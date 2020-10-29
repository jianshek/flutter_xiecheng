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
import 'package:flutter_xiecheng/widget/webview.dart';
import 'package:flutter_xiecheng/widget/search_bar.dart';
import 'dart:ui' as ui show window;
import 'package:flutter_xiecheng/util/NavigatorUtil.dart';
import 'package:flutter_xiecheng/page/search_page.dart';

const APPBAR_SCROLL_OFFSET = 100; //appBar最大偏移量
const String SEARCH_BAR_DEFAULT_TEXT = "网红打卡地 景点 酒店 美食";  //搜索默认值

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() =>__HomePageState();
}

class __HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive {
    return true;
  }


  double _appBarAlpha = 0;  //AppBar透明度
  List<CommonModel> bannerList = [];    //轮播图
  List<CommonModel> localNavList = [];  //appBar下面的5个按钮
  GridNavModel gridNavModel;            //三行渐变
  List<CommonModel> subNavList = [];    //两行橙色
  SalesBoxModel salesBoxModel;          //热门活动
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
                child: RefreshIndicator(
                  onRefresh: _handleRefresh,
                  child: NotificationListener(  //监听事件
                    onNotification: (scrollNotification){
                      if (scrollNotification is ScrollUpdateNotification &&  //监听滑动事件
                          scrollNotification.depth == 0) {          //depth=0:表示只监听child组件,child里面的子组件不监听
                        //滚动且是列表滚动的时候
                        _onScroll(scrollNotification.metrics.pixels);
                      }
                    },
                    child:  ListView(
                      children: [
                        BannerWidget(bannerList: bannerList),
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
        bannerList = homeModel.bannerList;
        _isLoading = false;
      });

    }catch(e){
      print(e);
      setState(() {
        _isLoading = false;
      });
    }

    return null;
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
//    return Opacity(
//      opacity: widget._appBarAlpha,  //获取AppBarWidget中的_appBarAlpha属性
//      child: Container(
//        height: 80,
//        decoration: BoxDecoration(color: Colors.yellow),
//        child: Center(
//          child: Padding(
//            padding: EdgeInsets.only(top: 20),
//            child: Text('首页'),
//          ),
//        ),
//      ),
//    );
      return Column(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(   //线性渐变
                //AppBar渐变遮罩背景
                colors: [Color(0x66000000), Colors.transparent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Container(
              padding: EdgeInsets.only(top: MediaQueryData.fromWindow(ui.window).padding.top),  //刘海高度
              height: 80,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color:
                  Color.fromARGB((widget._appBarAlpha * 255).toInt(), 255, 255, 255)),
              child: SearchBar(
                searchBarType: widget._appBarAlpha > 0.3
                    ? SearchBarType.homeLight
                    : SearchBarType.home,
                inputBoxClick: _jumpToSearch,
                speakClick: _jumpToSpeak,
                defaultText: SEARCH_BAR_DEFAULT_TEXT,
                hideLeft: true,
                leftButtonClick: () {},
              ),
            ),
          ),
          Container(    //阴影设置
            height: widget._appBarAlpha > 0.3 ? 0.5 : 0,
            decoration: BoxDecoration(
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 0.5)]),
          ),
        ],
      );
  }

  _jumpToSearch() {
    NavigatorUtil.push(context, SearchPage(hint: SEARCH_BAR_DEFAULT_TEXT,hideLeft: false,keyword: "123",));
  }


  _jumpToSpeak() {

  }

}

//轮播图
class BannerWidget extends StatelessWidget{

  final List _bannerList;

  BannerWidget({Key key,@required List bannerList}) : _bannerList = bannerList,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if(_bannerList.length == 0){
      return Container();
    }
    return Container(
      height: 240,
      child: Swiper(
        itemCount: _bannerList.length,
        autoplay: true,
        itemBuilder: (BuildContext context,int index){
          return GestureDetector(
            onTap: (){
              CommonModel model = _bannerList[index];
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WebView(
                    url: model.url,
                  ),
                ),
              );
            },
            child: Image.network(_bannerList[index].icon,fit: BoxFit.fill),
          );
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
    if(_localNavList.length == 0){
      return Container();
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(14, 0, 14, 0),
      child: LocalNav(localNavList: _localNavList),
    );
  }

}




