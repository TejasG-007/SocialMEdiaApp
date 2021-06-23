import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:photo_view/photo_view.dart';
import 'package:socialmedia/Widgets/PageBuilderTransition.dart';

class Friends extends StatefulWidget {
  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  ScrollController commentscroll = ScrollController();
 final _formkey = GlobalKey<FormState>();
  TextEditingController comment = TextEditingController();
  var doc;
  String username, profileimg_url;
  getdata() async {
    doc = await FirebaseFirestore.instance
        .collection("users")
        .doc("${FirebaseAuth.instance.currentUser.email}")
        .collection("UserDetails")
        .doc("user_detail")
        .get();
    username = doc["username"];
    profileimg_url = doc["profile_img_url"];
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
              Row(mainAxisAlignment:MainAxisAlignment.center,children: [Icon(Icons.report_problem_outlined,color: Colors.white,),SizedBox(width: 10,),Text("Alerts",style: Theme.of(context).textTheme.headline2.copyWith(color: Colors.white,fontSize: 18),)],),
                Expanded(
                  child: Container(
                  height: height,
                  width: width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(30))),
                  child:StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("Alert").snapshots(),
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
                        return ListView.separated(itemBuilder: (context,index)=>Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            radius: 35,
                                            child: data[index]
                                            ["profile_img"] !=
                                                null
                                                ? Container(
                                                height: kIsWeb ? 70 : 64,
                                                width: 70,
                                                decoration: BoxDecoration(
                                                    color: Colors.teal,
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                        100),
                                                    image:
                                                    DecorationImage(
                                                        fit: BoxFit
                                                            .fill,
                                                        image: Image
                                                            .network(
                                                          "${data[index]["profile_img"]}",
                                                          fit: BoxFit
                                                              .fill,
                                                        ).image)))
                                                : Icon(Icons.person_pin)))),
                                Expanded(
                                    flex: 4,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${data[index]["username"]}",
                                              style: Theme.of(context).textTheme.headline2.copyWith(fontSize: 14),
                                            ),
                                            Text(
                                              "${DateTime.fromMicrosecondsSinceEpoch(data[index]["timestamp"], isUtc: false).toString().substring(0, 16)}",
                                              style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 10),
                                            )
                                          ],
                                        ),
                                        data[index]["email"]==FirebaseAuth.instance.currentUser.email?PopupMenuButton(itemBuilder: (context)=>[
                                          PopupMenuItem(

                                              child: GestureDetector(
                                                  onTap:()async{
                                                    return showDialog(context: context, builder:(context){
                                                      return AlertDialog(
                                                        content: Text("Do you really want to delete this Alert ?"),
                                                        actions: [
                                                          TextButton(onPressed: ()async{
                                                            await FirebaseFirestore.instance.collection("Alert").doc(data[index].reference.id).delete().then((value) {
                                                              Navigator.pop(
                                                                  context);
                                                              showDialog(
                                                                  context: context,
                                                                  builder: (
                                                                      context) =>

                                                                      AlertDialog(
                                                                        content: Column(
                                                                          mainAxisSize: MainAxisSize.min,
                                                                          children: [
                                                                            Icon(
                                                                              Icons
                                                                                  .done,
                                                                              color: Colors
                                                                                  .green,
                                                                              size: height /
                                                                                  8,),
                                                                            SizedBox(
                                                                              height: 5,),
                                                                            Text(
                                                                                "Succesfully Deleted")
                                                                          ],),
                                                                        actions: [
                                                                          TextButton(
                                                                              onPressed: () {
                                                                                Navigator
                                                                                    .pop(
                                                                                    context);
                                                                              },
                                                                              child: Text(
                                                                                  "Close"))
                                                                        ],
                                                                      )
                                                              );
                                                            });
                                                          }, child:Text("Yes")),
                                                          TextButton(onPressed: (){
                                                            Navigator.pop(context);
                                                          }, child:Text("No")),
                                                        ],
                                                      );
                                                    });
                                                  },
                                                  child: Container(child: Row(children: [Icon(Icons.delete),SizedBox(width: 10,),Text("Delete Alert")],),)))
                                        ]):Container(),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "${data[index]["text"]}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .copyWith(
                                                fontSize: 14,
                                                color: Colors.black),
                                          ),
                                        ),
                                        data[index]["image_url"]!=null?Padding(
                                            padding:
                                            const EdgeInsets.all(8.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                _showImage(data, index);
                                              },
                                              child: Container(
                                                height: kIsWeb ? 400 : 200,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                    50,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        15),
                                                    color: Colors.white,
                                                    image: DecorationImage(
                                                      fit: BoxFit.fill,
                                                      image: data[index][
                                                      "image_url"] !=
                                                          null
                                                          ? Image.network(
                                                          "${data[index]["image_url"]}")
                                                          .image
                                                          : Container(),
                                                    )),
                                              ),
                                            )):Container(),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding:
                                              const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Text("${data[index]["likes"].length} ",style: Theme.of(context).textTheme.headline2.copyWith(fontSize: 16),),
                                                  SizedBox(width: 2,),
                                                  GestureDetector(
                                                      onTap: () async{
                                                        if(data[index]["likes"].contains("${FirebaseAuth.instance.currentUser.email}")){
                                                          await FirebaseFirestore.instance.collection("Alert").doc(data[index].reference.id).update(
                                                              {
                                                                "likes":FieldValue.arrayRemove([
                                                                  FirebaseAuth.instance.currentUser.email
                                                                ])
                                                              }
                                                          );
                                                          await Future.delayed(Duration(milliseconds: 300));
                                                        }else{
                                                          await FirebaseFirestore.instance.collection("Alert").doc(data[index].reference.id).update(
                                                              {
                                                                "likes":FieldValue.arrayUnion([
                                                                  FirebaseAuth.instance.currentUser.email
                                                                ])
                                                              }
                                                          );
                                                          await Future.delayed(Duration(milliseconds: 300));

                                                        }
                                                      },
                                                      child: data[index]["likes"].contains("${FirebaseAuth.instance.currentUser.email}")?Icon(
                                                          FontAwesomeIcons
                                                              .solidThumbsUp,
                                                          size: 20,
                                                          color: Colors.red):Icon(
                                                          FontAwesomeIcons.thumbsUp,
                                                          size: 20,
                                                          color: Colors.red)),

                                                ],
                                              ),
                                            ),
                                            GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      SlideRightRoute(
                                                          widget: Scaffold(
                                                            appBar: AppBar(
                                                              title: Text(
                                                                  "Comments"),
                                                              elevation: 0,
                                                              backgroundColor:
                                                              Colors.cyan,
                                                            ),
                                                            bottomSheet: Row(
                                                              children: [
                                                                Expanded(
                                                                  flex: 5,
                                                                  child: Padding(
                                                                    padding: EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                        4,
                                                                        vertical:
                                                                        0),
                                                                    child:
                                                                    Container(
                                                                      padding:
                                                                      EdgeInsets
                                                                          .all(5),
                                                                      decoration: BoxDecoration(
                                                                          borderRadius:
                                                                          BorderRadius.circular(50)),
                                                                      child: Form(
                                                                        key:
                                                                        _formkey,
                                                                        child:
                                                                        TextFormField(
                                                                          validator:
                                                                              (inp) {
                                                                            if (inp
                                                                                .isEmpty) {
                                                                              return "Please Type Comment";
                                                                            }
                                                                            return null;
                                                                          },
                                                                          controller:
                                                                          comment,
                                                                          cursorHeight:
                                                                          30,
                                                                          cursorWidth:
                                                                          2,
                                                                          cursorColor:
                                                                          Colors.teal,
                                                                          autovalidateMode:
                                                                          AutovalidateMode.onUserInteraction,
                                                                          decoration: InputDecoration(
                                                                              border:
                                                                              OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.black12)),
                                                                              disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
                                                                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.teal, width: 2), borderRadius: BorderRadius.circular(10))),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 1,
                                                                  child:
                                                                  FloatingActionButton(
                                                                    onPressed:
                                                                        () async {
                                                                      if (_formkey
                                                                          .currentState
                                                                          .validate()) {
                                                                        await FirebaseFirestore.instance.collection("Alert").doc("${data[index].reference.id}").update({
                                                                          "comments":FieldValue.arrayUnion([
                                                                            {
                                                                              "profile_img_url":profileimg_url,
                                                                              "text":comment.text,
                                                                              "username":username,
                                                                              "timestamp":DateTime.now().microsecondsSinceEpoch,
                                                                            }
                                                                          ])
                                                                        });
                                                                        comment.clear();
                                                                        commentscroll.animateTo(commentscroll.position.maxScrollExtent, duration: Duration(milliseconds: 300), curve: Curves.easeOut);


                                                                        await Future.delayed(Duration(
                                                                            milliseconds:
                                                                            200));
                                                                      }
                                                                    },
                                                                    backgroundColor:
                                                                    Colors
                                                                        .teal,
                                                                    child: Icon(
                                                                        Icons
                                                                            .send),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            body: Container(
                                                              child: StreamBuilder(
                                                                stream: FirebaseFirestore.instance.collection("Alert").doc("${data[index].reference.id}").snapshots(),
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

                                                                  }else if(snap.data["comments"].length<=0){
                                                                    return Center(
                                                                      child: Text("No Comments"),
                                                                    );
                                                                  }

                                                                  else{
                                                                    print(snap.data["comments"].length);
                                                                    var data = snap.data["comments"];
                                                                    return ListView.separated(
                                                                        controller: commentscroll,
                                                                        shrinkWrap: true,
                                                                        itemBuilder: (context,index)=>Container(
                                                                          margin: EdgeInsets.all(5),
                                                                          child: Column(
                                                                            children: [
                                                                              Row(

                                                                                children: [
                                                                                  CircleAvatar(
                                                                                      backgroundColor: Colors.white,
                                                                                      radius: 20,
                                                                                      child:data[index]["profile_img_url"]!=null?Container(
                                                                                          height: kIsWeb?70:64,
                                                                                          width:70,
                                                                                          decoration: BoxDecoration(color:Colors.teal,borderRadius: BorderRadius.circular(100),image: DecorationImage(
                                                                                              fit: BoxFit.fill,
                                                                                              image:Image.network("${data[index]["profile_img_url"]}",fit: BoxFit.fill,).image))):Icon(Icons.person_pin)),
                                                                                  SizedBox(width: 20,height: 30,),
                                                                                  Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Text("${data[index]["username"]}",style: Theme.of(context).textTheme.headline2.copyWith(fontSize: 14),),
                                                                                      Text("${DateTime.fromMicrosecondsSinceEpoch(data[index]["timestamp"],isUtc: false).toString().substring(0,16)}",style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 10),)
                                                                                    ],
                                                                                  )
                                                                                ],
                                                                              ),
                                                                              Container(
                                                                                alignment: Alignment.topCenter,
                                                                                child: Text("${data[index]["text"]}",style:Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 16),),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ), separatorBuilder: (context, index) => Divider(
                                                                      thickness: 1,
                                                                    ), itemCount: snap.data["comments"].length);
                                                                  }
                                                                },
                                                              ),
                                                            ),
                                                          )));
                                                },
                                                child: Icon(
                                                  FontAwesomeIcons.commentAlt,
                                                  size: 20,
                                                  color: Colors.cyan,
                                                )),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            FirebaseAuth.instance.currentUser.email.substring(0,2)=="s1" || FirebaseAuth.instance.currentUser.email.substring(0,2)=="s2"?Container():GestureDetector(
                                              child: Row(children: [
                                                Icon(Icons.remove_red_eye,color: Colors.green,),SizedBox(width: 4,),Text("Watch list"),
                                              ],),
                                              onTap: (){
                                                Navigator.push(context,MaterialPageRoute(builder:(context)=>Scaffold(
                                                  body: ListView.builder(itemBuilder: (context,ind)=>StreamBuilder(
                                                    stream: FirebaseFirestore.instance.collection("users").doc("${data[index]["likes"][ind]}").snapshots(),
                                                    builder:(context,snap)=>!snap.hasData?Center(
                                                        child:Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Lottie.asset("assets/Lottie/Gloading.json",height: height/10),
                                                            // Text("Loading...",style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: height/30,color: Colors.purple),)
                                                          ],
                                                        )
                                                    ): ListTile(isThreeLine: true,subtitle: Text("${snap.data["username"]}"),
                                                      leading:CircleAvatar(backgroundImage: AssetImage("assets/Images/profilepic.jpg"),),
                                                      title: Text("${snap.data["full_name"]}"),),
                                                  ),itemCount: data[index]["likes"].length,),
                                                ) ));
                                              },
                                            ),

                                            SizedBox(width: 20,)
                                          ],
                                        )
                                      ],
                                    )),
                              ],
                            )),separatorBuilder: (context, index) => Divider(
                          thickness: 1,
                        ), itemCount: snap.data.docs.length);
                      }

                    },
                  )
                  ),
                ),
            ],)
    ),
        ));
  }
  _showImage(var data, int index) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Center(
              child: PhotoView(
                imageProvider: data[index]["image_url"] != null
                    ? Image.network("${data[index]["image_url"]}").image
                    : Container(),
              )),
        ),
      ),
    );
  }
}

