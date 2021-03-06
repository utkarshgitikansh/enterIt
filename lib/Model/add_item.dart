import 'dart:io';

import 'package:enterit/Model/card.dart';
import 'package:enterit/invent.dart';
import 'package:enterit/main.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:enterit/Model/globals.dart' as globals;
import 'package:fluttertoast/fluttertoast.dart';


class AddForm extends StatefulWidget {

  String value;

  AddForm({Key key, this.value}) : super (key : key);

  @override
  _AddFormState createState() => _AddFormState();
}

class _AddFormState extends State<AddForm> {

  TabController controller;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var DBRef = Firestore.instance.collection('items').snapshots();

  String _inventory = 'brand';
  String _item = 'item';
  String edited_date;

  String _dropDownValue;
  String _dropDown;

  int _count = 0;
  int old_count = 0;
  int pcount;

  List arr = [];
  List inventItems = ["New brand .."];
  List items = ["New item .."];

  List aitems = ["books", "bakery"];

  List a = ["New brand .."];

  bool idata = false;
  bool _form1 = false;
  bool _form2 = false;
  bool _form3 = false;
  
  String user = globals.isLoggedIn;
  bool formShow = false;


  @override
  void initState() {

//    // ignore: invalid_use_of_protected_member
//    (context as Element).reassemble();

    Firestore.instance.collection(user).snapshots().listen((data) =>
        data.documents.forEach((doc) => inventItems.add(doc.documentID)));


////    getInvent();
//    Future<List> _invent = Future<List>.delayed(
//      Duration(milliseconds: 100),
//          () => inventItems,
//    );


//    print('init state');

    super.initState();

  }

//  Future getInvent() async {
//    return new Future.delayed(Duration(milliseconds: 100), () => print(inventItems));
//  }

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
    int cnt;

    Fluttertoast.showToast(
        msg: "Updating ...",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: globals.night ? Color(0xff0392cf) : Color(0xff141d26),
        textColor: Colors.white,
        fontSize: 16.0

    );


    // check for already exists

    Firestore.instance
        .collection(user)
        .document(_inventory.toLowerCase())
        .get()
        .then((DocumentSnapshot ds) {
      if (ds.exists) {


          Firestore.instance
              .collection(user)
              .document(_inventory.toLowerCase())
              .updateData({_item.toLowerCase() : old_count});


      Firestore.instance
          .collection(user)
          .document('date')
          .updateData({_inventory.toLowerCase(): edited_date});


      }

      else {


        // add a new item

        print(_count);
        print(old_count);


        Firestore.instance
            .collection(user)
            .document(_inventory.toLowerCase())
            .setData({_item.toLowerCase(): old_count});



        Firestore.instance
            .collection(user)
            .document('date')
            .updateData({_inventory.toLowerCase(): edited_date});

      }
    });

//    Firestore.instance
//        .collection(user)
//        .document(_inventory)
//        .snapshots()
//        .listen((data) =>



//    data.data.keys.toList().indexOf(_item) >= 0 &&
//        data.data.values
//            .elementAt(data.data.keys.toList().indexOf(_item)) ==
//            _count

//        ?

//    {

//      pcount = _count,
//      arr.add(data.data),
//
//      print('old field'),
//      print(old_count),

//      Firestore.instance
//          .collection(user)
//          .document(_inventory.toLowerCase())
//          .updateData({_item: old_count}),
//
//      Firestore.instance
//          .collection(user)
//          .document('date')
//          .updateData({_inventory.toLowerCase(): edited_date}),
//          exit
//
//    }


//        :


//    {
//      Firestore.instancefz
//          .collection(user)
//          .document(_inventory.toLowerCase())
//          .updateData({_item: old_count}),
//      print('new field'),
//      Firestore.instance
//          .collection(user)
//          .document('date')
//          .updateData({_inventory.toLowerCase(): edited_date}),
//       exit
//    }

//    );




    DateTime today = new DateTime.now();
    //edited_date ="${today.year.toString()}-${today.month.toString().padLeft(2,'0')}-${today.day.toString().padLeft(2,'0')}";
    edited_date = today.toString().substring(0, 19);
//    print(edited_date);


//  print(inventItems);

    new Future.delayed(const Duration(milliseconds: 500),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => Invent()))
    );


//    Navigator.pushReplacement(context,
//        MaterialPageRoute(builder: (context) => Invent()));

//    setState(() {
//      formShow = false;
//    });


  }

  increment() {
    setState(() {
      old_count = old_count + 1;
    });
  }

  decrement() {
    if (old_count <= 0) {
      // ignore: unnecessary_statements
      Fluttertoast.showToast(
          msg: "Count cannot be less than 0",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: globals.night ? Color(0xff0392cf) : Color(0xff141d26),
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

    if(_inventory == "New brand .."){
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

    setState(() {
      formShow = false;
    });


  }

  Widget _buildName() {
    return null;
  }

  @override
  Widget build(BuildContext context) {

    Future<List> _calculation = Future<List>.delayed(
      Duration(milliseconds: 100),
          () => inventItems,
    );

    Future<List> _items = Future<List>.delayed(
      Duration(seconds: 0),
          () => items,
    );


//    Future.delayed(Duration(seconds: 0), () => print(items));

//    getInvent();

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child:

      SingleChildScrollView(
        child: Column(
            children: <Widget>[

              SizedBox(height: 20,),

             Form(
                key: _formKey,


                child: SingleChildScrollView(

                  child: Column(

                    children : <Widget>[
                      SingleChildScrollView(

                      child: Card(
                        color: (!globals.night) ? Color(0xff141d26) : Color(0xfffdf498),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: <Widget>[

//                          SizedBox(height: 20,),

                              Material(
                                color: (!globals.night) ? Color(0xff141d26) : Color(0xfffdf498),
                                child :DefaultTextStyle(
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .headline2,
                                  textAlign: TextAlign.center,
                                  child: FutureBuilder<List>(
                                    future: _calculation,
                                    builder:
                                        (BuildContext context, AsyncSnapshot<List> snapshot) {
                                      List children;
                                      if (snapshot.hasData) {
                                        children = <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(20),
                                            child: Theme(
                                              data: Theme.of(context).copyWith(
                                                  canvasColor: (!globals.night) ? Color(0xff243447) : Color(0xff0392cf)
                                              ),
                                              child: DropdownButton(
                                                hint: _dropDownValue == null
                                                    ? Text('Show Brands', style: TextStyle(color: (!globals.night) ? Color(0xffffffff) : Color(0xff4a4e4d)))
                                                    : Text(
                                                  _dropDownValue,
                                                  style: TextStyle(color: (!globals.night) ? Color(0xffffffff) : Color(0xff4a4e4d)),
                                                ),
                                                isExpanded: true,
                                                iconSize: 30.0,
                                                style: TextStyle(color: Colors.white),
                                                items: snapshot.data.map(
                                                      (val) {
                                                    return DropdownMenuItem<String>(
                                                      value: val,
                                                      child: Text(val),
                                                      onTap: () {
                                                        _inventory = val;
                                                        item();
                                                      },
                                                    );
                                                  },
                                                ).toList(),
                                                onChanged: (val) {
                                                  setState(
                                                        () {
                                                      _dropDownValue = val;
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          )
                                        ];
                                      } else if (snapshot.hasError) {
                                        children = <Widget>[
                                          Icon(
                                            Icons.error_outline,
                                            color: (!globals.night) ? Color(0xffffffff) : Color(0xff4a4e4d),
                                            size: 60,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 16),
                                            child: Text('Error: ${snapshot.error}'),
                                          )
                                        ];
                                      } else {
                                        children = <Widget>[
                                          SizedBox(
                                            child: CircularProgressIndicator(
                                              valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                                            ),
                                            width: 40,
                                            height: 40,
                                          ),

                                        ];
                                      }
                                      return Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: children,
                                        ),
                                      );
                                    },
                                  ),
                                ),

                              ),

//                          SizedBox(height: 10),

                              Material(
                                color: (!globals.night) ? Color(0xff141d26) : Color(0xfffdf498),
                                child:
                                DefaultTextStyle(
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .headline2,
                                  textAlign: TextAlign.center,
                                  child: FutureBuilder(
                                    future: _items,
                                    builder:
                                        (BuildContext context, AsyncSnapshot<List> snapshot) {
                                      List children;
                                      if (idata) {
                                        children = <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(20),
                                            child: Theme(
                                              data: Theme.of(context).copyWith(
                                                  canvasColor: (!globals.night) ? Color(0xff243447) : Color(0xff0392cf)
                                              ),
                                              child: DropdownButton(
                                                hint: _dropDown == 'items'
                                                    ? null
                                                    : Text(
                                                  _dropDown,
                                                  style: TextStyle(color: (!globals.night) ? Color(0xffffffff) : Color(0xff4a4e4d)),
                                                ),
                                                isExpanded: true,
                                                iconSize: 30.0,
                                                style: TextStyle(color: Colors.white),
                                                items: snapshot.data.map(
                                                      (val) {
                                                    return DropdownMenuItem<String>(
                                                      value: val,
                                                      child: Text(val),
                                                      onTap: () {
                                                        _item = val;
                                                        count();
                                                      },
                                                    );
                                                  },
                                                ).toList(),
                                                onChanged: (val) {
                                                  setState(
                                                        () {
                                                      _dropDown = val;
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          )
                                        ];
                                      } else if (snapshot.hasError) {
                                        children = <Widget>[
                                          Icon(
                                            Icons.error_outline,
                                            color: Colors.red,
                                            size: 60,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 16),
                                            child: Text('Error: ${snapshot.error}'),
                                          )
                                        ];
                                      } else {
                                        children = <Widget>[
                                          SizedBox(
                                            height: 5,
                                          ),
//                          const Padding(
//                            padding: EdgeInsets.only(top: 16),
//                            child: Text('Awaiting result...'),
//                          )
                                        ];
                                      }
                                      return Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: children,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
//                          SizedBox(height: 20,),

//                Material(
//                  child: TextFormField(
//                    decoration: InputDecoration(
//                      labelText: 'Item',
//                      filled: true,
//                    ),
//                    // ignore: missing_return
////                    validator: (String value){
////                      if(value.isEmpty) return 'Item is Required';
////                    },
//                    onSaved: (String value) {
//                      _item = value;
//                    },
//                  ),
//                ),

                              Material(
                                color: (!globals.night) ? Color(0xff141d26) : Color(0xfffdf498),
                                child: ( _form1 == false ? null: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: TextFormField(
                                    cursorColor: (!globals.night) ? Color(0xffffffff) : Color(0xff4a4e4d),

                                    style: TextStyle(
                                      color: (!globals.night) ? Color(0xffffffff) : Color(0xff4a4e4d),
                                    ),


                                    decoration: InputDecoration(
                                      labelText: 'Brand Name',
                                      labelStyle: TextStyle(
                                          color:  (!globals.night) ? Color(0xffffffff) : Color(0xff4a4e4d)
                                    ),
                                      filled: true,
                                      fillColor:  (!globals.night) ? Color(0xff141d26) : Color(0xfffdf498),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: (!globals.night) ? Color(0xffffffff) : Color(0xff4a4e4d)),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color:(!globals.night) ? Color(0xffffffff) : Color(0xff4a4e4d)),
                                      ),
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide(color: (!globals.night) ? Color(0xffffffff) : Color(0xff4a4e4d)),
                                      ),
                                    ),
                                    // ignore: missing_return
                                    validator: (String value) {
                                      if (value.isEmpty) return 'Brand is Required';
                                    },
                                    onSaved: (String value) {
                                      _inventory = value;
                                    },
                                  ),
                                )
                                ),
                              ),


//                RawMaterialButton(
//                  onPressed: () {
//                    newItem();
//                  },
//                  elevation: 2.0,
//                  fillColor: Colors.white,
//                  child: Icon(
//                    Icons.add,
//                    size: 20.0,
//                  ),
//                  padding: EdgeInsets.all(5.0),
//                  shape: CircleBorder(),
//                ),



                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Material(
                                    color:( !globals.night) ? Color(0xff141d26) : Color(0xfffdf498),
                                    child: (_form2 == false ? null :TextFormField(
                                      cursorColor: (!globals.night) ? Color(0xffffffff) : Color(0xff4a4e4d),

                                      style: TextStyle(
                                        color: (!globals.night) ? Color(0xffffffff) : Color(0xff4a4e4d),
                                      ),

                                      decoration: InputDecoration(
                                        labelText: 'Item Name',
                                        labelStyle: TextStyle(
                                            color: (!globals.night) ? Color(0xffffffff) : Color(0xff4a4e4d)
                                        ),
                                        fillColor:(!globals.night) ? Color(0xff141d26) : Color(0xfffdf498),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: (!globals.night) ? Color(0xffffffff) : Color(0xff4a4e4d)),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: (!globals.night) ? Color(0xffffffff) : Color(0xff4a4e4d)),
                                        ),
                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide(color: (!globals.night) ? Color(0xffffffff) : Color(0xff4a4e4d)),
                                        ),
                                        filled: true,
                                      ),
                                      // ignore: missing_return
//                    validator: (String value){
//                      if(value.isEmpty) return 'Item is Required';
//                    },
                                      onSaved: (String value) {
                                        _item = value;
                                      },
                                    )
                                    )
                                ),
                              ),
//                          SizedBox(height: 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  RawMaterialButton(
                                    onPressed: () {
                                      decrement();
                                    },
                                    elevation: 2.0,
                                    fillColor: (!globals.night) ? Color(0xff243447) : Color(0xff0392cf),

                                    child: Icon(
                                      Icons.remove,
                                      size: 20.0,
                                      color: Colors.white,
                                    ),
                                    padding: EdgeInsets.all(5.0),
                                    shape: CircleBorder(),
                                  ),
                                  Text(
                                    'Current count : ' + old_count.toString(),
                                    style: TextStyle(color: (!globals.night) ? Color(0xffffffff) : Color(0xff4a4e4d), fontSize: 16),
                                  ),
                                  RawMaterialButton(
                                    onPressed: () {
                                      increment();
                                    },
                                    elevation: 2.0,
                                    fillColor: (!globals.night) ? Color(0xff243447) : Color(0xff0392cf),
                                    child: Icon(
                                      Icons.add,
                                      size: 20.0,
                                      color: Colors.white,
                                    ),
                                    padding: EdgeInsets.all(5.0),
                                    shape: CircleBorder(),
                                  ),
                                ],
                              ),
                              SizedBox(height: 40),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  RaisedButton(
                                    color: (!globals.night) ? Color(0xff243447) : Color(0xff0392cf),
                                    child: Text(
                                      'Add item',
                                      style: TextStyle(color: Colors.white, fontSize: 16),
                                    ),
                                    onPressed: () {
                                      if (!_formKey.currentState.validate()) {
                                        return;
                                      }

                                      _formKey.currentState.save();

                                      if (_item.toString() == "") {
                                        Scaffold.of(context).showSnackBar(SnackBar(
                                          content: Text("Please enter the item!!"),
                                        ));
                                      }

                                      write();
                                      _formKey.currentState.reset();
                                    },
                                  ),
                                  RaisedButton(
                                    color:(!globals.night) ? Color(0xff243447) : Color(0xff0392cf),
                                    child: Text(
                                      ' Delete ',
                                      style: TextStyle(color: Colors.white, fontSize: 16),
                                    ),
                                    onPressed: () {
                                      if (!_formKey.currentState.validate()) {
                                        return;
                                      }
                                      _formKey.currentState.save();
                                      delete();
                                      drop();
                                      _formKey.currentState.reset();
                                    },
                                  ),
                                ],
                              ),
                            SizedBox(height: 20),
//
//
//                          SizedBox(height: 20),


                            ],
                          ),
                        ),
                      ),
                    ),
        ]
                  ),
                )),
//          ],
//        )

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


],

        ),
      ),
    );


  }
}

