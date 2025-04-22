import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/product.dart';

class EditProductScreen extends StatefulWidget {
  final Product? product;
  final bool isEdit;

  EditProductScreen({this.product, this.isEdit = false});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name, _description, _imageUrl;
  late double _price;

  @override
  void initState() {
    super.initState();
    _name = widget.product?.name ?? '';
    _description = widget.product?.description ?? '';
    _price = widget.product?.price ?? 0;
    _imageUrl = widget.product?.imageUrl ?? '';
  }

  void _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final productData = {
        'name': _name,
        'description': _description,
        'price': _price,
        'imageUrl': _imageUrl,
      };

      final productsRef = FirebaseFirestore.instance.collection('products');

      if (widget.isEdit) {
        await productsRef.doc(widget.product!.id).update(productData);
      } else {
        await productsRef.add(productData);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? 'Mahsulotni tahrirlash' : 'Yangi mahsulot'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Nomi'),
                onSaved: (val) => _name = val!,
                validator: (val) => val!.isEmpty ? 'Majburiy maydon' : null,
              ),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(labelText: 'Tavsifi'),
                onSaved: (val) => _description = val!,
              ),
              TextFormField(
                initialValue: _price.toString(),
                decoration: InputDecoration(labelText: 'Narxi'),
                keyboardType: TextInputType.number,
                onSaved: (val) => _price = double.parse(val!),
                validator:
                    (val) => val!.isEmpty ? 'Narx kiritilishi kerak' : null,
              ),
              TextFormField(
                initialValue: _imageUrl,
                decoration: InputDecoration(labelText: 'Rasm URL'),
                onSaved: (val) => _imageUrl = val!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProduct,
                child: Text(widget.isEdit ? 'Saqlash' : 'Qo‘shish'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
