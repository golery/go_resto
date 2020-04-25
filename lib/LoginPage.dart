import 'package:flutter/material.dart';
import 'ManageTablePage.dart';
import 'Utils.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() {
    return new Login();
  }
}

class Login extends State<LoginScreen> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  BuildContext _ctx;

  _submit() {
//    scaffoldKey.currentState
//        .showSnackBar(new SnackBar(content: new Text('text')));
    Navigator.of(_ctx).pop();
  }

  @override
  Widget build(BuildContext context) {
    this._ctx = context;
    var loginBtn = new RaisedButton(
      onPressed: this._submit,
      child: new Text("LOGIN"),
      color: Colors.primaries[0],
    );
    return new Scaffold(
        appBar: new AppBar(
          // Here we take the value from the MySelectTablePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: new Text('Resto Waiter'),
        ),
        body: new Container(
            decoration: new BoxDecoration(
                image: new DecorationImage(
                    image: new ExactAssetImage('assets/background.jpg'),
                    fit: BoxFit.fitWidth)),
            child: new Center(
              child: Layout.pad(new Column(
                children: <Widget>[
                  new Text(
                    "Login",
                    textScaleFactor: 2.0,
                  ),
                  new Form(
                      child: new Column(children: [
                    Layout.pad(new TextFormField(
                      decoration: new InputDecoration(labelText: 'Username'),
                    )),
                    Layout.pad(new TextFormField(
                      decoration: new InputDecoration(labelText: 'Password'),
                    )),
                  ])),
                  loginBtn,
                  new CircularProgressIndicator()
                ],
              )),
            )));
  }
}
