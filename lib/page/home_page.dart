import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

const APPBAR_SCROLL_OFFSET = 100; //appBar最大偏移量

class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>__HomePageState();
}

class __HomePageState extends State<HomePage>{

  //轮播图数据
  List _bannerList = [
    'http://pages.ctrip.com/commerce/promote/20180718/yxzy/img/640sygd.jpg',
    'https://dimg04.c-ctrip.com/images/700u0r000000gxvb93E54_810_235_85.jpg',
    'https://dimg04.c-ctrip.com/images/700c10000000pdili7D8B_780_235_57.jpg'
  ];

  double _appBarAlpha = 0;  //AppBar透明度

  _onScroll(offset) {
    double alpha = offset / APPBAR_SCROLL_OFFSET;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    setState(() {
      _appBarAlpha = alpha;
    });
//    print(_appBarAlpha);
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(  //stack:相当于相对布局,后添加的控件会显示在层级最上方
        children: [
          MediaQuery.removePadding(       //MediaQuery:设备信息(屏幕宽高,设备旋转等)
              removeTop: true,            //去除顶部padding,listview有默认的顶部padding
              context: context,
              child: NotificationListener(  //监听事件()
                onNotification: (scrollNotification){
                  if (scrollNotification is ScrollUpdateNotification &&  //监听滑动事件
                      scrollNotification.depth == 0) {          //depth=0:表示只监听child组件,child里面的子组件不监听
                    //滚动且是列表滚动的时候
                    _onScroll(scrollNotification.metrics.pixels);
                  }
                },
                child: ListView(
                  children: [
                    BannerWidget(bannerList: _bannerList),
                  ],
                ),
              )
          ),
          AppBarWidget(appBarAlpha: _appBarAlpha),
        ],
      )
    );
  }

}

//自定义AppBar
class AppBarWidget extends StatefulWidget{
   double _appBarAlpha;
   AppBarWidget({ Key key, @required double appBarAlpha,}) : _appBarAlpha = appBarAlpha,
         super(key: key);
  @override
  State<StatefulWidget> createState()=> _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget>{

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget._appBarAlpha,  //获取AppBarWidget中的_appBarAlpha属性
      child: Container(
        height: 80,
        decoration: BoxDecoration(color: Colors.yellow),
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text('首页'),
          ),
        ),
      ),
    );
  }

}

//轮播图
class BannerWidget extends StatelessWidget{

  final List _bannerList;

  BannerWidget({Key key,@required List bannerList}) : _bannerList = bannerList,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      child: Swiper(
        itemCount: _bannerList.length,
        autoplay: true,
        itemBuilder: (BuildContext context,int index){
          return Image.network(_bannerList[index],fit: BoxFit.fill);
        },
        pagination: new SwiperPagination()
      ),
    );
  }

}



