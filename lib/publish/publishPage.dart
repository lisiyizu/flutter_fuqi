import 'package:flutter/material.dart';
import 'package:flutter_fuqi/publish/taskItem.dart';
import 'package:flutter_fuqi/publish/publishArticlePage.dart';
import 'package:flutter_fuqi/constants.dart';
import 'package:flutter_fuqi/modal/task.dart';
import 'package:flutter_fuqi/publish/publishDynamicPage.dart';
import 'package:flutter_fuqi/publish/publishImagePage.dart';
import 'package:flutter_fuqi/publish/publishHeadImg.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


class publishPage extends StatefulWidget{
  @override
  _publishPageState createState() {
    // TODO: implement createState
    return _publishPageState();
  }
}

class _publishPageState extends State<publishPage>{

  List<Task> tasksList = TaskManager.tasksList;
  String title;
  String desc;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: Text(
          "我要发布",
          style: TextStyle(
              color: Colors.black, fontSize: 34.0, fontWeight: FontWeight.bold),
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
                if(item.title == "我要认证"){
                  title = "认证须知";
                  desc = "1.女方手持,无需露脸 2.纸上写夫妻之家四个字和你的ID 3.不符合者将被删帖";
                  Alert(
                    context: context,
                    type: AlertType.warning,
                    title: title,
                    desc: desc,
                    buttons: [
                      DialogButton(
                        child: Text(
                          "我已知道",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.push(context,MaterialPageRoute(builder: (BuildContext ctx){
                            return publishArticlePage(category:"认证夫妻",title: item.title);
                          }));
                        },
                        color: Color.fromRGBO(0, 179, 134, 1.0),
                      )],
                  ).show();
                }else if(item.title == "我要写文章"){
                  title = "发帖须知";
                  desc = "发广告者封号,发漏点者删帖";
                  Alert(
                    context: context,
                    type: AlertType.warning,
                    title: title,
                    desc: desc,
                    buttons: [
                      DialogButton(
                      child: Text(
                      "我已知道",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.push(context,MaterialPageRoute(builder: (BuildContext ctx){
                          return publishArticlePage(category:"论坛",title: item.title);
                        }));
                    },
                    color: Color.fromRGBO(0, 179, 134, 1.0),
                     )
                    ],
                  ).show();
                }else if(item.title == "我要上传照片"){
                    Navigator.push(context,MaterialPageRoute(builder: (BuildContext ctx){
                      return publishImagePage();
                    }));
                }else if(item.title == "我要写动态"){
                    Navigator.push(context,MaterialPageRoute(builder: (BuildContext ctx){
                      return publishDynamicPage();
                    }));
                }else if(item.title == "我要改头像"){
                      Navigator.push(context,MaterialPageRoute(builder: (BuildContext ctx){
                        return publishHeadImagePage();
                      }));
                }
              },
            );
          },
        ),
      ),
    );
  }
}