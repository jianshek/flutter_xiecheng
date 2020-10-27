import 'package:flutter/material.dart';

//菊花
class LoadingContainer extends StatelessWidget{

  final Widget child;
  final bool isLoading;
  final bool cover;

  const LoadingContainer({@required  this.isLoading,this.cover = false,@required  this.child});

  Widget get _loadingView {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    /*
    * if(!cover){
    *   if(!isLoading){
    *     child :
    *   }else{
    *     _loadingView
    *   }
    * }else{
    *   Stack
    * }
    * */
    return !cover ? !isLoading ? child : _loadingView : Stack(
      children: [
        child,
        isLoading ? _loadingView: Container()
      ],
    );
  }

}