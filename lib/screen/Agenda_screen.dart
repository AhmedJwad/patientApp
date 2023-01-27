import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import "package:flutter/material.dart";
import 'package:healthcare/helpers/api_helper.dart';
import 'package:healthcare/models/Agenda.dart';
import 'package:healthcare/models/UserResponse.dart';
import 'package:healthcare/models/patient.dart';
import 'package:healthcare/models/patientresponse.dart';
import 'package:healthcare/models/response.dart';
import 'package:healthcare/models/token.dart';
import 'package:healthcare/models/user.dart';

import '../components/loader_component.dart';


class AgendaScrren extends StatefulWidget {
   final Token token;
  final User user;
  final Agenda agenda;
  final Patients patient;

  AgendaScrren({required this.token ,required this.user, required this.agenda,required this.patient});

  @override
  _agendaScrrenState createState() => _agendaScrrenState();
}

class _agendaScrrenState extends State<AgendaScrren> {
   late User _user;
   bool _showLoader=false;
   String _description='';
  String _descriptionError='';
  bool _descriptionShowErrorr=false;
  TextEditingController _descriptioncontroller= TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();   
     //_getUser(); 
    _user=widget.user;
    widget.patient.id==_user.patients.map((e) => e.id);
   
    
  }
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(
        title: Text(
          "add appointmet"
        ),
      ),
      body: Stack(
        children: [
         SingleChildScrollView(
          child: Column(
            children: <Widget>[
               _showDescription(),
                _showButtons(),
            ],
          ),
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
            keyboardType: TextInputType.multiline,
            controller:_descriptioncontroller,
            decoration: InputDecoration(
              hintText: 'Enter a description',
              labelText: 'Description',
              errorText:_descriptionShowErrorr ? _descriptionError : null,
              suffixIcon: Icon(Icons.notes),
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
          widget.agenda.id == 0 
            ? Container() 
            : SizedBox(width: 20,),
          widget.agenda.id == 0 
            ? Container() 
            : Expanded(
                child: ElevatedButton(
                  child: Text('Cancel'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        return Color(0xFFB4161B);
                      }
                    ),
                  ),
                  onPressed: () => _cancel(), 
              ),
          ),
        ],
      ),
  );
 }
 
 void _save() {
  if(!validateFields())
  {
    return;
  }
   _addRecord();
 }
  
void  _cancel() {
   Navigator.pop(context, 'yes');
}
  
  bool validateFields() {
      bool isValid=true;
       if(_description.isEmpty)
            {
              isValid=false;
            _descriptionShowErrorr=true;
          _descriptionError='You must enter a  description';

    }else
    {
      _descriptionShowErrorr=false;
    }
    setState(() {
      
    });
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
        message: 'check your internet connection.',
        actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Accept'),
        ]
      );    
      return;
    }

    Map<String, dynamic> request = {
      'AgendaId':widget.agenda.id,    
      'UserId': widget.user.id,
      'PatientId':widget.patient.id,      
      'Description': _description,
         
      };

    Response response = await Apihelper.Post(
      '/api/Agenda/AssignAgenda',      
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
  }
