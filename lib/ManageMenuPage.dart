import 'package:flutter/material.dart';
import 'Model.dart';
import 'Utils.dart';
import 'EditTable.dart';
import 'EditMenuCategoryPage.dart';
import 'Persistent.dart';

class ManageMenuPage extends StatefulWidget {
  @override
  State<ManageMenuPage> createState() {
    return new _ManageMenuPageState();
  }
}

class _ManageMenuPageState extends State<ManageMenuPage> {
  void _onSelectCategory(DishCategory category) async {
    var result = await Navigate.pushPage(context, new EditMenuCategoryPage(category));
    if (result == 'DELETE') {
      Repository.get().dishCategories.remove(category);
      Persistent.save();
    }
  }
  void _onAdd() async {
    DishCategory category = new DishCategory('Category', []);
    var result = await Navigate.pushPage(context, new EditMenuCategoryPage(category));
    if (result != null) {
      Repository.get().dishCategories.add(category);
      Persistent.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> texts = Repository.get().dishCategories
        .map((category) => new ListTile(
              title: new Text(category.name),
              leading: new Icon(Icons.restaurant, color: Colors.blue),
              onTap: () {
                _onSelectCategory(category);
              },
            ))
        .toList();
    ListView list = new ListView(children: texts);
    return new Scaffold(
        appBar: new AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: new Text('Manage menu'),
        ),
        body: Layout.pad(new Column(children: <Widget>[
          new Expanded(child: list),
          new RaisedButton(child: new Text('ADD CATEGORY'), onPressed: _onAdd),
        ])));
  }
}
