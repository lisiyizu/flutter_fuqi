import 'package:flutter/material.dart';
import 'package:flutter_fuqi/constants.dart';
import 'package:flutter_fuqi/tool/tool.dart';
import 'package:flutter_fuqi/fuqi/user_detail.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_fuqi/my/advertPage.dart';
import 'package:flutter_fuqi/my/vipPage.dart';
import 'package:flutter_fuqi/my/kefuPage.dart';
import 'package:flutter_fuqi/my/questionPage.dart';
import 'package:flutter_fuqi/my/softwarePage.dart';


class myInfoPage extends StatefulWidget {

  @override
  _myInfoPageState createState() {
    // TODO: implement createState
    return _myInfoPageState();
  }
}

class _myInfoPageState extends State<myInfoPage> {
  var titles = ["常见问题(必读)","我的资料", "我的钱包", "推广赚夫妻币", "VIP权限说明","联系客服","软件更新","退出登录"];
  var icons = [0xe69c,0xe634,0xe600,0xe622,0xe614,0xe635,0xe625,0xe799];
  static const double IMAGE_ICON_WIDTH = 30.0;
  static const double ARROW_ICON_WIDTH = 16.0;
  var titleTextStyle = new TextStyle(fontSize: 16.0);
  var firstTextStyle = new TextStyle(fontSize: 16.0,color: Colors.red,fontWeight: FontWeight.bold);
  var _body;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(tool.myUserData != null){
      _body  = new ListView.builder(
        itemCount: titles.length * 2,
        itemBuilder: (context, i) => _renderRow(i),
      );
    }else{
      _body = tool.getProgressIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,//去掉返回箭头
        elevation: 0.0,
        centerTitle:true,
        title: Text('我的详情'),
      ),
      body: _body,
    );
  }
  _handleListItemClick(String title) async {
    if(title == '我的资料'){
      Navigator.push(context,MaterialPageRoute(builder: (BuildContext ctx){
        return UserDetail(id:tool.myUserData['id']);
      }));
    }else if(title == '我的钱包'){
      //实时获取数据
      await tool.getMyUserInfo(context:context,id:tool.myUserData['id']);
      Alert(
        context: context,
        type: AlertType.info,
        title: "我的钱包",
        desc: "剩余夫妻币:${tool.myUserData['free_count']}",
        buttons: [
          DialogButton(
            child: Text(
              "确定",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            width: 120,
          )
        ],
      ).show();
    }else if(title == '推广赚夫妻币'){
      Navigator.push(context,MaterialPageRoute(builder: (BuildContext ctx){
        return advertPage();
      }));
    }else if(title == "VIP权限说明"){
      Navigator.push(context,MaterialPageRoute(builder: (BuildContext ctx){
        return vipPage();
      }));
    }else if(title == "联系客服"){
      Navigator.push(context,MaterialPageRoute(builder: (BuildContext ctx){
        return kefuPage();
      }));
    }else if(title == "常见问题(必读)"){
      Navigator.push(context,MaterialPageRoute(builder: (BuildContext ctx){
        return questionPage();
      }));
    }else if(title == "退出登录"){
      Navigator.of(context).pushNamed('/login');
    }else if(title == "软件更新"){
      Navigator.push(context,MaterialPageRoute(builder: (BuildContext ctx){
        return softwarePage();
      }));
    }
  }
  _renderRow(i) {
    if (i == 0) {
      var avatarContainer = new Container(
        color: Color(AppColors.AppBarColor),
        height: 200.0,
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
                  new Container(
                width: 100.0,
                height: 100.0,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  image: new DecorationImage(
                      image: new NetworkImage(tool.myUserData['head_img']),
                      fit: BoxFit.cover),
                  border: new Border.all(
                    color: Colors.white,
                    width: 2.0,
                  ),
                ),
              ),
              new Text(
                tool.myUserData['name'],
                style: new TextStyle(color: Colors.white, fontSize: 16.0),
              ),
              new Text(
                "ID:${tool.myUserData['id']}139",
                style: new TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            ],
          ),
        ),
      );
      return new GestureDetector(
        onTap: () {
          // 已登录，显示用户详细信息
          //_showUserInfoDetail();
        },
        child: avatarContainer,
      );
    }
    --i;
    if (i.isOdd) {
      return new Divider(
        height: 1.0,
      );
    }
    i = i ~/ 2;
    String title = titles[i];
    var listItemContent = new Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 15.0, 10.0, 15.0),
      child: new Row(
        children: <Widget>[
          Container(
            child: Icon(IconData(icons[i],fontFamily: Constants.IconFontFamily)),
            padding: EdgeInsets.only(right: 20.0),
          ),
          new Expanded(
              child: new Text(
                title,
                style: i==0 ? firstTextStyle:titleTextStyle,
                textAlign: TextAlign.left,
              )),
          Icon(IconData(0xe756,fontFamily: Constants.IconFontFamily)),
        ],
      ),
    );
    return new InkWell(
      child: listItemContent,
      onTap: () {
        _handleListItemClick(title);
      },
    );
  }

}