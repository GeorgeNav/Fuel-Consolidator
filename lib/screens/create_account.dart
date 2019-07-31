import 'package:flutter_web/material.dart';
import 'package:firebase_web/firebase.dart';
import 'package:firebase_web/firestore.dart';
import 'package:provider/provider.dart';

class CreateAccount extends StatefulWidget {
  CreateAccount({Key key}) : super(key: key);

  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  String _email;
  String _password;

  Map<String, dynamic> data = {
    'first_name': '',
    'last_name': '',
    'address_1': '',
    'address_2': '',
    'city': '',
    'state': '',
    'zipcode': '',
    'quotes': [],
  };

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Container(
        padding: EdgeInsets.all(16),
        width: 500,
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(hintText: 'Email'),
              onChanged: (String text) => _email = text,
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(hintText: 'Password'),
              onChanged: (String text) => _password = text,
            ),
            Row(
              children: <Widget>[
                Flexible(
                  child: TextField(
                    maxLength: 50,
                    decoration: InputDecoration(hintText: 'First Name'),
                    onChanged: (String text) => data['first_name'] = text,
                  ),
                ),
                Spacer(flex: 1),
                Flexible(
                  child: TextField(
                    maxLength: 50,
                    decoration: InputDecoration(hintText: 'Last Name'),
                    onChanged: (String text) => data['last_name'] = text,
                  ),
                ),
              ],
            ),
            TextField(
              maxLength: 100,
              decoration: InputDecoration(hintText: 'Address 1'),
              onChanged: (String text) => data['address_1'] = text,
            ),
            TextField(
              maxLength: 100,
              decoration: InputDecoration(hintText: 'Address 2'),
              onChanged: (String text) => data['address_2'] = text,
            ),
            Row(
              children: <Widget>[
                Flexible(
                  child: TextField(
                    maxLength: 100,
                    decoration: InputDecoration(hintText: 'City'),
                    onChanged: (String text) => data['city'] = text,
                  ),
                ),
                Spacer(flex: 1),
                Flexible(
                  child: TextField(
                    maxLength: 9,
                    decoration: InputDecoration(hintText: 'Zipcode'),
                    onChanged: (String text) => data['zipcode'] = text,
                  ),
                ),
                Spacer(flex: 1),
                DropdownButton<String>(
                  value: data['state'],
                  hint: Text('State'),
                  items: ['', 'AL', 'AK', 'AS', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'DC', 'FM', 'FL', 'GA', 'GU', 'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY', 'LA', 'ME', 'MH', 'MD', 'MA', 'MI', 'MN', 'MS', 'MO', 'MT', 'NE', 'NV', 'NH', 'NJ', 'NM', 'NY', 'NC', 'ND', 'MP', 'OH', 'OK', 'OR', 'PW', 'PA', 'PR', 'RI', 'SC', 'SD', 'TN', 'TX', 'UT', 'VT', 'VI', 'VA', 'WA', 'WV', 'WI', 'WY'].map(
                    (String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    )).toList(),
                  onChanged: (selection) {
                    setState(() {
                      data['state'] = selection;
                    });
                  },
                ),
              ],
            ),
            FlatButton(
              onPressed: () async {
                await _createUser();
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
    RegExp regExp = RegExp(p);

    return regExp.hasMatch(_email);
  }

  void _createUser() async {
    Auth a = Provider.of<Auth>(context);

    if(!_validEmail() ||
      data['first_name'].length < 1 ||
      data['last_name'].length < 1 ||
      data['address_1'].length < 1 ||
      data['city'].length < 1 ||
      data['state'].length < 1 ||
      data['zipcode'].length < 5) {
      return;
    }

    await a.createUserWithEmailAndPassword(_email, _password)
      .then((_) {
        a.currentUser.sendEmailVerification();
        Firestore fs = Provider.of<Firestore>(context);

        fs.collection('clients').doc(a.currentUser.uid).set(data);
        print('ACCOUNT CREATED!');
        Navigator.pop(context);
      }).catchError((error) {
        print('CREATE USER ERROR: ' + error);
    });
  }
}
