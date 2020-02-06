import 'package:flutter/material.dart';
import 'package:lunch_app/widgets/restaurantCategoryFilter.dart';

import 'foodCategoryRestaurantFilter.dart';

class RestaurantFilter extends StatefulWidget {
  final List<String> restaurantCategoryFilter;
  final List<String> foodCategoryFilter;
  final void Function(List<String>, List<String>) activateFilter;

  RestaurantFilter(this.restaurantCategoryFilter, this.foodCategoryFilter, this.activateFilter);

  @override
  _RestaurantFilterState createState() => _RestaurantFilterState();
}

class _RestaurantFilterState extends State<RestaurantFilter> {
  List<String> _foodCategoryFilter = [];
  List<String> _restaurantCategoryFilter = [];

  @override
  void initState() {
    super.initState();
    this._foodCategoryFilter = this.widget.foodCategoryFilter;
    this._restaurantCategoryFilter = this.widget.restaurantCategoryFilter;
  }

  filterRestaurantCategory(String categoryId) {
    toggleRestaurantCategory(categoryId);
  }

  filterRestaurantFoodCategory(String categoryId) {
    toggleRestaurantFoodCategory(categoryId);
  }

  toggleRestaurantFoodCategory(String foodCategoryId) {
    var filter = _foodCategoryFilter;
    handleToggle(filter, foodCategoryId);
    setState(() {
      _foodCategoryFilter = filter;
    });
  }

  toggleRestaurantCategory(String foodCategoryId) {
    var filter = _restaurantCategoryFilter;
    handleToggle(filter, foodCategoryId);
    setState(() {
      _restaurantCategoryFilter = filter;
    });
  }

  handleToggle(List<String> filter, String foodCategoryId) {
    if (filter.contains(foodCategoryId)) {
      filter.remove(foodCategoryId);
    } else {
      filter.add(foodCategoryId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: IntrinsicHeight(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                          padding: const EdgeInsets.only(left: 32.0),
                          child: Text(
                            'RESTAURANT FILTER',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromRGBO(94, 135, 142, 1),
                              fontSize: 18,
                            ),
                          )),
                    ),
                    new IconButton(
                      icon: new Icon(
                        Icons.close,
                        color: Colors.black,
                        size: 35,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Container(
                  child: FoodCategoryRestaurantFilter(filterRestaurantFoodCategory, this._foodCategoryFilter),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Container(
                  child: RestaurantCategoryFilter(filterRestaurantCategory, this._restaurantCategoryFilter),
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 17),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(5.0),
                    ),
                    textColor: Colors.white,
                    child: Text('BESTÄTIGEN'),
                    color: Color.fromRGBO(94, 135, 142, 1),
                    onPressed: () async {
                      widget.activateFilter(this._foodCategoryFilter, this._restaurantCategoryFilter);
                    },
                  ),
                ),
              )
            ],
          ),
        ));
  }
}