import 'dart:convert';

import 'package:flutter/material.dart';
import '../sevices/service_method.dart';

class IndexPage extends StatefulWidget {
  IndexPage({Key key}) : super(key: key);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int curPage = 0;
  @override
  void initState() {
    // TODO: implement initState
    getHomePageContent().then((data) {
      setState(() {
        curPage = data['curPage'];
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("天下无购"),
      ),
      body: Center(
        child: Text(curPage.toString()),
      ),
    );
  }
}
