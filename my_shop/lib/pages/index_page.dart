import 'dart:convert';

import 'package:flutter/material.dart';
import '../sevices/service_method.dart';
import '../api/http_util.dart';

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Http.getInstance().get(
      'http://www.wanandroid.com/article/list/0/json',
      (data) {
        print(data);
        setState(() {
          curPage = data.curPage;
        });
      },
    );
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
