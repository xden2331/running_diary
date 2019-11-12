import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/**
 * A class for handling
 * CRUD operations on locally stored running log file
 */
class RunningHistory with ChangeNotifier {

  List _logs = [];

  // Return the latest log from file system
  Future<List> get log async {
    return _fromJson();
  }

  /**
   * Get the local storage path
   */
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /**
   * Get the local stored file
   */
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/running_logs.json');
  }

  /**
   * Read data from local json file
   */
  Future<List> _fromJson() async {
    File file = await _localFile;
    _logs = json.decode(file.readAsStringSync());

    return _logs;
  }

  /**
   * Write file to local json file
   */
  Future<List> _toJson() async {
    File file = await _localFile;
    file.writeAsStringSync(json.encode(_logs));
    return _logs;
  }

  /**
   * Given an index, delete the log locally and in memory
   */
  Future<List> deleteLog(int index) async {
    _logs.removeAt(index);
    _logs = await _toJson();
    notifyListeners();
    return _logs;
  }

  /**
   * Delete all logs
   */
  Future<List> deleteAll() async {
    _logs = [];
    await _toJson();
    return _logs;
  }

  /**
   * Given distance and seconds, append one log onto the list
   * and flush it into local storage
   */
  Future<List> appendLog(double distance, int seconds) async {
    // Appended datetime
    DateTime dateTime = DateTime.now();

    // Add the log in memory
    _logs.add({
      'distance': distance,
      'seconds': seconds,
      'dateTime': dateTime.toIso8601String(),
    });

    // Write to local storage
    await _toJson();

    // Notify any listener that there is an update
    notifyListeners();

    // Return the updated logs
    return _logs;
  }

}