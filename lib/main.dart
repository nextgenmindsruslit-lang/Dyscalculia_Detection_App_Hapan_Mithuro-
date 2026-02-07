import 'package:dyscaculia_project/presentation/activities/activity12second.dart';
import 'package:flutter/material.dart';
import 'package:dyscaculia_project/presentation/splash_screen/splash_screen.dart';
import 'package:dyscaculia_project/presentation/auth/signup_screen.dart';
import 'package:dyscaculia_project/presentation/auth/login_screen.dart';
import 'package:dyscaculia_project/presentation/auth/forgot_password_screen.dart';
import 'package:dyscaculia_project/presentation/dashboard/dashboard_screen.dart';
import 'package:dyscaculia_project/presentation/dashboard/add_child_screen.dart';
import 'package:dyscaculia_project/presentation/dashboard/edit_child_screen.dart';
// import 'package:dyscaculia_project/presentation/dashboard/view_report_select_screen.dart';
//import 'package:dyscaculia_project/presentation/dashboard/view_report_detail_screen.dart';
import 'package:dyscaculia_project/presentation/activities/activity1.dart';
import 'package:dyscaculia_project/presentation/activities/activity2.dart';
import 'package:dyscaculia_project/presentation/activities/activity3.dart';
import 'package:dyscaculia_project/presentation/activities/activity4.dart';
import 'package:dyscaculia_project/presentation/activities/activity5.dart';
import 'package:dyscaculia_project/presentation/activities/activity6.dart';
import 'package:dyscaculia_project/presentation/activities/activity7.dart';
import 'package:dyscaculia_project/presentation/activities/activity8.dart';
import 'package:dyscaculia_project/presentation/activities/activity9.dart';
import 'package:dyscaculia_project/presentation/activity completion/activity_completion.dart';
import 'package:dyscaculia_project/presentation/auth/loginback.dart';
import 'package:dyscaculia_project/presentation/activities/activity10.dart';
import 'package:dyscaculia_project/presentation/activities/activity11.dart';
import 'package:dyscaculia_project/presentation/activities/activity11second.dart';
import 'package:dyscaculia_project/presentation/activities/activity12.dart';
// ignore: duplicate_import
import 'package:dyscaculia_project/presentation/activities/activity12second.dart';
import 'package:dyscaculia_project/presentation/activities/activity13.dart';
import 'package:dyscaculia_project/presentation/activities/activity13second.dart';




void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 18),
        ),
      ),

      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/forgot': (context) => const ForgotPasswordScreen(),
        '/dashboard': (context) => const DashboardScreen(userName: '',),
        '/add-child': (context) => const AddChildScreen(),
        '/edit-child': (context) => const EditChildScreen(),
        
        //'/view-report-detail': (context) => const ViewReportDetailScreen(),
        '/activity-1': (context) => const Activity1(),  
        '/activity-2': (context) => const Activity2(),
        '/activity-3': (context) => const Activity3(),
        '/activity-4': (context) => const Activity4(),
        '/activity-5': (context) => const Activity5(),
        '/activity-6': (context) => const Activity6(),
        '/activity-7': (context) => const Activity7(),
        '/activity-8': (context) => const Activity8(),
        '/activity-9': (context) => const Activity9(),
        '/activity-completion': (context) => const ActivityCompletion(),
        '/loginback': (context) => const LoginBackScreen(),
        '/activity-10': (context) => const Activity10Screen(),
        '/activity-11': (context) => const Activity11Screen(),
        '/activity-11-second': (context) => const Activity11Second(),
        '/activity-12': (context) => const Activity12(),
        '/activity-12-second': (context) => const Activity12Second(),
        '/activity-13': (context) => const Activity13(),
        '/activity-13-second': (context) => const Activity13Second(),
        
       

        

      }, 
    );
  }
}