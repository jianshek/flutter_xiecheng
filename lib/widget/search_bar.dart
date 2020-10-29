import 'package:flutter/material.dart';
import 'package:flutter_xiecheng/model/travel_hot_keyword_model.dart';

//枚举,searchbar的类型
enum SearchBarType { home, normal, homeLight }

class SearchBar extends StatefulWidget {
  final bool enabled; //能否点击
  final bool hideLeft; //是否隐藏左边按钮
  final SearchBarType searchBarType; //搜索框类型
  final String hint; //placeholder
  final String defaultText; //默认值
  final void Function() leftButtonClick;
  final void Function() rightButtonClick;
  final void Function() speakClick;
  final void Function() inputBoxClick;
  final ValueChanged<String> onChanged;

  const SearchBar(
      {Key key,
      this.enabled,
      this.hideLeft,
      this.searchBarType,
      this.hint,
      this.defaultText,
      this.leftButtonClick,
      this.rightButtonClick,
      this.speakClick,
      this.inputBoxClick,
      this.onChanged})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  bool showClear = false; //是否显示清除按钮
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.defaultText != null) {
      setState(() {
        _controller.text = widget.defaultText;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.searchBarType == SearchBarType.normal
        ? _genNormalSearch()
        : _genHomeSearch();
  }

  //普通输入框
  _genNormalSearch() {
    return Container(
      child: Row(
        children: [
          _wrapTap(
              Container(
                padding: EdgeInsets.fromLTRB(6, 5, 6, 5),
                child: widget.hideLeft ?? false
                    ? null
                    : Icon(
                        Icons.arrow_back_ios,
                        color: Colors.grey,
                        size: 26,
                      ),
              ),
              widget.leftButtonClick),
          Expanded(flex: 1, child: _inputBox()),
          _wrapTap(
              Container(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Text("搜索",
                    style: TextStyle(color: Colors.blue, fontSize: 17)),
              ),
              widget.rightButtonClick)
        ],
      ),
    );
  }

  //首页输入框
  _genHomeSearch() {
    return Container(
      child: Row(
        children: <Widget>[
          _wrapTap(
              Container(
                padding: EdgeInsets.fromLTRB(6, 5, 5, 5),
                child:Row(
                  children: <Widget>[
                    Text('上海',style: TextStyle(color: _homeFontColor(),fontSize: 14),),
                    Icon(Icons.expand_more,color: _homeFontColor(),size: 22,)
                  ],
                ),
              ),
              widget.leftButtonClick),
          Expanded(
            flex: 1,
            child: _inputBox(),
          ),
          _wrapTap(
              Container(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Icon(Icons.comment,color: _homeFontColor(),size: 26,)
              ),
              widget.rightButtonClick),
        ],
      ),
    );
  }

  //输入框包裹
  _inputBox() {
    Color inputBoxColor; //搜索框背景颜色
    if (widget.searchBarType == SearchBarType.home) {
      inputBoxColor = Colors.white;
    } else {
      inputBoxColor = Color(int.parse('0xffEDEDED'));
    }

    return Container(
      height: 30,
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
          color: inputBoxColor,
          borderRadius: BorderRadius.circular(
              widget.searchBarType == SearchBarType.normal ? 5 : 15)),
      child: Row(
        children: [
          Icon(
            Icons.search,
            size: 20,
            color: widget.searchBarType == SearchBarType.normal
                ? Color(0xffA9A9A9)
                : Colors.blue,
          ),
          Expanded(
            flex: 1,
            child: widget.searchBarType == SearchBarType.normal
                ? TextField(
                    controller: _controller,
                    onChanged: _onChanged,
                    autofocus: true,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w300),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      border: InputBorder.none,
                      hintText: widget.hint ?? "",
                      hintStyle: TextStyle(fontSize: 15),
                    ),
                  )
                : _wrapTap(
                    Container(
                      child: Text(
                        widget.defaultText,
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ),
                    widget.inputBoxClick),
          ),
          !showClear
              ? _wrapTap(
                  Icon(
                    Icons.mic,
                    size: 22,
                    color: widget.searchBarType == SearchBarType.normal
                        ? Colors.blue
                        : Colors.grey,
                  ),
                  widget.speakClick)
              : _wrapTap(
                  Icon(
                    Icons.clear,
                    size: 22,
                    color: Colors.grey,
                  ), () {
                  setState(() {
                    _controller.clear();
                  });
                  _onChanged("");
                })
        ],
      ),
    );
  }

  //点击包装
  _wrapTap(Widget child, void Function() callback) {
    return GestureDetector(
      onTap: () {
        if (callback != null) {
          callback();
        }
      },
      child: child,
    );
  }

  //输入框输入变化
  _onChanged(String text) {}

  //输入框背景
  _homeFontColor() {
    return widget.searchBarType == SearchBarType.homeLight
        ? Colors.black54
        : Colors.white;
  }
}
