import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app/auth/login.dart';
import 'package:note_app/auth/signup.dart';
import 'package:note_app/constantsColors.dart';
import 'package:note_app/crud/addnotes.dart';
import 'package:note_app/crud/change_color.dart';
import 'package:note_app/crud/create_password.dart';
import 'package:note_app/crud/password_page.dart';
import 'package:note_app/home/homepage.dart';
import 'package:note_app/crud/setting.dart';

Future backgroundMassiging(RemoteMessage remoteMessage) async {
  print(
      "===================================-------------------------=============================");
  print("${remoteMessage.notification?.body}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundMassiging);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _auth = FirebaseAuth.instance;
  var fbm = FirebaseMessaging.instance;

  Future getInt() async {
    print(
        "===================================trim=============================");
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      print(
          "=============++++++++++++++++++++++++++++++++++++++++++++++++++++++");
      Get.to(() => AddNotes());
    }
  }

  // Future getOn() async {
  //   print(
  //       "===================================trim=============================");
  //   var a = await FirebaseMessaging.instance;
  //   print(
  //       "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
  //   if (a != null) {
  //     Get.to(() => SettingsPage());
  //   }
  // }
  Future requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  @override
  void initState() {
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      Get.to(() => SettingsPage());
    });

    fbm.getToken().then(
      (value) {
        print("=====================================================");
        print(value);
        print("=====================================================");
      },
    );
    requestPermission();
    //getOn();
    getInt();
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
      ),
      initialRoute:
          _auth.currentUser == null ? Login.pageRoute : HomePage.pageRoute,
      routes: <String, WidgetBuilder>{
        Login.pageRoute: (context) => const Login(),
        Sign.pageRoute: (context) => const Sign(),
        HomePage.pageRoute: (context) => const HomePage(),
        AddNotes.pageRoute: (BuildContext context) => const AddNotes(),
        PasswordPage.pageRoute: (context) => const PasswordPage(),
        CreatePassowrd.pageRoute: (context) => const CreatePassowrd(),
        SettingsPage.pageRoute: (context) => const SettingsPage(),
        ChangeColor.pageRoute: (context) => const ChangeColor(),
      },
    );
  }
}
