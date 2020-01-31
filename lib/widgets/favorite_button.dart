import 'package:flutter/material.dart';
import 'package:lunch_app/providers/favorites.dart';
import 'package:provider/provider.dart';

class FavoriteButton extends StatelessWidget {
  final String restaurantId;

  FavoriteButton(this.restaurantId);

  @override
  Widget build(BuildContext context) {
    return Container(child: Material(
      color: Colors.white,
      shadowColor: Colors.black.withOpacity(0.8),
      elevation: 4.0,
      shape: CircleBorder(),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        child: new IconButton(
          icon: new Icon(
            Provider.of<Favorites>(context)
                .getFavoriteStatus(restaurantId)
                ? Icons.favorite
                : Icons.favorite_border,
            color: Provider.of<Favorites>(context)
                .getFavoriteStatus(restaurantId)
                ? Color.fromRGBO(94, 135, 142, 1)
                : Colors.black,
            size: 33,
          ),
          onPressed: () => Provider.of<Favorites>(context)
              .toggleFavorite(restaurantId),
        ),
      ),
    ));
  }
}
