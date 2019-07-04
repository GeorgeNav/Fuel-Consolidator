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
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
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
    body: Center(
      child: Container(
        width: 500,
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.all(8),
        child: Center(
          child: Column(
            children: <Widget>[
              Text('Hi you are logged in!'),
              _userData(),
              FlatButton(
                child: Text('Update UI'),
                onPressed: () {
                  setState(() {});
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );

  Widget _userData() {
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
              textWidgets.add(Text(key.toString() + ': ' + value.toString()));
            });
          return Column(children: textWidgets);
        }
      },
      initialData: CircularProgressIndicator(),
    );
  }
}
