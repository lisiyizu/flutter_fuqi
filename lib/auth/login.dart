import 'package:flutter/material.dart';
import 'package:flutter_fuqi/dio/dio.dart';
import 'package:flutter_fuqi/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter_fuqi/tool/tool.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget{
  @override
  _LoginPageState createState() {
    // TODO: implement createState
    return _LoginPageState();
  }
}



class _LoginPageState extends State<LoginPage>{

  var _userPassController = new TextEditingController();
  var _userNameController = new TextEditingController();
  Response response;
  _login () async {
    try {
      String url = "${Constants.host}/jwt_login/";
      response = await dioTool.dio.post(url, data: {
        'username': _userNameController.text,
        'password': _userPassController.text
      });
      tool.showToast("登录成功");
      dioTool.setHeadToken(response.data['token']);
      await tool.prefs.setString('token', response.data['token']);
      await tool.prefs.setInt('id', response.data['id']);
      //先记录id,否则后面获取用户信息时会错误
      tool.init(context);
    } on DioError catch (e) {
      Alert(
        context: context,
        type: AlertType.info,
        title: "登录失败",
        desc: "用户名或密码错误",
        buttons: [
          DialogButton(
            child: Text(
              "确定",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            color: Color.fromRGBO(0, 179, 134, 1.0),
            radius: BorderRadius.circular(0.0),
          ),
        ],
      ).show();
    }
  }

  _toRegister() async {
    //先检查是否注册过
    String token = await tool.prefs.get('token');
    if(token != null){
      Alert(
        context: context,
        type: AlertType.info,
        title: "您已经注册过了",
        desc: "请直接登录",
        buttons: [
          DialogButton(
            child: Text(
              "确定",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            color: Color.fromRGBO(0, 179, 134, 1.0),
            radius: BorderRadius.circular(0.0),
          ),
        ],
      ).show();
    }else{
      Navigator.of(context).pushNamed('/signup');
    }

  }
  @override
  Widget build(BuildContext context) {
    //判断是否需要登录
      return Scaffold(
          appBar: AppBar(
            title: Text("夫妻之家"),
            centerTitle: true,
            automaticallyImplyLeading: false,//去掉返回箭头
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    child: Hero(
                        tag: "夫妻之家",
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 100.0,
                          child: Image.asset('assets/images/logo.png'),
                        )
                    )
                ),
                Container(
                  padding: EdgeInsets.only(top: 35.0,left: 20.0,right: 20.0),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        controller: _userNameController,
                        decoration: InputDecoration(
                            hintText: "请输入你的用户名",
                            labelText: "用户名",
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green)
                            )
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      TextField(
                        controller: _userPassController,
                        decoration: InputDecoration(
                            hintText: "请输入你的密码",
                            labelText: "密码",
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green)
                            )
                        ),
                        obscureText: true,//是否是密码
                      ),
                      Container(
                        padding: EdgeInsets.only(top:15.0,left: 20.0),
                        alignment: Alignment(1.0, 0),
                        child: InkWell(
                          onTap: (){
                            Navigator.of(context).pushNamed('/kefu');
                          },
                          child: Text("登录有问题",
                            style: TextStyle(
                                color: Colors.green,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline
                            ),),
                        ),
                      ),
                      SizedBox(height: 40.0),
                      GestureDetector(
                        onTap: (){
                          _login();
                        },
                        child: Container(
                          height: 40.0,
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            shadowColor: Colors.greenAccent,
                            color: Colors.green,
                            child: Center(
                                child: Text(
                                    '登录',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat'
                                    ))

                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "还没有账户?",
                            style: TextStyle(
                                fontFamily: 'Montserrat'
                            ),
                          ),
                          SizedBox(width: 5.0),
                          InkWell(
                            onTap: () {
                              _toRegister();
                            },
                            child: Text(
                              '去注册',
                              style: TextStyle(
                                  color: Colors.green,
                                  fontFamily:'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline
                              ),
                            ),
                          )

                        ],
                      )

                    ],
                  ),
                )
              ],
            ),
          )
      );
    }
}