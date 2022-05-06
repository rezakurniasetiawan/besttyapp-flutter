import 'package:flutter/material.dart';

class PostinganUser extends StatelessWidget {
  const PostinganUser({Key? key, required this.image}) : super(key: key);

  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.redAccent,
      child: Image.network(
        image,
        fit: BoxFit.cover,
      ),
      margin: EdgeInsets.all(5.0),
    );
  }
}
