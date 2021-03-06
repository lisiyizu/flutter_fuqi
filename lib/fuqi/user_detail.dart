import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_fuqi/constants.dart';
import 'package:flutter_fuqi/dio/dio.dart';
import 'package:flutter_fuqi/fuqi/user_info_item.dart';
import 'package:flutter_fuqi/fuqi/user_detail_tab_content.dart';
import 'package:flutter_fuqi/tool/tool.dart';
import 'package:flutter_fuqi/message/chatPage.dart';
import 'package:flutter_fuqi/common/common.dart';


class UserDetail extends StatefulWidget{
  var  userData;
  int id;
  UserDetail({Key key,this.userData,this.id}):super(key:key);

  @override
  _UserDetailState createState() {
    // TODO: implement createState
    return _UserDetailState();
  }
}

class _UserDetailState extends State<UserDetail> with TickerProviderStateMixin {

  List<Tab> _tabs=[
    Tab(text: '动态'),
    Tab(text: '联系方式'),
    Tab(text: '在线聊天'),
  ];
  List<String> tempImage = [];
  TabController _controller;
  List<String> _urls = [];
  var _userTabContent;
  int _currentIndex = 0;
  var _userData;

  _goTochat(var userDetail) async {
      try{
        tool.bGetNewConversation = true;
        var response = await dioTool.dio.get('${Constants.host}/app/readConverstation/?id=${userDetail['id']}');
        if(response.data['count'] == 0){
          print('新建聊天');
          response = await dioTool.dio.post('${Constants.host}/app/writeConverstation/',data: {'receive_user_id':userDetail['id']});
          response = await dioTool.dio.get('${Constants.host}/app/readConverstation/${response.data['id']}/');
          Navigator.push(context,MaterialPageRoute(builder: (BuildContext ctx){
            return chatPage(originConversation:response.data);
          }));
        }else{
          print('以前聊过');
          Navigator.push(context,MaterialPageRoute(builder: (BuildContext ctx){
            return chatPage(originConversation:response.data['results'][0]);
          }));
        }
      }on DioError catch(e) {
        if(e.response != null && e.response.statusCode == 401){
          //登录信息已经失效
          tool.showToast("登录信息已失效");
          Navigator.of(context).pushNamed('/login');
        } else{
          tool.showToast("网络不佳,请稍候再试");
        }
      }
    }

  _reduceMyFreeCount() async {
    String msg;
    var response;
    var tabContent;
    try {
      //实时获取数据
      //tool.getMyUserInfo(context:context,id:tool.myUserData['id']);
      //权限检查
      if(tool.myUserData['free_count']>1 || _userData['id'] == tool.myUserData['id']){
        tabContent = UserDtailTabContent(tag: _tabs[_currentIndex].text, userDetail: _userData);
        setState(() {
          _userTabContent = tabContent;
        });
        if(_userData['id'] != tool.myUserData['id']){
          tool.showToast("夫妻币减2");
          int free_count = tool.myUserData['free_count']-2;
          String url = '${Constants.host}/app/userDetail/${tool.myUserData['id']}/';
          response = await dioTool.dio.patch(url,data:{'free_count':free_count});
          tool.myUserData = response.data;
        }
      }else{
        tabContent = Text("您的夫妻币不足,请在我->常见问题中,查看如何获取夫妻币");
        setState(() {
          _userTabContent = tabContent;
        });
        tool.goToQuestion(context:context,title:"查看如何获取夫妻币",desc: "您的夫妻币不足");
      }
    }on DioError catch(e) {
      if(e.response != null && e.response.statusCode == 401){
        msg = "登录信息已失效,请重新登录";
        Navigator.of(context).pushNamed('/login');
      }else{
        msg = "网络不佳,请稍候再试";
      }
      tool.showToast(msg);
      return;
    }
  }
  _onlineChat() async {
    String msg;
    var response;
    var tabContent;
    try {
      //实时获取数据
      //tool.getMyUserInfo(context:context,id:tool.myUserData['id']);
      //权限检查
      if(tool.myUserData['free_count']>=10){
        tabContent = UserDtailTabContent(tag: _tabs[_currentIndex].text, userDetail: _userData);
        setState(() {
          _userTabContent = tabContent;
        });
//        if(tool.myUserData['profile'] != "皇冠VIP会员" && tool.myUserData['profile'] != "至尊VIP会员" ){
//          _userTabContent = Text('抱歉,只有皇冠VIP会员和至尊VIP会员允许在线聊天',style:TextStyle(color: Colors.red));
//          return;
//        }
        if(_userData['id'] == tool.myUserData['id']){
          tool.showToast('抱歉,不能给自己发消息');
          return;
        }
        tool.showToast('夫妻币减10');
        _goTochat(_userData);
        int free_count = tool.myUserData['free_count']-10;
        String url = '${Constants.host}/app/userDetail/${tool.myUserData['id']}/';
        response = await dioTool.dio.patch(url,data:{'free_count':free_count});
        tool.myUserData = response.data;
      }else{
        tabContent = Text("您的夫妻币不足,请在我->常见问题中,查看如何获取夫妻币");
        setState(() {
          _userTabContent = tabContent;
        });
        tool.goToQuestion(context:context,title:"查看如何获取夫妻币",desc: "您的夫妻币不足");
      }
    }on DioError catch(e) {
      if(e.response != null && e.response.statusCode == 401){
        msg = "登录信息已失效,请重新登录";
        Navigator.of(context).pushNamed('/login');
      }else{
        msg = "网络不佳,请稍候再试";
      }
      tool.showToast(msg);
      return;
    }
  }
  _onChanged() {
    setState(() {
      _currentIndex = this._controller.index;
      if (_tabs[_currentIndex].text == "联系方式") {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return SimpleDialog(
                  title: _userData['id'] == tool.myUserData['id'] ? Text('查看自己无需消耗夫妻币'):Text('需要消耗2枚夫妻币'),
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 25.0),
                      child: Text('您当前的夫妻币是:${tool.myUserData['free_count']}'),
                    ),
                    new Container(
                        margin: const EdgeInsets.only(top: 18.0),
                        child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              new RaisedButton(
                                elevation: 0.0,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  setState(() {
                                    _userTabContent = Text("您已经取消查看");
                                  });
                                },
                                color: Colors.green,
                                colorBrightness: Brightness.light,
                                child: const Text('取消'),
                              ),
                              new RaisedButton(
                                  elevation: 0.0,
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    _reduceMyFreeCount();
                                  },
                                  color: Colors.green,
                                  colorBrightness: Brightness.light,
                                  child: const Text('确定'))
                            ]))
                  ]);
            });
      }else if(_tabs[_currentIndex].text == "在线聊天"){
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return SimpleDialog(
                  title: Text('需要消耗10个夫妻币'),
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 25.0),
                      child: Text('您当前的夫妻币是:${tool.myUserData['free_count']}'),
                    ),
                    new Container(
                        margin: const EdgeInsets.only(top: 18.0),
                        child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              new RaisedButton(
                                elevation: 0.0,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  setState(() {
                                    _userTabContent = Text("您已经取消在线聊天");
                                  });
                                },
                                color: Colors.green,
                                colorBrightness: Brightness.light,
                                child: const Text('取消'),
                              ),
                              new RaisedButton(
                                  elevation: 0.0,
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    _onlineChat();
                                  },
                                  color: Colors.green,
                                  colorBrightness: Brightness.light,
                                  child: const Text('确定'))
                            ]))
                  ]);
            });
      } else{
        _userTabContent = UserDtailTabContent(
            tag: _tabs[_currentIndex].text, userDetail:_userData);
      }
    });}

  @override
  void initState() {
    super.initState();
    _userData = widget.userData;//IOS版本直接操作widget.userData不会生效
    _init();
    _controller = new TabController(length: _tabs.length, vsync: this);
    _controller.addListener(_onChanged);
  }

  _getBannerImage(){
    var temp = _userData['user_image'];
    tempImage = [];
    if (temp.length == 0){
      tempImage.add(_userData['head_img']);//没有图片则使用默认图片
    }else{
      for (int i = 0;i < temp.length;i++){
        tempImage.add(temp[i]['img']);
      }
    }
  }

  _getUserDetail() async {
    Response response;
    String msg;
    String url = "${Constants.host}/app/searchUsers/${widget.id}/";
    print(url);
    try {
      response = await dioTool.dio.get(url);
      _userData = response.data;
      if(widget.id == tool.myUserData['id']){
        tool.myUserData = _userData;
      }
    }on DioError catch(e) {
      if(e.response != null && e.response.statusCode == 401){
        msg = "登录信息已失效,请重新登录";
        tool.showToast(msg);
        Navigator.of(context).pushNamed('/login');
      }else if(e.response != null && e.response.statusCode == 404){
        msg = "您搜索的用户不存在或已注销";
        tool.showLongToast(msg, 3);
        Navigator.of(context).pop();
      } else{
        msg = "网络不佳,请稍候再试";
        tool.showToast(msg);
      }
      return;
    }

    setState(() {
      print("set state");
      _getBannerImage();
      //等数据回来的时候再建立Tab,保证_userDetail里有数据
      _userTabContent = UserDtailTabContent(tag:_tabs[_currentIndex].text,userDetail: _userData);
    });
  }



  //刷新人气值
  _init() async {
    String msg;
    if (_userData == null){
      await _getUserDetail();
    }else{
      _getBannerImage();
      _userTabContent = UserDtailTabContent(tag:_tabs[_currentIndex].text,userDetail: _userData);
      try {
        String url = "${Constants.host}/app/searchUsers/${_userData['id']}/";
        await dioTool.dio.patch(url,data:{'read_count':_userData['read_count']+1});
      }on DioError catch(e) {
        if(e.response.statusCode == 401){
          msg = "登录信息已失效,请重新登录";
          tool.showToast(msg);
          Navigator.of(context).pushNamed('/login');
        }else if(e.response.statusCode == 404){
          msg = "您搜索的用户不存在或已注销";
          tool.showLongToast(msg, 3);
          Navigator.of(context).pop();
        } else{
          msg = "网络不佳,请稍候再试";
          tool.showToast(msg);
        }
        return;
      }
    }
  }
  @override
  void dispose() {
    _controller.removeListener(_onChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_userData == null) {
      return tool.getProgressIndicator();
    }else{
      return new Scaffold(
          appBar: AppBar(
            title: Text(_userData['name']+"的个人资料"),
            centerTitle: true,
          ),
          body: new Stack(
            children: <Widget>[
              new Container(
                  child: new Column(
                    children: <Widget>[
                      buildBanner(context,tempImage),
                      new Container(
                        color: Colors.white,
                        child: new Column(
                          children: <Widget>[
                            UserInfoItem(tag:"hot",userData:_userData),
                            Divider(),
                            TabBar(
                              indicatorWeight: 3.0,
                              indicatorSize: TabBarIndicatorSize.tab,
                              labelStyle: new TextStyle(fontSize: 16.0),
                              labelColor: Colors.black,
                              controller: _controller,
                              tabs: _tabs,
                              indicatorColor: Theme
                                  .of(context)
                                  .primaryColor,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: _userTabContent,
                      )
                    ],
                  )
              ),

              new Positioned(
                top: 10.0,
                left: -10.0,
                child: new Container(
                    padding: const EdgeInsets.all(15.0),
                    child: new BackButton(color: Colors.white)
                ),
              ),
            ],
          )
      );
    }
  }
}