import 'package:flutter/material.dart';
import 'package:flutter_grocery_store_admin/utils/functions/functions.dart';
import 'package:provider/provider.dart';

import '../../controller/screens/add_category_screen_controller.dart';

import '../../utils/global_widgets/add_image_widget.dart';

class AddCategoryScreen extends StatelessWidget {
  const AddCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AddCategoryScreenController provider =
        context.read<AddCategoryScreenController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(provider.categoryModel == null
            ? 'Add New Category'
            : 'Edit Category'),
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
                        imageUrl: value.categoryModel?.imageUrl,
                        onDeletePressed: () => value.deleteImageFile(),
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
                        if (value.categoryModel == null) {
                          if (await provider.addCategory(context) &&
                              context.mounted) {
                            Navigator.pop(context);
                            showSuccessSnackBar(
                              context: context,
                              content:
                                  'Category "${provider.nameController.text}" added.',
                            );
                          }
                        } else if (value.isEdited()) {
                          if (await provider.updateCategory(context) &&
                              context.mounted) {
                            Navigator.pop(context);
                            showSuccessSnackBar(
                              context: context,
                              content:
                                  'Category "${provider.nameController.text}" updated.',
                            );
                          }
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
                  : Text(provider.categoryModel == null
                      ? 'Add Category'
                      : 'Update Category'),
            ),
          ),
        ],
      ),
    );
  }
}
