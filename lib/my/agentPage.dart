import 'package:flutter/material.dart';
import 'package:flutter_fuqi/tool/tool.dart';



class agentPage extends StatefulWidget{
  @override
  _agentPageState createState() {
    // TODO: implement createState
    return _agentPageState();
  }
}

class _agentPageState extends State<agentPage>{

  int invitedNum = tool.myUserData['invitedNum'];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //实时获取数据
    if(tool.myUserData['is_agent']){
      _checkUserInfo();
    }
  }

  _checkUserInfo() async {
    int num = tool.myUserData['invitedNum'];
    await tool.getMyUserInfo(context:context,id:tool.myUserData['id']);
    if(num != tool.myUserData['invitedNum']){
      if(this.mounted){
        setState(() {
          invitedNum = tool.myUserData['invitedNum'];
        });
      }
    }
  }

  _buildTaskItem(var color,var quest,var ans){
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 10.0, right: 16.0,left: 16.0),
      padding: EdgeInsets.only(left: 8.0, top: 10.0, bottom: 10.0, right: 8.0),
      decoration: new BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: color,
            width: 0.5,
          )
      ),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Text(quest,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 19.0,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(ans,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if(tool.myUserData['is_agent'] == true){
      return Scaffold(
        appBar: AppBar(
          title: Text("代理商佣金实时统计"),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.only(top: 30.0,left: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("邀请好友注册佣金:$invitedNum元",style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),textAlign: TextAlign.start,),
              Divider(),
              Text("您邀请的好友开会员时客服会立刻转账给代理商",style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20.0),),
            ],
          ),
        ),
      );
    }else{
      return Scaffold(
          appBar: AppBar(
            title: Text("如何成为夫妻之家代理商"),
            centerTitle: true,
          ),
          body: ListView(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      _buildTaskItem(Colors.blue,"问:代理商怎么获取收益","答:邀请一个好友注册,可折现1元,您邀请的好友开通会员,平台给您返现25%的会员价"),
                      _buildTaskItem(Colors.green,"问:代理商有什么要求没有","答:您需要向客服证明您在夫妻交友行业拥有大量的资源,比如众多QQ群"),
                      _buildTaskItem(Colors.orange,"问:如何成为代理商","答:点击我-联系客服,向客服申请即可"),
                      _buildTaskItem(Colors.yellow,"问:夫妻之家什么时候付款","答:每当有您邀请的会员开通时,立即支付25%会员价,当您成为代理商后重新点击本页面,可实时获取您的邀请人数,随时找客服折现"),
                    ],
                  )
              )],
          ));
    }
  }
}