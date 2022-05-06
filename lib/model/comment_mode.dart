import 'package:besty_apps/model/user_model.dart';

class Comment {
  int? id;
  String? comment;
  UserModel? user;

  Comment({this.id, this.comment, this.user});

  // map json to comment model
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
        id: json['id'],
        comment: json['comment'],
        user: UserModel(
            id: json['user']['id'],
            name: json['user']['name'],
            image: json['user']['image']));
  }
}
