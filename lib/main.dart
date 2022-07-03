import 'package:flutter/material.dart';
import 'package:shop_app/modules/Login/LoginScreen.dart';
import 'package:shop_app/shared/dio_helper.dart';
import 'package:shop_app/shared/network/shared_pref.dart';

import 'modules/onboarding_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  // Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await DioHelper.init();

  bool onBoarding = CacheHelper.getData(key: 'onBoarding');

  print(onBoarding);

  runApp(MyApp(
    onBoarding: onBoarding,
  ));
}

class MyApp extends StatelessWidget {

  final bool? onBoadring;

  MyApp({this.onBoadring});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            // foregroundColor: Colors.black//here you can give the text color
        ),
        // backgroundColor: Colors.white,
        // primarySwatch: Colors.deepOrange,
      ),
      debugShowCheckedModeBanner: false,
      home:  onBoarding ? LoginScreen() :  OnBoardingScreen(),
    );
  }
}

