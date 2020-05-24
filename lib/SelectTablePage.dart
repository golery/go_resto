import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goresto/service/Navigator.dart';
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
      setState(() {});
    }
  }

  Widget _table(RestoTable table) {
    var subtitleFreeStyle = const TextStyle(
        color: Colors.grey, fontSize: 10.0, fontStyle: FontStyle.italic);
    var subtitleServingStyle = const TextStyle(
        color: Colors.green, fontSize: 15.0, fontStyle: FontStyle.italic);
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
    var inner = Column(children: <Widget>[
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
              child: Text("${table.name}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30))),
          Column(
            children: <Widget>[
              Icon(Icons.people_outline),
              Text("${table.maxPeople} pp"),
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          )
        ],
      ),
      SizedBox(height: 20),
      Row(
        children: <Widget>[subtitle],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    ]);
    return Container(
        child: InkWell(child: inner, onTap: () => _onSelectTable(table)),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black26.withOpacity(0.4),
              spreadRadius: 0,
              blurRadius: 8,
              offset: Offset(2, 2), // changes position of shadow
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> texts = Repository.get().tables.map((table) {
      return _table(table);
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
