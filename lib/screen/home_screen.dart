import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/helpers/api_helper.dart';
import 'package:healthcare/models/UserPatient.dart';
import 'package:healthcare/models/response.dart';
import 'package:healthcare/models/token.dart';
import 'package:healthcare/models/user.dart';
import 'package:healthcare/screen/Cities_Screen.dart';
import 'package:healthcare/screen/Gendre_Screen.dart';
import 'package:healthcare/screen/Gendres_Screen.dart';
import 'package:healthcare/screen/Nationalities_Screen.dart';
import 'package:healthcare/screen/UserPatients.dart';
import 'package:healthcare/screen/Users_Screen.dart';
import 'package:healthcare/screen/bloodtype_Screen.dart';
import 'package:healthcare/screen/diagnosic_screen.dart';
import 'package:healthcare/screen/login_screen.dart';
import 'package:healthcare/screen/mumdeical_history_screen.dart';
import 'package:healthcare/screen/myAgenda_Screen.dart';
import 'package:healthcare/screen/user_info_screen.dart';
import 'package:healthcare/screen/user_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import '../helpers/regex_helper.dart';
class HomeScreen extends StatefulWidget {
 final Token token;
 
 HomeScreen({ required this.token });

  @override
  _homescreenState  createState() =>  _homescreenState();
}

class  _homescreenState extends State<HomeScreen> {
   
   
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   
  }
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
      title: Text('patients' , ),
     ),
     body: _getBody(),
     drawer:widget.token.user.userType==0? _getAdminMenue() : widget.token.user.userType ==1 
    ? _getuserMenue()
    : _getpatientMenue(),
    );
  }
  
Widget _getBody() {
  return SingleChildScrollView(
    child: Container(
      margin: EdgeInsets.all(30),
      child:Column(
      mainAxisAlignment: MainAxisAlignment.center,
       children:[
        ClipRRect(
          borderRadius: BorderRadius.circular(150),
          child:  
          CachedNetworkImage(
            imageUrl: widget.token.user.imageFullPath,
            errorWidget: (context, url, error) => Icon(Icons.error),
                            fit: BoxFit.cover,
                            height: 300,
                            width: 300,
                            placeholder: (context, url) => Image(
                            image: AssetImage('assets/noimage.png'),
                            fit: BoxFit.cover,
                            height: 300,
                            width: 300,
                            ),
          ),

          // FadeInImage(
          //                     placeholder: AssetImage('assets/logo.jpg'),
          //                     image: NetworkImage(widget.token.user.imageFullPath),
          //                     height: 300,
          //                     width: 300,
          //                     fit: BoxFit.cover,                           
          // ),
        ),     
          SizedBox(height: 30,),
        Center(
          child: Text(
            'welcome! ${widget.token.user.fullName}',
            style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold),
            
            ),
        ),
        SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
             widget.token.user.userType==0? Text('call the Admin'):widget.token.user.userType==1?Text('call the doctor')
             :Text('call the Patient'),
              SizedBox(width: 10,),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 40,
                  width: 40,
                  color: Colors.blue,
                  child: IconButton(
                    icon: Icon(Icons.call, color: Colors.white,),
                    // ignore: deprecated_member_use
                    onPressed: () => launch('tel://+${widget.token.user.phoneNumber}''${RegexHelper.removeBlankSpaces(widget.token.user.phoneNumber)}'), 
                  ),
                ),
              )
            ],
          ),       
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
               widget.token.user.userType==0? Text('Send message to the Admin'):widget.token.user.userType==1?Text('Send message to the doctor')
             :Text('Send message to the Patient'),
              SizedBox(width: 10,),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 40,
                  width: 40,
                  color: Colors.green,
                  child: IconButton(
                    icon: Icon(Icons.insert_comment, color: Colors.white,),
                    onPressed: () => _sendMessage(), 
                  ),
                ),
              )
            ],
          ),       
       ],
      ) 
    ),
  );
}

 Widget _getAdminMenue() {
  return Drawer(
    child: ListView(
     padding: EdgeInsets.zero,
     children: <Widget>[
      DrawerHeader(
        child: Image(
          image: AssetImage('assets/logo.jpg'), width: 400,
          )
        ),
     ListTile(
        leading: Icon(Icons.bloodtype),
        title: const Text('Types of Blood'),
        onTap: () { 
            Navigator.push(
                  context, 
                  MaterialPageRoute(
                  builder: (context) => BloodTypeScreen(token: widget.token,)
      )   
            );               
        },
        ),
        ListTile(
        leading: Icon(Icons.alarm_add_outlined),
        title: const Text('Diagnosics'),
        onTap: () {    
          Navigator.push(
                  context, 
                  MaterialPageRoute(
                  builder: (context) => DiagnosicScreen(token: widget.token,)
      )
    );      
        },
        ),
        ListTile(
        leading: Icon(Icons.language),
        title: const Text('Nationalities'),
        onTap: () {   
            Navigator.push(
                  context, 
                  MaterialPageRoute(
                  builder: (context) => NationalitiesScreen(token: widget.token,)
                          )
                        );             
        },
        ),
         ListTile(
        leading: Icon(Icons.location_city),
        title: const Text('Cities'),
        onTap: () {  
           Navigator.push(
                  context, 
                  MaterialPageRoute(
                  builder: (context) =>Citiesscreen(token: widget.token,)
      )
    );              
        },
        ),
        ListTile(
        leading: Icon(Icons.seven_k),
        title: const Text('Gendres'),
        onTap: () {    
           Navigator.push(
                  context, 
                  MaterialPageRoute(
                  builder: (context) =>GendresScreen(token: widget.token,)
      )
    );                    
        },
        ),
        
          
         Divider(
            color: Colors.black, 
            height: 2,
          ),
           ListTile(
        leading: Icon(Icons.seven_k),
        title: const Text('Healthcare on web'),
        onTap: () =>launch("https://healthcareapi20220724094946.azurewebsites.net/"),
        
        ),        
          
         Divider(
            color: Colors.black, 
            height: 2,
          ),
           ListTile(
        leading: Icon(Icons.verified_user_outlined),
        title: const Text('Users'),
        onTap: () {
                    Navigator.push(
                  context, 
                  MaterialPageRoute(
                  builder: (context) =>UsersSCeen(token: widget.token,)
                  )
                    );
        },
        ),
           ListTile(
        leading: Icon(Icons.supervised_user_circle_sharp),
        title: const Text('Users of Patients'),
        onTap: () {
                    Navigator.push(
                  context, 
                  MaterialPageRoute(
                  builder: (context) =>UserPatients(token: widget.token,)
                  )
                    );
        },
        ),
         ListTile(
        leading: Icon(Icons.supervised_user_circle_sharp),
        title: const Text('Edit Profile'),
        onTap: () {
                    Navigator.push(
                  context, 
                  MaterialPageRoute(
                  builder: (context) =>UserScreen(token: widget.token,                  
                    user: widget.token.user,
                     myProfile: true,
                    )
                  )
                 );
        },
        ),
         ListTile(
        leading: Icon(Icons.login_outlined),
        title: const Text('Log out'),
        onTap: () =>_logOut(),
        ),
     ],
    ),
  );
 }
 
 Widget _getuserMenue() {
   return Drawer(
    child: ListView(
     padding: EdgeInsets.zero,
     children: <Widget>[
      DrawerHeader(
        child: Image(
          image: AssetImage('assets/logo.jpg'), width: 400,
          )
        ),
     ListTile(
        leading: Icon(Icons.sick),
        title: const Text('my Patients'),
        onTap: () { 
           Navigator.push(
                  context, 
                  MaterialPageRoute(
                  builder: (context) =>UserInfoScreen(token: widget.token,                  
                    user: widget.token.user,
                    isAdmin: false,
                    )
                  )
                 );         
        },
        ),
       
          
         Divider(
            color: Colors.black, 
            height: 2,
          ),
            ListTile(
        leading: Icon(Icons.supervised_user_circle_sharp),
        title: const Text('Edit Profile'),
        onTap: () {
                    Navigator.push(
                  context, 
                  MaterialPageRoute(
                  builder: (context) =>UserScreen(token: widget.token,                  
                    user: widget.token.user,
                     myProfile: true,
                    )
                  )
                 );
        },
        ),
         ListTile(
        leading: Icon(Icons.login_outlined),
        title: const Text('Log out'),
        onTap: ()=>_logOut()
          
        ),
     ],
    ),
  );  
 }
  
 void _logOut() async{
   SharedPreferences pref=await SharedPreferences.getInstance();
    await pref.setBool('isRemembered', false);
    await pref.setString('userBody','');
        Navigator.pushReplacement(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => loginScreen(),
              )
            );     
        
 }
 
  void _sendMessage() async{
     final link = WhatsAppUnilink(
      phoneNumber: '${widget.token.user.countryCode}${widget.token.user.phoneNumber}',
      text: 'Hello ${widget.token.user.fullName} client caller',
    );
    // ignore: deprecated_member_use
    await launch('$link');
  }
  
Widget  _getpatientMenue() {
   return Drawer(
    child: ListView(
     padding: EdgeInsets.zero,
     children: <Widget>[
      DrawerHeader(
        child: Image(
          image: AssetImage('assets/logo.jpg'), width: 400,
          )
        ),
     ListTile(
        leading: Icon(Icons.sick),
        title: const Text('My Medical History'),
        onTap: () { 
           Navigator.push(
                  context, 
                  MaterialPageRoute(
                  builder: (context) =>MyMedicalScreen(token: widget.token,                  
                    user: widget.token.user,                   
                    )
                  )
                 );         
        },
        ),
       
        ListTile(
        leading: Icon(Icons.sick),
        title: const Text('My Agenda'),
        onTap: () { 
           Navigator.push(
                  context, 
                  MaterialPageRoute(
                  builder: (context) =>MyAgendaScreen(token: widget.token,                  
                    user: widget.token.user,                   
                    )
                  )
                 );         
        },
        ),
       
         Divider(
            color: Colors.black, 
            height: 2,
          ),
            ListTile(
        leading: Icon(Icons.supervised_user_circle_sharp),
        title: const Text('Edit Profile'),
        onTap: () {
                    Navigator.push(
                  context, 
                  MaterialPageRoute(
                  builder: (context) =>UserScreen(token: widget.token,                  
                    user: widget.token.user,
                     myProfile: true,
                    )
                  )
                 );
        },
        ),
         ListTile(
        leading: Icon(Icons.login_outlined),
        title: const Text('Log out'),
        onTap: ()=>_logOut()
          
        ),
     ],
    ),
  );  
}
}