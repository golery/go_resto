import 'package:flutter/material.dart';
import 'package:goresto/service/Factory.dart';
import 'package:goresto/service/Navigator.dart';
import 'package:goresto/widget/TableGridItem.dart';

import 'EditTable.dart';
import 'Model.dart';
import 'Persistent.dart';
import 'Utils.dart';

class ManageTablePage extends StatefulWidget {
  @override
  State<ManageTablePage> createState() {
    return new _ManageTablePageState();
  }
}

class _ManageTablePageState extends State<ManageTablePage> {
  void _onSelectTable(RestoTable table) async {
    var result = await Navigate.push(
        context, Screen.EditTablePage, (context) => EditTablePage(table));
    setState(() {});
    if (result == 'DELETE') {
      Repository.get().tables.remove(table);
      Persistent.save();
    } else if (result != null) {
      Persistent.save();
    }
  }

  void _onAdd() async {
    factory.analytics.logEvent(name: "evAddTable");
    RestoTable table = new RestoTable('Table', 1);
    var result = await Navigator.of(context)
        .push(new MaterialPageRoute(builder: (buildContext) {
      return new EditTablePage(table);
    }));
    if (result != null && result != 'DELETE') {
      Repository.get().tables.add(table);
      Persistent.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    GridView list = GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 20,
        mainAxisSpacing: 5,
        crossAxisCount: 3,
        shrinkWrap: true,
        children: _list());
    return new Scaffold(
        appBar: new AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: new Text('Manage tables'),
        ),
        body: new Column(children: <Widget>[
          new Expanded(child: list),
          Layout.pad(
              new RaisedButton(child: new Text('Add'), onPressed: _onAdd)),
        ]));
  }

  List<Widget> _list() {
    return Repository.get().tables.map((table) {
      return TableGridItem(table, onClicked: _onSelectTable);
    }).toList();
  }
}
