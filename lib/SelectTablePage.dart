import 'package:flutter/material.dart';
import 'TableOrderPage.dart';
import 'Model.dart';
import 'Utils.dart';
import 'ManageMenuPage.dart';
import 'ManageTablePage.dart';
import 'AboutPage.dart';
import 'Persistent.dart';

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
    var widget = new TableOrderPage(order);
    var result = await Navigate.pushPage(context, widget);
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
          child: new Text('GO-RESTO',
              style: new TextStyle(color: Colors.white, fontSize: 35.0)),
          decoration: new BoxDecoration(
            color: Colors.blue,
          ),
        ),
        new ListTile(
          title: new Text('Manage tables'),
          onTap: ()=> Navigate.pushPage(context, new ManageTablePage()),
        ),
        new ListTile(
          title: new Text('Manage menu'),
          onTap: ()=> Navigate.pushPage(context, new ManageMenuPage()),
        ),
        new ListTile(
          title: new Text('About'),
          onTap: ()=> Navigate.pushPage(context, new AboutPage()),
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
