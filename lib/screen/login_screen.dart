

import 'package:flutter/material.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({Key? key}) : super(key: key);

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  String _email = '';
  String _password = '';
  bool _rememberMe = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      body:Column(
        mainAxisAlignment: MainAxisAlignment.center,       
        children: <Widget>[
         _showlogo(),
         SizedBox(height: 20,),
         _showemail(),
         _showpassword(),
         _showRememberMe(),
          _showButtons(),
        ],
      )
      

    );
  }
  
 Widget _showlogo() {

  return Image(image: AssetImage('assets/logo.jpg'), width: 300,);
 }
 
 Widget _showemail() {
  return Container(
    padding: EdgeInsets.all(10),
    child: TextField(
      autofocus: true,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: 'please inserrt your email',
        labelText: 'email',
        suffixIcon: Icon(Icons.email),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),      
      ),
      onChanged: (value){
        _email = value;       
      },
    ),
  );
 }

Widget _showpassword() {
  return Container(
    padding: EdgeInsets.all(10),
    child: TextField(     
    obscureText: true,
      decoration: InputDecoration(
        hintText: 'please inserrt your Password',
        labelText: 'Password',
        suffixIcon: Icon(Icons.lock),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),      
      ),
      onChanged: (value){
        _password = value;       
      },
    ),
  ); 
}

 Widget _showRememberMe() {
  return CheckboxListTile(
    title: Text('Remember Me'),
    value: _rememberMe, onChanged: (value) { 
    setState(() {
      _rememberMe=value!;
    });
   },);
 }
 
 Widget _showButtons() { 
  return Container(
    margin: EdgeInsets.only(left:10, right: 10,),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
     children: <Widget>[
     Expanded(
       child: ElevatedButton(
        child:Text('Login'),
        style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState>states){
            return Color(0xFF120E43);
          }
        )
        ),
        onPressed: (){}
        ),
     ),
     SizedBox(width:20,),
       Expanded(
         child: ElevatedButton(
           child:Text('Register'),
           style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              return Color(0xFFE03B8B);
            }
          ),
        ),
           onPressed: (){}
           ),
       ),
     ],
    ),
  );
 }
}



