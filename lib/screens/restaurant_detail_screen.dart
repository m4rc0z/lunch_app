import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/menus_list.dart';
import '../providers/menus.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final String id;

  RestaurantDetailScreen(this.id);

  @override
  _RestaurantDetailScreenState createState() =>
      _RestaurantDetailScreenState(this.id);
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  var _isInit = true;
  var _isLoading = false;
  var menus;

  final String restaurantId;

  _RestaurantDetailScreenState(this.restaurantId);

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    print('test');
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Menus>(context).fetchAndSetMenus(this.restaurantId).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final loadedMenus = Provider.of<Menus>(
      context
    );
    return Scaffold(
        appBar: AppBar(
          title: Text('Lunch Menu'),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : MenusList(),
      );
  }
}
