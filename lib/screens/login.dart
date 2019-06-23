import 'package:flutter_web/material.dart';
import 'package:firebase/firebase.dart';
import 'package:firebase/firestore.dart';
import '../util/db_util.dart';

class SignIn extends StatefulWidget {
  SignIn({Key key}) : super(key: key);

  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Container(
        width: 400,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                hintText: 'email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(),
                ),
              ),
            ),
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatButton(
                  onPressed: () => null,
                  color: Colors.white,
                  textColor: Colors.black,
                  child: Text('Login'),
                ),
                FlatButton(
                  onPressed: () => Navigator.pushNamed(context, '/createaccount'),
                  color: Colors.white,
                  textColor: Colors.black,
                  child: Text('Create Account'),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

class CreateAccount extends StatefulWidget {
  CreateAccount({Key key}) : super(key: key);

  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Container(
        width: 400,
          child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                hintText: 'email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(),
                ),
              ),
            ),
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(),
                ),
              ),
            ),
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: 're-enter password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(),
                ),
              ),
            ),

            FlatButton(
              onPressed: () => Navigator.pop(context),
              color: Colors.white,
              textColor: Colors.black,
              child: Text('Create Account'),
            ),
          ],
        ),
      ),
    ),
  );
}