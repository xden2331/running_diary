import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:running_diary/pages/RunningLog/LogPlaceholder.dart';
import 'package:running_diary/pages/RunningLog/RunningHistory.dart';

/**
 * The Widget for displaying the log history
 */
class RunningLogPage extends StatefulWidget {
  RunningHistory _runningHistory;

  RunningLogPage(this._runningHistory);

  @override
  _RunningLogPageState createState() => _RunningLogPageState();
}

class _RunningLogPageState extends State<RunningLogPage> {
  // RunningHistory instance from the basement
  RunningHistory _runningHistory;

  // Read logs from local storage
  Future<List> _readLogs() async {
    return _runningHistory.log;
  }

  @override
  void initState() {
    super.initState();
    _runningHistory = widget._runningHistory;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Running Log"),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: _readLogs(),
          builder: (context, snap) {
            // Check if the async is finished and has data
            if (snap.connectionState != ConnectionState.done || !snap.hasData) {
              return Center(
                child: Text("Fetching data"),
              );
            }
            List _logs = snap.data;
            // Return the placeholder widget
            return LogPlaceholder(_logs);
          },
        ),
      ),
    );
  }
}
