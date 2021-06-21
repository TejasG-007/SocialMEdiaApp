import 'package:flutter/foundation.dart';

class HomeViewModel extends ChangeNotifier{

  bool show = false;

  get isCollapase => show;

  setCollapse(){
    show=!show;
    notifyListeners();
  }

}