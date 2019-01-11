import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../constants.dart';
import '../modal/userData.dart';

class dioTool {

  static Options options= new Options(
      connectTimeout:300000,//5分钟
      receiveTimeout:30000,//5分钟
  );

  static Dio dio = new Dio(options);

  //设置Head Token
  static setHeadToken(String token){
    dio.options.headers['Authorization'] = 'JWT $token';
    //dio.options.headers['Accept'] = 'application/json';
  }

}




