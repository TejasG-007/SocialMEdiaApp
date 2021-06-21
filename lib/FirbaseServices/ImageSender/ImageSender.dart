import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

String fileName = DateTime.now().millisecondsSinceEpoch.toString();
String pfilename="profilepic";
FirebaseStorage _storage = FirebaseStorage.instance;
Reference post_reference = _storage.ref(FirebaseAuth.instance.currentUser.uid).child("postIMG").child("${fileName}");
Reference profile_reference = _storage.ref(FirebaseAuth.instance.currentUser.uid).child("profileIMG").child("${pfilename}");

Future<String> PostUploadImage(var image)async{
  String location;

  TaskSnapshot storageTaskSnapshot = await post_reference.putData(image,SettableMetadata(contentType: 'image/png'));

  location = await storageTaskSnapshot.ref.getDownloadURL();

  print(location);

  return location;
  
}


Future<String> UploadProfileImg(var image,String filename)async{
  String location;
  pfilename = filename;
  TaskSnapshot storageTaskSnapshot = await profile_reference.putData(image,SettableMetadata(contentType: 'image/png'));

  location = await storageTaskSnapshot.ref.getDownloadURL();



  return location;

}