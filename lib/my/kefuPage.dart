import 'package:flutter/material.dart';
import 'package:flutter_fuqi/constants.dart';

class kefuPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('联系客服'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child:Row(
                      children: <Widget>[
                        Icon(IconData(0xe605,fontFamily: Constants.IconFontFamily)),
                        Container(width: 10.0,),
                        Text(Constants.qq)
                      ]),
                ),
                Divider(),
                Container(
                  alignment: Alignment.centerLeft,
                  child:Row(
                      children: <Widget>[
                        Icon(IconData(0xe605,fontFamily: Constants.IconFontFamily)),
                        Container(width: 10.0,),
                        Text(Constants.qq2)
                      ]),
                ),
                Divider(),
                Container(
                  alignment: Alignment.centerLeft,
                  child:Row(
                      children: <Widget>[
                        Icon(IconData(0xe768,fontFamily: Constants.IconFontFamily)),
                        Container(width: 10.0,),
                        Text(Constants.weixin)
                      ]),
                ),
                Divider(),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text('官方网站:${Constants.host}'),
                ),
              ]),
        ),
      ),
    );
  }
}