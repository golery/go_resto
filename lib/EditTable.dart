import 'package:flutter/material.dart';
import 'Model.dart';
import 'Utils.dart';
import 'Persistent.dart';

class EditTablePage extends StatefulWidget {
  final RestoTable table;

  EditTablePage(this.table);

  @override
  State<EditTablePage> createState() {
    return new EditTableState(table);
  }
}

class EditTableState extends State<EditTablePage> {
  final TextEditingController textController = new TextEditingController();
  final RestoTable table;

  EditTableState(this.table);

  void _onAddTable() {
    table.name = textController.text;
    Navigator.of(context).pop(table);
  }

  @override
  void dispose() {
    textController.dispose();
    Persistent.save();
    super.dispose();
  }

  void _onDelete() {
    Navigator.of(context).pop('DELETE');
  }

  @override
  Widget build(BuildContext context) {
    textController.text = table.name;
    var form = new Form(
            child: new Column(children: <Widget>[
          new TextFormField(
              decoration: new InputDecoration(labelText: 'Table name'),
              controller: textController),
          Layout.pad(
              new RaisedButton(onPressed: _onAddTable, child: new Text('OK')))
        ]));
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Add table'),
          actions: [new IconButton(icon: new Icon(Icons.delete), onPressed: _onDelete)]
        ),
        body: Layout.pad(form));
  }
}
