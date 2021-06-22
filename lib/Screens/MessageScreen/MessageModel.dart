import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class MessageModel extends ChangeNotifier{
var data,username,othersusername;
var queryresultset =[];
var tempsearchstore = [];

userSearch(String value ){

  if(value.length==0){
    queryresultset = [];
    tempsearchstore =[];
  }
  var capitalizedValue = value.substring(0,1).toUpperCase()+value.substring(1);

  if(queryresultset.length == 0 && value.length ==1){
    Searchuser(value).then((snap){
      for(int itr=0;itr<snap.docs.length;itr++){
        queryresultset.add(snap.docs[itr].data());
      }

    });
  }else{
    tempsearchstore = [];
    queryresultset.forEach((element) {
      if(element["full_name"].toString().startsWith(capitalizedValue)){
        tempsearchstore.add(element);
        notifyListeners();
      }
    });
  }

  notifyListeners();
}


Searchuser(String value)async{

  return await FirebaseFirestore.instance.collection("users").where("searchkey",isEqualTo:value.substring(0,1).toUpperCase()).get();
}









gettingdata(var d,String u){
  data = d;
  username = u;
  notifyListeners();
}
  double xOffSet_ = 0;
  double yOffSet_ = 0;
  double scaleFactor_ = 1;
  bool isDrawerOpen = false;

  onClickOpen(double xOffSet,
  double yOffSet,
  double scaleFactor,bool isDrawerOpen_){
  xOffSet_ = xOffSet;
  yOffSet_ = yOffSet;
  scaleFactor_ = scaleFactor;
  isDrawerOpen = isDrawerOpen_;

  notifyListeners();
  }

}