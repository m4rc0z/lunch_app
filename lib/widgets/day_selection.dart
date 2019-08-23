import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../date_util.dart';

class DaySelection extends StatefulWidget {
  @override
  _DaySelectionState createState() => _DaySelectionState();
}

class _DaySelectionState extends State<DaySelection> {
  var today = DateTime.now();
  List<DateTime>weekDays = [];

  _DaySelectionState();

  void initState() {
    super.initState();
  }

  void didChangeDependencies() {
    this.weekDays = new DateUtil().getWeekDaysForDate(today);
    this.today = this.weekDays.firstWhere((weekDay) {
      return weekDay.day == today.day && weekDay.month == today.month && weekDay.year == today.year;
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 50, horizontal: 0),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ...this.weekDays.map((weekDay) {
                return Column(children: <Widget>[
                  Center(
                    child: Text(
                      DateFormat('EEEE').format(weekDay).substring(0, 2),
                      style: TextStyle(color: Colors.black, fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                    decoration: BoxDecoration(
                      color: weekDay != today
                          ? Color.fromARGB(500, 216, 216, 216)
                          : Colors.black,
                      shape: BoxShape.circle,
                    ),
                    width: 40,
                    height: 40,
                    child: Center(
                      child: Text(weekDay.day.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 15),
                          textAlign: TextAlign.center),
                    ),
                  ),
                ]);
              })
            ],
          ),
        ]),
      ),
    );
  }
}
