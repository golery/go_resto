import 'package:flutter/material.dart';
import 'dart:async';
import 'Model.dart';
import 'Utils.dart';
import 'ManageTablePage.dart';
import 'SelectTablePage.dart';
import 'dart:io';
import 'Persistent.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() {
    return new _State();
  }
}

class _State extends State<HomePage> {
  static bool _init = false;

  Future<bool>_initRepo() async {
    if (_init) return false;

    try {
      await Persistent.load();
      _init = true;
    } on FileSystemException {
      _init = true;
      Repository.get().setSampleData();
      Persistent.save();
    }
    return true;
  }

  void _onStart() async {
    await _initRepo();
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new SelectTablePage();
    }));
  }

  @override
  Widget build(BuildContext context) {
    TextStyle styleLogo = new TextStyle(
        fontSize: 40.0, color: Colors.blue, fontWeight: FontWeight.bold);
    TextStyle styleButton = new TextStyle(color: Colors.white);
    var loginButton = new RaisedButton(
        child: new Text('LOGIN', style: styleButton),
        color: Colors.blue,
        onPressed: () {
          Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
            return new ManageTablePage();
          }));
        });
    var demoButton = new RaisedButton(
        child: new Text('START', style: styleButton),
        color: Colors.blue,
        onPressed: _onStart);
    return new Scaffold(
        body: new Row(children: <Widget>[
      new Expanded(
          child: new Column(children: <Widget>[
        new Image.asset(
          'assets/deux-magots.jpeg',
          height: 240.0,
          fit: BoxFit.cover,
        ),
        Layout.pad(new Text('GO-RESTO', style: styleLogo),
            padding: EdgeInsets.only(top: 32.0, bottom: 32.0)),
//            Layout.pad(new SizedBox(width: 150.0, child: loginButton),
//                padding: EdgeInsets.only(bottom: 16.0)),
        new SizedBox(width: 150.0, child: demoButton),
      ]))
    ]));
  }
}
