import 'package:get/get.dart';
import 'package:pagedrop/Views/BottomMenu/bottom_manu_wrappers.dart';

import '../Views/Feature/SplashScreen/splash_screen.dart';

class AppRoutes{
  static String splashScreen="/splash_screen";
  static String welcomeScreen="/welcome_screen";
  static String signUp="/sign_up_screen";
  static String subscriptions="/subscriptions";
  static String jobsScreen="/jobs";
  static String bottomMenuwrapper="/bottom_menu_wrapper";
  static String notifications="/notifications";


  static List<GetPage>page=[
    GetPage(name: splashScreen, page: ()=> SplashScreen()),
    // GetPage(name:welcomeScreen , page: ()=> WelcomeScreen()),
    // GetPage(name:signUp , page: ()=> SignUpScreen()),
    // GetPage(name:subscriptions , page: ()=> Subscriptions()),
    // GetPage(name:bottomMenuwrapper , page: ()=> BottomMenuWrappers()),
    // GetPage(name:notifications , page: ()=> Notifications()),

  ];

}