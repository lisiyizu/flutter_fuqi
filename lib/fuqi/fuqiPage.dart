import 'package:flutter/material.dart';
import 'package:flutter_refresh/flutter_refresh.dart';
import 'package:dio/dio.dart';
import 'package:flutter_fuqi/constants.dart';
import 'package:flutter_fuqi/modal/userData.dart';
import 'package:flutter_fuqi/fuqi/user_info_item.dart';
import 'package:flutter_fuqi/fuqi/locate.dart';
import 'package:flutter_fuqi/tool/tool.dart';
import 'package:flutter_fuqi/dio/dio.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_fuqi/fuqi/user_detail.dart';



final List<Tab> _myTabs = <Tab>[
  Tab(text: '热门会员'),
  Tab(text: '最近登录'),
  Tab(text: '推荐会员'),
  Tab(text: 'SPA技师')
];

List<String> _allPages=[
  "hot",
  "login",
  "recommend",
  "spa",
];

class fuqiPage extends StatefulWidget{

  @override
  _fuqiPageState createState() {
    // TODO: implement createState
    return _fuqiPageState();
  }
}

class _fuqiPageState extends State<fuqiPage> with SingleTickerProviderStateMixin {

  TabController _controller;
  String _selectedTag;
  List<UserData> userDatas=[];
  TextEditingController _textController = new TextEditingController();
  int page = 1;
  int pageSize = 20;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TabController(vsync: this, length: _myTabs.length);
    _controller.addListener(_handleTabSelection);
    _selectedTag = _allPages[0];
    if(!_recoverData(false)){
      _getUserInfos(false);
    }
  }

  bool _recoverData(bool bSet){
    if(tool.userPageDatas[_controller.index] != null && tool.userPageDatas[_controller.index].containsKey('data') &&
        tool.userPageDatas[_controller.index]['data'].length != 0){
      if(bSet){
        setState(() {
          userDatas = tool.userPageDatas[_controller.index]['data'];
          page = tool.userPageDatas[_controller.index]['page'];
        });
      }else{
        userDatas = tool.userPageDatas[_controller.index]['data'];
        page = tool.userPageDatas[_controller.index]['page'];
      }
      return true;
    }else{
      return false;
    }
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    //tab改变的时候数据清0
    //滑动的时候出发一次,但是点击的时候会出发两次
    if (_selectedTag != _allPages[_controller.index]) {
      _selectedTag = _allPages[_controller.index];
      //已有数据不再获取
      if(!_recoverData(true)){
        _getUserInfos(false);
      }
    }
  }

  _getUserInfos(bool bGetMore) async {
    //根据tag不一样获取不一样的数据功能待调整
    Response response;
    String url;

    //不是获取更多数据那么就从第一页开始
    if(!bGetMore){
      page = 1;
    }
    if (tool.location == "全国"){
      url = "${Constants.host}/app/searchUsers/?type=$_selectedTag&page=$page&page_size=$pageSize";
    }else{
      url = "${Constants.host}/app/searchUsers/?type=$_selectedTag&page=$page&page_size=$pageSize&province=${tool.location}";
    }

    try {
      response = await dioTool.dio.get(url);
    }on DioError catch(e) {
      if (e.response != null && e.response.statusCode == 404){
         tool.showToast("已显示全部数据");
      }else if(e.response != null && e.response.statusCode == 401){
        //登录信息已经失效
         tool.showToast("登录信息已失效");
         Navigator.of(context).pushNamed('/login');
      } else{
         tool.showToast("网络不佳,请稍候再试");
      }
      return;
    }
    //数据已经到底了
    print(response.data);
    var result = response.data['results'];
    List<UserData> UserDatas=[];
    for(var item in result){
      UserDatas.add(UserData(
        id:item['id'],
        name:item['name'],
        desc:item['desc'],
        head_img: item['head_img'],
        sex: item['sex'],
        target: item['target'],
        qq: item['qq'],
        profile: item['profile'],
        province: item['province'],
        city: item['city'],
        age: item['age'],
        login_time: item['login_time'],
        buy_time: item['buy_time'],
        free_count: item['free_count'],
        read_count: item['read_count'],
        ip: item['ip'],
        is_identification: item['is_identification'],
        is_spa: item['is_spa'],
        spa_profile: item['spa_profile'],
        user: item['user'],
      ));
    }
    if (this.mounted){
      setState(() {
        // 是否是加载更多数据
        if (bGetMore) {
          userDatas.addAll(UserDatas);
        } else {
          userDatas = UserDatas;
        }
        page += 1;
        tool.userPageDatas[_controller.index]['data'] = userDatas;
        tool.userPageDatas[_controller.index]['page'] = page;
      });
    }
  }

  Future<Null> onHeaderRefresh() {
    return new Future.delayed(new Duration(seconds: 2), () {
      //上拉刷新的时候永远找第一页
      _getUserInfos(false);
    });
  }

  Future<Null> onFooterRefresh() {
    return new Future.delayed(new Duration(seconds: 2), () {
      _getUserInfos(true);
    });
  }


  Widget buildTabView(String tag) {
    return new Refresh(
      onFooterRefresh: onFooterRefresh,
      onHeaderRefresh: onHeaderRefresh,
      childBuilder: (BuildContext context,
          {ScrollController controller, ScrollPhysics physics}) {
        return new Container(
            child: new ListView.builder(
              physics: physics,
              controller: controller,
              itemBuilder: (BuildContext context,int index){
                return UserInfoItem(tag:_selectedTag,userData:userDatas[index]);
              },
              itemCount: userDatas.length,
            ));
      },
    );

  }

  _navigateToLocate(BuildContext context) async {
    String result = await Navigator.push(context,MaterialPageRoute(builder: (BuildContext ctx){
      return LocatePage(current:tool.location);
    }));

    //按返回键的时候返回的是null
    if (tool.location != result && result != null){
      //地点已经切换了,重新加载数据
      setState(() {
        tool.location = result;
      });
      //地点切换后,其他数据也要销毁,否则不会更新
      for(int i=0;i< tool.userPageDatas.length;i++){
        tool.userPageDatas[i].clear();
      }
      _getUserInfos(false);
    }
  }

  _searchUserDetail(String id) {
    //先做检查
    if(id==null || id.trim().length == 0 || id.contains('139') == false){
      tool.showLongToast("您输入的ID格式错误", 3);
      return;
    }
    id = id.substring(0,id.length-3);

    Navigator.push(context,MaterialPageRoute(builder: (BuildContext ctx){
      return UserDetail(id:num.parse(id));
    }));

  }
  _searchUserById(BuildContext context) async {
    Alert(
        context: context,
        title: "根据ID查找用户",
        content: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                  hintText:"请输入ID号"
              ),
              controller: _textController,
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () {
              Navigator.pop(context);
              _searchUserDetail(_textController.text);
              _textController.clear();
            },
            child: Text(
              "查找",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (userDatas.length == 0) {
      return tool.getProgressIndicator();
    }else {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,//去掉返回箭头
          elevation: 0.0,
          title: Text('交友'),
          centerTitle: true,
          actions: <Widget>[
            Container(
              padding: EdgeInsets.only(right: 25.0),
              child: GestureDetector(
                  onTap: (){
                    _searchUserById(context);
                  },
                  child: Row(
                      children: <Widget>[
                        Icon(IconData(0xe620, fontFamily: Constants.IconFontFamily),size: 18,),
                      ])),

            ),
            Container(
              padding: EdgeInsets.only(right: 25.0),
              child: GestureDetector(
                  onTap: (){
                    _navigateToLocate(context);
                  },
                  child: Row(
                      children: <Widget>[
                        Icon(IconData(0xe73d, fontFamily: Constants.IconFontFamily),size: 18,),
                        Container(width: 5.0,),
                        Text(tool.location,textAlign:TextAlign.center),
                      ])),

            )],
          bottom: TabBar(
              controller: _controller,
              tabs: _myTabs,
              isScrollable: true,
              labelColor: Colors.white,
              labelStyle: TextStyle(fontSize: 18.0),
              unselectedLabelColor: Colors.grey,
              unselectedLabelStyle: TextStyle(fontSize: 12.0)
          ),
        ),
        body:TabBarView(
          controller: _controller,
          children: _allPages.map((tag) => buildTabView(tag)).toList(),
        ),

      );
    }
  }
}