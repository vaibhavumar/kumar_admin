import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../utils/color_util.dart';

class BannerDisplay extends StatefulWidget {

  @override
  _BannerDisplayState createState() => _BannerDisplayState();
}

class _BannerDisplayState extends State<BannerDisplay> {
  Firestore _storage = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: white,
          leading: Icon(Icons.close, color: black),
          title: Text(
            'Banners',
            style: TextStyle(color: black),
          ),
          elevation: 0.1,
        ),
        body: StreamBuilder(
          stream: _storage.collection('banners').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text('Loading...');
            return ListView.builder(
              itemExtent: 80.0,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) => _buildListItem(
                  context, snapshot.data.documents[index], index),
            );
          },
        ));
  }

  _buildListItem(BuildContext context, DocumentSnapshot document, int index) {
    return InkWell(
        onTap: () {},
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(color: Color(0xffddddff)),
              child: Text('${index + 1}'),
            ),
            Expanded(
              child: Container(
                  padding: EdgeInsets.all(30.0),
                  child: Text(
                    document['bannerName'],
                    style: TextStyle(
                        color: Colors.deepOrange, fontWeight: FontWeight.bold),
                  )),
            )
          ],
        ));
  }
}
