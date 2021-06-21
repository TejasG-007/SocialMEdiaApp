
import 'package:get_it/get_it.dart';
import 'package:socialmedia/FirbaseServices/Authentication/Authentication.dart';

GetIt locator = GetIt.instance;
void setup(){
  locator.registerLazySingleton<Authentication>(() => Authentication());

}