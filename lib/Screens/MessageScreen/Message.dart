import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:socialmedia/Screens/MessageScreen/PersonalUserMessageScreen.dart';
import 'package:socialmedia/Widgets/PageBuilderTransition.dart';
import 'MessageModel.dart';

class MessageScreen extends StatefulWidget {
  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  TextEditingController search = TextEditingController();
  var username;
  var data;

  getusername()async{
     username = await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser.email).get();
  }

  @override
  void initState() {
    getusername();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double small = 700;
    return Consumer<MessageModel>(
      builder: (context, model, child) => AnimatedContainer(
        transform: Matrix4.translationValues(model.xOffSet_, model.yOffSet_, 0)
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
        child: Column(
          children: [
            ClipPath(
              clipper: DiagonalPathClipperOne(),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 70,
                    ),
                    Text("Messages",
                        style: Theme.of(context)
                            .textTheme
                            .headline2
                            .copyWith(color: Colors.white, fontSize: 24)),
                    SizedBox(
                      width: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: FloatingActionButton(
                        heroTag: "search",
                        backgroundColor: Colors.teal,
                        onPressed: () {
                          showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (context) {
                                return Container(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 4,
                                            child: Form(
                                              child: Padding(
                                                padding: EdgeInsets.all(5),
                                                child: TextFormField(
                                                  cursorHeight: 25,
                                                  controller: search,
                                                  decoration: InputDecoration(
                                                      border: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  10),
                                                          borderSide: BorderSide(
                                                              color: Colors
                                                                  .purple)),
                                                      disabledBorder: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  10),
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .purple)),
                                                      enabledBorder: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  10),
                                                          borderSide:
                                                              BorderSide(color: Colors.teal))),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              flex: 1,
                                              child: Consumer<MessageModel>(
                                                  builder:
                                                      (contex, model, child) {
                                                return FloatingActionButton(
                                                  heroTag: "search",
                                                  child: Icon(Icons.search),
                                                  onPressed: () {},
                                                );
                                              })),
                                        ],
                                      ),
                                      StreamBuilder(
                                        builder: (context, Snapshot) {
                                          if (Snapshot.hasData) {
                                            if (Snapshot.data.docs.length > 0) {
                                              return Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20,
                                                            vertical: 5),
                                                    child: CircleAvatar(
                                                        backgroundColor:
                                                            Colors.white,
                                                        radius: 35,
                                                        child: Snapshot.data
                                                                        .docs[0]
                                                                    [
                                                                    "profile_img_url"] !=
                                                                null
                                                            ? Container(
                                                                height: 64,
                                                                width: 70,
                                                                decoration: BoxDecoration(
                                                                    color: Colors.teal,
                                                                    borderRadius: BorderRadius.circular(100),
                                                                    image: DecorationImage(
                                                                        fit: BoxFit.fill,
                                                                        image: Image.network(
                                                                          "${Snapshot.data.docs[0]["profile_img_url"]}",
                                                                          fit: BoxFit
                                                                              .fill,
                                                                        ).image)))
                                                            : Icon(Icons.person_pin)),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 10),
                                                    child: MouseRegion(
                                                      cursor: SystemMouseCursors
                                                          .click,
                                                      child: GestureDetector(
                                                        onTap: () async{

                                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.purple,content: Text("Chat with ${Snapshot.data.docs[0]["full_name"]}",style:TextStyle(color: Colors.white),)));
                                                          await FirebaseFirestore.instance
                                                              .collection("users")
                                                              .doc(FirebaseAuth.instance.currentUser.email)
                                                              .collection("ChatRoom").doc(Snapshot.data.docs[0]["username"]).set({
                                                            "username":Snapshot.data.docs[0]["username"],
                                                            "email":Snapshot.data.docs[0]["email"],
                                                            "uid":Snapshot.data.docs[0]["uid"],
                                                            "profile_img_url":Snapshot.data.docs[0]["profile_img_url"],
                                                            "full_name":Snapshot.data.docs[0]["full_name"],
                                                            "last_message":""
                                                          });
                                                          await FirebaseFirestore.instance
                                                              .collection("users")
                                                              .doc(Snapshot.data.docs[0]["email"])
                                                              .collection("ChatRoom").doc(username["username"]).set({
                                                            "username":username["username"],
                                                            "email":username["email"],
                                                            "uid":username["uid"],
                                                            "profile_img_url":username["profile_img_url"],
                                                            "full_name":username["full_name"],
                                                            "last_message":""
                                                          });
                                                          await FirebaseFirestore.instance.collection("users").doc(
                                                            FirebaseAuth.instance.currentUser.email
                                                          ).collection("ChatRoom").doc(Snapshot.data.docs[0]["username"]).collection("Messages").add({
                                                            "text":"Hello!",
                                                            "uid":Snapshot.data.docs[0]["uid"],
                                                            "timestamp":DateTime.now().microsecondsSinceEpoch,
                                                          });
                                                          await FirebaseFirestore.instance.collection("users").doc(
                                                              Snapshot.data.docs[0]["email"]
                                                          ).collection("ChatRoom").doc(username["username"]).collection("Messages").add({
                                                            "text":"Hey..!",
                                                            "uid":FirebaseAuth.instance.currentUser.uid,
                                                            "timestamp":DateTime.now().microsecondsSinceEpoch,
                                                          });
                                                          width > small
                                                              ? model
                                                                  .onClickOpen(
                                                                      550,
                                                                      0,
                                                                      1,
                                                                      true)
                                                              : Navigator.push(
                                                                  context,
                                                                  SlideRightRoute(
                                                                      widget:
                                                                          UserMessageScreen(data:Snapshot.data.docs[0],username:username["username"])));
                                                        },
                                                        child: Column(
                                                          children: [
                                                            Snapshot.data.docs[
                                                                            0][
                                                                        "full_name"] !=
                                                                    null
                                                                ? Text(
                                                                    Snapshot.data
                                                                            .docs[0]
                                                                        [
                                                                        "full_name"],
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .headline2
                                                                        .copyWith(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize: 16))
                                                                : Container(),
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                  FontAwesomeIcons
                                                                      .circle,
                                                                  size: 10,
                                                                ),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Text(
                                                                    "Send Message to ..!!",
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodyText2
                                                                        .copyWith(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize: 14))
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              );
                                            }
                                          }
                                          return LinearProgressIndicator();
                                        },
                                        stream: FirebaseFirestore.instance
                                            .collection("users")
                                            .where("username",
                                                isEqualTo: search.text)
                                            .snapshots(),
                                      )
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          topLeft: Radius.circular(10))),
                                );
                              });
                        },
                        child: Icon(
                          FontAwesomeIcons.searchengin,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                height: width > 700 ? 110 : 100,
                color: Colors.teal,
              ),
            ),
            Expanded(
                child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(FirebaseAuth.instance.currentUser.email)
                  .collection("ChatRoom")
                  .snapshots(),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return ListView.builder(
                    itemBuilder: (context, ind) => Material(
                      color: Colors.white,
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey,
                        highlightColor: Colors.white,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey,
                            radius: 35,
                          ),
                          title: Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                color: Colors.grey,
                                height: 10,
                                width: MediaQuery.of(context).size.width - 100,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                color: Colors.grey,
                                height: 10,
                                width: MediaQuery.of(context).size.width - 100,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    itemCount: 10,
                  );
                } else {
                  var data = snap.data.docs;
                  return ListView.separated(

                      itemBuilder: (context, index) => Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 30,
                                    child: snap.data.docs[index]
                                                ["profile_img_url"] !=
                                            null
                                        ? Container(
                                            height: 64,
                                            width: 70,
                                            decoration: BoxDecoration(
                                                color: Colors.teal,
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: Image.network(
                                                      "${snap.data.docs[index]["profile_img_url"]}",
                                                      fit: BoxFit.fill,
                                                    ).image)))
                                        : Icon(Icons.person_pin)),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: ()async{
                                        await Provider.of<MessageModel>(context,listen: false).gettingdata(snap.data.docs[index],username["username"]);
                                        await Future.delayed(Duration(milliseconds: 300));
                                      width > small
                                          ? model.onClickOpen(550, 0, 1, true)
                                          : Navigator.push(
                                              context,
                                              SlideRightRoute(
                                                  widget: UserMessageScreen(data:snap.data.docs[index],username:username["username"])));
                                    },
                                    child: Column(
                                      children: [
                                        Text(snap.data.docs[index]["full_name"],
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline2
                                                .copyWith(
                                                    color: Colors.black,
                                                    fontSize: 16)),
                                        Row(
                                          children: [
                                            Icon(
                                              FontAwesomeIcons.circle,
                                              size: 10,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text("Send Message to ..!!",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2
                                                    .copyWith(
                                                        color: Colors.black,
                                                        fontSize: 14))
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                      separatorBuilder: (context, index) => Divider(
                            thickness: 1,
                            indent: 80,
                          ),
                      itemCount: snap.data.docs.length);
                }
              },
            ))

          ],
        ),
      ),
    );
  }
}
