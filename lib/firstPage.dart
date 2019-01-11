import 'package:flutter/material.dart';
import 'package:flutter_fuqi/tool/tool.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_fuqi/dio/dio.dart';
import 'package:flutter_fuqi/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter_fuqi/home/homePage.dart';
import 'package:flutter_fuqi/auth/login.dart';


class firstPage extends StatefulWidget {

  @override
  _firstPageState createState() {
    // TODO: implement createState
    return _firstPageState();
  }
}

class _firstPageState extends State<firstPage>{

  bool _isProcessLogin = false;
  Widget _body;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isNeedLogin();
  }

  _isNeedLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tool.prefs = prefs;
    String token = await prefs.get('token');
    if (token==null){
      print("没有token,需要登录");
      Navigator.of(context).pushNamed('/login');
    }else{
      try{
        var response = await dioTool.dio.post('${Constants.host}/jwt-verify/',data:{'token': token});
        print("token有效,无需登录");
        dioTool.setHeadToken(token);
        //做一些初始化操作
        tool.init(context);
        Navigator.of(context).pushNamed('/home');
      }on DioError catch (e) {
        if(e.response.statusCode == 400){
           tool.showToast("token已过期,需要重新登录");
        }else{
           tool.showToast("机器维护中,请稍后再登录");
        }
        Navigator.of(context).pushNamed('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //登录判断没有处理的时候返回进度条
    return Scaffold(
      body: tool.getProgressIndicator(),
    );
  }
}