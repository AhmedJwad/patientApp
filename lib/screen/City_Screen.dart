import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/helpers/api_helper.dart';
import 'package:healthcare/models/City.dart';
import 'package:healthcare/models/response.dart';
import 'package:healthcare/models/token.dart';

import '../components/loader_component.dart';

class CityScreen extends StatefulWidget {
  final Token token;
  final City city;

  CityScreen({ required this.token , required this.city});
  
  @override
  
  _cityScreen createState() =>  _cityScreen();
}

class  _cityScreen extends State<CityScreen> {
  bool _showLoader = false;
  String _description = '';
  String _descriptionError = '';
  bool _descriptionShowError = false;
  TextEditingController _descriptionController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     _description = widget.city.description;
    _descriptionController.text = _description;   
  }
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.city.id == 0 
            ? 'New City' 
            : widget.city.description
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
  
 Widget _showDescription() {
   return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: _descriptionController,
        decoration: InputDecoration(
          hintText: 'Enter a description......',
          labelText: 'Description',
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
          widget.city.id == 0 
            ? Container() 
            : SizedBox(width: 20,),
          widget.city.id == 0 
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

    widget.city.id == 0 ? _addRecord() : _saveRecord();
 }
 
  bool _validateFields() {
    bool isValid = true;

    if (_description.isEmpty) {
      isValid = false;
      _descriptionShowError = true;
      _descriptionError = 'You must enter a description..';
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
    Map<String, dynamic> request = {
      'description': _description,     
    };

    Response response = await Apihelper.Post(
      '/api/Cities/', 
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
      'id': widget.city.id,
      'description': _description,
    
    };

    Response response = await Apihelper.Put(
      '/api/Cities/', 
      widget.city.id.toString(), 
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
      title: 'Confirmación', 
      message: '¿Estas seguro de querer borrar el registro?',
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
      '/api/Cities/', 
      widget.city.id.toString(), 
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