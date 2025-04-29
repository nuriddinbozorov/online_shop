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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Mahsulot muvaffaqiyatli yangilandi'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        await productsRef.add(productData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Yangi mahsulot qo\'shildi'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Colors.green,
          ),
        );
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          widget.isEdit ? 'Mahsulotni tahrirlash' : 'Yangi mahsulot',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (_imageUrl.isNotEmpty)
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  height: 180,
                  width: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      _imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder:
                          (context, error, stackTrace) => Center(
                            child: Icon(
                              Icons.broken_image,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                    ),
                  ),
                ),
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(
                  labelText: 'Mahsulot nomi',
                  labelStyle: TextStyle(color: Colors.grey[700]),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                style: TextStyle(fontSize: 16),
                onSaved: (val) => _name = val!,
                validator:
                    (val) =>
                        val!.isEmpty ? 'Mahsulot nomi kiritilishi shart' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _description,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Tavsif',
                  labelStyle: TextStyle(color: Colors.grey[700]),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                style: TextStyle(fontSize: 16),
                onSaved: (val) => _description = val!,
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _price.toString(),
                decoration: InputDecoration(
                  labelText: 'Narx (so\'m)',
                  labelStyle: TextStyle(color: Colors.grey[700]),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  prefixText: 'so\'m ',
                ),
                style: TextStyle(fontSize: 16),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onSaved: (val) => _price = double.parse(val!),
                validator:
                    (val) => val!.isEmpty ? 'Narx kiritilishi shart' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _imageUrl,
                decoration: InputDecoration(
                  labelText: 'Rasm URL manzili',
                  labelStyle: TextStyle(color: Colors.grey[700]),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                style: TextStyle(fontSize: 16),
                onSaved: (val) => _imageUrl = val!,
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                  ),
                  onPressed: _saveProduct,
                  child: Text(
                    widget.isEdit
                        ? 'O\'ZGARTIRISHLARNI SAQLASH'
                        : 'MAHSULOT QO\'SHISH',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
