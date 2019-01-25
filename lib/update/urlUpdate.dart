import 'package:flutter/material.dart';
import 'package:flutter_fuqi/constants.dart';


class urlUpdate extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('下载最新版本'),
        centerTitle: true,
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            Container(height: 50,),
            Text('请打开浏览器并输入以下地址:',textAlign:TextAlign.center,style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25
            ),),
            Text(Constants.downloadUrl,textAlign:TextAlign.center,style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 30
            )),
          ],
        ),
      ),
    );
  }

}