import 'package:cloud_firestore/cloud_firestore.dart';

class CrudMethod{
  Future<void> addData(blogData) async{
    FirebaseFirestore.instance.collection("Blogs").add(blogData).catchError((e){
      print(e);
    });
  }

  getData() async{
    return await FirebaseFirestore.instance.collection("Blogs").snapshots();
  }
}