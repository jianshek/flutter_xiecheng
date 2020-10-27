import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_xiecheng/widget/local_nav.dart';
import 'package:flutter_xiecheng/model/common_model.dart';
import 'package:flutter_xiecheng/dao/home_dao.dart';
import 'package:flutter_xiecheng/model/home_model.dart';
import 'package:flutter_xiecheng/widget/grid_nav.dart';
import 'package:flutter_xiecheng/model/grid_nav_model.dart';
import 'package:flutter_xiecheng/widget/sub_nav.dart';
import 'package:flutter_xiecheng/widget/sales_box.dart';
import 'package:flutter_xiecheng/model/sales_box_model.dart';
import 'package:flutter_xiecheng/widget/loading_container.dart';

const APPBAR_SCROLL_OFFSET = 100; //appBar最大偏移量

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() =>__HomePageState();
}

class __HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive {
    return true;
  }

  //轮播图数据
  List _bannerList = [
    'http://pages.ctrip.com/commerce/promote/20180718/yxzy/img/640sygd.jpg',
    'https://dimg04.c-ctrip.com/images/700u0r000000gxvb93E54_810_235_85.jpg',
    'https://dimg04.c-ctrip.com/images/700c10000000pdili7D8B_780_235_57.jpg'
  ];

  double _appBarAlpha = 0;  //AppBar透明度
  List<CommonModel> localNavList = [];  //appBar下面的5个按钮
  GridNavModel gridNavModel;
  List<CommonModel> subNavList = [];
  SalesBoxModel salesBoxModel;
  bool _isLoading = true; //是否是加载状态

  @override
  void initState() {
    super.initState();
    _handleRefresh();
  }



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
      body: LoadingContainer(
        isLoading: _isLoading,
        cover: true,
        child: Stack(  //stack:相当于相对布局,后添加的控件会显示在层级最上方
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
                      LocalNavWidget(localNavList: localNavList),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.fromLTRB(14, 0, 14, 0),
                        margin: EdgeInsets.only(top: 10),
                        child: Column(
                          children: [
                            GridNav(gridNavModel: gridNavModel),
                            Padding(padding: EdgeInsets.only(top: 10)),
                            SubNav(subNavList: subNavList),
                            SalesBox(salesBoxModel: salesBoxModel),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
            ),
            AppBarWidget(appBarAlpha: _appBarAlpha),
          ],
        ),
      )
    );
  }


  Future<Null> _handleRefresh() async{
    try{

      HomeModel homeModel = await HomeDao.fetch();
      setState(() {
        localNavList = homeModel.localNavList;
        gridNavModel = homeModel.gridNav;
        subNavList = homeModel.subNavList;
        salesBoxModel = homeModel.salesBox;
        _isLoading = false;
      });

    }catch(e){
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
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

//轮播图下面的5个按钮
class LocalNavWidget extends StatelessWidget{

  final List _localNavList;

  const LocalNavWidget({Key key, @required List localNavList}) :  _localNavList = localNavList , super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(14, 0, 14, 0),
      child: LocalNav(localNavList: _localNavList),
    );
  }

}




