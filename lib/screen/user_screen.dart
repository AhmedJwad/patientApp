import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/helpers/api_helper.dart';
import 'package:healthcare/models/response.dart';

import '../components/loader_component.dart';
import '../models/token.dart';
import '../models/user.dart';

class UserScreen extends StatefulWidget {
final Token token;
  final User user;
  
  UserScreen({required this.token , required this.user});

  @override
 _userScreen createState() => _userScreen();
}

class _userScreen extends State<UserScreen> {
  bool _showLoader = false;
  String _firsName = '';
  String _firsNameError = '';
  bool _firsNameShowError = false;
  TextEditingController _firsNameController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState    
     _firsName = widget.user.fullName;
   _firsNameController.text = _firsName;   
  }
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.user.id.isEmpty
            ? 'New User' 
            : widget.user.fullName
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              _showfirstName(),            
              _showButtons(),
            ],
          ),
          _showLoader ? LoaderComponent(text: 'Loading...',) : Container(),
        ],
      ),
    );        
  }
  
  _showfirstName() {
     return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller:_firsNameController,
        decoration: InputDecoration(
          hintText: 'Enter a description......',
          labelText: 'Description',
          errorText: _firsNameShowError ? _firsName : null,
          suffixIcon: Icon(Icons.person),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)
          ),
        ),
        onChanged: (value) {
          _firsName = value;
        },
      ),
    );
  }
  
  _showButtons() {
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
          widget.user.id.isEmpty
            ? Container() 
            : SizedBox(width: 20,),
          widget.user.id.isEmpty
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
  
void  _save() {
     if (!_validateFields()) {
      return;
    }

    widget.user.id .isEmpty ? _addRecord() : _saveRecord();
  }
  
  bool _validateFields() {
     bool isValid = true;

    if (_firsName.isEmpty) {
      isValid = false;
      _firsNameShowError = true;
      _firsNameError = 'You must enter a first name..';
    } else {
     _firsNameShowError = false;
    }  

    setState(() { });
    return isValid;
  }
  
 void _addRecord() async{

 setState(() {
      _showLoader = true;
    });
    Map<String, dynamic> request = {    
      'firstname': _firsName,     
    };

    Response response;
    response = await Apihelper.Post(
      '/api/Users/', 
      request, 
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
    
     void _saveRecord() async{
      setState(() {
      _showLoader = true;
    });
     Map<String, dynamic> request = {
      'id': widget.user.id,
      'firstname': _firsName,
    
    };

    Response response = await Apihelper.Put(
      '/api/users/', 
      widget.user.id, 
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
     
     void  _confirmDelete() async{
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
     Response response = await Apihelper.Delete(
      '/api/CUsers/', 
      widget.user.id, 
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