import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:goresto/service/Factory.dart';

import 'HomePage.dart';

void main() => runApp(new Application());

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Resto Waiter',
        theme: new ThemeData(
          primarySwatch: Colors.green,
          scaffoldBackgroundColor: Colors.white,
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.green, //  <-- dark color
            textTheme: ButtonTextTheme
                .primary, //  <-- this auto selects the right color
          ),
        ),
        debugShowCheckedModeBanner: false,
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: factory.analytics),
        ],
        home: new HomePage());
  }
}
