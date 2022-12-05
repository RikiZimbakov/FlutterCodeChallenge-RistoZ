/* CommitedModel is our top level json object,
for this call we will need to create
nested calls since we are working with 3 levels */
class CommitedModel {
  String gitSha;
  Commit commit;
  CommitedModel({required this.gitSha, required this.commit});

  factory CommitedModel.fromJson(Map<String, dynamic> json) {
    return CommitedModel(
        gitSha: json['sha'], commit: Commit.fromJson(json['commit']));
  }
}

/* Commit is our middle level json object,
*/
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

/* Author is our most inner level json object,
*/
class Author {
//this will handle nested object
  String name;

  Author({
    required this.name,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(name: json['name']);
  }
}
