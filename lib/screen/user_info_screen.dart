// ignore_for_file: deprecated_member_use

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:healthcare/components/loader_component.dart';
import 'package:healthcare/helpers/api_helper.dart';
import 'package:healthcare/helpers/regex_helper.dart';
import 'package:healthcare/models/City.dart';
import 'package:healthcare/models/Nationality.dart';
import 'package:healthcare/models/UserPatient.dart';
import 'package:healthcare/models/bloodtypes.dart';
import 'package:healthcare/models/gendre.dart';
import 'package:healthcare/models/patient.dart';
import 'package:healthcare/models/response.dart';
import 'package:healthcare/models/token.dart';
import 'package:healthcare/models/user.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/screen/Patient_Screen.dart';
import 'package:healthcare/screen/patient_info_screen.dart';
import 'package:healthcare/screen/user_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class UserInfoScreen extends StatefulWidget {
  final Token token;
  final User user;
  bool isAdmin;
 

UserInfoScreen({required this.token, required this.user , required this.isAdmin});

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
        onPressed: ()=> _goAddPatient(Patients(
          address: '',
          city: City(id: 0, description: ''),
          age: 0,
          bloodType: bloodtypes(id: 0, description: ''),
          date: '',
          dateLocal: '',
          description: '',
          epcnNumber: 0, 
          firstName: '',
          fullName: '',
          gendre: Gendre(id: 0, description: ''),
          histories: [],
          historiesCount: 0,
          id:0,
          imageFullPath: '',
          lastName: '',
          mobilePhone: '',
          natianality: Natinality(id: 0, description: ''),
          patientPhotos: [],
          patientPhotosCount: 0,
          userPatient:UserPatient(id: 0, firstName: '', lastName: '', address:'', phoneNumber: '', email: ''),
                  
         )),            
      )
    );
  }
  
 Widget _showUserinfo() {
    return  SingleChildScrollView(
      child: Container(
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
                                image: AssetImage('assets/noimage.png'),
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,                                      
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
                                         Flexible(child: Text('Phone Number:', style: TextStyle(fontWeight: FontWeight.bold),)),
                                        Text(
                                         '+${_user.countryCode}''${_user.phoneNumber}', 
                                          style: TextStyle(
                                            fontSize: 14,
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
                                         Text('Specialty :', style: TextStyle(fontWeight: FontWeight.bold),),
                                        Text(
                                          _user.specialty, 
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
                                    SizedBox(height: 5,),
                                    widget.isAdmin ? _showCallButtons():Container(),
                                  ],
                                ),
                             ),
                           ],
                         ),                       
                       ),
                     ),                       
                    ],
                  ),
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
          myProfile: false,
        )
      )
    );
    if (result == 'yes') {
     //TODO:pending refrence user info
     _getUser();
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
      
        void _goAddPatient(Patients patients)async {
          String? result= await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context)=> PatientScreen(
                token: widget.token, user: _user, patient: patients
                )
              )
            );
            if(result=="yes")
            {
              _getUser();
            }
        }
        
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
                  onTap: () =>_goPatient(e),
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
                            image: AssetImage('assets/noimage.png'),
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
                                        fontSize: 16,
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
                                                           
                                      ],
                                    ),
                                    Row(
                                      children: [
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
                                       
                                                            
                                      ],
                                    ),
                                    Row(
                                      children: [
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

 void _goPatient(Patients e) async{
   String? result= await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context)=> PatientInfoScreen(
                token: widget.token, user: _user, patient: e, isAdmin: widget.isAdmin,
                )
              )
            );
            if(result=="yes")
            {
              _getUser();
            }
 }
 
 Widget _showCallButtons() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 40,
          width: 40,
          color: Colors.blue,
          child: IconButton(
            icon: Icon(Icons.call, color: Colors.white,),
            onPressed:()=>launch('tel://+${widget.user.phoneNumber}''${RegexHelper.removeBlankSpaces(widget.user.phoneNumber)}'), 
           ),
        ),
      ),
      SizedBox(width: 10,),
      ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 40,
          width: 40,  
          color: Colors.green, 
          child: IconButton(
            icon: Icon(Icons.insert_comment,color: Colors.white),
            onPressed: ()=> _sendMessage(), 
            
            ),       
        ),
      ),
    ],
  );
 }
 
  void _sendMessage() async{
     final link = WhatsAppUnilink(
      phoneNumber: '+${widget.user.countryCode}${RegexHelper.removeBlankSpaces(widget.user.phoneNumber)}',
      text: 'Hello, I am writing to you from healthcare app.',
    );
    await launch('$link');  
  }
 
    
  }    
  
