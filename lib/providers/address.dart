import 'package:flutter/foundation.dart';

class Address with ChangeNotifier {
  final String addressLine;
  final String postalCode;
  final String city;

  Address({
    @required this.addressLine,
    @required this.postalCode,
    @required this.city,
  });

  @override
  String toString() {
    return this.addressLine + ' ' + this.postalCode + ' ' + this.city;
  }
}
