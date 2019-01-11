import 'package:flutter/material.dart';
import 'package:flutter_fuqi/constants.dart';
import 'package:flutter_fuqi/modal/conversation.dart';
import 'package:flutter_fuqi/message/message_item.dart';
import 'package:flutter_fuqi/dio/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter_fuqi/tool/tool.dart';


class messagePage extends StatefulWidget{

  @override
  _messagePageState createState() {
    // TODO: implement createState
    return _messagePageState();
  }

}

class _messagePageState extends State<messagePage> {

  var _conversations;
  List<Conversation> _mConversation=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(tool.converstation == null){
      _getConversations();
    }else{
      _mConversation = tool.converstation;
      _conversations = tool.converstation;
    }
  }

  _getConversations() async {
    try{
      _conversations = await dioTool.dio.get('${Constants.host}/app/readConverstation/');
      _conversations = _conversations.data['results'];
      _mConversation=[];
      if(this.mounted){
        setState(() {
          for(int i=0;i<_conversations.length;i++){
            var des='';
            var updateAt='';
            if(_conversations[i]['converstation_message'].length > 0){
              des = _conversations[i]['converstation_message'][0]['content'];
              updateAt = tool.processTime(_conversations[i]['converstation_message'][0]['date']);
            }
            if(_conversations[i]['receive_user']['id'] != tool.myUserData['id']){
              _mConversation.add(Conversation(
                  title: _conversations[i]['receive_user']['name'],
                  avatar:_conversations[i]['receive_user']['head_img'],
                  des:des,
                  updateAt:updateAt,
                  unreadMsgCount: _conversations[i]['unReadCount_send']
              ));
            }else{
              _mConversation.add(Conversation(
                  title: _conversations[i]['send_user']['name'],
                  avatar:_conversations[i]['send_user']['head_img'],
                  des:des,
                  updateAt:updateAt,
                  unreadMsgCount: _conversations[i]['unReadCount_receive']
              ));
            }
          }
        });
        tool.converstation = _mConversation;
      }
    }on DioError catch(e) {
      if (e.response.statusCode == 404){
        tool.showToast("已显示全部数据");
      }else if(e.response.statusCode == 401){
        //登录信息已经失效
        Navigator.of(context).pushNamed('/login');
        tool.showToast("登录信息已失效");
      } else{
        tool.showToast("网络不佳,请稍候再试");
      }
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if(_conversations == null){
      return tool.getProgressIndicator();
    }else{
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,//去掉返回箭头
          elevation: 0.0,
          centerTitle:true,
          title: Text('聊天'),
        ),
        body: ListView.builder(
            itemCount: _mConversation.length,
            itemBuilder: (BuildContext context,int index){
              return ConverSationItem(conversation: _mConversation[index],originConversation:_conversations[index]);
            }
        ),
      );
    }
  }
}