import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enterit/Model/card.dart';

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
    return Container(
      child: Center(
        child: Card(
          child:   StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('record').snapshots() ,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                  print(snapshot.data.documents.map((e) =>
//                      print(e.data.keys.toList()),
//                  ));
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting: return new Text('Loading...');
                default:

                  return new ListView(

                    // ignore: missing_return
                    children: snapshot.data.documents.map((DocumentSnapshot document) {


                      list = [];
                      list1 = [];
                      list2 = [];
                      list3 = [];

                      for (int i = 0; i < document.data.length; i++) {
                        list.add(document.data.keys.elementAt(i));
                      }

                      for (int i = 0; i < document.data.length; i++) {
                        list1.add(i);
                      }

                      for (int i = 0; i < document.data.length; i++) {
                        list2.add(document.data.values.elementAt(i));
                      }


                      for (int i = 0; i < document.data.length; i++) {
                        list3.add( InCard(item_title: list[i].toString(), item_subtitle: list2[i].toString()));

                      }

                        return new Column(children: list1.map((item) => new Card(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                               ListTile(
                                leading: Icon(Icons.update),
                                title: Text(list.elementAt(item)),
                                subtitle: Text('Last updated on : ' + list2.elementAt(item)),
                              ),
                            ],
                          ),
                        )).toList());


                      }).toList(),



                  );

              }
            },
          ),


        ),
      ),
    );
  }
}
