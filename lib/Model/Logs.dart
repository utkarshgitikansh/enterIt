import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enterit/Model/card.dart';
import 'package:enterit/Model/globals.dart' as globals;


class Logs extends StatefulWidget {
  @override
  _LogsState createState() => _LogsState();

  final String item_title;
  final String item_subtitle;
  Logs ({ Key key, this.item_title, this.item_subtitle });

}

class _LogsState extends State<Logs> {

  List list = [];
  List list1 = [];
  List list2 = [];
  List<Widget> list3 = [];

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
                leading: Icon(Icons.account_circle,  color: Color(0xff4a4e4d),),
                title: Text('Customer', style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xff4a4e4d))),
                subtitle: Text(globals.isLoggedIn, style: TextStyle(color: Color(0xff4a4e4d)))
            ),
            ListTile(
                leading: Icon(Icons.access_time,  color: Color(0xff4a4e4d)),
                title: Text('Last login', style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xff4a4e4d))),
                subtitle: Text(globals.loginTime, style: TextStyle(color: Color(0xff4a4e4d)))
            ),
//        ListTile(
//            leading: Icon(Icons.access_time),
//            title: Text('Validity'),
//            subtitle: Text(documentFields['trial'].toString() + " days")
//        ),

            SizedBox(height: 50),

            RaisedButton(
              color: Color(0xff0392cf),
              child: Text(
                'Log out',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16
                ),
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/');
              },
            ),



//                            ButtonBar(
//                              children: <Widget>[
//                                FlatButton(
//                                  child: const Text('BUY TICKETS'),
//                                  onPressed: () { /* ... */ },
//                                ),
//
//                              ],
//                            ),
          ],
        ),
      ),
//      bottomNavigationBar: Container(
//
//          margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
//
//          child: Text('@utkarshgitikansh', textAlign: TextAlign.center,  style: TextStyle(color: Colors.brown, fontSize: 16),)
//
//      ),

    );

//    return Container(
//      child: Center(
//        child: Card(
//          child:   StreamBuilder<QuerySnapshot>(
//            stream: Firestore.instance.collection('paul').snapshots() ,
//            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
////                  print(snapshot.data.documents.map((e) =>
////                      print(e.data.keys.toList()),
////                  ));
//              if (snapshot.hasError)
//                return new Text('Error: ${snapshot.error}');
//              switch (snapshot.connectionState) {
//                case ConnectionState.waiting: return new Text('Loading...');
//                default:
//
//                  return Padding(
//                    padding: const EdgeInsets.all(10.0),
//                    child: new ListView(
//
//                      // ignore: missing_return
//                      children: snapshot.data.documents.map((DocumentSnapshot document) {
//
//
//                        list = [];
//                        list1 = [];
//                        list2 = [];
//                        list3 = [];
//
//                        for (int i = 0; i < document.data.length; i++) {
//                          list.add(document.data.keys.elementAt(i));
//                        }
//
//                        for (int i = 0; i < document.data.length; i++) {
//                          list1.add(i);
//                        }
//
//                        for (int i = 0; i < document.data.length; i++) {
//                          list2.add(document.data.values.elementAt(i));
//                        }
//
//
//                        for (int i = 0; i < document.data.length; i++) {
//                          list3.add( InCard(item_title: list[i].toString(), item_subtitle: list2[i].toString()));
//
//                        }
//
//                          return new Column(children: list1.map((item) => new Card(
//                            child: Column(
//                              mainAxisSize: MainAxisSize.min,
//                              children: <Widget>[
//                                 ListTile(
//                                  leading: Icon(Icons.update),
//                                  title: Text(list.elementAt(item)),
//                                  subtitle: Text('Last updated on : ' + list2.elementAt(item).toString()),
//                                ),
//                              ],
//                            ),
//                          )).toList());
//
//
//                        }).toList(),
//
//
//
//                    ),
//                  );
//
//              }
//            },
//          ),
//
//
//        ),
//      ),
//    );
  }
}
