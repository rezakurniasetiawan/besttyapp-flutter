// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:besty_apps/constan.dart';
import 'package:besty_apps/model/api_response_model.dart';
import 'package:besty_apps/screens/login/login_screen.dart';
import 'package:besty_apps/screens/tabs_screen.dart';
import 'package:besty_apps/services/auth_services.dart';
import 'package:besty_apps/services/post_services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPosting extends StatefulWidget {
  const AddPosting({Key? key}) : super(key: key);

  @override
  State<AddPosting> createState() => _AddPostingState();
}

class _AddPostingState extends State<AddPosting> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController _textPosting = TextEditingController();
  bool loading = true;

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(
            color: Colors.redAccent,
          ),
          Container(margin: EdgeInsets.only(left: 5), child: Text("Loading")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  File? _imageFile;
  final _picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _createdPost() async {
    String? image = _imageFile == null ? null : getStringImage(_imageFile);
    ApiResponse response = await createPost(_textPosting.text, image);

    if (response.error == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => TabsScreen()),
          (route) => false);
    } else if (response.error == unauthorized) {
      logout().then((value) => Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
      setState(() {
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Postingan Baru",
            style: TextStyle(color: Colors.black87),
          ),
          backgroundColor: Colors.white,
        ),
        body: ListView(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 250,
              decoration: BoxDecoration(
                  image: _imageFile == null
                      ? null
                      : DecorationImage(
                          image: FileImage(_imageFile ?? File('')),
                          fit: BoxFit.cover)),
              child: Center(
                child: IconButton(
                    icon: Icon(
                      Icons.image,
                      size: 50,
                    ),
                    onPressed: () {
                      getImage();
                    }),
              ),
            ),
            Form(
              key: _key,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: TextFormField(
                  controller: _textPosting,
                  keyboardType: TextInputType.multiline,
                  maxLines: 9,
                  validator: (val) => val!.isEmpty ? 'Harus diisi yaa' : null,
                  decoration: InputDecoration(
                    hintText: "Tulis keterangan disini...",
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Colors.black87)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                      color: Colors.redAccent,
                    )),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: Align(
                alignment: Alignment.topRight,
                child: ElevatedButton(
                  onPressed: () {
                    if (_key.currentState!.validate()) {
                      setState(() {
                        showAlertDialog(context);
                      });
                      _createdPost();
                    }
                  },
                  child: Text(
                    'Posting Sekarang',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.redAccent,
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
