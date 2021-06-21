import 'package:flutter/foundation.dart';

class RegisterHandler extends ChangeNotifier{

  ///Used to Hide and Show the Password
  bool obsecuretext1 = true;
  bool obsecuretext2 = true;

  get visibility1 => obsecuretext1;
  get visibility2 => obsecuretext2;

  Hidepassword1(){
    obsecuretext1 = !obsecuretext1;
    notifyListeners();
  }
  Hidepassword2(){
    obsecuretext2 = !obsecuretext2;
    notifyListeners();
  }



  ///Password Matcher
  bool matcher = true;
  PasswordMatcher(bool value){
    matcher=value;
    notifyListeners();
  }
  get matching => matcher;






}