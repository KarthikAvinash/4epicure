import 'dart:convert';

import '../auth_screens/signIn.dart';
import '../screens/tabs_screen.dart';
import 'package:flutter/material.dart';
import '../auth_screens/signUp.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../globals.dart' as wglobals;
import '../utilities/error_handling.dart';
import '../utilities/globals.dart' as globals; 


class authServices {
    
    //Sign Up
  void signUpUser({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
  }) async {
    try { 
      globals.userName = name;
      http.Response res = await http.post(
          Uri.parse('${globals.uri}/api/users/'),
          body:json.encode({
             "username":name,
             "email":email,
             "password":password,
          }),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            // 'origin': '*',
            // 'Access-Control-Allow-Origin': '*',
          }
          );
          // });
          print(res.statusCode);
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(
                context, 'Account created login with the same credentials');
Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ShakeToNavigate()));
          });
          return;
    } catch (e) {
      print(e.toString());
      showSnackBar(context, e.toString());
    }
  }
 
//  //Logging in
//  void signInUser({
//     required BuildContext context,
//     required String name,
//     required String password,
//   }) async {
//     try {
//       globals.userName = name;
//       http.Response res = await http.post(
//         Uri.parse('${globals.uri}/api/users/login/'),
//         body: jsonEncode({
//           'username': name,
//           'password': password,
//         }),
//          headers: <String, String>{
//            'Content-Type': 'application/json; charset=UTF-8',
//          },
//       );
//       print(res.statusCode);
//       httpErrorHandle(
//         response: res,
//         context: context,
//         onSuccess: () async {
//           SharedPreferences prefs = await SharedPreferences.getInstance();
//           // Provider.of<UserProvider>(context, listen: false).setUser(res.body);
//           // globals.userName = res.body[name];
//           await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);
// Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ShakeToNavigate()));
//         },
//       );
//     } catch (e) {
//       showSnackBar(context, e.toString());
//     }
//   }
// }


void signInUser({
    required BuildContext context,
    required String name,
    required String password,
  }) {
    try {
      // print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@$name');
      if(name == 'Devarshi')
      {
        if(password == '1234')
        {
          wglobals.setUserId(1);
        globals.userName = "Devarshi" ; 
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ShakeToNavigate()));
        }
        else{
          showSnackBar(context, "Please login with correct credentials");
        }
      }
      else if(name == 'Devesh')
      {
        if(password == '1234')
        {
        wglobals.setUserId(2); 
        globals.userName = "Devesh" ; 
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ShakeToNavigate()));
        print("inside");
        }
        else{
          showSnackBar(context, "Please login with correct credentials");
        }
      }
      else if(name == "Karthik")
      {
        if(password == '1234')
        {
        wglobals.setUserId(3); 
        globals.userName = "Karthik" ; 
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ShakeToNavigate()));
        }
        else{
          showSnackBar(context, "Please login with correct credentials");
        }
      }
      else if(name == "Sameed")
      {
        if(password == '1234')
        {
        wglobals.setUserId(4);
        globals.userName = "Sameed" ; 
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ShakeToNavigate()));
        }
        else{
          showSnackBar(context, "Please login with correct credentials");
        }
      }
      final a = wglobals.user_id;
      print('###################$a');
      final b = globals.userName;
      print('%%%%%%%%%%%%%%%%%%%%$b');
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
