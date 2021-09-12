import 'package:flutter/material.dart';
import 'package:forma_green/utils/Database.dart';
import 'package:forma_green/widget/item_list.dart';

class HomePage extends StatefulWidget{
  @override
  _HomePageState createState() => _HomePageState();
}

const showGrid = true; // Set to false to show ListView


class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) =>
      Scaffold(
          body: Center(child: ItemList(),),
          /*body: Center(child: _buildGrid() ),*/
      );

  // #docregion grid

}



