import 'package:flutter/material.dart';
import 'package:flutter_fuqi/publish/taskItem.dart';
import 'package:flutter_fuqi/publish/publishArticlePage.dart';
import 'package:flutter_fuqi/constants.dart';
import 'package:flutter_fuqi/modal/task.dart';
import 'package:flutter_fuqi/my/kefuPage.dart';
import 'package:flutter_fuqi/update/erweimaUpdate.dart';
import 'package:flutter_fuqi/update/urlUpdate.dart';

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
                Navigator.push(context,MaterialPageRoute(builder: (BuildContext ctx){
                  if (item.title == "升级方式一"){
                    return kefuPage();
                  }else if(item.title == "升级方式二"){
                    return erweimaUpdate();
                  }else if(item.title == "升级方式三"){
                    return urlUpdate();
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