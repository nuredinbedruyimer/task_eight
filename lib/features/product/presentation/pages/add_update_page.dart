import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/entities/product.dart';
import '../bloc/product_bloc.dart';
import '../widgets/custom_button.dart';

class AddUpdatePage extends StatefulWidget {
  final bool isAdding;
  final Product? product;
  const AddUpdatePage({super.key, required this.isAdding, this.product});

  @override
  State<AddUpdatePage> createState() => _AddUpdatePageState();
}

class _AddUpdatePageState extends State<AddUpdatePage> {
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController descriptionController;
  late TextEditingController typeController;
  File? _image;

  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if (widget.isAdding) {
      nameController = TextEditingController();
      priceController = TextEditingController();
      descriptionController = TextEditingController();
      typeController = TextEditingController();
    } else {
      nameController = TextEditingController(text: widget.product?.name ?? '');
      priceController =
          TextEditingController(text: widget.product?.price.toString() ?? '');
      descriptionController =
          TextEditingController(text: widget.product?.description ?? '');
      typeController = TextEditingController();
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Store the selected image in _image
      });
    }
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      if (widget.isAdding) {
        context.read<ProductBloc>().add(
              CreateProductEvent(
                product: Product(
                  id: '',
                  name: nameController.text,
                  price: double.parse(priceController.text),
                  description: descriptionController.text,
                  imageUrl: _image!.path,
                ),
              ),
            );
      } else if (widget.product != null) {
        context.read<ProductBloc>().add(
              UpdateProductEvent(
                product: Product(
                  id: widget.product!.id,
                  name: nameController.text,
                  price: double.parse(priceController.text),
                  description: descriptionController.text,
                  imageUrl: '',
                ),
              ),
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(254, 254, 254, 1),
        appBar: AppBar(
          title: Text(widget.isAdding ? 'Add Product' : 'Update Product'),
          centerTitle: true,
        ),
        body: BlocListener<ProductBloc, ProductState>(
          listener: (context, state) {
            if (state is ProductCreatedState) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Product Created Successfully')));
              Navigator.of(context).pushNamed('/');
            } else if (state is ProductUpdatedState) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Product Updated Successfully')));
              Navigator.of(context).pushNamed('/');
            } else if (state is ProductCreatedErrorState) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            } else if (state is ProductUpdatedErrorState) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(243, 243, 243, 1),
                          borderRadius: BorderRadius.circular(8),
                          image: _image !=
                                  null // Show the picked image if available
                              ? DecorationImage(
                                  image: FileImage(_image!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _image == null
                            ? const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image_outlined,
                                    size: 40,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text('Upload Image')
                                ],
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text('Name'),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                          fillColor: Color.fromRGBO(243, 243, 243, 1),
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          )),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the product name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text('Category'),
                    const SizedBox(
                      height: 5,
                    ),
                    TextField(
                      controller: typeController,
                      decoration: const InputDecoration(
                          fillColor: Color.fromRGBO(243, 243, 243, 1),
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          )),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text('Price'),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      controller: priceController,
                      decoration: const InputDecoration(
                          hintText: '\$',
                          hintTextDirection: TextDirection.rtl,
                          fillColor: Color.fromRGBO(243, 243, 243, 1),
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          )),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the product price';
                        }
                        final price = double.tryParse(value);
                        if (price == null || price <= 0) {
                          return 'Please enter a valid price';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text('Description'),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      controller: descriptionController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                          fillColor: Color.fromRGBO(243, 243, 243, 1),
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          )),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the product description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    BlocBuilder<ProductBloc, ProductState>(
                      builder: (context, state) {
                        return CustomButton(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          borderColor: Theme.of(context).primaryColor,
                          buttonWidth: double.maxFinite,
                          buttonHeight: 45,
                          onPressed: _handleSubmit,
                          child: state is ProductLoading
                              ? const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                )
                              : Text(
                                  widget.isAdding ? 'ADD' : 'UPDATE',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomButton(
                        backgroundColor: Colors.white,
                        foregroundColor:
                            const Color.fromRGBO(255, 19, 19, 0.79),
                        borderColor: const Color.fromRGBO(255, 19, 19, 0.79),
                        buttonWidth: double.maxFinite,
                        buttonHeight: 45,
                        child: const Text(
                          'DELETE',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        onPressed: () {}),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
