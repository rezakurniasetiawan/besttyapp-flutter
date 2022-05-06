import 'dart:io';

import 'package:besty_apps/model/api_response_model.dart';
import 'package:besty_apps/model/user_model.dart';
import 'package:besty_apps/screens/login/login_screen.dart';
import 'package:besty_apps/screens/tabs_screen.dart';
import 'package:besty_apps/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../constan.dart';

class EditProfil extends StatefulWidget {
  EditProfil({Key? key, required this.userModel}) : super(key: key);

  UserModel userModel;

  @override
  State<EditProfil> createState() => _EditProfilState();
}

class _EditProfilState extends State<EditProfil> {
  bool loading = true;
  File? _imageFile;
  final _picker = ImagePicker();
  TextEditingController txtNameController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future getImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

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

  //update profile
  void updateProfile() async {
    ApiResponse response =
        await updateUser(txtNameController.text, getStringImage(_imageFile));
    if (response.error == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.data}')));
      setState(() {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => TabsScreen()),
            (route) => false);
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
    if (widget.userModel.name != null) {
      txtNameController.text = widget.userModel.name ?? '';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black87),
        title: Text(
          "Edit Profil",
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 40, left: 40, right: 40),
        child: ListView(
          children: [
            Center(
              child: SizedBox(
                height: 100,
                width: 100,
                child: Stack(
                  fit: StackFit.expand,
                  overflow: Overflow.visible,
                  children: [
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          image: _imageFile == null
                              ? widget.userModel.image != null
                                  ? DecorationImage(
                                      image: NetworkImage(
                                          '${widget.userModel.image}'),
                                      fit: BoxFit.cover)
                                  : null
                              : DecorationImage(
                                  image: FileImage(_imageFile ?? File('')),
                                  fit: BoxFit.cover),
                          color: Colors.redAccent),
                    ),
                    Positioned(
                      bottom: 0,
                      right: -10,
                      child: SizedBox(
                        height: 43,
                        width: 43,
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                            side: BorderSide(color: Colors.white, width: 2),
                          ),
                          color: Color(0xFFea4a49),
                          onPressed: () {
                            getImage();
                          },
                          child: Image.asset(
                            'assets/images/user.png',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Form(
              key: formKey,
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: 'Nama',
                    contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.black))),
                controller: txtNameController,
                validator: (val) => val!.isEmpty ? 'Invalid Name' : null,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.topRight,
              child: ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    setState(() {
                      showAlertDialog(context);
                    });
                    updateProfile();
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
            )
          ],
        ),
      ),
    );
  }
}
