import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:running_diary/pages/GPSTracker/GPSTracker.dart';
import 'package:running_diary/pages/MusicPlayer/MusicPlayer.dart';
import 'package:running_diary/pages/PaceCalculator/PaceCalculator.dart';
import 'package:running_diary/pages/RunningLog/RunningHistory.dart';
import 'package:running_diary/pages/RunningLog/RunningLogPage.dart';

/**
 * The basement
 * Control the switchment between pages
 */
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

/**
 * The state manager of the basement
 */
class _MyHomePageState extends State<MyHomePage> {

  // The running log history
  RunningHistory _runningHistory;

  // The index of currently displayed tag, which is in Calculator/GPS/Log/MusicPlayer
  int _selectedIndex = 0;

  // The actual page/tag list
  List<Widget> _widgetOptions;

  /**
   * initialize the state before building the page
   */
  @override
  void initState() {
    super.initState();

    // Initialize the RunningHistory instance
    // It would read & load logs stored locally
    _runningHistory = RunningHistory();

    // Initialize tags
    _widgetOptions = <Widget>[
      PaceCalculator(),
      GPSTracker(_runningHistory),
      RunningLogPage(_runningHistory),
      MusicPlayer(),
    ];
  }

  /**
   *  Function called when one taps on a tag icon,
   * Notify the basement to switch displayed tag
   *  */
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  /**
   * Build the basement
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // The displayed tag
      body: Center(
        child: _widgetOptions[_selectedIndex],
      ),

      // Btm navbar allowing users to switch tags
      bottomNavigationBar: BottomNavigationBar(

        // The items in btm navbar
        items: const <BottomNavigationBarItem>[

          // Tag for calculator
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.calculator),
            title: Text('Pace Calculator'),
          ),

          // Tag for GPS
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            title: Text('GPS Tracking'),
          ),

          // Tag for Running log
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.history),
            title: Text('Running Log'),
          ),

          // Tag for Music Player
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.music),
            title: Text('Music Player'),
          ),
        ],

        // The index of currently displayed tag
        currentIndex: _selectedIndex,

        // The color of selected tag
        selectedItemColor: Colors.amber[800],

        // The color of unselected tag
        unselectedItemColor: Colors.pink,

        // Function called to update selected tag index
        onTap: _onItemTapped,
      ),
    );
  }
}
