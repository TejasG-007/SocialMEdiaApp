import 'package:flutter/foundation.dart';

class DrawerModel extends ChangeNotifier{
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