import 'dart:async';
import 'dart:io';
import 'package:flutter_fuqi/dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_fuqi/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter_fuqi/tool/tool.dart';
import 'package:flutter_fuqi/discover/discoverPage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class publishArticlePage extends StatefulWidget {
  String category;
  String title;
  publishArticlePage({Key key,@required this.category,@required this.title}):super(key:key);

  @override
  _publishArticlePageState createState() {
    return new _publishArticlePageState();
  }
}

class _publishArticlePageState extends State<publishArticlePage> {

  TextEditingController _contentController = new TextEditingController();
  TextEditingController _titleController = new TextEditingController();
  TextEditingController _briefController = new TextEditingController();
  List<File> fileList = new List();
  String _title;
  String _desc;
  String _category;
  String _content;
  Future<File> _imageFile;
  bool isLoading = false;
  String msg = "";

  Widget getBody() {
    // 标题
    var titleTextField = new TextField(
      decoration: new InputDecoration(
          hintText: "文章标题～",
          hintStyle: new TextStyle(
              color: const Color(0xFF808080)
          ),
          border: new OutlineInputBorder(
              borderRadius: const BorderRadius.all(const Radius.circular(10.0))
          )
      ),
      maxLines: 2,
      maxLength: 50,
      controller: _titleController,
    );
    // 输入框
    var contentTextField = new TextField(
      decoration: new InputDecoration(
          hintText: "文章内容～",
          hintStyle: new TextStyle(
              color: const Color(0xFF808080)
          ),
          border: new OutlineInputBorder(
              borderRadius: const BorderRadius.all(const Radius.circular(10.0))
          )
      ),
      maxLines: 6,
      maxLength: 150,
      controller: _contentController,
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
      contentTextField,
      new Text("提示：最多上传3张照片,默认第一张照片为封面照片", style: new TextStyle(fontSize: 12.0),),
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
    // 如果已添加了3张图片，则提示不允许添加更多
    num size = fileList.length;
    if (size >= 3) {
      Scaffold.of(ctx).showSnackBar(new SnackBar(
        content: new Text("最多只能添加3张图片！"),
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
    String content = _contentController.text;
    String title = _titleController.text;
    FormData formData;
    if (title == null || title.length == 0 || title.trim().length == 0) {
      Scaffold.of(ctx).showSnackBar(new SnackBar(
        content: new Text("请输入文章标题！"),
      ));
      return;
    }
    if (content == null || content.length == 0 || content.trim().length == 0) {
      Scaffold.of(ctx).showSnackBar(new SnackBar(
        content: new Text("请输入文章内容！"),
      ));
      return;
    }
    if (fileList.length == 0){
      if(widget.category == '认证夫妻'){
        Scaffold.of(ctx).showSnackBar(new SnackBar(
          content: new Text("请上传带ID的认证照片"),
        ));
      }else{
        Scaffold.of(ctx).showSnackBar(new SnackBar(
          content: new Text("请至少上传一张照片"),
        ));
      }
      return;
    }
    if (fileList.length == 1){
      var filename = fileList[0].path.substring(fileList[0].path.lastIndexOf("/") + 1);

      formData = new FormData.from({
      "title": title,
      "brief": title,
      'content':content,
      'category_name':widget.category,
      'head_img':UploadFileInfo(fileList[0],filename),
      });
    }else if (fileList.length == 2){
      var filename = fileList[0].path.substring(fileList[0].path.lastIndexOf("/") + 1);
      var filename2 = fileList[1].path.substring(fileList[1].path.lastIndexOf("/") + 1);

      formData = new FormData.from({
        "title": title,
        "brief": title,
        'content':content,
        'category_name':widget.category,
        'head_img':UploadFileInfo(fileList[0],filename),
        'head_img2':UploadFileInfo(fileList[1],filename2),
      });
    }else if (fileList.length == 3){
      var filename = fileList[0].path.substring(fileList[0].path.lastIndexOf("/") + 1);
      var filename2 = fileList[1].path.substring(fileList[1].path.lastIndexOf("/") + 1);
      var filename3 = fileList[2].path.substring(fileList[2].path.lastIndexOf("/") + 1);

      formData = new FormData.from({
        "title": title,
        "brief": title,
        'content':content,
        'category_name':widget.category,
        'head_img':UploadFileInfo(fileList[0],filename),
        'head_img2':UploadFileInfo(fileList[1],filename2),
        'head_img3':UploadFileInfo(fileList[2],filename3),
      });
    }

    try{
      var response = await dioTool.dio.post('${Constants.host}/app/writeArticle/',data:formData);
      Navigator.of(context).pop();
      if (widget.category == '认证夫妻'){
        tool.showToast("发布成功,请去认证夫妻板块查看");
      }else{
        tool.showToast("发布成功,请去论坛板块查看");
      }
    }on DioError catch (e){
      print(e.response.statusCode);
      tool.showToast("网络异常");
      Navigator.of(context).pushNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title, style: new TextStyle(color: Colors.white)),
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