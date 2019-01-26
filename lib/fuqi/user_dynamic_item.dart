import 'package:flutter/material.dart';


class userDynamicItem extends StatelessWidget {

  String des;
  String time;

  userDynamicItem({Key key,this.des,this.time}):super(key:key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black12))),//背景色和边框
      padding: EdgeInsets.fromLTRB(5.0,5.0,5.0,0.0),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Text(des,textAlign:TextAlign.left),
          ),
          Container(
            alignment: Alignment.centerRight,
            child: Text(time),
          )]),
    );
  }
}