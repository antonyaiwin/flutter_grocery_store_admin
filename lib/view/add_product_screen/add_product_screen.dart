import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_grocery_store_admin/controller/add_product_screen_controller.dart';
import 'package:flutter_grocery_store_admin/controller/firebase/firestore_controller.dart';
import 'package:flutter_grocery_store_admin/utils/global_widgets/my_network_image.dart';
import 'package:provider/provider.dart';

import 'widgets/add_image_widget.dart';

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
          key: context.read<AddProductScreenController>().formKey,
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
              DropdownButtonFormField<String>(
                borderRadius: BorderRadius.circular(10),
                hint: const Text('Select a category'),
                value:
                    context.read<AddProductScreenController>().selectedCategory,
                items: context
                    .read<FireStoreController>()
                    .categoryList
                    .map(
                      (e) => DropdownMenuItem(
                        value: e.id,
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
                        value.pickImage(context);
                      },
                      imageFile: index == value.imagesList.length
                          ? null
                          : value.imagesList[index],
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
      bottomNavigationBar: ElevatedButton(
        onPressed: () {
          if (context
              .read<AddProductScreenController>()
              .formKey
              .currentState!
              .validate()) {}
        },
        child: const Text('Add Product'),
      ),
    );
  }
}
