
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/components/loader_component.dart';
import 'package:healthcare/helpers/api_helper.dart';
import 'package:healthcare/models/Diagnosic.dart';
import 'package:healthcare/models/response.dart';
import 'package:healthcare/models/token.dart';
import 'package:healthcare/screen/diagnosic_screen2.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';

class DiagnosicScreen extends StatefulWidget {
  final Token token ;


  DiagnosicScreen({required this.token});

  @override
 _diagnosicScreen createState() => _diagnosicScreen();
}

class _diagnosicScreen extends State<DiagnosicScreen> {
  List<diagnosic> _diagnosic= [];
   bool _showLoader = false;
   bool _isFilter=false;
   String _search='';  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getdiagnosics();
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(title:Text ('diagnosics') ,
       actions: <Widget>
       [
        _isFilter ? IconButton(onPressed: _removeFilter, icon: Icon(Icons.filter)):IconButton(onPressed:  _showFilter, icon: Icon(Icons.filter_alt)),
       ],    
       ),
       
       body: Center(
        child:_showLoader ? LoaderComponent(text: ('Loading...'),) :_getcontent(),        
       ),
        floatingActionButton: FloatingActionButton(
      onPressed: () => _goAdd(),      
      child: Icon(Icons.add),         
         ),
    );
   
  }
  
  Future<Null> _getdiagnosics() async{
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
    Response response=await Apihelper.Getdiagnosics(widget.token);
   setState(() {
     _showLoader=false;
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
   }
   setState(() {
     _diagnosic=response.result;
   });
  }
  
  Widget _getcontent() {
    return _diagnosic.length==0 ? _nocontent():_getlistView();
    
  }
  
  _nocontent() {
    return Center(
     child:      
     Container(
      margin: EdgeInsets.all(20),
       child: Text(
          _isFilter? 'There are no diagnosic  with that search criteria.': 'There are no registered diagnosic.',         
       style: TextStyle(
        fontSize: 16 , fontWeight:FontWeight.bold,
        ),
       ),
     )
      );
  }
  
 Widget _getlistView() {
  return RefreshIndicator(    
   onRefresh: _getdiagnosics,
    child: ListView(
      children: _diagnosic.map((e){
           return Card(
             child: InkWell(
              onTap: ()=>_goEdit(e) ,
              child: Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(e.description, style: TextStyle(fontSize: 18, ),
             ),
             Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                  SizedBox(height: 20,),
                ],
              ),
             ),
             
      ),
           );
      }).toList(),
    ),
  );
 }

  void _showFilter() {
    showDialog(
      context: context,
       builder: (context){
       return AlertDialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
       title:Text('Filter diagnosics'),
       content: Column(
       mainAxisSize: MainAxisSize.min,
       children: <Widget>[
        Text('Write the first letters of the diagnosics'),
        SizedBox(height: 10,),
        TextField(
          decoration: InputDecoration(
          hintText: 'Search criteria...',
          labelText: 'Search',
          suffixIcon: Icon(Icons.search),
          ),
          onChanged: (value) => {
           _search=value,
          },
        ),
       ],
       ),
       actions: <Widget>[
        TextButton(onPressed:()=> Navigator.of(context).pop(),
        child: Text('Cacel'),
        ),
        TextButton(onPressed:()=> _filter(),
        child: Text('filter'),
        )
       ],
       
       );

        }
      );
  }

  void _removeFilter() {
    setState(() {
      _isFilter=false;
    });
    _getdiagnosics();
  }
  
 void _filter() {
  if(_search.isEmpty)
  {
    return;
  }
 List<diagnosic>filterList=[];
 for (var diagnosic in _diagnosic) {
   if(diagnosic.description.toLowerCase().contains(_search.toLowerCase()))
   {
    filterList.add(diagnosic);
   }
 }  
 setState(() {
    _diagnosic=filterList;
    _isFilter=true;
  });
  Navigator.of(context).pop();
 }
 
 void _goAdd() async{
   {
      String? result=await Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context)=> diagnosicscreen(
            token: widget.token, 
            diagnosic1: diagnosic (description: '' , id: 0)   ,        
          ),
          ),   
       );
       if(result =='yes')
       {
        _getdiagnosics();
       }
      } 
  }
  
 void _goEdit(diagnosic diagnosic) async{
  {
          String? result=await  Navigator.push(
                    context, 
                    MaterialPageRoute(
                    builder: (context)=> diagnosicscreen(
                    token: widget.token, 
                    diagnosic1: diagnosic,        
          ),
          ),   
       );
           
             if(result =='yes')
       {
        _getdiagnosics();
       }
  };

 }
}