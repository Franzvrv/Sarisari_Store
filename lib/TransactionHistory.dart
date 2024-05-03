import 'package:flutter/material.dart';
import 'Configuration.dart';
import 'NavBar.dart';
import 'models/Transaction.dart';

class TransactionsScreen extends StatefulWidget {
  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  @override
  Widget build (BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          extendBodyBehindAppBar: true,
          extendBody: true,

          appBar: AppBar(
              toolbarHeight: 40,
              centerTitle: true,
              title: Text('Transaction History'),
              backgroundColor: appBarBGColor,
          ),
          body: Container (
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 70),
            decoration: appBoxDecoration,
            child: Row(
              children: [
                Expanded(
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
                                  setState(() {
                                    TransactionDatabase.instance.removeAll();
                                  });
                                },
                                child: Text(
                                  'Clear Transactions',
                                  style: buttonTextStyle,
                                ),
                                borderRadius: BorderRadius.circular(14.0),
                                gradient: LinearGradient(colors: [buttonColor1, buttonColor2]),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'Transactions',
                          style: TextStyle(
                            color: columnTitleColor,
                            fontWeight: FontWeight.w800,
                            fontSize: 24,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                color: listBackgroundOverlay
                            ),
                            child: FutureBuilder<List<Transaction>>(
                                future: TransactionDatabase.instance.getTransactions(),
                                builder: (BuildContext context, AsyncSnapshot<List<Transaction>> snapshot) {
                                  if (!snapshot.hasData) {
                                    return Center(child: CircularProgressIndicator());
                                  }
                                  return snapshot.data!.isEmpty ?
                                  Center(child: Text('Transactions will be shown here', style: smallListTextStyle))
                                      :
                                  ListView(
                                    padding: EdgeInsets.zero,
                                    children: snapshot.data!.map((transaction) {
                                      DateTime dateTime = DateTime.parse(transaction.dateTime);
                                      String convertedDateTime = "${dateTime.year.toString()}-${dateTime.month.toString().padLeft(2,'0')}-${dateTime.day.toString().padLeft(2,'0')} ${dateTime.hour.toString().padLeft(2,'0')}:${dateTime.minute.toString().padLeft(2,'0')}";
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
                                                  colors: [transactionListColor1, transactionListColor2]
                                              )
                                          ),
                                          child: ListTile(
                                            title: Text(convertedDateTime, style: listTextStyle,),
                                            subtitle: Text('Amount: ' + transaction.total.toString() + ' PHP', style: smallListTextStyle),
                                            ),
                                          )
                                      );
                                    }).toList(),
                                  );
                                }
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