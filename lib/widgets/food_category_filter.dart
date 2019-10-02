import 'package:flutter/material.dart';
import 'package:lunch_app/providers/foodCategories.dart';
import 'package:provider/provider.dart';

class FoodCategoryFilter extends StatelessWidget {
  final List<String> foodCategoryFilter;
  final void Function(String) filterChanged;

  FoodCategoryFilter(this.foodCategoryFilter, this.filterChanged);

  @override
  Widget build(BuildContext context) {
    final foodCategoryData = Provider.of<FoodCategories>(context);
    final foodCategories = foodCategoryData.items;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container( // TODO: maybe use chip istead of own container
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Filter',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.black),
                ),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7.0),
            child: Row(children: <Widget>[
              ...foodCategories.map((fc) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3.0),
                  child: Container(
                    height: 30,
                    child: MaterialButton(
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                      color: this.foodCategoryFilter.contains(fc.id)
                          ? Color.fromRGBO(27, 154, 170, 1)
                          : Color.fromRGBO(245, 241, 227, 1),
                      child: Text(fc.description, style: TextStyle(
                        color: this.foodCategoryFilter.contains(fc.id)
                          ? Colors.white
                          : Color.fromRGBO(189, 187, 173, 1),
                        fontWeight: FontWeight.bold
                      )),
                      onPressed: () => filterCategory(fc.id),
                    ),
                  ),
                );
              })
            ]),
          ),
        ],
      ),
    );
  }

  filterCategory(String id) {
      this.filterChanged(id);
  }
}
