import 'package:flutter_web/material.dart';
import 'package:firebase/firebase.dart';
import 'util/db_util.dart';
import 'screens/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  App myApp;
  DBUtil d;

  MyApp() {
    myApp = initializeApp(
      apiKey: "AIzaSyChNwMyclSxQrr2rpKeq8dgJq6q3y0CJ6Y",
      authDomain: "fuel-consolidator.firebaseapp.com",
      databaseURL: "https://fuel-consolidator.firebaseio.com",
      projectId: "fuel-consolidator",
      storageBucket: "fuel-consolidator.appspot.com",
      messagingSenderId: "215639791821",
      name: "1:215639791821:web:31362194cdc54d9d",
    );

    DBUtil du = DBUtil(myApp);
    // d.databaseAltering();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Fuel Consolidator',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    routes: {
      '/signin': (context) => SignIn(),
      '/createaccount': (context) => CreateAccount(),
    },
    initialRoute: '/signin',
  );
}

