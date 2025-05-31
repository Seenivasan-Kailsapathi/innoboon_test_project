
class Organizations {
  List<Organization> organizationList = [];

  Organizations.fromJson(List<dynamic> orgList) {
    organizationList = orgList.map((e) => Organization.fromJson(e)).toList();
  }
}



class Organization {
  String? login;
  int? id;
  String? nodeId;
  String? url;
  String? avatarUrl;
  Null description;

  Organization({this.login, this.id, this.nodeId, this.url, this.avatarUrl, this.description});

  Organization.fromJson(Map<String, dynamic> json) {
    login = json['login'];
    id = json['id'];
    nodeId = json['node_id'];
    url = json['url'];
    avatarUrl = json['avatar_url'];
    description = json['description'];
  }
}
