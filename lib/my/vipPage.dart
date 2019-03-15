import 'package:flutter/material.dart';


class vipPage extends StatelessWidget {

  List<List<String>> _all=[
  ['服务内容','认证夫妻','高级会员','钻石会员','皇冠会员','至尊会员'],
  ['夫妻币','100枚/月','100枚/月','300枚/月','600枚/月','1000枚/月'],
  ['91视频','可以','可以','可以','可以','可以'],
  ['推荐夫妻','不行','不行','不行','可以','可以'],
  ['加认证夫妻群','可以','不行','不行','可以','可以'],
  ['查看联系方式', '可以','可以','可以','可以','可以'],
  ['参加活动', '可以','不行','可以','可以','可以'],
  ['组织活动','不行','不行','不行','不行',  '可以'],
  ['加各省QQ群','可以','不行','可以','可以','可以'],
  ['有效期','1个月','一年','三年','五年','永久'],
  ['价格', '0','199','399','599','899']
  ];


  List<Widget> _buildGridTileList(){
    List<Widget> widgetList = [];
    for(int i=0; i<_all.length; i++) {
      for (int j = 0; j < _all[i].length; j++) {
        var color;
        if(_all[i][0] == "价格" || _all[i][0] == "组织活动" || _all[i][0] == "夫妻币"
            || _all[i][0] == "推荐夫妻" || _all[i][0] == "有效期" || _all[i][0] == "夫妻推荐"||_all[i][j] == "不行"){
          color = Colors.red;
        }
        widgetList.add(
            Container(
              alignment: Alignment.center,
              child: Text(_all[i][j],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:color,
                ),),
            )
        );
      }
    }

    return widgetList;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("VIP权限说明"),
          centerTitle: true,
        ),
        body: GridView.count(
            crossAxisCount: 6,
            padding: const EdgeInsets.all(3.0),
            childAspectRatio:1.4,
            mainAxisSpacing: 0.0,
            crossAxisSpacing: 0.0,
            children: _buildGridTileList()
        )
    );
  }
}
