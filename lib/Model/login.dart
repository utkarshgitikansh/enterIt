import 'package:enterit/invent.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:enterit/Model/globals.dart' as globals;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _name;
  String _pwd;
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

  login() {

    Firestore.instance
        .collection('user')
        .document(_name)
        .get()
        .then((DocumentSnapshot ds) {

      if(ds.exists){

//      if()

        print(_name);

        setState(() {
          globals.isLoggedIn = _name;
        });

//        print(globals.isLoggedIn);


        Navigator.pushReplacementNamed(context, '/home');

      }
      else
        Fluttertoast.showToast(
            msg: "User doesn't exist",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0

        );
    });

//    var route = new MaterialPageRoute(builder: (BuildContext context) => new Invent(value: _name,));
//
//    Navigator.of(context).pushReplacement(route);



//    if(_name == 'yoga'){
//      Navigator.pushReplacementNamed(context, '/home');
//    }
  }


  signup() {

    Firestore.instance
        .collection('user').document(_name)
        .setData({ 'password' : _pwd});

  }



  @override
  Widget build(BuildContext context) {
    return Container(

      child: Scaffold(

          backgroundColor: Colors.brown.shade200,
//          appBar: AppBar(
//            centerTitle: true,
//            backgroundColor: Colors.blue,
//
//          ),

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

                            style: TextStyle(
                              color: Colors.white,
                            ),

                            cursorColor: Colors.brown.shade200,

                            decoration: InputDecoration(
                                labelText: 'Username',
                                labelStyle: TextStyle(
                                    color: Colors.brown.shade200,
                                ),

//                          focusedBorder:OutlineInputBorder(
//                                  borderSide: BorderSide(color: Colors.brown.shade200,),
//                                ),

                                filled: true,
                                fillColor: Colors.brown,
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
                                    color: Colors.brown.shade200
                                ),

                                filled: true,
                                fillColor: Colors.brown,
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.brown),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.brown),
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.brown),
                              ),
                            ),
//                          validator: (val) => val.length < 6 ? 'Password too short.' : null,
                            onSaved: (val) => _pwd = val,
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
                                'Login',
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
                                login();
                                _formKey.currentState.reset();

                              },
                            ),


                          ],
                        ),



                        SizedBox(height: 30),

                        new Center(
                          child: new InkWell(
                              child: new Text('New User (Signup)',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.brown,
                                ),),

                              onTap: () => Navigator.pushReplacementNamed(context, '/signup')
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
