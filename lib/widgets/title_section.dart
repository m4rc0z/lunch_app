import 'package:flutter/material.dart';

class TitleSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Icon(
              Icons.location_on,
              size: 19.0,
              color: Color.fromRGBO(94, 135, 142, 1),
            ),
          ),
          SizedBox(
            width: 5.0,
          ),
          Text(
            'BAD SÄCKINGEN',
            style: TextStyle(
              fontSize: 16.0,
              color: Color.fromRGBO(94, 135, 142, 1),
              letterSpacing: 0.6,
              fontWeight: FontWeight.w300,
            ),
          )
        ],
      ),
    );
  }
}
