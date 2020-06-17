import 'package:enterit/Model/test.dart';
import 'package:flutter/material.dart';
import 'package:enterit/Model/inventory_item.dart';
import 'package:enterit/Model/inventory_class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:enterit/Model/inventory_form.dart';
import 'package:enterit/Model/card.dart';
import 'package:enterit/Model/add_item.dart';
import 'package:enterit/Model/Logs.dart';
import 'package:enterit/Model/globals.dart' as globals;


class Invent extends StatefulWidget {

  String value;

  Invent({Key key, this.value}) : super (key : key);

  @override
  _InventState createState() => _InventState();
}


class _InventState extends State<Invent>
    with SingleTickerProviderStateMixin {

  TabController controller;

  String value;
  List docs = [0, 1];
  final DBRef = Firestore.instance.collection('items');


  @override
  void initState() {
    super.initState();
    controller = new TabController(length: 3, vsync: this);

    print(globals.isLoggedIn);

    DateTime today = new DateTime.now();
    globals.loginTime = today.toString().substring(0, 19);

  }


  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.brown.shade200,

      appBar: AppBar(
        title: Text('EnterIt'),
        centerTitle: true,
        backgroundColor: Colors.brown,

        actions: <Widget>[
          // action button
          IconButton(
            color: Colors.brown.shade200,
            icon: Icon(Icons.power_settings_new),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),

        ],

        bottom: new TabBar(
          labelColor: Colors.brown.shade200,
          indicatorColor: Colors.brown.shade200,
          controller: controller,
          tabs: <Widget>[
            new Tab(icon: new Icon(Icons.collections)
            ),
            new Tab(icon: new Icon(Icons.library_add)),
            new Tab(icon: new Icon(Icons.person)),
          ],


        ),


      ),



      body:
      new TabBarView(
        controller: controller,
        children: <Widget>[
          StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection(globals.isLoggedIn).snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.brown),
                  ));
                default:
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: new ListView(

                      // ignore: missing_return
                      children: snapshot.data.documents.map((
                          DocumentSnapshot document) {
                        List list = [];
                        String listItem = document.documentID;

                        if(listItem == 'date'){
                          return Text('');
                        }

                        for (int i = 0; i < document.data.length; i++) {
                          list.add(document.data.keys.elementAt(i) + " : " +
                              document.data.values.elementAt(i).toString());
                        }
                        List list2 = [];

                        for (int i = 0; i < document.data.length; i++) {
                          list2.add(document.data.values.elementAt(i));
                        }
                        return new InCard(item_title: listItem,
//                        document.documentID,
                          item_subtitle: list.toString()
                              .replaceAll('[', "")
                              .replaceAll(']', "")
                              .replaceAll(',', "   |  "),

                        );
                      }).toList(),
                    ),
                  );
              }
            },
          ),

//                InventForm(),

          AddForm(),
          //  Test(),
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