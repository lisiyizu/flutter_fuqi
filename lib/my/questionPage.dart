import 'package:flutter/material.dart';


class questionPage extends StatelessWidget {

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
    return Scaffold(
      appBar: AppBar(
        title: Text("常见问题"),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                _buildTaskItem(Colors.green,"问:如何改头像","答:点击发布->修改头像"),
                _buildTaskItem(Colors.grey,"问:91视频在哪里看","答:点击发现->91视频"),
                _buildTaskItem(Colors.blue,"问:夫妻币有什么用?,如何获得?","答:查看一个联系方式或者聊天需要消耗一枚夫妻币,方式一:邀请夫妻加入,填写你的邀请码,即可获赠5枚夫妻币,方式二:联系客服充值,方式三:认证夫妻,前三个月每月赠送100枚"),
                _buildTaskItem(Colors.yellow,"问:在哪里获得我的邀请码","答:点击我->推广赚取夫妻币"),
                _buildTaskItem(Colors.pinkAccent,"问:夫妻如何认证","答:点击”我“,在头像下方查看ID,女方手持一张纸,纸上写你的ID,拍照给客服,即可开通,单男不需要认证"),
                _buildTaskItem(Colors.orange,"问:夫妻认证有什么用？","答:可以加精品夫妻群,点亮认证特效,大大提高交友成功率,可以免费获取3个月VIP权限,可以参加夫妻之家线下活动"),
                _buildTaskItem(Colors.blue,"问:VIP有什么用？","答:可以加夫妻群,参加线下活动,免费查看联系方式,详情:点击我->VIP权限说明"),
                _buildTaskItem(Colors.red,"问:如何充值？","答:点击我->客服,加客服微信或QQ,发红包即可,注明自己的ID"),
              ],

            )
      )],
    ));
  }
}