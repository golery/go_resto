import 'package:flutter/material.dart';
import 'package:goresto/Model.dart';

typedef OnClickTableGridItem = void Function(RestoTable table);

class TableGridItem extends StatefulWidget {
  final RestoTable table;
  final bool showStatus;
  final OnClickTableGridItem onClicked;

  TableGridItem(this.table, {this.showStatus = false, this.onClicked});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<TableGridItem> {
  @override
  Widget build(BuildContext context) {
    var table = widget.table;
    Widget statusTxt = _statusText(table);
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
      widget.showStatus
          ? Row(
              children: <Widget>[statusTxt],
              mainAxisAlignment: MainAxisAlignment.center,
            )
          : SizedBox(height: 0),
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

  Widget _statusText(RestoTable table) {
    const double fontSize = 15.0;
    var subtitleFreeStyle = const TextStyle(
        color: Colors.green, fontSize: fontSize, fontStyle: FontStyle.normal);
    var subtitleServingStyle = const TextStyle(
        color: Colors.red, fontSize: fontSize, fontStyle: FontStyle.normal);
    Order order = Repository.get().getCurrentOrder(table.id);
    Widget statusTxt;
    if (order == null)
      statusTxt = new Text('Free', style: subtitleFreeStyle);
    else
      statusTxt = new Text('Occupied', style: subtitleServingStyle);
    return statusTxt;
  }

  _onSelectTable(RestoTable table) {
    if (widget.onClicked == null) return;
    widget.onClicked(table);
  }
}
