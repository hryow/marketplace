import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProductCreatePage extends StatefulWidget {
  const ProductCreatePage({Key? key}) : super(key: key);

  @override
  State<ProductCreatePage> createState() => _ProductCreatePageState();
}

class _ProductCreatePageState extends State<ProductCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  File? _imageFile;
  bool _loading = false;
  String? _error;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage(File file) async {
    final fileName = 'products/${DateTime.now().millisecondsSinceEpoch}.jpg';
    final ref = FirebaseStorage.instance.ref().child(fileName);
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });
    try {
      String? imageUrl;
      if (_imageFile != null) {
        imageUrl = await _uploadImage(_imageFile!);
      }
      await FirebaseFirestore.instance.collection('products').add({
        'name': _nameController.text.trim(),
        'price': num.tryParse(_priceController.text.trim()) ?? 0,
        'image': imageUrl ?? '',
      });
      if (mounted) Navigator.pop(context);
    } catch (e) {
      setState(() { _error = 'Failed to add product: $e'; });
    }
    setState(() { _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
                validator: (v) => v == null || v.isEmpty ? 'Enter a name' : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Enter a price' : null,
              ),
              const SizedBox(height: 16),
              _imageFile != null
                  ? Image.file(_imageFile!, height: 120)
                  : const SizedBox(height: 120, child: Center(child: Text('No image selected'))),
              TextButton.icon(
                icon: const Icon(Icons.image),
                label: const Text('Pick Image'),
                onPressed: _pickImage,
              ),
              const SizedBox(height: 16),
              if (_error != null) ...[
                Text(_error!, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 10),
              ],
              _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Add Product'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
