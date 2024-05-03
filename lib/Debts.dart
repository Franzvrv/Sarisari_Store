import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Configuration.dart';
import 'NavBar.dart';
import 'main.dart';
import 'models/Debt.dart';

class DebtsScreen extends StatefulWidget {
  @override
  State<DebtsScreen> createState() => _DebtsScreenState();
}

class _DebtsScreenState extends State<DebtsScreen> {
  int? selectedId;
  TextEditingController labelController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  ClearSelection() {
    selectedId = null;
    labelController.text = '';
    amountController.text = '';
  } //Unselects selected debt

  addDebtDialog(BuildContext context) {
    return showDialog(context: context,builder: (context){
      return AlertDialog(
          scrollable: true,
          title: selectedId == null ? Text('Add Debt', style: dialogTitleTextStyle,) : Text('Update Debt', style: dialogTitleTextStyle,),
          content: Container(
            child: Column(

                children: [
                  TextFormField(
                    controller: labelController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Debtor label',
                      labelStyle: TextStyle(
                        color: Colors.cyan,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ), // Debtor field
                  TextFormField(
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    controller: amountController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'amount (PHP)',
                      labelStyle: TextStyle(
                        color: Colors.cyan,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),// Price field
                  MaterialButton(
                      elevation: 2.0,
                      child: selectedId == null ? Text('Add') : Text('Update'),
                      onPressed: () async {
                        selectedId != null
                            ? await DebtDatabase.instance.update(
                          Debt(id: selectedId,
                            label: labelController.text.toString(),
                            price: double.parse(amountController.text),
                          ),
                        )
                            :
                        await DebtDatabase.instance.add(
                          Debt(label: labelController.text.toString(),
                            price: double.parse(amountController.text),
                          ),
                        );
                        setState((){
                          selectedId = null;
                          Navigator.of(context, rootNavigator: true).pop('dialog');
                        });
                      }
                  ),
                ]
            ),
          )
      );
    }).then((value) {ClearSelection();});
  }

  Widget build (BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          extendBodyBehindAppBar: true,
          extendBody: true,
          appBar: AppBar(
              toolbarHeight: 40,
              centerTitle: true,
              title: Text('Debts'),
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
                              Spacer(),
                              MyElevatedButton(
                                onPressed:  () {
                                  addDebtDialog(context);
                                },
                                child: Text(
                                  'Add Debt',
                                  style: buttonTextStyle,
                                ),
                                borderRadius: BorderRadius.circular(14.0),
                                gradient: LinearGradient(colors: [buttonColor1, buttonColor2]),
                              ),
                            ]
                          )
                        ),
                        Text(
                          'Debts',
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
                            child: FutureBuilder<List<Debt>>(
                                future: DebtDatabase.instance.getDebts(),
                                builder: (BuildContext context, AsyncSnapshot<List<Debt>> snapshot) {
                                  if (!snapshot.hasData) {
                                    return Center(child: CircularProgressIndicator());
                                  }

                                  return snapshot.data!.isEmpty ?
                                  Center(child: Text('Add Debts fom above', style: smallListTextStyle))
                                      :
                                  ListView(
                                    padding: EdgeInsets.zero,
                                    children: snapshot.data!.map((debt) {
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
                                                  colors: [debtListColor1, debtListColor2]
                                              )
                                          ),
                                          child: ListTile(
                                            title: Text(debt.label, style: listTextStyle),
                                            subtitle: Text(debt.price.toString() + ' PHP', style: smallListTextStyle),
                                            onTap: () {
                                              setState((){
                                                selectedId = debt.id;
                                                labelController.text = debt.label;
                                                amountController.text = debt.price.toString();
                                                addDebtDialog(context);
                                              });
                                            },
                                              onLongPress: () {
                                                setState((){
                                                  DebtDatabase.instance.remove(debt.id!);
                                                });
                                              }
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  );
                                }
                            ),
                          ),
                        )
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