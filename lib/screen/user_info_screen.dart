import 'package:healthcare/components/loader_component.dart';
import 'package:healthcare/models/token.dart';
import 'package:healthcare/models/user.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/screen/user_screen.dart';

class UserInfoScreen extends StatefulWidget {
   final Token token;
  final User user;
 

UserInfoScreen({required this.token, required this.user});

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
   bool _showLoader = false;
   
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.user.fullName),),
      body: Stack(
        children: <Widget>[
          Column(
           children:<Widget> [
               _showUserinfo(),
               _showbuttons(),
           ],
          ),     
          _showLoader?LoaderComponent(text: 'please wait',)  :Container(),  
        ],
      ),
    );
  }
  
 Widget _showUserinfo() {
    return  Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(5),
                child: Row(               
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: FadeInImage(
                        placeholder: AssetImage('/assets/noimage.png'),
                         image:NetworkImage(widget.user.imageFullPath),
                         width: 100,
                         height: 100,
                         fit: BoxFit.cover,
                         ),
                    ),
                  Expanded(
                     child:Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.start,   
                         children: [
                           Expanded(
                             child: Column(  
                              mainAxisAlignment: MainAxisAlignment.start,                                      
                                children:<Widget> [                              
                                  Row(
                                    children:<Widget> [
                                      Text('Email :', style: TextStyle(fontWeight: FontWeight.bold),),
                                      Text(
                                        widget.user.email, 
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),  
                                  SizedBox(height: 5,), 
                                  Row(
                                    children: <Widget>[
                                       Text('Phone Number :', style: TextStyle(fontWeight: FontWeight.bold),),
                                      Text(
                                        widget.user.phoneNumber, 
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),       
                                   SizedBox(height: 5,), 
                                  Row(
                                    children: <Widget>[
                                       Text('Address :', style: TextStyle(fontWeight: FontWeight.bold),),
                                      Text(
                                        widget.user.address, 
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),    
                                   SizedBox(height: 5,), 
                                  Row(
                                    children: <Widget>[
                                       Text('#Patients :', style: TextStyle(fontWeight: FontWeight.bold),),
                                      Text(
                                        widget.user.patientsCount.toString(), 
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),                                                                                  
                                ],
                              ),
                           ),
                         ],
                       ),                       
                     ),
                   ),                       
                  ],
                ),
              );
  }
  
 Widget _showbuttons() {
   return Container(    
    margin: EdgeInsets.only(left:10, right: 10,bottom: 10, top: 10),  

    child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,           
     children: <Widget>[  
     _showEditUserButton(),
     SizedBox(width: 20,),
    _showAddPatientButtons(),     
     ],
    ),
  );
  }
  
 Widget _showEditUserButton() {
  return Expanded
  (
    child: ElevatedButton(
      child: Text("Edit User"),
      style: ButtonStyle(
       backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState>states){
            return Color(0xFF120E43);
          }
        )
        ),
         onPressed:() =>_goEdit()
      )  
  );
 }
  
Widget  _showAddPatientButtons() {
   return Expanded
  (
    child: ElevatedButton(
      child: Text("Add Patient"),
      style: ButtonStyle(
       backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState>states){
            return Color(0xFFE03B8B);
          }
        )
        ),
         onPressed: () {}
      )  
  );
}

 void _goEdit() async{
    String? result = await Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => UserScreen(
          token: widget.token, 
          user:widget.user ,
        )
      )
    );
    if (result == 'yes') {
     //TODO:pending refrence user info
    }  
    }
  }    
  
