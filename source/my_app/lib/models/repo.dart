/* CommitedModel is our top level json object,
for this call we will need to create
nested calls since we are working with 3 levels */
class CommitedModel {
  String gitSha;
  Commit commit;
  AuthorAvatar authorAvatar;
  CommitedModel(
      {required this.gitSha, required this.commit, required this.authorAvatar});

  factory CommitedModel.fromJson(Map<String, dynamic> json) {
    return CommitedModel(
        gitSha: json['sha'],
        commit: Commit.fromJson(json['commit']),
        authorAvatar: AuthorAvatar.fromJson(json['author']));
  }
}

/* Commit is our middle level json object,
*/
class Commit {
  String message;
  Author author;
  Commit({required this.message, required this.author});

  factory Commit.fromJson(Map<String, dynamic> json) {
    return Commit(
        message: json['message'], author: Author.fromJson(json['author']));
  }
}

/* Author is our most inner level json object,
*/
class Author {
  String name;

  Author({
    required this.name,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(name: json['name']);
  }
}

/* AuthorAvatar is a sibling to Commit,
 they are on the same json level,
*/
class AuthorAvatar {
  String avatarUrl;

  AuthorAvatar({
    required this.avatarUrl,
  });

  factory AuthorAvatar.fromJson(Map<String, dynamic> json) {
    return AuthorAvatar(avatarUrl: json['avatar_url']);
  }
}
