import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/components/loader_component.dart';
import 'package:healthcare/helpers/api_helper.dart';
import 'package:healthcare/models/City.dart';
import 'package:healthcare/models/token.dart';
import 'package:healthcare/screen/City_Screen.dart';

import '../models/response.dart';

class Citiesscreen extends StatefulWidget {
 final Token token;
 Citiesscreen({required this.token});


  @override
  _citiesscreen createState() =>_citiesscreen();
}

class _citiesscreen extends State<Citiesscreen> {
  List<City> _cities=[];
   bool _showLoader = false;
   bool _isFiltered = false;
   String _search = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     _getCities();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cities'),
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
  
  Future<Null> _getCities() async{
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
    Response response = await Apihelper.Getcities(widget.token.token);

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
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
      _cities = response.result;
    });
  }

  void _removeFilter() {
    setState(() {
      _isFiltered = false;
    });
    _getCities();
  }

  void _showFilter() {
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text('Filter Cities'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Write the first letters of the procedure'),
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

    List<City> filteredList = [];
    for (var city in _cities) {
      if (city.description.toLowerCase().contains(_search.toLowerCase())) {
        filteredList.add(city);
      }
    }

    setState(() {
      _cities = filteredList;
      _isFiltered = true;
    });

    Navigator.of(context).pop();
 }
 
 Widget _getContent() {
    return _cities.length == 0 
      ? _noContent()
      : _getListView();
 }
 
 Widget _noContent() {
    return Center(
      child: Container(
        margin: EdgeInsets.all(20),
        child: Text(
          _isFiltered
          ? 'There are no cities with that search criteria.'
          : 'There are no registered cities.',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
 }
  
Widget  _getListView() {
   return RefreshIndicator(
      onRefresh: _getCities,
      child: ListView(
        children: _cities.map((e) {
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
        builder: (context) => CityScreen(
          token: widget.token, 
         city: City(description: '', id: 0,),
        )
      )
    );
    if (result == 'yes') {
     _getCities();
    }
 }
 
 void _goEdit(City city) async{
  String? result = await Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => CityScreen(
          token: widget.token, 
           city: city,
        )
      )
    );
    if (result == 'yes') {
      _getCities();
    }
  }
 
}