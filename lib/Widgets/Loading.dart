import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:socialmedia/Login%20and%20Register/LoginView.dart';
import 'package:socialmedia/Screens/Home/Home.dart';

class LoadingView extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    Size Screensize = MediaQuery.of(context).size;
    double width = Screensize.width;
    double height = Screensize.height;



    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset("assets/Lottie/Gloading.json",height: height/10),
                // Text("Loading...",style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: height/30,color: Colors.purple),)
              ],
            )
        )
    );
  }
}

