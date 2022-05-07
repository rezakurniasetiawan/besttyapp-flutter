import 'package:besty_apps/model/api_response_model.dart';
import 'package:besty_apps/model/comment_mode.dart';
import 'package:besty_apps/model/post_model.dart';
import 'package:besty_apps/model/user_model.dart';
import 'package:besty_apps/screens/home/component/comment_page.dart';
import 'package:besty_apps/screens/login/login_screen.dart';
import 'package:besty_apps/services/auth_services.dart';
import 'package:besty_apps/services/comment_services.dart';
import 'package:flutter/material.dart';

import '../../../constan.dart';

class DetailPostingan extends StatefulWidget {
  DetailPostingan(
      {Key? key,
      required this.id,
      required this.body,
      required this.image,
      required this.likesCount,
      required this.commentsCount,
      required this.userModel,
      required this.postModel,
      required this.selfLiked})
      : super(key: key);

  final id;
  final body;
  final image;
  final likesCount;
  final commentsCount;
  UserModel? userModel;
  final selfLiked;
  PostModel postModel;

  @override
  State<DetailPostingan> createState() => _DetailPostinganState();
}

class _DetailPostinganState extends State<DetailPostingan> {
  List<dynamic> _commentsList = [];
  bool _loading = true;
  int userId = 0;
  int _editCommentId = 0;

  // Get comments
  Future<void> _getComments() async {
    userId = await getUserId();
    ApiResponse response = await getComments(widget.postModel.id ?? 0);

    if (response.error == null) {
      setState(() {
        _commentsList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false)
          });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  @override
  void initState() {
    _getComments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black87),
        title: Text(
          "Postingan",
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                        image: widget.userModel!.image != null
                            ? DecorationImage(
                                image:
                                    NetworkImage('${widget.userModel!.image}'),
                                fit: BoxFit.cover)
                            : null,
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.redAccent),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "${widget.userModel!.name}",
                            style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          ImageIcon(
                            AssetImage('assets/images/verified.png'),
                            color: Color(0xFF1676ED),
                            size: 15,
                          ),
                        ],
                      ),
                      Text(
                        "username",
                        style:
                            const TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              widget.image != null
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.redAccent,
                        image: DecorationImage(
                            image: NetworkImage(
                              "${widget.image}",
                            ),
                            fit: BoxFit.cover),
                      ),
                    )
                  : SizedBox(
                      height: widget.image != null ? 0 : 10,
                    ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Row(
                        children: [
                          Text(
                            "${widget.userModel!.name}",
                            style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                          // Text(
                          //   "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
                          //   overflow: TextOverflow.ellipsis,
                          //   maxLines: 2,
                          //   style: const TextStyle(
                          //       fontSize: 12, color: Colors.black),
                          // ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 18),
                        child: Text(
                          "${widget.body}",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                height: 10,
                color: Colors.black54,
              ),
              Text(
                "Comments",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Divider(
                height: 10,
                color: Colors.black54,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CommentPage(
                            postModel: widget.postModel,
                          )));
                },
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.redAccent),
                  child: Center(
                      child: Text(
                    "Type Comments",
                    style: TextStyle(color: Colors.white),
                  )),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  color: Colors.redAccent,
                  onRefresh: () {
                    return _getComments();
                  },
                  child: ListView.builder(
                    itemCount: _commentsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      Comment comment = _commentsList[index];
                      return Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                              image: comment.user!.image != null
                                                  ? DecorationImage(
                                                      image: NetworkImage(
                                                          '${comment.user!.image}'),
                                                      fit: BoxFit.cover)
                                                  : null,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: Colors.blueGrey),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          '${comment.user!.name}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('${comment.comment}'),
                                SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
