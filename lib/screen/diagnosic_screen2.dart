import 'package:flutter/material.dart';
import 'package:healthcare/models/Diagnosic.dart';
import 'package:healthcare/models/token.dart';
import 'package:healthcare/models/Diagnosic.dart';
class diagnosicscreen extends StatefulWidget {
 final Token token;
 final diagnosic diagnosic1;
 diagnosicscreen({required this.token , required this.diagnosic1});
  @override
  _diagnosicscreenState createState() => _diagnosicscreenState();
}

class  _diagnosicscreenState extends State<diagnosicscreen> {
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
       appBar:AppBar(title:Text(widget.diagnosic1.id==0 ? 'New diagnosic' : widget.diagnosic1.description), ) ,   
       body: Column(
        children:<Widget>[
         _showdescription(),
         _showbuttons(),
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
                onPressed: () => {},
              ),
              ),
              widget.diagnosic1.id==0?Container():
                SizedBox(width: 20,),
              widget.diagnosic1.id==0?
              Container():
              Expanded(
              child: ElevatedButton(
                child: Text('Cancel'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState>State){
                       return Color(0xFFB4161B);
                    }
                  ),
                ),
                onPressed: () => {},
              ),
              )
      ],
    ),      
    );
 }
}