import 'package:flutter/material.dart';
import 'package:flutter_fuqi/modal/video.dart';
import 'package:flutter_fuqi/constants.dart';
import 'package:flutter_fuqi/tool/tool.dart';
import 'package:flutter_fuqi/discover/videoPlayer.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_fuqi/tool/tool.dart';
import 'package:flutter_fuqi/dio/dio.dart';
import 'package:dio/dio.dart';


class videoItem extends StatelessWidget{
  Video mData;
  String tag;

  videoItem({Key key,@required this.tag,@required this.mData}):super(key:key);

  _reduceMyFreeCount(BuildContext context) async {
    String msg;
    var response;
    int free_count;
    try {
      //实时获取数据
      //await tool.getMyUserInfo(context:context,id:tool.myUserData['id']);
      //权限检查
      if(tool.myUserData['free_count']>=3){
        free_count = tool.myUserData['free_count']-3;
        String url = '${Constants.host}/app/userDetail/${tool.myUserData['id']}/';
        response = await dioTool.dio.patch(url,data:{'free_count':free_count});
        tool.myUserData = response.data;
        tool.showToast("夫妻币减3");
        Navigator.of(context).pop();
        Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
          return videoPlayer(mData:mData);
          //return videoPlayer();
        }));
      }else{
        Navigator.of(context).pop();
        tool.goToQuestion(context:context,title:"查看如何获取夫妻币",desc: "您的夫妻币不足");
      }
    }on DioError catch(e) {
      if(e.response.statusCode == 401){
        msg = "登录信息已失效,请重新登录";
        Navigator.of(context).pushNamed('/login');
      }else{
        msg = "网络不佳,请稍候再试";
      }
      tool.showToast(msg);
      return;
    }
}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Color(AppColors.ConversationItemBg),
            border: Border(
                bottom: BorderSide(
                    color: Color(AppColors.DividerColor),
                    width: Constants.DividerWidth
                )
            )
        ),
        child: GestureDetector(
          onTap: (){
            Alert(
              context: context,
              type: AlertType.warning,
              title: "观看需要消耗3枚夫妻币",
              desc: "您当前的夫妻币是:${tool.myUserData['free_count']}",
              buttons: [
                DialogButton(
                  child: Text(
                    "取消",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  gradient: LinearGradient(colors: [
                    Color.fromRGBO(116, 116, 191, 1.0),
                    Color.fromRGBO(52, 138, 199, 1.0)
                  ]),
                ),
                DialogButton(
                  child: Text(
                    "确定",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () {
                    _reduceMyFreeCount(context);
                  },
                  color: Color.fromRGBO(0, 179, 134, 1.0),
                ),
              ],
            ).show();
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              //Image.network("${mData.image}",width: Constants.FuqiAvatarSize,height:Constants.FuqiAvatarSize,fit: BoxFit.cover,),
              tool.getCacheImage(url: mData.image,width: Constants.FuqiAvatarSize,height:Constants.FuqiAvatarSize,fit: BoxFit.cover),
              Container(
                width: 10,
              ),
              Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,//平分区域
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("简介:${mData.desc}",style: AppStyles.FuqiInfoStyle),
                      Text("时间:${tool.processTime(mData.date)}",style: AppStyles.FuqiInfoStyle),
                    ],
                  )
              ),
            ],
          ),
        )
    );
  }

}