import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'buy.dart';


String email = "";
double balance = 0;

class Home extends StatefulWidget {
  Home() {}
  static setEmail(String x) {
    email = x;
  }

  static setBalance(double b) {
    balance = b;
  }

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Widget createStock(String name, num price, String symbol) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 53, 51, 53),
          border: Border.all(color: Colors.greenAccent),
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.fromLTRB(5, 0, 10, 5),
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Text("Price: \$$price",
                      style: TextStyle(color: Colors.yellow, fontSize: 12))
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Buy(email, price, name, symbol, balance)));
                  },
                  child: Text(
                    "Buy",
                    style: TextStyle(color: Colors.black),
                  )),
            )
          ],
        ),
      ),
    );
  }

  Future<List<Widget>> createList() async {
    var response = await http.get(
        Uri.parse('https://flutter-stocks-app-backend.vercel.app/api/stocks'));
    List<dynamic> stockList = json.decode(response.body);
    print(stockList);
    List<Widget> stocks = [];
    for (var stock in stockList) {
      print('Creating stock widget for: ${stock["name"]}');

      stocks.add(createStock(stock["name"], stock["price"], stock["symbol"]));
    }
    print("Created stocks");
    return stocks;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: createList(),
        builder: (context, AsyncSnapshot<List<Widget>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return ListView(
            children: snapshot.data!,
          );
        });
  }
}
