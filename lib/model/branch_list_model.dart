class BranchList {
  List<Branch> branchList = [];

  BranchList.fromJson(List<dynamic> branches) {
    branchList = branches.map((e) => Branch.fromJson(e)).toList();
  }
}

class Branch {
  String? name;
  Commit? commit;
  bool? protected;

  Branch.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    commit = json['commit'] != null ? Commit.fromJson(json['commit']) : null;
    protected = json['protected'];
  }
}

class Commit {
  String? sha;
  String? url;

  Commit({this.sha, this.url});

  Commit.fromJson(Map<String, dynamic> json) {
    sha = json['sha'];
    url = json['url'];
  }
}
