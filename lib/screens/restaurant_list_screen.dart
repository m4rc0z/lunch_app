import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/day_selection.dart';
import '../widgets/restaurants_list.dart';
import '../providers/restaurants.dart';

class RestaurantsListScreen extends StatefulWidget {
  @override
  _RestaurantsListScreenState createState() => _RestaurantsListScreenState();
}

class _RestaurantsListScreenState extends State<RestaurantsListScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Restaurants>(context).fetchAndSetRestaurants().then((_) {
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
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200),
        child: AppBar(
          flexibleSpace: DaySelection(),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RestaurantsList(),
    );
  }
}
