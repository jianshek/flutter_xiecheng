import 'package:flutter/material.dart';
import 'package:flutter_xiecheng/model/common_model.dart';
import 'package:flutter_xiecheng/widget/webview.dart';

class LocalNav extends StatelessWidget{

  final List<CommonModel> localNavList;

  const LocalNav({Key key, this.localNavList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Container(
      height: 74,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(6)),
        boxShadow: [
          BoxShadow(color: Colors.black12,blurRadius: 12.0),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: _items(context),
      ),
    );
    
  }

  _items(BuildContext context){

    if(localNavList == null) return null;
    List<Widget> items = [];
    localNavList.forEach((model) {
      items.add(_item(context, model));
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: items,
    );

  }

  Widget _item(BuildContext context, CommonModel model){

    return GestureDetector(
      onTap: (){
        //自定义一个路由
        Navigator.push(context, new MaterialPageRoute(builder: (context) => WebView(
          url: model.url,
          statusBarColor: model.statusBarColor,
          hideAppBar: model.hideAppBar,
        )));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(model.icon,width: 40,height: 40),
          Text(model.title,style: TextStyle(fontSize: 12)),
        ],
      ),
    );

  }

}
