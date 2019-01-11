import 'package:flutter/material.dart';
import 'package:flutter_fuqi/publish/taskItem.dart';
import 'package:flutter_fuqi/publish/publishArticlePage.dart';
import 'package:flutter_fuqi/constants.dart';
import 'package:flutter_fuqi/modal/task.dart';
import 'package:flutter_fuqi/publish/publishDynamicPage.dart';
import 'package:flutter_fuqi/publish/publishImagePage.dart';
import 'package:flutter_fuqi/publish/publishHeadImg.dart';

class publishPage extends StatefulWidget{
  @override
  _publishPageState createState() {
    // TODO: implement createState
    return _publishPageState();
  }
}

class _publishPageState extends State<publishPage>{

  List<Task> tasksList = TaskManager.tasksList;
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
                Navigator.push(context,MaterialPageRoute(builder: (BuildContext ctx){
                  if (item.title == "我要认证"){
                    return publishArticlePage(category:"认证夫妻",title: item.title);
                  }else if(item.title == "我要写文章"){
                    return publishArticlePage(category:"论坛",title: item.title);
                  }else if(item.title == "我要上传照片"){
                    return publishImagePage();
                  }else if(item.title == "我要写动态"){
                    return publishDynamicPage();
                  }else if(item.title == "我要改头像"){
                    return publishHeadImagePage();
                  }
                }));
              },
            );
          },
        ),
      ),
    );
  }
}