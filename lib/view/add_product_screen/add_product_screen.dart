import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_grocery_store_admin/controller/add_product_screen_controller.dart';
import 'package:flutter_grocery_store_admin/core/constants/color_constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AddProductScreenController provider =
        context.read<AddProductScreenController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Product'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: provider.nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 25),
              TextFormField(
                controller: provider.descriptionController,
                minLines: 1,
                maxLines: 10,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 25),
              TextFormField(
                controller: provider.priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  prefixIcon: Icon(Icons.currency_rupee),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 25),
              TextFormField(
                controller: provider.barcodeController,
                decoration: InputDecoration(
                  labelText: 'Barcode',
                  prefixIcon: const Icon(Icons.qr_code),
                  suffixIcon: IconButton(
                    onPressed: () {
                      provider.scanBarcode();
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
                    itemBuilder: (context, index) => AddImageWidget(
                      onTap: () {
                        value.pickImage();
                      },
                      imagePath: index == value.imagesList.length
                          ? null
                          : value.imagesList[index].path,
                    ),
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 10),
                    itemCount: provider.imagesList.length + 1,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AddImageWidget extends StatelessWidget {
  const AddImageWidget({
    super.key,
    this.imagePath,
    this.onTap,
    this.borderRadius,
  });
  final String? imagePath;
  final void Function()? onTap;
  final BorderRadius? borderRadius;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius ?? BorderRadius.circular(10),
      child: Container(
          clipBehavior: Clip.antiAlias,
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            borderRadius: borderRadius ?? BorderRadius.circular(10),
            image: imagePath != null
                ? DecorationImage(image: FileImage(File(imagePath!)))
                : null,
            border: Border.all(
              color: ColorConstants.hintColor,
              width: 2,
            ),
          ),
          child: imagePath == null
              ? const Icon(
                  Icons.camera,
                  size: 50,
                )
              : Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton.filled(
                      constraints: BoxConstraints.loose(const Size.square(30)),
                      padding: const EdgeInsets.all(5),
                      iconSize: 18,
                      onPressed: () {},
                      icon: const Icon(
                        Icons.delete,
                      )),
                ) /* Image.file(
                File(imagePath!),
                fit: BoxFit.cover,
              ), */
          ),
    );
  }
}
