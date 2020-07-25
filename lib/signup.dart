import 'package:enterit/invent.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:enterit/Model/globals.dart' as globals;

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
            backgroundColor: globals.night ? Color(0xff0392cf) : Color(0xff141d26),
            textColor: Colors.white,
            fontSize: 16.0

        );


      }
      else {
        Firestore.instance
            .collection('user').document(_name)
            .setData({ 'password': _pwd});

        Fluttertoast.showToast(
            msg: "Welcome to enterIt. Please login",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: globals.night ? Color(0xff0392cf) : Color(0xff141d26),
            textColor: Colors.white,
            fontSize: 16.0

        );


        Navigator.pushReplacementNamed(context, '/');
      }

    });

  }



  @override
  Widget build(BuildContext context) {
    return Container(

      child: Scaffold(

          backgroundColor: Colors.white,

          body:
          Center(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Form(
                  key: _formKey,

                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[

                        Center(
                          child:
                          new Text('EnterIt', style: TextStyle(
                              color:  Color(0xff0392cf),
                              fontWeight: FontWeight.bold,
                              fontSize: 50,
                              fontFamily: 'Bradley'
                          ),),
                        ),
                        SizedBox(height: 30,),

                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            cursorColor: Color(0xff4a4e4d),

                            style: TextStyle(
                              color: Color(0xff4a4e4d),
                            ),


                            decoration: InputDecoration(
                                labelText: 'Username',
                                labelStyle: TextStyle(
                                  color: Color(0xff4a4e4d),
                                ),
                                filled: true,
                                fillColor: Color(0xfffdf498),
                                focusColor: Colors.white,
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
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
                            cursorColor: Color(0xff4a4e4d),

                            style: TextStyle(
                              color: Color(0xff4a4e4d),
                            ),


                            decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                  color: Color(0xff4a4e4d),
                            ),
                                filled: true,
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                fillColor: Color(0xfffdf498)
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
                            cursorColor: Color(0xff4a4e4d),

                            style: TextStyle(
                              color: Color(0xff4a4e4d),
                            ),

                            decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                labelStyle: TextStyle(
                                  color: Color(0xff4a4e4d),
                                ),
                                filled: true,
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                fillColor: Color(0xfffdf498)
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
                              color: Color(0xff0392cf),
                              child: Text(
                                'Submit',
                                style: TextStyle(
                                    color: Colors.white,
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
                                      backgroundColor: Color(0xff0392cf),
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
                                  color: Color(0xff0392cf),
                                ),),

                              onTap: () => Navigator.pushReplacementNamed(context, '/')
                          ),
                        ),

                      ],

                    ),
                  )
              ),
            ),
          ),
        bottomNavigationBar: Container(

            margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),

            child: Text('@utkarshgitikansh', textAlign: TextAlign.center,  style: TextStyle(color: Color(0xff0392cf), fontSize: 16),)

        ),
      ),
    );
  }
}
