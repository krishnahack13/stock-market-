import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../main.dart';
import 'Home.dart';
import 'SignUp.dart';
import 'holding.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

double balance = 0;

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    String email = "";
    String pass = "";
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(15.0),
              border: Border.all(
                color: Colors.yellow,
                width: 2.0,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.0),
                TextField(
                  onChanged: (value) => {email = value},
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.person, color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 10.0),
                TextField(
                  onChanged: (value) => {pass = value},
                  style: TextStyle(color: Colors.white),
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.lock, color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 20.0),
                SizedBox(
                  width: double.infinity,
                  height: 50.0,
                  child: ElevatedButton(
                    onPressed: () async {
                      print(email);
                      print(pass);
                      Uri url = Uri.parse(
                          'https://flutter-stocks-app-backend.vercel.app/api/user/$email');
                      print("Hello");
                      var response = await http.get(url);
                      var jsonResponse = json.decode(response.body);
                      print(jsonResponse);
                      print(jsonResponse[0]["password"]);
                      if (jsonResponse[0]["balance"].runtimeType == int) {
                        int x = jsonResponse[0]["balance"];
                        balance = x.toDouble();
                      } else {
                        balance = jsonResponse[0]["balance"];
                      }
                      print(balance);
                      print(balance.runtimeType);
                      if (jsonResponse[0]["password"] == pass) {
                        Home.setEmail(email);
                        Home.setBalance(balance);
                        Holding.setEmail(email);
                        Holding.setBalance(balance);
                        MyApp.setEmail(email, balance);
                        MyApp.setTab(0);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => MyApp()));
                      }
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(fontSize: 18.0, color: Colors.black),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.yellow),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUp()),
                    );
                  },
                  child: Text(
                    'Not a user? Register now',
                    style: TextStyle(color: Colors.yellow),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
