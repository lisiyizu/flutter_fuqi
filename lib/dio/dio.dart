import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../constants.dart';
import '../modal/userData.dart';

class dioTool {

  static Dio dio = new Dio();

  //设置Head Token
  static setHeadToken(String token){
    dio.options.headers['Authorization'] = 'JWT $token';
  }

}




