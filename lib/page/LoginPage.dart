import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forma_green/page/MainPage.dart';
import 'package:forma_green/utils/database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../main.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

late UserCredential userCredential;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
            title: Text("Login")),
        body: CustomScrollView(primary: false, slivers: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverGrid.count(
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 1,
              children: <Widget>[
                Container(
                  child:  new Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Image.asset('images/logo.png'),
                      Text("Come Naturally".toUpperCase(), style: GoogleFonts.dancingScript(fontSize: 22.0, color: Colors.green,),),
                    ],
                  )
                ),
                Container(
                  child:Scaffold(
                    body: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: Colors.black,
                            minimumSize: Size(double.infinity, 50)),
                        onPressed: () async {
                          // Trigger the authentication flow
                          final GoogleSignInAccount? googleUser =
                              await GoogleSignIn().signIn();

                          // Obtain the auth details from the request
                          final GoogleSignInAuthentication googleAuth =
                              await googleUser!.authentication;

                          // Create a new credential
                          final credential = GoogleAuthProvider.credential(
                            accessToken: googleAuth.accessToken,
                            idToken: googleAuth.idToken,
                          );
                          // Once signed in, return the UserCredential
                          userCredential = await FirebaseAuth.instance
                              .signInWithCredential(credential);
                          User user = userCredential.user!;
                          var test = await FirebaseFirestore.instance.collection('Users').doc(user.email).get();
                          if (!test.exists) {
                            await FirebaseFirestore.instance.collection('Users')
                                .doc(user.email)
                                .set({
                              'firstName': user.displayName,
                              'email': user.email,
                              'status': 'bénévole',
                              'image': user.photoURL,
                              'subdate':DateTime.now().add(const Duration(days: -1))
                            });
                          }else{
                            print("start");
                            var data = test.data() as Map<String,dynamic>;
                            if(data["status"] == "abonné"){

                              if(data["subdate"].toDate().isBefore(DateTime.now())){
                                await FirebaseFirestore.instance.collection('Users')
                                    .doc(user.email)
                                    .set({
                                  'firstName': data["firstName"],
                                  'email': data["email"],
                                  'status': 'bénévole',
                                  'image': data["image"],
                                  'subdate':data["subdate"]
                                });
                              }
                            }
                            print("end");
                          }
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) {
                              return MainPage(key: MyApp.mainPageState ,);
                            }),
                          );
                        },
                        icon:
                            FaIcon(FontAwesomeIcons.google, color: Colors.green),
                        label: Text('Sign Up with Google'))
                ),
                ),

              ]),
        )
      ]));
}
