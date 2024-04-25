import 'package:flutter/material.dart';
import 'components/Home.dart';
import 'components/holding.dart';
import 'components/login.dart';

void main() {
  runApp(MaterialApp(home: Login()));
}

int curr = -1;
double balance = 50000;
String email = "";

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  static setTab(int x) {
    curr = x;
  }

  static setEmail(String x, double y) {
    email = x;
    balance = y;
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var tabs = [Home(), Holding()];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: curr == -1
            ? null
            : AppBar(
                backgroundColor: Colors.black,
                title: Center(
                    child: Text(
                  "Demo Balance: \$$balance",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )),
              ),
        body: curr == -1 ? Login() : tabs[curr],
        bottomNavigationBar: curr == -1
            ? SizedBox(
                height: 5,
              )
            : BottomNavigationBar(
                onTap: (c) => {
                  setState(() {
                    curr = c;
                  })
                },
                backgroundColor: Colors.black,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.white,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home,
                      color: Colors.white,
                    ),
                    label: "Home",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.moving,
                      color: Colors.white,
                    ),
                    label: "Holdings",
                  )
                ],
              ),
      ),
    );
  }
}
