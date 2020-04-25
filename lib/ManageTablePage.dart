import 'package:flutter/material.dart';
import 'Model.dart';
import 'Utils.dart';
import 'EditTable.dart';
import 'Persistent.dart';

class ManageTablePage extends StatefulWidget {
  @override
  State<ManageTablePage> createState() {
    return new _ManageTablePageState();
  }
}

class _ManageTablePageState extends State<ManageTablePage> {
  void _onSelectTable(RestoTable table) async {
    var result = await Navigate.pushPage(context, new EditTablePage(table));
    if (result == 'DELETE') {
      Repository.get().tables.remove(table);
      Persistent.save();
    } else if (result != null) {
      Persistent.save();
    }
  }

  void _onAdd() async {
    RestoTable table = new RestoTable('Table');
    var result = await Navigator.of(context).push(
        new MaterialPageRoute(builder: (buildContext) {
          return new EditTablePage(table);
        }));
    if (result != null && result != 'DELETE') {
      Repository
          .get()
          .tables
          .add(table);
      Persistent.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> texts = Repository
        .get()
        .tables
        .map((table) => new ListTile(
              title: new Text(table.name),
              leading: new Icon(Icons.receipt, color: Colors.blue),
              onTap: () {
                _onSelectTable(table);
              },
            ))
        .toList();
    ListView list = new ListView(children: texts);
    return new Scaffold(
        appBar: new AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: new Text('Manage tables'),
        ),
        body: new Column(children: <Widget>[
          new Expanded(child: Layout.pad(list)),
          Layout.pad(new RaisedButton(child: new Text('Add'), onPressed: _onAdd)),
        ]));
  }
}
