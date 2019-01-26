import 'package:flutter/material.dart';
import 'package:flutter_fuqi/constants.dart';
import 'package:flutter_fuqi/modal/conversation.dart';
import 'package:flutter_fuqi/message/chatPage.dart';
import 'package:flutter_fuqi/tool/tool.dart';

class ConverSationItem extends StatelessWidget{

  final Conversation conversation;
  var originConversation;

  ConverSationItem({Key key,this.conversation,this.originConversation}):super(key:key);

  @override
  Widget build(BuildContext context) {
    //根据图片的获取方式初始化头像
    Widget avatar = tool.getCacheImage(url: conversation.avatar,width: Constants.ContactAvatarSize, height: Constants.ContactAvatarSize);

    //未读消息角标
    Widget avatarContainer;
    if (conversation.unreadMsgCount > 0) {
      Widget unreadMsgCountText = Container(
        width: Constants.UnReadMsgNotifyDotSize,
        height: Constants.UnReadMsgNotifyDotSize,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Constants.UnReadMsgNotifyDotSize/2.0),
          color: Color(AppColors.NotifyDotBg),
        ),
        child: Text(conversation.unreadMsgCount.toString(),style: AppStyles.UnreadMsgCountDotStyle),
      );
      avatarContainer = Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          avatar,
          Positioned(
            right: -6.0,
            top: -6.0,
            child: unreadMsgCountText,
          )
        ],
      );
    }else{
      avatarContainer = avatar;
    }

    return GestureDetector(
      onTap: (){
        if(conversation.unreadMsgCount>0){
          conversation.unreadMsgCount = 0;
        }
         Navigator.push(context,MaterialPageRoute(builder: (BuildContext ctx){
          return chatPage(originConversation:originConversation);
        }));

      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Color(AppColors.ConversationItemBg),
            border: Border(
                bottom: BorderSide(
                    color: Color(AppColors.DividerColor),
                    width: Constants.DividerWidth
                )
            )
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            avatarContainer,
            Container(
              width: 10,
            ),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(conversation.title,style: AppStyles.TitleStyle),
                    Text(conversation.des,style: AppStyles.DesStyle),
                  ],
                )
            ),
            Container(
              width: 10,
            ),
            Column(
              children: <Widget>[
                Text(conversation.updateAt,style: AppStyles.DesStyle),
              ],
            ),
          ],
        ),
      ),
    );
  }
}