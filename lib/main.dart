import 'package:flutter_web/material.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart' as fs;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var myApp = fb.initializeApp(
      apiKey: "AIzaSyChNwMyclSxQrr2rpKeq8dgJq6q3y0CJ6Y",
      authDomain: "fuel-consolidator.firebaseapp.com",
      databaseURL: "https://fuel-consolidator.firebaseio.com",
      projectId: "fuel-consolidator",
      storageBucket: "fuel-consolidator.appspot.com",
      messagingSenderId: "215639791821",
      name: "1:215639791821:web:31362194cdc54d9d",
    );

    // var fsStorage = fb.storage(myApp);
    var fsInstance = fb.firestore(myApp);

    var sourceColRef = fsInstance.collection('sources');
    sourceColRef.doc('testDoc1').set({
      'key': 'value',
      'price': 45,
    });
    sourceColRef.doc('testDoc2').set({'key': 'value'});
    sourceColRef.doc('testDoc3').set({'key': 'value'});

    sourceColRef.doc('testDoc1').get().then(
      (doc) => print(doc.data()['price']));

    sourceColRef.doc('testDoc1').get().then(
      (doc) => !doc.exists ?
        print('No such document!') :
        print(doc.data())
    );

/*     sourceColRef.doc('testDoc1').delete();
    sourceColRef.doc('testDoc2').delete();
    sourceColRef.doc('testDoc3').delete(); */

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(title),
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Hello There!'),
        ],
      ),
    ),
  );
}
