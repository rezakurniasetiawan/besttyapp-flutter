import 'dart:convert';

import 'package:besty_apps/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PostinganUserPage extends StatefulWidget {
  PostinganUserPage({Key? key, required this.userId}) : super(key: key);

  final userId;

  @override
  State<PostinganUserPage> createState() => _PostinganUserPageState();
}

class _PostinganUserPageState extends State<PostinganUserPage> {
  List _postingUser = [];
  var loading = false;
  getPostUser() async {
    setState(() {
      loading = true;
    });
    String token = await getToken();
    final String url = "https://besttyapp.skom.id/api/posts/user/";
    final response = await http.get(
      Uri.parse(url + widget.userId.toString()),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['post'];

      setState(() {
        _postingUser = data;

        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    getPostUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              itemCount: _postingUser.length,
              itemBuilder: (context, i) {
                var _post = _postingUser[i];
                return Container(
                  color: Colors.redAccent,
                  child: Image.network(
                    "${_post["image"]}",
                    fit: BoxFit.cover,
                  ),
                  margin: EdgeInsets.all(5.0),
                );
              },
            ),
    );
  }
}
