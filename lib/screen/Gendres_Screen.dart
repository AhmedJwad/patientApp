import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/components/loader_component.dart';
import 'package:healthcare/helpers/api_helper.dart';
import 'package:healthcare/models/gendre.dart';
import 'package:healthcare/models/response.dart';
import 'package:healthcare/screen/Gendre_Screen.dart';
import '../models/token.dart';

class GendresScreen extends StatefulWidget {
  final Token token;
  GendresScreen({required this.token});

  @override
  _gendresScreen createState() => _gendresScreen();}

class  _gendresScreen extends State<GendresScreen> {
  List<Gendre> _gendres = [];
  bool _showLoader = false;
  bool _isFiltered = false;
  String _search = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getGendres();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gendres'),
        actions: <Widget>[
          _isFiltered
          ? IconButton(
              onPressed: _removeFilter, 
              icon: Icon(Icons.filter_none)
            )
          : IconButton(
              onPressed: _showFilter, 
              icon: Icon(Icons.filter_alt)
            )
        ],
      ),
      body: Center(
        child: _showLoader ? LoaderComponent(text: 'Loading...') : _getContent(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _goAdd(),
      ),
    );    
  }
  
  Future<Null> _getGendres() async{
    setState(() {
      _showLoader =true;
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
    Response response=await Apihelper.GetGendre(widget.token.token);

    setState(() {
      _showLoader =false;
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
    setState(() {
      _gendres=response.result;
    });

  }

  void _removeFilter() {
    setState(() {
      _isFiltered = false;
    });
    _getGendres();
  }

  void _showFilter() {
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text('Filtrar Gendres'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Write the first letters of the gendres'),
              SizedBox(height: 10,),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search criteria...',
                  labelText: 'Search',
                  suffixIcon: Icon(Icons.search)
                ),
                onChanged: (value) {
                  _search = value;
                },
              )
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(), 
              child: Text('Cancel')
            ),
            TextButton(
              onPressed: () => _filter(), 
              child: Text('Filter')
            ),
          ],
        );
      });
  }
  
 void _filter() {
   if (_search.isEmpty) {
      return;
    }

    List<Gendre> filteredList = [];
    for (var gendres in _gendres) {
      if (gendres.description.toLowerCase().contains(_search.toLowerCase())) {
        filteredList.add(gendres);
      }
    }

    setState(() {
     _gendres = filteredList;
      _isFiltered = true;
    });

    Navigator.of(context).pop();
 }
 
Widget  _getContent() {
  return _gendres.length == 0 
      ? _noContent()
      : _getListView();
}

 Widget _noContent() {
  return Center(
      child: Container(
        margin: EdgeInsets.all(20),
        child: Text(
          _isFiltered
          ? 'There are no gendres with that search criteria.'
          : 'There are no registered gendres.',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
  
 Widget _getListView() {
   return RefreshIndicator(
      onRefresh:_getGendres,
      child: ListView(
        children:_gendres.map((e) {
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
  
 void _goAdd() async{
  String? result = await Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => GendreScreen(
          token: widget.token, 
          gendre: Gendre(description: '', id: 0, ),
        )
      )
    );
    if (result == 'yes') {
      _getGendres();
    }
 }
 
 void _goEdit(Gendre gendre) async{
  String? result = await Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => GendreScreen(
          token: widget.token, 
          gendre: gendre,
        )
      )
    );
    if (result == 'yes') {
      _getGendres();
    }
 }
}