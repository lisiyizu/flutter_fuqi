import 'package:flutter/material.dart';
import 'package:flutter_fuqi/constants.dart';
import 'package:flutter_fuqi/modal/conversation.dart';
import 'package:flutter_fuqi/message/message_item.dart';
import 'package:flutter_fuqi/dio/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter_fuqi/tool/tool.dart';
import 'package:flutter_refresh/flutter_refresh.dart';


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
    _getConversations();//每次都获取最新数据
  }

  _getConversations() async {
    try{
      _conversations = await dioTool.dio.get('${Constants.host}/app/readConverstation/');
      _conversations = _conversations.data['results'];
      _mConversation=[];
      if(this.mounted){
        setState(() {
          _mConversation = Conversation.parseConversations(_conversations);
        });
        tool.converstation = _conversations;
        if(_mConversation == null){
          _mConversation = [];
        }
        if(_mConversation.length == 0){
          tool.showToast("您没有任何聊天记录");
        }
      }
      //tool.bGetNewConversation = false;//不再获取新的conversation
    }on DioError catch(e) {
      if (e.response != null && e.response.statusCode == 404){
        tool.showToast("已显示全部数据");
      }else if(e.response != null && e.response.statusCode == 401){
        //登录信息已经失效
        Navigator.of(context).pushNamed('/login');
        tool.showToast("密码已过期,请重新登录");
      } else{
        tool.showToast("网络不佳,请稍候再试");
      }
      return;
    }
  }

  Future<Null> onHeaderRefresh() {
    return new Future.delayed(new Duration(seconds: 5), () {
      //上拉刷新的时候永远找第一页
      _getConversations();//每次都获取最新数据
    });
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,//去掉返回箭头
          elevation: 0.0,
          centerTitle:true,
          title: Text('聊天'),
        ),
        body: new Refresh(
            onHeaderRefresh: onHeaderRefresh,
            childBuilder: (BuildContext context,
                {ScrollController controller, ScrollPhysics physics}) {
              return  ListView.builder(
                  itemCount: _mConversation.length,
                  itemBuilder: (BuildContext context,int index){
                return ConverSationItem(conversation: _mConversation[index],originConversation:_conversations[index]);
              });
            }));
  }
}