import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:socialmedia/FirbaseServices/ImageSender/ImageSender.dart';
import 'package:socialmedia/Screens/Drawer/ImagePicker.dart';
import 'package:socialmedia/Screens/GettingStarted/GenderSelectionModel.dart';
import 'package:provider/provider.dart';
import 'package:socialmedia/Widgets/BusyButtonModel.dart';

class GettingStarted extends StatefulWidget {
  @override
  _GettingStartedState createState() => _GettingStartedState();
}

class _GettingStartedState extends State<GettingStarted> {
  double small = 700;
  double medium = 700;
  double large = 1399;
  TextEditingController username = TextEditingController();
  TextEditingController full_name = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController institute = TextEditingController();
  String profile_img_url;

  profile_img_picker() async {
    Provider.of<BusyButtonModel>(context, listen: false).setBusy = true;
    FilePickerCross image =
        await Provider.of<GetImage>(context, listen: false).getfile();
    if (image != null) {
      profile_img_url =
          await UploadProfileImg(image.toUint8List(), image.fileName);
      Provider.of<BusyButtonModel>(context, listen: false).setBusy = false;
    }
  }

  Widget genderSelector() {
    return Consumer<GenderSelection>(
      builder: (context, gender, child) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select Gender",
            style: Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    child: gender.gender == "Male"
                        ? CircleAvatar(
                            backgroundColor: Colors.purpleAccent,
                            child: FaIcon(
                              FontAwesomeIcons.male,
                              color: Colors.white,
                            ))
                        : CircleAvatar(
                            backgroundColor: Colors.white,
                            child: FaIcon(FontAwesomeIcons.male),
                          ),
                    onTap: () {
                      gender.SetGender("Male");
                    },
                  )),
              SizedBox(
                width: 20,
              ),
              MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    child: gender.gender == "Female"
                        ? CircleAvatar(
                            backgroundColor: Colors.purpleAccent,
                            child: FaIcon(
                              FontAwesomeIcons.female,
                              color: Colors.white,
                            ))
                        : CircleAvatar(
                            backgroundColor: Colors.white,
                            child: FaIcon(FontAwesomeIcons.female),
                          ),
                    onTap: () {
                      gender.SetGender("Female");
                    },
                  )),
              SizedBox(
                width: 20,
              ),
              MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    child: gender.gender == "Other"
                        ? CircleAvatar(
                            backgroundColor: Colors.purpleAccent,
                            child: FaIcon(
                              FontAwesomeIcons.transgender,
                              color: Colors.white,
                            ),
                          )
                        : CircleAvatar(
                            backgroundColor: Colors.white,
                            child: FaIcon(FontAwesomeIcons.transgender)),
                    onTap: () {
                      gender.SetGender("Other");
                    },
                  ))
            ],
          )
        ],
      ),
    );
  }

  Widget _DesktopBuilder(double width) {
    return Scrollbar(
      child: ListView(
        children: [
          ClipPath(
            clipper: WaveClipperTwo(),
            child: Container(
                alignment: Alignment.center,
                height: 200,
                width: width,
                color: Colors.teal,
                child: Text(
                  "Getting Started",
                  style: Theme.of(context)
                      .textTheme
                      .headline1
                      .copyWith(color: Colors.white, fontSize: 40),
                )),
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  profile_img_picker();
                },
                child: Consumer<GetImage>(
                    builder: (context, model, child) => CircleAvatar(
                          radius: 50,
                          child: model.myfile != null
                              ? Container(
                                  decoration: BoxDecoration(
                                      color: Colors.teal,
                                      borderRadius: BorderRadius.circular(100),
                                      image: DecorationImage(
                                          image: Image.memory(
                                                  model.myfile.toUint8List())
                                              .image,
                                          fit: BoxFit.fill)),
                                  height: 100,
                                  width: 100,
                                )
                              : FaIcon(
                                  FontAwesomeIcons.user,
                                  size: 50,
                                ),
                        )),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.report_gmailerrorred_outlined,color: Colors.redAccent,),
              Container(
                padding:EdgeInsets.all(5),
                child:Text("Once Entered Info Cannot Allow to change later...",style: Theme.of(context).textTheme.headline2.copyWith(color: Colors.red,fontSize: 14),),
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width*0.7
                ),
              )
            ],),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Provider.of<GetImage>(context).myfile != null
                  ? Text(
                      "${Provider.of<GetImage>(context).myfile.fileName}",
                      style: Theme.of(context).textTheme.bodyText2.copyWith(),
                    )
                  : Text(
                      "Set Profile Image",
                      style: Theme.of(context).textTheme.bodyText2.copyWith(),
                    )
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: Padding(
                    padding: EdgeInsets.only(
                        left: 60, right: 60, top: 10, bottom: 10),
                    child: TextFormField(
                      controller: username,
                      validator: (inp) {
                        if (inp.isEmpty) {
                          return "Username Should not be Empty";
                        }
                        return null;
                      },
                      cursorColor: Colors.purple,
                      cursorHeight: 25,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person_pin_circle),
                          labelText: "Create UserName",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.purple)),
                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.purple)),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2),
                              borderRadius: BorderRadius.circular(10))),
                    )),
              ),
              Expanded(
                child: Padding(
                    padding: EdgeInsets.only(
                        left: 60, right: 60, top: 10, bottom: 10),
                    child: TextFormField(
                      controller: full_name,
                      validator: (inp) {
                        if (inp.isEmpty) {
                          return "Full Name Should not be Empty";
                        }
                        return null;
                      },
                      cursorColor: Colors.purple,
                      cursorHeight: 25,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person_pin),
                          labelText: "Enter Full Name",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.purple)),
                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.purple)),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2),
                              borderRadius: BorderRadius.circular(10))),
                    )),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 60, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: genderSelector(),
                ),
                Expanded(child: Container())
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                    padding: EdgeInsets.only(
                        left: 60, right: 60, top: 10, bottom: 10),
                    child: TextFormField(
                      controller: dob,
                      validator: (inp) {
                        if (inp.isEmpty) {
                          return "DOB Should not be Empty";
                        } else if (inp.length > 10) {
                          return "Please Enter Valid Date as DD/MM/YYYY ";
                        }
                        return null;
                      },
                      cursorColor: Colors.purple,
                      keyboardType: TextInputType.datetime,
                      cursorHeight: 25,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.date_range),
                          labelText: "DD/MM/YYYY",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.purple)),
                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.purple)),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2),
                              borderRadius: BorderRadius.circular(10))),
                    )),
              ),
              Expanded(
                child: Padding(
                    padding: EdgeInsets.only(
                        left: 60, right: 60, top: 10, bottom: 10),
                    child: TextFormField(
                      readOnly: true,
                      controller: institute,
                      validator: (inp) {
                        if (inp.isEmpty) {
                          return "Institution Name Should not be Empty";
                        }
                        return null;
                      },
                      cursorColor: Colors.purple,
                      cursorHeight: 25,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.account_balance),
                          labelText: "MGM's College of Engineering , Nanded",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.purple)),
                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.purple)),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2),
                              borderRadius: BorderRadius.circular(10))),
                    )),
              ),
            ],
          ),
          _floatingActionButton(),
          ClipPath(
            clipper: WaveClipperOne(reverse: true),
            child: Container(
              alignment: Alignment.bottomLeft,
              height: 100,
              width: width,
              color: Colors.teal,
            ),
          )
        ],
      ),
    );
  }

  _floatingActionButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FloatingActionButton(
            heroTag: "Floating1",
            backgroundColor: Colors.purpleAccent,
            child: Icon(Icons.arrow_forward),
            onPressed: () async {
              await FirebaseFirestore.instance.collection("users").where("username",isEqualTo:username.text.toLowerCase()).get().then((value)async{
                 if(value.docs.length<=0){
                   if (profile_img_url != null &&
                       username.text != null &&
                       full_name.text != null &&
                       dob.text != null) {
                     await FirebaseFirestore.instance
                         .collection("users")
                         .doc("${FirebaseAuth.instance.currentUser.email}")
                         .collection("UserDetails")
                         .doc("user_detail")
                         .set({
                       "uid":FirebaseAuth.instance.currentUser.uid,
                       "username": username.text.toLowerCase(),
                       "full_name": full_name.text.substring(0,1).toUpperCase()+full_name.text.substring(1),
                       "DOB": dob.text,
                       "searchKey":full_name.text.substring(0,1).toUpperCase(),
                       "profile_img_url": profile_img_url,
                       "gender": Provider.of<GenderSelection>(context, listen: false)
                           .gender,
                     }).then((value) async {
                       await FirebaseFirestore.instance
                           .collection("users")
                           .doc("${FirebaseAuth.instance.currentUser.email}")
                           .set({

                         "uid":FirebaseAuth.instance.currentUser.uid,
                         "email":FirebaseAuth.instance.currentUser.email,
                         "profile_img_url": profile_img_url,
                         "username": username.text,
                         "gender": Provider.of<GenderSelection>(context, listen: false)
                             .gender,
                         "searchKey":full_name.text.substring(0,1).toUpperCase(),
                         "full_name": full_name.text.substring(0,1).toUpperCase()+full_name.text.substring(1),
                         "DOB": dob.text,
                         "getting_started": true,
                       });
                     });
                   } else {
                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                         backgroundColor: Colors.teal,
                         content: Text("Please Wait While Uploading Profile Image or Check Fields")));
                   }
              }else{
                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                       backgroundColor: Colors.teal,
                       content: Text("Username is already taken please try again.")));
                 }}
              );
              


              // Navigator.push(context,SlideRightRoute(widget:HomeView()));
            })
      ],
    );
  }

  Widget _MobileBuilder(double width) {
    return ListView(
      children: [
        ClipPath(
          clipper: WaveClipperTwo(),
          child: Container(
              alignment: Alignment.centerLeft,
              height: 120,
              width: width,
              color: Colors.teal,
              child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    "Getting Started",
                    style: Theme.of(context)
                        .textTheme
                        .headline1
                        .copyWith(color: Colors.white, fontSize: 20),
                  ))),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                FilePickerCross image =
                    await Provider.of<GetImage>(context, listen: false)
                        .getfile();
                if (image != null) {
                  profile_img_url = await UploadProfileImg(
                      image.toUint8List(), image.fileName);
                }
              },
              child: Consumer<GetImage>(
                  builder: (context, model, child) => CircleAvatar(
                        radius: 50,
                        child: model.myfile != null
                            ? Container(
                                decoration: BoxDecoration(
                                    color: Colors.teal,
                                    borderRadius: BorderRadius.circular(100),
                                    image: DecorationImage(
                                        image: Image.memory(
                                                model.myfile.toUint8List())
                                            .image,
                                        fit: BoxFit.fill)),
                                height: 100,
                                width: 100,
                              )
                            : FaIcon(
                                FontAwesomeIcons.user,
                                size: 50,
                              ),
                      )),
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Set Profile Image",
              style: Theme.of(context).textTheme.bodyText2.copyWith(),
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
            padding: EdgeInsets.only(left: 60, right: 60, top: 10, bottom: 10),
            child: TextFormField(
              controller: username,
              validator: (inp) {

                if (inp.isEmpty) {
                  return "Username Should not be Empty";
                }
                return null;
              },
              cursorColor: Colors.purple,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              cursorHeight: 25,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person_pin_circle),
                  labelText: "Create UserName",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.purple)),
                  disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(10))),
            )),
        Padding(
          padding: EdgeInsets.only(left: 60, right: 60, top: 10, bottom: 10),
          child: genderSelector(),
        ),
        Padding(
            padding: EdgeInsets.only(left: 60, right: 60, top: 10, bottom: 10),
            child: TextFormField(
              controller: full_name,
              validator: (inp) {
                if (inp.isEmpty) {
                  return "Full Name Should not be Empty";
                }
                return null;
              },
              cursorColor: Colors.purple,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              cursorHeight: 25,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person_pin),
                  labelText: "Enter Full Name",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.purple)),
                  disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(10))),
            )),
        Padding(
            padding: EdgeInsets.only(left: 60, right: 60, top: 10, bottom: 10),
            child: TextFormField(
              controller: dob,
              validator: (inp) {
                if (inp.isEmpty) {
                  return "DOB Should not be Empty";
                } else if (inp.length > 10) {
                  return "Please Enter Valid Date";
                }
                return null;
              },
              cursorColor: Colors.purple,
              keyboardType: TextInputType.datetime,
              cursorHeight: 25,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.date_range),
                  labelText: "DD/MM/YYYY",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.purple)),
                  disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(10))),
            )),
        Padding(
            padding: EdgeInsets.only(left: 60, right: 60, top: 10, bottom: 10),
            child: TextFormField(
              readOnly: true,
              validator: (inp) {
                if (inp.isEmpty) {
                  return "Institution Name Should not be Empty";
                }
                return null;
              },
              cursorColor: Colors.purple,
              cursorHeight: 25,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.account_balance),
                  hintText: "MGM's College of Engineering,Nanded",
                  labelText:"Institution Name" ,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.purple)),
                  disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(10))),
            )),
        SizedBox(
          height: 30,
        ),
        _floatingActionButton(),
        ClipPath(
          clipper: WaveClipperOne(reverse: true),
          child: Container(
            alignment: Alignment.bottomLeft,
            height: 100,
            width: width,
            color: Colors.teal,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (builder, size) => SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SafeArea(
            child: Center(
                child: Column(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  child: size.maxWidth < small
                      ? _MobileBuilder(size.maxWidth)
                      : _DesktopBuilder(size.maxWidth),
                  height: size.maxHeight,
                  width: size.maxWidth,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ],
            )),
          ),
        ),
      ),
    );
  }
}
