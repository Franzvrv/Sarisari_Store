import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Configuration.dart';
import 'NavBar.dart';
import 'package:flutter/widgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(Main());
}

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);
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
            title: Text('Sari-sari Store Management'),
            backgroundColor: appBarBGColor,
        ),
        body: Container (
          decoration: appBoxDecoration,
        ),
        bottomNavigationBar: NavBar(),
      )
    );
  }
}
