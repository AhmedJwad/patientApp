import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/components/loader_component.dart';
import 'package:healthcare/helpers/api_helper.dart';
import 'package:healthcare/models/Nationality.dart';
import 'package:healthcare/models/response.dart';
import 'package:healthcare/models/token.dart';

class NationalityScreen extends StatefulWidget {
 
  final Token token;
  final Natinality natinality;
  NationalityScreen({required this.token, required this.natinality});

  @override
 _nationalityScreen createState() => _nationalityScreen(); 
}

class _nationalityScreen extends State<NationalityScreen> {
  bool _showLoader = false;
  String _description = '';
  String _descriptionError = '';
  bool _descriptionShowError = false;
  TextEditingController _descriptionController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     _description = widget.natinality.description;
    _descriptionController.text = _description;    
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.natinality.id == 0 
            ? 'new nationality' 
            :  widget.natinality.description
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              _showDescription(),           
              _showButtons(),
            ],
          ),
          _showLoader ? LoaderComponent(text: 'Loading...',) : Container(),
        ],
      ),
    );
  }
  
Widget  _showDescription() {
     return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: _descriptionController,
        decoration: InputDecoration(
          hintText: 'Enter a description...',
          labelText: 'description',
          errorText: _descriptionShowError ? _descriptionError : null,
          suffixIcon: Icon(Icons.description),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)
          ),
        ),
        onChanged: (value) {
          _description = value;
        },
      ),
    );
  }
  
 Widget _showButtons() {
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
          widget.natinality.id == 0 
            ? Container() 
            : SizedBox(width: 20,),
          widget.natinality.id == 0 
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
   if (!_validateFields()) {
      return;
    }

    widget.natinality.id == 0 ? _addRecord() : _saveRecord();
 }
 
  bool _validateFields() {
    bool isValid = true;
    if (_description.isEmpty) {
      isValid = false;
      _descriptionShowError = true;
      _descriptionError = 'You must enter a description.';
    } else {
      _descriptionShowError = false;
    } 
    setState(() { });
    return isValid;
  }
  
 void _addRecord() async{
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

    Map<String, dynamic> request = {
      'description': _description,      
    };

    Response response = await Apihelper.Post(
      '/api/Natianalities/', 
      request, 
      widget.token.token
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
 
 void _saveRecord() async{
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

    Map<String, dynamic> request = {
      'id': widget.natinality.id,
      'description': _description,      
    };

    Response response = await Apihelper.Put(
      '/api/Natianalities/', 
      widget.natinality.id.toString(), 
      request, 
      widget.token.token
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
  
 void _confirmDelete() async{
  var response =  await showAlertDialog(
      context: context,
      title: 'Confirmation', 
      message: 'Are you sure you want to delete the record ?',
      actions: <AlertDialogAction>[
          AlertDialogAction(key: 'no', label: 'No'),
          AlertDialogAction(key: 'yes', label: 'Yes'),
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
      '/api/Natianalities/', 
      widget.natinality.id.toString(), 
      widget.token.token
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
