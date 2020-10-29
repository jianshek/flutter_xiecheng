import 'package:flutter/material.dart';
import 'package:flutter_xiecheng/model/search_model.dart';
import 'package:flutter_xiecheng/dao/search_dao.dart';
import 'package:flutter_xiecheng/widget/search_bar.dart';
import 'package:flutter_xiecheng/util/NavigatorUtil.dart';
import 'package:flutter_xiecheng/widget/webview.dart';
import 'dart:ui';

//搜索的接口
const URL =
    "https://m.ctrip.com/restapi/h5api/searchapp/search?source=mobileweb&action=autocomplete&contentType=json&keyword=";

//搜索返回的类型
const TYPES = [
  'channelgroup',
  'channellgs',
  'channelplane',
  'channeltrain',
  'cruise',
  'district',
  'food',
  'hotel',
  'huodong',
  'shop',
  'sight',
  'ticket',
  'travelgroup'
];

class SearchPage extends StatefulWidget {
  final bool hideLeft;
  final String searchUrl;
  final String keyword;
  final String hint;

  const SearchPage(
      {Key key, this.hideLeft, this.searchUrl = URL, this.keyword = "", this.hint})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String keyword;
  SearchModel searchModel;

  @override
  void initState() {
    super.initState();
    if (widget.keyword != null) {
      _onTextChange(widget.keyword);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
          onTap: (){
            FocusScope.of(context).requestFocus(FocusNode());  //收起键盘
          },
          child: Column(
            children: [
              _appBar(),
              MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: Expanded(    //撑满父组件
                    flex: 1,
                    child: ListView.builder(
                        itemCount: searchModel?.data?.length ?? 0,
                        itemBuilder: (BuildContext context, int position) {
                          return _item(position);
                        }),
                  )),
            ],
          ),
        ));
  }

  //输入框输入改变
  _onTextChange(String text) {
    keyword = text;
    if (text.length == 0) {
      setState(() {
        searchModel = null;
      });
      return;
    }
    String url = widget.searchUrl + keyword;
    SearchDao.fetch(url, keyword).then((value) {
      if (value.keyword == keyword) {
        //解决快速请求展示结果不是最后一次搜索结果的问题
        setState(() {
          searchModel = value;
        });
      }
    }).catchError((e) {
      print(e.toString());
    });
  }

  //tableview cell
  _item(int position) {
    if (searchModel == null || searchModel.data == null) {
      return null;
    }

    SearchItem item = searchModel.data[position];

    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode()); //收起键盘
        NavigatorUtil.push(context, WebView(url: item.url, title: "详情"));
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 0.3, color: Colors.grey))  //分割线
        ),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              child: Image(
                height: 26,
                width:26,
                image: AssetImage(_typeImage(item.type)),
              ),
            ),
            Column(
              children: [
                Container(
                  child: _title(item),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  child: _subTitle(item),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  //tableview cell 左边根据不同的关键词显示不同的图标
  _typeImage(String type){
    if (type == null) {
      return "images/type_travelgroup.png";
    }
    String path = 'travelgroup';
    for(final val in TYPES){
      if (type.contains(val)) {
        path = val;
        break;
      }
    }
    return "images/type_$path.png";
  }

  //tableview cell 右上边标题
  _title(SearchItem item){
    if (item == null) {
      return null;
    }

    List<TextSpan> spans = [];
    spans.addAll(_keywordTextSpans(item.word, searchModel.keyword));
    spans.add(TextSpan(
        text: ' ' + (item.districtname ?? "") + " " + (item.zonename ?? ""),
        style: TextStyle(fontSize: 16, color: Colors.grey)));
    return RichText(text: TextSpan(children: spans)); //富文本
  }

  //tableview cell 右下边描述
  _subTitle(SearchItem item){
    return RichText(
      text: TextSpan(children: <TextSpan>[
        TextSpan(
            text: item.price ?? "",
            style: TextStyle(fontSize: 16, color: Colors.orange)),
        TextSpan(
            text: ' ' + (item.star ?? ''),
            style: TextStyle(fontSize: 12, color: Colors.grey))
      ]),
    );
  }

  //通过关键字把一段文字分割
  _keywordTextSpans(String word, String keyword) {
    List<TextSpan> spans = [];
    if (word == null || word.length == 0) {
      return spans;
    }
    List<String> arr = word.split(keyword);  //分割
    TextStyle normalStyle = TextStyle(fontSize: 16, color: Colors.black87);
    TextStyle keywordStyle = TextStyle(fontSize: 16, color: Colors.orange);
    for(int i = 0;i<arr.length;i++){
      if((i+1)%2 == 0){   //关键字
        spans.add(TextSpan(text: keyword, style: keywordStyle));
      }
      String val = arr[i]; //非关键字
      if (val != null && val.length > 0) {
        spans.add(TextSpan(text: val, style: normalStyle));
      }
    }
    return spans;
  }


  _appBar() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [Color(0x66000000), Colors.transparent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
          child: Container(
            padding: EdgeInsets.only(
                top: MediaQueryData.fromWindow(window).padding.top),
            //刘海高度
            height: 80,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: Colors.white),
            child: SearchBar(
              hideLeft: widget.hideLeft,
              searchBarType: SearchBarType.normal,
              defaultText: widget.keyword,
              hint: widget.hint,
              speakClick: _jumpToSpeak,
              leftButtonClick: () {
                Navigator.pop(context);
              },
              onChanged: _onTextChange,
            ),
          ),
        )
      ],
    );
  }

  //语音搜索
  _jumpToSpeak() {}
}
