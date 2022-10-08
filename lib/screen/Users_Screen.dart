import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/components/loader_component.dart';
import 'package:healthcare/helpers/api_helper.dart';
import 'package:healthcare/models/response.dart';
import 'package:healthcare/models/token.dart';
import 'package:healthcare/models/user.dart';
import 'package:healthcare/screen/user_screen.dart';

class UsersSCeen extends StatefulWidget {
  final Token token;
 UsersSCeen({required this.token});

  @override
  _usersSCeen createState() =>  _usersSCeen();
}

class  _usersSCeen extends State<UsersSCeen> {
   List<User> _users=[];
   bool _showLoader = false;
   bool _isFiltered = false;
   String _search = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     _getUsers();
  }
  @override
  Widget build(BuildContext context) {
      return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
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
  
  Future<Null>_getUsers() async{
    setState(() {
      _showLoader=true;
    });
    Response response = await Apihelper.GetUsers(widget.token.token);

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
      _users = response.result;
    });    
  }

  void _removeFilter() {
     setState(() {
      _isFiltered = false;
    });
   _getUsers();
  }

  void _showFilter() {
     showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text('Filter Users'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Write the first letters of the user'),
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

    List<User> filteredList = [];
    for (var user in _users) {
      if (user.fullName.toLowerCase().contains(_search.toLowerCase())) {
        filteredList.add(user);
      }
    }

    setState(() {
     _users = filteredList;
      _isFiltered = true;
    });

    Navigator.of(context).pop();
 }
 
 Widget _getContent() {
   return _users.length == 0 
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
      onRefresh: _getUsers,
      child: ListView(
        children: _users.map((e) {
          return Card(
            child: InkWell(
              onTap: () => _goEdit(e),
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(5),
                child: Row(               
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: FadeInImage(
                        placeholder: AssetImage('/assets/noimage.png'),
                         image:NetworkImage(e.imageFullPath),
                         width: 80,
                         height: 80,
                         fit: BoxFit.cover,
                         ),
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
                                  e.fullName, 
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
 
    
 void _goAdd() async{
    String? result = await Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => UserScreen(
          token: widget.token, 
         user: User(
          firstName: '',
          lastName: '',
          address: '', 
          imageId:'',
          imageFullPath: '',
          userType: 1, 
          fullName: '',
          patients:[],
          patientsCount: 0,
          id: '',
          userName: '',
          email: '',
          phoneNumber: ''),
        )
      )
    );
    if (result == 'yes') {
     _getUsers();
    }
 }
 
 void _goEdit(User user) async{
  String? result = await Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => UserScreen(
          token: widget.token, 
          user: user,
        )
      )
    );
    if (result == 'yes') {
     _getUsers();
    }  
 }
}