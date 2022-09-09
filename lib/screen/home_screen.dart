import 'package:flutter/material.dart';
import 'package:healthcare/models/token.dart';
import 'package:healthcare/screen/login_screen.dart';

class HomeScreen extends StatefulWidget {
 final Token token;
 HomeScreen({ required this.token});

  @override
  _homescreenState  createState() =>  _homescreenState();
}

class  _homescreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
      title: Text('patients' , ),
     ),
     body: _getBody(),
     drawer: _getuserMenue(),
    );
  }
  
Widget _getBody() {
  return Container(
    margin: EdgeInsets.all(30),
    child:Center(
      child:Text(
        'welcome! ${widget.token.user.fullName}',
        style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold),
        
        ),
    ) 
  );
}

 Widget _getuserMenue() {
  return Drawer(
    child: ListView(
     padding: EdgeInsets.zero,
     children: <Widget>[
      DrawerHeader(
        child: Image(
          image: AssetImage('assets/logo.jpg'), width: 400,
          )
        ),
     ListTile(
        leading: Icon(Icons.girl_rounded),
        title: const Text('type of blood'),
        onTap: () {          
        },
        ),
        ListTile(
        leading: Icon(Icons.location_city),
        title: const Text('City'),
        onTap: () {          
        },
        ),
         ListTile(
        leading: Icon(Icons.verified_user_outlined),
        title: const Text('Users'),
        onTap: () {          
        },
        ),
          ListTile(
        leading: Icon(Icons.sick_rounded),
        title: const Text('Patients'),
        onTap: () {          
        },
        ),
         Divider(
            color: Colors.black, 
            height: 2,
          ),
         ListTile(
        leading: Icon(Icons.login_outlined),
        title: const Text('Log out'),
        onTap: () {  
          Navigator.pushReplacement(
      context, 
      MaterialPageRoute(
        builder: (context) => loginScreen(),
      )
    );        
        },
        ),
     ],
    ),
  );
 }
}