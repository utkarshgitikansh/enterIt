import 'package:flutter/material.dart';
import 'package:enterit/Model/inventory_item.dart';
import 'package:enterit/Model/inventory_class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:enterit/Model/inventory_form.dart';
import 'package:enterit/Model/card.dart';
import 'package:enterit/Model/add_item.dart';
import 'package:enterit/Model/Logs.dart';



void main() {

  runApp(MaterialApp(
    home: Home(),
  ));
  
}


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}


class _HomeState extends State<Home>
with SingleTickerProviderStateMixin{

TabController controller;

String value;
List docs = [0,1];
final DBRef = Firestore.instance.collection('items');


@override
void initState(){
  super.initState();
  controller = new TabController(length: 3, vsync: this);
}


@override
void dispose() {
  controller.dispose();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('EnterIt'),
        centerTitle: true,
        backgroundColor: Colors.brown,
        bottom: new TabBar(
          controller: controller,
            tabs: <Widget>[
              new Tab(icon: new Icon(Icons.collections)),
              new Tab(icon: new Icon(Icons.library_add)),
              new Tab(icon: new Icon(Icons.receipt)),
            ],
        ),
      ),

      body:
          new TabBarView(
            controller: controller,
              children: <Widget>[
                StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection('inventory').snapshots() ,
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

                    if (snapshot.hasError)
                      return new Text('Error: ${snapshot.error}');
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting: return new CircularProgressIndicator();
                      default:

                        return new ListView(

                          // ignore: missing_return
                          children: snapshot.data.documents.map((DocumentSnapshot document) {
                              List list = [];

                              for (int i = 0; i < document.data.length; i++) {
                                list.add(document.data.keys.elementAt(i) + " : " + document.data.values.elementAt(i).toString());
                              }
                              List list2 = [];

                              for (int i = 0; i < document.data.length; i++) {
                                list2.add(document.data.values.elementAt(i));
                              }
                            return new InCard( item_title : document.documentID,
                              item_subtitle: list.toString().replaceAll('[', "").replaceAll(']', "").replaceAll(',', "   |  "),

                            ) ;
                          }).toList(),
                     );
                    }
                  },
                ),

//                InventForm(),

                  AddForm(),

                  Logs(),

              ],
          ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: () {
//
//        },
//        child: Text('Add'),
//        backgroundColor: Colors.indigoAccent,
//      ),
    );
  }

}

