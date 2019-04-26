import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

class CategoryService{
  Firestore _firestore = Firestore.instance;
  String ref = "categories";

  StorageReference _storageReference;

  void createCategory(String name, File _image) async {
    var id = Uuid();
    String categoryId = id.v1();
    String imageName = categoryId+'.jpeg';
    _storageReference = FirebaseStorage.instance.ref().child('category/$imageName');
        StorageUploadTask putFile = _storageReference.putFile(_image);
        Fluttertoast.showToast(msg: 'Uploading Image');
        await putFile.onComplete.whenComplete(() async {
            _firestore.collection('categories').document(categoryId).setData({
            "categoryName": name,
            "image": await _storageReference.getDownloadURL(),
          }).whenComplete((){
            Fluttertoast.showToast(msg: "Category added.");
          });
          });
  }

  Future<List<DocumentSnapshot>> getCategories(){
    return _firestore.collection(ref).getDocuments().then((snaps){
      return snaps.documents;
      
    });
  }

  Future<List<DocumentSnapshot>> getSuggestion(String suggestion){
    return _firestore.collection(ref).where('categoryName', isEqualTo: suggestion).getDocuments().then((snaps){
      return snaps.documents;
    });
  }
}