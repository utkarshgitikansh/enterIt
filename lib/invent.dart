import 'dart:io';

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

import 'package:fluttertoast/fluttertoast.dart';


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

    print(user);

    // ignore: invalid_use_of_protected_member
    (context as Element).reassemble();

    Firestore.instance.collection(user).snapshots().listen((data) =>
        data.documents.forEach((doc) => inventItems.add(doc.documentID)));


//    getInvent();
    Future<List> _invent = Future<List>.delayed(
      Duration(seconds: 0),
          () => inventItems,
    );




    print('init state');
    super.initState();



  }


  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  String _inventory = 'inventory';
  String _item = 'item';
  String edited_date;

  String _dropDownValue;
  String _dropDown;

  int _count = 1;
  int old_count = 0;
  int pcount;

  List arr = [];
  List inventItems = ["New inventory .."];
  List items = ["New item .."];

  List aitems = ["books", "bakery"];

  List a = ["New inventory .."];

  bool idata = false;
  bool _form1 = false;
  bool _form2 = false;
  bool _form3 = false;

  String user = globals.isLoggedIn;

  bool formShow = false;


  Future getInvent() async {
    return new Future.delayed(Duration(seconds: 1), () => print(inventItems));
  }

  count() {

    old_count = 0;

    var match = 'New item ..' ;

    _form2 = false;

    if(_item == "New item .."){
      _form2 = true;
    }

    items.remove("New item ..");

    Firestore.instance
        .collection(user)
        .document(_inventory)
        .get()
        .then((DocumentSnapshot ds) {
      if (ds.exists) {
        setState(() {
          old_count = old_count +
              ds.data.values.elementAt(
                  ds.data.keys.toList().indexOf(_item));
        });
        print(old_count);
      } else
        exitCode;
    });

    items.add("New item ..");

  }

  drop() {
    _dropDownValue = "";
    _dropDown = "";
  }

  write() {
    bool set = false;

//    print('yo' + inventItems.toString());

    // check for already exists

    Firestore.instance
        .collection(user)
        .document(_inventory)
        .get()
        .then((DocumentSnapshot ds) {
      if (ds.exists) {
        print('exists');
      } else
        // add a new item

        Firestore.instance
            .collection(user)
            .document(_inventory.toLowerCase())
            .setData({_item.toLowerCase(): _count});

      Firestore.instance
          .collection(user)
          .document('date')
          .updateData({_inventory.toLowerCase(): edited_date});
    });

    Firestore.instance
        .collection(user)
        .document(_inventory)
        .snapshots()
        .listen((data) =>
    data.data.keys.toList().indexOf(_item) >= 0 &&
        data.data.values
            .elementAt(data.data.keys.toList().indexOf(_item)) ==
            _count
//             data.data.values.toList().indexOf(_item) == _count
        ?
//     print('old data')

    //       print('new data'),
    {
      //pcount = data.data.values.elementAt(data.data.keys.toList().indexOf(_item.toLowerCase())),
      pcount = _count,
      arr.add(data.data),
//      print(pcount),
//      print(arr),
      print('old field'),
      print(old_count),
      Firestore.instance
          .collection(user)
          .document(_inventory.toLowerCase())
          .updateData({_item: old_count}),
      Firestore.instance
          .collection(user)
          .document('date')
          .updateData({_inventory.toLowerCase(): edited_date}),
      exitCode
    }
        : {
      Firestore.instance
          .collection(user)
          .document(_inventory.toLowerCase())
          .updateData({_item: old_count}),
      print('new field'),
      Firestore.instance
          .collection(user)
          .document('date')
          .updateData({_inventory.toLowerCase(): edited_date}),

    });

    DateTime today = new DateTime.now();
    //edited_date ="${today.year.toString()}-${today.month.toString().padLeft(2,'0')}-${today.day.toString().padLeft(2,'0')}";
    edited_date = today.toString().substring(0, 19);
//    print(edited_date);


//  print(inventItems);

    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => Invent()));

  }

  increment() {
    setState(() {
      old_count = old_count + 1;
    });
  }

  decrement() {
    if (old_count <= 1) {
      // ignore: unnecessary_statements
      Fluttertoast.showToast(
          msg: "Count cannot be less than 1",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0

      );
    } else {
      setState(() {
        old_count = old_count - 1;
      });
    }
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("EnterIt"),
      content: Text("Item counts should be more than 1"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  newItem() {
    _form3 = true;
  }

  item() {

    _dropDown = "Items list ..";

    idata =  false;
    _form1 = false;
    _form2 = false;

    setState(() {
      items = [];
      old_count = 0;
    });

    if(_inventory == "New inventory .."){
      items = [];
      _form1 = true;
      _form2 = true;
      _dropDown = "No items yet";
    }
    else {
      Firestore.instance.collection(user).snapshots().listen((data) =>
          data.documents.forEach((doc) =>
          {
            if(doc.documentID == _inventory){

              setState(() {
                items = doc.data.keys.toList();
              }),

              items.add("New item ..")
            }})
      );
    }
    Future<List>.delayed(
      Duration(seconds: 0),
          () => setItem(),
    );

  }

  setItem () {

    setState(() {
      idata = true;
    });

  }

  delete() {
    Firestore.instance
        .collection(user)
        .document(_inventory)
        .get()
        .then((DocumentSnapshot ds) {

      Firestore.instance
          .collection(user)
          .document(_inventory.toLowerCase())
          .delete();

    });

    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => Invent()));

  }

  Widget _buildName() {
    return null;
  }


  @override
  Widget build(BuildContext context) {

    Future<List> _calculation = Future<List>.delayed(
      Duration(seconds: 0),
          () => inventItems,
    );

    Future<List> _items = Future<List>.delayed(
      Duration(seconds: 0),
          () => items,
    );


    Future.delayed(Duration(seconds: 2), () => print(items));

    return Scaffold(

      backgroundColor: Colors.brown.shade200,

      appBar: AppBar(
//        title: Text('EnterIt'),
        centerTitle: true,
        backgroundColor: Colors.brown,

//        actions: <Widget>[
//          // action button
//          IconButton(
//            color: Colors.brown.shade200,
//            icon: Icon(Icons.power_settings_new),
//            onPressed: () {
//              Navigator.pushReplacementNamed(context, '/');
//            },
//          ),
//
//        ],

//        bottom:
        title : new TabBar(
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
      Padding(
      padding: const EdgeInsets.all(12.0),
      child:
          Flexible(
                child: StreamBuilder<QuerySnapshot>(
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
                                list.add("✔  " + document.data.keys.elementAt(i) + "  :  " +
                                    document.data.values.elementAt(i).toString() + "\n");
                              }
                              List list2 = [];

                              for (int i = 0; i < document.data.length; i++) {
                                list2.add(document.data.values.elementAt(i));
                              }

                              return Center(
                                child: Container(
//                                  height: 100,
                                  child: Flexible(
                                    child: Card(
                                      color: Colors.brown,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                             ListTile(
//                                          leading: Icon(Icons.assignment_turned_in, color: Colors.brown.shade200,),
                                              title: Text(listItem + '\n' , style: TextStyle(fontWeight: FontWeight.w900, color: Colors.brown.shade200)),
                                              subtitle: Text(list.toString()
                                                  .replaceAll('[', " ")
//                                          .replaceAll('[', "")
                                          .replaceAll(']', "")
                                          .replaceAll(',', "\n"), style: TextStyle(fontWeight: FontWeight.w500, color: Colors.brown.shade200)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );

//                              return new InCard(item_title: listItem,
////                        document.documentID,
//                                item_subtitle: list.toString()
//                                    .replaceAll('[', "")
//                                    .replaceAll(']', "")
//                                    .replaceAll(',', "   |  "),
//
//                              );
                            }).toList(),
                          ),
                        );
                    }
                  },
                ),
              ),
          ),

//        const ListTile(
//          leading: Icon(Icons.album),
//          title: Text('The Enchanted Nightingale'),
//          subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
//        ),
//        ButtonBar(
//          children: <Widget>[
//            FlatButton(
//              child: const Text('BUY TICKETS'),
//              onPressed: () { /* ... */ },
//            ),
//            FlatButton(
//              child: const Text('LISTEN'),
//              onPressed: () { /* ... */ },
//            ),
//          ],
//        ),
//                InventForm(),

          AddForm(),
          //  Test(),
          Logs(),

        ],
      ),

    );
  }

}