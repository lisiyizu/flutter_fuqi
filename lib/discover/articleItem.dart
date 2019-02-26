import 'package:flutter/material.dart';
import 'package:flutter_fuqi/modal/articleData.dart';
import 'package:flutter_fuqi/constants.dart';
import 'package:flutter_fuqi/tool/tool.dart';
import 'package:flutter_fuqi/discover/articleOtherDetail.dart';
import 'package:flutter_fuqi/discover/activityArticle.dart';


class articleItem extends StatelessWidget{
  articleData mData;
  String tag;

  articleItem({Key key,@required this.tag,@required this.mData}):super(key:key);

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
            Navigator.push(context,MaterialPageRoute(builder: (BuildContext ctx){
              if(tag == "activity"){
                return activityDetail(mData: mData, tag: tag);
              }else{
                return articleOtherDetail(tag:tag,mData: mData);
              }

            }));
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              tool.getCacheImage(url: mData.head_img,width: Constants.FuqiAvatarSize,height: Constants.FuqiAvatarSize,fit: BoxFit.cover),
              Container(
                width: 10,
              ),
              Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,//平分区域
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("标题:${mData.title}",style: AppStyles.FuqiInfoStyle),
                      Text("简介:${mData.brief}",style: AppStyles.FuqiInfoStyle),
                      Text("人气:${mData.read_count}",style: AppStyles.FuqiInfoStyle),
                      Text("时间:${tool.processTime(mData.pub_date)}",style: AppStyles.FuqiInfoStyle),
                    ],
                  )
              ),
            ],
          ),
        )
    );
  }

}