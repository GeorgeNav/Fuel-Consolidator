import 'package:firebase/firebase.dart';
import 'package:firebase/firestore.dart';

class DBUtil {
  Firestore fsInstance;
  App myApp;

  DBUtil(App myApp) {
    fsInstance = firestore(myApp);
  }

  databaseAltering() {
    var sourceColRef = fsInstance.collection('sources');
    sourceColRef.doc('testDoc1').set({
      'key': 'value',
      'price': 45,
    });
    sourceColRef.doc('testDoc2').set({'key': 'value'});
    sourceColRef.doc('testDoc3').set({'key': 'value'});

    sourceColRef.doc('testDoc1').get().then(
      (doc) => print(doc.data()['price']));

    sourceColRef.doc('testDoc1').get().then(
      (doc) => !doc.exists ?
        print('No such document!') :
        print(doc.data())
    );
  }
}