import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:forma_green/utils/Global.dart' as global;
import 'package:rflutter_alert/rflutter_alert.dart';



class MapPage extends StatefulWidget{
  @override
  MapPageState createState() => MapPageState();
}


class MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = const LatLng(50.633333, 3.066667);
  final name = TextEditingController();
  final pictLink = TextEditingController();
  String positionLatLng = "";

  List<Marker> myMarkerList = [
    Marker(markerId: MarkerId("Lille"),
        position: _center,
        infoWindow: InfoWindow(title: "Lille", snippet: "50.633333, 3.066667"))
  ];

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Long Press = add place in data base")));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Map').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }
          snapshot.data!.docs.forEach((element) {
            var data = element.data() as Map<String,dynamic>;
            String coord = data["coord"];
            var list = coord.split("/");
            myMarkerList.add(
            Marker(markerId: MarkerId("Lille"),
                position: LatLng( double.parse(list[0]), double.parse(list[1])),
                infoWindow: InfoWindow(title: data["title"], snippet: data["coord"])
            )
            );
            print(list);
          });
          return GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: global.target,
              zoom: 15.0,
            ),
            onLongPress: _ShowFormsPopUp,
            markers: myMarkerList.toSet(),
          );

        }
    );

  }

  void _ShowFormsPopUp(LatLng position){
    positionLatLng = position.latitude.toString()+"/"+position.longitude.toString();
    Alert(
        context: context,
        title: "New Place",
        content: Column(
          children: <Widget>[
            TextField(
              controller: name,
              decoration: InputDecoration(
                icon: Icon(Icons.account_circle),
                labelText: 'Place Name',
              ),
            ),
            TextField(
              controller: pictLink,
              decoration: InputDecoration(
                icon: Icon(Icons.image),
                labelText: 'Picture link empty by default',
              ),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () async {LoadOnFireStore(context);},
            child: Text(
              "Validate",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  void  LoadOnFireStore(context) async{
    print("LoadOnFireStore");
    print(positionLatLng);
    print(pictLink.text);
    print(name.text);
    Navigator.pop(context);
    var test = await FirebaseFirestore.instance.collection('Map').doc(name.text).get();
    print(test);
    if (!test.exists) {
      try {
        await FirebaseFirestore.instance.collection('Map')
            .doc(name.text)
            .set({
          'coord': positionLatLng,
          'img': pictLink.text,
          'title': name.text,
        });
      } catch (ex) {
        print(ex);
        Alert(context: context,
            title: "Error",
            desc: "Une erreur est survenue",
            image: Image.network(
                "https://outpost24.com/sites/default/files/styles/hotspots/public/2019-04/red-cross.png?itok=EjZAnSVk"))
            .show();
      }
    }else {
      Alert(context: context, title: "Error name already exist", desc: "Ce name est déja présent dans la base de donnée ", image:Image.network("https://outpost24.com/sites/default/files/styles/hotspots/public/2019-04/red-cross.png?itok=EjZAnSVk")).show();
    }


  }

}