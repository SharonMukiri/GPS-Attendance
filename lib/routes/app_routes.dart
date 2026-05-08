import 'package:flutter/material.dart';

import '../presentation/attendance_screen/attendance_screen.dart';
import '../presentation/home_screen/home_screen.dart';
import '../presentation/sign_up_login_screen/sign_up_login_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String signUpLoginScreen = '/sign-up-login-screen';
  static const String attendanceScreen = '/attendance-screen';
  static const String homeScreen = '/home-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SignUpLoginScreen(),
    signUpLoginScreen: (context) => const SignUpLoginScreen(),
    attendanceScreen: (context) => const AttendanceScreen(),
    homeScreen: (context) => const HomeScreen(),
  };
}
