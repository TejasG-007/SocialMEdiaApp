import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:socialmedia/FirbaseServices/ImageSender/ImageSender.dart';
import 'package:socialmedia/Screens/Drawer/DraweModel.dart';
import 'package:socialmedia/Screens/Drawer/ImagePicker.dart';
import 'package:socialmedia/Screens/MessageScreen/Message.dart';
import 'package:socialmedia/Screens/QandA/QandA.dart';
import 'package:socialmedia/Widgets/BusyButton.dart';
import 'package:socialmedia/Widgets/BusyButtonModel.dart';
import 'package:socialmedia/Widgets/Loading.dart';
import 'package:socialmedia/Widgets/PageBuilderTransition.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  double small = 700;
  final _postkey = GlobalKey<FormState>();
  final _formkey = GlobalKey<FormState>();
  TextEditingController comment = TextEditingController();
  var doc;

  String username, profileimg_url, fullname;
  getdata() async {
    doc = await FirebaseFirestore.instance
        .collection("users")
        .doc("${FirebaseAuth.instance.currentUser.email}")
        .collection("UserDetails")
        .doc("user_detail")
        .get();
    username = doc["username"];
    profileimg_url = doc["profile_img_url"];
    fullname = doc["full_name"];
  }

  @override
  void initState() {
    getdata();
    super.initState();
  }

  ScrollController commentscroll = ScrollController();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onPanUpdate: (updateDetail) {
        //Swiping from left to right = MessageScreen Appear
        int sensitivity = 8;
        if (updateDetail.delta.dx > sensitivity) {
          width > 600
              ? Container()
              : Navigator.push(
                  context, SlideRightRoute(widget: MessageScreen()));
        }
      },
      onTap: () {
        Provider.of<DrawerModel>(context, listen: false)
            .onClickOpen(0, 0, 1, false);
      },
      child: Consumer<DrawerModel>(
        builder: (context, model, child) => AnimatedContainer(
          transform:
              Matrix4.translationValues(model.xOffSet_, model.yOffSet_, 0)
                ..scale(model.scaleFactor_)
                ..rotateY(width > 600
                    ? model.isDrawerOpen
                        ? -0.5
                        : 0
                    : 0),
          duration: Duration(milliseconds: 250),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(width < 700
                  ? model.isDrawerOpen
                      ? 20
                      : 0.0
                  : 0)),
          child: Container(
              margin: const EdgeInsets.only(bottom: 10, left: 0),
              child: Column(children: [
                Container(
                  margin: EdgeInsets.all(0),
                  padding: EdgeInsets.all(0),
                  child: Stack(children: [
                    ClipPath(
                        clipper: WaveClipperTwo(),
                        child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 60,
                                ),
                                FloatingActionButton(
                                  tooltip: "Questions and Answers",
                                  onPressed: (){
                                  Navigator.push(context,SlideRightRoute(widget:
                                  QandAView()
                                  ));
                                },
                                  backgroundColor: Colors.teal,
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.teal,
                                  backgroundImage: AssetImage("assets/Images/qa.png"),
                                ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                width > small
                                    ? Text("   Feed News",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline2
                                            .copyWith(
                                                color: Colors.white,
                                                fontSize: 24))
                                    : Container(),
                                SizedBox(
                                  width: 120,
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            height: model.isDrawerOpen
                                ? width < small
                                    ? 100
                                    : 109
                                : 100,
                            width: width,
                            decoration: BoxDecoration(
                                color: Colors.teal,
                                borderRadius: BorderRadius.circular(width < 700
                                    ? model.isDrawerOpen
                                        ? 20
                                        : 0.0
                                    : 0)))),
                    Column(
                      children: [
                        SizedBox(
                          height: 25,
                        ),
                        model.isDrawerOpen
                            ? IconButton(
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  model.onClickOpen(0, 0, 1, false);
                                },
                              )
                            : IconButton(
                                icon: Icon(
                                  Icons.menu,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  width < 600
                                      ? model.onClickOpen(
                                          230,
                                          150,
                                          0.6,
                                          true,
                                        )
                                      : model.onClickOpen(400, 0, 1, true);
                                }),
                      ],
                    ),
                  ]),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                        right: model.isDrawerOpen
                            ? width > 700
                                ? 30
                                : 0
                            : 0),
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("post")
                            .snapshots(),
                        builder: (context, snap) {
                          if (!snap.hasData) {
                            return ListView.separated(
                                separatorBuilder: (context, index) => Divider(
                                      thickness: 1,
                                    ),
                                itemCount: 10,
                                itemBuilder: (context, index) =>
                                    Shimmer.fromColors(
                                        child: Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 10),
                                            width: width - 40,
                                            child: Container(
                                              child: Column(
                                                children: [
                                                  ListTile(
                                                      leading: CircleAvatar(
                                                        radius: 35,
                                                      ),
                                                      title: Column(
                                                        children: [
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          Container(
                                                            height: 10,
                                                            color:
                                                                Colors.black12,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Container(
                                                            height: 10,
                                                            color:
                                                                Colors.black12,
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Container(
                                                            height: 10,
                                                            color:
                                                                Colors.black12,
                                                          ),
                                                        ],
                                                      )),
                                                  Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Container(
                                                        height: 10,
                                                        color: Colors.black12,
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Container(
                                                        height: 10,
                                                        color: Colors.black12,
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Container(
                                                        height: 10,
                                                        color: Colors.black12,
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Container(
                                                        height: 10,
                                                        color: Colors.black12,
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Container(
                                                        height: 10,
                                                        color: Colors.black12,
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )),
                                        baseColor: Colors.black12,
                                        highlightColor: Colors.white));
                          } else {
                            var data = snap.data.docs;
                            return ListView.separated(
                              separatorBuilder: (context, index) => Divider(
                                thickness: 1,
                              ),
                              physics: ScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: data.length,
                              itemBuilder: (context, index) => Container(
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
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                            content: Text("Do you really want to delete this post ?"),
                                                            actions: [
                                                              TextButton(onPressed: ()async{
                                                                await FirebaseFirestore.instance.collection("post").doc(data[index].reference.id).delete().then((value) {
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
                                                      child: Container(child: Row(children: [Icon(Icons.delete),SizedBox(width: 10,),Text("Delete Post")],),)))
                                            ]):Container(),
                                          ],),
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
                                          data[index]["image_url"] != null
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      _showImage(data, index);
                                                    },
                                                    child: Container(
                                                      height:
                                                          kIsWeb ? 400 : 200,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              50,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          color: Colors.white,
                                                          image:
                                                              DecorationImage(
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
                                                  ))
                                              : Container(),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "${data[index]["likes"].length} likes",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline2
                                                          .copyWith(
                                                              fontSize: 16),
                                                    ),
                                                    SizedBox(
                                                      width: 2,
                                                    ),
                                                    GestureDetector(
                                                        onTap: () async {
                                                          if (data[index]
                                                                  ["likes"]
                                                              .contains(
                                                                  "${FirebaseAuth.instance.currentUser.email}")) {
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "post")
                                                                .doc(data[index]
                                                                    .reference
                                                                    .id)
                                                                .update({
                                                              "likes": FieldValue
                                                                  .arrayRemove([
                                                                FirebaseAuth
                                                                    .instance
                                                                    .currentUser
                                                                    .email
                                                              ])
                                                            });
                                                            await Future.delayed(
                                                                Duration(
                                                                    milliseconds:
                                                                        300));
                                                          } else {
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "post")
                                                                .doc(data[index]
                                                                    .reference
                                                                    .id)
                                                                .update({
                                                              "likes": FieldValue
                                                                  .arrayUnion([
                                                                FirebaseAuth
                                                                    .instance
                                                                    .currentUser
                                                                    .email
                                                              ])
                                                            });
                                                            await Future.delayed(
                                                                Duration(
                                                                    milliseconds:
                                                                        300));
                                                          }
                                                        },
                                                        child: data[index]
                                                                    ["likes"]
                                                                .contains(
                                                                    "${FirebaseAuth.instance.currentUser.email}")
                                                            ? Icon(
                                                                FontAwesomeIcons
                                                                    .solidHeart,
                                                                size: 20,
                                                                color:
                                                                    Colors.red)
                                                            : Icon(
                                                                FontAwesomeIcons
                                                                    .heart,
                                                                size: 20,
                                                                color: Colors
                                                                    .red)),
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
                                                            actions: [
                                                              TextButton(onPressed:(){
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

                                                              }, child: Row(children: [Text("View Likes ${data[index]["likes"].length}",style: TextStyle(color: Colors.white),),Icon(
                                                                  FontAwesomeIcons
                                                                      .solidHeart,
                                                                  size: 20,
                                                                  color:
                                                                  Colors.red)],)),
                                                              SizedBox(width: 20,)
                                                            ],
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
                                                                      await FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              "post")
                                                                          .doc(
                                                                              "${data[index].reference.id}")
                                                                          .update({
                                                                        "comments":
                                                                            FieldValue.arrayUnion([
                                                                          {
                                                                            "profile_img_url":
                                                                                profileimg_url,
                                                                            "text":
                                                                                comment.text,
                                                                            "username":
                                                                                username,
                                                                            "timestamp":
                                                                                DateTime.now().microsecondsSinceEpoch,
                                                                          }
                                                                        ])
                                                                      });
                                                                      comment
                                                                          .clear();
                                                                      commentscroll.animateTo(
                                                                          commentscroll
                                                                              .position
                                                                              .maxScrollExtent,
                                                                          duration: Duration(
                                                                              milliseconds:
                                                                                  300),
                                                                          curve:
                                                                              Curves.easeOut);

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
                                                            child:
                                                                StreamBuilder(
                                                              stream: FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      "post")
                                                                  .doc(
                                                                      "${data[index].reference.id}")
                                                                  .snapshots(),
                                                              builder: (context,
                                                                  snap) {
                                                                if (!snap
                                                                    .hasData) {
                                                                  return Center(
                                                                      child:
                                                                          Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Lottie.asset(
                                                                          "assets/Lottie/Gloading.json",
                                                                          height:
                                                                              height / 10),
                                                                      // Text("Loading...",style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: height/30,color: Colors.purple),)
                                                                    ],
                                                                  ));
                                                                } else if (snap
                                                                        .data[
                                                                            "comments"]
                                                                        .length <=
                                                                    0) {
                                                                  return Center(
                                                                    child: Text(
                                                                        "No Comments"),
                                                                  );
                                                                } else {
                                                                  print(snap
                                                                      .data[
                                                                          "comments"]
                                                                      .length);
                                                                  var data = snap
                                                                          .data[
                                                                      "comments"];
                                                                  return ListView
                                                                      .separated(
                                                                          controller:
                                                                              commentscroll,
                                                                          shrinkWrap:
                                                                              true,
                                                                          itemBuilder: (context, index) =>
                                                                              Container(
                                                                                margin: EdgeInsets.all(5),
                                                                                child: Column(
                                                                                  children: [
                                                                                    Row(
                                                                                      children: [
                                                                                        CircleAvatar(
                                                                                            backgroundColor: Colors.white,
                                                                                            radius: 20,
                                                                                            child: data[index]["profile_img_url"] != null
                                                                                                ? Container(
                                                                                                    height: kIsWeb ? 70 : 64,
                                                                                                    width: 70,
                                                                                                    decoration: BoxDecoration(
                                                                                                        color: Colors.teal,
                                                                                                        borderRadius: BorderRadius.circular(100),
                                                                                                        image: DecorationImage(
                                                                                                            fit: BoxFit.fill,
                                                                                                            image: Image.network(
                                                                                                              "${data[index]["profile_img_url"]}",
                                                                                                              fit: BoxFit.fill,
                                                                                                            ).image)))
                                                                                                : Icon(Icons.person_pin)),
                                                                                        SizedBox(
                                                                                          width: 20,
                                                                                          height: 30,
                                                                                        ),
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
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                    Container(
                                                                                      alignment: Alignment.topCenter,
                                                                                      child: Text(
                                                                                        "${data[index]["text"]}",
                                                                                        style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 16),
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                          separatorBuilder: (context, index) =>
                                                                              Divider(
                                                                                thickness: 1,
                                                                              ),
                                                                          itemCount: snap
                                                                              .data["comments"]
                                                                              .length);
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
                                              // GestureDetector(
                                              //     onTap: () {},
                                              //     child: Icon(
                                              //         Icons.share_rounded,
                                              //         size: 25,
                                              //         color: Colors.cyan)),
                                              SizedBox(
                                                width: 5,
                                              )
                                            ],
                                          )
                                        ],
                                      )),
                                ],
                              )),
                            );
                          }
                        }),
                  ),
                ),
                FirebaseAuth.instance.currentUser.email.substring(0, 2) ==
                            "s1" ||
                        FirebaseAuth.instance.currentUser.email
                                .substring(0, 2) ==
                            "s2"
                    ? FloatingActionButton.extended(
                        heroTag: "sending_post",
                        icon: Icon(
                          Icons.add_a_photo,
                        ),
                        label: Text("Post Something"),
                        onPressed: () {
                          Provider.of<BusyButtonModel>(context, listen: false)
                              .setBusy = false;
                          Provider.of<GetImage>(context, listen: false).myfile =
                              null;
                          Navigator.push(
                              context,
                              SlideRightRoute(
                                  widget:
                                      CreatePost(username, profileimg_url)));
                        },
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FloatingActionButton.extended(
                            heroTag: "sending_post",
                            icon: Icon(
                              Icons.add_a_photo,
                            ),
                            label: Text("Post Something"),
                            onPressed: () {
                              Provider.of<BusyButtonModel>(context,
                                      listen: false)
                                  .setBusy = false;
                              Provider.of<GetImage>(context, listen: false)
                                  .myfile = null;
                              Navigator.push(
                                  context,
                                  SlideRightRoute(
                                      widget: CreatePost(
                                          username, profileimg_url)));
                            },
                          ),
                          FloatingActionButton.extended(
                            backgroundColor: Colors.teal,
                            heroTag: "alert-button",
                            icon: Icon(
                              Icons.report_problem_outlined,
                            ),
                            label: Text("Add Alert"),
                            onPressed: () {
                              Provider.of<BusyButtonModel>(context,
                                      listen: false)
                                  .setBusy = false;
                              Provider.of<GetImage>(context, listen: false)
                                  .myfile = null;
                              Navigator.push(
                                  context,
                                  SlideRightRoute(
                                      widget: CreateAlert(
                                          username, profileimg_url)));
                            },
                          )
                        ],
                      ),
              ])),
        ),
      ),
    );
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

class CreatePost extends StatefulWidget {
  String username, profileimg_url;
  CreatePost(this.username, this.profileimg_url);
  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final _postkey = GlobalKey<FormState>();
  TextEditingController post_text = TextEditingController();
  FilePickerCross image;
  String Storage_location;
  String username;
  String profile_img_url;
  final _scaffoldkey = GlobalKey<ScaffoldState>();

  webpicker() async {
    image = await Provider.of<GetImage>(context, listen: false).getfile();
  }

  sendData() async {
    Provider.of<BusyButtonModel>(context, listen: false).setBusy = true;
    try {
      if (image != null) {
        Storage_location =
            await PostUploadImage(image.toUint8List()).then((value) {
          return value;
        });
      }
      print(Storage_location);
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser.email)
          .collection("posts")
          .doc("${DateTime.now().microsecondsSinceEpoch}")
          .set({
        "text": "${post_text.text}",
        "image_url": Storage_location,
        "username": widget.username,
        "profile_img": widget.profileimg_url,
        "timestamp": DateTime.now().microsecondsSinceEpoch,
        "comments": [],
        "likes": [],
        "email":FirebaseAuth.instance.currentUser.email
      });
      await FirebaseFirestore.instance
          .collection("post")
          .doc("${DateTime.now().microsecondsSinceEpoch}")
          .set({
        "text": "${post_text.text}",
        "image_url": Storage_location,
        "username": widget.username,
        "profile_img": widget.profileimg_url,
        "timestamp": DateTime.now().microsecondsSinceEpoch,
        "comments": [],
        "likes": [],
        "email":FirebaseAuth.instance.currentUser.email
      });
    } catch (e) {
      print("${e} there is an error");
      Provider.of<BusyButtonModel>(context, listen: false).setBusy = false;
      return false;
    }
    Provider.of<BusyButtonModel>(context, listen: false).setBusy = false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.only(top: 30, right: 10, left: 10),
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                Form(
                    key: _postkey,
                    child: TextFormField(
                      controller: post_text,
                      validator: (inp) {
                        if (inp.isEmpty) {
                          return "This Field Should not be Empty";
                        }
                        return null;
                      },
                      maxLines: 10,
                      cursorColor: Colors.teal,
                      cursorHeight: 30,
                      style: Theme.of(context).textTheme.bodyText2,
                      decoration: InputDecoration(
                          hintText: "Write Something here to post",
                          labelText: "POST",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.teal)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.purple))),
                    )),
                SizedBox(
                  height: 10,
                ),
                Consumer<GetImage>(
                    builder: (context, model, child) =>
                        Provider.of<BusyButtonModel>(context).getBusy
                            ? Column(
                                children: [
                                  LinearProgressIndicator(
                                    backgroundColor: Colors.teal,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.purple),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Text("Uploading...")],
                                  )
                                ],
                              )
                            : model.myfile != null
                                ? Chip(
                                    avatar: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Image.memory(
                                            model.myfile.toUint8List())),
                                    label: Text("Image Selected"))
                                : Container()),
                SizedBox(
                  height: 20,
                ),
                FloatingActionButton.extended(
                    heroTag: "adding_images",
                    onPressed: () async {
                      await webpicker();
                    },
                    icon: Icon(Icons.add),
                    label: Text(
                        "${Provider.of<GetImage>(context).myfile != null ? "Replace Image" : "Add Image"}")),
                SizedBox(
                  height: 10,
                ),
                Consumer<BusyButtonModel>(
                    builder: (context, model, child) => BusyButton(
                        busy: model.getBusy,
                        title: "Submit",
                        onPressed: () async {
                          if (_postkey.currentState.validate()) {
                            bool checker = await sendData() ?? false;
                            if (checker) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Posted :)")));
                              Navigator.pop(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text("Error! Please Try Again :(")));
                            }
                          }
                        }))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CreateAlert extends StatefulWidget {
  String username, profileimg_url;
  CreateAlert(this.username, this.profileimg_url);
  @override
  _CreateAlertState createState() => _CreateAlertState();
}

class _CreateAlertState extends State<CreateAlert> {
  final _postkey = GlobalKey<FormState>();
  TextEditingController post_text = TextEditingController();
  FilePickerCross image;
  String Storage_location;
  String username;
  String profile_img_url;
  final _scaffoldkey = GlobalKey<ScaffoldState>();

  webpicker() async {
    image = await Provider.of<GetImage>(context, listen: false).getfile();
  }

  sendData() async {
    Provider.of<BusyButtonModel>(context, listen: false).setBusy = true;
    try {
      if (image != null) {
        Storage_location =
            await PostUploadImage(image.toUint8List()).then((value) {
          return value;
        });
      }
      print(Storage_location);
      await FirebaseFirestore.instance
          .collection("Alert")
          .doc(FirebaseAuth.instance.currentUser.email)
          .set({
        "text": "${post_text.text}",
        "image_url": Storage_location,
        "username": widget.username,
        "profile_img": widget.profileimg_url,
        "timestamp": DateTime.now().microsecondsSinceEpoch,
        "comments": [],
        "likes": [],
      });
      await FirebaseFirestore.instance
          .collection("Notifications")
          .doc(FirebaseAuth.instance.currentUser.email)
          .set({
        "Notification": "Alert From ${username}",
        "email": FirebaseAuth.instance.currentUser.email,
      });
    } catch (e) {
      print("${e} there is an error");
      Provider.of<BusyButtonModel>(context, listen: false).setBusy = false;
      return false;
    }
    Provider.of<BusyButtonModel>(context, listen: false).setBusy = false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.only(top: 30, right: 10, left: 10),
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                Form(
                    key: _postkey,
                    child: TextFormField(
                      controller: post_text,
                      validator: (inp) {
                        if (inp.isEmpty) {
                          return "This Field Should not be Empty";
                        }
                        return null;
                      },
                      maxLines: 10,
                      cursorColor: Colors.teal,
                      cursorHeight: 30,
                      style: Theme.of(context).textTheme.bodyText2,
                      decoration: InputDecoration(
                          hintText: "Please Add Alert here...",
                          labelText: "Add Alert",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.teal)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.purple))),
                    )),
                SizedBox(
                  height: 10,
                ),
                Consumer<GetImage>(
                    builder: (context, model, child) =>
                        Provider.of<BusyButtonModel>(context).getBusy
                            ? Column(
                                children: [
                                  LinearProgressIndicator(
                                    backgroundColor: Colors.teal,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.purple),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Text("Uploading...")],
                                  )
                                ],
                              )
                            : model.myfile != null
                                ? Chip(
                                    avatar: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Image.memory(
                                            model.myfile.toUint8List())),
                                    label: Text("Image Selected"))
                                : Container()),
                SizedBox(
                  height: 20,
                ),
                FloatingActionButton.extended(
                    heroTag: "adding_images",
                    onPressed: () async {
                      await webpicker();
                    },
                    icon: Icon(Icons.add),
                    label: Text(
                        "${Provider.of<GetImage>(context).myfile != null ? "Replace Image" : "Add Image"}")),
                SizedBox(
                  height: 10,
                ),
                Consumer<BusyButtonModel>(
                    builder: (context, model, child) => BusyButton(
                        busy: model.getBusy,
                        title: "Add Alert",
                        onPressed: () async {
                          if (_postkey.currentState.validate()) {
                            bool checker = await sendData() ?? false;
                            if (checker) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("Added Succefully:)")));
                              Navigator.pop(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text("Error! Please Try Again :(")));
                            }
                          }
                        }))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
