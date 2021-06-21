import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:socialmedia/Screens/Drawer/MainS.dart';
import 'package:socialmedia/Screens/GettingStarted/GettingStarted.dart';
import 'package:socialmedia/Screens/MessageScreen/Message.dart';
import 'package:socialmedia/Screens/MessageScreen/MessageSwitcher.dart';
import 'package:socialmedia/Widgets/Loading.dart';


class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {


  @override
  Widget build(BuildContext context) {
    //Responsive Sizes for Devices
    double small = 700;
    double medium = 700;
    double large = 1399;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ///Here MainLayer goes for Mobile View and Other Written Code for the Desktop/Tablet View
    return StreamBuilder(
      ///TODO:Starting from here
        stream: FirebaseFirestore.instance.collection("users").doc("${FirebaseAuth.instance.currentUser.email}").snapshots(),

        builder:(context,snapshot)

        {

      if(!snapshot.hasData){
        return LoadingView();
      }
      else{
        var data = snapshot.data["getting_started"];
        return data?width < small
            ? DrawerSwitcher()
            : Scaffold(
            body: ListView(children: [
              Row(

                  children: [
                    // Expanded(
                    //   flex: 2,
                    //   child: Container(
                    //     child: UserProfile(),
                    //     height: height,
                    //     color: Colors.transparent,
                    //   ),
                    // ),
                    Expanded(
                        flex: 6,
                        child: Container(
                            margin: const EdgeInsets.all(0),
                            child:DrawerSwitcher(),//FeedandPost(),
                            height: height,
                            color: Colors.transparent)),
                    Expanded(
                        flex: 3,
                        child: Container(
                            margin: EdgeInsets.all(0),
                            child:width>small?MessageSwitcher():MessageScreen(),
                            height: height,
                            color: Colors.transparent)),
                  ]),
            ])):GettingStarted();
      }

    } );
  }
}
