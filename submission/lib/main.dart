import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:running_diary/pages/RunningLog/RunningHistory.dart';

import 'MyHomePage.dart';

void main() {
  runApp(MyApp());
}

/**
 * The basement of the running diary app
 */
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: MyHomePage(),
    );
  }
}