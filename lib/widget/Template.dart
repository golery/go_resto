import 'package:flutter/material.dart';

class MyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Edit product"),
          actions: <Widget>[],
        ),
        body: _body(),
//      floatingActionButton: FloatingActionButton(
//        onPressed: _ok,
//        child: Icon(Icons.check),
//      ),
    );
  }

  Widget _body() {
    return Text("x");
  }

  _ok() {

  }
}