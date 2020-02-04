import 'package:flutter/material.dart';
import 'package:lunch_app/providers/foodCategory.dart';

class FoodCategoryFilter extends StatelessWidget {
  final List<String> foodCategoryFilter;
  final List<FoodCategory> foodCategories;
  final void Function(String) filterChanged;
  final String filterName;

  FoodCategoryFilter(this.foodCategories, this.foodCategoryFilter,
      this.filterChanged, this.filterName);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: this.foodCategories.length > 0
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                      // TODO: maybe use chip istead of own container
                      child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      this.filterName,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color.fromRGBO(61, 40, 15, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                        letterSpacing: 0.6,
                      ),
                    ),
                  )),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 7.0),
                    child: Wrap(
                      alignment: WrapAlignment.spaceEvenly,
                        children: <Widget>[
                      ...this.foodCategories.map((fc) {
                        return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 3.0),
                            child: ConstrainedBox(
                              constraints: new BoxConstraints(
                                minHeight: 30.0,
                                minWidth: 110.0,
                              ),
                              child: Container(
                                  height: 50,
                                  child: this.foodCategoryFilter.contains(fc.id)
                                      ? MaterialButton(
                                          shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(10.0),
                                          ),
                                          color:
                                              Color.fromRGBO(94, 135, 142, 1),
                                          child: Text(fc.description.toUpperCase(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold)),
                                          onPressed: () =>
                                              filterCategory(fc.id),
                                        )
                                      : OutlineButton(
                                          shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(10.0),
                                          ),
                                          color: Colors.white,
                                          child: Text(fc.description.toUpperCase(),
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  color: Colors.black.withOpacity(0.3),
                                                  fontWeight: FontWeight.bold)),
                                          onPressed: () =>
                                              filterCategory(fc.id),
                                        )),
                            ));
                      })
                    ]),
                  ),
                ],
              )
            : Container());
  }

  filterCategory(String id) {
    this.filterChanged(id);
  }
}
