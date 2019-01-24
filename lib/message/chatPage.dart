import 'package:flutter/material.dart';
import 'package:flutter_fuqi/modal/conversation.dart';
import 'package:flutter_fuqi/tool/tool.dart';
import 'package:flutter_fuqi/message/chat_item.dart';
import 'package:flutter_fuqi/dio/dio.dart';
import 'package:flutter_fuqi/constants.dart';
import 'package:dio/dio.dart';


class chatPage extends StatefulWidget {

  var originConversation;

  chatPage({Key key,@required this.originConversation}):super(key:key);

  @override
  _chatPageState createState() {
    // TODO: implement createState
    return _chatPageState();
  }
}

class _chatPageState extends State<chatPage> {

  final TextEditingController _textController = new TextEditingController();

  Future _handleSubmitted(String text) async {
    if(text == null || text.length == 0 || text.trim() == 0){
      tool.showToast("发送内容不能为空");
      return;
    }
    _textController.clear();
    try {
      var response = await dioTool.dio.post('${Constants.host}/app/message/',
          data: {
            'content': text,
            'converstation_id': widget.originConversation['id']
          });
      //更新聊天信息和刷新未读次数
      _getConversation();
    }on DioError catch(e) {
      if(e.response.statusCode == 401){
        //登录信息已经失效
        tool.showToast("登录信息已失效");
        Navigator.of(context).pushNamed('/login');
      } else{
        tool.showToast("网络不佳,请稍候再试");
      }
      return;
    }
  }

  _getConversation() async {
    try{
      var response = await dioTool.dio.get('${Constants.host}/app/readConverstation/${widget.originConversation['id']}/');
      if(this.mounted){
        setState(() {
          widget.originConversation = response.data;
          for(int i= 0;i<tool.converstation.length;i++){
            if(tool.converstation[i]['id'] == response.data['id']){
              tool.converstation[i]['id'] = response.data['id'];
            }
          }
        });
      }
      //_scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 1000),curve:Curves.ease);
    }on DioError catch(e) {
      if(e.response.statusCode == 401){
        //登录信息已经失效
        tool.showToast("登录信息已失效");
        Navigator.of(context).pushNamed('/login');
      } else{
        tool.showToast("网络不佳,请稍候再试");
      }
      return;
    }
  }

  Widget _buildTextComposer() {
    return new IconTheme(
        data: new IconThemeData(color: Theme.of(context).accentColor),
        child: new Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: new Row(children: <Widget>[
              new Flexible(
                  child: new TextField(
                    controller: _textController,
                    onSubmitted: _handleSubmitted,
                    decoration: new InputDecoration.collapsed(hintText: '发送消息'),
                  )
              ),
              new Container(
                margin: new EdgeInsets.symmetric(horizontal: 4.0),
                child: new IconButton(
                    icon: new Icon(Icons.send),
                    onPressed: (){
                        _handleSubmitted(_textController.text);
                      }
                    )
              )
            ]))
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //访问conversation,刷新未读次数
    _getConversation();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.originConversation[tool.getPersonInfo(widget.originConversation,false)]['name']),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              reverse: true,
              itemCount: widget.originConversation['converstation_message'].length,
              itemBuilder: (context,index){
                return chatItem(originConversation:widget.originConversation,index:index);
              },
            ),
          ),
          Divider(height: 1.0),
          Container(
            decoration: new BoxDecoration(
              color: Colors.white,
            ),
            child: _buildTextComposer(),
          )
        ],
      )
    );
  }

}