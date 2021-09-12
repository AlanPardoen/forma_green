import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:rflutter_alert/rflutter_alert.dart';

class AccountPage extends StatefulWidget{
  @override
  _AccountPageState createState() => _AccountPageState();
}


class _AccountPageState extends State<AccountPage>{
  Uint8List bytes = Uint8List(0);
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('Users').doc(user.email).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }
          var data = snapshot.data!.data() as Map<String,dynamic>;
          return Scaffold(
              body: Center(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      CircleAvatar(radius: 50,
                        backgroundImage: NetworkImage(data["image"]),),
                      SizedBox(height: 30),
                      Text('Status: ' + data["status"],
                        style: const TextStyle(fontSize: 15.0),),
                      SizedBox(height: 10),
                      if  (data["subdate"].toDate().isBefore(DateTime.now()))
                        Text("Pas d'abonement",
                          style: const TextStyle(fontSize: 15.0, color: Colors.red ), ),
                      if  (data["subdate"].toDate().isAfter(DateTime.now()))
                        Text("Abonement : "+data["subdate"].toDate().toString(),
                          style: const TextStyle(fontSize: 15.0, color: Colors.green ), ),
                      SizedBox(height: 10),
                      Text('Name: ' + data["firstName"],
                        style: const TextStyle(fontSize: 15.0),),
                      SizedBox(height: 10),
                      Text('Email: ' + data["email"],
                        style: const TextStyle(fontSize: 15.0),),
                      SizedBox(height: 10),
                      QrImage(
                        data: user.email!,
                        size: 200.0,
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(onPressed: _scan, child: Text("Scan Now"))
                    ],
                  )
              )
          );
        }
    );
  }

  Future _scan() async {
    await Permission.camera.request();
    String? barcode = await scanner.scan();
    if (barcode == null) {
      print('nothing return.');
    } else {
      var doc = await FirebaseFirestore.instance.collection('Users').doc(barcode).get();

      if (doc.exists){
        var data = doc.data() as Map<String,dynamic>;
        Alert(context: context, title: "User", content: Column(
            children: <Widget>[
              SizedBox(height: 10),
              CircleAvatar(radius: 50,backgroundImage: NetworkImage(data["image"])),
              SizedBox(height: 35),
              Text(data["status"]),
              SizedBox(height: 20),
              Text(data["firstName"]),
              SizedBox(height: 5),
              Text(data["email"]),
            ]
        )).show();
      }else {
        Alert(context: context, title: "Erreur Utilisateur Inconu", desc: "Cet usager n'est pas présent dans la base", image:Image.network("https://outpost24.com/sites/default/files/styles/hotspots/public/2019-04/red-cross.png?itok=EjZAnSVk")).show();
      }
    }
  }
}
