import 'dart:io';

import 'package:besty_apps/model/api_response_model.dart';
import 'package:besty_apps/model/post_model.dart';
import 'package:besty_apps/model/user_model.dart';
import 'package:besty_apps/screens/account/component/edit_profil.dart';
import 'package:besty_apps/screens/account/component/postingan_user.dart';
import 'package:besty_apps/screens/login/login_screen.dart';
import 'package:besty_apps/services/auth_services.dart';
import 'package:besty_apps/services/postingan_user_services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../constan.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>
    with TickerProviderStateMixin {
  late TabController tabController = TabController(length: 2, vsync: this);
  UserModel? userModel;
  bool loading = true;
  List<dynamic> _userList = [];

  File? _imageFile;
  final _picker = ImagePicker();
  TextEditingController txtNameController = TextEditingController();

  @override
  void dispose() {
    tabController.dispose();

    super.dispose();
  }

  Future getImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  //Get user detail
  void getUser() async {
    ApiResponse response = await getUserDetail();
    if (response.error == null) {
      setState(() {
        userModel = response.data as UserModel;
        loading = false;
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

  //get all post by iduser
  Future<void> getPostUser(int userId) async {
    ApiResponse response = await getPostUsers(userId);
    print(userId);
    if (response.error == null) {
      setState(() {
        _userList = response.data as List<dynamic>;
        loading = loading ? !loading : loading;
      });
    } else if (response.error == unauthorized) {
      logout().then((value) => Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false));
    } else {
      print("object");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  @override
  void initState() {
    getUser();
    // getPostUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Center(
            child: CircularProgressIndicator(
              color: Colors.redAccent,
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => EditProfil(
                                  userModel: userModel!,
                                )),
                      );
                    },
                    child: Icon(
                      Icons.settings,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
              elevation: 0,
            ),
            body: ListView(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                          image: userModel!.image != null
                              ? DecorationImage(
                                  image: NetworkImage('${userModel!.image}'),
                                  fit: BoxFit.cover)
                              : null,
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.redAccent),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${userModel!.name}",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        ImageIcon(
                          AssetImage('assets/images/verified.png'),
                          color: Color(0xFF1676ED),
                          size: 20,
                        ),
                      ],
                    )),
                    SizedBox(
                      height: 3,
                    ),
                    Center(
                      child: Text(
                        "Bergabung pada : ${userModel!.createdAt}",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              "3",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text("Post"),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "0",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text("Followers"),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "0",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text("Following"),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: TabBar(
                        controller: tabController,
                        indicatorColor: Colors.redAccent,
                        tabs: [
                          Tab(
                            child: Text(
                              "Posting",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          Tab(
                            child: Text(
                              "Tag",
                              style: TextStyle(color: Colors.black),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: double.maxFinite,
                      height: double.maxFinite,
                      child: TabBarView(
                        controller: tabController,
                        children: [
                          PostinganUserPage(
                            userId: userModel!.id ?? 0,
                          ),
                          Text("data"),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 100,
                    )
                  ],
                ),
              ],
            ),
          );
  }
}
