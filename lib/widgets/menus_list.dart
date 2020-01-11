import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/menus.dart';

class MenusList extends StatelessWidget {
  final DateTime menuFilterDate;
  final String restaurantId;
  var textStyle = TextStyle(color: Colors.white, fontSize: 16);

  MenusList(this.restaurantId, this.menuFilterDate);

  @override
  Widget build(BuildContext context) {
    final menusData = Provider.of<Menus>(context).getMenuByDate(this.restaurantId, this.menuFilterDate);
    final menus = menusData;
    return Container(
      color: Colors.white,
      child: menus.length > 0
          ? ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: menus.length,
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: menus[i],
          child: Column(children: [
            ConstrainedBox(
              constraints: new BoxConstraints(
                minHeight: 150.0,
              ),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                  color: Color.fromRGBO(51, 50, 47, 1),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IntrinsicHeight(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(menus[i].courses[0].description != null
                                    ? menus[i].courses[0].description
                                    : ' ',
                                  style: textStyle,
                                ),
                                Text(menus[i].courses[1].description != null
                                    ? menus[i].courses[1].description
                                    : ' ',
                                  style: textStyle,
                                ),
                                Text(menus[i].courses[2].description != null
                                    ? menus[i].courses[2].description
                                    : ' ',
                                  style: textStyle,
                                ),
                              ],
              ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: menus[i].categories.length > 0 ?
                                Chip(
                                  backgroundColor: Color.fromRGBO(94, 135, 142, 1),
                                  label: Text(menus[i].categories != null && menus[i].categories.length > 0
                                      ? menus[i].categories[0].description
                                      : ' ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ) : Container(),
                              ),
                              Container(
                                child: menus[i].categories.length > 1 ?
                                Chip(
                                  backgroundColor: Color.fromRGBO(94, 135, 142, 1),
                                  label: Text(menus[i].categories != null && menus[i].categories.length > 1
                                      ? menus[i].categories[1].description
                                      : ' ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ) : Container(),
                              ),
                              Container(
                                  child: Text(
                                      menus[i].price.toStringAsFixed(2) + ' €',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                      ),
                                  )),
                            ],
                          ),
                        ),
                      )
                    ],
                  )),
            ),
          ]),
        ),
      )
          : Container(child: Text('Es bieten keine Restaurants Menüs an dem ausgewählten Tag an.'))
    );
  }
}
