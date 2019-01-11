import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_fuqi/constants.dart';
import 'package:flutter_fuqi/dio/dio.dart';
import 'package:flutter_fuqi/fuqi/indicator_viewpager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_fuqi/fuqi/user_brief.dart';
import 'package:flutter_fuqi/fuqi/user_detail_tab_content.dart';
import 'package:flutter_fuqi/tool/tool.dart';
import 'package:flutter_fuqi/message/chatPage.dart';

class UserDetail extends StatefulWidget{
  int id;

  UserDetail({Key key,@required this.id}):super(key:key);

  @override
  _UserDetailState createState() {
    // TODO: implement createState
    return _UserDetailState();
  }
}

class _UserDetailState extends State<UserDetail> with TickerProviderStateMixin {

  List<Tab> _tabs;
  List<Widget> _imagePages = [];
  TabController _controller;
  List<String> _urls = [];
  var _userTabContent;
  int _currentIndex = 0;
  var _userDetail;


  _goTochat(var userDetail) async {
      if(userDetail['id'] == tool.myUserData['id']){
         tool.showToast('抱歉,不能给自己发消息');
         return;
      }
      try{
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
        if(e.response.statusCode == 401){
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
      tool.getMyUserInfo(context:context,id:tool.myUserData['id']);

      //权限检查
      if(tool.myUserData['free_count']>0){
        if(_tabs[_currentIndex].text == "聊天"){
          _goTochat(_userDetail);
          tabContent = Text("点击聊天即可发送信息");
        }{
          tabContent = UserDtailTabContent(
              tag: _tabs[_currentIndex].text, userDetail: _userDetail);
        }
        int free_count = tool.myUserData['free_count']-1;
        String url = '${Constants.host}/app/userDetail/${tool.myUserData['id']}/';
        response = await dioTool.dio.patch(url,data:{'free_count':free_count});
        tool.myUserData = response.data;
        print("次数减1");
      }else{
        tabContent = Text("您的夫妻币不足,请在我->常见问题中,查看如何获取夫妻币");
      }
      setState(() {
        _userTabContent = tabContent;
      });
    }on DioError catch(e) {
      if(e.response.statusCode == 401){
        msg = "登录信息已失效,请重新登录";
        Navigator.of(context).pushNamed('/login');
      }else{
        msg = "网络不佳,请稍候再试";
      }
      Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black
      );
      return;
    }
  }

  _onChanged() {
    setState(() {
      _currentIndex = this._controller.index;
      if (_tabs[_currentIndex].text == "联系方式" || _tabs[_currentIndex].text == "聊天") {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return SimpleDialog(
                  title: Text('需要消耗一个夫妻币'),
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
      }else{
        _userTabContent = UserDtailTabContent(
            tag: _tabs[_currentIndex].text, userDetail: _userDetail);
      }
    });}

  @override
  void initState() {
    super.initState();
    _getUserDetail();
    _tabs = [
       Tab(text: '动态'),
       Tab(text: '联系方式'),
       Tab(text: '聊天'),
    ];
    _controller = new TabController(length: _tabs.length, vsync: this);
    _controller.addListener(_onChanged);
  }

  _getUserDetail() async {
    Response response;
    String msg;
    var temp;
    List<String> tempImage=[];
    String url = "${Constants.host}/app/userDetail/${widget.id}";
    print(url);
    try {
      response = await dioTool.dio.get(url);
      _userDetail = response.data;
      temp = _userDetail['user_image'];
      if (temp.length == 0){
        tempImage.add(_userDetail['head_img']);//没有图片则使用默认图片
      }else{
        for (int i = 0;i < temp.length;i++){
          tempImage.add(temp[i]['img']);
        }
      }
    }on DioError catch(e) {
      if(e.response.statusCode == 401){
        msg = "登录信息已失效,请重新登录";
      }else{
        msg = "网络不佳,请稍候再试";
      }
      Fluttertoast.showToast(
          msg: msg,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black
      );
      Navigator.of(context).pushNamed('/login');
      return;
    }
    setState(() {
      _urls = tempImage;
      _urls.forEach((String url) {
        Widget avator = Image.network(
          url,
          fit: BoxFit.contain,
          height: Constants.bannerImageHeight,
        );

        _imagePages.add(
            Container(
              color: Colors.black.withAlpha(900),
              child: ConstrainedBox(
                  constraints: const BoxConstraints.expand(),
                  child: avator),
            ));
      });
      //等数据回来的时候再建立Tab,保证_userDetail里有数据
      _userTabContent = UserDtailTabContent(tag:_tabs[_currentIndex].text,userDetail: _userDetail);
    });
  }
  @override
  void dispose() {
    _controller.removeListener(_onChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //此处先清空
    if (_userDetail == null) {
      return tool.getProgressIndicator();
    }else {
      return new Scaffold(
          backgroundColor: new Color.fromARGB(255, 242, 242, 245),
          body: new Stack(
            children: <Widget>[
              new Container(
                  child: new Column(
                    children: <Widget>[
                      new SizedBox.fromSize(
                        size:  Size.fromHeight(Constants.bannerImageHeight),
                        child: new IndicatorViewPager(_imagePages),
                      ),
                      new Container(
                        color: Colors.white,
                        child: new Column(
                          children: <Widget>[
                            UserBrief(userBrief: _userDetail),
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