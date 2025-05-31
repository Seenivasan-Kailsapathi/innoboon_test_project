class SignInUserInfo {
  String? login;
  int? id;
  String? nodeId;
  String? avatarUrl;
  String? name;
  String? company;
  String? location;
  String? email;

  SignInUserInfo({this.login, this.id, this.nodeId, this.avatarUrl, this.name, this.company, this.location, this.email});

  SignInUserInfo.fromJson(Map<String, dynamic> json) {
    login = json['login'];
    id = json['id'];
    nodeId = json['node_id'];
    avatarUrl = json['avatar_url'];
    name = json['name'];
    company = json['company'];
    location = json['location'];
    email = json['email'];
  }
}
