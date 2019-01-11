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
            Text('请在浏览器打开后下载安装:',textAlign:TextAlign.center,style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15
            ),),
            Text(Constants.downloadUrl,textAlign:TextAlign.center,style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 20
            )),
          ],
        ),
      ),
    );
  }

}