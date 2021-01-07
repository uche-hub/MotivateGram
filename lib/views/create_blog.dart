import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motivate_gram/servies/crud.dart';
import 'package:motivate_gram/widgets/provider_widget.dart';
import 'package:random_string/random_string.dart';

class CreateBlog extends StatefulWidget {
  @override
  _CreateBlogState createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {

  String authorName, desc;

  CrudMethod crudMethod = new CrudMethod();

  File selectedImage;
  bool _isLoading = false;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        selectedImage = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  uploadBlog() async{
    if(selectedImage != null){

      setState(() {
        _isLoading = true;
      });
      /// Uploading Image to firebase storage
      Reference firebaseStorageRef = FirebaseStorage.instance.ref().child("BlogImages").child(
        "${randomAlphaNumeric(9)}.jpg"
      );
      final UploadTask task = firebaseStorageRef.putFile(selectedImage);

      var downloadUrl = await (await task).ref.getDownloadURL();
      print("this is url $downloadUrl");
      Map<String, String> blogMap = {
        'imgUrl': downloadUrl,
        'authorName': authorName = Provider.of(context).auth.getProfileName(),
        'description': desc
      };
      
      crudMethod.addData(blogMap).then((result) {
        Navigator.pop(context);
      });

    }else{

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Motivate",
              style: TextStyle(
                  fontSize: 22,
                  fontFamily: 'Langar'
              ),
            ),
            Text(
              "Gram",
              style: TextStyle(
                  fontSize: 22,
                  fontFamily: 'Langar',
                  fontWeight: FontWeight.w900,
                  color: Color(0xffc41a78)
              ),
            )
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          GestureDetector(
            onTap: (){
              uploadBlog();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(
                  Icons.file_upload,
                color: Color(0xffc41a78),
              ),
            ),
          ),
        ],
      ),
      body: _isLoading ? Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ) : SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(height: 10,),
              GestureDetector(
                onTap: (){
                  getImage();
                },
                child: selectedImage != null ? Container(
                  height: 170,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.file(selectedImage, fit: BoxFit.cover,),
                  ),
                ) : Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  height: 170,
                  decoration: BoxDecoration(
                      color:   Colors.white,
                      borderRadius: BorderRadius.circular(6)
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Icon(
                    Icons.add_a_photo,
                    color: Color(0xffc41a78),
                  ),
                ),
              ),
              SizedBox(height: 8,),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: Provider.of(context).auth.getProfileName(),
                      ),
                      onChanged: (val){
                        authorName = val;
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Quote",
                      ),
                      onChanged: (val){
                        desc = val;
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
