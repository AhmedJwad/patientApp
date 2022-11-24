import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/components/loader_component.dart';
import 'package:healthcare/helpers/api_helper.dart';
import 'package:healthcare/models/Diagnosic.dart';
import 'package:healthcare/models/detail.dart';
import 'package:healthcare/models/history.dart';
import 'package:healthcare/models/patient.dart';
import 'package:healthcare/models/response.dart';
import 'package:healthcare/models/token.dart';
import 'package:healthcare/models/user.dart';
import 'package:healthcare/screen/Patient_Screen.dart';
import 'package:healthcare/screen/detail_screen.dart';
import 'package:healthcare/screen/history_screen.dart';
import 'package:intl/intl.dart';



class HistoryInfoScreen extends StatefulWidget {
  final Token token;
 final User user ;
 final Patients patient;
 final Histories history;
 
 HistoryInfoScreen({required this.token, required this.user, required this.patient,  required this.history});

  @override
  _historyInfoScreenstate createState() =>  _historyInfoScreenstate();
}

class  _historyInfoScreenstate extends State<HistoryInfoScreen> {
   bool _showLoader = false;
  late Histories _history;
  late Patients _patient;
  @override
  void initState() {
    // TODO: implement initState
    super.initState(); 
     _patient=widget.patient;   
    _getPatient();
      _history=widget.history;  
    _getHistory();         
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.patient.fullName}'),
      ),
      body: Center(
        child:  _showLoader ? LoaderComponent(text: 'loading...',) 
          : _getContent(),
      ),
       floatingActionButton:
         FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () => _goDetail(Details(
              id: 0,
               description: '',
                diagonisic: diagnosic(id: 0, description: ''), 
             )),
          ),       
    );   
  }
  
 Widget _getContent() {
  return Column(
    children: <Widget>[
      _showPatientInfo(),
      Expanded(child: _history.details.length == 0 ? _noContent() : _getListView()),
    ],      
  );
 }
  
 void  _goDetail(Details details) async{
     String? result = await  Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => DetailScreen(
          token: widget.token, 
          user: widget.user, 
          patient: widget.patient, 
          histories: widget.history, 
          details: details,
        ) 
      )
    );
    if (result == 'yes') {
      await _getHistory();
    }
 }
 Future<Null> _getHistory() async {
    setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });
      await showAlertDialog(
        context: context,
        title: 'Error', 
        message: 'Check you internet Connection.',
        actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
        ]
      );    
      return;
    }

    Response response = await Apihelper.getHistory(widget.token, _history.id.toString());

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
      _history = response.result;
    });
  }
  
 Widget _showPatientInfo() {
  return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(5),
      child: Column(
        children: [
          Row(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: CachedNetworkImage(
                      imageUrl: _patient.imageFullPath,
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
                      onTap: () => _goEditPatient(),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          color: Colors.green[50],
                          height: 40,
                          width: 40,
                          child: Icon(
                            Icons.edit,
                            size: 30,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    )
                  )
                ],
              ),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Row(
                          children: <Widget>[
                            Text(
                              'city: ', 
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              )
                            ),
                            Text(
                             _patient.city.description, 
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          children: <Widget>[
                            Text(
                              'Type of Blood: ', 
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              )
                            ),
                            Text(
                           _patient.bloodType.description, 
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                         SizedBox(height: 5,),
                        Row(
                          children: <Widget>[
                            Text(
                              'Nationality: ', 
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              )
                            ),
                            Text(
                            _patient.natianality.description, 
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                         SizedBox(height: 5,),
                        Row(
                          children: <Widget>[
                            Text(
                              'Gendre: ', 
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              )
                            ),
                            Text(
                           _patient.gendre.description, 
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                         SizedBox(height: 5,),
                        Row(
                          children: <Widget>[
                            Text(
                              'email of Patient: ', 
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              )
                            ),                           
                          ],
                        ),
                           Row(
                          children: <Widget>[                          
                            Text(
                             _patient.userPatient.email, 
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          children: <Widget>[
                            Text(
                              'Address: ', 
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              )
                            ),
                            Text(
                             _patient.address, 
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          children: <Widget>[
                            Text(
                              'Age: ', 
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              )
                            ),
                            Text(
                          _patient.age.toString(), 
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          children: <Widget>[
                            Text(
                              'EPCN: ', 
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              )
                            ),
                            Text(
                            _patient.epcnNumber.toString(), 
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          children: <Widget>[
                            Text(
                              'Mobile Phone: ', 
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              )
                            ),
                            Text(
                             _patient.mobilePhone, 
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          children: <Widget>[
                            Text(
                              'Description: ', 
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              )
                            ),
                            Text(
                             _patient.description == null ? 'NA' :_patient.description, 
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          children: <Widget>[
                            Text(
                              '# Histories: ', 
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              )
                            ),
                            Text(
                             _patient.historiesCount.toString(), 
                              style: TextStyle(
                                fontSize: 14,
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
                  ],
                ),
              ),
            ],
          ),
            SizedBox(height: 10,),
          Stack(
            children: [
              Column(
                children: <Widget>[
                  SizedBox(height: 5,),
                  Divider(
                    color: Colors.black, 
                    height: 2,
                  ),
                  SizedBox(height: 5,),
                    Row(
                                  children: [
                                     Text(
                                          'Date:',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold
                                  ),
                                ),
                                       Text(
                                  '${DateFormat('yyyy-MM-dd').format(DateTime.parse(_history.dateLocal))}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal
                                  ),
                                ),
                                  ],
                                ),                             
                                Row(
                                  children: [
                                     Text(
                                      'Allergies:',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${_history.allergies}',
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),                                   
                                  ],                                  
                                ),
                                Row(
                                  children: [
                                    
                                     Text(
                                      'Illnesses:',
                                      style: TextStyle(
                                        fontSize: 14,
                                         fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                     SizedBox(width: 5,),
                                    Text(
                                      _history.illnesses,
                                      style: TextStyle(
                                        fontSize: 14,
                                         fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                                  Row(
                                  children: [
                                     Text(
                                      'Surgeries:',
                                      style: TextStyle(
                                        fontSize: 14,
                                         fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${_history.surgeries}',
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(width: 5,),
                                  
                                  ],
                                ),
                                Row(
                                  children: [
                                       Text(
                                      'Result:',
                                      style: TextStyle(
                                        fontSize: 14,
                                         fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${_history.result}',
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(width: 5,),
                                 
                                  ],
                                ),                               
                               
                              ],
                            ),
                          ],
                        ),
                        Positioned(
                          bottom: 0,
                  left: 280,
                  child: InkWell(
                    onTap: () => _goEditHistory(),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        color: Colors.green[50],
                        height: 40,
                        width: 40,
                        child: Icon(
                          Icons.edit,
                          size: 30,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ) 
                        ),
                ],
              ),

         );            
             
    
 }
  
 Widget _getListView() {
   return ListView(
      children: _history.details.map((e) {
        return Card(
          child: InkWell(
            onTap: () => _goDetail(e),
            child: Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(5),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                   Text(
                               "diagonisic :",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                                Text(
                                e.diagonisic.description,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal
                                ),
                              ),
                                ],
                              ) ,
                              SizedBox(height :5,) ,
                               Row(
                                children: <Widget>[
                                   Text(
                               "Description :",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                                Text(
                                e.description == null ? 'NA' : e.description!,
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),         
                                ],
                             )                                                                                                                                                 
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
    );
 }
  
 Widget _noContent() {
  return Center(
      child: Container(
        margin: EdgeInsets.all(20),
        child: Text(
          'the history has no details.',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
 }
  
 void _goEditPatient() async{
  String? result = await Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => PatientScreen(
          token: widget.token, 
          user:widget.user ,
          patient: _patient,
        )
      )
    );
    if (result == 'yes') {
     //TODO:pending refrence patient info
    await _getPatient();
    }     
 }
 Future<Null> _getPatient() async{
  setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });
      await showAlertDialog(
        context: context,
        title: 'Error', 
        message: 'Check your internet connection.',
        actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Accept'),
        ]
      );    
      return;
    }

    Response response= await Apihelper.getPatient(widget.token,_patient.id.toString());
    

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
     _patient = response.result;
    });
  }
  
 void _goEditHistory() async{
    String? result = await  Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => HistoryScreen(
          token: widget.token, 
          user: widget.user, 
          patient:widget.patient,         
          history: widget.history,
        ) 
      )
    );
    if (result == 'yes') {
      await _getHistory();     
    }    
 }
  
}