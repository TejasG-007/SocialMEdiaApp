import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:socialmedia/FirbaseServices/Authentication/Authentication.dart';
import 'package:socialmedia/Login%20and%20Register/LoginView.dart';
import 'package:socialmedia/Login%20and%20Register/RegisterView.dart';
import 'package:socialmedia/Widgets/BusyButton.dart';
import 'package:socialmedia/Widgets/BusyButtonModel.dart';
import 'package:socialmedia/Widgets/PageBuilderTransition.dart';
import '../locator.dart';
import 'LoginModel.dart';

class ForgotView extends StatefulWidget {
  @override
  _ForgotViewState createState() => _ForgotViewState();
}

class _ForgotViewState extends State<ForgotView> {
  final _formkey = GlobalKey<FormState>();
  final Auth = locator<Authentication>();
  TextEditingController email = TextEditingController();
  final _scaffoldkey = GlobalKey<ScaffoldState>();

  _getBottomRoutes(double Right) {
    double right = Right;
    return Column(
      children: [
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context, SlideRightRoute(widget: RegisterView()));
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, right: right),
                    child: Text(
                      "Create New Account   ",
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontSize: 18,
                          color: Colors.purple,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
            )
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context, SlideRightRoute(widget: LoginView()));
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, right: right),
                    child: Text(
                      "Login with Credentials ?",
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontSize: 18,
                          color: Colors.purple,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldkey,
        backgroundColor: Colors.white,
        body: LayoutBuilder(
          builder: (builder, size) {
            //Responsive Sizes for Devices
            double small = 700;
            double medium = 700;
            double large = 1399;
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                  height: size.maxHeight,
                  width: size.maxWidth,
                  child: Scrollbar(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        ClipPath(
                          clipper: DiagonalPathClipperOne(),
                          child: Container(
                            alignment: Alignment.center,
                            height: size.maxWidth < small ? 100 : 100,
                            width: size.maxWidth,
                            color: Colors.teal,
                          ),
                        ),
                        size.maxWidth < small
                            ? Container()
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    Image.asset(
                                      "assets/Images/logo.jpeg",
                                      height: 80,
                                    )
                                  ]),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            size.maxWidth >= small
                                ? Expanded(
                                    flex: 1,
                                    child: Container(
                                      margin: EdgeInsets.all(20),
                                      child: Lottie.asset(
                                          "assets/Lottie/social-media-network.json",
                                          height: size.maxWidth > medium
                                              ? 600
                                              : 200),
                                    ),
                                  )
                                : Container(),
                            Expanded(
                                flex: 1,
                                child: Container(
                                    child: Column(
                                  children: [
                                    size.maxWidth < small
                                        ? Padding(
                                            padding: EdgeInsets.only(top: 10),
                                            child: Lottie.asset(
                                                "assets/Lottie/social-media-network.json",
                                                height: 250,
                                                width: 250),
                                          )
                                        : Container(),
                                    size.maxWidth > small
                                        ? SizedBox(
                                            height: 100,
                                          )
                                        : SizedBox(
                                            height: 20,
                                          ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("Password Recovery",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline1),
                                        FaIcon(
                                          FontAwesomeIcons.userLock,
                                          color: Colors.purple,
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Form(
                                        key: _formkey,
                                        child: Column(
                                          children: [
                                            Padding(
                                                padding: size.maxWidth <= small
                                                    ? EdgeInsets.only(
                                                        left: 60, right: 60)
                                                    : size.maxWidth >= medium &&
                                                            size.maxWidth <=
                                                                large
                                                        ? EdgeInsets.only(
                                                            left: 80, right: 80)
                                                        : EdgeInsets.only(
                                                            left: 200,
                                                            right: 200),
                                                child: TextFormField(
                                                  controller: email,
                                                  validator: (inp) {
                                                    if (inp.contains("@")) {
                                                      return "Please Enter Valid Email";
                                                    } else if (inp.isEmpty) {
                                                      return "Email Should not be Empty";
                                                    }
                                                    return null;
                                                  },
                                                  cursorColor: Colors.purple,
                                                  autovalidateMode:
                                                      AutovalidateMode
                                                          .onUserInteraction,
                                                  cursorHeight: 25,
                                                  decoration: InputDecoration(
                                                      prefixIcon: Icon(Icons
                                                          .alternate_email),
                                                      labelText: "Enter Email",
                                                      suffixText:
                                                          "@mgmcen.ac.in",
                                                      border: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  10),
                                                          borderSide: BorderSide(
                                                              color: Colors
                                                                  .purple)),
                                                      disabledBorder:
                                                          OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .purple)),
                                                      enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color:
                                                                  Colors.black,
                                                              width: 2),
                                                          borderRadius:
                                                              BorderRadius.circular(10))),
                                                )),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            MouseRegion(
                                              cursor: SystemMouseCursors.click,
                                              child: BusyButton(
                                                onPressed: () async {
                                                  if (_formkey.currentState
                                                      .validate()) {
                                                    Provider.of<BusyButtonModel>(
                                                            context,
                                                            listen: false)
                                                        .setBusy = true;
                                                    var result = await Auth
                                                        .passwordRecovery(
                                                            email.text);
                                                    Provider.of<BusyButtonModel>(
                                                            context,
                                                            listen: false)
                                                        .setBusy = false;
                                                    return showDialog(
                                                        context: _scaffoldkey
                                                            .currentContext,
                                                        builder:
                                                            (context) =>
                                                                AlertDialog(
                                                                  actions: [
                                                                    TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.push(
                                                                              context,
                                                                              SlideRightRoute(widget: LoginView()));
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          "LOGIN",
                                                                          style: TextStyle(
                                                                              color: Colors.teal,
                                                                              fontWeight: FontWeight.bold),
                                                                        ))
                                                                  ],
                                                                  title: Text(
                                                                    "Recovery Mail has been sent.",
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodyText2
                                                                        .copyWith(
                                                                            color:
                                                                                Colors.teal,
                                                                            fontWeight: FontWeight.bold),
                                                                  ),
                                                                ));
                                                  }
                                                },
                                                title: "Continue",
                                                busy: Provider.of<
                                                            BusyButtonModel>(
                                                        context,
                                                        listen: true)
                                                    .getBusy,
                                              ),
                                            ),
                                            size.maxWidth > small
                                                ? _getBottomRoutes(80)
                                                : Container()
                                          ],
                                        )),
                                  ],
                                )))
                          ],
                        ),
                        size.maxWidth < small
                            ? _getBottomRoutes(15)
                            : Container()
                      ],
                    ),
                  )),
            );
          },
        ));
  }
}
