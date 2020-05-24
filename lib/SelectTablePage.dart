import 'package:flutter/material.dart';
import 'package:goresto/service/Navigator.dart';
import 'package:goresto/widget/TablePage.dart';

import 'AboutPage.dart';
import 'ManageMenuPage.dart';
import 'ManageTablePage.dart';
import 'Model.dart';
import 'Persistent.dart';
import 'Utils.dart';

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
      setState(() {});
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
      var title = table.name;
      if (order?.seqId != null) {
        title += ': Order #${order.seqId}';
      }
      return new ListTile(
          title: new Text(title),
          subtitle: subtitle,
          leading: new Icon(Icons.receipt, color: Colors.blue),
          onTap: () {
            _onSelectTable(table);
          });
    }).toList();
    Drawer drawer = _drawer(context);

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

  Drawer _drawer(BuildContext context) {
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
    return drawer;
  }
}
