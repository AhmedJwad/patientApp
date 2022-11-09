import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/helpers/api_helper.dart';
import 'package:healthcare/models/UserPatient.dart';
import 'package:healthcare/models/token.dart';

import '../components/loader_component.dart';
import '../models/response.dart';


class UserPatients extends StatefulWidget {
 final Token token;

 UserPatients({required this.token});

  @override
   _userPatientsState  createState() =>  _userPatientsState();
   

}

class  _userPatientsState extends State<UserPatients> {
  List<UserPatient> _userpatients=[];
   bool _showLoader = false;
   bool _isFiltered = false;
   String _search = '';
   
    
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserPatients();
  }
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(
        title: Text('User of Patients'),
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
        onPressed: () => {},
      ),
    );
  }
  
  Future<Null> _getUserPatients() async{
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
    Response response = await Apihelper.GetUsersPatient(widget.token);

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
      _userpatients = response.result;
    });
  }
  
   Widget _getContent() {
    return _userpatients.length == 0 
      ? _noContent()
      : _getListView();
 }
 
 Widget _noContent() {
  return Center(
      child: Container(
        margin: EdgeInsets.all(20),
        child: Text(
          _isFiltered
          ? 'There are no users with that search criteria.'
          : 'There are no registered users.',
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
      onRefresh: _getUserPatients,
      child: ListView(
        children:_userpatients.map((e) {
          return Card(
            child: InkWell(
              onTap: () =>{},
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(5),
                child: Row(               
                  children: [
                    ClipRRect(
                       
                    ),
                  Expanded(
                     child:Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.start,   
                         children: [
                           Column(                                        
                              children: [
                                Text(
                                  e.firstName, 
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),    
                                SizedBox(height: 5,),
                                 Text(
                                  e.email, 
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),  
                                SizedBox(height: 5,), 
                                Text(
                                  e.phoneNumber, 
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),                                         
                              ],
                            ),
                         ],
                       ),
                     ),
                   ),    
                      Icon(Icons.arrow_forward_ios),               
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
 }

  void _removeFilter() {
     setState(() {
      _isFiltered = false;
    });
   _getUserPatients();
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
  
  _filter() {
     if (_search.isEmpty) {
      return;
    }

    List<UserPatient> filteredList = [];
    for (var userpatient in _userpatients) {
      if (userpatient.firstName.toLowerCase().contains(_search.toLowerCase())) {
        filteredList.add(userpatient);
      }
    }

    setState(() {
      _userpatients = filteredList;
      _isFiltered = true;
    });

    Navigator.of(context).pop();
  }
}