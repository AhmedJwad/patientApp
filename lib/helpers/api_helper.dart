import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:healthcare/models/Agenda.dart';
import 'package:healthcare/models/City.dart';
import 'package:healthcare/models/Diagnosic.dart';
import 'package:healthcare/models/Nationality.dart';
import 'package:healthcare/models/bloodtypes.dart';
import 'package:healthcare/models/gendre.dart';
import 'package:healthcare/models/history.dart';
import 'package:healthcare/models/patient.dart';
import 'package:healthcare/models/response.dart';
import 'package:healthcare/helpers/constans.dart';
import 'package:healthcare/models/token.dart';
import 'package:healthcare/models/user.dart';
import 'package:healthcare/models/UserPatient.dart';
import 'package:http/http.dart'as http;

class Apihelper {

static Future<Response> getHistory(Token token, String id) async {
      if (!_validToken(token)) {
        return Response(isSuccess: false, message: 'Your credentials have expired, please log out and log back in.');
      }

      var url = Uri.parse('${constans.apiUrl}/api/Histories/$id');
      var response = await http.get(
        url,
        headers: {
          'content-type' : 'application/json',
          'accept' : 'application/json',
          'authorization': 'bearer ${token.token}',
        },
      );

      var body = response.body;
      if (response.statusCode >= 400) {
        return Response(isSuccess: false, message: body);
      }

      var decodedJson = jsonDecode(body);
      return Response(isSuccess: true, result: Histories.fromJson(decodedJson));
  }


static Future<Response> getPatient(Token token, String id) async {
      if (!_validToken(token)) {
        return Response(isSuccess: false, message: 'Your credentials have expired, please log out and log back in.');
      }

      var url = Uri.parse('${constans.apiUrl}/api/Patients/$id');
      var response = await http.get(
        url,
        headers: {
          'content-type' : 'application/json',
          'accept' : 'application/json',
          'authorization': 'bearer ${token.token}',
        },
      );

      var body = response.body;
      if (response.statusCode >= 400) {
        return Response(isSuccess: false, message: body);
      }

      var decodedJson = jsonDecode(body);
      return Response(isSuccess: true, result: Patients.fromJson(decodedJson));
  }
static Future<Response> GetAgenda(Token token, String id)async  {
          if (!_validToken(token)) {
            return Response(isSuccess: false, message: 'Your credentials have expired, please log out and log back in.');
          }
          var url=Uri.parse('${constans.apiUrl}/api/Agenda/$id');
          var response=await http.get(
          url, 
              headers: {
              'content-type' : 'application/json',
              'accept' : 'application/json',
              'authorization':'bearer ${token.token}' ,
                } , 
        );    
          var body=response.body;
        if(response.statusCode >= 400)
        {
          return Response(isSuccess: false, result:body);
        }
        List<Agenda> list=[] ;  
        var decodedjson=jsonDecode(body);
        if(decodedjson != null)
        {
          for (var item in decodedjson) {
            list.add(Agenda.fromJson(item));
          }
        }
          return Response(isSuccess: true, result: list);
    }  

     

static Future<Response> GetUsers(Token token)async  {
          if (!_validToken(token)) {
            return Response(isSuccess: false, message: 'Your credentials have expired, please log out and log back in.');
          }
          var url=Uri.parse('${constans.apiUrl}/api/Users');
          var response=await http.get(
          url, 
              headers: {
              'content-type' : 'application/json',
              'accept' : 'application/json',
              'authorization':'bearer ${token.token}' ,
                } , 
        );    
          var body=response.body;
        if(response.statusCode >= 400)
        {
          return Response(isSuccess: false, result:body);
        }
        List<User> list=[] ;  
        var decodedjson=jsonDecode(body);
        if(decodedjson != null)
        {
          for (var item in decodedjson) {
            list.add(User.fromJson(item));
          }
        }
          return Response(isSuccess: true, result: list);
    }  

     
static Future<Response> getUser(Token token, String id) async {
    if (!_validToken(token)) {
      return Response(isSuccess: false, message: 'Sus credenciales se han vencido, por favor cierre sesión y vuelva a ingresar al sistema.');
    }
    
    var url = Uri.parse('${constans.apiUrl}/api/Users/$id');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
        'authorization': 'bearer ${token.token}',
      },
    );

    var body = response.body;
    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    var decodedJson = jsonDecode(body);
    return Response(isSuccess: true, result: User.fromJson(decodedJson));
  }

static Future<Response> getUserpatient(Token token, String id) async {
    if (!_validToken(token)) {
      return Response(isSuccess: false, message: 'Sus credenciales se han vencido, por favor cierre sesión y vuelva a ingresar al sistema.');
    }
    
    var url = Uri.parse('${constans.apiUrl}/api/UserPatients/$id');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
        'authorization': 'bearer ${token.token}',
      },
    );

    var body = response.body;
    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    var decodedJson = jsonDecode(body);
    return Response(isSuccess: true, result: User.fromJson(decodedJson));
  }

static Future<Response> GetNationalities(Token token)async
  {
     if (!_validToken(token)) {
      return Response(isSuccess: false, message: 'Your credentials have expired, please log out and log back in.');
    }
    var url=Uri.parse('${constans.apiUrl}/api/Natianalities');
    var response=await http.get(
    url, 
        headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
        'authorization':'bearer ${token.token}' ,
          } , 
   );    
    var body=response.body;
   if(response.statusCode >= 400)
   {
    return Response(isSuccess: false, result:body);
   }
  List<Natinality> list=[] ;  
   var decodedjson=jsonDecode(body);
   if(decodedjson != null)
   {
     for (var item in decodedjson) {
       list.add(Natinality.fromJson(item));
     }
   }
     return Response(isSuccess: true, result: list);
     }  
  
static Future<Response> GetGendre(Token token)async
  {
     if (!_validToken(token)) {
      return Response(isSuccess: false, message: 'Your credentials have expired, please log out and log back in.');
    }
    var url=Uri.parse('${constans.apiUrl}/api/gendres');
    var response=await http.get(
    url, 
        headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
        'authorization':'bearer ${token.token}' ,
          } , 
   );    
    var body=response.body;
   if(response.statusCode >= 400)
   {
    return Response(isSuccess: false, result:body);
   }
  List<Gendre> list=[] ;  
   var decodedjson=jsonDecode(body);
   if(decodedjson != null)
   {
     for (var item in decodedjson) {
       list.add(Gendre.fromJson(item));
     }
   }
     return Response(isSuccess: true, result: list);
     }  
static Future<Response> Getcities(Token token)async
  {
     if (!_validToken(token)) {
      return Response(isSuccess: false, message: 'Your credentials have expired, please log out and log back in.');
    }
    var url=Uri.parse('${constans.apiUrl}/api/Cities');
    var response=await http.get(
    url, 
        headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
        'authorization':'bearer ${token.token}' ,
          } , 
   );    
    var body=response.body;
   if(response.statusCode >= 400)
   {
    return Response(isSuccess: false, result:body);
   }
  List<City> list=[] ;  
   var decodedjson=jsonDecode(body);
   if(decodedjson != null)
   {
     for (var item in decodedjson) {
       list.add(City.fromJson(item));
     }
   }
     return Response(isSuccess: true, result: list);
     }  

static Future<Response> Getbloodtypes(Token token)async
  {
     if (!_validToken(token)) {
      return Response(isSuccess: false, message: 'Your credentials have expired, please log out and log back in.');
    }
    var url=Uri.parse('${constans.apiUrl}/api/BloodTypes');
    var response=await http.get(
    url, 
        headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
        'authorization':'bearer ${token.token}' ,
          } , 
   );    
    var body=response.body;
   if(response.statusCode >= 400)
   {
    return Response(isSuccess: false, result:body);
   }
  List<bloodtypes> list=[] ;  
   var decodedjson=jsonDecode(body);
   if(decodedjson != null)
   {
     for (var item in decodedjson) {
       list.add(bloodtypes.fromJson(item));
     }
   }
     return Response(isSuccess: true, result: list);
     }  


static Future<Response> Getdiagnosics(Token token)async
  {
     if (!_validToken(token)) {
      return Response(isSuccess: false, message: 'Your credentials have expired, please log out and log back in.');
    }
    var url=Uri.parse('${constans.apiUrl}/api/diagonisics');
    var response=await http.get(
    url, 
        headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
        'authorization':'bearer ${token.token}' ,
          } , 
   );    
    var body=response.body;
   if(response.statusCode >= 400)
   {
    return Response(isSuccess: false, result:body);
   }
  List<diagnosic> list=[] ;  
   var decodedjson=jsonDecode(body);
   if(decodedjson != null)
   {
     for (var item in decodedjson) {
       list.add(diagnosic.fromJson(item));
     }
   }
     return Response(isSuccess: true, result: list);
     }  

static Future<Response> Put(String controller , String id ,Map<String, dynamic>request,  Token token)async
  {
     if (!_validToken(token)) {
      return Response(isSuccess: false, message: 'Your credentials have expired, please log out and log back in.');
    }
    var url=Uri.parse('${constans.apiUrl}$controller$id');
    var response=await http.put(
    url, 
        headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
        'authorization':'bearer ${token.token}' ,
          } , 
          body: jsonEncode(request),
   );    
    var body=response.body;
   if(response.statusCode >= 400)
   {
    return Response(isSuccess: false, message: response.body);
   }
  
     return Response(isSuccess: true);
   }  

static Future<Response> Post(String controller  ,Map<String, dynamic>request,  Token token)async
  {
     if (!_validToken(token)) {
      return Response(isSuccess: false, message: 'Your credentials have expired, please log out and log back in.');
    }
    var url=Uri.parse('${constans.apiUrl}$controller');
    var response=await http.post(
    url, 
        headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
        'authorization':'bearer ${token.token}' ,
          } , 
          body: jsonEncode(request),
   );    
    var body=response.body;
   if(response.statusCode >= 400)
   {
    return Response(isSuccess: false, message: response.body);
   }
  
     return Response(isSuccess: true);
   }  

static Future<Response> PostnoToken(String controller  ,Map<String, dynamic>request)async
  {
    
    var url=Uri.parse('${constans.apiUrl}$controller');
    var response=await http.post(
    url, 
        headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',      
          } , 
          body: jsonEncode(request),
   );    
    var body=response.body;
   if(response.statusCode >= 400)
   {
    return Response(isSuccess: false, message: response.body);
   }
  
     return Response(isSuccess: true);
   }  


static Future<Response> Delete(String controller , String id ,  Token token)async
  {
     if (!_validToken(token)) {
      return Response(isSuccess: false, message: 'Your credentials have expired, please log out and log back in.');
    }
    var url=Uri.parse('${constans.apiUrl}$controller$id');
    var response=await http.delete(
    url, 
        headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
        'authorization':'bearer ${token.token}' ,
          } , 
         
   );    
    var body=response.body;
   if(response.statusCode >= 400)
   {
    return Response(isSuccess: false,message: response.body);
   }
  
     return Response(isSuccess: true);
   }
   
static bool _validToken(Token token) {
      if(DateTime.parse(token.expiration).isAfter(DateTime.now()))
      {
        return true;
      }
      return false;
     }  
   
static Future<Response> GetUsersPatient(Token token)async
  {
     if (!_validToken(token)) {
      return Response(isSuccess: false, message: 'Your credentials have expired, please log out and log back in.');
    }
    var url=Uri.parse('${constans.apiUrl}/api/UserPatients');
    var response=await http.get(
    url, 
        headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
        'authorization':'bearer ${token.token}' ,
          } , 
   );    
    var body=response.body;
   if(response.statusCode >= 400)
   {
    return Response(isSuccess: false, result:body);
   }
  List<UserPatient> list=[] ;  
   var decodedjson=jsonDecode(body);
   if(decodedjson != null)
   {
     for (var item in decodedjson) {
       list.add(UserPatient.fromJson(item));
     }
   }
     return Response(isSuccess: true, result: list);
     }  
}