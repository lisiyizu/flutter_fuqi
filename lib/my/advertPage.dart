import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter_fuqi/tool/tool.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter_fuqi/constants.dart';


class advertPage extends StatefulWidget {

  @override
  _advertPageState createState() {
    // TODO: implement createState
    return _advertPageState();
  }
}





class _advertPageState extends State<advertPage>{
  GlobalKey rootWidgetKey = GlobalKey();
  Uint8List pngBytes;
  var _imageFile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _init();
  }

  void _init() async {

  }

  void _saveImage() async {
    RenderRepaintBoundary boundary =
    rootWidgetKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage(pixelRatio:2.0);
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final result = await ImageGallerySaver.save(byteData.buffer.asUint8List());
    if (result){
      tool.showToast("推广码已保存至相册");
    }else{
      tool.showToast("保存失败,请直接截图");
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: AppBar(
        title: Text('夫妻之家邀请码'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _saveImage();
        },
        icon: Icon(Icons.save_alt),
        label: Text('保存'),
        backgroundColor: Color.alphaBlend(Colors.green.withOpacity(0.8), Colors.white),
      ),
      body: ListView(
        children: <Widget>[
          RepaintBoundary(
            key: rootWidgetKey,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image:AssetImage("assets/images/advert.gif"),
                    fit: BoxFit.fill
                )
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(20.0),
                    child:Column(
                      children: <Widget>[
                        Text('邀请加入夫妻之家',textAlign:TextAlign.center,style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0
                        ),
                        ),
                        Text('如果QQ微信无法扫码,请使用浏览器扫码',textAlign:TextAlign.center,style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0
                        ),
                        ),
                      ],
                    )
                  ),
                  tool.downloadurl== null ?Image.asset("assets/images/download.png",width: 200,height: 200,):tool.getCacheImage(url:tool.downloadurl, width:200,height:200,bProcess: true),
                  //Image.asset("assets/images/download.png",width: 200,height: 200,),
                  Container(
                    padding: EdgeInsets.only(top: 5.0),
                    child:Text('或打开${Constants.downloadUrl}',textAlign:TextAlign.center,style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0
                    ),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(left: 5.0),
                      child: Text('邀请码:${tool.getMyAdvertCode()}',style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 40.0,
                      ),)
                  ),
                  Container(
                    padding: EdgeInsets.only(top:20.0,bottom: 5.0),
                    child:Text('免费的素质夫妻交友APP,拒绝嘴炮,欢迎真实夫妻',textAlign:TextAlign.center,style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0
                    ),
                    ),
                  ),
                ],
              ),
            )
          ),
        ],
      ),
    );
  }
}