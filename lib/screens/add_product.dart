import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../db/category.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  CategoryService _categoryService = CategoryService();

  Color white = Colors.white;
  Color black = Colors.black;
  Color grey = Colors.grey;

  GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController productNameController = TextEditingController();
  TextEditingController quantityNameController = TextEditingController();
  TextEditingController costPriceNameController = TextEditingController();
  TextEditingController discountNameController = TextEditingController();
  List<DocumentSnapshot> banners = <DocumentSnapshot>[];
  List<DocumentSnapshot> categories = <DocumentSnapshot>[];
  List<DropdownMenuItem<String>> categoriesDropDown =
      <DropdownMenuItem<String>>[];
  List<DropdownMenuItem<String>> bannersDropDown = <DropdownMenuItem<String>>[];
  String _currentCategory;

  //Image
  File _image;
  StorageReference _storageReference;
  Firestore _firestore = Firestore.instance;

  @override
  void initState() {
    super.initState();
    _getCategories();
    //_currentCategory = categoriesDropDown[0].value;
  }

  void _getCategories() async {
    List<DocumentSnapshot> data = await _categoryService.getCategories();
    setState(() {
      categories = data;
      categoriesDropDown = getCategoriesDropdown();
      _currentCategory = categories[0].data['categoryName'];
    });
  }

  List<DropdownMenuItem<String>> getCategoriesDropdown() {
    List<DropdownMenuItem<String>> items = new List();
    for (int i = 0; i < categories.length; i++) {
      setState(() {
        items.insert(
            0,
            DropdownMenuItem(
              child: Text(categories[i].data['categoryName']),
              value: categories[i].data['categoryName'],
            ));
      });
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        leading: IconButton(
          icon: Icon(Icons.close, color: black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Add Products",
          style: TextStyle(color: black),
        ),
        elevation: 0.1,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: SizedBox(
                  width: 200.0,
                  height: 200.0,
                  child: OutlineButton(
                    borderSide:
                        BorderSide(color: grey.withOpacity(0.5), width: 2.5),
                    onPressed: () async {
                      var image = await ImagePicker.pickImage(
                          source: ImageSource.gallery);
                      setState(() {
                        _image = image;
                      });
                    },
                    child: _image == null
                        ? Icon(Icons.add_a_photo, color: grey)
                        : Image.file(_image),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                controller: productNameController,
                decoration: InputDecoration(
                  hintText: "Product Name (max. 10 chars) ",
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Product Name cannot be empty";
                  } else if (value.length > 10) {
                    return "Product Name should be less than 10 chars.";
                  } else
                    return null;
                },
              ),
            ),
            // Visibility(
            //   visible: _currentCategory != null,
            //   child: InkWell(
            //     child: Material(
            //       borderRadius: BorderRadius.circular(20),
            //       color: Colors.red,
            //       child: Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: Row(
            //           children: <Widget>[
            //             Expanded(
            //               child: Text(
            //                 _currentCategory ?? '',
            //                 style: TextStyle(color: white),
            //               ),
            //             ),
            //             IconButton(
            //               icon: Icon(
            //                 Icons.close,
            //                 color: white,
            //               ),
            //               onPressed: () {
            //                 setState(() {
            //                   _currentCategory = null;
            //                 });
            //               },
            //             )
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: TypeAheadField(
            //     textFieldConfiguration: TextFieldConfiguration(
            //         autofocus: false,
            //         decoration: InputDecoration(hintText: 'Choose Category')),
            //     suggestionsCallback: (pattern) async {
            //       return await _categoryService.getSuggestion(pattern);
            //     },
            //     itemBuilder: (context, suggestion) {
            //       return ListTile(
            //         leading: Icon(Icons.category),
            //         title: Text(suggestion['categoryName']),
            //       );
            //     },
            //     onSuggestionSelected: (suggestion) {
            //       setState(() {
            //         _currentCategory = suggestion['categoryName'];
            //       });
            //     },
            //   ),
            // ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Categories",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                DropdownButton(
                  items: categoriesDropDown,
                  onChanged: changeSelectedCategory,
                  value: _currentCategory,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                controller: quantityNameController,
                decoration: InputDecoration(
                  hintText: "Quantity",
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Quantity cannot be empty";
                  } else
                    return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                keyboardType: TextInputType.numberWithOptions(),
                controller: costPriceNameController,
                decoration: InputDecoration(
                  hintText: "Cost Price",
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Cost Price cannot be empty";
                  } else
                    return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                keyboardType: TextInputType.numberWithOptions(),
                controller: discountNameController,
                decoration: InputDecoration(
                  hintText: "Discount(%)",
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    value = '0.0';
                  } else
                    return null;
                },
              ),
            ),
            MaterialButton(
              height: 50.0,
              color: Colors.red,
              onPressed: addUploadProduct,
              child: Text(
                "Add Product",
                style: TextStyle(color: white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  changeSelectedCategory(String selectedCategory) {
    setState(() {
      _currentCategory = selectedCategory;
    });
  }

  Future addUploadProduct() async {
    if (_formKey.currentState.validate()) {
      if (_image == null)
        Fluttertoast.showToast(msg: "Provide an Image");
      else {
        var id = Uuid();
        String productId = id.v1();
        var imageName = productId + '.jpeg';
        _storageReference = FirebaseStorage.instance
            .ref()
            .child('$_currentCategory/$imageName');
        StorageUploadTask putFile = _storageReference.putFile(_image);
        Fluttertoast.showToast(msg: "Uploading Image.");
        await putFile.onComplete.whenComplete(() async {
          _firestore.collection('products').document(productId).setData({
            'id': productId,
            "name": productNameController.text,
            "category": _currentCategory,
            "quantity": quantityNameController.text,
            "costPrice": costPriceNameController.text,
            "discount": discountNameController.text,
            "image": await _storageReference.getDownloadURL(),
          }).whenComplete(() {
            Fluttertoast.showToast(msg: "Product Added.");
            setState(() {
              _image = null;
              _formKey.currentState.reset();
            });
          });
        });
      }
    }
  }
}
