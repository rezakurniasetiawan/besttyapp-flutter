import 'package:besty_apps/model/api_response_model.dart';
import 'package:besty_apps/model/comment_mode.dart';
import 'package:besty_apps/model/post_model.dart';
import 'package:besty_apps/screens/login/login_screen.dart';
import 'package:besty_apps/services/auth_services.dart';
import 'package:besty_apps/services/comment_services.dart';
import 'package:flutter/material.dart';

import '../../../constan.dart';

class CommentPage extends StatefulWidget {
  CommentPage({Key? key, required this.postModel}) : super(key: key);

  PostModel postModel;
  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  List<dynamic> _commentsList = [];
  bool _loading = true;
  int userId = 0;
  int _editCommentId = 0;
  TextEditingController _txtCommentController = TextEditingController();

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

  // create comment
  void _createComment() async {
    ApiResponse response = await createComment(
        widget.postModel.id ?? 0, _txtCommentController.text);

    if (response.error == null) {
      _txtCommentController.clear();
      _getComments();
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false)
          });
    } else {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  // edit comment
  void _editComment() async {
    ApiResponse response =
        await editComment(_editCommentId, _txtCommentController.text);

    if (response.error == null) {
      _editCommentId = 0;
      _txtCommentController.clear();
      _getComments();
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

  // Delete comment
  void _deleteComment(int commentId) async {
    ApiResponse response = await deleteComment(commentId);

    if (response.error == null) {
      _getComments();
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
          "Comments",
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.redAccent,
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                            image: widget.postModel.userModel!.image != null
                                ? DecorationImage(
                                    image: NetworkImage(
                                        '${widget.postModel.userModel!.image}'),
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
                                "${widget.postModel.userModel!.name}",
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
                            style: const TextStyle(
                                fontSize: 12, color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  height: 10,
                  color: Colors.black54,
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
                                                image: comment.user!.image !=
                                                        null
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
                                      comment.user!.id == userId
                                          ? PopupMenuButton(
                                              child: Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 10),
                                                  child: Icon(
                                                    Icons.more_vert,
                                                    color: Colors.black,
                                                  )),
                                              itemBuilder: (context) => [
                                                PopupMenuItem(
                                                    child: Text('Edit'),
                                                    value: 'edit'),
                                                PopupMenuItem(
                                                    child: Text('Delete'),
                                                    value: 'delete')
                                              ],
                                              onSelected: (val) {
                                                if (val == 'edit') {
                                                  setState(() {
                                                    _editCommentId =
                                                        comment.id ?? 0;
                                                    _txtCommentController.text =
                                                        comment.comment ?? '';
                                                  });
                                                } else {
                                                  _deleteComment(
                                                      comment.id ?? 0);
                                                }
                                              },
                                            )
                                          : SizedBox()
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
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(color: Colors.black26, width: 0.5)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.redAccent),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.redAccent,
                                  )),
                              labelText: 'Comment',
                              labelStyle: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                              contentPadding: EdgeInsets.all(10),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.black))),
                          controller: _txtCommentController,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.send,
                          color: Colors.redAccent,
                        ),
                        onPressed: () {
                          if (_txtCommentController.text.isNotEmpty) {
                            setState(() {
                              _loading = true;
                            });
                            if (_editCommentId > 0) {
                              _editComment();
                            } else {
                              _createComment();
                            }
                          }
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
