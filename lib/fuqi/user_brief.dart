import 'package:flutter/material.dart';
import 'package:flutter_fuqi/fuqi/user_info_item.dart';
import 'package:flutter_fuqi/modal/userData.dart';


class UserBrief extends StatelessWidget {
  var userBrief;

  UserBrief({Key key,@required this.userBrief}):super(key:key);

  @override
  Widget build(BuildContext context) {
    UserData userData=UserData(
      id:userBrief['id'],
      name:userBrief['name'],
      desc:userBrief['desc'],
      head_img: userBrief['head_img'],
      sex: userBrief['sex'],
      target: userBrief['target'],
      qq: userBrief['qq'],
      profile: userBrief['profile'],
      province: userBrief['province'],
      city: userBrief['city'],
      age: userBrief['age'],
      login_time: userBrief['login_time'],
      buy_time: userBrief['buy_time'],
      free_count: userBrief['free_count'],
      read_count: userBrief['read_count'],
      ip: userBrief['ip'],
      is_identification: userBrief['is_identification'],
      is_spa: userBrief['is_spa'],
      spa_profile: userBrief['spa_profile'],
      user: userBrief['user'],
    );
    return UserInfoItem(tag:"hot",userData:userData);
  }


}