import 'package:flutter/material.dart';
import 'package:flutter_fuqi/constants.dart';
import 'package:flutter_fuqi/message/messagePage.dart';
import 'package:flutter_fuqi/fuqi/fuqiPage.dart';
import 'package:flutter_fuqi/discover/discoverPage.dart';
import 'package:flutter_fuqi/publish/publishPage.dart';
import 'package:flutter_fuqi/my/myInfoPage.dart';


enum ActionItems {
   read_count,
   log_time,
   recommend_fuqi,
   recommend_dan,
   spa_tech,
}
class NavigationIconView {
  final BottomNavigationBarItem item;

  NavigationIconView({Key key, String title, IconData icon, IconData activeIcon}) :
        item = BottomNavigationBarItem(
          icon: Icon(icon),
          activeIcon: Icon(activeIcon),
          title: Text(title),
          backgroundColor: Colors.white,
        );
}


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() {
    // TODO: implement createState
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage>{

  PageController _pageController;
  int _currentIndex = 0;
  List<NavigationIconView> _navigationViews;
  List<Widget> _pages;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);//页面控制器
    _pages = [
      fuqiPage(),
      discoverPage(),
      publishPage(),
      messagePage(),
      myInfoPage(),
    ];
    _navigationViews = [
      NavigationIconView(
          title: '夫妻',
          icon: IconData(
            0xe73e,
            fontFamily:Constants.IconFontFamily,
          ),
          activeIcon: IconData(
            0xe696,
            fontFamily:Constants.IconFontFamily,
          )
      ),
      NavigationIconView(
          title: '发现',
          icon: IconData(
            0xe66c,
            fontFamily:Constants.IconFontFamily,
          ),
          activeIcon: IconData(
            0xe610,
            fontFamily:Constants.IconFontFamily,
          )
      ),
      NavigationIconView(
          title: '发布',
          icon: IconData(
            0xe66e,
            fontFamily:Constants.IconFontFamily,
          ),
          activeIcon: IconData(
            0xe66e,
            fontFamily:Constants.IconFontFamily,
          )
      ),
      NavigationIconView(
          title: '聊天',
          icon: IconData(
            0xe602,
            fontFamily:Constants.IconFontFamily,
          ),
          activeIcon: IconData(
            0xe61a,
            fontFamily:Constants.IconFontFamily,
          )
      ),
      NavigationIconView(
          title: '我',
          icon: IconData(
            0xe649,
            fontFamily:Constants.IconFontFamily,
          ),
          activeIcon: IconData(
            0xe634,
            fontFamily:Constants.IconFontFamily,
          )
      )
    ];
  }
  _buildPopupMenuItem(int iconName,String title){
    return Row(
      children: <Widget>[
        Icon(IconData(iconName,fontFamily: Constants.IconFontFamily),size: 22.0,color: const Color(AppColors.AppBarPopupMenuColor) ,),
        Container(width: 12.0,),
        Text(title,style: TextStyle(color: const Color(AppColors.AppBarPopupMenuColor)),)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBar botNavBar  =  BottomNavigationBar (
      fixedColor: const Color(AppColors.TabIconActive),//选中时文字的颜色
      items:_navigationViews.map((NavigationIconView view) {
        return view.item;
      }).toList(),
      currentIndex: _currentIndex,//当前显示的是哪一个view
      type: BottomNavigationBarType.fixed,
      onTap: (int index){
        setState((){
          _currentIndex = index;
          //按Tab建时页面进行切换
          _pageController.animateToPage(_currentIndex,duration: Duration(milliseconds: 20),curve: Curves.easeInOut);
        });
      }
    );
    return Scaffold(
//      appBar: AppBar(
//        title: Text('夫妻之家'),
//        centerTitle:true,
//        actions: <Widget>[
//          Container(
//             padding: EdgeInsets.only(right: 16.0),
//             child: PopupMenuButton(
//               itemBuilder: (BuildContext context) {
//                 return <PopupMenuItem<ActionItems>>[
//                   PopupMenuItem(
//                     child: _buildPopupMenuItem(0xe611,"按人气排序"),
//                     value: ActionItems.read_count,
//                   ),
//                   PopupMenuItem(
//                     child: _buildPopupMenuItem(0xe619,"按登陆时间"),
//                     value: ActionItems.log_time,
//                   ),
//                   PopupMenuItem(
//                     child: _buildPopupMenuItem(0xe78f,"推荐夫妻"),
//                     value: ActionItems.recommend_fuqi,
//                   ),
//                   PopupMenuItem(
//                     child: _buildPopupMenuItem(0xe78f,"推荐单男"),
//                     value: ActionItems.recommend_dan,
//                   ),
//                   PopupMenuItem(
//                     child: _buildPopupMenuItem(0xe6ab,"SPA技师"),
//                     value: ActionItems.spa_tech,
//                   ),
//                 ];
//               },
//               icon: Icon(IconData(
//                   0xe620,
//                   fontFamily: Constants.IconFontFamily
//               ),size: 22),
//               onSelected: (ActionItems selected) {
//                 print('点击的是$selected');
//               },
//             ),
//          )
//        ],
//      ),
      body: PageView.builder(
        itemBuilder: (BuildContext context,int index){
          return _pages[index];//返回指定页面
        },
        controller: _pageController,
        itemCount: _pages.length,
        onPageChanged: (int index) {//页面滑动时Tab也进行切换
         setState(() {
           _currentIndex = index;
         });

        }
       ),
      bottomNavigationBar: botNavBar,
    );
    }
}
