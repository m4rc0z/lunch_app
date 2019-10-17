import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeekDayNavigationBar extends StatelessWidget {
  final List<DateTime> weekDays;
  final int currentIndex;
  final void Function(int) navigateTo;

  WeekDayNavigationBar(this.weekDays, this.currentIndex, this.navigateTo);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Colors.white,
      ),
      child: Container(
        child: BottomNavigationBar(
          elevation: 0.0,
          currentIndex: this.currentIndex,
          onTap: (newPage) {
            this.navigateTo(newPage);
          },
          items: [
            ...this.weekDays.map((weekDay) {
              return BottomNavigationBarItem(
                title: Container(),
                icon: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(children: <Widget>[
                    Center(
                      child: Text(
                        DateFormat('EEEE').format(weekDay).substring(0, 2),
                        style: TextStyle(
                            color: Color.fromRGBO(189, 187, 173, 1),
                            fontSize: 15),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(245, 241, 227, 1),
                        shape: BoxShape.circle,
                      ),
                      width: 40,
                      height: 40,
                      child: Center(
                        child: Text(weekDay.day.toString(),
                            style: TextStyle(
                                color: Color.fromRGBO(189, 187, 173, 1),
                                fontSize: 15),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ]),
                ),
                activeIcon: Column(children: <Widget>[
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Text(
                        DateFormat('EEEE').format(weekDay).substring(0, 2),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 15),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(27, 154, 170, 1),
                      shape: BoxShape.circle,
                    ),
                    width: 50,
                    height: 50,
                    child: Center(
                      child: Text(weekDay.day.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 15),
                          textAlign: TextAlign.center),
                    ),
                  ),
                ]),
              );
            }),
          ],
        ),
      ),
    );
  }
}
