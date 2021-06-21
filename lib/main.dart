import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:socialmedia/Login%20and%20Register/LoginModel.dart';
import 'package:socialmedia/Login%20and%20Register/RegisterModel.dart';
import 'package:socialmedia/Screens/Drawer/DraweModel.dart';
import 'package:socialmedia/Screens/Drawer/ImagePicker.dart';
import 'package:socialmedia/Screens/GettingStarted/GenderSelectionModel.dart';
import 'package:socialmedia/Screens/Home/Home.dart';
import 'package:socialmedia/Screens/Home/HomeViewModel.dart';
import 'package:socialmedia/Screens/MessageScreen/MessageModel.dart';
import 'package:socialmedia/Widgets/BusyButtonModel.dart';
import 'package:socialmedia/Widgets/Loading.dart';
import 'package:socialmedia/locator.dart';
import 'Login and Register/LoginView.dart';



void main()async{
  setup();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.teal
      )
    );
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => Handler(),
      ),
      ChangeNotifierProvider(create: (_) =>BusyButtonModel()),
        ChangeNotifierProvider(create: (_) => RegisterHandler(),),
        ChangeNotifierProvider(create: (_) => GenderSelection()),
        ChangeNotifierProvider(create: (_)=>HomeViewModel(),child: HomeView(),),
        ChangeNotifierProvider(create: (_)=>DrawerModel(),),
        ChangeNotifierProvider(create: (_)=>MessageModel()),
        ChangeNotifierProvider(create: (_)=>GetImage()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.purple,
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                    primary: Colors.purple,
                    textStyle: TextStyle(color: Colors.white,fontSize:20,fontFamily: "Nunito" ))),

            accentColor: Colors.purple,
            primaryColor: Colors.purple,
          fontFamily: "Nunito",
          textTheme: TextTheme(
            headline1: TextStyle(color:Colors.black,fontSize: 35,fontFamily: "Nunito"),
            headline2: TextStyle(color: Colors.black),
            bodyText2: TextStyle(color:Colors.black,fontFamily: "Body")
          )

        ),
        // initialRoute: '/login',
        // routes: {
        //   '/login':(context)=>LoginView(),
        //   '/register':(context)=>RegisterView(),
        //   '/forgot':(context)=>ForgotView(),
        //   '/home':(context)=>HomeView(),
        //   '/messages':(context)=>MessageScreen(),
        //   '/ChatRoom':(context)=>UserMessageScreen(),
        //   '/notifications':(context)=>Notifications(),
        //   '/friends':(context)=>Friends(),
        // },
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context,snapshot){
            if(snapshot.hasData){
              return FirebaseAuth.instance.currentUser.emailVerified?HomeView():LoginView();
            }
    else if(snapshot.connectionState==ConnectionState.waiting){
      return LoadingView();
            }
            else{
              return LoginView();
            }

          },
        ),
      ),
    );
  }
}


