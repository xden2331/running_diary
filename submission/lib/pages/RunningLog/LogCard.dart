import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/**
 * Styly log card
 */
class LogCard extends StatelessWidget {
  String _date;
  double _pace;
  double _speed;
  int _seconds;
  double _distance;

  LogCard(this._date, this._pace, this._speed, this._seconds, this._distance);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      color: Colors.blue,
      child: Card(
        child: Stack(
          children: <Widget>[

            // The grey header
            Container(
              color: Colors.grey,
              height: 25,
              width: double.infinity,
            ),

            // The datetime in grey header
            Positioned(
              left: 20,
              top: 2.5,
              child: Row(
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.clock,
                    size: 15,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(_date),
                ],
              ),
            ),

            // The running duration in grey header
            Positioned(
              top: 2.5,
              right: 20,
              child: Text("Duration: ${_seconds} s"),
            ),

            // The distance you run
            Positioned(
              top: 40,
              left: 20,
              child: Text("You runned: \n"+_distance.toStringAsPrecision(3) + " m"),
            ),

            // The pace
            Positioned(
              top: 40,
              left: 100,
              child: Text("Your Pace: \n"+_pace.toStringAsPrecision(3) + " s/m"),
            ),

            // The speed
            Positioned(
              top: 40,
              left: 180,
              child: Text("Your Speed: \n"+_speed.toStringAsPrecision(3) + " m/s"),
            ),
          ],
        ),
      ),
    );
  }
}
