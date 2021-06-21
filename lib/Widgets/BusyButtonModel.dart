import 'package:flutter/cupertino.dart';

class BusyButtonModel extends ChangeNotifier{
  ///////////////Loading Handler Method
  bool _busy=false;

  get getBusy{
    return _busy;

  }

  set setBusy(bool value){
    _busy=value;
    notifyListeners();
  }


}