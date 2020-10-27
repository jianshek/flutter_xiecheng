import 'package:flutter/material.dart';
import 'package:flutter_xiecheng/model/grid_nav_model.dart';
import 'package:flutter_xiecheng/model/common_model.dart';
import 'package:flutter_xiecheng/widget/webview.dart';

class GridNav extends StatelessWidget {
  final GridNavModel gridNavModel;

  const GridNav({Key key, @required this.gridNavModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(     //主要的功能就是设置widget四边圆角，可以设置阴影颜色，和z轴高度
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(6),
      clipBehavior: Clip.antiAlias, ////裁剪模式:平滑
      child: Column(
        children: _gridNavItems(context),
      ),
    );
  }

  //三大块
  _gridNavItems(BuildContext context) {
    List<Widget> items = <Widget>[];
    if (gridNavModel == null) return items;
    if (gridNavModel.hotel != null) {
      items.add(_gridNavItem(context, gridNavModel.hotel, true));
    }
    if (gridNavModel.flight != null) {
      items.add(_gridNavItem(context, gridNavModel.flight, false));
    }
    if (gridNavModel.travel != null) {
      items.add(_gridNavItem(context, gridNavModel.travel, false));
    }
    return items;
  }

  /*
  * 每行的大块
  * isFirst:是否是第一大块
  * */
  _gridNavItem(BuildContext context, GridNavItem gridNavItem, bool isFirst) {
    List<Widget> items = <Widget>[];
    items.add(_mainItem(context, gridNavItem.mainItem));
    items.add(_doubleItem(context, gridNavItem.item1, gridNavItem.item2));
    items.add(_doubleItem(context, gridNavItem.item3, gridNavItem.item4));
    List<Widget> expandItem = <Widget>[];
    items.forEach((element) {
      //让控件充满父控件
      expandItem.add(Expanded(
        child: element,
        flex: 1,
      ));
    });
    Color startColor = Color(int.parse('0xff' + gridNavItem.startColor));
    Color endColor = Color(int.parse('0xff' + gridNavItem.endColor));
    return Container(
      height: 88,
      margin: isFirst ? null : EdgeInsets.only(top: 3),
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [startColor, endColor]) //线性渐变
          ),
      child: Row(
        children: expandItem,
      ),
    );
  }

  //第一小块
  _mainItem(BuildContext context, CommonModel model) {
    return _wrapGesture(
        context,
        Stack(
          alignment: AlignmentDirectional.topCenter, //子组件对齐方式
          children: [
            Image.network(
              model.icon,
              fit: BoxFit.contain,
              width: 88,
              height: 121,
              alignment: AlignmentDirectional.bottomCenter,
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                model.title,
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            )
          ],
        ),
        model);
  }

  //第二三小块
  _doubleItem(
      BuildContext context, CommonModel topItem, CommonModel bottomItem) {
    return Column(
      children: [
        Expanded(child: _item(context, topItem, true)),
        Expanded(child: _item(context, bottomItem, false))
      ],
    );
  }

  //最小块
  _item(BuildContext context, CommonModel item, bool isTop) {
    BorderSide borderSide = BorderSide(width: 0.8, color: Colors.white); //边线
    return FractionallySizedBox(
      //百分比布局
      widthFactor: 1, //子组件宽度充满
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                left: borderSide,
                bottom: isTop ? borderSide : BorderSide.none)),
        child: _wrapGesture(
            context,
            Center(
              child: Container(
                child: Text(
                  item.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
            ),
            item),
      ),
    );
  }

  //跳转包裹
  _wrapGesture(BuildContext context, Widget widget, CommonModel model) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WebView(
                      url: model.url,
                      title: model.title,
                      statusBarColor: model.statusBarColor,
                      hideAppBar: model.hideAppBar,
                    )));
      },
      child: widget,
    );
  }
}
