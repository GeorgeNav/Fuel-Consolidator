import 'package:firebase_web/firestore.dart';
import 'package:flutter_web/material.dart';
import 'package:firebase_web/firebase.dart';
import 'package:provider/provider.dart';

class Client extends StatefulWidget {
  Client({Key key}) : super(key: key);

  _ClientState createState() => _ClientState();
}

class _ClientState extends State<Client> {

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 2,
    child: Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          tabs: <Widget>[
            Tab(icon: Icon(Icons.portrait)),
            Tab(icon: Icon(Icons.power)),
          ],
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Auth a = Provider.of<Auth>(context);
              a.signOut();
              setState(() {
                Navigator.pop(context);
              });
            },
            textColor: Colors.black,
            child: Text('Logout'),
          ),
        ],
      ),
      backgroundColor: Colors.blueGrey,
      body: TabBarView(
        children: <Widget>[
          _userProfile(),
          _userQuotes(),
        ],
      ),
    ),
  );

  Widget _userProfile() {
    Firestore fs = Provider.of<Firestore>(context);
    Auth a = Provider.of<Auth>(context);
    
    return FutureBuilder(
      future: fs.collection('users')
        .doc(a.currentUser.uid).get().then((doc) => doc.data()),
      builder: (context, snapshot) {
        if(snapshot.connectionState != ConnectionState.done) {
          return CircularProgressIndicator();
        } else {
            Map<String, dynamic> data = snapshot.data;
            List<Widget> textWidgets = <Widget>[];
            data.forEach((String key, dynamic value) {
              textWidgets.add(
                getCard(key.toString() + ': ' + value.toString(), Colors.yellow)
              );
            });
          return ListView(children: textWidgets);
        }
      },
      initialData: CircularProgressIndicator(),
    );
  }
  _userQuotes() {
    Firestore fs = Provider.of<Firestore>(context);
    Auth a = Provider.of<Auth>(context);
    
    return FutureBuilder(
      future: fs.collection('quotes')
        .doc(a.currentUser.uid).get().then((doc) => doc.data()),
      builder: (context, snapshot) {
        if(snapshot.connectionState != ConnectionState.done) {
          return CircularProgressIndicator();
        } else {
            Map<String, dynamic> data = snapshot.data;
            List<Widget> textWidgets = <Widget>[];
            data.forEach((String key, dynamic value) {
              textWidgets.add(
                getCard(key.toString() + ': ' + value.toString(), Colors.blue)
              );
            });
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: textWidgets
          );
        }
      },
      initialData: CircularProgressIndicator(),
    );
  }

  Widget getCard(String text, Color color) => Card(
    child: InkWell(
      splashColor: Colors.blue,
      child: Container(
        padding: EdgeInsets.all(16),
        color: color,
        height: 200,
        child: Center(child: Text(text)),
      ),
  ));
}
