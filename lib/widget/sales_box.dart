import 'package:flutter/material.dart';
import 'package:flutter_xiecheng/model/common_model.dart';
import 'package:flutter_xiecheng/model/sales_box_model.dart';
import 'package:flutter_xiecheng/widget/webview.dart';

class SalesBox extends StatelessWidget {
  final SalesBoxModel salesBoxModel;

  const SalesBox({Key key, this.salesBoxModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _items(context),
    );
  }

  _items(BuildContext context) {
    if (salesBoxModel == null) return null;
    List<Widget> items = [];
    items.add(_doubleItem(
        context, salesBoxModel.bigCard1, salesBoxModel.bigCard2, true));
    items.add(_doubleItem(
        context, salesBoxModel.smallCard1, salesBoxModel.smallCard2, false));
    items.add(_doubleItem(
        context, salesBoxModel.smallCard3, salesBoxModel.smallCard4, false));
    return Column(
      children: [
        _TopTitle(context),
        Padding(padding: EdgeInsets.only(top: 4)),
        items[0],
        Padding(padding: EdgeInsets.only(top: 4)),
        items[1],
        Padding(padding: EdgeInsets.only(top: 4)),
        items[2],
      ],
    );
  }

  /*
  * isBig:是否是大卡片
  * */
  Widget _doubleItem(BuildContext context, CommonModel leftCard,
      CommonModel rightCard, bool isBig) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _item(context, leftCard, isBig, true),
        _item(context, rightCard, isBig, false),
      ],
    );
  }

  /*
  * isBig:是否是大卡片
  * isLeft:是否是左边的图片
  * */
  _item(BuildContext context, CommonModel model, bool isBig, bool isLeft) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WebView(
                url: model.url,
                title: model.title ?? '活动',
              ),
            ),
          );
        },
        child: Container(
          height: isBig ? 130 : 82,
          margin: isLeft ? EdgeInsets.only(right: 4) : EdgeInsets.zero,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Image.network(
            model.icon,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  //左图片,右文字
  Widget _TopTitle(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(4)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 5),
            child: Image.network(
              salesBoxModel.icon,
              width: 80,
              height: 15,
              fit: BoxFit.fill,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WebView(
                    url: salesBoxModel.moreUrl,
                    title: '更多活动',
                  ),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                  gradient: LinearGradient(//线性渐变
                      colors: [Color(0xffff4e63), Color(0xffff6cc9)]),
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                '获取更多福利 >',
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
