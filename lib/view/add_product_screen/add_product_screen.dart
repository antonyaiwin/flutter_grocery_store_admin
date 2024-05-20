import 'package:flutter/material.dart';
import 'package:flutter_grocery_store_admin/controller/screens/add_product_screen_controller.dart';
import 'package:flutter_grocery_store_admin/controller/firebase/firestore_controller.dart';
import 'package:flutter_grocery_store_admin/core/enum/unit_type.dart';
import 'package:flutter_grocery_store_admin/model/product_model.dart';
import 'package:flutter_grocery_store_admin/utils/functions/web_functions.dart';
import 'package:flutter_grocery_store_admin/utils/global_widgets/my_network_image.dart';
import 'package:flutter_grocery_store_admin/utils/global_widgets/product_card.dart';
import 'package:flutter_grocery_store_admin/view/photo_screen/photo_screen.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../utils/functions/functions.dart';
import '../../utils/global_widgets/add_image_widget.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AddProductScreenController provider =
        context.read<AddProductScreenController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Product'),
        actions: [
          Consumer<AddProductScreenController>(
            builder: (BuildContext context, value, Widget? child) => IconButton(
                onPressed: () async {
                  await provider.scanBarcode();
                  if (provider.barcodeController.text.isNotEmpty) {
                    var list = (await context
                        .read<FireStoreController>()
                        .searchProductsUsingBarcode(
                            provider.barcodeController.text));
                    if (list.isNotEmpty &&
                        !await showDuplicateBarcodeDialog(context, list)) {
                      return;
                    } else {
                      provider.searchingDetails = true;
                      provider.notifyListeners();
                      var data =
                          await extractData(provider.barcodeController.text);
                      if (data?.name != null) {
                        provider.nameController.text = data!.name!;
                      }
                      if (data?.description != null) {
                        provider.descriptionController.text =
                            data!.description!;
                      }
                      provider.searchingDetails = false;
                      provider.notifyListeners();
                    }
                  }
                },
                icon: value.searchingDetails
                    ? const CircularProgressIndicator()
                    : const Icon(Iconsax.scan_barcode_bold)),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: provider.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: provider.nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value != null && value.length >= 3) {
                    return null;
                  } else {
                    return 'Enter a valid name';
                  }
                },
              ),
              const SizedBox(height: 25),
              TextFormField(
                controller: provider.descriptionController,
                minLines: 1,
                maxLines: 10,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value != null && value.length >= 3) {
                    return null;
                  } else {
                    return 'Enter a valid Description';
                  }
                },
              ),
              const SizedBox(height: 25),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Category'),
                borderRadius: BorderRadius.circular(10),
                value: context
                    .read<AddProductScreenController>()
                    .selectedCategoryId,
                items: context
                    .read<FireStoreController>()
                    .categoryList
                    .map(
                      (e) => DropdownMenuItem(
                        value: e.collectionDocumentId,
                        child: Row(
                          children: [
                            MyNetworkImage(
                              imageUrl: e.imageUrl ?? '',
                              height: 50,
                              width: 50,
                            ),
                            const SizedBox(width: 10),
                            Text(e.name ?? '')
                          ],
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  context
                      .read<AddProductScreenController>()
                      .onCategorySelected(value);
                },
                validator: (value) {
                  if (value != null) {
                    return null;
                  } else {
                    return 'Please select a category';
                  }
                },
              ),
              const SizedBox(height: 25),
              TextFormField(
                controller: provider.priceMrpController,
                decoration: const InputDecoration(
                  labelText: 'Price (MRP)',
                  prefixIcon: Icon(Icons.currency_rupee),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && double.tryParse(value) != null) {
                    return null;
                  } else {
                    return 'Enter a valid price';
                  }
                },
              ),
              const SizedBox(height: 25),
              TextFormField(
                controller: provider.priceSellingController,
                decoration: const InputDecoration(
                  labelText: 'Price (Selling)',
                  prefixIcon: Icon(Icons.currency_rupee),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && double.tryParse(value) != null) {
                    return null;
                  } else {
                    return 'Enter a valid price';
                  }
                },
              ),
              const SizedBox(height: 25),
              TextFormField(
                controller: provider.quantityController,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  prefixIcon: Icon(Iconsax.weight_bold),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && double.tryParse(value) != null) {
                    return null;
                  } else {
                    return 'Enter a valid number';
                  }
                },
              ),
              const SizedBox(height: 25),
              DropdownButtonFormField<UnitType>(
                decoration: const InputDecoration(labelText: 'Unit'),
                borderRadius: BorderRadius.circular(10),
                hint: const Text('Select a unit'),
                value:
                    context.read<AddProductScreenController>().selectedUnitType,
                items: context
                    .read<AddProductScreenController>()
                    .unitList
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.name),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  context
                      .read<AddProductScreenController>()
                      .onUnitSelected(value);
                },
                validator: (value) {
                  if (value != null) {
                    return null;
                  } else {
                    return 'Please select a unit';
                  }
                },
              ),
              const SizedBox(height: 25),
              TextFormField(
                controller: provider.barcodeController,
                decoration: InputDecoration(
                  labelText: 'Barcode',
                  prefixIcon: const Icon(Icons.qr_code),
                  suffixIcon: IconButton(
                    onPressed: () async {
                      await provider.scanBarcode();
                      if (provider.barcodeController.text.isNotEmpty) {
                        var list = (await context
                            .read<FireStoreController>()
                            .searchProductsUsingBarcode(
                                provider.barcodeController.text));
                        if (list.isNotEmpty &&
                            !await showDuplicateBarcodeDialog(context, list)) {
                          return;
                        }
                      }
                    },
                    icon: const Icon(Icons.barcode_reader),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              Text(
                'Images',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 100,
                child: Consumer<AddProductScreenController>(
                  builder: (BuildContext context, value, Widget? child) =>
                      ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => index == 0
                        ? AddImageWidget(
                            onCameraPressed: () {
                              value.pickImage(context);
                            },
                            onImagePressed: () {
                              value.pickImage(context, ImageSource.gallery);
                            },
                          )
                        : AddImageWidget(
                            imageFile: value.imagesList[index - 1],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PhotoScreen(
                                      imageFile: value.imagesList[index - 1]),
                                ),
                              );
                            },
                            onDeletePressed: () {
                              value.deleteImage(value.imagesList[index - 1]);
                            },
                          ),
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 10),
                    itemCount: provider.imagesList.length + 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Consumer<AddProductScreenController>(
        builder: (BuildContext context, value, Widget? child) => ElevatedButton(
          onPressed: value.uploading
              ? null
              : () async {
                  if (provider.formKey.currentState!.validate()) {
                    if (value.productModel == null) {
                      if (provider.barcodeController.text.isNotEmpty) {
                        var list = (await context
                            .read<FireStoreController>()
                            .searchProductsUsingBarcode(
                                provider.barcodeController.text));
                        if (list.isNotEmpty &&
                            !await showDuplicateBarcodeDialog(context, list)) {
                          return;
                        }
                      }
                      if (await provider.addProduct(context) &&
                          context.mounted) {
                        Navigator.pop(context);
                        showSuccessSnackBar(
                          context: context,
                          content:
                              'Product "${provider.nameController.text}" added.',
                        );
                      }
                    } else if (value.isEdited()) {
                      // TODO implement this

                      // if (await provider.updateCategory(context) &&
                      //     context.mounted) {
                      //   Navigator.pop(context);
                      //   showSuccessSnackBar(
                      //     context: context,
                      //     content:
                      //         'Category "${provider.nameController.text}" updated.',
                      //   );
                      // }
                    } else {
                      showErrorSnackBar(
                          context: context, content: 'No change detected');
                    }
                  }
                },
          child: value.uploading
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(value.message),
                    const SizedBox(width: 10),
                    const CircularProgressIndicator()
                  ],
                )
              : Text(provider.productModel == null
                  ? 'Add Product'
                  : 'Update Product'),
        ),
      ),
    );
  }

  Future<bool> showDuplicateBarcodeDialog(
      BuildContext context, List<ProductModel> list) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Duplicate barcode found!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
                'The entered barcode is used on another product. \nDo you wish to continue?'),
            SizedBox(
              height: 230,
              width: 500,
              child: ListView.separated(
                clipBehavior: Clip.none,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) =>
                    SizedBox(width: 150, child: ProductCard(item: list[index])),
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(width: 10),
                itemCount: list.length,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text('No'),
          ),
        ],
      ),
    );
  }
}
