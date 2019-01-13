import 'package:flutter/material.dart';
import 'loginpage.dart';
import 'rootpage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Favor',
        home: RootPage(auth: Auth()),
        theme: ThemeData(primarySwatch: Colors.deepOrange));
  }
}

