import 'package:flutter/material.dart';
import 'package:flutter_fuqi/dio/dio.dart';
import 'package:flutter_fuqi/constants.dart';
import 'package:flutter_fuqi/tool/tool.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:dio/dio.dart';



class softwarePage extends StatefulWidget{

  @override
  _softwarePageState createState() {
    // TODO: implement createState
    return _softwarePageState();
  }

}

class _softwarePageState extends State<softwarePage>{
  static String _version = Constants.version;
  String _result = "当前软件版本为:"+_version;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkSysVersion(context);

  }

  _checkSysVersion(BuildContext context) async {
    var response;
    try{
      response = await dioTool.dio.get("${Constants.host}/app/version/");
      _version = response.data[0]['version'];
      if(_version != Constants.version){
        Alert(
          context: context,
          type: AlertType.warning,
          title: "软件版本需要更新",
          desc: "修复软件问题,增加新功能",
          buttons: [
            DialogButton(
              child: Text(
                "立即更新",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                _version = response.data[0]['version'];
                Navigator.of(context).pushNamed('/update');
              },
              color: Color.fromRGBO(0, 179, 134, 1.0),
            ),
            DialogButton(
              child: Text(
                "暂不更新",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.of(context).pop(),
              gradient: LinearGradient(colors: [
                Color.fromRGBO(116, 116, 191, 1.0),
                Color.fromRGBO(52, 138, 199, 1.0)
              ]),
            )
          ],
        ).show();
      }else{
        setState(() {
          _result = "当前版本已经是最新版本:$_version,无需更新";
        });
      }
    }on DioError catch (e) {
      tool.showToast("网络异常");
    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("软件版本检查"),
        centerTitle: true,
      ),
      body: Center(
        child: Text(_result,style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0
        ),),
      ),
    );
  }
}