import 'dart:io';

import 'package:flutter/material.dart';
import '../db/category.dart';
import '../db/banner.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/color_util.dart';

import 'add_product.dart';
import 'category_list.dart';
import 'banner_list.dart';

enum Page { dashboard, manage }

class Admin extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  Page _selectedPage = Page.dashboard;
  MaterialColor active = Colors.red;
  MaterialColor notActive = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: <Widget>[
              Expanded(
                  child: FlatButton.icon(
                      onPressed: () {
                        setState(() => _selectedPage = Page.dashboard);
                      },
                      icon: Icon(
                        Icons.dashboard,
                        color: _selectedPage == Page.dashboard
                            ? active
                            : notActive,
                      ),
                      label: Text('Dashboard'))),
              Expanded(
                  child: FlatButton.icon(
                      onPressed: () {
                        setState(() => _selectedPage = Page.manage);
                      },
                      icon: Icon(
                        Icons.sort,
                        color:
                            _selectedPage == Page.manage ? active : notActive,
                      ),
                      label: Text('Manage'))),
            ],
          ),
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        body: _loadScreen());
  }

  Widget _loadScreen() {
    switch (_selectedPage) {
      case Page.dashboard:
        return Column(
          children: <Widget>[
            ListTile(
              subtitle: FlatButton.icon(
                onPressed: null,
                icon: Icon(
                  Icons.attach_money,
                  size: 30.0,
                  color: Colors.green,
                ),
                label: Text('12,000',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30.0, color: Colors.green)),
              ),
              title: Text(
                'Revenue',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0, color: Colors.grey),
              ),
            ),
            Expanded(
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Card(
                      child: ListTile(
                          title: FlatButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.people_outline),
                              label: Text("Users")),
                          subtitle: Text(
                            '7',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 60.0),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Card(
                      child: ListTile(
                          title: FlatButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.category),
                              label: Text("Categories")),
                          subtitle: Text(
                            '23',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 60.0),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Card(
                      child: ListTile(
                          title: FlatButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.track_changes),
                              label: Text("Producs")),
                          subtitle: Text(
                            '120',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 60.0),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Card(
                      child: ListTile(
                          title: FlatButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.tag_faces),
                              label: Text("Sold")),
                          subtitle: Text(
                            '13',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 60.0),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Card(
                      child: ListTile(
                          title: FlatButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.shopping_cart),
                              label: Text("Orders")),
                          subtitle: Text(
                            '5',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 60.0),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Card(
                      child: ListTile(
                          title: FlatButton.icon(
                              onPressed: null,
                              icon: Icon(Icons.close),
                              label: Text("Return")),
                          subtitle: Text(
                            '0',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: active, fontSize: 60.0),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
        break;
      case Page.manage:
        return ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.add),
              title: Text("Add product"),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => AddProduct()));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.change_history),
              title: Text("Products list"),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.add_circle),
              title: Text("Add category"),
              onTap: () {
                _categoryAlert();
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.category),
              title: Text("Category list"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => CategoryDisplay()));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.add_circle_outline),
              title: Text("Add banner"),
              onTap: () {
                _bannerAlert();
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.library_books),
              title: Text("Banner list"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => BannerDisplay()));
              },
            ),
            Divider(),
          ],
        );
        break;
      default:
        return Container();
    }
  }

  void _categoryAlert() {
    var alert = new MyCategoryDialog();
    showDialog(context: context, builder: (_) => alert);
  }

  void _bannerAlert() {
    var alert = new MyDialog();
    showDialog(context: context, builder: (_) => alert);
  }
}

class MyCategoryDialog extends StatefulWidget {
  @override
  _MyCategoryDialogState createState() => _MyCategoryDialogState();
}

class _MyCategoryDialogState extends State<MyCategoryDialog> {
  TextEditingController categoryController = TextEditingController();

  GlobalKey<FormState> _categoryFormKey = GlobalKey();

  CategoryService _categoryService = CategoryService();

  File _image;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Form(
          key: _categoryFormKey,
          child: Column(
            children: <Widget>[
              Center(
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
              TextFormField(
                controller: categoryController,
                decoration: InputDecoration(hintText: "Add Category"),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Category cannot be empty";
                  }
                },
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton.icon(
          onPressed: () {
            if (categoryController.text != null) {
              _categoryService.createCategory(categoryController.text, _image);
                          Navigator.pop(context);
            }
          },
          icon: Icon(Icons.add),
          label: Text("Add"),
        ),
        FlatButton.icon(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.close),
          label: Text("Cancel"),
        ),
      ],
    );
  }
}

class MyDialog extends StatefulWidget {
  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  TextEditingController bannerController = TextEditingController();
  GlobalKey<FormState> _bannerFormKey = GlobalKey();
  BannerService _bannerService = BannerService();
  File _image;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Form(
          key: _bannerFormKey,
          child: Column(
            children: <Widget>[
              Center(
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
              TextFormField(
                controller: bannerController,
                decoration: InputDecoration(hintText: "Add Banner"),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Category cannot be empty";
                  }
                },
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton.icon(
          onPressed: () {
            if (bannerController.text != null && _image != null) {
              _bannerService.createBanner(bannerController.text, _image);
              Navigator.pop(context);
            }
          },
          icon: Icon(Icons.add),
          label: Text("Add"),
        ),
        FlatButton.icon(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.close),
          label: Text("Cancel"),
        ),
      ],
    );
  }
}
