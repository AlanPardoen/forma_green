import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tuple/tuple.dart';
import 'package:url_launcher/url_launcher.dart';

class PartnersPage extends StatefulWidget{
  @override
  _PartnersPageState createState() => _PartnersPageState();
}


class _PartnersPageState extends State<PartnersPage> {

  final List<Tuple3> partners = [
    Tuple3(getRandString(6), "https://www.vnconline.com/upload/tinymce/amazon.png","https://www.amazon.fr/"),
    Tuple3(getRandString(6), "https://www.d-tt.nl/assets/images/blog/welkom-famiflora.png","https://www.famiflora.be/fr-be"),
    Tuple3(getRandString(6), "https://www.lsa-conso.fr/mediatheque/6/9/6/000144696_2_mobile.jpg","https://www.jardiland.com/"),
    Tuple3(getRandString(6), "https://www.lsa-conso.fr/mediatheque/4/7/7/000144774_2_mobile.jpg", "https://www.leroymerlin.fr/")
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center (
          child:GridView.count(
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        crossAxisCount: 2,
        // Generate 100 widgets that display their index in the List.
        children: List.generate(4, (index) {
          return Column(
              children: <Widget>[
                Expanded(
                  child: new InkResponse( child:Image.network(partners[index].item2),onTap: () => _onLinkNavigation(partners[index].item3)),
                ),
                Row(
                  children: <Widget>[
                    Text('Promo:'),
                    ElevatedButton.icon(style: ElevatedButton.styleFrom( primary: Colors.transparent, onPrimary: Colors.black, shadowColor: Colors.transparent),icon: Icon(Icons.content_copy),
                        label: Text(partners[index].item1), onPressed: () async {_onCopyText(partners[index].item1);})
                  ]
                )
              ]
          );
        }),
      )
      )
    );
  }

  void _onLinkNavigation(String url) async{
    print(url);
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
    }

  void _onCopyText(String promocode) async{
    Clipboard.setData(ClipboardData(text: promocode));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Copied!")));
  }

}
String getRandString(int len) {
  var random = Random.secure();
  var values = List<int>.generate(len, (i) =>  random.nextInt(255));
  return base64UrlEncode(values);
}
