import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class GetImage extends ChangeNotifier {
  FilePickerCross myfile;


  Future<FilePickerCross> getfile()async{
     myfile = await FilePickerCross.importFromStorage(
        type: FileTypeCross.custom,
        fileExtension: 'jpeg,png,jpg'
    ).onError((error, stackTrace){
      return null;
     });
    notifyListeners();


    return myfile;


  }


}


