import 'package:flutter/material.dart';
import 'Configuration.dart';
import 'NavBar.dart';
import 'main.dart';
import 'models/Product.dart';
import 'models/Category.dart';
import 'models/Transaction.dart';

class SellScreen extends StatefulWidget {
  @override
  State<SellScreen> createState() => _SellScreenState();
}

class SellItem {
  final int? id;
  final String name;
  int amount;
  final double price;
  bool hasStock;

  SellItem({
    this.id,
    required this.name,
    required this.amount,
    required this.price,
    required this.hasStock,
  });

  factory SellItem.fromMap(Map<String, dynamic> json) => new SellItem(
    id: json['id'],
    name: json['name'],
    amount: json['amount'],
    price: json['price'].toDouble(),
    hasStock: json['hasStock'],
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'stock': amount,
      'price': price,
      'hasStock': hasStock,
    };
  }
} //Class of item that will be sold

class _SellScreenState extends State<SellScreen> {
  List<SellItem> itemsToSell = [];
  double totalPrice = 0;

  transactDialog(BuildContext context) {
    return showDialog(context: context,builder: (context){
      return AlertDialog(
          title: Text('Transaction Complete!'),
          actions: <Widget>[
            MaterialButton(
                elevation: 2.0,
                child: Text('Close'),
                onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop('dialog');
                }
            ),
          ]
      );
    });
  } //Dialog after transaction

  Widget build (BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          extendBodyBehindAppBar: true,
          extendBody: true,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
              toolbarHeight: 40,
              centerTitle: true,
              title: Text('Sell'),
              backgroundColor: appBarBGColor,
          ),
          body: Container (
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 70),
            decoration: appBoxDecoration,
            child: Row(
              children: [
                Expanded(
                  flex: 12,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.all(Radius.circular(24)),
                          ),
                        ),
                        Text(
                          'Products',
                          style: TextStyle(
                            color: columnTitleColor,
                            fontWeight: FontWeight.w800,
                            fontSize: 24,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                color: listBackgroundOverlay
                            ),
                            child: FutureBuilder<List<Product>>(
                                future: ProductDatabase.instance.getProducts(),
                                builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
                                  if (!snapshot.hasData) {
                                    return Center(child: CircularProgressIndicator());
                                  }
                                  return snapshot.data!.isEmpty ?
                                  Center(child: Text('No products to show', style: smallListTextStyle))
                                      :
                                  ListView(
                                    padding: EdgeInsets.zero,
                                    children: snapshot.data!.map((product) {
                                      if (product.stock == 0) {
                                        return Card(
                                          color: Colors.transparent,
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                                            height: 80,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                                gradient: LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                    colors: [productEmptyListColor1, productEmptyListColor2]
                                                )
                                            ),
                                            child: ListTile(
                                              title: Text(product.name, style: miniListTextStyle,),
                                              subtitle: Text(product.price.toString() + ' PHP', style: smallListTextStyle),
                                              trailing: Column(
                                                  children: [
                                                    FutureBuilder<Category?>(
                                                        future: CategoryDatabase.instance.fetchCategory(product.category),
                                                        builder: (BuildContext context, AsyncSnapshot<Category?> categorySnap) {
                                                          if (!snapshot.hasData) {
                                                          }
                                                          return snapshot.data!.isEmpty ?
                                                          Text('')
                                                              :
                                                          categorySnap.data.toString() == 'null' ?
                                                          Text('Others', style: smallListTextStyle)
                                                              :
                                                          Text('' + categorySnap.data!.name, style: smallListTextStyle);
                                                        }
                                                    ),
                                                    Spacer(),
                                                    product.stock != null ? Text('Stock: ' + product.stock.toString(), style: smallListTextStyle) : Text(''),
                                                  ]
                                              ),
                                              onTap: () {
                                                setState((){
                                                  bool productStock = false;
                                                  if(product.stock != null) {
                                                    productStock = true;
                                                    if(product.stock! > 0) {
                                                      for(int i = 0; i < itemsToSell.length; i++) {
                                                        if(itemsToSell[i].id == product.id) {
                                                          if(itemsToSell[i].amount + 1 <= product.stock!.toInt()) {
                                                            itemsToSell[i].amount += 1;
                                                            totalPrice += product.price;
                                                            return;
                                                          }
                                                          else {
                                                            return;
                                                          }
                                                        }
                                                      }
                                                      SellItem sellItem = SellItem(
                                                        id: product.id,
                                                        name: product.name,
                                                        amount: 1,
                                                        price: product.price,
                                                        hasStock: productStock,
                                                      );
                                                      totalPrice += product.price;
                                                      itemsToSell.add(sellItem);
                                                      return;
                                                    }
                                                    else {
                                                      return;
                                                    }
                                                  }
                                                  for(int i = 0; i < itemsToSell.length; i++) {
                                                    if(itemsToSell[i].id == product.id) {
                                                      itemsToSell[i].amount += 1;
                                                      totalPrice += product.price;
                                                      return;
                                                    }
                                                  }
                                                  SellItem sellItem = SellItem(
                                                    id: product.id,
                                                    name: product.name,
                                                    amount: 1,
                                                    price: product.price,
                                                    hasStock: productStock,
                                                  );
                                                  totalPrice += product.price;
                                                  itemsToSell.add(sellItem);

                                                });
                                              },
                                              onLongPress: () {
                                                setState((){
                                                  bool productStock = false;
                                                  if (product.stock != null) {
                                                    productStock = true;
                                                  }
                                                  int amount = 0;
                                                  for(int i = 0; i < itemsToSell.length; i++) {
                                                    if(itemsToSell[i].id == product.id) {
                                                      if (product.stock != null) {
                                                        if(10 + itemsToSell[i].amount > product.stock!.toInt()) {
                                                          amount = product.stock!.toInt() - itemsToSell[i].amount;
                                                        }
                                                        else {
                                                          amount = 10;
                                                        }
                                                        itemsToSell[i].amount += amount;
                                                        totalPrice += (product.price * amount);
                                                        return;
                                                      }
                                                      else {
                                                        itemsToSell[i].amount += 10;
                                                        totalPrice += product.price * 10;
                                                        return;
                                                      }
                                                    }
                                                  }
                                                  if (product.stock != null) {
                                                    if(10 > product.stock! && product.stock! > 0) {
                                                      amount = product.stock!.toInt();
                                                      SellItem sellItem = SellItem(
                                                        id: product.id,
                                                        name: product.name,
                                                        amount: amount,
                                                        price: product.price,
                                                        hasStock: productStock,
                                                      );
                                                      itemsToSell.add(sellItem);
                                                      totalPrice += product.price * amount;
                                                      return;
                                                    }
                                                    else if(product.stock!.toInt() <= 0) {
                                                      return;
                                                    }
                                                  }
                                                  SellItem sellItem = SellItem(
                                                    id: product.id,
                                                    name: product.name,
                                                    amount: 10,
                                                    price: product.price,
                                                    hasStock: productStock,
                                                  );
                                                  totalPrice += product.price * 10;
                                                  itemsToSell.add(sellItem);
                                                });
                                              },
                                            ),
                                          ),
                                        );
                                      }
                                      else {
                                        return Card(
                                          color: Colors.transparent,
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                                            height: 80,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                                gradient: LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                    colors: [productListColor1, productListColor2]
                                                )
                                            ),
                                            child: ListTile(
                                              title: Text(product.name, style: miniListTextStyle,),
                                              subtitle: Text(product.price.toString() + ' PHP', style: smallListTextStyle),
                                              trailing: Column(
                                                  children: [
                                                    FutureBuilder<Category?>(
                                                        future: CategoryDatabase.instance.fetchCategory(product.category),
                                                        builder: (BuildContext context, AsyncSnapshot<Category?> categorySnap) {
                                                          if (!snapshot.hasData) {
                                                          }
                                                          return snapshot.data!.isEmpty ?
                                                          Text('')
                                                              :
                                                          categorySnap.data.toString() == 'null' ?
                                                          Text('Others', style: smallListTextStyle)
                                                              :
                                                          Text('' + categorySnap.data!.name, style: smallListTextStyle);
                                                        }
                                                    ),
                                                    Spacer(),
                                                    product.stock != null ? Text('Stock: ' + product.stock.toString(), style: smallListTextStyle) : Text(''),
                                                  ]
                                              ),
                                              onTap: () {
                                                setState((){
                                                  bool productStock = false;
                                                  if(product.stock != null) {
                                                    productStock = true;
                                                    if(product.stock! > 0) {
                                                      for(int i = 0; i < itemsToSell.length; i++) {
                                                        if(itemsToSell[i].id == product.id) {
                                                          if(itemsToSell[i].amount + 1 <= product.stock!.toInt()) {
                                                            itemsToSell[i].amount += 1;
                                                            totalPrice += product.price;
                                                            return;
                                                          }
                                                          else {
                                                            return;
                                                          }
                                                        }
                                                      }
                                                      SellItem sellItem = SellItem(
                                                        id: product.id,
                                                        name: product.name,
                                                        amount: 1,
                                                        price: product.price,
                                                        hasStock: productStock,
                                                      );
                                                      totalPrice += product.price;
                                                      itemsToSell.add(sellItem);
                                                      return;
                                                    }
                                                    else {
                                                      return;
                                                    }
                                                  }
                                                  for(int i = 0; i < itemsToSell.length; i++) {
                                                    if(itemsToSell[i].id == product.id) {
                                                      itemsToSell[i].amount += 1;
                                                      totalPrice += product.price;
                                                      return;
                                                    }
                                                  }
                                                  SellItem sellItem = SellItem(
                                                    id: product.id,
                                                    name: product.name,
                                                    amount: 1,
                                                    price: product.price,
                                                    hasStock: productStock,
                                                  );
                                                  totalPrice += product.price;
                                                  itemsToSell.add(sellItem);

                                                });
                                              },
                                              onLongPress: () {
                                                setState((){
                                                  bool productStock = false;
                                                  if (product.stock != null) {
                                                    productStock = true;
                                                  }
                                                  int amount = 0;
                                                  for(int i = 0; i < itemsToSell.length; i++) {
                                                    if(itemsToSell[i].id == product.id) {
                                                      if (product.stock != null) {
                                                        if(10 + itemsToSell[i].amount > product.stock!.toInt()) {
                                                          amount = product.stock!.toInt() - itemsToSell[i].amount;
                                                        }
                                                        else {
                                                          amount = 10;
                                                        }
                                                        itemsToSell[i].amount += amount;
                                                        totalPrice += (product.price * amount);
                                                        return;
                                                      }
                                                      else {
                                                        itemsToSell[i].amount += 10;
                                                        totalPrice += product.price * 10;
                                                        return;
                                                      }
                                                    }
                                                  }
                                                  if (product.stock != null) {
                                                    if(10 > product.stock! && product.stock! > 0) {
                                                      amount = product.stock!.toInt();
                                                      SellItem sellItem = SellItem(
                                                        id: product.id,
                                                        name: product.name,
                                                        amount: amount,
                                                        price: product.price,
                                                        hasStock: productStock,
                                                      );
                                                      itemsToSell.add(sellItem);
                                                      totalPrice += product.price * amount;
                                                      return;
                                                    }
                                                    else if(product.stock!.toInt() <= 0) {
                                                      return;
                                                    }
                                                  }
                                                  SellItem sellItem = SellItem(
                                                    id: product.id,
                                                    name: product.name,
                                                    amount: 10,
                                                    price: product.price,
                                                    hasStock: productStock,
                                                  );
                                                  totalPrice += product.price * 10;
                                                  itemsToSell.add(sellItem);
                                                });
                                              },
                                            ),
                                          ),
                                        );
                                      }
                                    }).toList(),
                                  );
                                }
                            ),
                          ),
                        )
                      ]
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.all(Radius.circular(24)),
                          ),
                          child: Row(
                            children: [
                              const Spacer(),
                              MyElevatedButton(
                                onPressed:  () {
                                  if (itemsToSell.isNotEmpty) {
                                    setState(() {
                                      DateTime now = DateTime.now();
                                      for(int i = 0; i < itemsToSell.length; i++) {
                                        if(itemsToSell[i].hasStock) {
                                          ProductDatabase.instance.sellProduct(itemsToSell[i].id, itemsToSell[i].amount);
                                        }
                                      }
                                      transactDialog(context);
                                      Transaction transaction = Transaction(
                                        dateTime: now.toString(),
                                        total: totalPrice,
                                      );
                                      TransactionDatabase.instance.add(transaction);
                                      totalPrice = 0;
                                      itemsToSell.clear();
                                    });
                                  }
                                  },
                                child: Text(
                                  'Transact',
                                  style: buttonTextStyle,
                                ),
                                borderRadius: BorderRadius.circular(14.0),
                                gradient: LinearGradient(colors: [buttonColor1, buttonColor2]),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'To Sell',
                          style: TextStyle(
                            color: columnTitleColor,
                            fontWeight: FontWeight.w800,
                            fontSize: 24,
                          ),
                        ),
                        Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                  color: listBackgroundOverlay
                              ),
                              child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: itemsToSell.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                      height: 80,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(8)),
                                          gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [toSellListColor1, toSellListColor2]
                                          )
                                      ),
                                      child: ListTile(
                                        title: Text('${itemsToSell[index].name}', style: listTextStyle),
                                        subtitle: Text('${itemsToSell[index].amount}', style: smallListTextStyle),
                                        onTap: () {
                                          setState(() {
                                            itemsToSell[index].amount = itemsToSell[index].amount - 1;
                                            totalPrice -= itemsToSell[index].price;
                                            if (itemsToSell[index].amount <= 0) {
                                              itemsToSell.removeAt(index);
                                            }
                                          });
                                        },
                                        onLongPress: () {
                                          setState(() {
                                            totalPrice -= itemsToSell[index].price * itemsToSell[index].amount;
                                            itemsToSell.removeAt(index);
                                          });
                                        },
                                      ),
                                    );
                                  }
                              )
                          )
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.all(Radius.circular(24)),
                          ),
                          child: Text('Total Price: ' + totalPrice.toStringAsFixed(2),
                            style: TextStyle(
                              color: Colors.cyan,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ]
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: NavBar(),
        )
    );
  }
}

