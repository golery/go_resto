import 'package:flutter/material.dart';
import 'Model.dart';
import 'Utils.dart';
import 'Persistent.dart';

class EditDishPage extends StatefulWidget {
  final Dish dish;

  EditDishPage(this.dish);

  @override
  State<EditDishPage> createState() {
    return new _EditDishState(dish);
  }
}

class _EditDishState extends State<EditDishPage> {
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController fullNameController = new TextEditingController();
  final TextEditingController priceController = new TextEditingController();
  final Dish dish;

  _EditDishState(this.dish);

  void _onAdd() {
    dish.name = nameController.text;
    dish.price = double.parse(priceController.text);
    dish.fullName = fullNameController.text;
    Navigator.of(context).pop(dish);
  }

  void _onDelete() {
    Navigator.of(context).pop('delete');
  }

  @override
  void dispose() {
    nameController.dispose();
    fullNameController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    nameController.text = dish.name;
    fullNameController.text = dish.fullName;
    priceController.text = '${dish.price}';
    var form = new Form(
            child: new Column(children: <Widget>[
          new TextFormField(
              decoration: new InputDecoration(labelText: 'Name'),
              controller: nameController),
          new TextFormField(
              decoration: new InputDecoration(labelText: 'Full name'),
              controller: fullNameController),
          new TextFormField(
              decoration: new InputDecoration(labelText: 'Price'),
              controller: priceController),
          Layout.pad(
              new RaisedButton(onPressed: _onAdd, child: new Text('OK')))
        ]));
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Edit Dish'),
          actions: <Widget>[
            new IconButton(icon: new Icon(Icons.delete), onPressed: _onDelete)],
        ),
        body: Layout.pad(form));
  }
}
