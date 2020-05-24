import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Model.dart';
import 'Persistent.dart';
import 'Utils.dart';

class EditTablePage extends StatefulWidget {
  final RestoTable table;

  EditTablePage(this.table);

  @override
  State<EditTablePage> createState() {
    return new EditTableState(table);
  }
}

class EditTableState extends State<EditTablePage> {
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController maxPeopleController = new TextEditingController();
  final RestoTable table;

  EditTableState(this.table);

  @override
  void initState() {
    super.initState();
    nameController.text = table.name;
    maxPeopleController.text = "${table.maxPeople}";
  }

  void _onAddTable() {
    table.name = nameController.text;
    table.maxPeople = int.parse(maxPeopleController.text);
    Navigator.of(context).pop(table);
  }

  @override
  void dispose() {
    nameController.dispose();
    Persistent.save();
    super.dispose();
  }

  void _onDelete() {
    Navigator.of(context).pop('DELETE');
  }

  @override
  Widget build(BuildContext context) {
    var form = new Form(
      child: new Column(
        children: <Widget>[
          new TextFormField(
            decoration: new InputDecoration(labelText: 'Table name'),
            maxLength: 2,
            controller: nameController,
          ),
          new TextFormField(
            decoration: new InputDecoration(labelText: 'Max people'),
            maxLength: 2,
            keyboardType: TextInputType.number,
            controller: maxPeopleController,
          ),
          Layout.pad(
              new RaisedButton(onPressed: _onAddTable, child: new Text('OK'))),
        ],
      ),
    );
    return new Scaffold(
        appBar: new AppBar(title: new Text('Add table'), actions: [
          new IconButton(icon: new Icon(Icons.delete), onPressed: _onDelete)
        ]),
        body: Layout.pad(form));
  }
}
