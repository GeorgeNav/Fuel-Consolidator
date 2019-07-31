import 'package:firebase_web/firestore.dart';
import 'package:flutter_web/material.dart';
import 'package:firebase_web/firebase.dart';
import 'package:flutter_web/painting.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class Client extends StatefulWidget {
  Client({Key key}) : super(key: key);

  _ClientState createState() => _ClientState();
}

class _ClientState extends State<Client> {
  Map<String, dynamic> quote_data = {
    'quote_name': '',
    'gallons_requested': 0,
    'delivery_address': '',
    'delivery_date': DateTime.now(),
    'suggested_price': 0,
    'total_amount_due': 0,
  };

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 3,
    child: Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          tabs: <Widget>[
            Tab(icon: Icon(Icons.portrait)),
            Tab(icon: Icon(Icons.add)),
            Tab(icon: Icon(Icons.history)),
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
          _createQuote(),
          _userQuotes(),
        ],
      ),
    ),
  );

  Widget _userProfile() {
    Firestore fs = Provider.of<Firestore>(context);
    Auth a = Provider.of<Auth>(context);
    
    return FutureBuilder(
      future: fs.collection('clients')
        .doc(a.currentUser.uid).get().then((doc) => doc.data()),
      initialData: LinearProgressIndicator(),
      builder: (context, snapshot) {
        if(snapshot.connectionState != ConnectionState.done) {
          return LinearProgressIndicator();
        }
        Map<String, dynamic> data = snapshot.data;
        List<Widget> children = <Widget>[];
        data.forEach((String key, dynamic value) {
          if(key != 'quotes') {
            children.add(getUserInfoCard(key, value.toString(), Colors.lightBlue, Colors.white));
          }
        });
        return ListView(children: children);
      },
    );
  }

  Map<String, TextEditingController> controllers = {
    'name': TextEditingController(),
    'gallons_requested': TextEditingController(),
  };

  Widget _createQuote() => Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(8),
      child: Column(
        children: <Widget>[
          TextField(
            controller: controllers['name'],
            decoration: InputDecoration(hintText: 'Name of the quote (example: Quote 1)'),
            onChanged: (String text) => quote_data['quote_name'] = text,
          ),
          TextField(
            controller: controllers['gallons_requested'],
            decoration: InputDecoration(hintText: 'Amount of gallons you are requesting'),
            onChanged: (String text) {
              if(num.tryParse(text) != null) {
                quote_data['gallons_requested'] = double.parse(text);
                _updateQuoteData();
              } else {
                quote_data['gallons_requested'] = 0;
                quote_data['total_amount_due'] = 0;
              }
            }
          ),
          Text('Address: ' + quote_data['delivery_address']),
          Text('Date and Time: ' + DateTime.now().toString()),
          Text('Suggested Price: \$' + quote_data['suggested_price'].toString()),
          Text('Total Amount Due: \$' + quote_data['total_amount_due'].toString()),
          FlatButton(
            color: Colors.blue,
            onPressed: () {
              Firestore fs = Provider.of<Firestore>(context);
              Auth a = Provider.of<Auth>(context);

              if(quote_data['quote_name'] == '' || quote_data['gallons_requested']  == '') {
                return null;
              }

              fs.collection('clients').doc(a.currentUser.uid).set({
                  'quotes': FieldValue.arrayUnion([quote_data])
                },
                SetOptions(merge: true)
              ).then((_) {
                quote_data['quote_name'] = '';
                quote_data['gallons_requested'] = '';
                quote_data['delivery_date'] = DateTime.now();
                quote_data['suggested_price'] = 0;
                quote_data['total_amount_due'] = 0;
                controllers['name'].clear();
                controllers['gallons_requested'].clear();
                setState(() {});
              }).catchError((error) {
                print(error);
              });
            },
            textColor: Colors.black,
            child: Text('Inquire for a Quote'),
          ),
        ],
      ),
    );

  void _updateQuoteData() async {
    Firestore fs = Provider.of<Firestore>(context);
    Auth a = Provider.of<Auth>(context);

    await fs.collection('clients')
      .doc(a.currentUser.uid).get().then((doc) {
        Map<String, dynamic> data = doc.data();
        quote_data['delivery_address'] =
          data['address_1'] + ', ' +
          data['zipcode'] + ' ' +
          data['city'] + ', ' + data['state'];
        var time = DateTime.now();
        double
          current_price = 1.5,
          location_factor = data['state'] == 'TX' ? 0.02 : 0.04,
          rate_history_factor = data['quotes'].length > 0 ? 0.01 : 0,
          gallons_requested_factor = quote_data['gallons_requested'] > 1000 ? 0.02 : 0.03,
          company_profit_factor = 0.1,
          rate_fluctuation = time.isAfter(DateTime(time.year, DateTime.june, 20)) && time.isBefore(DateTime(time.year, DateTime.september, 24)) ? 0.04 : 0.03;

        /* Location Factor - Rate History Factor + Gallons Requested Factor + Company Profit Factor + Rate Fluctuation */
        print('Current Price + Current Price * ( Location Factor - Rate History Factor + Gallons Requested Factor + Company Profit Factor + Rate Fluctuation)');
        print('${current_price} + ${current_price} * ( ${location_factor} - ${rate_history_factor} + ${gallons_requested_factor} + ${company_profit_factor} + ${rate_fluctuation} ) = ${current_price + current_price * (location_factor - rate_history_factor + gallons_requested_factor + company_profit_factor + rate_fluctuation)}');
        quote_data['suggested_price'] = double.parse((current_price + current_price * (location_factor - rate_history_factor + gallons_requested_factor + company_profit_factor + rate_fluctuation)).toStringAsFixed(2));
        quote_data['total_amount_due'] = double.parse((quote_data['gallons_requested'] * quote_data['suggested_price']).toStringAsFixed(2));
        print('Total Amount Due: ' + quote_data['total_amount_due'].toString());
        setState(() {});
      });
  }
  
  Widget _userQuotes() {
    Firestore fs = Provider.of<Firestore>(context);
    Auth a = Provider.of<Auth>(context);

    return FutureBuilder(
      future: fs.collection('clients')
        .doc(a.currentUser.uid).get().then((doc) => doc.data()),
      initialData: LinearProgressIndicator(),
      builder: (context, snapshot) {
        if(snapshot.connectionState != ConnectionState.done) {
          return LinearProgressIndicator();
        }
        List<dynamic> quotes = snapshot.data['quotes'];
        List<Widget> quote_children = <Widget>[];
        quotes.forEach((map) {
          List<Widget> quote_data = <Widget>[];
          map.forEach((String key, dynamic value) {
            quote_data.add(getQuoteInfoCard(key, value.toString(), Colors.lightBlue, Colors.white));
          });
          quote_children.add(Container(
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.all(8),
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: quote_data,
              ),
            ),
          ));
        });

        return ListView(
          children: quote_children,
        );
      },
    );
  }

  Widget getUserInfoCard(String key, String value, Color key_color, Color value_color) => Center(
    child: Card(
      child: Container(
        padding: EdgeInsets.all(8),
        color: key_color,
        height: 75,
        width: 500,
        child: Row(
          children: <Widget>[
            Container(
              width: 200,
              child: Center(
                child: Text(capitalize(key.replaceAll('_', ' '))),
              ),
            ),
            Expanded(
              child: Card(
                child: Container(
                  padding: EdgeInsets.all(8),
                  color: value_color,
                  height: 75,
                  child: Container(
                    width: 200,
                    child: Center(
                      child: TextFormField(
                        initialValue: value,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget getQuoteInfoCard(String key, String value, Color key_color, Color value_color) => Center(
    child: Card(
      child: Container(
        height: 100,
        width: 200,
        padding: EdgeInsets.all(8),
        color: key_color,
        child: Column(
          children: <Widget>[
            Container(
              child: Center(
                child: Text(capitalize(key.replaceAll('_', ' ')))
              ),
            ),
            Expanded(
              child: Card(
                child: Container(
                  padding: EdgeInsets.all(8),
                  color: value_color,
                  child: Center(child: Text(value)),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  String capitalize(String input) {
    if (input == null || input.length == 0) {
      return '';
    }
    return input[0].toUpperCase() + input.substring(1);
  }
}
