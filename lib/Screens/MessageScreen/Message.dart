import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
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
  void dispose() {
    search.dispose();
    // TODO: implement dispose
    super.dispose();
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
                    Text("Chat-Room",
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
                        tooltip: "Search User",
                        backgroundColor: Colors.teal,
                        onPressed: () {
                          showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (context) {
                                return  Consumer<MessageModel>(
                                  builder: (context,model,child)=>Container(
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
                                                    onChanged: (val){
                                                      if(val.length!=0){
                                                        model.userSearch(val);
                                                      }
                                                    },
                                                    cursorHeight: 25,
                                                    controller: search,
                                                    decoration: InputDecoration(
                                                      hintText: "Search User",
                                                        prefixIcon:Icon(Icons.search_outlined,color: Colors.teal,),
                                                        suffixIcon: GestureDetector(

                                                          child: Icon(Icons.send,color: Colors.teal,),
                                                        ),
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
                                          ],
                                        ),
                                     model.tempsearchstore!=null?ListView.builder(
                                            shrinkWrap: true,
                                            itemBuilder:(context,index)=>
                                              Row(
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
                                                        child: model.tempsearchstore[index]
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
                                                                      "${model.tempsearchstore[index]["profile_img_url"]}",
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

                                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.purple,content: Text("Chat with ${model.tempsearchstore[index]["full_name"]}",style:TextStyle(color: Colors.white),)));
                                                          await FirebaseFirestore.instance
                                                              .collection("users")
                                                              .doc(FirebaseAuth.instance.currentUser.email)
                                                              .collection("ChatRoom").doc(model.tempsearchstore[index]["username"]).set({
                                                            "username":model.tempsearchstore[index]["username"],
                                                            "email":model.tempsearchstore[index]["email"],
                                                            "uid":model.tempsearchstore[index]["uid"],
                                                            "profile_img_url":model.tempsearchstore[index]["profile_img_url"],
                                                            "full_name":model.tempsearchstore[index]["full_name"],
                                                            "last_message":""
                                                          });
                                                          await FirebaseFirestore.instance
                                                              .collection("users")
                                                              .doc(model.tempsearchstore[index]["email"])
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
                                                          ).collection("ChatRoom").doc(model.tempsearchstore[index]["username"]).collection("Messages").add({
                                                            "text":"Hello!",
                                                            "uid":model.tempsearchstore[index]["uid"],
                                                            "timestamp":DateTime.now().microsecondsSinceEpoch,
                                                          });
                                                          await FirebaseFirestore.instance.collection("users").doc(
                                                              model.tempsearchstore[index]["email"]
                                                          ).collection("ChatRoom").doc(username["username"]).collection("Messages").add({
                                                            "text":"Hey..!",
                                                            "uid":FirebaseAuth.instance.currentUser.uid,
                                                            "timestamp":DateTime.now().microsecondsSinceEpoch,
                                                          });
                                                         if(kIsWeb){
                                                           showDialog(context: context, builder:(context)=>
                                                           AlertDialog(
                                                             content: Column(
                                                               mainAxisSize: MainAxisSize.min,
                                                               children: [
                                                                 Icon(Icons.message,color: Colors.green,size: height/8,),
                                                                 SizedBox(height: 10,),
                                                                 Text("Conversation is Created Please Check ChatRoom")
                                                               ],
                                                             ),
                                                             actions: [
                                                               TextButton(onPressed: (){
                                                                 Navigator.pop(context);
                                                               }, child: Text("OK"))
                                                             ],
                                                           )
                                                           );
                                                         }else{
                                                           Navigator.push(
                                                               context,
                                                               SlideRightRoute(
                                                                   widget:
                                                                   UserMessageScreen(data:model.tempsearchstore[index],username:username["username"])));
                                                         }
                                                        },
                                                        child: Column(
                                                          children: [
                                                            model.tempsearchstore[index][
                                                            "full_name"] !=
                                                                null
                                                                ? Text(
                                                                model.tempsearchstore[index]
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
                                              ),
                                            itemCount: model.tempsearchstore.length,




                                          ):LinearProgressIndicator(
                                       backgroundColor: Colors.teal,
                                     ),

                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          topLeft: Radius.circular(10))),
                                ));
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
                                            Text("Start Conversation",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2
                                                    .copyWith(
                                                        color: Colors.green,
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
