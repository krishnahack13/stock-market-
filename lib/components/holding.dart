import 'package:demo/components/sell.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


String email = "";
double balance = 0;

class Holding extends StatefulWidget {
  Holding() {}
  static setEmail(String x) {
    email = x;
  }

  static setBalance(double b) {
    balance = b;
  }

  @override
  State<Holding> createState() => _HoldingState();
}

class _HoldingState extends State<Holding> {
  Widget createStock(
      String name, num price, int quantity, num currentPrice, String symbol) {
    //print(name);
    //print(price);
    //print(currentPrice);
    num profit = 0;
    num loss = 0;
    if (currentPrice >= price) {
      profit = (currentPrice - price) * quantity;
    } else {
      loss = (price - currentPrice) * quantity;
    }
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
                      style: TextStyle(color: Colors.yellow, fontSize: 12)),
                  Text("Quantity: $quantity",
                      style: TextStyle(color: Colors.yellow, fontSize: 12)),
                  price > currentPrice
                      ? Text("-$loss",
                          style: TextStyle(color: Colors.red, fontSize: 12))
                      : Text("+$profit",
                          style: TextStyle(color: Colors.green, fontSize: 12))
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
                            builder: (context) => Sell(email, price, name,
                                symbol, balance, currentPrice, profit, loss)));
                  },
                  child: Text(
                    "Sell",
                    style: TextStyle(color: Colors.black),
                  )),
            )
          ],
        ),
      ),
    );
  }

  Future<List<Widget>> createList() async {
    num currentPrice = 0;
    var curr = await http.get(
        Uri.parse('https://flutter-stocks-app-backend.vercel.app/api/stocks'));
    List<dynamic> currentValue = json.decode(curr.body);
    print(currentValue);
    print("done");
    var response = await http.get(Uri.parse(
        'http://flutter-stocks-app-backend.vercel.app/api/user/$email'));
    List<dynamic> stockList = json.decode(response.body);
    print(stockList);
    List<Widget> stocks = [];
    for (var stock in stockList[0]["bought"]) {
      var matchingCurrentValue = currentValue.firstWhere(
          (e) => e["symbol"] == stock["symbol"],
          orElse: () => null);
      num currentPrice =
          matchingCurrentValue != null ? matchingCurrentValue["price"] : 0.0;
      stocks.add(createStock(stock["name"], stock["price"], stock["quantity"],
          currentPrice, stock["symbol"]));
    }
    return stocks;
  }

  @override
  Widget build(BuildContext context) {
    print(email);
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
