import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/helpers/api_helper.dart';
import 'package:healthcare/helpers/regex_helper.dart';
import 'package:healthcare/models/Agenda.dart';
import 'package:healthcare/models/response.dart';
import 'package:healthcare/models/token.dart';
import 'package:healthcare/models/user.dart';
import 'package:healthcare/screen/Agenda_screen.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

import '../components/loader_component.dart';

class MyAgendaScreen extends StatefulWidget {
  final Token token;
  final User user;
  
  
  MyAgendaScreen({required this.token, required this.user});

  @override
 _myAgendaScreenState createState() => _myAgendaScreenState();
}

class _myAgendaScreenState extends State<MyAgendaScreen> {
  List<Agenda> _agenda=[];
  bool  _showLoader=false;
   late  User _user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _user=widget.user;
   _getUser();
   _getAgenda();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${_user.fullName}'),),
      body: Center(
       child: _showLoader 
          ? LoaderComponent(text: 'Loading...',) 
          : _getContent(),
      ),
    );
 
}
Future<Null>_getAgenda() async{
    setState(() {
      _showLoader=true;
    });
     var connectivityResult= await Connectivity().checkConnectivity();  
  if(connectivityResult == ConnectivityResult.none )
  {
    setState(() {
   _showLoader=false;
  });
    await showAlertDialog(
      context: context, 
      title:'Error',  
      message: 'check your internet connection.',    
     actions: <AlertDialogAction>[
      AlertDialogAction(key: null, label:'Accept')
     ]
         );
      return ;
      
  }
    Response response = await Apihelper.GetAgenda(widget.token,widget.user.id);

    setState(() {
      _showLoader = false;
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
      _agenda = response.result;
    });    
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
        Response response=await Apihelper.getUserpatient(widget.token , _user.id);

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
   
   Widget  _getContent() {
    
        return Column(
                children: <Widget>[
                  _showUserinfo(),
                  Expanded(
                    child: _agenda.length == 0 ? _noContent() : _getListView(),
                  ),
                ],
              ); 
   }
   
   Widget  _showUserinfo() {
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
                                    _showCallButtons(),
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
 
  
  
 Widget _noContent() {
   return Center(
      child: Container(
        margin: EdgeInsets.all(20),
        child: Text(         
           'There are no Agenda added by doctors.',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );  
 }
 Widget _getListView() {
   return RefreshIndicator(
      onRefresh: _getAgenda,
      child: ListView(
        children: _agenda.map((e) {
          return Card(
            child: InkWell(
              onTap: () =>e.isAvailable? AddAgenda(e):_delteagenda(e),
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(5),
                child: Row(               
                  children: [
                   
                  Expanded(
                     child:Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.start,   
                         children: [
                           Column(                                        
                              children: [
                                Text(
                                  '${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(e.dateLocal.toString()))}', 
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),   
                                  
                               Row(
                                      children: [
                                        Text('Available:'                                    
                                        ),
                                        SizedBox(width: 5,),
                                        Text(                                  
                                            e.isAvailable? "yse":'No', 
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),                         
                                                         
                                      ],
                                    ),
                                
                                SizedBox(height: 5,), 
                                   Row(
                                      children: [
                                        Text('description:'                                    
                                        ),
                                        SizedBox(width: 5,),
                                        Text(
                                          e.description.toString(), 
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),                               
                                                        
                                      ],
                                    ),
                                      SizedBox(height: 5,), 
                                   Row(
                                      children: [
                                        Text('Patient:'                                    
                                        ),
                                        SizedBox(width: 5,),
                                        Text(
                                          e.patientresponse != null
                                            ? '${e.patientresponse!.firstName} ${e.patientresponse!.lastName}'
                                            : 'No scheduled appointment',
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),                               
                                                        
                                      ],
                                    ),
                                                                
                              ],
                            ),
                         ],
                       ),
                     ),
                   ),    
                     e.isAvailable ? Icon(Icons.add, color: Color.fromARGB(255, 31, 143, 200),):Icon(Icons.delete, color: Color(0xffF02E65),),              
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
 }
 
 void _delteagenda(Agenda e) {
 
 }
  
 void AddAgenda(Agenda e) async{
   String? result = await  Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) =>AgendaScrren(
          token: widget.token, 
          user: _user, 
          patient:_user.patients.first,  
          agenda: e,       
        
        ) 
      )
    );
    if (result == 'yes') {
      await _getAgenda();     
    }    
 }
 
 
    
  }