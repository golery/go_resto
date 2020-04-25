import 'package:flutter/material.dart';

import 'Model.dart';
import 'Utils.dart';
import 'EditDishPage.dart';
import 'Persistent.dart';

class EditMenuCategoryPage extends StatefulWidget {
  final DishCategory category;

  EditMenuCategoryPage(this.category);

  @override
  State<EditMenuCategoryPage> createState() {
    return new _EditMenuCategoryState(category);
  }
}

class _EditMenuCategoryState extends State<EditMenuCategoryPage> {
  final TextEditingController textController = new TextEditingController();
  final DishCategory category;

  _EditMenuCategoryState(this.category);

  void _onOk() {
    category.name = textController.text;
    Persistent.save();
    Navigator.of(context).pop(category);
  }

  void _onDelete() {
    Navigator.of(context).pop('DELETE');
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void _onEditDish(DishCategory category, Dish dish) async {
    var result = await Navigate.pushPage(context, new EditDishPage(dish));
    if (result == 'delete') {
      category.dishes.remove(dish);
      Persistent.save();
    }
  }

  void _onAddDish() async {
    var dish = new Dish('Dish name', 0.0);
    var result = await Navigate.pushPage(context, new EditDishPage(dish));
    if (result != null) {
      category.dishes.add(dish);
      Persistent.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    textController.text = category.name;
    var form = new Form(
        child: new Column(children: <Widget>[
      new TextFormField(
          decoration: new InputDecoration(labelText: 'Category name'),
          controller: textController),
      Layout.pad(
          new RaisedButton(onPressed: _onOk, child: new Text('OK')))
    ]));
    List<Widget> list = [];
    category.dishes
          .forEach((dish) => list.add(new ListTile(
                title: new Text(dish.name),
                leading: new Icon(Icons.restaurant),
                onTap: () =>_onEditDish(category, dish)
              )));
    list.add(new Center(child: new RaisedButton(onPressed: _onAddDish, child: new Text('ADD DISH'))));
    var listView = new ListView(
      children: list,
    );
    var listViewContainer = new Expanded(child: new Container(child: listView));
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Edit category'),
          actions: <Widget>[new IconButton(icon: new Icon(Icons.delete), onPressed: _onDelete)],
        ),
        body: Layout.pad(
            new Column(children: <Widget>[form, listViewContainer])));
  }
}
