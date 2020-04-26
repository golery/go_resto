import 'dart:async';

import 'package:flutter/material.dart';

import 'ManageTablePage.dart';
import 'Model.dart';
import 'Persistent.dart';
import 'SelectTablePage.dart';
import 'Utils.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() {
    return _State();
  }
}

class _State extends State<HomePage> {
  static bool _init = false;

  Future<bool> _initRepo() async {
    if (_init) return false;

    try {
      await Persistent.load();
      _init = true;
    } catch (e) {
      _init = true;
      Repository.get().setSampleData();
      Persistent.save();
    }
    return true;
  }

  void _onStart() async {
    await _initRepo();
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return SelectTablePage();
    }));
  }

  @override
  Widget build(BuildContext context) {
    TextStyle styleLogo = TextStyle(
        fontSize: 40.0, color: Colors.blue, fontWeight: FontWeight.bold);
    TextStyle styleButton = TextStyle(color: Colors.white);
    var loginButton = RaisedButton(
        child: Text('LOGIN', style: styleButton),
        color: Colors.blue,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return ManageTablePage();
          }));
        });
    var demoButton = RaisedButton(
        child: Text('START', style: styleButton),
        color: Colors.blue,
        onPressed: _onStart);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            child: Image.asset(
              'assets/landing.jpg',
              height: 240.0,
              fit: BoxFit.cover,
            ),
            padding: EdgeInsets.all(50),
          ),
          Column(
            children: <Widget>[
              Layout.pad(Text('RESTO ORDER', style: styleLogo),
                  padding: EdgeInsets.only(top: 32.0, bottom: 32.0)),
              SizedBox(width: 150.0, child: demoButton),
            ],
          )
        ],
      ),
    );
  }
}
