import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/helpers/api_helper.dart';
import 'package:healthcare/models/Diagnosic.dart';
import 'package:healthcare/models/detail.dart';
import 'package:healthcare/models/history.dart';
import 'package:healthcare/models/patient.dart';
import 'package:healthcare/models/response.dart';
import 'package:healthcare/models/token.dart';
import 'package:healthcare/models/user.dart';

class DetailScreen extends StatefulWidget {
 final Token token;
 final User user ;
 final Patients patient;
 final Histories histories;
 final Details details;
 DetailScreen({required this.token, required this.user, required this.patient, required this.details, required this.histories});

  @override
  _detailScreenState createState() => _detailScreenState();
}

class _detailScreenState extends State<DetailScreen> {
  bool _showLoader=false;

  int _daignosicId=0;
  String _dagnosicError='';
  bool _diagnosicshowError=false;
  List<diagnosic> _diagnosics=[];

  String _description = '';
  String _descriptionError = '';
  bool _descriptionShowError = false;
  TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     _getdiagnosics();
     _loadFieldValues();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.details.id==0 ? 'New Details':widget.details.description),
      ),
      body:Stack(
       children:[
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _showDiagnosics(),
              _showDescription(),
              _showbuttons(),


            ],
          ),
        ),
       ],
      ),
    );  
  }


  Future<Null> _getdiagnosics() async {
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

    Response response = await Apihelper.Getdiagnosics(widget.token);

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
      _diagnosics = response.result;
    });
  }
  
  void _loadFieldValues() {
    _daignosicId=widget.details.diagonisic.id;
    _description=widget.details.description;
   _descriptionController.text=_description;
  }
  
 Widget _showDiagnosics() {
  return Container(
     padding: EdgeInsets.all(10),
      child: _diagnosics.length == 0 
        ? Text('loading diagnosics...')
        : DropdownButtonFormField(
            items: _getCombodiagnosic(),
            value: _daignosicId,
            onChanged: (option) {
              setState(() {
               _daignosicId = option as int;              
              });
            },
            decoration: InputDecoration(
              hintText: 'Select a diagnosic...',
              labelText: 'diagnosics',
              errorText: _diagnosicshowError ? _dagnosicError : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10)
              ),
            ),
          )
  );
 }
  
Widget  _showDescription() {
  return Container(
     padding: EdgeInsets.all(10),
      child: TextField(
        keyboardType: TextInputType.multiline,
        minLines: 4,
        maxLines: 4,
        controller: _descriptionController,
        decoration: InputDecoration(
          hintText: 'Enter a comment...',
          labelText: 'Comment',
          errorText:_descriptionShowError ? _descriptionError : null,
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
          widget.details.id == 0 
            ? Container() 
            : SizedBox(width: 20,),
          widget.details.id == 0 
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
  
 List<DropdownMenuItem<int>> _getCombodiagnosic() {
   List<DropdownMenuItem<int>> list = [];
    
    list.add(DropdownMenuItem(
      child: Text('Select a diagnosic...'),
      value: 0,
    ));

    _diagnosics.forEach((diagnosic) { 
      list.add(DropdownMenuItem(
        child: Text(diagnosic.description),
        value: diagnosic.id,
      ));
    });

    return list;

 }
 
void  _save() {
   if (!_validateFields()) {
      return;
    }

    widget.details.id == 0 ? _addRecord() : _saveRecord();
}
  
  
  
  bool _validateFields() {
     bool isValid = true;

    if (_daignosicId == 0) {
      isValid = false;
      _diagnosicshowError = true;
     _dagnosicError= 'You must select a diagnosic.';
    } else {
       _diagnosicshowError = false;
    }

    if (_description.isEmpty) {
      isValid = false;
     _descriptionShowError = true;
      _descriptionError = 'You must enter a comment.';
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

    Map<String, dynamic> request = {
      'HistoryId': widget.histories.id,
      'diagonisicId':_daignosicId,     
      'Description':_description,
    };

    Response response = await Apihelper.Post(
      '/api/Details/', 
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
        message: 'Check your internet connection.',
        actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Accept'),
        ]
      );    
      return;
    }

    Map<String, dynamic> request = {
      'id': widget.details.id,
      'historyId': widget.histories.id,
      'diagonisicId': _daignosicId,     
      'Description':_description,
    };

    Response response = await Apihelper.Put(
      '/api/Details/', 
      widget.details.id.toString(), 
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

    Response response = await Apihelper.Delete(
      '/api/Details/', 
      widget.details.id.toString(), 
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