import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter_xiecheng/widget/loading_container.dart';

const CATCH_URLS = [
  'm.ctrip.com/',
  'm.ctrip.com/html5/',
  'm.ctrip.com/html5',
  'm.ctrip.com/html5/you/',
  'm.ctrip.com/webapp/you/foods/',
  'm.ctrip.com/webapp/vacations/tour/list'
];

class WebView extends StatefulWidget {
  final String url;
  final String statusBarColor;
  final String title;
  final bool hideAppBar;
  final bool backForbid;
  final bool hideHead;

  const WebView(
      {this.url,
      this.statusBarColor,
      this.title,
      this.hideAppBar,
      this.backForbid = false,
      this.hideHead = false});

  @override
  State<StatefulWidget> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  final webViewReference = FlutterWebviewPlugin();
  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<WebViewStateChanged> _onStateChanged;
  StreamSubscription<WebViewHttpError> _onHttpError;
  bool exiting = false;

  @override
  void initState() {
    super.initState();

    webViewReference.close();
    //url变化监听
    _onUrlChanged = webViewReference.onUrlChanged.listen((String url) {});
    //webview状态变化监听
    _onStateChanged =
        webViewReference.onStateChanged.listen((WebViewStateChanged state) {
      switch (state.type) {
        case WebViewState.startLoad:
          if (_isToMain(state.url) && !exiting) {     //防止返回到携程网页..
            if (widget.backForbid) {
              webViewReference.launch(widget.url);
            } else {
              Navigator.pop(context);
              exiting = true;
            }
          }
          break;
        default:
          break;
      }
    });
    _onHttpError =
        webViewReference.onHttpError.listen((WebViewHttpError error) {});

  }

  _isToMain(String url) {
    bool contain = false;
    for (final value in CATCH_URLS) {
      if (url?.endsWith(value) ?? false) {
        contain = true;
        break;
      }
    }
    return contain;
  }


  @override
  void dispose() {
    super.dispose();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    _onHttpError.cancel();
    webViewReference.dispose();
  }

  @override
  Widget build(BuildContext context) {

    String statusBarColorStr = widget.statusBarColor ?? 'ffffff';
    Color backButtonColor;
    if (statusBarColorStr == 'ffffff') {
      backButtonColor = Colors.black;
    } else {
      backButtonColor = Colors.white;
    }
    /**
     * SystemChrome:一个全局属性，很像 Android 的 Application，功能很强大
     * setSystemUIOverlayStyle:用来设置状态栏顶部和底部样式
     *
     * */
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      body: MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: Column(
          children: [
            _appBar(Color(int.parse('0xff' + statusBarColorStr)), backButtonColor),
            _webViewWidget()
          ],
        ),
      ),
    );
  }

  //设置appBar
  _appBar(Color backgroundColor,Color backButtonColor){
    if(widget.hideAppBar ?? false){
      return widget.hideHead ? Container() : Container(
        color: backgroundColor,
        height: Theme.of(context).platform == TargetPlatform.iOS ? 34 : 29,
        width: double.infinity,
      );
    } else {
      return Container(
        color: backgroundColor,
        padding: EdgeInsets.fromLTRB(0, 38, 0, 10),
        child: FractionallySizedBox(    //百分比组件
          widthFactor: 1,               //宽度沾满屏幕
          child: Stack(
            children: [
              GestureDetector(          //返回按钮
                onTap: (){
                  Navigator.pop(context); //返回上一页
                },
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Icon(Icons.close,color: backButtonColor,size: 24),
                ),
              ),
              Positioned(               //appBar标题
                  left: 0,
                  right: 0,
                  child:Center(
                    child: Text(
                      widget.title ?? '',
                      style: TextStyle(color: backButtonColor,fontSize: 18),
                    ),
                  )
              )
            ],
          ),
        ),
      );
    }

  }

  _webViewWidget(){
    return Expanded(
      child: WebviewScaffold(
        url: widget.url,
        withZoom: true,
        withLocalStorage: true,
        hidden: true,
        initialChild: Container(    //菊花
          color: Colors.white,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }


}
