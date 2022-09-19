import 'dart:convert';
import 'package:healthcare/models/Diagnosic.dart';
import 'package:healthcare/models/response.dart';
import 'package:healthcare/helpers/constans.dart';
import 'package:http/http.dart'as http;
class Apihelper {
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
    return Response(isSuccess: false, result:body);
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
    return Response(isSuccess: false, result:body);
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
    return Response(isSuccess: false, result:body);
   }
  
     return Response(isSuccess: true);
   }  
}