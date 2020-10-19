import 'package:flutter/material.dart';
import 'package:flutter_xiecheng/page/home_page.dart';
import 'package:flutter_xiecheng/page/search_page.dart';
import 'package:flutter_xiecheng/page/travel_page.dart';
import 'package:flutter_xiecheng/page/my_page.dart';

class TabNavigator extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  final PageController _controller = new PageController(initialPage: 0);
  final MaterialColor defaultColor = Colors.grey;
  final MaterialColor activeColor = Colors.blue;
  int __currentIndex = 0; //当前选中的是哪个tabbar

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        onPageChanged: (index) {
          setState(() {
            __currentIndex = index;
          });
        },
        physics: NeverScrollableScrollPhysics(), //不响应用户的滚动
        children: [
          HomePage(),
          SearchPage(),
          TravelPage(),
          MyPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: __currentIndex,
        onTap: (index) {
          _controller.jumpToPage(index);
          setState(() {
            __currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: [
          _navigationBarItem(Icons.home, '首页',0),
          _navigationBarItem(Icons.search, '搜索',1),
          _navigationBarItem(Icons.camera, '旅拍',2),
          _navigationBarItem(Icons.account_box, '我的',3),
        ],
      ),
    );
  }

  _navigationBarItem(IconData iconData, String itemName, int index) {
    return BottomNavigationBarItem(
        icon: Icon(
          iconData,
          color: defaultColor,
        ),
        activeIcon: Icon(
          iconData,
          color: activeColor,
        ),
        label:itemName
    );
  }
}
