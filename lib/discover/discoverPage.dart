import 'package:flutter/material.dart';
import 'package:flutter_refresh/flutter_refresh.dart';
import 'package:dio/dio.dart';
import 'package:flutter_fuqi/constants.dart';
import 'package:flutter_fuqi/discover/articleItem.dart';
import 'package:flutter_fuqi/tool/tool.dart';
import 'package:flutter_fuqi/dio/dio.dart';
import 'package:flutter_fuqi/modal/articleData.dart';
import 'package:flutter_fuqi/modal/video.dart';
import 'package:flutter_fuqi/discover/videoItem.dart';



final List<Tab> _myTabs = <Tab>[
  Tab(text: '认证夫妻'),
  Tab(text: '91视频'),
  Tab(text: '论坛'),
  Tab(text: 'QQ群'),
  Tab(text: '我的文章'),
];

List<String> _allPages=[
  "identify",
  "91",
  "bbs",
  "qq",
  'my',
];


class discoverPage extends StatefulWidget{

  int currentIndex;
  discoverPage({Key key,this.currentIndex:0}):super(key:key);

  @override
  _discoverPageState createState() {
    // TODO: implement createState
    return _discoverPageState();
  }
}

class _discoverPageState extends State<discoverPage> with SingleTickerProviderStateMixin {

  TabController _controller;
  String _selectedTag;
  List<articleData> _articleDatas = [];
  List<Video> _videoDatas = [];
  int page = 1;
  int pageSize = 100;
  @override
  void initState() {
    // TODO: implement initStates
    super.initState();
    _controller = TabController(vsync: this, length: _myTabs.length,initialIndex: widget.currentIndex);
    _controller.addListener(_handleTabSelection);
    _selectedTag = _allPages[widget.currentIndex];
    if(!_recoverData(false)){
      _getArticleInfos(false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _recoverData(bool bSet){

    if(tool.articlePageDatas[_controller.index] != null && tool.articlePageDatas[_controller.index].containsKey('data') &&
        tool.articlePageDatas[_controller.index]['data'].length != 0){
      if(bSet){
        setState(() {
          if(_selectedTag == "91"){
            _videoDatas = tool.articlePageDatas[_controller.index]['data'];
            page = tool.articlePageDatas[_controller.index]['page'];
          }else{
            _articleDatas = tool.articlePageDatas[_controller.index]['data'];
            page = tool.articlePageDatas[_controller.index]['page'];
          }
        });
      }else{
        if(_selectedTag == "91"){
          _videoDatas = tool.articlePageDatas[_controller.index]['data'];
          page = tool.articlePageDatas[_controller.index]['page'];
        }else{
          _articleDatas = tool.articlePageDatas[_controller.index]['data'];
          page = tool.articlePageDatas[_controller.index]['page'];
        }
      }
      return true;
    }else{
      return false;
    }
  }
  void _handleTabSelection() {
    //tab改变的时候数据清0
    //滑动的时候出发一次,但是点击的时候会出发两次
    if (_selectedTag != _allPages[_controller.index]) {
      _selectedTag = _allPages[_controller.index];
      //已经获取过数据时不再继续获取,只在下拉刷新的时候获取
      if(!_recoverData(true)){
        if(_selectedTag == '91'){
          _get91Video(false);
        }else{
          _getArticleInfos(false);
        }
      }
    }
  }

  _get91Video(bool bGetMore) async {
    //根据tag不一样获取不一样的数据功能待调整
    Response response;
    String url;
    if(!bGetMore){
      page = 1;
    }

    //不是获取更多数据那么就从第一页开始
    url = "${Constants.host}/app/searchVideos/?page=$page&page_size=$pageSize";
    try {
      response = await dioTool.dio.get(url);
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

    List<Video> videoData=[];
    var result = response.data['results'];
    for(var item in result){
      videoData.add(Video.getVideoData(item));
    }
    if (this.mounted){
      setState(() {
        // 是否是加载更多数据
        if(!bGetMore){
          _videoDatas = videoData;
        }else{
          _videoDatas.addAll(videoData);
        }
        page += 1;
        tool.articlePageDatas[_controller.index]['page'] = page;
        tool.articlePageDatas[_controller.index]['data'] = _videoDatas;
      });
    }
  }
  _getArticleInfos(bool bGetMore) async {
    //根据tag不一样获取不一样的数据功能待调整
    Response response;
    String url;
    if(!bGetMore){
      page = 1;
    }

    //不是获取更多数据那么就从第一页开始
    url = "${Constants.host}/app/searchArticles/?type=$_selectedTag&page=$page&page_size=$pageSize";
    try {
      response = await dioTool.dio.get(url);
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
    //数据已经到底了
    print(response.data);
    List<articleData> ArticleData=[];
    var result = response.data['results'];
    for(var item in result){
      ArticleData.add(articleData.getArticleData(item));
    }
    if (this.mounted){
      if(ArticleData.length == 0){
        tool.showToast("您还没有发布自己的文章");
        return;
      }
      setState(() {
        // 是否是加载更多数据
        if(!bGetMore){
          _articleDatas = ArticleData;
        }else{
          _articleDatas.addAll(ArticleData);
        }
        page += 1;
        tool.articlePageDatas[_controller.index]['page'] = page;
        tool.articlePageDatas[_controller.index]['data'] = _articleDatas;
      });
    }
  }

  Future<Null> onHeaderRefresh() {
    return new Future.delayed(new Duration(seconds: 2), () {
      //上拉刷新的时候永远找第一页
      if(_selectedTag == '91'){
        _get91Video(false);
      }else{
        _getArticleInfos(false);
      }
    });
  }

  Future<Null> onFooterRefresh() {
    return new Future.delayed(new Duration(seconds: 2), () {
      if(_selectedTag == '91'){
        _get91Video(true);
      }else{
        _getArticleInfos(true);
      }
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
                if(_selectedTag == "91"){
                  return videoItem(tag:_selectedTag,mData:_videoDatas[index]);
                }else{
                  return articleItem(tag:_selectedTag,mData:_articleDatas[index]);
                }
              },
              itemCount: _selectedTag == "91" ? _videoDatas.length:_articleDatas.length,
            ));
      },
    );

  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (_articleDatas.length == 0) {
      return tool.getProgressIndicator();
    }else {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,//去掉返回箭头
          elevation: 0.0,
          centerTitle:true,
          title: Text('发现'),
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