import 'package:flutter_web/material.dart';
import 'package:firebase/firestore.dart';
import 'package:firebase/firebase.dart';
import 'package:provider/provider.dart';
import 'screens/user/user_type.dart';
import 'screens/create_account.dart';
import 'screens/sign_in.dart';

void main() {
  App myApp = initializeApp(
    apiKey: "AIzaSyChNwMyclSxQrr2rpKeq8dgJq6q3y0CJ6Y",
    authDomain: "fuel-consolidator.firebaseapp.com",
    databaseURL: "https://fuel-consolidator.firebaseio.com",
    projectId: "fuel-consolidator",
    storageBucket: "fuel-consolidator.appspot.com",
    messagingSenderId: "215639791821",
    name: "1:215639791821:web:31362194cdc54d9d",
  );

  runApp(MyApp(
    firestore(myApp),
    myApp,
    auth(myApp),
  ));
}

class MyApp extends StatelessWidget {
  final Firestore fs;
  final App myApp;
  final Auth a;

  MyApp(this.fs, this.myApp, this.a);

  @override
  Widget build(BuildContext context) => MultiProvider(
    providers: [
        Provider<Firestore>.value(value: fs),
        Provider<App>.value(value: myApp),
        Provider<Auth>.value(value: a),
    ],
    child: MaterialApp(
      title: 'Fuel Consolidator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.lightBlueAccent,
        primaryColorDark: Colors.blueGrey,
      ),
      routes: {
        '/': (context) => SignIn(),
        '/create_account': (context) => CreateAccount(),
        '/user_type': (context) => UserType(),
      },
      initialRoute: '/',
    ),
  );
}
