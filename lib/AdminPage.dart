import 'package:flutter/material.dart';
import 'package:goresto/service/Navigator.dart';

import 'ManageMenuPage.dart';
import 'ManageTablePage.dart';

class AdminPage extends StatefulWidget {
  @override
  State<AdminPage> createState() {
    return new _AdminPageState();
  }
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Admin'),
        ),
        body: new Column(
            children: <Widget>[
              new RaisedButton(
                  child: new Text('Manage table'),
                  onPressed: () {
                    Navigator.of(context)
                        .push(new MaterialPageRoute(builder: (context) {
                      return new ManageTablePage();
                    }));
                  }),
              new RaisedButton(
                  onPressed: () {
                    Navigate.push(context, Screen.ManageMenuPage,
                        (context) => ManageMenuPage());
                  },
                  child: new Text('Manage menu')),
            ],
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center));
  }
}
