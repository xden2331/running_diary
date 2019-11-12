import 'package:flutter/material.dart';
import 'package:running_diary/pages/RunningLog/BarChart.dart';
import 'package:running_diary/pages/RunningLog/LogCard.dart';

/**
 * A widget for placing the log list
 */
class LogPlaceholder extends StatefulWidget {
  // List of logs
  List _history;

  LogPlaceholder(List _history) {
    if (_history == null) {
      this._history = [];
    } else {
      this._history = _history;
    }
  }

  @override
  _LogPlaceholderState createState() => _LogPlaceholderState();
}

class _LogPlaceholderState extends State<LogPlaceholder> {
  List _history;

  @override
  void initState() {
    _history = widget._history;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity,
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // The bar chart
          SizedBox(
            width: double.infinity,
            height: 100,
            child: Container(
              child: BarChart(_history),
            ),
          ),

          // The log list
          Container(
            height: height - 236,
            child: ListView.builder(
              itemCount: _history.length,
              itemBuilder: (context, index) {
                // The current log
                var log = _history[index];

                // The information of the log
                DateTime datetime = DateTime.parse(log['dateTime']);
                String date = "${datetime.year}-${datetime.month}-${datetime.day} ${datetime.hour}:${datetime.minute}:${datetime.second}";
                double pace = log['seconds'] / log['distance'];
                double speed = log['distance'] / log['seconds'];

                return LogCard(date, pace, speed, log['seconds'], log['distance']);
                // Return a card object
                // return Card(
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: <Widget>[
                //       Text("Date: ${date}", style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),),
                //       Text(
                //           "Distance: ${(log['distance']).toStringAsPrecision(3)} m\n"+
                //           "Seconds: ${log['seconds']}\n"+
                //           "Pace: ${pace.toStringAsPrecision(3)}\n"+
                //           "Speed: ${speed.toStringAsPrecision(3)}\n"
                //           ),
                //     ],
                //   ),
                // );
              },
            ),
          )
        ],
      ),
    );
  }
}
