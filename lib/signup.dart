import 'package:enterit/invent.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _name;
  String _pwd;
  String _pwdC;
  String edited_date;
  bool _obscureText = true;

  int _count = 0;
  int old_count = 0;
  int pcount;

  List arr = [];

  String name = "";

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }


  signup() {

    Firestore.instance
        .collection('user')
        .document(_name)
        .get()
        .then((DocumentSnapshot ds) {

      if(ds.exists){

        Fluttertoast.showToast(
            msg: "User already exists",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0

        );


      }
      else {
        Firestore.instance
            .collection('user').document(_name)
            .setData({ 'password': _pwd});

        Navigator.pushReplacementNamed(context, '/');
      }

    });

  }



  @override
  Widget build(BuildContext context) {
    return Container(

      child: Scaffold(

          backgroundColor: Colors.brown.shade200,

          body:
          Center(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Form(
                  key: _formKey,

                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            cursorColor: Colors.brown.shade200,

                            style: TextStyle(
                              color: Colors.white,
                            ),


                            decoration: InputDecoration(
                                labelText: 'Username',
                                labelStyle: TextStyle(
                                  color: Colors.brown.shade200,
                                ),
                                filled: true,
                                fillColor: Colors.brown,
                                focusColor: Colors.brown,
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.brown),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.brown),
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.brown),
                              ),
//                              icon: const Padding(
//                                  padding: const EdgeInsets.only(top: 15.0),
//                                  child: const Icon(Icons.person_outline))
                            ),
                            // ignore: missing_return
                            validator: (String value){
                              if(value.isEmpty) return 'Username is Required';
                            },
                            onSaved: (String value) {
                              _name = value;

                            },
                          ),
                        ),


                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            cursorColor: Colors.brown.shade200,

                            style: TextStyle(
                              color: Colors.white,
                            ),


                            decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                  color: Colors.brown.shade200,
                                ),
                                filled: true,
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.brown),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.brown),
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.brown),
                                ),
                                fillColor: Colors.brown
                            ),
                            validator: (val) => val.length < 6 ? 'Password too short.' : null,
                            onSaved: (val) => _pwd = val,
                            obscureText: _obscureText,
                            // ignore: missing_return
//                    validator: (String value){
//                      if(value.isEmpty) return 'Password is Required';
//                    },
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            cursorColor: Colors.brown.shade200,

                            style: TextStyle(
                              color: Colors.white,
                            ),

                            decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                labelStyle: TextStyle(
                                  color: Colors.brown.shade200,
                                ),
                                filled: true,
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.brown),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.brown),
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.brown),
                                ),
                                fillColor: Colors.brown
                            ),
                            // ignore: unrelated_type_equality_checks
                            //validator: (val) => val != _pwd ? 'Password dont match.' : null,
                            onSaved: (val) => _pwdC = val,
                            obscureText: _obscureText,
                            // ignore: missing_return
//                    validator: (String value){
//                      if(value.isEmpty) return 'Password is Required';
//                    },
                          ),
                        ),


                        SizedBox(height: 20),

                        SizedBox(height: 20),

                        SizedBox(height: 20),


                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[

                            RaisedButton(
                              color: Colors.brown,
                              child: Text(
                                'Submit',
                                style: TextStyle(
                                    color: Colors.brown.shade200,
                                    fontSize: 16
                                ),
                              ),
                              onPressed: () {
                                if(!_formKey.currentState.validate()){
                                  return;
                                }
                                _formKey.currentState.save();
                                if(_pwd != _pwdC) {
                                  Fluttertoast.showToast(
                                      msg: "Passwords don't match",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.black,
                                      textColor: Colors.white,
                                      fontSize: 16.0

                                  );
                                }
                                else {
                                  signup();
                                  _formKey.currentState.reset();
                                }
                              },
                            ),


                          ],
                        ),



                        SizedBox(height: 30),

                        new Center(
                          child: new InkWell(
                              child: new Text('Back to login',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.brown,
                                ),),

                              onTap: () => Navigator.pushReplacementNamed(context, '/')
                          ),
                        ),

                      ],

                    ),
                  )
              ),
            ),
          )
      ),
    );
  }
}
