import 'package:flutter/material.dart';
import 'package:lunch_app/providers/general_info.dart';
import 'package:lunch_app/providers/menus.dart';
import 'package:provider/provider.dart';

import 'food_category_filter.dart';

class FoodCategoryMenuFilter extends StatefulWidget {
  final String restaurantId;

  FoodCategoryMenuFilter(this.restaurantId);

  @override
  _FoodCategoryMenuFilterState createState() =>
      _FoodCategoryMenuFilterState(this.restaurantId);
}

class _FoodCategoryMenuFilterState extends State<FoodCategoryMenuFilter> {
  final String restaurantId;
  var _isInit = true;
  List<String> foodCategoryFilter = [];

  _FoodCategoryMenuFilterState(this.restaurantId);

  filterCategories(String id) {
    // TODO: share this logic with generalinfo
    if (this.foodCategoryFilter.contains(id)) {
      this.foodCategoryFilter.removeAt(this.foodCategoryFilter.indexOf(id));
    } else {
      this.foodCategoryFilter = [...this.foodCategoryFilter, id];
//      this.foodCategoryFilter.add(id);
    }
    Provider.of<Menus>(context).fetchAndSetMenus(
        this.foodCategoryFilter,
        this.restaurantId,
        Provider.of<GeneralInfo>(context).fromDate,
        Provider.of<GeneralInfo>(context).toDate
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      this.foodCategoryFilter = Provider
          .of<GeneralInfo>(context)
          .foodCategoryFilter;
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: FoodCategoryFilter(this.foodCategoryFilter, this.filterCategories),
    );
  }
}
