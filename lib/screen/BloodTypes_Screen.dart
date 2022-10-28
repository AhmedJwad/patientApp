import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/helpers/api_helper.dart';
import 'package:healthcare/helpers/constans.dart';
import 'package:healthcare/models/bloodtypes.dart';
import 'package:healthcare/models/response.dart';
import 'package:healthcare/models/token.dart';

import '../components/loader_component.dart';


class BloodTypesScreen extends StatefulWidget {
 final Token token;
 final bloodtypes bloodtypess ;

 BloodTypesScreen({required this.token , required this.bloodtypess});

  @override
  _bloodTypesScreen createState() => _bloodTypesScreen();
}

class _bloodTypesScreen extends State<BloodTypesScreen> {
  bool _showLoader=false;
  String _description='';
  String _descripitionError='';
  bool _descripitionshowError= false;
  TextEditingController _descripitionController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _description=widget.bloodtypess.description;
    _descripitionController.text=_description;

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar:
      AppBar(
        title: Text(widget.bloodtypess.id==0 ?'New Blood types':widget.bloodtypess.description 
        )),
        body: Stack(
          children: [
            Column(
              children: <Widget>[
                  _showdescription(),
                  _showbuttons(),
              ],
            ),
             _showLoader ? LoaderComponent(text: 'Loading...',) : Container(),
          ],
        ),
    );
  }
  
 Widget _showdescription() {
  return Container(
    padding: EdgeInsets.all(10),  
    child: TextField(
      autofocus: true,
      controller: _descripitionController,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
             hintText: "description",
             labelText: 'description',
             errorText: _descripitionshowError ? _descripitionError:null,
             suffixIcon: Icon(Icons.description),
             border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),             
      ),
      onChanged: (value) => {
        _description=value ,
      },
    ),  
  );
 }
  
 Widget _showbuttons() {
  return Container(
    margin: EdgeInsets.only(left: 10 , right: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
       Expanded(
                child: ElevatedButton(
                  child: Text('Save'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        return Color.fromARGB(255, 98, 22, 180);
                      }
                    ),
                  ),
                  onPressed: () =>_save(), 
              ),
          ),
          widget.bloodtypess.id==0 ? Container():SizedBox(width: 20,),widget.bloodtypess.id==0? Container()        
          :Expanded(
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
            )
          )
        ],
      ),
    );
  }

 
 void _save() {
  if(!_validateFields())
  {
    return;
  }
    widget.bloodtypess.id == 0 ? _addRecord() : _saveRecord();
 } 
    
  bool _validateFields() {
     bool isValid = true;

     if(_description.isEmpty)
     {
       isValid=false;
      _descripitionshowError=true;
      _descripitionError='You must enter a description.';
     }else
     {
      _descripitionshowError=false;
     }
     setState(() {       
     });

     return isValid;
  }
  
 void _addRecord() async {
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
  Map<String , dynamic>request={
    'description':_description,    
  };
  Response response =await Apihelper.Post('/api/BloodTypes/', request, widget.token.token);
  setState(() {
      _showLoader = false;
    });
  if (!response.isSuccess)
  {
    await showAlertDialog(
        context: context,
        title: 'Error', 
        message: response.message,
        actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
        ]
      );    
      return;
  }
  Navigator.pop(context, 'yes');
 }
 
 void _saveRecord() async{
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
 Map<String, dynamic> request = {
      'id': widget.bloodtypess.id,
      'description': _description,    
    };
  Response response =await Apihelper.Put('/api/BloodTypes/', 
      widget.bloodtypess.id.toString(), 
      request, 
      widget.token.token);
  setState(() {
      _showLoader = false;
    });
  if (!response.isSuccess)
  {
    await showAlertDialog(
        context: context,
        title: 'Error', 
        message: response.message,
        actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
        ]
      );    
      return;
  }
  Navigator.pop(context, 'yes');

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
 
  void _deleteRecord() async{
     setState(() {
      _showLoader = true;
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
    Response response = await Apihelper.Delete(
      '/api/BloodTypes/', 
      widget.bloodtypess.id.toString(), 
      widget.token.token,
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