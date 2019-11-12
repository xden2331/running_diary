/// Bar chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

/**
 * Given the historical data
 * Draw a bar chart.
 * Each bar represents the average amount of distance(km)/day run in that week
 */
class BarChart extends StatelessWidget {
  List<charts.Series> seriesList;
  bool animate;

  /**
   * Constructor
   */
  BarChart(List historyData) {
    seriesList = _createSeriesData(historyData);
    animate = false;
  }

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      seriesList,
      animate: true,
    );
  }

  /**
   * Create one series with given data.
   */
  List<charts.Series<WeeklyAverageData, String>> _createSeriesData(
      List historyData) {
    // If no data yet, return
    if (historyData.length == 0) {
      return [];
    }

    // compile the weekly averages
    final data = _createWeeklyAvgs(historyData);

    return [
      new charts.Series<WeeklyAverageData, String>(
        id: 'Distance',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,

        // x-axis
        domainFn: (WeeklyAverageData data, _) => data.whichWeek,

        // y-axis
        measureFn: (WeeklyAverageData data, _) => data.distance,
        data: data,
      )
    ];
  }

  /**
   * Compile weekly averages
   */
  List _createWeeklyAvgs(List historyData) {
    // The return result
    List<WeeklyAverageData> results = [];

    // a variable stores all info of a particular week.
    // would be cleared after compiling that week's average
    List week = [];

    // the index of week that are being compiled
    int weekNum = 1;

    // previous record's weekday, used to check if a new week arrives.
    int preWeekDayNum = -1;

    // Iterate through the logs except the last record
    for (int i = 0; i < historyData.length-1; ++i) {

      // current visited record
      var record = historyData[i];

      // the record's creation datetime
      DateTime currentDateTime = DateTime.parse(record['dateTime']);

      // If this is not a new week
      if (currentDateTime.weekday >= preWeekDayNum) {

        // append the record
        week.add(record);
      } 
      // else if this is a new week
      else if (currentDateTime.weekday < preWeekDayNum) {
        // Get the sum of current week
        double distanceSum = 0;
        week.forEach((map) {
          distanceSum += map['distance'];
        });

        // The average distance in current week
        double avg = distanceSum / 7;

        // Add the average onto the result list
        results.add(WeeklyAverageData(avg, "Week ${weekNum}"));

        // Clean current week list
        week.clear();

        // Go into new week
        week.add(record);

        // increase the index of week
        ++weekNum;
      }

      // Update previous record's weekday value
      preWeekDayNum = currentDateTime.weekday;
    }

    // after the for loop, we need to consider the last record
    var record = historyData.last;

    // the datetime of the last record
    DateTime currentDateTime = DateTime.parse(record['dateTime']);

    // if the last record is not in a new week
    if (currentDateTime.weekday >= preWeekDayNum) {
      // add the record
      week.add(record);

      // Calculate the sum of distance
      double distanceSum = 0;
      week.forEach((map) {
        distanceSum += map['distance'];
      });

      // The average distance in that week
      double avg = distanceSum / 7;

      // Add the average onto the result list
      results.add(WeeklyAverageData(avg, "Week ${weekNum}"));

      // Clean week list and go to next week
      week.clear();
    } 
    // else if the last record is in a new week
    else if (currentDateTime.weekday < preWeekDayNum) {
      // Get the sum of that week
      double distanceSum = 0;
      week.forEach((map) {
        distanceSum += map['distance'];
      });

      // The average distance in that week
      double avg = distanceSum / week.length;

      // Add the average onto the result list
      results.add(WeeklyAverageData(avg, "Week ${weekNum}"));

      // Clean week list and go to next week
      week.clear();

      // go into the new week
      week.add(record);
      ++weekNum;

      distanceSum = 0;
      week.forEach((map) {
        distanceSum += map['distance'];
      });

      // The average distance in the new week
      avg = distanceSum / 7;

      // Add the average onto the result list
      results.add(WeeklyAverageData(avg, "Week ${weekNum}"));

      // Clean week list and go to next week
      week.clear();
    }

    preWeekDayNum = currentDateTime.weekday;
    return results;
  }
}

/**
 * Class object used to display information on bar chart
 */
class WeeklyAverageData {
  final double distance;
  final String whichWeek;

  WeeklyAverageData(this.distance, this.whichWeek);
}
