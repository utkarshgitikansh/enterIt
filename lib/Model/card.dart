import 'package:flutter/material.dart';

class InCard extends StatefulWidget {
  @override
  _InCardState createState() => _InCardState();

  final String item_title;
  final String item_subtitle;
  InCard ({ Key key, this.item_title, this.item_subtitle });

}

class _InCardState extends State<InCard> {


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Colors.brown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
             ListTile(
              leading: Icon(Icons.assignment_turned_in,  color: Colors.brown.shade200),
              title: Text(widget.item_title.toString(), style: TextStyle(color: Colors.brown.shade200),),
              subtitle: Text(widget.item_subtitle.toString(), style: TextStyle(color: Colors.brown.shade200)),
            ),
//            ButtonBar(
//              children: <Widget>[
//                FlatButton(
//                  child: const Text('BUY TICKETS'),
//                  onPressed: () { /* ... */ },
//                ),
//                FlatButton(
//                  child: const Text('LISTEN'),
//                  onPressed: () { /* ... */ },
//                ),
//              ],
//            ),
          ],
        ),
      ),
    );
  }
}
