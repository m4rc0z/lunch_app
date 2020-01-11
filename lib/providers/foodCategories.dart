import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../env.dart';
import '../error_logger.dart';
import 'foodCategory.dart';

class FoodCategories with ChangeNotifier {
  List<FoodCategory> _restaurantItems = [];

  List<FoodCategory> get restaurantItems {
    return [..._restaurantItems];
  }

  // TODO: revert this part and do it like for non favourites (fetch of restaurants based on date
  // TODO: do this in parent (fetch with same function) then in favourite class filter the fetched items based on favourite status)
  // TODO: do the filter of favourites like this -> iterate over favourite restaurant ids and get these items out of the fetched items
  //  this has a better performance then the other way around
  Future<void> fetchAndSetRestaurantCategories(DateTime fromDate,
      DateTime toDate) async {
    var c = new Completer();
    var url = environment['baseUrl'] + '/categories?fromDate=' +
        fromDate.toIso8601String() + '&toDate=' + toDate.toIso8601String();
    try {
      _restaurantItems = await prepareCategories(url)
      .catchError((error) {
        throw(error);
      });
      c.complete();
      notifyListeners();
      return c.future;
    } catch (error) {
      c.completeError(error);
      if (error is! SocketException) {
        ErrorLogger.logError(error);
      }
    }
  }

  Future<List<FoodCategory>> prepareCategories(String url) {
    final List<FoodCategory> loadedFoodCategories = [];
    var c = new Completer<List<FoodCategory>>();
    try {
      http.get(url)
          .then((response) {
        final extractedData = json.decode(response.body) as List<dynamic>;
        extractedData.forEach((foodCategoryData) {
          loadedFoodCategories.add(FoodCategory(
            id: foodCategoryData['_id'],
            description: foodCategoryData['description'],
          ));
        });
        c.complete(loadedFoodCategories);
      }).catchError((error) {
        c.completeError(error);
      });
      return c.future;
    } catch (error) {
      c.completeError(error);
      if (error is! SocketException) {
        ErrorLogger.logError(error);
      }
      return c.future;
    }

  }
}