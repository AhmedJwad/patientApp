import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/components/loader_component.dart';
import 'package:healthcare/helpers/api_helper.dart';
import 'package:healthcare/models/Diagnosic.dart';
import 'package:healthcare/models/token.dart';
import 'package:healthcare/models/Diagnosic.dart';

import '../models/response.dart';
class diagnosicscreen extends StatefulWidget {
 final Token token;
 final diagnosic diagnosic1;
 diagnosicscreen({required this.token , required this.diagnosic1});
  @override
  _diagnosicscreenState createState() => _diagnosicscreenState();
}

class  _diagnosicscreenState extends State<diagnosicscreen> {
  bool _showLoadre=false; 
  String _description='';
  String _descripitionError='';
  bool _descripitionshowError= false;
  TextEditingController _descripitionController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _description=widget.diagnosic1.description;
    _descripitionController.text=_description;
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar:AppBar(title:Text(widget.diagnosic1.id==0 ? 'New diagnosic' : widget.diagnosic1.description),
       
       ) ,  
      
       body: Stack(
         children: [
           Column(
            children:<Widget>[
             _showdescription(),
             _showbuttons(),
            ],
           ),
           _showLoadre ? LoaderComponent(text:"Loading ",):Container(),
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
          hintText: "Description",
          labelText: "Description",
          errorText: _descripitionshowError ? _descripitionError:null,
          suffixIcon: Icon(Icons.description),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onChanged: (value) => {
          _description=value,
        },
      ),
    );
  }
  
 Widget _showbuttons() {
   return Container(
    margin: EdgeInsets.only(left: 10 , right: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
            Expanded(
              child: ElevatedButton(
                child: Text('Save'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState>State){
                       return Color(0xFF120E43);
                    }
                  ),
                ),
                onPressed: () => _Save(),
              ),
              ),
              widget.diagnosic1.id==0?Container():
                SizedBox(width: 20,),
              widget.diagnosic1.id==0?
              Container():
              Expanded(
              child: ElevatedButton(
                child: Text('Delete'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState>State){
                       return Color(0xFFB4161B);
                    }
                  ),
                ),
                onPressed: () => _confirmDelete(),
              ),
              )
      ],
    ),      
    );
 }
 
 void _Save() {
  if(!_validateFields())
  {
    return;
  }
  widget.diagnosic1.id==0 ? addRecord(): _saveRecord();
 }
 
  bool _validateFields() {
    bool isValid=true;
    if(_description.isEmpty)
    {
      isValid=false;
      _descripitionshowError=true;
      _descripitionError="You must enter a description.";      
    }
    else
    {
      _descripitionshowError=false;
    }
    setState(() {      
    });
    return isValid;
  }
  
  void addRecord() async{
    setState(() {
       _showLoadre = true;
    });
    Map<String , dynamic>request ={
     'description': _description,
    };
    Response response=await Apihelper.Post('/api/diagonisics/', request, widget.token.token);
    if(!response.isSuccess)
    {
      await showAlertDialog(
        context: context,
        title: 'error',
        message: response.message,
        actions: <AlertDialogAction>[
          AlertDialogAction(key:null, label:  'Accept')
        ]
      );
      return;
    }
    setState(() {
      _showLoadre=false;
    });
    Navigator.pop(context, 'yes');
  }
  
  void _saveRecord() async{
    setState(() {
      _showLoadre=true;
    });   
     Map<String , dynamic>request ={
      'id':widget.diagnosic1.id,
      'description':_description,
     };
     Response response=await Apihelper.Put('/api/diagonisics/', widget.diagnosic1.id.toString(), request, widget.token.token);    
      setState(() {
      _showLoadre=false;
      });   
      if(!response.isSuccess)
      {
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
      Navigator.pop(context,'yes');
    }
    
     void _confirmDelete() async{
      var response =await showAlertDialog(
        context: context,
        title: 'Confirmation',
        message: 'Are you sure you want to delete the record?',
        actions: <AlertDialogAction>[
          AlertDialogAction(key: 'no', label: 'No'),
           AlertDialogAction(key: 'yes', label: 'Yes'),
        ]
        );
        if(response=='yes')
        {
           _deleteRecord();
        }

     }
     
       void _deleteRecord() async{
        setState(() {
          _showLoadre==true;
        });

        Response response=await Apihelper.Delete('/api/diagonisics/', widget.diagnosic1.id.toString(),  widget.token.token);

         setState(() {
          _showLoadre==false;
        });
        if(!response.isSuccess)
        {
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