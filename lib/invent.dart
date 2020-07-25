import 'dart:io';

import 'package:enterit/Model/test.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
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
import 'package:string_validator/string_validator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:toggle_switch/toggle_switch.dart';

class Invent extends StatefulWidget {
  String value;

  Invent({Key key, this.value}) : super(key: key);

  @override
  _InventState createState() => _InventState();
}

class Post {
  final String title;
  final String description;

  Post(this.title, this.description);
}

class VagasDisponivei {
  String v_n;
  String v_id;

  VagasDisponivei({this.v_n, this.v_id});

  @override
  String toString() {
    return '${v_n} ${v_id}';
  }
}

class _InventState extends State<Invent> with SingleTickerProviderStateMixin {
  TabController controller;

  List<VagasDisponivei> _vagasDisponiveis;
  String vaga_name;
  int _counter = 0;
  int check = 1;

  String value;
  String filter;
  int old_count;
  List docs = [0, 1];
  final DBRef = Firestore.instance.collection('items');

  @override
  void initState() {
    super.initState();

    _vagasDisponiveis = [
      VagasDisponivei(v_id: "1", v_n: "A0001"),
      VagasDisponivei(v_id: "2", v_n: "A0002"),
      VagasDisponivei(v_id: "3", v_n: "A0003"),
      VagasDisponivei(v_id: "4", v_n: "A0004"),
      VagasDisponivei(v_id: "5", v_n: "A0005"),
      VagasDisponivei(v_id: "6", v_n: "A0006"),
      VagasDisponivei(v_id: "7", v_n: "A0007"),
      VagasDisponivei(v_id: "8", v_n: "A0008"),
      VagasDisponivei(v_id: "9", v_n: "A0009"),
      VagasDisponivei(v_id: "10", v_n: "A0010"),
    ];

    controller = new TabController(length: 3, vsync: this);

    print(globals.isLoggedIn);

    DateTime today = new DateTime.now();
    globals.loginTime = today.toString().substring(0, 19);

//    print(user);

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

  count() {
    var match = 'New item ..';

    _form2 = false;

    if (_item == "New item ..") {
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
              ds.data.values.elementAt(ds.data.keys.toList().indexOf(_item));
        });
        print(old_count);
      } else
        exitCode;
    });

    items.add("New item ..");
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
  VagasDisponivei selectedValue;

  // ignore: non_constant_identifier_names
  String search_text = 'try';

  int _count = 1;
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

    Firestore.instance.collection(user).document(_inventory).snapshots().listen(
        (data) => data.data.keys.toList().indexOf(_item) >= 0 &&
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

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Invent()));
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
          backgroundColor: globals.night ? Color(0xff0392cf) : Color(0xff141d26),
          textColor: Colors.white,
//          Colors.brown.shade200,
          fontSize: 16.0);
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

    idata = false;
    _form1 = false;
    _form2 = false;

    setState(() {
      items = [];
      old_count = 0;
    });

    if (_inventory == "New inventory ..") {
      items = [];
      _form1 = true;
      _form2 = true;
      _dropDown = "No items yet";
    } else {
      Firestore.instance
          .collection(user)
          .snapshots()
          .listen((data) => data.documents.forEach((doc) => {
                if (doc.documentID == _inventory)
                  {
                    setState(() {
                      items = doc.data.keys.toList();
                    }),
                    items.add("New item ..")
                  }
              }));
    }
    Future<List>.delayed(
      Duration(seconds: 0),
      () => setItem(),
    );
  }

  setItem() {
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

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Invent()));
  }

  test_alert() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              content: Column(
            children: <Widget>[
              new SearchableDropdown(
                hint: Text('Select Items'),
                items: _vagasDisponiveis.map((item) {
                  return new DropdownMenuItem<VagasDisponivei>(
                      child: Text(item.v_n), value: item);
                }).toList(),
                isExpanded: true,
                value: selectedValue,
//                    isCaseSensitiveSearch: true,
                searchHint: new Text(
                  'Select ',
                  style: new TextStyle(fontSize: 20),
                ),
                onChanged: (value) {
                  setState(() {
                    selectedValue = value;
                    print(selectedValue.v_n);
                  });
                },
              ),
              selectedValue == null ? Text('test') : Text(selectedValue.v_n)
            ],
          ));
        });
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

    globals.filter = inventItems;

    Future.delayed(Duration(seconds: 2), () => print(items));

    String selectedValue;

    return Scaffold(
      backgroundColor: (!globals.night) ? Color(0xff243447) : Color(0xffffffff) ,
//      Colors.brown.shade200,

      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Text(
                'EnterIt',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    fontFamily: 'Bradley'),
              ),
            ],
          ),
        ),
        centerTitle: true,
        backgroundColor: globals.night ? Color(0xff0392cf) : Color(0xff141d26),
//        Color(0xff051e3e),
//        Color(0xFF54B1F3),
//        Colors.brown,
//
//        actions: <Widget>[
//          // action button
//          IconButton(
//            color: Colors.white,
//            icon: Icon(Icons.search),
//            onPressed: () {
//              showDialog(
//                  context: context,
//                  builder: (context) {
//                    return AlertDialog(
//                      content:
//                    );
//
//                  });
//            },
//          ),
//        ],

        bottom: new TabBar(
          labelColor: Colors.white,
//          Colors.brown.shade200,
          indicatorColor: Colors.white,
//          Colors.brown.shade200,
          controller: controller,
          tabs: <Widget>[
            new Tab(
              icon: new Icon(Icons.collections),
              text: 'Inventory',
            ),
            new Tab(
              icon: new Icon(Icons.library_add),
              text: 'Update',
            ),
            new Tab(
              icon: new Icon(Icons.person),
              text: 'Profile',
            ),
          ],
        ),
      ),
      body: new TabBarView(
        controller: controller,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: <Widget>[
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SearchPage(),
                  ),
                )
              ],
            ),
          ),

          AddForm(),
          //  Test(),
          Logs(),
        ],
      ),

//      bottomNavigationBar:

//        Container(
//          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
//          color: Color(0xff008744),
//          child: Padding(
//          padding: EdgeInsets.all(5.0),
//          child: Text('EnterIt', style: TextStyle(
//              color: Colors.white,
//              fontWeight: FontWeight.bold,
//              fontSize: 40,
//              fontFamily: 'Bradley'
//          ),),
//        ),
//        ),

      floatingActionButton:

      FloatingActionButton(
        backgroundColor: globals.night ? Color(0xff0392cf) : Color(0xff141d26),
        child: IconButton(
          color: Colors.white,
          icon: (!globals.night) ? Icon(Icons.wb_sunny) : Icon(Icons.brightness_3),
          onPressed: () {
//            Navigator.pushReplacementNamed(context, '/');
            setState(() {
                globals.night = !globals.night;
            });
          },
        ),
      ),
    );
  }
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String filter;
  int check;

  Future getPosts() async {
    var firestore = Firestore.instance;

    QuerySnapshot qw =
        await firestore.collection(globals.isLoggedIn).getDocuments();

    return qw.documents;
  }

  @override
  Widget build(BuildContext context) {
    Widget list;

//    Firestore.instance
//        .collection(globals.isLoggedIn)
//        .document("ghee".toLowerCase())
//        .get()
//        .then((DocumentSnapshot ds) {
//      if (ds.documentID == globals.filter) {
//      } else {}
//    });

    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              cursorColor: (!globals.night) ? Color(0xffffffff) : Color(0xff4a4e4d),

              style: TextStyle(
                color: (!globals.night) ? Color(0xffffffff) : Color(0xff4a4e4d),
              ),
//              cursorColor:(!globals.night) ? Color(0xffffffff) : Color(0xff4a4e4d))),
              decoration: InputDecoration(
                  icon: Icon(Icons.search, color: (!globals.night) ? Color(0xffffffff) : Color(0xff4a4e4d),), hintText: 'Search Brands..', hintStyle: TextStyle(color: (!globals.night) ? Color(0xffffffff) : Color(0xff4a4e4d)),
                labelStyle: TextStyle(
                    color:  (!globals.night) ? Color(0xffffffff) : Color(0xff4a4e4d)
                ),
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
              onChanged: (text) {
                text = text.toLowerCase();
                print(text);
                setState(() {
                  globals.brand = text;
                });
              },
            ),
          ),
//          (globals.filter.contains(globals.brand)
          (1 == 1
              ? Container(
                  child: Flexible(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance
                        .collection(globals.isLoggedIn)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError)
                        return new Text('Error: ${snapshot.error}');
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Center(
                              child: CircularProgressIndicator(
                            valueColor:
                                new AlwaysStoppedAnimation<Color>(Colors.brown),
                          ));
                        default:
                          return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ListView(
                                // ignore: missing_return
                                children: snapshot.data.documents
                                    // ignore: missing_return
                                    .map((DocumentSnapshot document) {
                                  List list = [];
                                  String listItem = document.documentID;

                                  if (listItem == 'date') {
                                    return Text('');
                                  }

                                  for (int i = 0;
                                      i < document.data.length;
                                      i++) {
                                    list.add("✔  " +
                                        document.data.keys.elementAt(i) +
                                        "  :  " +
                                        document.data.values
                                            .elementAt(i)
                                            .toString() +
                                        "\n");
                                  }

                                  List list2 = [];

                                  for (int i = 0;
                                      i < document.data.length;
                                      i++) {
                                    list2
                                        .add(document.data.values.elementAt(i));
                                  }

                                  if (document.documentID
                                      .trim()
                                      .contains(globals.brand)) {
                                    return Center(
                                      child: Container(
                                        child: Column(
                                          children: <Widget>[
                                            Card(
                                              color: (!globals.night) ? Color(0xff141d26) : Color(0xfffdf498),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    ListTile(
//                                          leading: Icon(Icons.assignment_turned_in, color: Colors.brown.shade200,),
                                                      title: Text(
                                                          listItem + '\n',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900,
                                                              color: (!globals.night) ? Color(0xffffffff) : Color(0xff4a4e4d))),
//                                      Color(0xFFA6A283))),
//                                      Colors.brown.shade200)),
                                                      subtitle: Text(
                                                          list
                                                              .toString()
                                                              .replaceAll(
                                                                  '[', " ")
//                                          .replaceAll('[', "")
                                                              .replaceAll(
                                                                  ']', "")
                                                              .replaceAll(
                                                                  ',', "\n"),
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: (!globals.night) ? Color(0xffffffff) : Color(0xff4a4e4d))),
//                                      Colors.brown.shade200)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  } else {
                                    return new Container();
                                  }

//                              return new InCard(item_title: listItem,
////                        document.documentID,
//                                item_subtitle: list.toString()
//                                    .replaceAll('[', "")
//                                    .replaceAll(']', "")
//                                    .replaceAll(',', "   |  "),
//
//                              );
                                }).toList(),
                              ));
                      }
                    },
                  ),
                ))
              : Container(
                  child: Flexible(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance
                        .collection(globals.isLoggedIn)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError)
                        return new Text('Error: ${snapshot.error}');
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Center(
                              child: CircularProgressIndicator(
                            valueColor:
                                new AlwaysStoppedAnimation<Color>(Colors.brown),
                          ));
                        default:
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: new ListView(
// ignore: missing_return
                              children: snapshot.data.documents
                                  .map((DocumentSnapshot document) {
                                List list = [];
                                String listItem = document.documentID;

                                if (listItem == 'date') {
                                  return Text('');
                                }

                                for (int i = 0; i < document.data.length; i++) {
                                  list.add("✔  " +
                                      document.data.keys.elementAt(i) +
                                      "  :  " +
                                      document.data.values
                                          .elementAt(i)
                                          .toString() +
                                      "\n");
                                }

                                List list2 = [];

                                for (int i = 0; i < document.data.length; i++) {
                                  list2.add(document.data.values.elementAt(i));
                                }

                                return Center(
                                  child: Container(
//                                  height: 100,//0xffB0C5C6  0xff54B1F3
                                    child: Column(
                                      children: <Widget>[
                                        Card(
                                          color: Color(0xfffdf498),
//008744  ffa700
//                                Color(0xFFafd275)
//                              Color(0xffFDEFCC),
//                              Colors.brown,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                ListTile(
//                                          leading: Icon(Icons.assignment_turned_in, color: Colors.brown.shade200,),
                                                  title: Text(listItem + '\n',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          color: Color(
                                                              0xff4a4e4d))),
//                                      Color(0xFFA6A283))),
//                                      Colors.brown.shade200)),
                                                  subtitle: Text(
                                                      list
                                                          .toString()
                                                          .replaceAll('[', " ")
//                                          .replaceAll('[', "")
                                                          .replaceAll(']', "")
                                                          .replaceAll(
                                                              ',', "\n"),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Color(
                                                              0xff4a4e4d))),
//                                      Colors.brown.shade200)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
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
                )))
        ],
      ),
    );
  }
}

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  int check = 0;
  String filter;

  Future getPosts() async {
    var firestore = Firestore.instance;

    QuerySnapshot qw = await firestore.collection("user").getDocuments();

    return qw.documents;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        // ignore: missing_return
        future: getPosts(),
        // ignore: missing_return
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Text("Loading..."),
            );
          } else {
            return ListView.builder(
                itemCount: snapshot.data.length,
                // ignore: missing_return
                itemBuilder: (_, index) {
                  return ListTile(
                      title: Text(snapshot.data[index].data["password"])
//            title: Text(index.toString())

                      );
                });
          }
        },
      ),
    );
  }
}
