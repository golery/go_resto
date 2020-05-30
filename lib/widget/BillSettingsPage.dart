import 'package:flutter/material.dart';
import 'package:goresto/Model.dart';
import 'package:goresto/Persistent.dart';
import 'package:goresto/service/Navigator.dart';

class BillSettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<BillSettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final _taxController = TextEditingController();
  final _tipController = TextEditingController();

  @override
  void initState() {
    _taxController.text = "${Repository.get().settings.taxPercentage}";
    _tipController.text = "${Repository.get().settings.tipPercentage}";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bill Settings"),
        actions: <Widget>[],
      ),
      body: _body(),
      floatingActionButton: FloatingActionButton(
        onPressed: _ok,
        child: Icon(Icons.check),
      ),
    );
  }

  Widget _body() {
    return Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(children: <Widget>[
            TextFormField(
                decoration: new InputDecoration(labelText: 'Tax Percentage'),
                controller: _taxController),
            TextFormField(
                decoration: new InputDecoration(labelText: 'Tip Percentage'),
                controller: _tipController),
          ]),
        ));
  }

  _ok() {
    var tax = num.parse(_taxController.text);
    var tip = num.parse(_tipController.text);
    if (tax < 0 || tax >= 100) return;
    if (tip < 0 || tip >= 100) return;
    Repository.get().settings.tipPercentage = tip;
    Repository.get().settings.taxPercentage = tax;
    Persistent.save();
    Navigate.pop(context, null);
  }
}
