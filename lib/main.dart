import 'package:atasayaregitim/Helper/Token.dart';
import 'package:atasayaregitim/Screens/HomeScreen.dart';
import 'package:atasayaregitim/Screens/LoginScreen.dart';
import 'package:flutter/material.dart';

import 'Helper/RouteGenerator.dart';

Future<void> main() async {
  await init();
  runApp(MyApp());
}

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();
  final result = await Token.readToken();
  if (result != null) {
    str = result.token;
  }
}

//Pazar anlatılack
final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
var str = null;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return
      GestureDetector(
        onTap: () {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    },
    child :
      MaterialApp(
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: str != null ? "/" : "/login",
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        backgroundColor: Colors.green,
        accentColor: Colors.deepPurple,
        fontFamily: 'Exo',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      ),

    );
  }
}
