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

        Fluttertoast.showToast(
            msg: "Welcome to enterIt",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Color(0xff0392cf),
            textColor: Colors.white,
            fontSize: 16.0

        );

        Navigator.pushReplacementNamed(context, '/home');

      }
      else
        Fluttertoast.showToast(
            msg: "User doesn't exist. Please note username is case sensitive",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Color(0xff0392cf),
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

          backgroundColor: Colors.white,
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

                            style: TextStyle(
                              color: Color(0xff4a4e4d),
                            ),

                            cursorColor: Color(0xff4a4e4d),

                            decoration: InputDecoration(
                                labelText: 'Username',
                                labelStyle: TextStyle(
                                    color: Color(0xff4a4e4d),
                                ),

//                          focusedBorder:OutlineInputBorder(
//                                  borderSide: BorderSide(color: Colors.brown.shade200,),
//                                ),

                                filled: true,
                                fillColor: Color(0xfffdf498),
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
                                    color: Color(0xff4a4e4d)
                                ),

                                filled: true,
                                fillColor: Color(0xfffdf498),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
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
                              color: Color(0xff0392cf),
                              child: Text(
                                'Login',
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
                                  color: Color(0xff0392cf),
                                ),),

                              onTap: () => Navigator.pushReplacementNamed(context, '/signup')
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

            child: Text('@utkarshgitikansh', textAlign: TextAlign.center,  style: TextStyle(color:Color(0xff0392cf), fontSize: 16),)

        ),


      ),
    );
  }
}
