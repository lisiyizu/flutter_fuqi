import 'package:flutter/material.dart';
import 'package:flutter_fuqi/modal/articleData.dart';
import 'package:flutter_fuqi/constants.dart';
import 'package:flutter_fuqi/fuqi/indicator_viewpager.dart';
import 'package:flutter_fuqi/dio/dio.dart';
import 'package:flutter_fuqi/tool/tool.dart';
import 'package:dio/dio.dart';

class activityDetail extends StatefulWidget{

  articleData mData;
  String tag;

  activityDetail({Key key,@required this.mData,@required this.tag}):super(key:key);

  @override
  _articleDetailState createState() {
    // TODO: implement createState
    return _articleDetailState();
  }

}

class _articleDetailState extends State<activityDetail> with TickerProviderStateMixin {
  List<String> _urls = [];
  List<Widget> _imagePages = [];
  TabController _controller;
  List<Tab> _tabs;
  Widget _articleTabContent;
  int _currentIndex = 0;
  articleData _localData;

  void _setImagePages() {
    _urls.add(widget.mData.head_img);
    if (widget.mData.head_img2.contains('media/uploads/couple.jpg') == false) {
      _urls.add(widget.mData.head_img2);
    }
    if (widget.mData.head_img3.contains('media/uploads/couple.jpg') == false) {
      _urls.add(widget.mData.head_img3);
    }
    if (widget.mData.head_img3.contains('media/uploads/couple.jpg') == false) {
      _urls.add(widget.mData.head_img3);
    }
    if (widget.mData.head_img4.contains('media/uploads/couple.jpg') == false) {
      _urls.add(widget.mData.head_img4);
    }
    if (widget.mData.head_img5.contains('media/uploads/couple.jpg') == false) {
      _urls.add(widget.mData.head_img5);
    }
    _urls.forEach((String url) {
      Widget avator = tool.getCacheImage(
          url: url, height: Constants.bannerImageHeight, fit: BoxFit.contain);

      _imagePages.add(
          Container(
            color: Colors.black.withAlpha(900),
            child: ConstrainedBox(
                constraints: const BoxConstraints.expand(),
                child: avator),
          ));
    });
  }

  _onChanged() {
    if (_currentIndex != _controller.index) {
      setState(() {
        _currentIndex = _controller.index;
        _articleTabContent = _getArticleTabContent();
      });
    }
  }

  _getArticleTabContent() {
    Widget content;
    if (_tabs[_currentIndex].text == '活动详情') {
//      if((tool.myUserData['profile'] == '普通会员' || tool.myUserData['profile'] == '高级VIP会员') && widget.tag == 'qq' && _localData.is_free == false){
//        content = Text("内容:权限不够,只有钻石及以上VIP可查看",style:TextStyle(color: Colors.red));
//      }
      content = Text("${_localData.content}");
      return ListView(
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(left: 10.0,top: 5.0),
              child: Row(
                children: <Widget>[
                  Text("简介:${_localData.brief}"),
                ],
              )
          ),
          Divider(),
          Container(
              padding: EdgeInsets.only(left: 10.0,top: 5.0),
              child: content
          ),
        ],
      );
    } else if (_tabs[_currentIndex].text == "咨询QQ") {
      return ListView(
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(left: 20.0, top: 15.0),
              child: Row(
                children: <Widget>[
                  Text("${_localData.qq}"),
                ],
              )
          ),
        ],
      );
    } else {
      return ListView(
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(left: 20.0, top: 15.0),
              child: Row(
                children: <Widget>[
                  Text("${_localData.join}"),
                ],
              )
          ),
        ],
      );
    }
  }


    //获取文章详情,增加人气统计
    void _getArticleInfo() async {
      try {
        var response = await dioTool.dio.get(
            "${Constants.host}/app/searchArticles/${_localData.id}/");
        //widget.mData.setNewData(_localData);//如果不更新它,重新进来时不会显示新的评论信息
        _localData = articleData.getArticleData(response.data);
        if (_localData.comment_count != widget.mData.comment_count) {
          setState(() {
            widget.mData.setNewData(_localData); //如果不更新它,重新进来时不会显示新的评论信息
            _articleTabContent = _getArticleTabContent();
          });
        }
      } on DioError catch (e) {
        if (e.response != null && e.response.statusCode == 401) {
          tool.showToast("密码已过期,请重新登录");
          Navigator.of(context).pushNamed('/login');
        } else {
          tool.showToast("网络异常");
        }
      }
    }
    @override
    void initState() {
      // TODO: implement initState
      super.initState();
      _setImagePages();
      _tabs = [
        Tab(text: '活动详情'),
        Tab(text: '咨询QQ'),
        Tab(text: '报名情况'),
      ];
      _localData = widget.mData; //IOS版直接操作widget.mData有异常
      _controller = new TabController(length: _tabs.length, vsync: this);
      _currentIndex = _controller.index;
      _controller.addListener(_onChanged);
      _articleTabContent = _getArticleTabContent();
      _getArticleInfo();
    }
    @override
    void dispose() {
      _controller.removeListener(_onChanged);
      _controller.dispose();
      super.dispose();
    }


    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.mData.title),
          centerTitle: true,
        ),
        body: Container(
            child: Column(
              children: <Widget>[
                new SizedBox.fromSize(
                  size: Size.fromHeight(Constants.bannerImageHeight),
                  child: new IndicatorViewPager(_imagePages),
                ),
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
                Expanded(
                  child: _articleTabContent,
                )

              ],)),
      );
    }
}
