import 'package:flutter/material.dart';


class vipPage extends StatelessWidget {

  List<String> _all=[
  '服务内容','普通会员','认证夫妻专享','高级VIP会员','钻石VIP会员','皇冠VIP会员','至尊VIP会员',
  '夫妻币', '0','100枚/月','100枚/月','400枚/月','600枚/月','1000枚/月',
  '加精品夫妻群', '不行','可以','可以','可以','可以','可以',
  '查看联系方式', '可以' ,'可以','可以','可以','可以','可以',
  '参加活动','不行', '可以','不行','可以','可以','可以',
  '组织活动','不行','不行','不行','不行','不行',  '可以',
  '加各省QQ群', '不行','可以','可以','可以','可以','可以',
  '有效期',  '0','3个月','一年','三年','五年','永久',
  '升级所需金钱', '0', '0','168','258','399','599'
  ];


  List<Widget> _buildGridTileList(){
    List<Widget> widgetList = [];
    for(int i=0; i<_all.length; i++){
      widgetList.add(
        Container(
          child: Text(_all[i],style: TextStyle(
            fontWeight: FontWeight.bold
          ),),
        )
      );
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
            crossAxisCount: 7,
            children: _buildGridTileList()
        )
    );
  }
}
