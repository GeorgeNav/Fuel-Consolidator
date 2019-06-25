import 'package:flutter_web/material.dart';
import 'package:firebase/firebase.dart';
import 'package:firebase/firestore.dart';
import '../util/db_util.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  SignIn({Key key}) : super(key: key);

  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String _email;
  String _password;
  bool _invalidLogIn = false;

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
            /* Image(image: AssetImage('images/barrel.png')), */
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
          decoration: InputDecoration(
            hintText: 'email',
          ),
          onChanged: (String input) => _email = input,
        ),
        TextField(
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'password',
          ),
          onChanged: (String input) => _password = input,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton(
              onPressed: () {
                _logIn();
              },
              textColor: Colors.black,
              child: Text('Login'),
            ),
            FlatButton(
              onPressed: () {
                  Navigator.pushNamed(context, '/createaccount');
              },
              textColor: Colors.black,
              child: Text('Create Account'),
            ),
          ],
        ),
        if(_invalidLogIn) Text('Invalid credentials or account doesn\'t exist'),
      ],
    ),
  );

  void _logIn() {
    var a = Provider.of<Auth>(context);
    a.signInWithEmailAndPassword(_email, _password)
    .then((_) {
      print('Your id: ' + a.currentUser.uid);
      if(a.currentUser.emailVerified) {
        print(a.currentUser.email + ' is verified and signed in');
      } else {
        a.signOut();
        print('Please verify your email!');
      }
      setState(() {
        _invalidLogIn = false;
      });
    }).catchError((error) {
      print(error);
      print('Could not sign in');
      setState(() {
        _invalidLogIn = true;
      });
    });
  }
}

class CreateAccount extends StatefulWidget {
  CreateAccount({Key key}) : super(key: key);

  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  Map<String, dynamic> data = {
    'first_name': '',
    'last_name': '',
    'rate_history': [],
    'requested_gallons': 0,
  };
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _same_password = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.all(8),
        width: 500,
        child: Column(
          children: <Widget>[
            TextField(
              controller: _email,
              decoration: InputDecoration(
                hintText: 'email',
              ),
              onChanged: (String text) {
                setState(() {});
              },
            ),
            if(!_validEmail()) Text('Please enter a valid email address'),
            TextField(
              decoration: InputDecoration(
                hintText: 'first name',
              ),
              onChanged: (String text) {
                data['first_name'] = text;
              },
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'last name',
              ),
              onChanged: (String text) {
                data['last_name'] = text;
              },
            ),
            TextField(
              controller: _password,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'password',
              ),
              onChanged: (String text) {
                setState(() {});
              },
            ),
            TextField(
              controller: _same_password,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 're-enter password',
              ),
              onChanged: (String text) {
                setState(() {});
              },
            ),
            if(_password.text != _same_password.text) Text('Password needs to match!'),
            FlatButton(
              onPressed: () async {
                if(await _createUser()) {
                  Navigator.pop(context);
                }
              },
              textColor: Colors.black,
              child: Text('Create Account'),
            ),
          ],
        ),
      ),
    ),
  );

  bool _validEmail() {
    String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(_email.text);
  }

  bool _createUser() {
    Auth a = Provider.of<Auth>(context);

    a.createUserWithEmailAndPassword(_email.text, _password.text)
      .then((_) {
        a.currentUser.sendEmailVerification();
        DBUtil db = Provider.of<DBUtil>(context);
        db.createUserDoc(a.currentUser.uid, data);
        print('Account Created!');
        return true;
      })
      .catchError((error) {
        print('CREATE_USER_ERROR: ' + error);
        return false;
    });

  }
}
