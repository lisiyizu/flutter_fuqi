import 'package:flutter/material.dart';
import 'package:flutter_fuqi/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter_fuqi/tool/tool.dart';
import 'package:flutter_fuqi/dio/dio.dart';
import 'package:flutter_fuqi/fuqi/user_detail.dart';

class publishDynamicPage extends StatefulWidget {

  @override
  _publishDynamicPageSate createState() {
    // TODO: implement createState
    return _publishDynamicPageSate();
  }

}


class _publishDynamicPageSate extends State<publishDynamicPage> {

  TextEditingController _Controller = new TextEditingController();

  _sendArticle (ctx) async {
    String content = _Controller.text;

    if (content == null || content.length == 0 || content.trim().length == 0) {
      Scaffold.of(ctx).showSnackBar(new SnackBar(
        content: new Text("请填写动态内容！"),
      ));
      return;
    }

    try{

      var response = await dioTool.dio.post('${Constants.host}/app/writeDynamic/',data:{'content':content});
      Navigator.of(context).pop();
      tool.showToast("发布成功");
      Navigator.push(context,MaterialPageRoute(builder: (BuildContext ctx){
        return UserDetail(id: tool.myUserData['id']);
      }));
    }on DioError catch (e){
      print(e.response.statusCode);
      tool.showToast("网络异常");
      Navigator.of(context).pushNamed('/login');
    }
  }


  _getBody(){
    // 标题
    var titleTextField = new TextField(
      decoration: new InputDecoration(
          hintText: "发布动态～",
          hintStyle: new TextStyle(
              color: const Color(0xFF808080)
          ),
          border: new OutlineInputBorder(
              borderRadius: const BorderRadius.all(const Radius.circular(10.0))
          )
      ),
      maxLines: 2,
      maxLength: 50,
      controller: _Controller,
    );
    var children = [
      titleTextField,
    ];
    return new Container(
        padding: const EdgeInsets.all(5.0),
        child: ListView(
          children: children,
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(
        title: new Text("发布动态到我的资料", style: new TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: new IconThemeData(color: Colors.white),
        actions: <Widget>[
          new Builder(
            builder: (ctx) {
              return new IconButton(icon: new Icon(Icons.send), onPressed: () {
                // 发送动弹
                _sendArticle(ctx);
              });
            },
          )
        ],
      ),
      body: _getBody(),
    );
  }


}

