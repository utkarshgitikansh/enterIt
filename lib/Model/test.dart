import 'dart:io';

import 'package:enterit/Model/card.dart';
import 'package:enterit/main.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {

  TabController controller;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var DBRef = Firestore.instance.collection('items').snapshots();

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

  List a = ["New inventory .."];

  bool idata = false;
  bool _form1 = false;
  bool _form2 = false;
  bool _form3 = false;

  @override
  void initState() {

    // ignore: invalid_use_of_protected_member
    (context as Element).reassemble();

    Firestore.instance.collection('inventory').snapshots().listen((data) =>
        data.documents.forEach((doc) => inventItems.add(doc.documentID)));

//    getInvent();
    Future<List> _invent = Future<List>.delayed(
      Duration(seconds: 0),
          () => inventItems,
    );

    print('init state');
    super.initState();
  }

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
        .collection('inventory')
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
        .collection('inventory')
        .document(_inventory)
        .get()
        .then((DocumentSnapshot ds) {
      if (ds.exists) {
        print('exists');

      } else
        // add a new item

        Firestore.instance
            .collection('inventory')
            .document(_inventory.toLowerCase())
            .setData({_item.toLowerCase(): _count});

      Firestore.instance
          .collection('record')
          .document('date')
          .updateData({_inventory.toLowerCase(): edited_date});

    });

    Firestore.instance
        .collection('inventory')
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
          .collection('inventory')
          .document(_inventory.toLowerCase())
          .updateData({_item: old_count}),
      Firestore.instance
          .collection('record')
          .document('date')
          .updateData({_inventory.toLowerCase(): edited_date}),
      exitCode
    }
        : {
      Firestore.instance
          .collection('inventory')
          .document(_inventory.toLowerCase())
          .updateData({_item: old_count}),
      print('new field'),
      Firestore.instance
          .collection('record')
          .document('date')
          .updateData({_inventory.toLowerCase(): edited_date}),

    });

    DateTime today = new DateTime.now();
    //edited_date ="${today.year.toString()}-${today.month.toString().padLeft(2,'0')}-${today.day.toString().padLeft(2,'0')}";
    edited_date = today.toString().substring(0, 19);
//    print(edited_date);


//  print(inventItems);

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Home()));

  }

  increment() {
    setState(() {
      old_count = old_count + 1;
    });
  }

  decrement() {
    if (old_count <= 1) {
      // ignore: unnecessary_statements
      showAlertDialog(context);
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

    idata =  false;
    _form1 = false;
    _form2 = false;

    setState(() {
      items = [];
      old_count = 0;
    });

    if(_inventory == "New inventory .."){
      items = ["New item .."];
      _form1 = true;
      _form2 = true;
    }
    else {
      Firestore.instance.collection('inventory').snapshots().listen((data) =>
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
        .collection('inventory')
        .document(_inventory)
        .get()
        .then((DocumentSnapshot ds) {
      // add a new item

      Firestore.instance
          .collection('inventory')
          .document(_inventory.toLowerCase())
          .delete();
    });

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Home()));

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

//    getInvent();

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[

                SizedBox(height: 20,),

                Material(
//                  child: TextFormField(
//                    decoration: InputDecoration(
//                      labelText: 'Inventory',
//                      filled: true,
//                    ),
//                    // ignore: missing_return
//                    validator: (String value) {
//                      if (value.isEmpty) return 'Inventory is Required';
//                    },
//                    onSaved: (String value) {
//                      _inventory = value;
//                    },
//                  ),
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
                              child: DropdownButton(
                                hint: _dropDownValue == null
                                    ? Text('Show Inventory')
                                    : Text(
                                  _dropDownValue,
                                  style: TextStyle(color: Colors.blue),
                                ),
                                isExpanded: true,
                                iconSize: 30.0,
                                style: TextStyle(color: Colors.blue),
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
                              child: CircularProgressIndicator(),
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

                SizedBox(height: 10),

                Material(

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
                              child: DropdownButton(
                                hint: _dropDown == null
                                    ? Text('Show Items')
                                    : Text(
                                  _dropDown,
                                  style: TextStyle(color: Colors.blue),
                                ),
                                isExpanded: true,
                                iconSize: 30.0,
                                style: TextStyle(color: Colors.blue),
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
                              child: Text('loading ..'),
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
                SizedBox(height: 20,),

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
                  child: ( _form1 == false ? null: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'New Inventory',
                        filled: true,
                      ),
                      // ignore: missing_return
                      validator: (String value) {
                        if (value.isEmpty) return 'Inventory is Required';
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
                      child: (_form2 == false ? null :TextFormField(
                        decoration: InputDecoration(
                          labelText: 'New Item',
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

//                Material(
//                    child: (_form3 == true ? Text(_item) :TextFormField(
//                      decoration: InputDecoration(
//                        labelText: 'New Item',
//                        filled: true,
//                      ),
//                      // ignore: missing_return
////                    validator: (String value){
////                      if(value.isEmpty) return 'Item is Required';
////                    },
//                      initialValue: _item,
//                      onSaved: (String value) {
//                        _item = value;
//                      },
//                    )
//                    )
//                ),


                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      'Current count :',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ),
                    Text(
                      old_count.toString(),
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RawMaterialButton(
                      onPressed: () {
                        decrement();
                      },
                      elevation: 2.0,
                      fillColor: Colors.white,
                      child: Icon(
                        Icons.remove,
                        size: 20.0,
                      ),
                      padding: EdgeInsets.all(5.0),
                      shape: CircleBorder(),
                    ),
                    Text(
                      old_count.toString(),
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    RawMaterialButton(
                      onPressed: () {
                        increment();
                      },
                      elevation: 2.0,
                      fillColor: Colors.white,
                      child: Icon(
                        Icons.add,
                        size: 20.0,
                      ),
                      padding: EdgeInsets.all(5.0),
                      shape: CircleBorder(),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                      child: Text(
                        'Add item',
                        style: TextStyle(color: Colors.blue, fontSize: 16),
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
                      child: Text(
                        'Delete inventory',
                        style: TextStyle(color: Colors.red, fontSize: 16),
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


                SizedBox(height: 20),


              ],
            ),
          )),
    );
  }
}

