class UserModel {
  int? id;
  String? name;
  String? image;
  String? email;
  String? token;
  DateTime? createdAt;
  DateTime? updatedAt;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.image,
    this.token,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['user']['id'],
      name: json['user']['name'],
      image: json['user']['image'],
      email: json['user']['email'],
      createdAt: DateTime.parse(json['user']["created_at"]),
      updatedAt: DateTime.parse(json['user']["updated_at"]),
      token: json['token'],
    );
  }
}
