import 'package:flutter/material.dart';
import 'package:goresto/service/Navigator.dart';

import 'AboutPage.dart';
import 'ManageMenuPage.dart';
import 'ManageTablePage.dart';
import 'Model.dart';
import 'Persistent.dart';
import 'Utils.dart';
import 'widget/TableOrderPage.dart';

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
      // FIXME: new id is not save, thus potentially duplicated.
      // Need a better to manage id
      var seqId = Repository.get().orderIdSeq++;
      order = new Order(seqId, table.id);
    }
    var result = await Navigate.push(
        context, Screen.ManageTablePage, (context) => TableOrderPage(order));
    if (result != null) {
      Repository.get().setCurrentOrder(table.id, result);
      Persistent.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    var subtitleFreeStyle = const TextStyle(
        color: Colors.grey, fontSize: 10.0, fontStyle: FontStyle.italic);
    var subtitleServingStyle = const TextStyle(
        color: Colors.green, fontSize: 10.0, fontStyle: FontStyle.italic);
    List<Widget> texts = Repository.get().tables.map((table) {
      Order order = Repository.get().getCurrentOrder(table.id);
      Widget subtitle;
      if (order == null)
        subtitle = new Text('Free', style: subtitleFreeStyle);
      else
        subtitle = new Text('Serving...', style: subtitleServingStyle);
      return new ListTile(
          title: new Text(table.name),
          subtitle: subtitle,
          leading: new Icon(Icons.receipt, color: Colors.blue),
          onTap: () {
            _onSelectTable(table);
          });
    }).toList();
    var drawer = new Drawer(
        child: new ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        new DrawerHeader(
          child: new Text('ORDER',
              style: new TextStyle(
                  color: Colors.white,
                  fontSize: 35.0,
                  fontWeight: FontWeight.bold)),
          decoration: new BoxDecoration(
            color: Colors.blue,
          ),
        ),
        new ListTile(
          title: new Text('Manage tables'),
          onTap: () => Navigate.push(
              context, Screen.ManageTablePage, (context) => ManageTablePage()),
        ),
        new ListTile(
          title: new Text('Manage menu'),
          onTap: () => Navigate.push(
              context, Screen.ManageMenuPage, (context) => ManageMenuPage()),
        ),
        new ListTile(
          title: new Text('About'),
          onTap: () => Navigate.push(
              context, Screen.AboutPage, (context) => AboutPage()),
        )
      ],
    ));

    ListView list = new ListView(children: texts);
    return new Scaffold(
        drawer: drawer,
        appBar: new AppBar(
          title: new Text('Choose table'),
        ),
        body: new Column(children: <Widget>[
          new Expanded(child: Layout.pad(list)),
        ]));
  }
}
