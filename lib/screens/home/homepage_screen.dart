import 'package:besty_apps/model/api_response_model.dart';
import 'package:besty_apps/model/post_model.dart';
import 'package:besty_apps/screens/home/component/comment_page.dart';
import 'package:besty_apps/screens/login/login_screen.dart';
import 'package:besty_apps/screens/posting/component/detail_postingan.dart';
import 'package:besty_apps/services/auth_services.dart';
import 'package:besty_apps/services/post_services.dart';
import 'package:besty_apps/widget/edit_post.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import '../../constan.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _postList = [];
  int userId = 0;
  bool _loading = true;

  //get all post
  Future<void> retrievePosts() async {
    userId = await getUserId();
    print(userId);
    ApiResponse response = await getPost();
    if (response.error == null) {
      setState(() {
        print(_postList);
        _postList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
    } else if (response.error == unauthorized) {
      logout().then((value) => Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  //Delete Post
  void _deletePost(int postId) async {
    ApiResponse response = await deletePost(postId);

    if (response.error == null) {
      retrievePosts();
    } else if (response.error == unauthorized) {
      logout().then((value) => Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  //Post like and disklike
  void _postLikeAndDisklike(int postId) async {
    ApiResponse response = await likesPost(postId);

    if (response.error == null) {
      retrievePosts();
    } else if (response.error == unauthorized) {
      logout().then((value) => Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    retrievePosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/logo.png',
          height: 30.0,
        ),
        // ignore: prefer_const_literals_to_create_immutables
        actions: [
          InkWell(
            onTap: () {
              logout().then((value) => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (route) => false));
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.logout,
                color: Colors.black,
              ),
            ),
          )
        ],
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.redAccent,
              ),
            )
          : RefreshIndicator(
              color: Colors.redAccent,
              onRefresh: () {
                return retrievePosts();
              },
              child: ListView.builder(
                  itemCount: _postList.length,
                  itemBuilder: (BuildContext context, int index) {
                    PostModel post = _postList[index];
                    return Container(
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
                                      image: post.userModel!.image != null
                                          ? DecorationImage(
                                              image: NetworkImage(
                                                  '${post.userModel!.image}'),
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
                                          "${post.userModel!.name}",
                                          style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(
                                          width: 2,
                                        ),
                                        ImageIcon(
                                          AssetImage(
                                              'assets/images/verified.png'),
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
                                post.userModel!.id == userId
                                    ? Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            PopupMenuButton(
                                              child: Icon(
                                                Icons.more_vert,
                                                color: Colors.black45,
                                              ),
                                              itemBuilder: (context) => [
                                                PopupMenuItem(
                                                  child: Container(
                                                    child: Text('Edit'),
                                                  ),
                                                  value: 'edit',
                                                ),
                                                PopupMenuItem(
                                                  child: Text('Hapus'),
                                                  value: 'hapus',
                                                ),
                                              ],
                                              onSelected: (value) {
                                                switch (value) {
                                                  case 'edit':
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              EditPost(
                                                                postModel: post,
                                                              )),
                                                    );
                                                    break;
                                                  case 'hapus':
                                                    _deletePost(post.id ?? 0);
                                                    break;
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      )
                                    : SizedBox(
                                        height: 12,
                                      ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            post.image != null
                                ? InkWell(
                                    onLongPress: () {
                                      print("Tampil Postingan");
                                    },
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DetailPostingan(
                                                  id: post.id,
                                                  body: post.body,
                                                  commentsCount:
                                                      post.commentsCount,
                                                  image: post.image,
                                                  likesCount: post.likesCount,
                                                  selfLiked: post.selfLiked,
                                                  userModel: post.userModel,
                                                  postModel: post,
                                                )),
                                      );
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 250,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.redAccent,
                                        image: DecorationImage(
                                            image: NetworkImage(
                                              "${post.image}",
                                            ),
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                  )
                                : SizedBox(
                                    height: post.image != null ? 0 : 10,
                                  ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                kLikeAndComment(
                                    post.likesCount ?? 0,
                                    post.selfLiked == true
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    post.selfLiked == true
                                        ? Colors.redAccent
                                        : Colors.black, () {
                                  _postLikeAndDisklike(post.id ?? 0);
                                }),
                                SizedBox(
                                  width: 18,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => CommentPage(
                                                  postModel: post,
                                                )));
                                  },
                                  child: Row(
                                    children: [
                                      ImageIcon(
                                        AssetImage('assets/images/comment.png'),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        '${post.commentsCount ?? 0}',
                                        style: TextStyle(
                                            fontSize: 15, letterSpacing: 0.3),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                    child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(right: 10),
                                      child: Icon(
                                        Icons.bookmark_border,
                                        color: Colors.black54,
                                        size: 30,
                                      ),
                                    ),
                                  ],
                                ))
                              ],
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
                                          "${post.userModel!.name}",
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
                                        "${post.body}",
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
    );
  }

  Widget kLikeAndComment(
      int value, IconData icon, Color color, Function onTap) {
    return Material(
      child: InkWell(
        onTap: () => onTap(),
        child: Row(
          children: [
            Icon(
              icon,
              color: color,
            ),
            SizedBox(width: 3),
            Text(
              "$value",
              style: TextStyle(fontSize: 15, letterSpacing: 0.3),
            ),
          ],
        ),
      ),
    );
  }
}
