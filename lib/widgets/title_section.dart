import 'package:flutter/material.dart';

class TitleSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.location_on,
              color: Color.fromRGBO(94, 135, 142, 1),
            ),
            Text(
              'Bad Säckingen',
              style: TextStyle(color: Color.fromRGBO(94, 135, 142, 1)),
            )
          ],
        ),
      ),
      Divider(
        color: Color.fromRGBO(242, 241, 240, 1),
      )
    ]);
  }
}
