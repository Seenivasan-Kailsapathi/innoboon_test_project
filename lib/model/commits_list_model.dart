class CommitsList {
  List<Commits> commitsLists = [];

  CommitsList.fromJson(List<dynamic> commitsList) {
    commitsLists = commitsList.map((e) => Commits.fromJson(e)).toList();
  }
}

class Commits {
  String? sha;
  String? nodeId;
  Commit? commit;
  String? url;
  Author? author;
  Author? committer;

  Commits.fromJson(Map<String, dynamic> json) {
    sha = json['sha'];
    nodeId = json['node_id'];
    commit = json['commit'] != null ? Commit.fromJson(json['commit']) : null;
    url = json['url'];
    author = json['author'] != null ? Author.fromJson(json['author']) : null;

    committer = json['committer'] != null ? Author.fromJson(json['committer']) : null;
  }
}


class Commit {
  Author? author;
  Author? committer;
  String? message;
  Tree? tree;
  String? url;
  int? commentCount;
  Verification? verification;

  Commit.fromJson(Map<String, dynamic> json) {
    author = json['author'] != null ? Author.fromJson(json['author']) : null;
    committer = json['committer'] != null ? Author.fromJson(json['committer']) : null;
    message = json['message'];
    tree = json['tree'] != null ? Tree.fromJson(json['tree']) : null;
    url = json['url'];
    commentCount = json['comment_count'];
    verification = json['verification'] != null ? Verification.fromJson(json['verification']) : null;
  }
}

class Author {
  String? name;
  String? email;
  String? date;

  Author.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    date = json['date'];
  }
}

class Tree {
  String? sha;
  String? url;

  Tree.fromJson(Map<String, dynamic> json) {
    sha = json['sha'];
    url = json['url'];
  }
}

class Verification {
  bool? verified;
  String? reason;

  Verification.fromJson(Map<String, dynamic> json) {
    verified = json['verified'];
    reason = json['reason'];
  }
}

class Authors {
  String? login;
  int? id;
  String? nodeId;
  String? avatarUrl;
  String? url;
  String? type;
  String? userViewType;
  bool? siteAdmin;

  Authors.fromJson(Map<String, dynamic> json) {
    login = json['login'];
    id = json['id'];
    nodeId = json['node_id'];
    avatarUrl = json['avatar_url'];
    url = json['url'];
    type = json['type'];
    userViewType = json['user_view_type'];
    siteAdmin = json['site_admin'];
  }
}
