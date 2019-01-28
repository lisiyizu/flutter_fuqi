import 'package:flutter/material.dart';
import 'package:flutter_fuqi/constants.dart' show AppColors;
import 'package:flutter_fuqi/home/homePage.dart';
import 'package:flutter_fuqi/auth/login.dart';
import 'package:flutter_fuqi/auth/signUp.dart';
import 'package:flutter_fuqi/constants.dart';
import 'package:flutter_fuqi/firstPage.dart';
import 'package:flutter_fuqi/fuqi/user_detail.dart';
import 'package:flutter_fuqi/publish/publishPage.dart';
import 'package:flutter_fuqi/discover/discoverPage.dart';
import 'package:flutter_fuqi/my/kefuPage.dart';
import 'package:flutter_fuqi/update/updatePage.dart';
import 'package:flutter_fuqi/my/questionPage.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: '夫妻之家',
      theme: ThemeData.light().copyWith(
          primaryColor: Color(AppColors.AppBarColor),
          cardColor: Color(AppColors.AppBarColor)//调整搜索下拉框的颜色
      ),
      routes: <String,WidgetBuilder>{
        '/signup':(BuildContext context) => SignUpPage(),
        '/login':(BuildContext context) => LoginPage(),
        '/home':(BuildContext context) => HomePage(),
        '/discover':(BuildContext context) => discoverPage(),
        '/publish':(BuildContext context) => publishPage(),
        '/kefu':(BuildContext context) => kefuPage(),
        '/update':(BuildContext context) => updatePage(),
        '/question':(BuildContext context) => questionPage(),
      },
      home: firstPage(),
      //home: HomePage(),
    );
  }
}