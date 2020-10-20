import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>__HomePageState();
}

class __HomePageState extends State<HomePage>{
  @override
  Widget build(BuildContext context) {

    List _bannerList = [
      'http://via.placeholder.com/350x150',
      'http://via.placeholder.com/350x150',
      'http://via.placeholder.com/350x150'
    ];

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Container(
              height: 160,
              child: BannerWidget(bannerList: _bannerList),
            )
          ],
        ),
      ),
    );
  }

}

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



