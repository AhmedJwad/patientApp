import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/components/loader_component.dart';
import 'package:healthcare/helpers/api_helper.dart';
import 'package:healthcare/models/Nationality.dart';
import 'package:healthcare/models/response.dart';
import 'package:healthcare/models/token.dart';
import 'package:healthcare/screen/Nationality_Screen.dart';


class NationalitiesScreen extends StatefulWidget {
 final Token token;

 NationalitiesScreen ({required this.token});

  @override
  _nationalitiesScreen  createState() => _nationalitiesScreen();
}

class _nationalitiesScreen extends State<NationalitiesScreen> {
  List<Natinality> _nationality = [];
  bool _showLoader = false;
  bool _isFiltered = false;
  String _search = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getnationalities();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nationalities'),
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
  
  Future<Null> _getnationalities() async{
    setState(() {
      _showLoader=true;
    });
     Response response = await Apihelper.GetNationalities(widget.token.token);

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
      _nationality = response.result;
    });
  }

  void _removeFilter() {
    setState(() {
      _isFiltered = false;
    });
    _getnationalities();
  }

  void _showFilter() {
     showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text('Filtrar Nationalities'),
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

    List<Natinality> filteredList = [];
    for (var natinality in _nationality) {
      if (natinality.description.toLowerCase().contains(_search.toLowerCase())) {
        filteredList.add(natinality);
      }
    }

    setState(() {
     _nationality = filteredList;
      _isFiltered = true;
    });

    Navigator.of(context).pop();
  }
  
 
 Widget _getContent() {
   return _nationality.length == 0 
      ? _noContent()
      : _getListView();
 }
 
 Widget _noContent() {
   return Center(
      child: Container(
        margin: EdgeInsets.all(20),
        child: Text(
          _isFiltered
          ? 'There are no nationalities with that search criteria.'
          : 'There are no registered nationalities.',
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
      onRefresh: _getnationalities,
      child: ListView(
        children: _nationality.map((e) {
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
 void _goAdd() async {
    String? result = await Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => NationalityScreen(
          token: widget.token, 
          natinality: Natinality(description: '', id: 0, ),
        )
      )
    );
    if (result == 'yes') {
      _getnationalities();
    }
 }
 void _goEdit( Natinality  natinality) async {
   String? result = await Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => NationalityScreen(
          token: widget.token, 
          natinality: natinality,
        )
      )
    );
    if (result == 'yes') {
      _getnationalities();
    }
  }
}