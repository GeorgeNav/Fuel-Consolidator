import 'package:flutter_web/material.dart';
import 'package:firebase_web/firebase.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  String _logInInfo = '';

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.lightBlue,
    body: Center(
      child: Container(
        width: 500,
        child: Column(
          children: <Widget>[
            Container(
              width: 100,
              height: 100,
              child: Icon(Icons.data_usage),
            ),
            // Image(image: AssetImage('images/barrel.png')),
            _signInForm(),
          ],
        ),
      ),
    ),
  );

  Widget _signInForm() => Container(
    padding: EdgeInsets.all(8),
    margin: EdgeInsets.all(8),
    child: Column(
      children: <Widget>[
        TextField(
          controller: _email,
          decoration: InputDecoration(
            hintText: 'email',
          ),
        ),
        TextField(
          controller: _password,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'password',
          ),
        ),
        if(_logInInfo != '') Text(_logInInfo),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton(
              onPressed: () {
                _logIn();
                setState(() {});
              },
              textColor: Colors.black,
              child: Text('Login'),
            ),
            FlatButton(
              onPressed: () {
                  Navigator.pushNamed(context, '/create_account');
              },
              textColor: Colors.black,
              child: Text('Create Account'),
            ),
          ],
        ),
      ],
    ),
  );

  bool _validEmail() {
    String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(p);

    return regExp.hasMatch(_email.text);
  }

  void _logIn() {
    if(!_validEmail()) {
      _logInInfo = 'Enter a valid email address';
    } else {
      Auth a = Provider.of<Auth>(context);
      a.signInWithEmailAndPassword(_email.text, _password.text)
        .then((_) {
          print('Your id: ' + a.currentUser.uid);
          _logInInfo = a.currentUser.email + ' is signed in';
          // TODO: implement employee log in
          setState(() {
            Navigator.of(context).pushNamed('/client');
          });
          // TODO: decide on verifiing email
/*           if(a.currentUser.emailVerified) {
            _logInInfo = a.currentUser.email + ' is verified and signed in';
            // TODO: implement employee log in
            setState(() {
              Navigator.of(context).pushNamed('/client');
            });
          } else {
            a.signOut();
            _logInInfo = 'Email isn\'t verified!';
          } */
        }).catchError((error) {
          _logInInfo = 'SIGN_IN_ERROR: ' + error.toString();
      });
    }
  }
}
