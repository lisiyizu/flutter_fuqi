import 'package:flutter/material.dart';
import 'package:flutter_fuqi/tool/tool.dart';
import '../constants.dart';

//每一条数据
class Conversation {

  const Conversation({
    @required this.title,
    @required this.avatar,
    this.titleColor : AppColors.TitleTextColor,//设置默认颜色
    this.des,
    this.updateAt,
    this.unreadMsgCount:0
  }):assert(avatar != null), assert(title != null);

  final String  avatar;//头像
  final String  title;//标题
  final String  des;//最新消息或简介
  final String  updateAt;//最新消息接收到的时间
  final int  titleColor;//标题颜色
  final int unreadMsgCount;//未读消息数量

  bool isAvatarFromNet() {
    if(this.avatar.indexOf('http') == 0 ||
        this.avatar.indexOf('https') == 0) {
      return true;
    }
    return false;
  }

  static parseConversations(var conversations){
    List<Conversation>  conversationData = [];
    for(int i=0;i<conversations.length;i++){
      var des='';
      var updateAt='';
      if(conversations[i]['converstation_message'].length > 0){
        des = conversations[i]['converstation_message'][0]['content'];
        updateAt = tool.processTime(conversations[i]['converstation_message'][0]['date']);
      }
      if(conversations[i]['receive_user']['id'] != tool.myUserData['id']){
        conversationData.add(Conversation(
            title: conversations[i]['receive_user']['name'],
            avatar:conversations[i]['receive_user']['head_img'],
            des:des,
            updateAt:updateAt,
            unreadMsgCount: conversations[i]['unReadCount_send']
        ));
      }else{
        conversationData.add(Conversation(
            title: conversations[i]['send_user']['name'],
            avatar:conversations[i]['send_user']['head_img'],
            des:des,
            updateAt:updateAt,
            unreadMsgCount: conversations[i]['unReadCount_receive']
        ));
      }
    }
    return conversationData;
}
}


