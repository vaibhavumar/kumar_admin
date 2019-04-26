import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';

//TODO ========== Image Imports ============
class BannerService{
  Firestore _firestore = Firestore.instance;
  StorageReference _storageReference;

  void createBanner(String name, File _image) async {
    var id = Uuid();
    String bannerId = id.v1();
    String imageName = bannerId+'.jpeg';
    _storageReference = FirebaseStorage.instance.ref().child('banners/$imageName');
        StorageUploadTask putFile = _storageReference.putFile(_image);
        Fluttertoast.showToast(msg: 'Uploading Image');
        await putFile.onComplete.whenComplete(() async {
            _firestore.collection('banners').document(bannerId).setData({
            "bannerName": name,
            "image": await _storageReference.getDownloadURL(),
          }).whenComplete((){
            Fluttertoast.showToast(msg: "Banner added.");
          });
          });
  }


  Future<List<DocumentSnapshot>> getBanners(){
    return _firestore.collection("banner").getDocuments().then((snaps){
      print(snaps.documents.length);
      return snaps.documents;
    });
  }
}