import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:socialmedia/FirbaseServices/Authentication/Authentication.dart';
import 'package:socialmedia/Login%20and%20Register/LoginView.dart';
import 'package:socialmedia/Screens/Edit%20Profile/EditProfile.dart';
import 'package:socialmedia/Screens/Friends/Friends.dart';
import 'package:socialmedia/Screens/MessageScreen/Message.dart';
import 'package:socialmedia/Screens/Notifications/Notifications.dart';
import 'package:socialmedia/Widgets/PageBuilderTransition.dart';

import '../../locator.dart';



List<Map> drawerItems = [
  {
    'icon': FontAwesomeIcons.edit,
    'title': "Edit Profile",
  },
  {'icon': Icons.report_problem_outlined, 'title': 'Alert'},
  {'icon': FontAwesomeIcons.bell, 'title': 'Notifications'},
  {'icon': Icons.mail, 'title': 'Messages'},
];

class DrawerScreen extends StatefulWidget {


  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> with TickerProviderStateMixin {

  final Auth = locator<Authentication>();
  // String username,profileimg_url;
  // getdata()async{
  //   var doc = await FirebaseFirestore.instance.collection("users").doc("${FirebaseAuth.instance.currentUser.email}").collection("UserDetails").doc("user_detail").get();
  //   username = doc["username"];
  //   profileimg_url = doc["profile_img_url"];
  //
  // }

  // @override
  // void initState() {
  //   getdata();
  //   super.initState();
  // }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      color: Color(0xff416d6d),
      padding: EdgeInsets.only(top: 50, bottom: 70, left: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: (){
                width>600?showModalBottomSheet(
                  transitionAnimationController: AnimationController(vsync:this,duration: Duration(milliseconds: 800)),
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,context:context, builder:(context)=>Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25)
                  ),
                  height: MediaQuery.of(context).size.height/1.5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(child: EditProfile()),
                      Flexible(child: Friends()),
                      Flexible(child: Notifications()),
                    ],
                  ),
                )):Container();
              },
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser.email).collection("UserDetails").doc("user_detail").snapshots(),
                builder: (context,snap){
                  if(!snap.hasData){
                    return LinearProgressIndicator();
                  }else{
                    var data = snap.data;
                    String profileimg_url = data["profile_img_url"];
                    String username = data["username"];
                    return  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                            radius: 35, backgroundColor: Colors.teal,
                            child:profileimg_url!=null?Container(
                                height: kIsWeb?70:68,
                                width:70,
                                decoration: BoxDecoration(color:Colors.teal,borderRadius: BorderRadius.circular(100),image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image:Image.network("${profileimg_url}",fit: BoxFit.fill,).image))):Icon(Icons.person_pin)),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${username??"fetching..."}",
                              style: TextStyle(
                                  color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Row(
                              children: [
                                Text('Active Status',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  width: 5,
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.green,
                                  radius: 4,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
          Column(
            children: drawerItems
                .map((element) => width>600?Container():Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  switch (element['title']) {
                                    case "Messages":
                                      Navigator.push(
                                          context,
                                          SlideRightRoute(
                                              widget: MessageScreen()));
                                      break;
                                    case "Notifications":
                                      Navigator.push(
                                          context,
                                          SlideRightRoute(
                                              widget: Notifications()));
                                      break;
                                    case "Edit Profile":
                                      Navigator.push(
                                          context,
                                          SlideRightRoute(
                                              widget: EditProfile()));
                                      break;
                                    case "Alert":
                                      Navigator.push(
                                          context,
                                          SlideRightRoute(
                                              widget: Friends()));
                                      break;

                                  }
                                });
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    element['icon'],
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 60,
                                  ),
                                  Text(element['title'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                              fontSize: 15,
                                              color: Colors.white))
                                ],
                              ),
                            ),
                    ))
                .toList(),
          ),
          Row(
            children: [
              Icon(
                Icons.settings,
                color: Colors.white,
              ),
              SizedBox(
                width: 10,
              ),
              width > 700
                  ? MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                          onTap: () {},
                          child: Text(
                            'Settings',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                          )))
                  : Text(
                      'Settings',
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
              SizedBox(
                width: 10,
              ),
              Container(
                width: 2,
                height: 20,
                color: Colors.white,
              ),
              SizedBox(
                width: 10,
              ),
              width > 700
                  ? MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          Auth.signout();
                          Navigator.pushReplacement(context,SlideRightRoute(widget: LoginView()));
                        },
                        child: Text(
                          'Log out',
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ))
                  : GestureDetector(
                   onTap: (){
                     Auth.signout();
                     Navigator.pushReplacement(context,SlideRightRoute(widget: LoginView()));
                   },
                    child: Text(
                        'Log out',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                  )
            ],
          )
        ],
      ),
    );
  }
}
