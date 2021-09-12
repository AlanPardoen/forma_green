import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forma_green/page/LoginPage.dart';
import 'AccountPage.dart';
import 'HomePage.dart';
import 'MapPage.dart';
import 'package:tuple/tuple.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'PartnersPage.dart';



class MainPage extends StatefulWidget{
  const MainPage({required Key key}) : super(key: key);
  @override
  MainPageState createState() => MainPageState();
}


class MainPageState extends State<MainPage> with SingleTickerProviderStateMixin{

  final List<Tuple3> pages = [
    Tuple3('Home', HomePage(), Icons.home),
    Tuple3('Map', MapPage(), Icons.map),
    Tuple3('Account', AccountPage(), Icons.people),
    Tuple3('Partners', PartnersPage(), Icons.shopping_cart)

  ];

  late TabController tabController;

  @override
  void initState(){
    super.initState();
    tabController = TabController(length: pages.length, vsync: this);
    tabController.addListener(()=> setState(() { }));
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }


  void logout() async {
    await GoogleSignIn().disconnect();
    FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) {
        return LoginPage();
      }),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
              title: Text(pages[tabController.index].item1),
              centerTitle: true,
              actions: [
                IconButton(onPressed:  () {this.logout();}, icon:  FaIcon(FontAwesomeIcons.powerOff))
              ],
              bottom: TabBar(
                controller: tabController,
                tabs: pages.map<Tab>((Tuple3 page) => Tab(text: page.item1, icon: Icon(page.item3),)).toList()
              )
            ),
          body: TabBarView(
            controller: tabController,
            physics: NeverScrollableScrollPhysics(),
            children: pages.map<Widget>((Tuple3 page) => page.item2).toList(),
          ),
        );
}