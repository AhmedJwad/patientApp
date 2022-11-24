


import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/components/loader_component.dart';
import 'package:healthcare/helpers/api_helper.dart';
import 'package:healthcare/models/history.dart';
import 'package:healthcare/models/patient.dart';
import 'package:healthcare/models/response.dart';
import 'package:healthcare/models/token.dart';
import 'package:healthcare/models/user.dart';



class HistoryScreen extends StatefulWidget {
 final Token token;
 final User user;
 final Patients patient;
 final Histories history;
 
HistoryScreen({required this.token , required this.user , required this.patient, required this.history});

  @override
 _historyScreen createState() =>  _historyScreen();
}

class  _historyScreen extends State<HistoryScreen> {
bool _showLoader=false;


String _allergies='';
String _allergiesError='';
bool _allergiesShowError=false;
TextEditingController _allergiesController= TextEditingController();

String _illnesses='';
String _illnessesError='';
bool   _illnessesShowError=false;
TextEditingController  _illnessesController= TextEditingController();

String _surgeries='';
String _surgeriesError='';
bool _surgeriesShowError=false;
TextEditingController _surgeriesController=TextEditingController();

String _result='';
String _resultError='';
bool _resultShowError=false;
TextEditingController _resultController= TextEditingController();

  get _showButtons => null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _allergies=widget.history.allergies;
    _allergiesController.text=_allergies;

    _illnesses=widget.history.illnesses;
    _illnessesController.text=_illnesses;

    _surgeries=widget.history.surgeries;
    _surgeriesController.text=_surgeries;
    _result=widget.history.result;
    _resultController.text=_result;
  }
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text( widget.history.id == 0 
            ? 'New history' 
            : 'Edit history'),
        ),        
        body: SingleChildScrollView(
          child: Stack(          
            children:<Widget>[
            Column(
              children: <Widget>[
              _showAllergies(),
              _showIllnesses(),
              _showSurgeries(),
              _showResult(),
             _showbuttons(),
              ],           
            ),
            _showLoader ? LoaderComponent(text: "Loading...",): Container(),
            ],
          ),
        ),
    );
  }
  
 Widget _showAllergies() {
  return Container(
    padding: EdgeInsets.all(10),
    child: TextField(
      keyboardType: TextInputType.multiline,
      minLines: 4,
      maxLines: 4,
      controller: _allergiesController,
      decoration: InputDecoration(
        hintText: 'Enter a allergy...',
        labelText: 'allergies',
        errorText: _allergiesShowError ? _allergiesError:null,
          suffixIcon: Icon(Icons.description),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)
          ),
        ),
        onChanged: (value) {
          _allergies = value;
        },   
    ),
  );
 }
  
 Widget _showIllnesses() {
  return Container(
      padding: EdgeInsets.all(10),
    child: TextField(
      keyboardType: TextInputType.multiline,
      minLines: 4,
      maxLines: 4,
      controller: _illnessesController,
      decoration: InputDecoration(
        hintText: 'Enter a illnesses...',
        labelText: 'illnesses',
        errorText: _illnessesShowError ? _illnessesError:null,
          suffixIcon: Icon(Icons.description),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)
          ),
        ),
        onChanged: (value) {
          _illnesses = value;
        },   
    ),
  );
 }
  
 Widget _showSurgeries() {
  return Container(
     padding: EdgeInsets.all(10),
     child: TextField(
      keyboardType: TextInputType.multiline,
      minLines: 4,
      maxLines: 4,
      controller: _surgeriesController,
      decoration: InputDecoration(
        hintText: 'Enter a Surgeries...',
        labelText: 'Surgeries',
        errorText: _surgeriesShowError ? _surgeriesError:null,
          suffixIcon: Icon(Icons.description),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)
          ),
        ),
        onChanged: (value) {
          _surgeries = value;
        },   
    ),
  );
 }
  
Widget  _showResult() {
  return Container(
     padding: EdgeInsets.all(10),
     child: TextField(
      keyboardType: TextInputType.multiline,
      minLines: 4,
      maxLines: 4,
      controller: _resultController,
      decoration: InputDecoration(
        hintText: 'Enter a result...',
        labelText: 'result',
        errorText: _resultShowError ? _resultError:null,
          suffixIcon: Icon(Icons.description),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)
          ),
        ),
        onChanged: (value) {
          _result = value;
        },   
    ),
  );
}
  
 Widget _showbuttons() {
  return Container(    
     margin: EdgeInsets.only(left: 10, right: 10),     
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,        
        children: <Widget>[
          Expanded(
            child: ElevatedButton(              
              child: Text('Save'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    return Color(0xFF120E43);
                  }
                ),
              ),
              onPressed: () => _save(), 
            ),
          ),
          widget.history.id == 0 
            ? Container() 
            : SizedBox(width: 20,),
          widget.history.id == 0 
            ? Container() 
            : Expanded(
                child: ElevatedButton(
                  child: Text('Delete'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        return Color(0xFFB4161B);
                      }
                    ),
                  ),
                  onPressed: () => _confirmDelete(), 
              ),
          ),
        ],
      ),
  );
 }
 
 void _save() {
  if(!validateFields())
  {
    return ;
  }
  widget.history.id==0 ? _addRecord(): _saveRecord();
 }
  
  void _confirmDelete() async{
    var response =  await showAlertDialog(
      context: context,
      title: 'Confirmation', 
      message: 'Are you sure you want to delete the record?',
      actions: <AlertDialogAction>[
          AlertDialogAction(key: 'no', label: 'No'),
          AlertDialogAction(key: 'yes', label: 'yes'),
      ]
    );    

    if (response == 'yes') {
      _deleteRecord();
    }
  }
  
  bool validateFields() {
    bool isValid=true;
    if(_allergies.isEmpty)
    {
       isValid=false;
      _allergiesShowError=true;
      _allergiesError='You must enter a allergies.';
    }else
    {
      _allergiesShowError=false;
    }
    if(_illnesses.isEmpty)
    {
      isValid=false;
      _illnessesShowError=true;
      _illnessesError='You must enter a illnesses.';
    }
    else
    {
      _illnessesShowError=false;
    }
    if(_surgeries.isEmpty)
    {
      isValid=false;
      _surgeriesShowError=true;
      _surgeriesError='You must enter a surgeries.';
    }else
    {
      _surgeriesShowError=false;
    }
    if(_result.isEmpty)
    {
       isValid=false;
      _resultShowError=true;
      _resultError='You must enter a result.';
    }else
    {
      _resultShowError=false;
    }
    setState(() {
      
    });
    return isValid;
  }
  
 void _addRecord() async{
  setState(() {
    _showLoader=false;
  });
  var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });
      await showAlertDialog(
        context: context,
        title: 'Error', 
        message: 'Check your internet connection',
        actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Accept'),
        ]
      );    
      return;
    }
   Map<String , dynamic>request={
    'allergies':_allergies,
    'illnesses':_illnesses,
    'surgeries':_surgeries,
    'Result':_result,
    'patientId':widget.patient.id,
   };
  Response response=await Apihelper.Post('/api/Histories/', request, widget.token);

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

    Navigator.pop(context, 'yes');
 }
  
 void _saveRecord() async{
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
        message: 'check your internet connection.',
        actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Accept'),
        ]
      );    
      return;
    }

    Map<String, dynamic> request = {     
      'id': widget.history.id,
      'allergies': _allergies,
      'illnesses':_illnesses,
      'surgeries': _surgeries,
      'Result': _result, 
      'patientId':widget.patient.id,     
    };

    Response response = await Apihelper.Put(
      '/api/Histories/', 
      widget.history.id.toString(), 
      request, 
      widget.token
    );

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

    Navigator.pop(context, 'yes');
 }
 
  void _deleteRecord() async{
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
        message: 'Check your internet connection',
        actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Accept'),
        ]
      );    
      return;
    }

    Response response = await Apihelper.Delete(
      '/api/Histories/', 
      widget.history.id.toString(), 
      widget.token
    );

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

    Navigator.pop(context, 'yes');
  }     

  
}