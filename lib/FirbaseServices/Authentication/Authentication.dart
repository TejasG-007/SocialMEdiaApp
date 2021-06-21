

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class Authentication {



/////////////////FirebaseAuth Instance Call and FirebaseCloudstore Instance
final _firebase_auth = FirebaseAuth.instance;
final clouddb = FirebaseFirestore.instance;






////Inititiating database collections with empty field

  DbInitiater()async{
    try{
      await clouddb.collection("users").doc(_firebase_auth.currentUser.email).collection("Messages").doc("Userid").set(
          {"username": "message"});
      await clouddb.collection("users").doc(_firebase_auth.currentUser.email).collection("User_details").doc("username_detail").set({
        "DOB":"",
        "fullName":"",
        "Gender":"unknown",
        "profile_img_url":"",
        "uid":"",
      });
      await clouddb.collection("users").doc(_firebase_auth.currentUser.email).collection("Posts").doc("Userid_timestamp").set({
        "Image_count":0,
        "Image_urls":[],
        "Text":""

      });
      await clouddb.collection("users").doc(_firebase_auth.currentUser.email).collection("Notifications").doc("fromuid").set({
        "fromuid_username":"",
        "fromuid_profile_img_url":"",
        "timestamp":"",
        "isRead":"false",
      });
      return true;
    }on FirebaseException
    catch(e){
      return e.message;
    }
  }





 ///////////////Sign In and Verify Method

signInVerify(String email,String password)async{

  try{
    UserCredential result = await _firebase_auth.createUserWithEmailAndPassword(email: email+"@mgmcen.ac.in", password: password);
    await result.user.sendEmailVerification();
    await clouddb.collection("users").doc(_firebase_auth.currentUser.email).set({"getting_started":false});
    return result.user!=null;

  }on FirebaseAuthException catch(e){

    return e.message;
  }
}


 //////////////Login Method
loginUser(String email , String password)async{

try{

  UserCredential result = await _firebase_auth.signInWithEmailAndPassword(email: (email+"@mgmcen.ac.in"), password: password);
  if(result.user.emailVerified){
    return result.user!=null;
  }else{
    return "Email is not Verified";
  }
}on FirebaseAuthException catch(e){
  return e.message;
}

}



///////////////Sign Out



  signout()async{
    await _firebase_auth.signOut();
  }



/////////////passwordRecovery


passwordRecovery(String email)async{
  try{
   var result = await _firebase_auth.sendPasswordResetEmail(email: email+"@mgmcen.ac.in");

  }on FirebaseAuthException catch(e){
    return e.message;
  }
}




}