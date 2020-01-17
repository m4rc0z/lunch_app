import 'package:flutter/material.dart';
import 'package:lunch_app/providers/menu.dart';
import 'package:provider/provider.dart';

import '../providers/menus.dart';

class MenusList extends StatelessWidget {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  final DateTime menuFilterDate;
  final String restaurantId;
  List<Menu> menusList = [];

  var textStyle = TextStyle(
    fontFamily: 'Avenir Next',
      color: Color.fromRGBO(61, 40, 15, 1),
      fontSize: 16
  );

  MenusList(this.restaurantId, this.menuFilterDate);

  loadMenus(List<Menu> menus) {

      menusList.forEach((it) {
        _listKey.currentState.removeItem(
          0,
              (BuildContext context, Animation animation) => _buildItem(context, it, animation),
          duration: const Duration(milliseconds: 300),
        );
      });
      menusList.clear();
      menus.asMap().forEach((i, m) {
        menusList.add(m);
        _listKey.currentState.insertItem(i);
      });
  }

  @override
  Widget build(BuildContext context) {
    final menusData = Provider.of<Menus>(context).getMenuByDate(this.restaurantId, this.menuFilterDate);
    final menus = menusData;

    Future.delayed(Duration()).then((_) {
      loadMenus(menus);
    });

    return Container(
      color: Colors.white,
      child: menus.length > 0
        ? AnimatedList(
            key: _listKey,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(10.0),
            initialItemCount: 0,
            itemBuilder: (ctx, i, animation) => _buildItem(ctx, menusList[i], animation)
          )
        : Container(child: Text('Es bieten keine Restaurants Menüs an dem ausgewählten Tag an.'))
    );
  }

  Widget _buildItem(BuildContext ctx, Menu item, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      axis: Axis.vertical,
      child: Container(child: Column(children: [
        ConstrainedBox(
          constraints: new BoxConstraints(
            minHeight: 150.0,
          ),
          child: Card(
              elevation: 0.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(item.courses[0].description != null
                                  ? item.courses[0].description
                                  : ' ',
                                style: textStyle,
                              ),
                              Text(item.courses[1].description != null
                                  ? item.courses[1].description
                                  : ' ',
                                style: textStyle,
                              ),
                              Text(item.courses[2].description != null
                                  ? item.courses[2].description
                                  : ' ',
                                style: textStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: item.categories.length > 0 ?
                            Chip(
                              backgroundColor: Color.fromRGBO(94, 135, 142, 1),
                              label: Text(item.categories != null && item.categories.length > 0
                                  ? item.categories[0].description.toUpperCase()
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
                            child: item.categories.length > 1 ?
                            Chip(
                              backgroundColor: Color.fromRGBO(94, 135, 142, 1),
                              label: Text(item.categories != null && item.categories.length > 1
                                  ? item.categories[1].description
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
                                item.price.toStringAsFixed(2) + ' €',
                                style: TextStyle(
                                  color: Color.fromRGBO(61, 40, 15, 1),
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
    );
  }
}
