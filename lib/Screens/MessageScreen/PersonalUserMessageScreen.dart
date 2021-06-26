import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_10.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:socialmedia/Screens/MessageScreen/MessageModel.dart';

class UserMessageScreen extends StatefulWidget {
  final data,username;
  UserMessageScreen({this.data, this.username});
  @override
  _UserMessageScreenState createState() => _UserMessageScreenState();
}


class _UserMessageScreenState extends State<UserMessageScreen> {


TextEditingController text = TextEditingController();

    Sender(text,timestamp){
      int time = int.parse(timestamp);
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.end,children: [

          Column(
            mainAxisSize: MainAxisSize.min,
            //mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ChatBubble(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: kIsWeb?MediaQuery.of(context).size.width * 0.2:MediaQuery.of(context).size.width * 0.7,
                  ),
                  child:Text(text,style: Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.white,fontSize: 15)),
                ),backGroundColor: Colors.teal,
                clipper: ChatBubbleClipper10(type: BubbleType.sendBubble),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("${DateTime.fromMicrosecondsSinceEpoch(time).toString().substring(10,16)}")
                ],
              )
            ],
          )


        ],),
      );
    }
    Receiver(text,timestamp){
      int time = int.parse(timestamp);
      return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              Column(
                children: [
                  ChatBubble(
                    backGroundColor: Colors.purple,
                    clipper: ChatBubbleClipper10(
                        type: BubbleType.receiverBubble),
                    child:Container(
                      constraints: BoxConstraints(
                        maxWidth: kIsWeb?MediaQuery.of(context).size.width * 0.2:MediaQuery.of(context).size.width * 0.7,
                      ),
                      child:Text(text,style: Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.white,fontSize: 15)),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("${DateTime.fromMicrosecondsSinceEpoch(time).toString().substring(10,16)}")
                    ],
                  )

                ],
              )

            ],));
    }




final _formkey = GlobalKey<FormState>();

ScrollController scroll_controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height  = MediaQuery.of(context).size.height;
    return width > 600
        ? DesktopView(context)
        : Scaffold(
            appBar: AppBar(
              leadingWidth: width,
              titleSpacing: 0,
              title: Text(
                "${widget.data["full_name"]}",
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(color: Colors.white, fontSize: 15),
              ),
              backgroundColor: Colors.teal,
              elevation: 0,
              leading: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.arrow_back_ios_outlined)),
                  CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 20,
                      child:widget.data["profile_img_url"]!=null?Container(
                          height: kIsWeb?70:64,
                          width:70,
                          decoration: BoxDecoration(color:Colors.teal,borderRadius: BorderRadius.circular(100),image: DecorationImage(
                              fit: BoxFit.fill,
                              image:Image.network("${widget.data["profile_img_url"]}",fit: BoxFit.fill,).image))):Icon(Icons.person_pin)),
                ],
              ),
            ),
      bottomSheet:  Row(

        children: [
        Expanded(
          flex: 5,
          child: Padding(padding:EdgeInsets.symmetric(horizontal: 4,vertical:0)
          ,
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50)
              ),
              child: Form(
                key: _formkey,
                child: TextFormField(
                  validator: (inp){
                    if(inp.isEmpty){
                      return "Please Type Message";
                    }
                    return null;
                  },
                  controller: text,
                cursorHeight: 30,
                cursorWidth: 2,
                cursorColor: Colors.teal,
                autovalidateMode:AutovalidateMode.onUserInteraction ,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                        BorderSide(color: Colors.black12)),
                    disabledBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.teal)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.teal, width: 2),
                        borderRadius:
                        BorderRadius.circular(10))),
            ),
              ),),
          ),
        )
          ,Expanded(
            flex: 1,
            child: FloatingActionButton(
              onPressed: ()async{
                if(_formkey.currentState.validate()){
                  await FirebaseFirestore.instance.collection("users").doc(widget.data["email"]).collection("ChatRoom").doc(widget.username).collection("Messages").add({
                    "text":text.text,
                    "uid":FirebaseAuth.instance.currentUser.uid,
                    "timestamp":"${DateTime.now().microsecondsSinceEpoch}"
                  });
                  await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser.email).collection("ChatRoom").doc(widget.data["username"]).collection("Messages").add({
                    "text":text.text,
                    "uid":FirebaseAuth.instance.currentUser.uid,
                    "timestamp":"${DateTime.now().microsecondsSinceEpoch}"
                  }).then((v){
                    text.clear();
                    scroll_controller.animateTo(scroll_controller.position.maxScrollExtent, duration: Duration(milliseconds: 300), curve: Curves.easeOut);

                  });
                  await Future.delayed(Duration(milliseconds: 200));


                }
              },
              backgroundColor: Colors.teal,
              child: Icon(Icons.send),
            ),)],),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser.email).collection("ChatRoom").doc(widget.data["username"]).collection("Messages").orderBy("timestamp",descending: false).snapshots(),
        builder: (context,snap){
          if(!snap.hasData){
            return Center(
                child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Lottie.asset("assets/Lottie/Gloading.json",height: height/10),
          // Text("Loading...",style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: height/30,color: Colors.purple),)
          ],
          ));
          }else{
            var data = snap.data.docs;
            return Padding(padding: const EdgeInsets.only(bottom: 100),child: ListView.builder(
              controller: scroll_controller,
                itemCount: data.length,
                itemBuilder: (context,index){
                return FirebaseAuth.instance.currentUser.uid!=data[index]["uid"]?Receiver("${data[index]["text"]}","${data[index]["timestamp"]}"):Sender("${data[index]["text"]}",data[index]["timestamp"]);}),);

          }
        },
      ),
          );
  }
Widget DesktopView(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  double height  = MediaQuery.of(context).size.height;
  return Container(
    color: Colors.white,
    child: SafeArea(
      child: Column(
        children: [
          Stack(
            children: [
              ClipPath(
                clipper: DiagonalPathClipperOne(),
                child: Container(
                  child: Row(
                    children: [
                      Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: IconButton(
                                icon: Icon(
                                  Icons.arrow_back_ios_outlined,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  Provider.of<MessageModel>(context, listen: false)
                                      .onClickOpen(0, 0, 1, false);
                                }),
                          )),
                      CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 20,
                          child:widget.data["profile_img_url"]!=null?Container(
                              height: kIsWeb?70:64,
                              width:70,
                              decoration: BoxDecoration(color:Colors.teal,borderRadius: BorderRadius.circular(100),image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image:Image.network("${widget.data["profile_img_url"]}",fit: BoxFit.fill,).image))):Icon(Icons.person_pin)),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Text("${widget.data["full_name"]}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(color: Colors.white, fontSize: 15)),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  height: width > 700 ? 110 : 100,
                  color: Colors.teal,
                ),
              ),
            ],
          ),
          Expanded(
              flex: 8,
              child: Container(


                color:Colors.white,
                child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser.email).collection("ChatRoom").doc(widget.data["username"]).collection("Messages").orderBy("timestamp",descending: false).snapshots(),
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
                  return Padding(padding: const EdgeInsets.only(bottom:10),child: ListView.builder(
                      shrinkWrap: true,
                      controller: scroll_controller,
                      itemCount: data.length,
                      itemBuilder: (context,index){
                        return
                        FirebaseAuth.instance.currentUser.uid!=data[index]["uid"]?Receiver("${data[index]["text"]}",data[index]["timestamp"]):Sender("${data[index]["text"]}",data[index]["timestamp"]);},));

                }
            },
          ),
              )),
          Expanded(
              flex: 1,
              child: Row(

            children: [
              Expanded(
                flex: 5,
                child: Padding(padding:EdgeInsets.symmetric(horizontal: 4,vertical:3)
                  ,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50)
                    ),
                    child: Form(
                      key: _formkey,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        validator: (inp){
                          if(inp.isEmpty){
                            return "Please Type Message";
                          }
                          return null;
                        },
                        controller: text,
                        cursorHeight: 20,
                        cursorWidth: 2,
                        cursorColor: Colors.teal,
                        autovalidateMode:AutovalidateMode.onUserInteraction ,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                BorderSide(color: Colors.black12)),
                            disabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.teal)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.teal, width: 2),
                                borderRadius:
                                BorderRadius.circular(10))),
                      ),
                    ),),
                ),
              )
              ,Expanded(
                flex: 1,
                child: FloatingActionButton(
                  onPressed: ()async{
                    if(_formkey.currentState.validate()){
                      await FirebaseFirestore.instance.collection("users").doc(widget.data["email"]).collection("ChatRoom").doc(widget.username).collection("Messages").add({
                        "text":text.text,
                        "uid":FirebaseAuth.instance.currentUser.uid,
                        "timestamp":"${DateTime.now().microsecondsSinceEpoch}"
                      });
                      await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser.email).collection("ChatRoom").doc(widget.data["username"]).collection("Messages").add({
                        "text":text.text,
                        "uid":FirebaseAuth.instance.currentUser.uid,
                        "timestamp":"${DateTime.now().microsecondsSinceEpoch}"
                      }).then((v){
                        text.clear();
                        scroll_controller.animateTo(scroll_controller.position.maxScrollExtent, duration: Duration(milliseconds: 300), curve: Curves.easeOut);

                      });


                    }
                  },
                  backgroundColor: Colors.teal,
                  child: Icon(Icons.send),
                ),)],)),
        ],
      ),
    ),
  );
}
}


