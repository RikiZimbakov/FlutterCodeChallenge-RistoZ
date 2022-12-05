class CommitedModel {
  String gitSha;
  Commit commit;
  CommitedModel({required this.gitSha, required this.commit});

  factory CommitedModel.fromJson(Map<String, dynamic> json) {
    return CommitedModel(
        gitSha: json['sha'], commit: Commit.fromJson(json['commit']));
  }
}

class Commit {
//this will handel nested object
  String message;
  Author author;
  Commit({required this.message, required this.author});

  factory Commit.fromJson(Map<String, dynamic> json) {
    return Commit(
        message: json['message'], author: Author.fromJson(json['author']));
  }
}

class Author {
//this will handel nested object
  String name;

  Author({
    required this.name,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(name: json['name']);
  }
}
