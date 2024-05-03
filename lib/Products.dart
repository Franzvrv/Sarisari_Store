import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Configuration.dart';
import 'models/Product.dart';
import 'models/Category.dart';
import 'NavBar.dart';
import 'main.dart';

class ProductsScreen extends StatefulWidget {
  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  Future<List<Category>> categories = CategoryDatabase.instance.getCategories();

  int? selectedId;
  String? selectedCategory;
  int? selectedProductCategory;
  int? productCategory;
  Category? initialCategory;
  TextEditingController categoryController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController stockController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  ClearSelection() {
    selectedId = null;
    selectedCategory = null;
    selectedProductCategory = null;
    initialCategory = null;
    productCategory = null;
    categoryController.text = '';
    nameController.text = '';
    stockController.text = '';
    priceController.text = '';
  } //Clear all product and dialog selections

  addProductDialog(BuildContext context) {
    if (stockController.text == 'null') {
      stockController.text = '';
    }
    return showDialog(context: context,builder: (context){
      return AlertDialog(
        scrollable: true,
        title: selectedId == null ? Text('Add Product', style: dialogTitleTextStyle) : Text('Update Product', style: dialogTitleTextStyle),
        content: Container(
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Product name',
                  labelStyle: TextStyle(
                    color: Colors.cyan,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ), // Product name field
              TextFormField(
                controller: stockController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'stock (optional)',
                  labelStyle: TextStyle(
                    color: Colors.cyan,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ), // Stock field
              FutureBuilder<List<Category?>>(
                future: CategoryDatabase.instance.getCategories(),
                builder: (BuildContext context, AsyncSnapshot<List<Category?>> snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  else {
                    for(int i = 0; i < snapshot.data!.length; i++) {
                      if(productCategory == snapshot.data![i]!.id) {
                        initialCategory = snapshot.data![i];
                      }
                    }
                  }
                    return snapshot.data!.isNotEmpty && initialCategory != null ?
                    DropdownButtonFormField<Category>(
                      value: initialCategory,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'category',
                        labelStyle: TextStyle(
                          color: Colors.cyan,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                      items: snapshot.data?.map((category) => DropdownMenuItem<Category>(
                        child: Text(category!.name),
                        value: category,
                      )).toList(),
                      onChanged: (category) {
                        setState(() {
                          selectedProductCategory = category?.id;
                        });
                      },
                    ) :
                    DropdownButtonFormField<Category>(
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'category',
                            labelStyle: TextStyle(
                              color: Colors.cyan,
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                          items: snapshot.data?.map((category) => DropdownMenuItem<Category>(
                            child: Text(category!.name),
                            value: category,
                          )).toList(),
                          onChanged: (category) {
                            setState(() {
                              selectedProductCategory = category?.id;
                            });
                          },
                        );
                  }
                ), // Category field
              TextFormField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                controller: priceController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'price (PHP)',
                  labelStyle: TextStyle(
                    color: Colors.cyan,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),// Price field
              selectedId == null ?
              MaterialButton(
                  elevation: 2.0,
                  child: Text('Add'),
                  onPressed: () async {
                    await ProductDatabase.instance.add(
                      Product(name: nameController.text,
                        category: selectedProductCategory,
                        stock: int.tryParse(stockController.text),
                        price: double.parse(priceController.text),
                      ),
                    );
                    setState((){
                      categoryController.clear();
                      selectedId = null;
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                    });
                  }
              ) :
                  Row(
                    children: [
                      MaterialButton(
                          elevation: 2.0,
                          child: Text('Delete'),
                          onPressed: () async {
                            await ProductDatabase.instance.remove(selectedId!);
                            setState((){
                              categoryController.clear();
                              selectedId = null;
                              Navigator.of(context, rootNavigator: true).pop('dialog');
                            });
                          }
                      ),
                      Spacer(),
                      MaterialButton(
                          elevation: 2.0,
                          child: Text('Update'),
                          onPressed: () async {
                            await ProductDatabase.instance.update(
                              Product(id: selectedId,
                                name: nameController.text,
                                category: selectedProductCategory,
                                stock: int.parse(stockController.text),
                                price: double.parse(priceController.text),
                              ),
                            );
                            setState((){
                              categoryController.clear();
                              ClearSelection();
                              Navigator.of(context, rootNavigator: true).pop('dialog');
                            });
                          }
                      ),
                    ],
                  )
            ]
          ),
        )
      );
    }).then((value) {ClearSelection(); setState(() {});});
  } //Dialog to Add/Update products

  categoryDialog(BuildContext context) {
    return showDialog(context: context,builder: (context){
      int? selectedId;
      return StatefulBuilder(
        builder: (context, setState) {
          return Center(
            child: SimpleDialog(
                insetPadding: EdgeInsets.all(10),
                contentPadding: EdgeInsets.all(20),
                children: [
                  Text('Manage Categories', style: dialogTitleTextStyle),
                  Container(
                    height: 200,
                    width: 300,
                    child: FutureBuilder<List<Category>>(
                        future: CategoryDatabase.instance.getCategories(),
                        builder: (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }
                          return snapshot.data!.isEmpty ?
                          Center(child: Text('Add new categories below'))
                              :
                          ListView(
                            children: snapshot.data!.map((category) {
                              return Center(
                                child: Card(
                                  child: ListTile(
                                      title: Text(category.name),
                                      onTap: () {
                                        setState(() {
                                          if (selectedId == category.id) {
                                            categoryController.text = '';
                                            selectedId = null;
                                          } else {
                                            categoryController.text = category.name;
                                            selectedId = category.id;
                                          }
                                        });
                                      },
                                      onLongPress: () {
                                        setState((){
                                          CategoryDatabase.instance.remove(category.id!);
                                        });
                                      }
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }
                    ),
                  ),
                  TextFormField(
                    controller: categoryController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Category name',
                      labelStyle: TextStyle(
                        color: Colors.cyan,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ), // Product name field
                  MaterialButton(
                      elevation: 2.0,
                      child: selectedId == null ? Text('Add') : Text('Update'),
                      onPressed: () async {
                        selectedId != null
                            ? await CategoryDatabase.instance.update(
                          Category(id: selectedId, name: categoryController.text),
                        )
                            :
                        await CategoryDatabase.instance.add(
                          Category(name: categoryController.text),
                        );
                        setState((){
                          categoryController.clear();
                          selectedId = null;
                        });
                      }
                  ),
                ]
            ),
          );
        },
      );
    }).then((value) {ClearSelection(); setState(() {});});
  } //Dialog that add, remove, update categories

  Widget build (BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          extendBodyBehindAppBar: true,
          extendBody: true,
          appBar: AppBar(
              toolbarHeight: 40,
              centerTitle: true,
              title: Text('Products'),
              backgroundColor: appBarBGColor,
          ),
          body: Container (
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 70),
            decoration: appBoxDecoration,
            child: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.all(Radius.circular(24)),
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                MyElevatedButton(
                                  onPressed:  () {
                                    categoryDialog(context);
                                  },
                                  child: Text(
                                    'Manage Categories',
                                    style: smallButtonTextStyle,
                                  ),
                                  borderRadius: BorderRadius.circular(14.0),
                                  gradient: LinearGradient(colors: [buttonColor1, buttonColor2]),
                                ),
                                MyElevatedButton(
                                  onPressed:  () {
                                    ClearSelection();
                                    addProductDialog(context);
                                  },
                                  child: Text(
                                    'Add Product',
                                    style: buttonTextStyle,
                                  ),
                                  borderRadius: BorderRadius.circular(14.0),
                                  gradient: LinearGradient(colors: [buttonColor1, buttonColor2]),
                                ),
                              ]
                            )
                          ],
                        ),
                        Text(
                          'Products',
                          style: TextStyle(
                            color: columnTitleColor,
                            fontWeight: FontWeight.w800,
                            fontSize: 24,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                color: listBackgroundOverlay
                            ),
                            child: FutureBuilder<List<Product>>(
                                future: ProductDatabase.instance.getProducts(),
                                builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
                                  if (!snapshot.hasData) {
                                    return Center(child: CircularProgressIndicator());
                                  }
                                  return snapshot.data!.isEmpty ?
                                  Center(child: Text('Add Products fom above', style: smallListTextStyle))
                                      :
                                  ListView(
                                    padding: EdgeInsets.zero,
                                    children: snapshot.data!.map((product) {
                                      if (product.stock == 0) {
                                        return Card(
                                          color: Colors.transparent,
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                                            height: 80,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                                gradient: LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                    colors: [productEmptyListColor1, productEmptyListColor2]
                                                )
                                            ),
                                            child: ListTile(
                                              title: Text(product.name, style: listTextStyle,),
                                              subtitle: Text('Price: ' + product.price.toString() + ' PHP', style: smallListTextStyle),
                                              trailing: Column(
                                                  children: [
                                                    FutureBuilder<Category?>(
                                                        future: CategoryDatabase.instance.fetchCategory(product.category),
                                                        builder: (BuildContext context, AsyncSnapshot<Category?> categorySnap) {
                                                          if (!snapshot.hasData) {
                                                          }
                                                          return snapshot.data!.isEmpty ?
                                                          Text('')
                                                              :
                                                          categorySnap.data == null ?
                                                          Text('Category: Others', style: smallListTextStyle)
                                                              :
                                                          Text('Category: ' + categorySnap.data!.name, style: smallListTextStyle);
                                                        }
                                                    ),
                                                    Spacer(),
                                                    product.stock != null ? Text('Stock: ' + product.stock.toString(), style: smallListTextStyle) : Text(''),
                                                  ]
                                              ),
                                              onTap: () {
                                                selectedId = product.id;
                                                productCategory = product.category;
                                                selectedProductCategory = product.category;
                                                nameController.text = product.name;
                                                stockController.text = product.stock.toString();
                                                priceController.text = product.price.toString();
                                                addProductDialog(context);
                                              },
                                            ),
                                          ),
                                        );
                                      }
                                      else {
                                        return Card(
                                          color: Colors.transparent,
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                                            height: 80,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                                gradient: LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                    colors: [productListColor1, productListColor2]
                                                )
                                            ),
                                            child: ListTile(
                                              title: Text(product.name, style: listTextStyle,),
                                              subtitle: Text('Price: ' + product.price.toString() + ' PHP', style: smallListTextStyle),
                                              trailing: Column(
                                                  children: [
                                                    FutureBuilder<Category?>(
                                                        future: CategoryDatabase.instance.fetchCategory(product.category),
                                                        builder: (BuildContext context, AsyncSnapshot<Category?> categorySnap) {
                                                          if (!snapshot.hasData) {
                                                          }
                                                          return snapshot.data!.isEmpty ?
                                                          Text('')
                                                              :
                                                          categorySnap.data == null ?
                                                          Text('Category: Others', style: smallListTextStyle)
                                                              :
                                                          Text('Category: ' + categorySnap.data!.name, style: smallListTextStyle);
                                                        }
                                                    ),
                                                    Spacer(),
                                                    product.stock != null ? Text('Stock: ' + product.stock.toString(), style: smallListTextStyle) : Text(''),
                                                  ]
                                              ),
                                              onTap: () {
                                                selectedId = product.id;
                                                productCategory = product.category;
                                                selectedProductCategory = product.category;
                                                nameController.text = product.name;
                                                stockController.text = product.stock.toString();
                                                priceController.text = product.price.toString();
                                                addProductDialog(context);
                                              },
                                            ),
                                          ),
                                        );
                                      }
                                    }).toList(),
                                  );
                                }
                            ),
                          )
                        )
                      ]
                  ),
                ),
              ],
            ),

          ),
          bottomNavigationBar: NavBar(),
        )
    );
  }
}

