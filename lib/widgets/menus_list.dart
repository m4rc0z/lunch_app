import 'package:flutter/material.dart';
import 'package:lunch_app/providers/menu.dart';
import 'package:provider/provider.dart';

import '../providers/menus.dart';

class MenusList extends StatelessWidget {
  final DateTime menuFilterDate;
  final String restaurantId;
  List<Menu> menusList = [];

  var textStyle = TextStyle(
      fontFamily: 'Avenir Next',
      color: Color.fromRGBO(61, 40, 15, 1),
      fontSize: 16
  );

  MenusList(this.restaurantId, this.menuFilterDate);

  @override
  Widget build(BuildContext context) {
    final menusData = Provider.of<Menus>(context).getMenuByDate(
        this.restaurantId, this.menuFilterDate);
    final menus = menusData;

    return Container(
        color: Colors.white,
        child: menus.length > 0
            ? ListView.builder(
          shrinkWrap: true,
          physics: new NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(10.0),
          itemCount: menus.length,
          itemBuilder: (ctx, i) =>
              ChangeNotifierProvider.value(
                value: menus[i],
                child: Container(child: Column(children: [
                  ConstrainedBox(
                    constraints: new BoxConstraints(
                      minHeight: 150.0,
                    ),
                    child: Card(
                        elevation: 0.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(20))),
                        color: Color.fromRGBO(242, 241, 240, 1),
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: IntrinsicHeight(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: IntrinsicHeight(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
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
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      child: menus[i].categories.length > 0 ?
                                      Chip(
                                        backgroundColor: Color.fromRGBO(
                                            94, 135, 142, 1),
                                        label: Text(menus[i].categories != null &&
                                            menus[i].categories.length > 0
                                            ? menus[i].categories[0].description
                                            .toUpperCase()
                                            : ' ',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Avenir Next',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 9
                                          ),
                                        ),
                                      ) : Container(),
                                    ),
                                    Container(
                                      child: menus[i].categories.length > 1 ?
                                      Chip(
                                        backgroundColor: Color.fromRGBO(
                                            94, 135, 142, 1),
                                        label: Text(menus[i].categories != null &&
                                            menus[i].categories.length > 1
                                            ? menus[i].categories[1].description
                                            : ' ',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Avenir Next',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ) : Container(),
                                    ),
                                    Container(
                                        child: Text(
                                          menus[i].price.toStringAsFixed(2) + ' €',
                                          style: TextStyle(
                                            color: Color.fromRGBO(
                                                61, 40, 15, 1),
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Avenir Next',
                                            fontSize: 14,
                                          ),
                                        )),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )),
                  ),
                ]),
                ),
              ),
        )
            : Container(child: Text(
            'Es bieten keine Restaurants Menüs an dem ausgewählten Tag an.'))
    );
  }

}
