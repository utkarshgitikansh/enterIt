import 'package:enterit/invent.dart';
import 'package:enterit/Model/login.dart';
import 'package:enterit/Model/test.dart';
import 'package:enterit/signup.dart';
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
    with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Start the app with the "/" named route. In this case, the app starts
      // on the FirstScreen widget.
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => Login(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/home': (context) => Invent(),

        '/signup': (context) => Signup(),

      },

    );
  }

}






