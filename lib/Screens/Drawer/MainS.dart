import 'package:flutter/material.dart';
import 'DrawerScreen.dart';
import 'FeedPage.dart';

class DrawerSwitcher extends StatefulWidget {
  @override
  _DrawerSwitcherState createState() => _DrawerSwitcherState();
}

class _DrawerSwitcherState extends State<DrawerSwitcher> {
  GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      key: _scaffoldkey,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          DrawerScreen(),
          FeedScreen(),


        ],
      ),
    );
  }
}


