//轮播图model
class BannerListModel{
  String icon;
  String url;
  BannerListModel({this.icon, this.url});

  BannerListModel.fromJson(Map<String, dynamic> json){
    icon = json['icon'];
    url = json['url'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['icon'] = this.icon;
    data['url'] = this.url;
    return data;
  }
}