import 'package:flutter/material.dart';
import 'package:flutter_fuqi/publish/taskItem.dart';
import 'package:flutter_fuqi/constants.dart';
import 'package:flutter_fuqi/modal/task.dart';
import 'package:flutter_fuqi/my/kefuPage.dart';
import 'package:flutter_fuqi/tool/tool.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class updatePage extends StatefulWidget{
  @override
  _updatePageState createState() {
    // TODO: implement createState
    return _updatePageState();
  }
}

class _updatePageState extends State<updatePage>{

  List<Task> tasksList = updateManager.tasksList;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "我要升级",
          style: TextStyle(
              color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 32.0),
        child: ListView.builder(
          itemCount: tasksList.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            var item = tasksList.elementAt(index);
            return GestureDetector(
              child: TaskWidget(task: item),
              onTap: (){
                if (item.title == "更新异常"){
                  Navigator.push(context,MaterialPageRoute(builder: (BuildContext ctx){
                    return kefuPage();
                  }));
                }else if(item.title == "升级方式一"){
                  Alert(
                    context: context,
                    type: AlertType.warning,
                    title: "苹果手机信任和下载问题",
                    desc: "1.请在苹果自带Safari浏览器打开 2.信任在设置-通用-设备管理(或设备描述等)中设置",
                    buttons: [
                      DialogButton(
                        child: Text(
                          "我已知道",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () => tool.launchURL(url: tool.updateUrl),
                        color: Color.fromRGBO(0, 179, 134, 1.0),
                      ),
                    ],
                  ).show();
                }else{
                  tool.launchURL(url: tool.updateUrl);
                }
              },
            );
          },
        ),
      ),
    );
  }
}