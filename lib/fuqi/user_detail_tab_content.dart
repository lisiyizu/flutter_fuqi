import 'package:flutter/material.dart';
import 'package:flutter_fuqi/tool/tool.dart';
import 'package:flutter_fuqi/constants.dart';
import 'package:flutter_fuqi/fuqi/user_dynamic_item.dart';
import 'package:dio/dio.dart';
import 'package:flutter_fuqi/dio/dio.dart';
import 'package:flutter_fuqi/message/chatPage.dart';


class UserDtailTabContent extends StatelessWidget {
  final String tag;
  var userDetail;

  UserDtailTabContent({Key key,@required this.tag,@required this.userDetail}):super(key:key);

  Widget _getDynamicContent(var userDetail){
    if (userDetail['user_dynamic'].length == 0){
      return userDynamicItem(des:userDetail['desc'],time:tool.processTime(userDetail['buy_time']));
    }else{
      return ListView.builder(
          itemCount: userDetail['user_dynamic'].length,
          itemBuilder: (BuildContext context,int index) {
            return userDynamicItem(des:userDetail['user_dynamic'][index]['content'], time: tool.processTime(userDetail['user_dynamic'][index]['date']));
          });
    }
  }

  Widget _getQQContent(BuildContext context,var userDetail){
    String qq = userDetail['qq'];
    String weixin = userDetail['weixin'];
    return  Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child:Row(
                children: <Widget>[
                  Icon(IconData(0xe605,fontFamily: Constants.IconFontFamily)),
                  Container(width: 10.0,),
                  Text(qq)
                ]),
            ),
            Divider(),
            Container(
              alignment: Alignment.centerLeft,
              child:Row(
                  children: <Widget>[
                    Icon(IconData(0xe768,fontFamily: Constants.IconFontFamily)),
                    Container(width: 10.0,),
                    Text(weixin)
                  ]),
            ),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (tag == "动态") {
      return _getDynamicContent(userDetail);
    }else if(tag == "聊天") {
      return Text("点击聊天可以在线聊天");
    } else{
      return _getQQContent(context,userDetail);
    }
  }
}
