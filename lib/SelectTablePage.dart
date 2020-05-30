import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goresto/service/Factory.dart';
import 'package:goresto/service/Navigator.dart';
import 'package:goresto/widget/BillSettingsPage.dart';
import 'package:goresto/widget/TableGridItem.dart';
import 'package:goresto/widget/TablePage.dart';

import 'AboutPage.dart';
import 'ManageMenuPage.dart';
import 'ManageTablePage.dart';
import 'Model.dart';
import 'Persistent.dart';

// Ref. https://www.behance.net/gallery/96449931/Anytime-Restaurant-App?tracking_source=search_projects_recommended%7Crestaurant%20order%20app
class SelectTablePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new SelectTablePageState();
  }
}

class SelectTablePageState extends State<SelectTablePage> {
  void _onSelectTable(RestoTable table) async {
    var order = Repository.get().getCurrentOrder(table.id);
    if (order == null) {
      order = new Order(table.id);
    }
    Order result = await Navigate.push(
        context, Screen.ManageTablePage, (context) => TablePage(table));
    if (result != null) {
      result.seqId = Repository.get().orderIdSeq++;
      Repository.get().setCurrentOrder(table.id, result);
      Persistent.save();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> texts = Repository.get().tables.map((table) {
      return TableGridItem(table, showStatus: true, onClicked: _onSelectTable);
    }).toList();
    Drawer drawer = _drawer(context);

    GridView list = GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 20,
        mainAxisSpacing: 5,
        crossAxisCount: 3,
        shrinkWrap: true,
        children: texts);
    return new Scaffold(
        drawer: drawer,
        appBar: new AppBar(
          title: new Text('Choose table'),
        ),
        body: ListView(
          children: <Widget>[
            SizedBox(height: 20),
            Image.asset(
              "assets/picnic-table.png",
              height: 60,
            ),
            list,
          ],
        ));
  }

  _manageTable() async {
    factory.analytics.logEvent(name: "evManageTable");
    await Navigate.push(
        context, Screen.ManageTablePage, (context) => ManageTablePage());
    setState(() {});
  }

  _manageMenu() async {
    factory.analytics.logEvent(name: "evManageMenu");
    await Navigate.push(
        context, Screen.ManageMenuPage, (context) => ManageMenuPage());
    setState(() {});
  }

  _billSettings() async {
    factory.analytics.logEvent(name: "evBillSettings");
    await Navigate.push(
        context, Screen.BillSettings, (context) => BillSettingsPage());
    setState(() {});
  }

  Drawer _drawer(BuildContext context) {
    var drawer = new Drawer(
      child: new ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          new DrawerHeader(
            child: new Text('Restaurant',
                style: new TextStyle(
                    color: Colors.white,
                    fontSize: 35.0,
                    fontWeight: FontWeight.bold)),
            decoration: new BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          new ListTile(
            title: new Text('Manage tables'),
            onTap: _manageTable,
          ),
          new ListTile(
            title: new Text('Manage menu'),
            onTap: _manageMenu,
          ),
          new ListTile(
            title: new Text('Bill settings'),
            onTap: _billSettings,
          ),
          new ListTile(
            title: new Text('About'),
            onTap: () => Navigate.push(
                context, Screen.AboutPage, (context) => AboutPage()),
          )
        ],
      ),
    );
    return drawer;
  }
}
