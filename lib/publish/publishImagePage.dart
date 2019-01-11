import 'dart:async';
import 'dart:io';
import 'package:flutter_fuqi/dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_fuqi/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter_fuqi/tool/tool.dart';
import 'package:flutter_fuqi/discover/discoverPage.dart';
import 'package:flutter_fuqi/fuqi/user_detail.dart';

class publishImagePage extends StatefulWidget {

  @override
  _publishImagePageState createState() {
    return new _publishImagePageState();
  }
}

class _publishImagePageState extends State<publishImagePage> {

  TextEditingController _titleController = new TextEditingController();
  List<File> fileList = new List();
  Future<File> _imageFile;
  bool isLoading = false;
  String msg = "";

  Widget getBody() {
    // 标题
    var titleTextField = new TextField(
      decoration: new InputDecoration(
          hintText: "请输入照片名字～",
          hintStyle: new TextStyle(
              color: const Color(0xFF808080)
          ),
          border: new OutlineInputBorder(
              borderRadius: const BorderRadius.all(const Radius.circular(10.0))
          )
      ),
      maxLines: 1,
      maxLength: 50,
      controller: _titleController,
    );
    // gridView用来显示选择的图片
    var gridView = new Builder(
      builder: (ctx) {
        return new GridView.count(
          // 分4列显示
          crossAxisCount: 4,
          children: new List.generate(fileList.length + 1, (index) {
            // 这个方法体用于生成GridView中的一个item
            var content;
            if (index == 0) {
              // 添加图片按钮
              var addCell = new Center(
                  child: new Image.asset('assets/images/ic_add_pics.png', width: 80.0, height: 80.0,)
              );
              content = new GestureDetector(
                onTap: () {
                  // 添加图片
                  pickImage(ctx);
                },
                child: addCell,
              );
            } else {
              // 被选中的图片
              content = new Center(
                  child: new Image.file(fileList[index - 1], width: 80.0, height: 80.0, fit: BoxFit.cover,)
              );
            }
            return new Container(
              margin: const EdgeInsets.all(2.0),
              width: 80.0,
              height: 80.0,
              color: const Color(0xFFECECEC),
              child: content,
            );
          }),
        );
      },
    );
    var children = [
      titleTextField,
      new Text("提示：一次只能上传一张图片", style: new TextStyle(fontSize: 12.0),),
      new Container(
          margin: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
          height: 200.0,
          child: gridView
      )
    ];
    if (isLoading) {
      children.add(new Container(
        margin: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
        child: new Center(
          child: new CircularProgressIndicator(),
        ),
      ));
    } else {
      children.add(new Container(
          margin: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
          child: new Center(
            child: new Text(msg),
          )
      ));
    }
    return new Container(
        padding: const EdgeInsets.all(5.0),
        child: ListView(
          children: children,
        )
    );
  }

  // 相机拍照或者从图库选择图片
  pickImage(ctx) {
    // 如果已添加了1张图片，则提示不允许添加更多
    num size = fileList.length;
    if (size >= 1) {
      Scaffold.of(ctx).showSnackBar(new SnackBar(
        content: new Text("一次只能添加一张图片"),
      ));
      return;
    }
    showModalBottomSheet<void>(context: context, builder: _bottomSheetBuilder);
  }

  Widget _bottomSheetBuilder(BuildContext context) {
    return new Container(
        height: 182.0,
        child: new Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 30.0),
          child: new Column(
            children: <Widget>[
              _renderBottomMenuItem("图库选择照片", ImageSource.gallery),
              new Divider(height: 2.0,),
              _renderBottomMenuItem("相机拍照", ImageSource.camera),
            ],
          ),
        )
    );
  }

  _renderBottomMenuItem(title, ImageSource source) {
    var item = new Container(
      height: 60.0,
      child: new Center(
          child: new Text(title)
      ),
    );
    return new InkWell(
      child: item,
      onTap: () {
        Navigator.of(context).pop();
        setState(() {
          _imageFile = ImagePicker.pickImage(source: source);
        });
      },
    );
  }

  _sendArticle(ctx) async {
    String title = _titleController.text;
    FormData formData;
    if (title == null || title.length == 0 || title.trim().length == 0) {
      Scaffold.of(ctx).showSnackBar(new SnackBar(
        content: new Text("请输入照片名字"),
      ));
      return;
    }

    if (fileList.length == 0){
      Scaffold.of(ctx).showSnackBar(new SnackBar(
        content: new Text("请上传照片"),
      ));
      return;
    }
    if (fileList.length == 1){
      var filename = fileList[0].path.substring(fileList[0].path.lastIndexOf("/") + 1);

      formData = new FormData.from({
        "name": title,
        'img':UploadFileInfo(fileList[0],filename),
      });
    }

    try{
      showDialog(context: ctx,child: tool.getProgressIndicator(info: "数据上传中..."));
      var response = await dioTool.dio.post('${Constants.host}/app/uploadUserImage/',data:formData);
      tool.showToast("发布成功");
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.push(context,MaterialPageRoute(builder: (BuildContext ctx){
        return UserDetail(id: tool.myUserData['id']);
      }));
    }on DioError catch (e){
      if(e.response != null && e.response.statusCode == 401){
        tool.showToast("登录信息已失效");
        Navigator.of(context).pushNamed('/login');
      }else{
        tool.showToast("网络异常");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("上传照片到我的资料", style: new TextStyle(color: Colors.white)),
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
      // 在这里接收选择的图片
      body: new FutureBuilder(
        future: _imageFile,
        builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null && _imageFile != null) {
            // 选择了图片（拍照或图库选择），添加到List中
            fileList.add(snapshot.data);
            _imageFile = null;
          }
          // 返回的widget
          return getBody();
        },
      ),
    );
  }
}