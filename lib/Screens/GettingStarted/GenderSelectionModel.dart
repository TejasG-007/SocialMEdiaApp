import 'package:flutter/foundation.dart';


class GenderSelection extends ChangeNotifier{

  String gender="Male";
  get SelectedGender =>gender;

SetGender(String value){
  gender = value;
  notifyListeners();
}


}