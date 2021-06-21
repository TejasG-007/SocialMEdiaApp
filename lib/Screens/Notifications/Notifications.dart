import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:socialmedia/Screens/Friends/Friends.dart';
import 'package:socialmedia/Widgets/PageBuilderTransition.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        key: _scaffoldkey,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
              alignment: Alignment.bottomCenter,
              height: height,
              width: width,
              color: Colors.teal,
              child:Column(children: [
                Row(mainAxisAlignment:MainAxisAlignment.center,children: [FaIcon(FontAwesomeIcons.bell,color: Colors.white,),SizedBox(width: 10,),Text("Notifications",style: Theme.of(context).textTheme.headline2.copyWith(color: Colors.white,fontSize: 18),)],),
                Expanded(
                  child: Container(
                      width: width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.only(topRight: Radius.circular(30))),
                      child:
                      Scrollbar(child:
                      StreamBuilder(
                        stream: FirebaseFirestore.instance.collection("Notifications").snapshots(),
                        builder: (context,snap){
                          if(!snap.hasData){
                            return Center(
                                child:Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Lottie.asset("assets/Lottie/Gloading.json",height: height/10),
                                    // Text("Loading...",style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: height/30,color: Colors.purple),)
                                  ],
                                )
                            );
                          }else{
                            var data = snap.data.docs;
                            return ListView.builder(itemBuilder:(context,index)=>ListTile(
                              onTap: (){
                                Navigator.push(context,SlideRightRoute(widget: Friends()));
                              },
                              isThreeLine: true,subtitle: Text("${data[index]["email"]}"),
                              leading:Icon(Icons.report_problem_outlined,color: Colors.red,),
                              title: Text("${data[index]["Notification"]}"),),itemCount: data.length,);
                          }
                        },
                      )
                      )
                  ),
                ),
              ],)
          ),
        ));}}