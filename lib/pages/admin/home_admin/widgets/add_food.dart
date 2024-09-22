import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wandercrew/widgets/widget_support.dart';
import 'add_food_item_controller.dart';

class AddFoodItem extends StatelessWidget {
  const AddFoodItem({super.key});

  @override
  Widget build(BuildContext context) {
    final AddFoodItemController controller = Get.put(AddFoodItemController());

    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back_ios_new_outlined, color: Color(0xFF373866)),
        //   onPressed: () => Get.back(),
        // ),
        centerTitle: true,
        title: Text("Add Item", style: AppWidget.HeadlineTextFeildStyle()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Upload the Item Picture", style: AppWidget.semiBoldTextFeildStyle()),
            const SizedBox(height: 20.0),
            Obx(() {
              return GestureDetector(
                onTap: controller.pickImage,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1.5),
                    borderRadius: BorderRadius.circular(20),
                    image: controller.selectedImage.value != null
                        ? DecorationImage(
                      image:
                      kIsWeb
                          ? MemoryImage(controller.selectedImage.value as Uint8List) // For web
                          :
                        FileImage(controller.selectedImage.value as File), // For mobile
                      fit: BoxFit.cover,
                    )
                        : null,
                  ),
                  child: controller.selectedImage.value == null
                      ? const Center(
                    child: Icon(Icons.camera_alt_outlined, color: Colors.black),
                  )
                      : null,
                ),
              );
            }),

            const SizedBox(height: 30.0),
            _buildTextField("Item Id", controller.idController),
            const SizedBox(height: 30.0),
            _buildTextField("Item Name", controller.nameController),
            const SizedBox(height: 30.0),
            _buildTextField("Item Price", controller.priceController),
            const SizedBox(height: 30.0),
            _buildTextField("Item Description", controller.descriptionController, maxLines: 6),
            const SizedBox(height: 30.0),
            Text("Select Category", style: AppWidget.semiBoldTextFeildStyle()),
            const SizedBox(height: 10.0),
            Obx(() {
              return DropdownButton<String>(
                value: controller.selectedCategory.value,
                hint: const Text("Select Category"),
                items: controller.categories.map((item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item, style: const TextStyle(fontSize: 18.0, color: Colors.black)),
                  );
                }).toList(),
                onChanged: (value) => controller.selectedCategory.value = value,
              );
            }),
            const SizedBox(height: 30.0),
            Center(
              child: ElevatedButton(
                onPressed: controller.uploadItem,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Add", style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppWidget.semiBoldTextFeildStyle()),
        const SizedBox(height: 10.0),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          decoration: BoxDecoration(
            color: const Color(0xFFececf8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Enter $label",
              hintStyle: AppWidget.LightTextFeildStyle(),
            ),
          ),
        ),
      ],
    );
  }
}
