class GitHubProjects {
  List<GitHubProject> gitHubProjectList = [];

  GitHubProjects.fromJson(List<dynamic> projectList) {
    gitHubProjectList = projectList.map((e) => GitHubProject.fromJson(e)).toList();
  }
}

class GitHubProject {
  String? name;
  Owner? owner;
  String? visibility;
  String? defaultBranch;
  String? branchesUrl;
  String? createdAt;
  String? updatedAt;
  String? pushedAt;

  GitHubProject({this.name, this.owner, this.branchesUrl, this.createdAt, this.updatedAt, this.pushedAt});

  GitHubProject.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    owner = json['owner'] != null ? Owner.fromJson(json['owner']) : null;
    visibility = json['visibility'];
    defaultBranch = json['default_branch'];
    branchesUrl = json['branches_url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    pushedAt = json['pushed_at'];
  }
}

class Owner {
  String? login;
  int? id;
  String? avatarUrl;
  String? url;
  String? reposUrl;

  Owner({this.login, this.id, this.avatarUrl, this.url, this.reposUrl});

  Owner.fromJson(Map<String, dynamic> json) {
    login = json['login'];
    id = json['id'];
    avatarUrl = json['avatar_url'];
    url = json['url'];
    reposUrl = json['repos_url'];
  }
}
