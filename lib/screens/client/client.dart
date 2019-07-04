import 'package:firebase/firestore.dart';
import 'package:flutter_web/material.dart';
import 'package:firebase/firebase.dart';
import 'package:provider/provider.dart';

class Client extends StatefulWidget {
  Client({Key key}) : super(key: key);

  _ClientState createState() => _ClientState();
}

class _ClientState extends State<Client> {
  String stateSelection = 'State';
  TextEditingController zipcode;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.blueGrey,
    body: Container(
      width: 500,
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(8),
      child: Center(
        child: Column(
          children: <Widget>[
            Text('Hi you are logged in!'),
            _userData(),
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
    ),
  );

  Widget _userData() {
    List<String> states = ['State', 'AL', 'AK', 'AS', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'DC', 'FM', 'FL', 'GA', 'GU', 'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY', 'LA', 'ME', 'MH', 'MD', 'MA', 'MI', 'MN', 'MS', 'MO', 'MT', 'NE', 'NV', 'NH', 'NJ', 'NM', 'NY', 'NC', 'ND', 'MP', 'OH', 'OK', 'OR', 'PW', 'PA', 'PR', 'RI', 'SC', 'SD', 'TN', 'TX', 'UT', 'VT', 'VI', 'VA', 'WA', 'WV', 'WI', 'WY' ];

    return Column(
      children: <Widget>[
        // will need to figure out how to automatically pull name from database when client creats and account
        TextFormField(
          // first and last name
          decoration: InputDecoration(labelText: 'Firstname Lastname'),
          initialValue: 'George Navarro',
          maxLength: 50, //(required)
          enableInteractiveSelection: false, // non-editable
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Address'),
          initialValue: '12345 Katy Mills Blvd A',
          maxLength: 100, //(required)
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'City'),
          initialValue: 'Katy',
          maxLength: 100, //(required)
        ),
        Container(
          alignment: Alignment.centerLeft,
          child: DropdownButton<String>(
            value: stateSelection,
            items: states
                .map((String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    ))
                .toList(),
            onChanged: (selection) {
              setState(() {
                stateSelection = selection;
              });
            },
          ),
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Zipcode'),
          initialValue: '77494',
          maxLength: 9, //(required)
          controller: zipcode,
          // need to account for 5 characters minimum (required)
        ),
      ],
    );
  }

  void _logOut() {
    Auth a = Provider.of<Auth>(context);
    a.signOut();
    setState(() {
      Navigator.pop(context);
    });
  }
}
