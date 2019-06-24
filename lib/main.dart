import 'package:firebase/firebase_io.dart';
import 'package:flutter_web/material.dart';
import 'package:firebase/firebase.dart';
import 'util/db_util.dart';
import 'screens/login.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  App myApp;
  DBUtil db;
  Auth a;
  UserCredential uc;

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

    DBUtil db = DBUtil(myApp);
    a = auth(myApp);

    // db.databaseAltering();
  }

  @override
  Widget build(BuildContext context) => MultiProvider(
    providers: [
        Provider<App>.value(value: myApp),
        Provider<DBUtil>.value(value: db),
        Provider<Auth>.value(value: a),
        Provider<UserCredential>.value(value: uc),
    ],
    child: MaterialApp(
      title: 'Fuel Consolidator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.lightBlueAccent,
        primaryColorDark: Colors.blueGrey,
      ),
      routes: {
        '/signin': (context) => SignIn(),
        '/createaccount': (context) => CreateAccount(),
      },
      initialRoute: '/signin',
    ),
  );
}

