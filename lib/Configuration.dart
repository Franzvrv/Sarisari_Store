import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'main.dart';

Color appBarBGColor = const Color.fromARGB(20, 150, 250, 200);
BoxDecoration appBoxDecoration = BoxDecoration(
    gradient: LinearGradient(
        end: Alignment.bottomRight,
        begin: Alignment.topLeft,
        colors: [appBGColor1, appBGColor2, appBGColor3]
    )
); //App background

Color navBarIconColor = const Color.fromARGB(255, 150, 250, 200);
ButtonStyle navBarButtonStyle = ButtonStyle(

  backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
); //Navigation bar button styles

TextStyle buttonTextStyle = const TextStyle(
  color: Color.fromARGB(200, 255, 255, 255),
  fontSize: 24,
  fontWeight: FontWeight.w800,
); //Style of button texts
TextStyle smallButtonTextStyle = const TextStyle(
  color: Color.fromARGB(200, 255, 255, 255),
  fontSize: 16,
  fontWeight: FontWeight.w800,
); //Style of button's small texts
TextStyle listTextStyle = const TextStyle(
  color: Color.fromARGB(238, 255, 255, 255),
  fontSize: 18,
  fontWeight: FontWeight.w800,
); //Text style of list
TextStyle miniListTextStyle = const TextStyle(
  color: Color.fromARGB(200, 255, 255, 255),
  fontSize: 16,
  fontWeight: FontWeight.w800,
); //Small text style of list
TextStyle smallListTextStyle = const TextStyle(
  color: Color.fromARGB(238, 255, 255, 255),
  fontSize: 16,
  fontWeight: FontWeight.w800,
); //smaller text style of list
TextStyle dialogTitleTextStyle = const TextStyle(
  color: Color.fromARGB(238, 35, 35, 35),
  fontSize: 18,
  fontWeight: FontWeight.w800,
); //Text style of dialog title

Color columnTitleColor = const Color.fromARGB(255, 221, 231, 232);
Color listBackgroundOverlay = const Color.fromARGB(100, 0, 0, 0);
Color appBGColor1 = const Color.fromARGB(255, 51, 6, 68);
Color appBGColor2 = const Color.fromARGB(255, 7, 20, 69);
Color appBGColor3 = const Color.fromARGB(255, 5, 32, 61);

Color listTextColor = const Color.fromARGB(255, 255, 255, 255);
Color productListColor1 = const Color.fromARGB(255, 255, 203, 82);
Color productListColor2 = const Color.fromARGB(255, 255, 123, 2);
Color productEmptyListColor1 = const Color.fromARGB(255, 111, 89, 36);
Color productEmptyListColor2 = const Color.fromARGB(255, 101, 44, 0);
Color toSellListColor1 = const Color.fromARGB(255, 193, 101, 221);
Color toSellListColor2 = const Color.fromARGB(255, 92, 39, 254);
Color transactionListColor1 = const Color.fromARGB(255, 85, 129, 241);
Color transactionListColor2 = const Color.fromARGB(255, 17, 83, 252);
Color debtListColor1 = const Color.fromARGB(255, 250, 205, 104);
Color debtListColor2 = const Color.fromARGB(255, 252, 118, 179);
Color buttonColor1 = const Color.fromARGB(255, 210, 40, 125);
Color buttonColor2 = const Color.fromARGB(255, 79, 4, 156);

Color sellListColor1 = const Color.fromARGB(255, 164, 220, 204);
Color sellListColor2 = const Color.fromARGB(255, 229, 203, 118);

class MyElevatedButton extends StatelessWidget {
  final BorderRadiusGeometry? borderRadius;
  final double? width;
  final double height;
  final Gradient gradient;
  final VoidCallback? onPressed;
  final Widget child;

  const MyElevatedButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.borderRadius,
    this.width,
    this.height = 44.0,
    this.gradient = const LinearGradient(colors: [Colors.cyan, Colors.indigo]),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderRadius = this.borderRadius ?? BorderRadius.circular(0);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: borderRadius,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
        ),
        child: child,
      ),
    );
  }
} //Custom button
