import 'package:enterit/Model/card.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class InventForm extends StatefulWidget {

  @override
  _InventFormState createState() => _InventFormState();

}


class _InventFormState extends State<InventForm> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var DBRef = Firestore.instance.collection('items').snapshots();

  String _name;


  write() {

  int val, newVal = 0;
  bool set = false;

  // increment count by 1

  Firestore.instance
      .collection('inventory')
      .document('stationery')
      .get()
      .then((DocumentSnapshot ds) {

    Firestore.instance.collection('inventory').document('stationery')
        .setData({ 'pens': ds['pens'] + 1 });

  });


  // display count

    Firestore.instance
        .collection('inventory')
        .where("pens")
        .snapshots()
        .listen((data) =>
        data.documents.forEach((doc) => print(doc["pens"])));



  }

  Widget _buildName() {
    return null;
  }


  @override
  Widget build(BuildContext context) {

    List inventItems =[];

    Firestore.instance
        .collection('inventory')
        .snapshots()
        .listen((data) =>
        data.documents.forEach((doc) => inventItems.add(doc.documentID))
    );

    Future getInvent()
    async {
     return new Future.delayed(Duration(seconds: 1), () =>
      inventItems
      );
    }


    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Form(
              key: _formKey,

                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                  Material(
                    child:
                    FutureBuilder(
                      future: getInvent(),
                      builder: (context, snapshot){
                        if(snapshot.data!= null){
                            return new InCard(item_title: snapshot.data[1],item_subtitle: snapshot.data[1]);
                             }
                        return CircularProgressIndicator();
                      },

                    ),


//                    TextFormField(
//                    decoration: InputDecoration(
//                      labelText: 'Pen',
//                      filled: true,),
//                    // ignore: missing_return
//                    validator: (String value){
//                      if(value.isEmpty) return 'Pen is Required';
//                    },
//                    onSaved: (String value) {
//                      _name = value;
//
//                    },
//              ),
                  ),

                      SizedBox(height: 10),

                      RaisedButton(
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16
                          ),
                        ),
                        onPressed: () {
                          if(!_formKey.currentState.validate()){
                            return;
                          }
                          _formKey.currentState.save();
                          write();
                          _formKey.currentState.reset();
                          print(_name);
                        },
                      )
                    ],

              ),
                )
          ),
    );
  }
}
