import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:forma_green/main.dart';
import 'package:forma_green/page/HomePage.dart';
import 'package:forma_green/page/MainPage.dart';
import 'package:forma_green/page/MapPage.dart';
import 'package:forma_green/utils/database.dart';
import 'package:forma_green/utils/Global.dart' as global;
import 'package:google_maps_flutter/google_maps_flutter.dart';



class ItemList extends StatelessWidget {
  final Database repository = Database();
  var storage = FirebaseStorage.instance.ref() ;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Map').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }
/*          return _buildGrid(snapshot.data!.docs as Map<String, dynamic>);*/
          return GridView.count(
            crossAxisCount: 2,
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String,dynamic>;
              return GridTile(
                  child: new InkResponse( child:Image.network(data['img']),onTap: () => _onTileClicked(data['coord'],data['title'])),
                  footer:Container(padding:const EdgeInsets.all(10.0) ,color: Color.fromRGBO(0, 0, 0, 0.5),child: _buildTitleListe(data['title'],data['coord']))
              );
            }).toList(),
          );
        });

  }

  Column _buildTitleListe( String title,String coord) => Column(crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(
            fontSize: 12.0,
            color: Colors.white,
          ),
        ),
        Text(
          coord,
          style: const TextStyle(
            fontSize: 12.0,
            color: Colors.white54,
          ),
        ),

      ]
  );

  void _onTileClicked(String coord, String title){
    var list = coord.split("/");
    global.target = LatLng( double.parse(list[0]), double.parse(list[1]));
    MyApp.mainPageState.currentState!.tabController.animateTo(1);

  }

}


