import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:running_diary/pages/RunningLog/RunningHistory.dart';


/**
 * Widget for GPS Tracker
 */
class GPSTracker extends StatefulWidget {

  // Used for saving running log
  RunningHistory _runningHistory;

  @override
  _GPSTrackerState createState() => _GPSTrackerState();

  /**
   * Constructor, the RunningHistory instance is passed by the basement
   */
  GPSTracker(this._runningHistory);
}

/**
 * The state manager of GPSTracker
 */
class _GPSTrackerState extends State<GPSTracker> {

  // Used to controll the map behaviour
  GoogleMapController _mapController;

  // Used to store the current position
  Position _currentPosition;

  // Used to fetch coordinates and calculate distance
  Geolocator _geolocator;

  // Used to store the parameters of the geolocator
  // Such as accuracy, the minimal distance change to notify listener.
  var _locationOptions;

  // Used with googleMap to decide the display coor on the map
  LatLng _center;

  // Used to store the start pos of a running log
  Position _startPos;

  // Used to store a list of Lat and Lng
  // This is a list of points in a route
  // Then it is further processed to draw the route/direction on the map
  List<LatLng> _latlng;

  // The set of the '_latlng', it is used to draw the route/direction on the map
  Set<Polyline> _polyline;

  // Indicate whether if a running starts or not
  bool _isStarted;

  // Record the start time of a running
  DateTime _startTime;

  // Record the end time of a running
  DateTime _endTime;

  // running history inherited from the parent
  RunningHistory _runningHistory;

  /**
   * Call when a google map is created
   * _mapController is updated so that we can use it
   * to control the behaviour of the map
   */
  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  /**
   * Initialize all state before building the widget
   */
  @override
  void initState() {
    super.initState();

    // Set the running histroy
    _runningHistory = widget._runningHistory;

    // Initialize the route
    _polyline = {};

    // Initialize the list of route points
    _latlng = List();

    // Initially, no running starts
    _isStarted = false;

    // Initialize the geolocator
    _geolocator = Geolocator();

    // Initialize the param
    _locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);

    // Add listener to the change of location
    StreamSubscription<Position> positionStream = _geolocator
        .getPositionStream(_locationOptions)
        .listen((Position position) {
      
      // If currently no running starts, simply return
      if (!_isStarted) {
        return;
      }

      // Otherwise
      setState(() {

        // Get the current LatLng for drawying route
        LatLng latlng = LatLng(position.latitude, position.longitude);

        // Add it into the route point list
        _latlng.add(latlng);

        // Add the update point list to the route set
        _polyline.add(Polyline(
            polylineId: PolylineId(latlng.toString()),
            visible: true,
            color: Colors.blue,
            points: _latlng));
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  /**
   * Called to fetch currentPosition
   * For displaying user position at the center
   */
  Future<LatLng> _fetchCurrentPosition() async {
    _currentPosition = await Geolocator().getCurrentPosition();
    double lat = _currentPosition.latitude;
    double lng = _currentPosition.longitude;
    _center = LatLng(lat, lng);
    var dir = await getApplicationDocumentsDirectory();
    return _center;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // Based on the result of the async call, display different content
      body: FutureBuilder(

        // The async call
        future: _fetchCurrentPosition(),

        // Builder for building content
        builder: (context, snap) {

          // If the async call is not finished || no data return
          if (snap.connectionState != ConnectionState.done || !snap.hasData) {

            // Telling users we are fetching data
            return Center(child: Text("Fetching data"));
          }

          // The information is fetched, then display the GoogleMap
          // The return data is the center position
          return GoogleMap(

            // Define the center point, and the zoom level
            initialCameraPosition: CameraPosition(
              target: snap.data,
              zoom: 17,
            ),

            // Allow user to center themself using a built-in btn
            myLocationEnabled: true,

            // If starts, draw the route, else drow nothing
            polylines: (_isStarted ? _polyline : {}),

            // Call to set controller to control the map
            onMapCreated: _onMapCreated,
          );
        },
      ),

      // Rounded button at bottom right
      // ALlow user to start/stop a running
      floatingActionButton: IconButton(
        icon: (_isStarted
            ? Icon(FontAwesomeIcons.pause)
            : Icon(FontAwesomeIcons.play)),
        onPressed: _onBtnPressed,
      ),
    );
  }

  /**
   * Function called when the start/stop button is pressed
   */
  void _onBtnPressed() {
    // Switch the state of isStarted
    _isStarted = !_isStarted;

    // if starts a running
    if (_isStarted) {
      _geolocator.getCurrentPosition().then((pos) {
        // Store the start position
        _startPos = pos;

        // Store the star time
        _startTime = DateTime.now();
      });
    } 
    // If stops a running
    else {
      _geolocator.getCurrentPosition().then((endPos) {

        // Fetch the end position
        endPos = endPos;

        // Calculate the distance
        _geolocator
            .distanceBetween(_startPos.latitude, _startPos.longitude,
                endPos.latitude, endPos.longitude)
            .then((distance) {
          
          // Calculate how many seconds are used on running
          int seconds = DateTime.now().difference(_startTime).inSeconds;

          // Append the log onto the running history
          // It would then write it into local file
          _runningHistory.appendLog(distance, seconds);
        });
      });
    }

    // Update the state
    setState(() {});
  }
}
