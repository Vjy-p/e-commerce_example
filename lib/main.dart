import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:firebase_testing/controller/userController/user_controller.dart';
import 'package:firebase_testing/models/hive_address_model.dart';
import 'package:firebase_testing/models/hive_cart_model.dart';
import 'package:firebase_testing/models/hive_order_model.dart';
import 'package:firebase_testing/screens/auth/mobile_login.dart';
import 'package:firebase_testing/screens/homepage/homepage.dart';
import 'package:firebase_testing/services/notificationServices/notification_services.dart';
import 'package:firebase_testing/services/userServices/user_services.dart';
import 'package:firebase_testing/utils/colors.dart';
import 'package:firebase_testing/utils/constants.dart';
import 'package:firebase_testing/utils/custom_text.dart';

const String cartStore = 'cartDB';
const String userStore = 'userDB';
const String orderStore = 'orderDB';

void main() {
  init();
  runApp(const MyApp());
}

// class App extends StatefulWidget {
//   const App({super.key});

//   @override
//   State<App> createState() => _AppState();
// }

// class _AppState extends State<App> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//       designSize: const Size(393, 852),
//       ensureScreenSize: true,
//       builder: (context, child) {
//         return MaterialApp(debugShowCheckedModeBanner: false, home: child);
//       },
//       child: ChatScreen(),
//     );
//   }
// }

Future init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var dir = await getApplicationDocumentsDirectory();
  var path = "${dir.path}/localdata";
  debugPrint("\npath: $path");

  Hive
    ..init(path)
    ..registerAdapter(HiveCartModelAdapter())
    ..registerAdapter(HiveOrderModelAdapter())
    ..registerAdapter(HiveAddressModelAdapter());

  await Hive.openBox(userStore);
  await Hive.openBox<HiveCartModel>(cartStore);
  await Hive.openBox<HiveOrderModel>(orderStore);
  await Hive.openBox<HiveAddressModel>('address');

  NotificationServices().init();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    NotificationServices().initialise();
  }

  @override
  Widget build(BuildContext context) {
    return FirebasePhoneAuthProvider(
      child: ScreenUtilInit(
        designSize: const Size(393, 852),
        ensureScreenSize: true,
        builder: (context, snapshot) {
          return GetMaterialApp(
            navigatorKey: navigatorKey,
            title: Constants.appName,
            theme: ThemeData(
                useMaterial3: true,
                primaryColor: primary,
                colorScheme: ColorScheme.fromSeed(seedColor: primary),
                appBarTheme: AppBarTheme(
                    backgroundColor: primary,
                    titleTextStyle: customTextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                    ),
                    systemOverlayStyle: SystemUiOverlayStyle(
                      statusBarColor: transparent,
                    ))),
            debugShowCheckedModeBanner: false,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final userController = Get.put(UserController());

  @override
  initState() {
    super.initState();

    navigate();
  }

  navigate() {
    Future.delayed(const Duration(seconds: 2), () async {
      final number = await userController.getMobileNumber();
      userController.getUserName();
      var token = await UserServices().getToken();
      debugPrint("\nnumber $number\n token: $token");
      FirebaseAuth.instance.authStateChanges().listen((user) {
        debugPrint("\nuser $user");

        if (user != null && user.phoneNumber == number) {
          // Navigator.of(context)
          //     .push(MaterialPageRoute(builder: (context) => Homepage()));
          Get.off(Homepage());
        } else {
          // Get.off(const MobileLogin());
          Get.off(Homepage());
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Shimmer(
                gradient: LinearGradient(colors: [primary, amber, orange]),
                child: customText(
                  text: Constants.appName,
                  fontSize: 50.sp,
                  color: primary,
                  fontWeight: FontWeight.w700,
                )),
            SizedBox(
              height: 30.h,
            ),
            customText(
              text: "Shopping at yout fingertip..",
              fontSize: 18.sp,
            ),
          ],
        ),
      ),
    );
  }
}
