import 'package:flutter/foundation.dart';

import 'address.dart';
import 'menu.dart';

class Restaurant with ChangeNotifier {
  final String id;
  final String name;
  final List<Menu> menus;
  final Address address;
  final double distance;
  final String openingTimesLine1;
  final String openingTimesLine2;
  final String imageUrl;
  final String mapImageUrl;
  // TODO: resolve warnings when restaurant call happens and menus get initialzed not fully -> check if rest endpoint only returns menu id

  Restaurant({
    @required this.id,
    @required this.name,
    @required this.menus,
    @required this.address,
    @required this.distance,
    @required this.openingTimesLine1,
    @required this.openingTimesLine2,
    @required this.imageUrl,
    @required this.mapImageUrl,
  });

}
