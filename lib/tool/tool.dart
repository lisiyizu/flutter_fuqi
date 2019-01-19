import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter_fuqi/constants.dart';
import 'package:flutter_fuqi/dio/dio.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_fuqi/modal/userData.dart';
import 'package:flutter_fuqi/modal/articleData.dart';

class tool {

  static SharedPreferences prefs;

  static String key = 'abcdefghij';

  static var myUserData;

  static String location = '全国';

  //屏幕高度
  static double screenHeight = 0.0;

  //用户信息
  static List<Map> userPageDatas=[
    Map(),
    Map(),
    Map(),
    Map(),
  ];
  //文章信息
  static List<Map> articlePageDatas=[
    Map(),
    Map(),
    Map(),
    Map(),
  ];

  //聊天信息
  static var converstation;

  static init(BuildContext context){
    //设置轮播图高度
    Constants.bannerImageHeight = MediaQuery.of(context).size.height ;
    Constants.bannerImageHeight = Constants.bannerImageHeight*0.4;
    if(Constants.bannerImageHeight>400){
      Constants.bannerImageHeight = 400;
    }

    //获取登录者的信息
    tool.getMyUserInfo(context: context);
    //检查版本
    tool.checkSysVersion(context);
  }

  static getMyUserInfo({id:-1,BuildContext context}) async {
    assert(prefs != null);
    var response;
    int myID;
    if (id == -1) {
      myID = await tool.prefs.get('id');
    }else{
      myID = id;
    }
    try{
      String url = "${Constants.host}/app/userDetail/$myID/";
      response = await dioTool.dio.get(url);
      myUserData = response.data;
      print("my id:${myUserData['id']},my name:${myUserData['name']}");
    }on DioError catch (e) {
      print("没有获取到自己的信息");
      showToast("网络异常");
      Navigator.of(context).pushNamed('/login');
    }
  }

  //检查系统版本
  static checkSysVersion(BuildContext context) async {
    var response;
    String version;
    String info;
    bool bForce;
    try{
      response = await dioTool.dio.get("${Constants.host}/app/version/");
      version = response.data[0]['version'];
      info = response.data[0]['info'];
      bForce = response.data[0]['bForce'];
      //强制更新
      if(bForce && version != Constants.version){
        Alert(
          context: context,
          type: AlertType.warning,
          title: "当前版本已不可用,必须更新",
          buttons: [
            DialogButton(
              child: Text(
                "立即更新",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.of(context).pushNamed('/update'),
              color: Color.fromRGBO(0, 179, 134, 1.0),
            ),
          ],
        ).show();
      }else if(version != Constants.version){
        Alert(
          context: context,
          type: AlertType.warning,
          title: "软件版本需要更新",
          desc: info,
          buttons: [
            DialogButton(
              child: Text(
                "暂不更新",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.of(context).pushNamed('/home'),
              gradient: LinearGradient(colors: [
                Color.fromRGBO(116, 116, 191, 1.0),
                Color.fromRGBO(52, 138, 199, 1.0)
              ]),
            ),
            DialogButton(
              child: Text(
                "立即更新",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.of(context).pushNamed('/update'),
              color: Color.fromRGBO(0, 179, 134, 1.0),
            )
          ],
        ).show();
      }else{
        Navigator.of(context).pushNamed('/home');
      }
    }on DioError catch (e) {
      showToast("网络异常");
    }
  }

  static Widget getProgressIndicator({info:'数据加载中...'}) {
//    return new Center(
//      // CircularProgressIndicator是一个圆形的Loading进度条
//      child: new CircularProgressIndicator(),
//    );
    return LoadingDialog(text:info);
  }
  //"2018-11-21T22:10:36.860805",
  static String processTime(String time){
    if(time.contains('T')){
      time=time.replaceFirst('T', ' ');
      time = time.substring(0,time.lastIndexOf(":"));
    }
    return time;
  }

  //转化为ID
  static String changeToID(String str){
    String ID='';
    int temp = -1;
    if (str == null || str.trim().length == 0){
      return '1960';
    }
    for(int i=0;i<str.length;i++){
      temp = key.indexOf(str.substring(i,i+1));
      if (temp == -1){
        return '1960';
      }else{
        ID+=temp.toString();
      }
    }
    print("真实邀请码:$ID");
    return ID;
  }

  static String getMyAdvertCode(){
    int id = tool.myUserData['id'];
    String temp = id.toString();
    String code='';
    for(int i=0;i < temp.length;i++){
      int temp2 = num.parse(temp.substring(i,i+1));
      code+=key.substring(temp2,temp2+1);
    }
    changeToID(code);
    return code;
  }

  static showToast(String msg) async {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 2,
        backgroundColor: Colors.white,
        textColor: Colors.black
    );
  }
  static showLongToast(String msg,int time) async {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: time,
        backgroundColor: Colors.white,
        textColor: Colors.red
    );
  }

  static getPersonInfo(var originConversation,bool bSelf){
    if(originConversation['receive_user']['id']==tool.myUserData['id']){
      return bSelf == true ? 'receive_user':'send_user';
    }else{
      return bSelf == true ? 'send_user':'receive_user';
    }
  }


}


//自定义dialog
class LoadingDialog extends Dialog {
  String text;

  LoadingDialog({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Material( //创建透明层
      type: MaterialType.transparency, //透明类型
      child: new Center( //保证控件居中效果
        child: new SizedBox(
          width: 120.0,
          height: 120.0,
          child: new Container(
            decoration: ShapeDecoration(
              color: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
            ),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new CircularProgressIndicator(),
                new Padding(
                  padding: const EdgeInsets.only(
                    top: 20.0,
                  ),
                  child: new Text(
                    text,
                    style: new TextStyle(
                      fontSize: 15.0, fontWeight:FontWeight.bold
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


