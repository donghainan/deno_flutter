import 'package:flutter/material.dart';
import './pages/index_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "天下无购",
      theme: ThemeData(
        primaryColor: Colors.pink,
      ),
      debugShowCheckedModeBanner: false,
      home: IndexPage(),
    );
  }
}
