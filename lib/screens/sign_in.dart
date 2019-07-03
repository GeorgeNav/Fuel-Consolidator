import 'package:flutter_web/material.dart';
import 'package:firebase/firebase.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  SignIn({Key key}) : super(key: key);

  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
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
    RegExp regExp = new RegExp(p);

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
          if(a.currentUser.emailVerified) {
            _logInInfo = a.currentUser.email + ' is verified and signed in';
            setState(() {
              Navigator.of(context).pushNamed('/user_type');
            });
          } else {
            a.signOut();
            _logInInfo = 'Email isn\'t verified!';
          }
        }).catchError((error) {
          _logInInfo = 'SIGN_IN_ERROR: ' + error.toString();
      });
    }
  }
}
