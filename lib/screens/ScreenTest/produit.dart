import 'dart:io';

import 'package:fitfood/screens/ScreenTest/produitLiset.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  late String _productName;
  late String _productDescription;
  XFile? _imageFile;

  Future<void> _uploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  Future<void> _saveProduct() async {
    if (_imageFile == null ||
        _productName.isEmpty ||
        _productDescription.isEmpty) {
      // Handle validation error
      return;
    }

    final firebase_storage.Reference storageRef = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('product_images/${DateTime.now().millisecondsSinceEpoch}');
    final firebase_storage.UploadTask uploadTask =
        storageRef.putFile(File(_imageFile!.path));
    final firebase_storage.TaskSnapshot downloadUrl =
        (await uploadTask.whenComplete(() => null)!);

    final String url = await downloadUrl.ref.getDownloadURL();

    // Save product info to Firestore
    FirebaseFirestore.instance.collection('products').add({
      'name': _productName,
      'description': _productDescription,
      'image': url,
    });

    // Navigate back or show success message
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Product Name'),
              onChanged: (value) => _productName = value,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Product Description'),
              onChanged: (value) => _productDescription = value,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadImage,
              child: Text('Choose Image'),
            ),
            SizedBox(height: 20),
            _imageFile != null
                ? Image.file(File(_imageFile!.path))
                : SizedBox(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProduct,
              child: Text('Save Product'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                   Navigator.pushReplacementNamed(context, '/productListScreen');
              },
              child: Text('list Product'),
            ),
          ],
        ),
      ),
    );
  }
}
