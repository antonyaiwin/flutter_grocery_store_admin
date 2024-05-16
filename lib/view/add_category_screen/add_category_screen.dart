import 'package:flutter/material.dart';
import 'package:flutter_grocery_store_admin/utils/functions/functions.dart';
import 'package:provider/provider.dart';

import '../../controller/add_category_screen_controller.dart';

import '../add_product_screen/widgets/add_image_widget.dart';

class AddCategoryScreen extends StatelessWidget {
  const AddCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AddCategoryScreenController provider =
        context.read<AddCategoryScreenController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Category'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20).copyWith(bottom: 5),
              child: Form(
                key: provider.formKey,
                child: Column(
                  children: [
                    Text(
                      'Image',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 10),
                    Consumer<AddCategoryScreenController>(
                      builder: (BuildContext context, value, Widget? child) =>
                          AddImageWidget(
                        onTap: () {
                          value.pickImage(context);
                        },
                        imageFile: value.imageFile,
                      ),
                    ),
                    const SizedBox(height: 25),
                    TextFormField(
                      controller: provider.nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (value) {
                        if (value == null || value.length < 3) {
                          return 'Enter a valid category name';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Consumer<AddCategoryScreenController>(
            builder: (BuildContext context, value, Widget? child) =>
                ElevatedButton(
              onPressed: value.uploading
                  ? null
                  : () async {
                      if (provider.formKey.currentState!.validate()) {
                        if (await provider.addCategory(context) &&
                            context.mounted) {
                          Navigator.pop(context);
                          showSuccessSnackBar(
                            context: context,
                            content:
                                'Category "${provider.nameController.text}" added.',
                          );
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
                  : const Text('Add Category'),
            ),
          ),
        ],
      ),
    );
  }
}
