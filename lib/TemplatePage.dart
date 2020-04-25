import 'package:flutter/material.dart';
import 'ManageTablePage.dart';

class TemplatePage extends StatefulWidget {
  @override
  State<TemplatePage> createState() {
    return new _State();
  }
}

class _State extends State<TemplatePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Admin'),
        ),
        body: new Column(
            children: <Widget>[
              new RaisedButton(
                  child: new Text('START'),
                  onPressed: () {
                    Navigator
                        .of(context)
                        .push(new MaterialPageRoute(builder: (context) {
                      return new ManageTablePage();
                    }));
                  }),
            ],
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center));
  }
}
