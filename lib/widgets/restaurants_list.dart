import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lunch_app/widgets/favorite_button.dart';
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
      child: restaurants.length > 0
          ? ListView.builder(
        physics: new NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.all(10.0),
        itemCount: restaurants.length,
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: restaurants[i],
          child: Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Container(
                width: double.infinity,
                child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Stack(
                      fit: StackFit.passthrough,
                      children: <Widget>[
                        Container(
                          height: 170,
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
                                  borderRadius: new BorderRadius.circular(5.0),
                                  child: restaurants[i].imageUrl != null
                                      ? CachedNetworkImage(
                                        imageUrl: restaurants[i].imageUrl,
                                        placeholder: (context, url) => Container(
                                          color: Colors.transparent,
                                          child: FittedBox(fit: BoxFit.scaleDown, child: CircularProgressIndicator())
                                        ),
                                        errorWidget: (context, url, error) => Container(color: Color.fromRGBO(189, 187, 173, 1)),
                                        fit: BoxFit.fitWidth,
                                      )
                                      : Container(color: Color.fromRGBO(189, 187, 173, 1))
                            ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 4,
                          top: 4,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                            child: FavoriteButton(restaurants[i].id),
                          ),
                        )
                      ],
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 2.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Text(
                              restaurants[i].name != null
                                  ? restaurants[i].name.toUpperCase()
                                  : '',
                              style: TextStyle(
                                  letterSpacing: 0.6,
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.location_on,
                                color: Colors.black.withOpacity(0.5),
                                size: 17.0,
                              ),
                              SizedBox(width: 5.0,),
                              Text(
                                restaurants[i].distance != null
                                    ? (restaurants[i].distance / 1000.00).toStringAsFixed(1).toUpperCase() + ' KM'
                                    : '',
                                style: TextStyle(
                                  letterSpacing: 0.6,
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.restaurant_menu,
                                color: Colors.black.withOpacity(0.5),
                                size: 17.0,
                              ),
                              SizedBox(width: 5.0,),
                              Text(
                                restaurants[i].categories != null
                                    && restaurants[i].categories.length > 0
                                    && restaurants[i].categories[0].description != null
                                    ? restaurants[i].categories[0].description.toUpperCase()
                                    : '',
                                style: TextStyle(
                                  letterSpacing: 0.6,
                                  color: Colors.black.withOpacity(0.5),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      )
      : Container(child: Text(this.onlyFavourites
          ? 'Es bieten keine deiner Favoriten Restaurants Menüs an dem ausgewählten Tag an.'
          : 'Es bieten keine Restaurants Menüs an dem ausgewählten Tag an.'))
    );
  }

  navigateToRestaurant(BuildContext ctx, String id) {
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
