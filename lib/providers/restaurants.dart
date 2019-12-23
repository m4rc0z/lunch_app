import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:lunch_app/models/http_exception.dart';

import '../env.dart';
import '../error_logger.dart';
import '../providers/restaurant.dart';
import 'address.dart';
import 'favorites.dart';
import 'menu.dart';

class Restaurants with ChangeNotifier {
  List<Restaurant> _items = [];
  Favorites _favoritesProvider;
  Position currLocation;

  Restaurants(this._favoritesProvider);

  void setProvider(Favorites favoritesProvider) {
    this._favoritesProvider = favoritesProvider;
  }

  void setCurrentLocation(Position curr) {
    this.currLocation = curr;
  }

  List<Restaurant> get items {
    return [..._items];
  }

  // TODO: maybe adapt to use also filtering of foodcategories?
  List<Restaurant> get favouriteItems {
    return [..._items.where((i) => this._favoritesProvider.getFavoriteStatus(i.id))];
  }

  bool _isFetching = false;

  bool get isFetching => _isFetching;

  // TODO: add possibility to filter with foodCategoryFilter
  void getRestaurantFavourites(List<String> foodCategoryFilter, DateTime fromDate,
      DateTime toDate) {
    this._items =  this._items.where((r) =>
      this._favoritesProvider.getFavoriteStatus(r.id) && r.menus.any((m) =>
      m.date.isAfter(fromDate) || m.date.isAtSameMomentAs(fromDate) &&
          m.date.isBefore(toDate) || m.date.isAtSameMomentAs(toDate))).toList()
        .where((r) => r.menus.any(
            (m) => m.categories.any(
              (c) => foodCategoryFilter.any(
                      (fcf) => fcf == c.id
              )
            )
        ));
    notifyListeners();
  }

  List<String> getRestaurantFavouritesCategories(DateTime fromDate,
      DateTime toDate) {
    List<String> categoryIds;
    this._items
        .where((r) =>
          this._favoritesProvider.getFavoriteStatus(r.id) && r.menus.any((m) =>
          m.date.isAfter(fromDate) || m.date.isAtSameMomentAs(fromDate) &&
              m.date.isBefore(toDate) || m.date.isAtSameMomentAs(toDate))
        )
        .toList()
        .map((r) => {
          r.menus.forEach((m) => {
            if (m.date.isAfter(fromDate) || m.date.isAtSameMomentAs(fromDate) &&
            m.date.isBefore(toDate) || m.date.isAtSameMomentAs(toDate)) {
              m.categories.forEach((c) {
                if (categoryIds.firstWhere((categoryId) => categoryId == c.id) == null) {
                  categoryIds.add(c.id);
                }
              })
            }
          })
        });
        return categoryIds;
  }

  Future<Position> getCurrentLocation() {
    try {
      final geoLocator = new Geolocator();
      return geoLocator.checkGeolocationPermissionStatus().then((status) {
        if (status != GeolocationStatus.denied && status != GeolocationStatus.disabled) {
          if (currLocation == null) {
            return geoLocator.getLastKnownPosition(
                desiredAccuracy: LocationAccuracy.best).then((Position curr) {
              if (curr == null) {
                return geoLocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
              } else {
                return Future(() => curr);
              }
            });
          }
          return new Future(() => this.currLocation);
        }
        return new Future(() => null);
      });
    } catch (err) {
      print(err);
      return new Future(() => null);
    }
  }

  Future<void> fetchAndSetRestaurants(List<String> foodCategoryFilter,
      DateTime fromDate, DateTime toDate) async {
    var c = new Completer();
    _isFetching = true;
    Geolocator geoLocator = Geolocator();
    var response;

    var url;
    if (foodCategoryFilter.length > 0) {
      url = environment['baseUrl'] + '/restaurants?categories=' +
          foodCategoryFilter.join(',') + '&fromDate=' +
          fromDate.toIso8601String() + '&toDate=' + toDate.toIso8601String();
    } else {
      url = environment['baseUrl'] + '/restaurants?fromDate=' +
          fromDate.toIso8601String() + '&toDate=' + toDate.toIso8601String();
    }
    try {
      Future.wait([
        getCurrentLocation(),
        http.get(url),
      ]).then((List<dynamic> values) async {
        try {
          this.currLocation = values[0];
          response = values[1];
          if (response.statusCode >= 400) {
            throw HttpException('Wrong Http Status answer ' + response.statusCode.toString());
          }

          final extractedData = json.decode(response.body) as List<dynamic>;
          final List<Restaurant> loadedRestaurant = [];
          await Future.wait(extractedData.map((restaurantData) async {
            final List<Menu> loadedMenus = [];
            restaurantData['menus'].forEach((menu) {
              loadedMenus.add(Menu(id: menu['_id'], date: DateTime.parse(menu['date'])));
            });
            loadedRestaurant.add(Restaurant(
                id: restaurantData['RID'],
                name: restaurantData['name'],
                menus: loadedMenus,
                address: Address(
                  addressLine: restaurantData['address'],
                  postalCode: restaurantData['postalCode'],
                  city: restaurantData['city'],
                ),
                imageUrl: restaurantData['imageUrl'],
                distance: this.currLocation != null
                    ? await getDistance(
                    geoLocator, this.currLocation, restaurantData['latitude'], restaurantData['longitude'])
                    : null
            ));
          }));

          // TODO: do only fetch restaurants in parent restaurant screen and filter only for screens based on favorite status
          _items = loadedRestaurant;
          if (this.currLocation != null) {
            sortRestaurantsByPosition();
          }
          _isFetching = false;
          c.complete(null);
          notifyListeners();
        } catch (error) {
          _isFetching = false;
          c.completeError(error);
          notifyListeners();
          if (error is! SocketException) {
            ErrorLogger.logError(error);
          }
        }
      })
      .catchError((error) {
        c.completeError(error);
      });
      return c.future;
    } catch (error) {
      _isFetching = false;
      c.completeError(error);
      notifyListeners();
      if (error is! SocketException) {
        ErrorLogger.logError(error);
      }
    }
  }

  void sortRestaurantsByPosition() async {
    _items.sort((a, b) {
      return a.distance.compareTo(b.distance);
    });

    notifyListeners(); // TODO: check how to optimize this
  }

  getDistance(Geolocator geoLocator, Position currentLocation, restaurantPositionLat, restaurantPositionLong) async {
    return await geoLocator.distanceBetween(
      currentLocation.latitude,
      currentLocation.longitude,
      restaurantPositionLat,
      restaurantPositionLong,
    );
  }

}