import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lunch_app/providers/favorites.dart';
import 'package:lunch_app/providers/general_info.dart';
import 'package:provider/provider.dart';

import '../providers/restaurants.dart';
import '../screens/restaurant_detail_screen.dart';

class RestaurantsList extends StatelessWidget {
  final int currentIndex;
  final Position currentPosition;
  final bool onlyFavourites;

  RestaurantsList(this.currentIndex, this.currentPosition, this.onlyFavourites);

  @override
  Widget build(BuildContext context) {
    final restaurantsData = Provider.of<Restaurants>(context);
    final restaurants = this.onlyFavourites ? restaurantsData.favouriteItems : restaurantsData.items;
    return Container(
      color: Colors.white,
      child: ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: restaurants.length,
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: restaurants[i],
          child: Column(children: [
            Container(
              width: double.infinity,
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Stack(
                    fit: StackFit.passthrough,
                    children: <Widget>[
                      Container(
                        height: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Hero(
                          transitionOnUserGestures: true,
                          tag: 'restaurantHero' + restaurants[i].id,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => navigateToRestaurant(
                                  context, restaurants[i].id),
                              child: ClipRRect(
                                borderRadius: new BorderRadius.circular(20.0),
                                child: restaurants[i].imageUrl != null
                                    ? ColorFiltered(
                                        colorFilter: ColorFilter.mode(
                                            Colors.black.withOpacity(0.4),
                                            BlendMode.darken),
                                        child: CachedNetworkImage(
                                          imageUrl: restaurants[i].imageUrl,
                                          placeholder: (context, url) => Container(
                                            color: Colors.transparent,
                                            child: FittedBox(fit: BoxFit.scaleDown, child: CircularProgressIndicator())
                                          ),
                                          errorWidget: (context, url, error) => Container(color: Color.fromRGBO(189, 187, 173, 1)),
                                          fit: BoxFit.fitWidth,
                                        )
                                      )
                                    : Container(color: Color.fromRGBO(189, 187, 173, 1))
                          ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Text(
                                restaurants[i].name != null
                                    ? restaurants[i].name
                                    : '',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            Container(
                              child: Text(
                                restaurants[i].distance != null
                                    ? (restaurants[i].distance / 1000.00).toStringAsFixed(1) + 'km'
                                    : '',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                          child: Material(
                            color: Colors.transparent,
                            shadowColor: Colors.transparent,
                            elevation: 4.0,
                            shape: CircleBorder(),
                            clipBehavior: Clip.hardEdge,
                            child: InkWell(
                              child: new IconButton(
                                icon: new Icon(
                                  Provider.of<Favorites>(context)
                                          .getFavoriteStatus(restaurants[i].id)
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: Colors.white,
                                  size: 35,
                                ),
                                onPressed: () => Provider.of<Favorites>(context)
                                    .toggleFavorite(restaurants[i].id),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )),
            )
          ]),
        ),
      ),
    );
  }

  navigateToRestaurant(BuildContext ctx, String id) {
    Provider.of<GeneralInfo>(ctx)
        .initMenuFoodCategoryBasedOnRestaurantFoodCategory();
    Navigator.of(ctx)
        .push(SlideBottomRoute(page: RestaurantDetailScreen(id, currentIndex)));
  }

  getDistance(currentPosition, restaurantPosition) async {
    double distanceInMeters = await Geolocator().distanceBetween(
      currentPosition.latitude,
      currentPosition.longitude,
      restaurantPosition.latitude,
      restaurantPosition.longitude,
    );

    return distanceInMeters;
  }
}

class SlideBottomRoute extends PageRouteBuilder {
  final Widget page;

  SlideBottomRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
}
