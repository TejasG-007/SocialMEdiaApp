import'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialmedia/Screens/MessageScreen/MessageModel.dart';
import 'Message.dart';
import 'PersonalUserMessageScreen.dart';

class MessageSwitcher extends StatefulWidget {
  @override
  _MessageSwitcherState createState() => _MessageSwitcherState();
}

class _MessageSwitcherState extends State<MessageSwitcher> {
  GlobalKey scaffoldkey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      key: scaffoldkey,
      body: WillPopScope(
        onWillPop: (){
     Navigator.of(context).pop();
      return null;
    },
    child: Stack(
          children: [
           Consumer<MessageModel>(builder: (context,model,child){

             return UserMessageScreen(data: model.data,username: model.username,);},),
            MessageScreen(),
          ],
        ),),
    );
  }
}
