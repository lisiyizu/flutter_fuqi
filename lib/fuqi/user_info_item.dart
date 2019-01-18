import 'package:flutter/material.dart';
import 'package:flutter_fuqi/constants.dart';
import 'package:flutter_fuqi/modal/userData.dart';
import 'package:flutter_fuqi/fuqi/user_detail.dart';


class UserInfoItem extends StatelessWidget {
  final String tag;
  final UserData userData;
  const UserInfoItem({Key key,@required this.tag,@required this.userData}):super(key:key);


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var ProfileTextStyle;
    String identifyText = "";
    String profile = userData.profile;
    if (userData.is_identification){
      identifyText = ",已认证";
    }

    //是否显示红色
    if (userData.profile != '普通会员' || userData.is_identification || (userData.is_spa && tag=='spa')){
      ProfileTextStyle = AppStyles.FuqiInfoSpecialStyle;
    }else{
      ProfileTextStyle = AppStyles.FuqiInfoStyle;
    }

    //spa技师显示技师级别
    if (userData.is_spa && tag=='spa'){
      profile = userData.spa_profile;
    }

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
            return UserDetail(id:userData.id);
          }));
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.network("${userData.head_img}",width: Constants.FuqiAvatarSize,height:Constants.FuqiAvatarSize,fit: BoxFit.cover,),
            Container(
              width: 10,
            ),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("昵称:${userData.name},年纪:${userData.age},人气:${userData.read_count}",style: AppStyles.FuqiInfoStyle),
                    Text("性别:${userData.sex},寻找:${userData.target}",style: AppStyles.FuqiInfoStyle),
                    Text("地点:${userData.province},${userData.city},夫妻币:${userData.free_count}",style: AppStyles.FuqiInfoStyle),
                    Text("权限:$profile$identifyText",style: ProfileTextStyle),
                    Text("简介:${userData.desc}",style:AppStyles.FuqiInfoStyle),
                  ],
                )
            ),
          ],
        ),
      )
    );
  }

}