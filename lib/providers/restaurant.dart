import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

import 'address.dart';
import 'menu.dart';

class Restaurant with ChangeNotifier {
  final String id;
  final String name;
  final List<Menu> menus;
  final Address address;
  final Position addressPosition;
  final double distance;
  final String imageUrl;
  // TODO: resolve warnings when restaurant call happens and menus get initialzed not fully -> check if rest endpoint only returns menu id

  Restaurant({
    @required this.id,
    @required this.name,
    @required this.menus,
    @required this.address,
    @required this.addressPosition,
    @required this.distance,
    @required this.imageUrl,
  });

}
