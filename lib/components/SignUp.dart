import 'dart:convert';

import 'package:flutter/material.dart';
import 'login.dart';
import 'package:http/http.dart' as http;

String email = "";
String name = "";
String pass = "";
double balance = 50000;

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
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
                  'Sign Up',
                  style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  onChanged: (value) {
                    name = value;
                  },
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Name',
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
                TextFormField(
                  onChanged: (value) {
                    email = value;
                  },
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(Icons.email, color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  onChanged: (value) {
                    pass = value;
                  },
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
                      var data = [
                        {
                          "name": name,
                          "email": email,
                          "password": pass,
                          "balance": balance
                        }
                      ];
                      var bdy = json.encode(data);
                      var response = await http.post(
                        Uri.parse(
                            "https://flutter-stocks-app-backend.vercel.app/api/signup"),
                        headers: {"Content-Type": "application/json"},
                        body: bdy,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Login()),
                      );
                    },
                    child: Text(
                      'Sign Up',
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
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                  child: Text(
                    'Already a member? Login now',
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
