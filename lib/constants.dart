import 'package:flutter/material.dart';
import 'package:flutter_fuqi/modal/task.dart';

class AppColors {
  static const BackgroundColor = 0xffebebeb;
  static const AppBarColor = 0xff303030;
  static const TabIconNormal = 0xff999999;
  static const TabIconActive = 0xff46c11b;
  static const AppBarPopupMenuColor = 0xffffffff;
  static const TitleTextColor = 0xff353535;
  static const ConversationItemBg = 0xffffffff;
  static const DesTextColor = 0xff9e9e9e;
  static const DividerColor = 0xffd9d9d9;
  static const NotifyDotBg = 0xffff3e3e;
  static const NotifyDotText = 0xffffffff;
  static const ConversationMuteIcon = 0xffd8d8d8;
  static const DeviceInfoItemBg = 0xfff5f5f5;
  static const DeviceInfoItemText = 0xff606062;
  static const DeviceInfoItemIcon = 0xff606062;
  static const ContactGroupTitleBg = 0xffebebeb;
  static const ContactGroupTitleText = 0xff888888;
  static const IndexLetterBoxBg = Colors.black45;
}

class AppStyles {
  static const TitleStyle = TextStyle(
    fontSize: 14.0,
    color: Color(AppColors.TitleTextColor),
  );
  static const FuqiInfoSpecialStyle = TextStyle(
    fontSize: 14.0,
    color: Colors.red,
  );
  static const FuqiInfoStyle = TextStyle(
    fontSize: 14.0,
    color: Color(AppColors.TitleTextColor),
  );
  static const DesStyle = TextStyle(
    fontSize: 12.0,
    color: Color(AppColors.DesTextColor),
  );

  static const UnreadMsgCountDotStyle = TextStyle(
    fontSize: 12.0,
    color: Color(AppColors.NotifyDotText),
  );

  static const DeviceInfoItemTextStyle = TextStyle(
    fontSize: 13.0,
    color: Color(AppColors.DeviceInfoItemText),
  );

  static const GroupTitleItemTextStyle = TextStyle(
    fontSize: 14.0,
    color: Color(AppColors.ContactGroupTitleText),
  );

  static const IndexLetterBoxTextStyle = TextStyle(
    fontSize: 64.0,
    color: Colors.white
  );
}

class Constants {
  static const IconFontFamily = "appIconFont";
  static const ConversationAvatarSize = 48.0;
  static const DividerWidth = 1.0;
  static const UnReadMsgNotifyDotSize = 20.0;
  static const ConversationMuteIconSize = 18.0;
  static const ContactAvatarSize = 36.0;
  static const FuqiAvatarSize = 100.0;
  static const IndexBarWidth = 24.0;
  static const IndexLetterBoxSize = 114.0;
  static const IndexLetterBoxRadius = 4.0;
  static const FullWidthIconButtonIconSize = 24.0;
  static const host='https://www.fuqi.site';
  static const defaultImage = 'assets/images/couple.jpg';
  static const qq = '2123108929';
  static const weixin = 'fuqi9970';
  static const gongzhonghao = '福气之家';
  static double bannerImageHeight = 150.0; //轮播图高度
  static const version = 1;//当前系统版本
  static const downloadUrl = 'https://www.fuqi.site/down';//当前系统版本
}

List<String> Provinces = [
  "北京" ,
  "上海",
  "江苏",
  "浙江",
  "广东",
  "山东",
  "河南",
  "安徽",
  "澳门",
  "重庆",
  "福建",
  "甘肃",
  "广西",
  "贵州",
  "海南",
  "湖北",
  "河北",
  "香港",
  "黑龙江",
  "湖南",
  "吉林",
  "江西",
  "辽宁",
  "内蒙古",
  "宁夏",
  "青海",
  "山西",
  "四川",
  "陕西",
  "天津",
  "台湾",
  "新疆",
  "西藏",
  "云南",
];



class TaskManager {
  /// A set of tasks
  static List<Task> tasksList = [
    Task(Colors.green, '我要认证', '成为认证夫妻,点亮认证图标,赠送VIP'),
    Task(Colors.blue, '我要改头像', '发布到我的个人资料中'),
    Task(Colors.red, '我要写文章', '发布文章到论坛'),
    Task(Colors.purple, '我要上传照片', '发布到我的相册中'),
    Task(Colors.amber, '我要写动态', '发布到我的个人资料中'),
  ];

  static addNewTask(Task task) => tasksList.add(task);
}

class updateManager {
  /// A set of tasks
  static List<Task> tasksList = [
    Task(Colors.green, '升级方式一', '找客服要最新软件'),
    Task(Colors.blue, '升级方式二', '扫二维码下载'),
    Task(Colors.red, '升级方式三', '浏览器下载'),
  ];

}