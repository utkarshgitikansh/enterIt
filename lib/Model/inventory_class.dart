import 'package:flutter/material.dart';
import 'package:enterit/Model/inventory_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class InventCard extends StatelessWidget {

  final InventoryItem inventoryItem;
  final Function add;
  final Function delete;
  InventCard({this.inventoryItem, this.add, this.delete});

  @override
  Widget build(BuildContext context) {


    return Card(
      margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child:
            Text(
              'works',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.indigoAccent,
              ),
            ),
          ),
          SizedBox(height: 6.0),
          FlatButton.icon(
            onPressed: delete,
            label: Text('add'),
            icon: Icon(Icons.add),
          )
        ],
      ),
    );
  }
}
