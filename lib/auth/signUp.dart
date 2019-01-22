import 'package:flutter/material.dart';
import 'package:flutter_fuqi/constants.dart';
import 'package:flutter_fuqi/tool/tool.dart';
import 'package:flutter_fuqi/dio/dio.dart';
import 'package:dio/dio.dart';


class SignUpPage extends StatefulWidget{

  @override
  _SignUpPageState createState() {
    // TODO: implement createState
    return _SignUpPageState();
  }
}

//用户注册
class UserRegisterData {
  static String inviteCode;//邀请码
  static String name;//昵称
  static String userName;//账户
  static String userPassword;//密码
  static String desc;//描述
  static String sex;//性别
  static String target;//寻找
  static String qq;
  static String weiXin;
  static String province;
  static String city;
  static int age;
}

class _SignUpPageState extends State<SignUpPage> {
  String _sex = "夫妻/情侣";
  String _target = "夫妻/情侣";
  String _age = "25";
  String _province = "北京";
  String _checkPassword = "";

  final List<String> _allSexChoices = <String>['夫妻/情侣', '男性', '女性'];
  final List<String> _allAgeChoices = <String>[
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '24',
    '25',
    '26',
    '27',
    '28',
    '29',
    '30',
    '31',
    '32',
    '33',
    '34',
    '35',
    '36',
    '37',
    '38',
    '39',
    '40',
    '41',
    '42',
    '43',
    '44',
    '45',
    '46',
    '47',
    '48',
    '49',
    '50',
    '51',
    '52',
    '53',
    '54',
    '55',
    '56',
    '57',
    '58',
    '59',
    '60',
    '61',
    '62',
    '63',
    '64',
    '65'
  ];

  _submit() async {
    //注册成功去登录
    Response response;
    String msg;
    try {
      //使用默认的时候,由于没有变化,导致没有赋值
      if (UserRegisterData.sex == null) {
        UserRegisterData.sex = _sex;
      }
      if (UserRegisterData.age == null) {
        UserRegisterData.age = num.parse(_age);
      }
      if (UserRegisterData.target == null) {
        UserRegisterData.target = _target;
      }
      if (UserRegisterData.province == null) {
        UserRegisterData.province = _province;
      }

      showDialog(
          context: context, child: tool.getProgressIndicator(info: "数据上传中..."));
      response =
      await dioTool.dio.post('${Constants.host}/app/useRegister/', data: {
        'name': UserRegisterData.name,
        'username': UserRegisterData.userName,
        'password': UserRegisterData.userPassword,
        'desc': UserRegisterData.desc,
        'sex': UserRegisterData.sex,
        'target': UserRegisterData.target,
        'province': UserRegisterData.province,
        'city': UserRegisterData.city,
        'age': UserRegisterData.age,
        'qq': UserRegisterData.qq,
        'weixin': UserRegisterData.weiXin,
        'code': tool.changeToID(UserRegisterData.inviteCode)});
      Navigator.of(context).pop();
      tool.showToast("注册成功,请返回登录");
    } on DioError catch (e) {
      if (e.response.statusCode == 400) {
        if (e.response.data['non_field_errors'] != null) {
          msg = "您之前在网站或APP上注册过,请直接登录";
          Navigator.of(context).pushNamed('/login');
        } else {
          msg = '用户名已存在,请修改用户名';
        }
      } else {
        msg = "注册失败,请稍后再试";
      }
      msg += ',错误编码:${e.response.statusCode}';
      tool.showLongToast(msg, 5);
    }
  }

  _checkRegisterData() {
    if (UserRegisterData.name == null || UserRegisterData.name
        .trim()
        .length == 0) {
      showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text('昵称格式错误'),
              ));
      return false;
    }
    if (UserRegisterData.userName == null || UserRegisterData.userName
        .trim()
        .length == 0) {
      showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text('用户名格式错误'),
              ));
      return false;
    }
    if (UserRegisterData.userName == null || UserRegisterData.userName
        .trim()
        .length == 0) {
      showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text('用户名格式错误'),
              ));
      return false;
    }
    if (UserRegisterData.userPassword == null || UserRegisterData.userPassword
        .trim()
        .length == 0) {
      showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text('密码格式错误'),
              ));
      return false;
    }
    if (UserRegisterData.userPassword != _checkPassword) {
      showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text('两次密码不一样,请重新输入密码'),
              ));
      return false;
    }
    if (UserRegisterData.desc == null || UserRegisterData.desc
        .trim()
        .length == 0) {
      showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text('简介格式错误'),
              ));
      return false;
    }
    if (UserRegisterData.qq == null || UserRegisterData.qq
        .trim()
        .length == 0) {
      showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text('qq格式错误'),
              ));
      return false;
    }
    if (UserRegisterData.weiXin == null || UserRegisterData.weiXin
        .trim()
        .length == 0) {
      showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text('微信号码格式错误'),
              ));
      return false;
    }
    if (UserRegisterData.city == null || UserRegisterData.city
        .trim()
        .length == 0) {
      showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text('城市格式错误'),
              ));
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("夫妻之家"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 20.0),
                alignment: Alignment.center,
                child: Text("欢迎加入", style: TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.bold),),

              ),
              Container(
                padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(
                          labelText: "邀请码",
                          hintText: '请输入您的邀请码',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.red
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green)
                          )
                      ),
                      onChanged: (String str) {
                        UserRegisterData.inviteCode = str;
                      },
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    TextField(
                      decoration: InputDecoration(
                          hintText: '请输入你的昵称(非登录账户)',
                          labelText: "昵称(非登录账户)",
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green)
                          )
                      ),
                      onChanged: (String str) {
                        UserRegisterData.name = str;
                      },
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    TextField(
                      decoration: InputDecoration(
                          labelText: "用户名(登录账户)",
                          hintText: '请输入你的用户名(登录账户)',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green)
                          )
                      ),
                      onChanged: (String str) {
                        UserRegisterData.userName = str;
                      },
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    TextField(
                      decoration: InputDecoration(
                          hintText: '请输入您账户密码)',
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
                      obscureText: true,
                      onChanged: (String str) {
                        UserRegisterData.userPassword = str;
                      },
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    TextField(
                      decoration: InputDecoration(
                          hintText: '请再输入一次密码)',
                          labelText: "确认密码",
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green)
                          )
                      ),
                      obscureText: true,
                      onChanged: (String str) {
                        _checkPassword = str;
                      },
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    TextField(
                      decoration: InputDecoration(
                          labelText: "简介",
                          hintText: '请介绍一下自己的情况',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green)
                          )
                      ),
                      onChanged: (String str) {
                        UserRegisterData.desc = str;
                      },
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    InputDecorator(
                      decoration: const InputDecoration(
                        labelText: '性别',
                        hintText: '夫妻/男/女/情侣',
                        contentPadding: EdgeInsets.zero,
                      ),
                      isEmpty: _sex == null,
                      child: DropdownButton<String>(
                        value: _sex,
                        isExpanded: true,
                        onChanged: (String newValue) {
                          setState(() {
                            _sex = newValue;
                            UserRegisterData.sex = _sex;
                          });
                        },
                        items: _allSexChoices.map<DropdownMenuItem<String>>((
                            String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    InputDecorator(
                      decoration: const InputDecoration(
                        labelText: '寻找',
                        hintText: '夫妻/男/女/情侣',
                        contentPadding: EdgeInsets.zero,
                      ),
                      isEmpty: _target == null,
                      child: DropdownButton<String>(
                        value: _target,
                        isExpanded: true,
                        onChanged: (String newValue) {
                          setState(() {
                            _target = newValue;
                            UserRegisterData.target = _target;
                          });
                        },
                        items: _allSexChoices.map<DropdownMenuItem<String>>((
                            String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    InputDecorator(
                      decoration: const InputDecoration(
                        labelText: '年龄',
                        hintText: '请选择16-65岁之间的数字',
                        contentPadding: EdgeInsets.zero,
                      ),
                      isEmpty: _age == null,
                      child: DropdownButton<String>(
                        value: _age,
                        isExpanded: true,
                        onChanged: (String newValue) {
                          setState(() {
                            _age = newValue;
                            UserRegisterData.age = num.parse(_age);
                          });
                        },
                        items: _allAgeChoices.map<DropdownMenuItem<String>>((
                            String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    InputDecorator(
                      decoration: const InputDecoration(
                        labelText: '省份',
                        hintText: '请输入您所在的省份',
                        contentPadding: EdgeInsets.zero,
                      ),
                      isEmpty: _province == null,
                      child: DropdownButton<String>(
                        value: _province,
                        isExpanded: true,
                        onChanged: (String newValue) {
                          setState(() {
                            _province = newValue;
                            UserRegisterData.province = _province;
                          });
                        },
                        items: Provinces.map<DropdownMenuItem<String>>((
                            String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    TextField(
                      decoration: InputDecoration(
                          labelText: "城市",
                          hintText: '请输入您所在的城市',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green)
                          )
                      ),
                      onChanged: (String str) {
                        UserRegisterData.city = str;
                      },
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    TextField(
                      decoration: InputDecoration(
                          labelText: "QQ",
                          hintText: '请输入您的QQ',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green)
                          )
                      ),
                      onChanged: (String str) {
                        UserRegisterData.qq = str;
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(
                          labelText: "微信",
                          hintText: '请输入您的微信',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green)
                          )
                      ),
                      onChanged: (String str) {
                        UserRegisterData.weiXin = str;
                      },
                    ),
                    SizedBox(height: 40.0),
                    GestureDetector(
                      onTap: () {
                        if (_checkRegisterData()) {
                          _submit();
                          tool.getProgressIndicator();
                        }
                      },
                      child: Container(
                        height: 40.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.greenAccent,
                          color: Colors.green,
                          child: Center(
                              child: Text(
                                  '注册',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat'
                                  ))

                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40.0),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}


