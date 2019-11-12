import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';


/**
 * Pace Calculator calculating Pace/Speed
 */
class PaceCalculator extends StatefulWidget {
  @override
  _PaceCalculatorState createState() => _PaceCalculatorState();
}

class _PaceCalculatorState extends State<PaceCalculator> {

  // Text controller controlling the distance input
  TextEditingController _distanceInputController;

  // The number of hours selected
  int _hours;

  // The number of minutes selected
  int _minutes;

  // The number of seconds selected
  int _seconds;

  @override
  void initState() {
    super.initState();
    _distanceInputController = TextEditingController();
    _hours = 0;
    _minutes = 0;
    _seconds = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(15),
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            // The distane input field
            TextField(
              keyboardType: TextInputType.number,
              controller: _distanceInputController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                labelText: "Enter your distance",
                suffixText: 'km',
                filled: true,
                fillColor: Color.fromRGBO(237, 237, 237, 1),
                hintStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide.none),
              ),
            ),

            // The time selected field
            Container(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // Selector for hours
                  Expanded(
                    child: NumberPicker.integer(
                      initialValue: _hours,
                      minValue: 0,
                      maxValue: 99,
                      onChanged: (newValue) =>
                          setState(() => _hours = newValue),
                      infiniteLoop: true,
                    ),
                  ),
                  Text('h'),

                  // Selected minutes
                  Expanded(
                    child: NumberPicker.integer(
                      initialValue: _minutes,
                      minValue: 0,
                      maxValue: 59,
                      onChanged: (newValue) =>
                          setState(() => _minutes = newValue),
                      infiniteLoop: true,
                    ),
                  ),
                  Text('m'),

                  // Selected seconds
                  Expanded(
                    child: NumberPicker.integer(
                      initialValue: _seconds,
                      minValue: 0,
                      maxValue: 59,
                      onChanged: (newValue) =>
                          setState(() => _seconds = newValue),
                      infiniteLoop: true,
                    ),
                  ),
                  Text('s'),
                ],
              ),
            ),

            // Button for calculating the speed/pace
            RaisedButton(
              color: Colors.pink,
              onPressed: () {
                double distance =
                    double.tryParse(_distanceInputController.text) ?? -1;
                Widget content = Container(
                  height: 40,
                  margin: EdgeInsets.all(15),
                  child: Text("Invalid input"),
                );
                if (distance > 0) {
                  var pace =
                      (_hours * 3600 + _minutes * 60 + _seconds) / distance;
                  var speed =
                      distance / (_hours * 3600 + _minutes * 60 + _seconds);
                  content = Container(
                    margin: EdgeInsets.all(15),
                    height: 40,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text("Pace: ${pace.toStringAsPrecision(4)} s/km"),
                        Text("Speed: ${speed.toStringAsPrecision(4)} km/s"),
                      ],
                    ),
                  );
                }

                // Popup dialog for showing the speed/pace
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        contentPadding: EdgeInsets.all(0),
                        title: Text("Pace and speed"),
                        content: content,
                        actions: <Widget>[
                          FlatButton(
                            child: Text("Close"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    });
              },
              child: Text("Calculate"),
            ),
          ],
        ),
      ),
    );
  }
}
