import 'package:flutter/foundation.dart';

class MessageModel extends ChangeNotifier{
var data,username,othersusername;
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