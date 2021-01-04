import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:motivate_gram/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:motivate_gram/servies/auth_service.dart';
import 'package:motivate_gram/servies/crud.dart';
import 'package:motivate_gram/widgets/provider_widget.dart';
import 'package:share/share.dart';

import '../create_blog.dart';


class HomePage extends StatefulWidget with NavigationStates{
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CrudMethod crudMethod = new CrudMethod();

  Stream blogStream;



  Widget BlogsList() {
    return SingleChildScrollView(

      child: Container(
        child: blogStream != null ? Column(
          children: [
            StreamBuilder(
              stream: blogStream,
              builder: (context, snapshot){
                if(snapshot.data == null) return CircularProgressIndicator();
                return ListView.builder(
                  physics: ClampingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  itemCount: snapshot.data.docs.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index){
                    return BlogTile(
                      authorName: snapshot.data.docs[index].data()['authorName'],
                      description: snapshot.data.docs[index].data()["description"],
                      imgUrl: snapshot.data.docs[index].data()["imgUrl"],
                    );
                  },
                );
              },
            )
          ],
        ): Container(
          alignment: Alignment.center,
          child: CircularProgressIndicator(),),
      ),
    );
  }

  @override
  void initState() {
    crudMethod.getData().then((results){
      setState(() {
        blogStream = results;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
                  color: Colors.greenAccent
              ),
            )
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: BlogsList(),
      floatingActionButton: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => CreateBlog()
                ));
              },
              child: Icon(
                  Icons.add
              ),
            )
          ],
        ),
      ),
    );
  }
}




class BlogTile extends StatelessWidget {

  String imgUrl;
  String description, authorName;

  BlogTile({
    @required this.imgUrl,
    @required this.description,
    @required this.authorName
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      height: 170,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: CachedNetworkImage(
              imageUrl: imgUrl,
              height: 900,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: 170,
            decoration: BoxDecoration(
                color: Colors.black45.withOpacity(0.5),
                borderRadius: BorderRadius.circular(6)
            ),
          ),
          Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 4,),
                Text(
                  description != null ? description : '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Langar',
                      fontWeight: FontWeight.w400
                  ),
                ),
                SizedBox(height: 4,),
                Text(authorName != null ? authorName : ''),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

