import 'dart:convert';
import 'package:healthcare/models/City.dart';
import 'package:healthcare/models/Diagnosic.dart';
import 'package:healthcare/models/Nationality.dart';
import 'package:healthcare/models/bloodtypes.dart';
import 'package:healthcare/models/gendre.dart';
import 'package:healthcare/models/response.dart';
import 'package:healthcare/helpers/constans.dart';
import 'package:healthcare/models/user.dart';
import 'package:http/http.dart'as http;
class Apihelper {
  static Future<Response> GetUsers(String token)async
  {
    var url=Uri.parse('${constans.apiUrl}/api/Users');
    var response=await http.get(
    url, 
        headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
        'authorization':'bearer ${token}' ,
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
  static Future<Response> GetNationalities(String token)async
  {
    var url=Uri.parse('${constans.apiUrl}/api/Natianalities');
    var response=await http.get(
    url, 
        headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
        'authorization':'bearer ${token}' ,
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
  
  static Future<Response> GetGendre(String token)async
  {
    var url=Uri.parse('${constans.apiUrl}/api/gendres');
    var response=await http.get(
    url, 
        headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
        'authorization':'bearer ${token}' ,
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
  static Future<Response> Getcities(String token)async
  {
    var url=Uri.parse('${constans.apiUrl}/api/Cities');
    var response=await http.get(
    url, 
        headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
        'authorization':'bearer ${token}' ,
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

static Future<Response> Getbloodtypes(String token)async
  {
    var url=Uri.parse('${constans.apiUrl}/api/BloodTypes');
    var response=await http.get(
    url, 
        headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
        'authorization':'bearer ${token}' ,
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


  static Future<Response> Getdiagnosics(String token)async
  {
    var url=Uri.parse('${constans.apiUrl}/api/diagonisics');
    var response=await http.get(
    url, 
        headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
        'authorization':'bearer ${token}' ,
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

     static Future<Response> Put(String controller , String id ,Map<String, dynamic>request,  String token)async
  {
    var url=Uri.parse('${constans.apiUrl}$controller$id');
    var response=await http.put(
    url, 
        headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
        'authorization':'bearer ${token}' ,
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
   static Future<Response> Post(String controller  ,Map<String, dynamic>request,  String token)async
  {
    var url=Uri.parse('${constans.apiUrl}$controller');
    var response=await http.post(
    url, 
        headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
        'authorization':'bearer ${token}' ,
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
     static Future<Response> Delete(String controller , String id ,  String token)async
  {
    var url=Uri.parse('${constans.apiUrl}$controller$id');
    var response=await http.delete(
    url, 
        headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
        'authorization':'bearer ${token}' ,
          } , 
         
   );    
    var body=response.body;
   if(response.statusCode >= 400)
   {
    return Response(isSuccess: false,message: response.body);
   }
  
     return Response(isSuccess: true);
   }  
}