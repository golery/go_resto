import 'package:flutter/material.dart';
import 'Utils.dart';

class AboutPage extends StatefulWidget {
  @override
  State<AboutPage> createState() {
    return new _State();
  }
}

class _State extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('About'),
        ),
        body: new Center(
            child: new Column(
                children: <Widget>[
            Layout.pad(new Text('Go-Resto',
                style: new TextStyle(fontSize: 30.0, color: Colors.blue))),
        new Text('Copyright (C) 2018 by Golery.com. All rights reserved.'),
        new Text('Contact: golery.team@outlook.com  or www.golery.com')
        ],
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center)));
  }
}
