import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const String routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct =
      Product(description: '', id: null, imageUrl: '', price: 0.0, title: '');
  var init = true;

  var initialValue = {
    'title': '',
    'price': '',
    'imageUrl': '',
    'description': '',
  };

  var _isLoading = false;
  @override
  void didChangeDependencies() {
    if (init) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct = Provider.of<Products>(context).findById(productId);
        initialValue = {
          'title': _editedProduct.title,
          'price': _editedProduct.price.toString(),
          'imageUrl': '',
          'description': _editedProduct.description,
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }

    init = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();

    super.dispose();
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);

    super.initState();
  }

  _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https') ||
          (!_imageUrlController.text.endsWith('.jpg')) &&
              (!_imageUrlController.text.endsWith('.png')) &&
              (!_imageUrlController.text.endsWith('.jpeg'))) {
        return 'Please provide a valid imageUrl';
      }

      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    var validate = _form.currentState.validate();
    if (!validate) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);

     // Navigator.of(context).pop();
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProducts(_editedProduct);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                  //Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
      // finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
     
    }
     setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: _saveForm)
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Form(
                  key: _form,
                  child: ListView(children: <Widget>[
                    TextFormField(
                      initialValue: initialValue['title'],
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            description: _editedProduct.description,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            imageUrl: _editedProduct.imageUrl,
                            price: _editedProduct.price,
                            title: value);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a Title.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: initialValue['price'],
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (value) {
                        print('price1234567');
                        _editedProduct = Product(
                            description: _editedProduct.description,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            imageUrl: _editedProduct.imageUrl,
                            price: double.parse(value),
                            title: _editedProduct.title);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a Price.';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please provide a valid number.';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please provide a number greater than 0.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: initialValue['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      onSaved: (value) {
                        _editedProduct = Product(
                            description: value,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            imageUrl: _editedProduct.imageUrl,
                            price: _editedProduct.price,
                            title: _editedProduct.title);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a Description.';
                        }
                        if (value.length < 10) {
                          return 'Please provide a Description greater than 10 characters';
                        }
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey)),
                          child: _imageUrlController.text.isEmpty
                              ? Text('Enter a Url')
                              : FittedBox(
                                  child:
                                      Image.network(_imageUrlController.text),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'ImageUrl'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                  description: _editedProduct.description,
                                  id: _editedProduct.id,
                                  isFavorite: _editedProduct.isFavorite,
                                  imageUrl: value,
                                  price: _editedProduct.price,
                                  title: _editedProduct.title);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please provide a imageUrl';
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Please provide a valid imageUrl';
                              }
                              if (!value.endsWith('.jpg') &&
                                  (!value.endsWith('.png')) &&
                                  (!value.endsWith('.jpeg'))) {
                                return 'Please provide a valid imageUrl';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    )
                  ])),
            ),
    );
  }
}
