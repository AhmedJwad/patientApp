import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:healthcare/components/loader_component.dart';
import 'package:healthcare/helpers/api_helper.dart';
import 'package:healthcare/models/response.dart';
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
   late User _user;
  @override
 void initState() {
    // TODO: implement initState
    super.initState();
    _user=widget.user;
    _getUser();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_user.fullName),),
      body: Center(
        child: _showLoader 
          ? LoaderComponent(text: 'please wait...',) 
          : _getContent(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: ()=> _goAdd(),            
      )
    );
  }
  
 Widget _showUserinfo() {
    return  Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(5),
                child: Row(               
                  children: [
                   Stack(
                    children: <Widget>[
                    ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: CachedNetworkImage(
                            imageUrl: _user.imageFullPath,
                            errorWidget: (context, url, error) => Icon(Icons.error),
                            fit: BoxFit.cover,
                            height: 100,
                            width: 100,
                            placeholder: (context, url) => Image(
                              image: AssetImage('assets/vehicles_logo.png'),
                              fit: BoxFit.cover,
                              height: 100,
                              width: 100,
                            ),
                          ),
                        ),
                       Positioned(
                          bottom: 0,
                          left: 60,
                          child: InkWell(
                            onTap: ()=>_goEdit(),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Container(
                                color: Colors.green[50],
                                height: 40,
                                width: 40,
                                child: Icon(Icons.edit, size: 30, color: Colors.blue,),
                              ),
                            ),
                          ),
                          ),
                      ],
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
                                        _user.email, 
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
                                        _user.phoneNumber, 
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
                                        _user.address, 
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
                                        _user.patientsCount.toString(), 
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
  
 

 void _goEdit() async{
    String? result = await Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => UserScreen(
          token: widget.token, 
          user:_user ,
        )
      )
    );
    if (result == 'yes') {
     //TODO:pending refrence user info
    }  
    }
    
      Future<Null> _getUser() async{
        setState(() {
          _showLoader=true;
        });
        var connectivityResult = await Connectivity().checkConnectivity();
                            if (connectivityResult == ConnectivityResult.none) {
                              setState(() {
                                _showLoader = false;
                              });
                              await showAlertDialog(
                                context: context,
                                title: 'Error', 
                                message: 'check your internet connection',
                                actions: <AlertDialogAction>[
                                    AlertDialogAction(key: null, label: 'Accept'),
                                ]
                              );    
                              return;
                            }
        Response response=await Apihelper.getUser(widget.token , _user.id);

        setState(() {
          _showLoader=false;
        });
         if (!response.isSuccess) {
                await showAlertDialog(
                  context: context,
                  title: 'Error', 
                  message: response.message,
                  actions: <AlertDialogAction>[
                      AlertDialogAction(key: null, label: 'Accept'),
                  ]
                );    
                return;
              }
              setState(() {                 
                _user=response.result;                
              });
      }
      
        _goAdd() {}
        
      Widget _getContent() {
              return Column(
                children: <Widget>[
                  _showUserinfo(),
                  Expanded(
                    child: _user.patients.length == 0 ? _noContent() : _getListView(),
                  ),
                ],
              );
  }
       Widget   _noContent() {
        return Center(
          child: Container(
            margin:EdgeInsets.all(20),
            child: Text(
              'The user has no patients registered.',
              style: TextStyle(fontSize: 16 , fontWeight: FontWeight.bold,),
            ),
          ),
        );
       }
       
        Widget _getListView() {
         return RefreshIndicator(
      onRefresh: _getUser,
      child: ListView(
        children: _user.patients.map((e) {
          return Card(
            child: InkWell(
              onTap: () {},
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(5),
                child: Row(
                  children: <Widget>[
                    CachedNetworkImage(
                      imageUrl: e.imageFullPath,
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      fit: BoxFit.cover,
                      height: 80,
                      width: 80,
                      placeholder: (context, url) => Image(
                        image: AssetImage('assets/vehicles_logo.png'),
                        fit: BoxFit.cover,
                        height: 80,
                        width: 80,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Text(
                                  e.fullName,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                  ),                                  
                                ),                                                              
                                Row(
                                  children: [
                                    Text('Adress:'                                    
                                    ),
                                    SizedBox(width: 5,),
                                    Text(                                      
                                      e.address,
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(width: 5,),
                                    Text("Age:"),
                                      SizedBox(width: 5,),
                                    Text(
                                      e.age.toString(),
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),                                   
                                  ],
                                ),
                                  Row(
                                  children: [
                                    Text('Nationality:'                                    
                                    ),
                                    SizedBox(width: 5,),
                                    Text(                                      
                                      e.natianality.description,
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(width: 5,),
                                    Text("Blood Type:"),
                                      SizedBox(width: 5,),
                                    Text(
                                      e.bloodType.description,
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),                                   
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ),
                    Icon(Icons.arrow_forward_ios, size: 40,)
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ), 
    );
        }

  }    
  
