import 'package:flutter/material.dart';
import 'package:flutter_fuqi/fuqi/user_detail.dart';
import 'package:flutter_fuqi/tool/tool.dart';


class chatItem extends StatelessWidget{

  var originConversation;
  int index;
  chatItem({Key key,this.originConversation,this.index}):super(key:key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //是自己发的
    if(originConversation['converstation_message'][index]['user'] == tool.myUserData['id']){
      return Container(
          child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Flexible(
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                          child: new Text(
                              originConversation['converstation_message'][index]['content'],
                              style: new TextStyle(fontSize: 16.0))
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context,MaterialPageRoute(builder: (BuildContext ctx){
                          return UserDetail(id:originConversation['converstation_message'][index]['user']);
                        }));
                      },
                      child: Container(
                        width: 35.0,
                        height: 35.0,
                        decoration: new BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.transparent,
                          image: new DecorationImage(
                              image: new NetworkImage(originConversation[tool.getPersonInfo(originConversation,true)]['head_img']),
                              fit: BoxFit.cover),
                          border: new Border.all(
                            color: Colors.white,
                            width: 2.0,),
                        ),),
                    ),
                    Container(width: 5.0,)
                  ]),
                    Divider()]
          )
      );
    }else{
      return Container(
          child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(width: 5.0,),
                    GestureDetector(
                      onTap: (){
                          Navigator.push(context,MaterialPageRoute(builder: (BuildContext ctx){
                          return UserDetail(id:originConversation['converstation_message'][index]['user']);
                        }));
                      },
                      child: Container(
                        width: 35.0,
                        height: 35.0,
                        decoration: new BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.transparent,
                          image: new DecorationImage(
                              image: new NetworkImage(originConversation[tool.getPersonInfo(originConversation,false)]['head_img']),
                              fit: BoxFit.cover),
                          border: new Border.all(
                            color: Colors.white,
                            width: 2.0,),
                        ),),
                    ),
                    Flexible(
                        child:Padding(
                            padding: const EdgeInsets.fromLTRB(6.0, 0.0, 0.0, 0.0),
                            child: new Text(
                                originConversation['converstation_message'][index]['content'],
                                style: new TextStyle(fontSize: 16.0)))

                    ),],
                ),
                Divider()]
          )
      );
    }
  }
}
