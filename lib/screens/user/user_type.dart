import 'package:firebase/firestore.dart';
import 'package:flutter_web/material.dart';
import 'package:firebase/firebase.dart';
import 'package:provider/provider.dart';

class UserType extends StatefulWidget {
  UserType({Key key}) : super(key: key);

  _UserTypeState createState() => _UserTypeState();
}

class _UserTypeState extends State<UserType> {
  @override
  Widget build(BuildContext context) {
/*     Firestore fs = Provider.of<Firestore>(context);
    Auth a = Provider.of<Auth>(context); */

    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Text('Hi you are logged in!'),
/*             _userData(), */
            FlatButton(
              onPressed: () {
                _logOut();
                Navigator.of(context).pop();
              },
              textColor: Colors.black,
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }

/*   Widget _userData() => StreamBuilder(
    stream: fs
      .collection('users')
      .doc(a.currentUser.uid).get().asStream(),
    builder: (context, snapshot) {
      print(snapshot.data.toString());
      if(snapshot.hasData) {
        return Text(reflect(snapshot.data).type.reflectedType.toString());
      } else {
        return Text('No Data');
      }
    },
  ); */

  void _logOut() {
    Auth a = Provider.of<Auth>(context);
    a.signOut();
    setState(() {
      Navigator.pop(context);
    });
  }
}