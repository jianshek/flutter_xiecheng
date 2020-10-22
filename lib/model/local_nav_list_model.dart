
class LocalNavListModel{
  String icon;
  String title;
  String url;
  String statusBarColor;
  bool hideAppBar;

  LocalNavListModel({this.icon, this.title, this.url, this.statusBarColor, this.hideAppBar});

  /*
   * factory :不需要总返回一个新的对象,则使用factory来定义这个构造函数
   * 使用 new 关键字来调用工厂构造函数
   * */
  factory LocalNavListModel.fromJson(Map<String, dynamic> json){
    return LocalNavListModel(
        icon : json['icon'],
        title : json['title'],
        url : json['url'],
        statusBarColor : json['statusBarColor'],
        hideAppBar : json['hideAppBar']
    );

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['icon'] = this.icon;
    data['title'] = this.title;
    data['url'] = this.url;
    data['statusBarColor'] = this.statusBarColor;
    data['hideAppBar'] = this.hideAppBar;
    return data;
  }
}