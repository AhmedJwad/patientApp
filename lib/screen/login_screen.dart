

import 'package:flutter/material.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({Key? key}) : super(key: key);

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  String _email = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      body:Column(
        mainAxisAlignment: MainAxisAlignment.center,       
        children: <Widget>[
         _showlogo(),
         _showemail(),
        ],
      )
      

    );
  }
  
 Widget _showlogo() {

  return Image(image: AssetImage('assets/logo.jpg'), width: 300,);
 }
 
 Widget _showemail() {
  return Container(
    padding: EdgeInsets.all(20),
    child: TextField(
      autocorrect: true,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: 'please inserrt your email',
        labelText: 'email',
        suffixIcon: Icon(Icons.email),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),      
      ),
      onChanged: (value){
        _email = value;
        print(_email);
      },
    ),
  );
 }
}