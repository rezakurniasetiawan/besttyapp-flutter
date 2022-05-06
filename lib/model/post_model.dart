import 'package:besty_apps/model/user_model.dart';

class PostModel {
  int? id;
  String? body;
  String? image;
  int? likesCount;
  int? commentsCount;
  UserModel? userModel;
  bool? selfLiked;

  PostModel({
    this.id,
    this.body,
    this.image,
    this.likesCount,
    this.commentsCount,
    this.userModel,
    this.selfLiked,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      body: json['body'],
      image: json['image'],
      likesCount: json['likes_count'],
      commentsCount: json['comments_count'],
      selfLiked: json['likes'].length > 0,
      userModel: UserModel(
        id: json['user']['id'],
        name: json['user']['name'],
        image: json['user']['image'],
      ),
    );
  }
}
