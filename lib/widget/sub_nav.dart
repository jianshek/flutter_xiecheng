import 'package:flutter/material.dart';
import 'package:flutter_xiecheng/model/common_model.dart';
import 'package:flutter_xiecheng/widget/webview.dart';

class SubNav extends StatelessWidget{
  final List<CommonModel> subNavList;

  const SubNav({Key key, this.subNavList}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return  Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(6))
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: _items(context),
      ),
    );
  }

  _items(BuildContext context) {
    if (subNavList == null) return null;
    List<Widget> items = [];
    subNavList.forEach((model) {
      items.add(_item(context, model));
    });
    int separate = (subNavList.length / 2 + 0.5).toInt();  //数组里的数据只显示两行
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: items.sublist(0,separate),
        ),
        Padding(padding: EdgeInsets.only(top: 10)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: items.sublist(separate,items.length),
        )
      ],
    );
  }

  Widget _item(BuildContext context, CommonModel model) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => WebView(
            url: model.url,
            statusBarColor: model.statusBarColor,
            hideAppBar: model.hideAppBar,
          )));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(model.icon,width: 28,height: 28),
            Text(model.title,style: TextStyle(fontSize: 12))
          ],
        ),
      ),
    );
  }


}