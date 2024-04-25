import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import 'Home.dart';
import 'holding.dart';

num profit = 0;
num loss = 0;
num price = 0;
num currentPrice = 0;
double balance = 0;
String email = "";
String name = "";
String symbol = "";

class Sell extends StatefulWidget {
  Sell(String e, num p, String n, String s, double b, num c, num pr, num lo) {
    price = p;
    email = e;
    name = n;
    symbol = s;
    balance = b;
    currentPrice = c;
    profit = pr;
    loss = lo;
  }

  @override
  State<Sell> createState() => _SellState();
}

class _SellState extends State<Sell> {
  TextEditingController quantityController = TextEditingController();
  num totalPrice = 0;
  int quantity = 0;

  @override
  void initState() {
    super.initState();
    totalPrice = price;
  }

  @override
  Widget build(BuildContext context) {
    profit = (currentPrice - price) * quantity;
    loss = (price - currentPrice) * quantity;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Center(
            child: Text(
          "Demo Balance: \$$balance",
          style: TextStyle(color: Colors.white, fontSize: 20),
        )),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quantity',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellow),
            ),
            SizedBox(height: 10),
            TextField(
              style: TextStyle(color: Colors.white),
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter quantity',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  if (value.isNotEmpty) {
                    quantity = int.parse(value);
                    totalPrice = currentPrice * quantity;
                    profit = (currentPrice - price) * quantity;
                    loss = (-1) * profit;
                  } else {
                    totalPrice = 0;
                  }
                });
              },
            ),
            SizedBox(height: 10),
            Text(
              'Total Price: \$${totalPrice.toStringAsFixed(2)}',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellow),
            ),
            Expanded(child: Container()),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () async {
                  Uri url = Uri.parse(
                      "https://flutter-stocks-app-backend.vercel.app/api/sell/$email/$name/$symbol/$quantity/$price/$currentPrice");
                  await http.post(url);
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                              backgroundColor: Colors.black,
                              title: Text(
                                'Success',
                                style: TextStyle(color: Colors.green),
                              ),
                              content: currentPrice >= price
                                  ? Text(
                                      'The stock is successfully sold.Profit: $profit',
                                      style: TextStyle(color: Colors.white),
                                    )
                                  : Text(
                                      'The stock is successfully sold.Loss: $loss',
                                      style: TextStyle(color: Colors.white),
                                    ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    'Close',
                                    style: TextStyle(color: Colors.yellow),
                                  ),
                                )
                              ]));
                  await Future.delayed(Duration(seconds: 2));

                  setState(() {
                    balance = balance + totalPrice;
                    MyApp.setTab(1);
                    Home.setBalance(balance);
                    Holding.setBalance(balance);
                    MyApp.setEmail(email, balance);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyApp()));
                  });
                },
                child: Text('Sell'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
