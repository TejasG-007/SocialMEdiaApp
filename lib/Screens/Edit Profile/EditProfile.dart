import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double small = 700;
    double medium = 700;
    double large = 1399;
    return Scaffold(
        key: _scaffoldkey,
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(0.0),
                    margin: const EdgeInsets.all(0.0),
                    height: height / 4,
                    width: width,
                    child:  StreamBuilder(
                      stream: FirebaseFirestore.instance.collection("users").doc("${FirebaseAuth.instance.currentUser.email}").collection("UserDetails").snapshots(),
                      builder:(context,snap){
                        if(!snap.hasData){
                          return Container();
                        }else{
                          String fullname=snap.data.docs[0]["full_name"];
                          String profileimg_url = snap.data.docs[0]["profile_img_url"];

                          return Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Stack(children: [
                                  CircleAvatar(
                                      backgroundColor: Colors.teal,
                                      radius: 60,
                                      child:profileimg_url!=null?Container(
                                          height: kIsWeb?120:120,
                                          width:120,
                                          decoration: BoxDecoration(color:Colors.teal,borderRadius: BorderRadius.circular(100),image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image:Image.network(profileimg_url,fit: BoxFit.fill,).image))):Icon(Icons.person_pin,size: 60,)),
                                  Container(
                                      margin: EdgeInsets.only(left: 80, top: 70),
                                      child: FloatingActionButton(
                                        heroTag: "Floating1",
                                        onPressed: () {

                                        },
                                        child: Icon(
                                          Icons.camera_alt,
                                        ),
                                      ))
                                ]),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  fullname,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline2
                                      .copyWith(color: Colors.white, fontSize: 20),
                                )
                              ],
                            ),
                            height: height / 4,
                            width: width,
                            decoration: BoxDecoration(
                              color: Colors.teal,
                              borderRadius:
                              BorderRadius.only(bottomRight: Radius.circular(80)),
                            ),
                          );
                        }
                      },
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(0.0),
                    margin: const EdgeInsets.all(0.0),
                    height: height * 3 / 4,
                    width: width,
                    color: Colors.teal,
                    child:  Container(
                      child: Scrollbar(
                        child: ListView(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            // Row(
                            //   children: [
                            //     SizedBox(
                            //       width: 20,
                            //     ),
                            //     FaIcon(
                            //       FontAwesomeIcons.firstOrder,
                            //       color: Colors.pink,
                            //     ),
                            //     SizedBox(
                            //       width: 20,
                            //     ),
                            //     Text(
                            //       "Show Profile",
                            //       style: Theme.of(context)
                            //           .textTheme
                            //           .bodyText2
                            //           .copyWith(
                            //           fontWeight: FontWeight.w900,
                            //           fontSize: 20),
                            //     ),
                            //   ],
                            // ),

                            SizedBox(
                              height: 30,
                            ),
                            StreamBuilder(
                              stream: FirebaseFirestore.instance.collection("users").doc("${FirebaseAuth.instance.currentUser.email}").collection("UserDetails").snapshots(),
                              builder: (context, snap) {
                                if(!snap.hasData){
                                  return Container();
                                }else{
                                  String username = snap.data.docs[0]["username"];
                                  String dob=snap.data.docs[0]["DOB"];
                                  String gender=snap.data.docs[0]["gender"];
                                  String fullname=snap.data.docs[0]["full_name"];
                                  return Column(
                                    children: [
                                      ListTile(
                                    title: Text("username"),
                                subtitle: Text(username),
                                        leading: Icon(Icons.verified_user,color: Colors.green,),
                                      ),ListTile(
                                    title: Text("full name"),
                                subtitle: Text(fullname),
                                        leading: Icon(Icons.drive_file_rename_outline,color: Colors.green,),
                                      ),ListTile(
                                    title: Text("Date of Birth"),
                                subtitle: Text(dob),
                                        leading: Icon(Icons.calendar_today_outlined,color: Colors.green,),
                                      ),ListTile(
                                    title: Text("gender"),
                                subtitle: Text(gender),
                                        leading: gender=="Male"?Icon(Icons.male,color: Colors.green,):Icon(Icons.female,color: Colors.pink,),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                        Icon(Icons.email,color: Colors.redAccent,),
                                        Container(
                                          padding:EdgeInsets.all(5),
                                          child:Text("To Make Any Required Modifications in Profile info Please Mail Us on admin@tejasg.me",style: Theme.of(context).textTheme.headline2.copyWith(color: Colors.red,fontSize: 14),),
                                          constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context).size.width*0.7
                                          ),
                                        )
                                      ],),
                                    ],
                                  );
                                }
                              }
                            )
                          ],
                        ),
                      ),
                      height: height * 3 / 4,
                      width: width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(80)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
  }
}

//
// Form(
// child: Column(
// children: [
// Padding(
// padding: EdgeInsets.only(
// left: 60, right: 60, top: 0, bottom: 10),
// child: TextFormField(
// readOnly: true,
// validator: (inp) {
// if (inp.isEmpty) {
// return "First Name should not be Empty";
// }
// return null;
// },
// cursorColor: Colors.purple,
// autovalidateMode:
// AutovalidateMode.onUserInteraction,
// cursorHeight: 25,
// decoration: InputDecoration(
// prefixIcon: Icon(Icons.person_pin),
// labelText: "username",
// hintText: username,
// border: OutlineInputBorder(
// borderRadius:
// BorderRadius.circular(10),
// borderSide:
// BorderSide(color: Colors.purple)),
// disabledBorder: OutlineInputBorder(
// borderSide:
// BorderSide(color: Colors.purple)),
// enabledBorder: OutlineInputBorder(
// borderSide: BorderSide(
// color: Colors.black, width: 2),
// borderRadius:
// BorderRadius.circular(10))),
// ),
// ),
// SizedBox(
// height: 20,
// ),
// Padding(
// padding:EdgeInsets.only(
// left: 60, right: 60, top: 0, bottom: 10),
// child: TextFormField(
// readOnly: true,
// validator: (inp) {
// if (inp.isEmpty) {
// return "Last Name should not be Empty";
// }
// return null;
// },
// cursorColor: Colors.purple,
// autovalidateMode:
// AutovalidateMode.onUserInteraction,
// cursorHeight: 25,
// decoration: InputDecoration(
// prefixIcon: Icon(Icons.person_pin),
// labelText: "full name",
// hintText: fullname,
// border: OutlineInputBorder(
// borderRadius:
// BorderRadius.circular(10),
// borderSide:
// BorderSide(color: Colors.purple)),
// disabledBorder: OutlineInputBorder(
// borderSide:
// BorderSide(color: Colors.purple)),
// enabledBorder: OutlineInputBorder(
// borderSide: BorderSide(
// color: Colors.black, width: 2),
// borderRadius:
// BorderRadius.circular(10))),
// ),
// ),
// SizedBox(
// height: 20,
// ),
// Padding(
// padding: EdgeInsets.only(
// left: 60, right: 60, top: 0, bottom: 10),
// child: TextFormField(
// readOnly: true,
//
// validator: (inp) {
// if (inp.isEmpty) {
// return "DOB Should not be Empty";
// } else if (inp.length > 10) {
// return "Please Enter Valid Date";
// }
// return null;
// },
// cursorColor: Colors.purple,
// keyboardType: TextInputType.datetime,
// cursorHeight: 25,
// autovalidateMode:
// AutovalidateMode.onUserInteraction,
// decoration: InputDecoration(
// hintText: dob,
// prefixIcon: Icon(Icons.date_range),
// labelText: "Date of Birth",
// border: OutlineInputBorder(
// borderRadius:
// BorderRadius.circular(10),
// borderSide: BorderSide(
// color: Colors.purple)),
// disabledBorder: OutlineInputBorder(
// borderSide: BorderSide(
// color: Colors.purple)),
// enabledBorder: OutlineInputBorder(
// borderSide: BorderSide(
// color: Colors.black, width: 2),
// borderRadius:
// BorderRadius.circular(10))),
// )),
//
// // Padding(
// //   padding: EdgeInsets.only(
// //       left: 60, right: 60, top: 10, bottom: 10),
// //   child: GettingStarted()
// //       .createState()
// //       .genderSelector(),
// // ),
// SizedBox(
// height: 20,
// ),
// Padding(
// padding:EdgeInsets.only(
// left: 60, right: 60, top: 0, bottom: 10),
// child: TextFormField(
// readOnly: true,
// validator: (inp) {
// if (inp.isEmpty) {
// return "Last Name should not be Empty";
// }
// return null;
// },
// cursorColor: Colors.purple,
// autovalidateMode:
// AutovalidateMode.onUserInteraction,
// cursorHeight: 25,
// decoration: InputDecoration(
// prefixIcon: Icon(Icons.person_pin),
// labelText: "Gender",
// hintText: gender,
// border: OutlineInputBorder(
// borderRadius:
// BorderRadius.circular(10),
// borderSide:
// BorderSide(color: Colors.purple)),
// disabledBorder: OutlineInputBorder(
// borderSide:
// BorderSide(color: Colors.purple)),
// enabledBorder: OutlineInputBorder(
// borderSide: BorderSide(
// color: Colors.black, width: 2),
// borderRadius:
// BorderRadius.circular(10))),
// ),
// ),
// SizedBox(
// height: 20,
// ),
// Row(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// FloatingActionButton(
// heroTag: "Floating2",
// backgroundColor: Colors.teal,
// onPressed: () {},
// child: Icon(Icons.done),
// )
// ],
// )
// ],
// ))