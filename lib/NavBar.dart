import 'package:flutter/material.dart';
import 'Configuration.dart';
import 'Products.dart';
import 'TransactionHistory.dart';
import 'Debts.dart';
import 'Sell.dart';

class NavBar extends StatefulWidget {
  @override
  _NavBar createState() => _NavBar();
}

class _NavBar extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 2,
        color: Color.fromARGB(100, 50, 30, 60),
        child: Container(height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed:  () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => SellScreen()));
                  },
                child: Icon(Icons.store, color: navBarIconColor),
                style: navBarButtonStyle,
              ),
              ElevatedButton(
                onPressed:  () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => ProductsScreen()));
                },
                child: Icon(Icons.business_center, color: navBarIconColor),
                style: navBarButtonStyle,
              ),
              const Icon(Icons.store, color: Colors.transparent),
              ElevatedButton(
                onPressed:  () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => TransactionsScreen()));
                },
                child: Icon(Icons.rotate_left, color: navBarIconColor),
                style: navBarButtonStyle,
              ),
              ElevatedButton(
                onPressed:  () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => DebtsScreen()));
                },
                child: Icon(Icons.filter_frames, color: navBarIconColor),
                style: navBarButtonStyle,
              ),
            ])
        )
    );
  }
}

