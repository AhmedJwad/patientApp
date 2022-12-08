import 'dart:convert';
import 'dart:io';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/models/City.dart';
import 'package:healthcare/models/Nationality.dart';
import 'package:healthcare/models/UserPatient.dart';
import 'package:healthcare/models/bloodtypes.dart';
import 'package:healthcare/models/gendre.dart';
import 'package:healthcare/models/patient.dart';
import 'package:healthcare/models/response.dart';
import 'package:healthcare/models/token.dart';
import 'package:healthcare/helpers/api_helper.dart';
import 'package:healthcare/screen/UserPatients.dart';
import 'package:healthcare/screen/take_picture_screen.dart';
import 'package:image_picker/image_picker.dart';
import '../components/loader_component.dart';
import '../models/user.dart';
import 'package:intl/intl.dart';


class PatientScreen extends StatefulWidget {
  final Token token;
  final User user;
  final Patients patient;
 PatientScreen({required this.token ,required this.user, required this.patient});

  @override
  _patientScreenState createState() => _patientScreenState();
}

class _patientScreenState extends State<PatientScreen> {
  bool _showLoader=false;
  bool _photochanged=false;
  late XFile _image;
  int _current=0;
   CarouselController _carouselController = CarouselController();
  int _cityId=0;
  String _CityError='';
  bool _cityShowError=false;
  List<City> _cities=[];

  int _bloodtypeId=0;
  String _bloodtypeError='';
  bool _bloodtypeShowError=false;
  List<bloodtypes> _bloodTypes=[];

  int _gendreId=0;
  String _gendreError='';
  bool _gendreShowError=false;
  List<Gendre> _gendress=[];

  int _nationalityId=0;
  String _nationalityError='';
  bool _nationalityShowError=false;
  List<Natinality> _nationalities=[];

  int _userPatientyId=0;
  String _userPatientError='';
  bool _userPatientShowError=false;
  List<UserPatient> _userPatients=[];

  String _date='';
  String _dateerror='';
  bool _dateshowerror=false;
  TextEditingController _datecontroller= TextEditingController();

  String _firstName='';
  String _firstNameError='';
  bool _firstNameShowErrorr=false;
  TextEditingController _firstNamecontroller= TextEditingController();

  String _lastName='';
  String _lastNameError='';
  bool _lastNameShowErrorr=false;
  TextEditingController _lastNamecontroller= TextEditingController();

  String _description='';
  String _descriptionError='';
  bool _descriptionShowErrorr=false;
  TextEditingController _descriptioncontroller= TextEditingController();

  String _address='';
  String _addressError='';
  bool _addressShowErrorr=false;
  TextEditingController _addresscontroller= TextEditingController();

  String _epcNumber='';
  String _epcNumberError='';
  bool _epcNumberShowErrorr=false;
  TextEditingController _epcNumbercontroller= TextEditingController();

  String _mobileNumber='';
  String _mobileNumberError='';
  bool _mobileNumberShowErrorr=false;
  TextEditingController _mobileNumbercontroller= TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _datecontroller.text="";
    _loadData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.patient.id==0 ? 'Add Patient' : '${widget.patient.fullName}'
        ),
      ),
      body: Stack(
        children: [
         SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _showPatientPhoto(),  
              _showfirstName(),
              _showLastName(),
              _showAdress(),
              _showDate(),
              _showEpcNumber(),
              _showDescription(),
              _showmobileNumber(),
              _showCity(),
              _shownationality(),              
              _showGendre(),      
              _showBloodType(),          
              _showUserPatient(),    
                                     
             _showButtons(),
            ],
          ),
         ),
         _showLoader ? LoaderComponent(text: 'Loading...',) : Container(),
        ],
      ),
    );
  }
   Widget _showPatientPhoto() {
    return widget.patient.id==0?
    _showPatientUniquePhoto():
    _showPhotosCarousel();

   }

  Widget _showPatientUniquePhoto() {
    return  Stack(
            children:<Widget>[
               Container(
              margin: EdgeInsets.only(top: 10),
              child:widget.patient.id==0 && !_photochanged ? Image
                    (
                      image: AssetImage('assets/noimage.png'),           
                        height: 160,
                        width: 160,
                        fit: BoxFit.cover,
                        ): ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child:_photochanged ? 
                            Image.file(
                             File(_image.path),
                             height: 160,
                             width: 160,
                             fit: BoxFit.cover,
                            )
                          : CachedNetworkImage(
                                imageUrl: widget.patient.imageFullPath,
                                errorWidget: (context, url, error) => Icon(Icons.error),
                                fit: BoxFit.cover,
                                height: 160,
                                width: 160,
                                placeholder: (context, url) => Image(
                                  image: AssetImage('assets/noimage.png'),
                                  fit: BoxFit.cover,
                                  height: 160,
                                  width: 160,
                    ),
                       
                          ),
                           ),
            ),
             Positioned(
              bottom: 0,
              left: 100,
              child: InkWell(
                onTap: ()=>_Takepicture(),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    color: Colors.green[50],
                    height: 60,
                    width: 60,
                    child: Icon(Icons.photo_camera, size: 40, color: Colors.blue,),
                  ),
                ),
              ),
              ),
              
            Positioned(
              bottom: 0,
              left: 0,
              child:InkWell(
                onTap: ()=> _selectPicture(),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    color: Colors.green[50],
                    height: 60,
                    width: 60,
                    child: Icon(Icons.image, size: 40, color: Colors.blue,),
                  ),
                ),
              ),
              ),
              
            ]
          );
  
 }
  
 Widget _showCity() {
  return Container(
      padding: EdgeInsets.all(10),
      child: _cities.length == 0 
        ? Text('Loading Cities...')
        : DropdownButtonFormField(
            items: _getComboCities(),
            value: _cityId,
            onChanged: (option) {
              setState(() {
                _cityId = option as int;
              });
            },
            decoration: InputDecoration(
              hintText: 'Select a city...',
              labelText: 'City',
              errorText: _cityShowError ? _CityError : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10)
              ),
            ),
          )
    );
 }
  
 Widget _showBloodType() {
   return Container(
      padding: EdgeInsets.all(10),
      child: _bloodTypes.length == 0 
        ? Text('Loading blood types...')
        : DropdownButtonFormField(
            items: _getComboBloodTypes(),
            value: _bloodtypeId,
            onChanged: (option) {
              setState(() {
                _bloodtypeId = option as int;
              });
            },
            decoration: InputDecoration(
              hintText: 'Select a type of blood...',
              labelText: 'type of blood',
              errorText:_bloodtypeShowError ? _bloodtypeError : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10)
              ),
            ),
          )
    );
 }
  
 Widget _showGendre() {
   return Container(
      padding: EdgeInsets.all(10),
      child: _gendress.length == 0 
        ? Text('Loading Gendre...')
        : DropdownButtonFormField(
            items: _getComboGendres(),
            value: _gendreId,
            onChanged: (option) {
              setState(() {
                _gendreId = option as int;
              });
            },
            decoration: InputDecoration(
              hintText: 'Select a gendre...',
              labelText: 'Gendre',
              errorText: _gendreShowError ? _gendreError : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10)
              ),
            ),
          )
    );
 }
 Widget _shownationality() {
    return Container(
      padding: EdgeInsets.all(10),
      child: _nationalities.length == 0 
        ? Text('Loading nationalities...')
        : DropdownButtonFormField(
            items: _getComboNationalitis(),
            value: _nationalityId,
            onChanged: (option) {
              setState(() {
               _nationalityId = option as int;
              });
            },
            decoration: InputDecoration(
              hintText: 'Select a nationality...',
              labelText: 'Nationality',
              errorText: _nationalityShowError ?_nationalityError : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10)
              ),
            ),
          )
    );  
 }
  
 Widget _showUserPatient() {
   return Container(
      padding: EdgeInsets.all(10),
      child: _userPatients.length == 0 
        ? Text('Loading user of Patients...')
        : DropdownButtonFormField(
            items: _getCombouserPatient(),
            value: _userPatientyId,
            onChanged: (option) {
              setState(() {
              _userPatientyId = option as int;
              });
            },
            decoration: InputDecoration(
              hintText: 'Select a user of Patients...',
              labelText: 'user of Patient',
              errorText:_userPatientShowError ?_userPatientError: null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10)
              ),
            ),
          )
    );  
 }
  
 
 Widget _showDate() {
 return Container(
   padding: EdgeInsets.all(10),
      child: TextField(        
        controller: _datecontroller,
        decoration: const InputDecoration( 
                    icon: Icon(Icons.calendar_today), //icon of text field
                   labelText: "Enter Birth of Date" //label text of field
            ),
           readOnly: true,    
          onTap:() async {  DateTime? pickedDate = await showDatePicker(
                      context: context,
                       initialDate: DateTime.now(), //get today's date
                      firstDate:DateTime(1905), //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(2101)
                  );
                  if(pickedDate != null ){
                   
                     _date = DateFormat('yyyy-MM-dd').format(pickedDate);                   
                                           
                  } else
                  {
                    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
                    _date=dateFormat.format(DateTime.now());
                  }
                  setState(() {
                   _datecontroller.text=_date;
                  });
          }
              
      ),
    ) ;
 
}
  
Widget  _showfirstName() {
   return Container(
       padding: EdgeInsets.all(10),
      child: TextField(
        keyboardType: TextInputType.text,
        controller: _firstNamecontroller,
        decoration: InputDecoration(
          hintText: 'Enter first Name',
          labelText: 'First Name',
          errorText: _firstNameShowErrorr ? _firstNameError : null,
          suffixIcon: Icon(Icons.text_fields_rounded),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)
          ),
        ),
        onChanged: (value) {
          _firstName = value;
        },
      ),  
  );
}
  
Widget  _showLastName() {
   return Container(
       padding: EdgeInsets.all(10),
      child: TextField(
        keyboardType: TextInputType.text,
        controller:_lastNamecontroller,
        decoration: InputDecoration(
          hintText: 'Enter last Name',
          labelText: 'last Name',
          errorText: _lastNameShowErrorr ? _lastNameError : null,
          suffixIcon: Icon(Icons.text_fields),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)
          ),
        ),
        onChanged: (value) {
          _lastName = value;
        },
      ),  
  );
}
  
Widget  _showDescription() {
   return Container(
          padding: EdgeInsets.all(10),
          child: TextField(
            keyboardType: TextInputType.text,
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
  
Widget  _showAdress() {
   return Container(
        padding: EdgeInsets.all(10),
          child: TextField(
            keyboardType: TextInputType.text,
            controller:_addresscontroller,
            decoration: InputDecoration(
              hintText: 'Enter a address',
              labelText: 'Address',
              errorText:_addressShowErrorr ? _addressError : null,
              suffixIcon: Icon(Icons.text_fields),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10)
              ),
            ),
            onChanged: (value) {
              _address = value;
            },
      ),
  );
}
  
Widget  _showEpcNumber() {
   return Container(
     padding: EdgeInsets.all(10),
      child: TextField(
        keyboardType: TextInputType.number,
        controller: _epcNumbercontroller,
        decoration: InputDecoration(
          hintText: 'Enter a EpcNumber...',
          labelText: 'EpcNumber',
          errorText:_epcNumberShowErrorr ? _epcNumberError : null,
          suffixIcon: Icon(Icons.text_fields_rounded),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)
          ),
        ),
        onChanged: (value) {
         _epcNumber= value;
        },
      ),
  );
}
  
Widget  _showmobileNumber() {
   return Container(
      padding: EdgeInsets.all(10),
          child: TextField(
            keyboardType: TextInputType.number,
            controller:_mobileNumbercontroller,
            decoration: InputDecoration(
              hintText: 'Enter a mobile number',
              labelText: 'Mobile nummber',
              errorText:_mobileNumberShowErrorr ? _mobileNumberError : null,
              suffixIcon: Icon(Icons.text_fields),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10)
              ),
            ),
            onChanged: (value) {
              _mobileNumber = value;
            },
      ),    
  );
}
  
Widget  _showButtons() {
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
          widget.patient.id == 0 
            ? Container() 
            : SizedBox(width: 20,),
          widget.patient.id == 0 
            ? Container() 
            : Expanded(
                child: ElevatedButton(
                  child: Text('Delete'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        return Color(0xFFB4161B);
                      }
                    ),
                  ),
                  onPressed: () => _confirmDelete(), 
              ),
          ),
        ],
      ),
  );
}

    Future<Null>  _Takepicture() async{
      WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    var camera = cameras.first;
    var responseCamera = await showAlertDialog(
        context: context,
        title: 'select camera',
        message: 'What camera do you want to use?',
        actions: <AlertDialogAction>[
          AlertDialogAction(key: 'front', label: 'front'),
          AlertDialogAction(key: 'back', label: 'back'),
          AlertDialogAction(key: 'cancel', label: 'cancel'),
        ]);

    if (responseCamera == 'cancel') {
      return;
    }

    if (responseCamera == 'back') {
      camera = cameras.first;
    }

    if (responseCamera == 'front') {
      camera = cameras.last;
    }

    Response? response = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TakePictureScreen(camera: camera)));
    if (response != null) {
      setState(() {
        _photochanged = true;
        _image = response.result;
      });
    }
  }
  
   Future<Null>  _selectPicture()async {
  final ImagePicker _picker= ImagePicker();
              final XFile? image= await _picker.pickImage(source: ImageSource.gallery);
              if(image !=null)
              {
                setState(() {
                  _photochanged=true;
                _image=image;                  
                });                
              }
 }
 
  List<DropdownMenuItem<int>> _getComboCities() {
    List<DropdownMenuItem<int>> list=[];
    list.add(DropdownMenuItem(
      child: Text("select a city"),
      value: 0,
      ));
      _cities.forEach((City) {
        list.add(DropdownMenuItem(
          child: Text(City.description),
          value: City.id,
          ));
      });
      return list;
  }
  
  void _loadData() async{
     await _getCities();
     await _getBloodTypes();
     await _gendres();
     await _getnationality();
     await _getuserPatients();
      _loadFieldValues();
  }
  
 Future<Null> _getCities() async{
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
        message: 'Check your internet connection',
        actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Accept'),
        ]
      );    
      return;
    }
    Response response=await Apihelper.Getcities(widget.token);
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
      _cities=response.result;
    });
 }
 
 List<DropdownMenuItem<int>> _getComboBloodTypes() {
   List<DropdownMenuItem<int>> list=[];
    list.add(DropdownMenuItem(
      child: Text("select a type of blood"),
      value: 0,
      ));
      _bloodTypes.forEach((bloodtypes) {
        list.add(DropdownMenuItem(
          child: Text(bloodtypes.description),
          value: bloodtypes.id,
          ));
      });
      return list;
 }
 
 Future<Null> _getBloodTypes() async{
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
        message: 'Check your internet connection',
        actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Accept'),
        ]
      );    
      return;
    }
    Response response=await Apihelper.Getbloodtypes(widget.token);
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
      _bloodTypes=response.result;
    });
  }
  
 List<DropdownMenuItem<int>> _getComboGendres() {
  List<DropdownMenuItem<int>> list=[];
    list.add(DropdownMenuItem(
      child: Text("select a gendre"),
      value: 0,
      ));
      _gendress.forEach((Gendre) {
        list.add(DropdownMenuItem(
          child: Text(Gendre.description),
          value: Gendre.id,
          ));
      });
      return list;
 }
 
 Future<Null> _gendres() async{
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
        message: 'Check your internet connection',
        actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Accept'),
        ]
      );    
      return;
    }
    Response response=await Apihelper.GetGendre(widget.token);
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
      _gendress=response.result;
    });  
 }
 
List<DropdownMenuItem<int>>  _getComboNationalitis() {
List<DropdownMenuItem<int>> list=[];
    list.add(DropdownMenuItem(
      child: Text("select a nationality"),
      value: 0,
      ));
      _nationalities.forEach((nationality) {
        list.add(DropdownMenuItem(
          child: Text(nationality.description),
          value: nationality.id,
          ));
      });
      return list;
}

 Future<Null> _getnationality() async{
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
        message: 'Check your internet connection',
        actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Accept'),
        ]
      );    
      return;
    }
    Response response=await Apihelper.GetNationalities(widget.token);
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
     _nationalities=response.result;
    });    
  }
  
 List<DropdownMenuItem<int>> _getCombouserPatient() {
  List<DropdownMenuItem<int>> list=[];
    list.add(DropdownMenuItem(
      child: Text("select a user of patient"),
      value: 0,
      ));
      _userPatients.forEach((UserPatient) {
        list.add(DropdownMenuItem(
          child: Text(UserPatient.email),
          value: UserPatient.id,
          ));
      });
      return list;
 }
 
 Future<Null> _getuserPatients() async{
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
        message: 'Check your internet connection',
        actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Accept'),
        ]
      );    
      return;
    }
    Response response=await Apihelper.GetUsersPatient(widget.token);
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
     _userPatients=response.result;
    });    
 }
 
 void _save() {
  if(!validateFields())
  {
    return;
  }
  widget.patient.id==0 ? _addRecord(): _saveRecord();
 }
  
 void _confirmDelete() async{
    var response =  await showAlertDialog(
      context: context,
      title: 'Confirmation', 
      message: 'Are you sure you want to delete the record?',
      actions: <AlertDialogAction>[
          AlertDialogAction(key: 'no', label: 'No'),
          AlertDialogAction(key: 'yes', label: 'yes'),
      ]
    );    

    if (response == 'yes') {
      _deleteRecord();
    }
  }
  
  bool validateFields() {
    bool isValid=true;
    if(_cityId==0)
    {
      isValid=false;
      _cityShowError=true;
      _CityError='You must select a city.';
    }else
    {
      _cityShowError=false;
    }
    if(_bloodtypeId==0)
    {
       isValid=false;
      _bloodtypeShowError=true;
       _bloodtypeError='You must select a blood type.';

    }else
    {
      _bloodtypeShowError=false;
    }
    if(_gendreId==0)
    {
       isValid=false;
     _gendreShowError=true;
    _gendreError='You must select a gender.';

    }else
    {
     _gendreShowError=false;
    }
    if(_nationalityId==0)
    {
       isValid=false;
      _nationalityShowError=true;
      _nationalityError='You must select a nATIONALITY.';

    }else
    {
       _nationalityShowError=false;
    }
     if(_userPatientyId==0)
    {
       isValid=false;
      _userPatientShowError=true;
      _userPatientError='You must select a nationality.';

    }else
    {
     _userPatientShowError=false;
    }
     if(_date.isEmpty)
    {
       isValid=false;
     _dateshowerror=true;
      _dateerror='You must select a date';

    }else
    {
    _dateshowerror=false;
    }
     if(_firstName.isEmpty)
    {
       isValid=false;
     _firstNameShowErrorr=true;
     _firstNameError='You must select a first name';

    }else
    {
    _firstNameShowErrorr=false;
    }
     if(_lastName.isEmpty)
    {
       isValid=false;
     _lastNameShowErrorr=true;
    _lastNameError='You must select a last name';

    }else
    {
    _firstNameShowErrorr=false;
    }
     if(_description.isEmpty)
    {
       isValid=false;
     _descriptionShowErrorr=true;
   _descriptionError='You must select a  description';

    }else
    {
      _descriptionShowErrorr=false;
    }
       if(_address.isEmpty)
    {
       isValid=false;
      _addressShowErrorr=true;
      _addressError='You must select a address';

    }else
    {
     _addressShowErrorr=false;
    }
       if(_epcNumber.isEmpty)
    {
       isValid=false;
      _epcNumberShowErrorr=true;
     _epcNumberError='You must select a Epcnumber';

    }else
    {
     _addressShowErrorr=false;
    }
      if(_mobileNumber.isEmpty)
    {
       isValid=false;
      _mobileNumberShowErrorr=true;
   _mobileNumberError='You must enter Mobile Number';

    }else
    {
     _mobileNumberShowErrorr=false;
    }
    setState(() {
      
    });
    return isValid;
  }
  
 void _addRecord() async{
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
     String base64Image = '';
     if(_photochanged)
     {
      List<int>imageBytes= await _image.readAsBytes();
      base64Image=base64Encode(imageBytes);
      Map<String ,dynamic>request={
        
      };
     }
     Map<String, dynamic> request = {
      'FirstName': _firstName.toUpperCase(),
      'LastName': _lastName,      
      'Address': _address,
      'Date': _date,
      'EPCNNumber': _epcNumber,
      'Description': _description,
      'MobilePhone': _mobileNumber,
      'UserId': widget.user.id,
      'CityId': _cityId,
      'NatianalityId': _nationalityId,
      'gendreId':_gendreId,
      'bloodTypeId':_bloodtypeId,
      'userPatientId':_userPatientyId,
      'Image': base64Image,
    };

    Response response = await Apihelper.Post(
      '/api/Patients/' , request, widget.token
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
            AlertDialogAction(key: null, label: 'Aceptar'),
        ]
      );    
      return;
    }

    Navigator.pop(context, 'yes');
 }
  
 void _saveRecord() async{
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
      'id':widget.patient.id,    
      'FirstName': _firstName.toUpperCase(),
      'LastName': _lastName,      
      'Address': _address,
      'Date': _date,
      'EPCNNumber': _epcNumber,
      'Description': _description,
      'MobilePhone': _mobileNumber,
      'UserId': widget.user.id,
      'CityId': _cityId,
      'NatianalityId': _nationalityId,
      'gendreId':_gendreId,
      'bloodTypeId':_bloodtypeId,
      'userPatientId':_userPatientyId,     
      };

    Response response = await Apihelper.Put(
      '/api/Patients/', 
      widget.patient.id.toString(),
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
 
  void _loadFieldValues() {
    _cityId=widget.patient.city.id;    
    _bloodtypeId=widget.patient.bloodType.id;
    _gendreId=widget.patient.gendre.id;
    _nationalityId=widget.patient.natianality.id;
    _userPatientyId=widget.patient.userPatient.id;
    _date=widget.patient.date;
    _datecontroller.text=_date;
    _firstName=widget.patient.firstName;
    _firstNamecontroller.text=_firstName;
    _lastName=widget.patient.lastName;
    _lastNamecontroller.text=_lastName;
    _description=widget.patient.description;
    _descriptioncontroller.text=_description;
    _epcNumber=widget.patient.epcnNumber.toString();
    _epcNumbercontroller.text=_epcNumber;
    _address=widget.patient.address;
    _addresscontroller.text=_address;
    _mobileNumber=widget.patient.mobilePhone;
    _mobileNumbercontroller.text=_mobileNumber;
  }
  
  void _deleteRecord() async{
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

    Response response = await Apihelper.Delete(
      '/api/Patients/', 
      widget.patient.id.toString(), 
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
  
 Widget _showPhotosCarousel() {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 10),
    child: Column(
      children: [
        CarouselSlider(
              options: CarouselOptions(height: 200, autoPlay: true,autoPlayInterval: Duration(seconds: 3), 
              enlargeCenterPage: true,
              onPageChanged: (index, reason) {
                setState(() {
                  _current=index;
                });
              } ,),
               carouselController: _carouselController,
              items: widget.patient.patientPhotos.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5),                 
                      child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                        child: CachedNetworkImage(
                                      imageUrl: i.imageFullPath,
                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                      fit: BoxFit.cover,
                                      height: 160,
                                      width: 160,
                                      placeholder: (context, url) => Image(
                                        image: AssetImage('assets/noimage.png'),
                                        fit: BoxFit.cover,
                                        height: 160,
                                        width: 160,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
),
        Row(
           mainAxisAlignment: MainAxisAlignment.center,
            children: widget.patient.patientPhotos.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _carouselController.animateToPage(entry.key),
                child: Container(
                  width: 12.0,
                  height: 12.0,
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black)
                          .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                ),
              );
            }).toList(),
        ),
         _showImageButtons()   
      ],           
    )      ,
  );
  }
  
 Widget _showImageButtons() {
  return Container(
    margin: EdgeInsets.only(left: 10 , right: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Expanded(          
          child: ElevatedButton(        
            child: Row
            (
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_a_photo),
              Text('Add Photo'),
            ],
        ),
          style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    return Color(0xFF120E43);
                  }
                ),
              ),
            onPressed: () => _goAddPhoto(),
          ),
                
        ),
           SizedBox(width: 20,),
           Expanded(
            child: ElevatedButton(
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(Icons.delete),
                  Text('Delete Photo'),
                ],
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    return Color(0xFFB4161B);
                  }
                ),
              ),
              onPressed: ()=> _confirmDeletePhoto(), 
              ),
            ),
      ],
    ),
  );
 }
 
 void _goAddPhoto() async{
   var response = await showAlertDialog(
      context: context,
      title: 'Confirmation', 
      message: 'Where do you want to get the image from?',
      actions: <AlertDialogAction>[
          AlertDialogAction(key: 'cancel', label: 'cancel'),
          AlertDialogAction(key: 'camera', label: 'camera'),
          AlertDialogAction(key: 'gellery', label: 'Images'),
      ]
    );   

    if (response == 'cancel') {
      return;
    } 

    if (response == 'camera') {     
      await _Takepicture();
    } else {
      await _selectPicture();
    }
 
    if (_photochanged) {
      _addPicture();
    }
 }
  
 void _confirmDeletePhoto() async{
   var response =  await showAlertDialog(
      context: context,
      title: 'Confirmation', 
      message: 'Are you sure you want to delete the last photo taken?',
      actions: <AlertDialogAction>[
          AlertDialogAction(key: 'no', label: 'No'),
          AlertDialogAction(key: 'yes', label: 'yes'),
      ]
    );    

    if (response == 'yes') {
      _deletePhoto();
    }
 }
  
  void _addPicture() async{
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

    List<int> imageBytes = await _image.readAsBytes();
    String base64Image = base64Encode(imageBytes);

    Map<String, dynamic> request = {
      'PatientId': widget.patient.id,
      'Image': base64Image
    };

    Response response = await Apihelper.Post(
      '/api/PhotosPatient',
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
  
  void _deletePhoto() async{
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
        message: 'Verifica que estes conectado a internet.',
        actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
        ]
      );    
      return;
    }

    Response response = await Apihelper.Delete(
      '/api/PhotosPatient/', 
      widget.patient.patientPhotos[widget.patient.patientPhotos.length - 1].id.toString(), 
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
   
  
}