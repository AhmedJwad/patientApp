import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/components/loader_component.dart';
import 'package:healthcare/helpers/api_helper.dart';
import 'package:healthcare/models/bloodtypes.dart';
import 'package:healthcare/models/response.dart';
import 'package:healthcare/models/token.dart';
import 'package:healthcare/screen/BloodTypes_Screen.dart';

class BloodTypeScreen extends StatefulWidget {  
 final Token token;

BloodTypeScreen({required this.token});

  @override
  _bloodtypescreenstate createState() => _bloodtypescreenstate();
}

class _bloodtypescreenstate extends State<BloodTypeScreen> {

  List<bloodtypes>_bloodtypes=[];
  bool _showLoader=false;
  bool _isFiltered = false;
  String _search = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getbloodtypes();
  }
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("types of blood"),
      actions: <Widget>[
        _isFiltered?IconButton(onPressed: _removeFilter,  icon: Icon(Icons.filter_none))
        :IconButton(onPressed: _showFilter,  icon: Icon(Icons.filter_alt))
      ],
    ),
    body: Center(
      child: _showLoader ? LoaderComponent(text: 'Loading...',): _getContent(),
    ),
    floatingActionButton: FloatingActionButton(child: Icon(Icons.add), onPressed: () => _goAdd(),),
  );
  }
  
  Future<Null> _getbloodtypes() async{
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
Response response=await Apihelper.Getbloodtypes(widget.token);
  setState(() {
      _showLoader = false;
    });
if(!response.isSuccess)
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
   setState(() {
     _bloodtypes=response.result;
   });   
  }

  void _removeFilter() async{
    setState(() {
      _isFiltered=false;
    });
    _getbloodtypes();
  }

  _showFilter() {
   showDialog(
    context: context,
     builder:(context){
      return AlertDialog(
         shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text('filter types of blodd'),
          content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
          Text('Write the first letters of the procedure'),
          SizedBox(width: 10,),
          TextField(
            decoration: InputDecoration(
                  hintText: 'Search criteria......',
                  labelText: 'Search',
                  suffixIcon: Icon(Icons.search)              
            ),
               onChanged:(value){
                _search=value;
               }
              ),         
          ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(), 
              child: Text('Cancelar')
            ),
            TextButton(
              onPressed: () => _filter(), 
              child: Text('Filtrar')
            ),
          ],
        );
     }
    );
  }
  
 void _filter() {
  if (_search.isEmpty) {
      return;
    }

    List<bloodtypes> filteredList = [];
    for (var bloodtypes in _bloodtypes) {
      if (bloodtypes.description.toLowerCase().contains(_search.toLowerCase())) {
        filteredList.add(bloodtypes);
      }
    }

    setState(() {
      _bloodtypes = filteredList;
      _isFiltered = true;
    });

    Navigator.of(context).pop();
 }
 
 Widget _getContent() {
  return _bloodtypes.length==0?
  _nocontent():_getListView();
 }
 
 Widget _getListView() {
   return RefreshIndicator(
      onRefresh: _getbloodtypes,
      child: ListView(
        children: _bloodtypes.map((e) {
          return Card(
            child: InkWell(
              onTap: () => _goEdit(e),
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(5),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          e.description, 
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios),
                      ],
                    ),                  
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
 }
  
 Widget _nocontent() {
  return Center(
      child: Container(
        margin: EdgeInsets.all(20),
        child: Text(
          _isFiltered
          ? 'There are no blood types with that search criteria.'
          : 'There are no registered blood types.',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
 }
 
 void _goEdit(bloodtypes bloodtypes) async{
  String? result = await Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => BloodTypesScreen(
          token: widget.token, 
          bloodtypess: bloodtypes,
        )
      )
    );
    if (result == 'yes') {
     _getbloodtypes();
    }
  
 }
 
 void _goAdd() async {
  String? result = await Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => BloodTypesScreen(
          token: widget.token, 
          bloodtypess: bloodtypes(description: '', id: 0, ),
        )
      )
    );
    if (result == 'yes') {
     _getbloodtypes();
    }
 }
}

