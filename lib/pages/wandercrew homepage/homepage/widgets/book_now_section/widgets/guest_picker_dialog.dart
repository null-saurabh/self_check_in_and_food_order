import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../home_screen_controller.dart';

class GuestsPickerDialog extends StatelessWidget {
  const GuestsPickerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeScreenController>();

    return AlertDialog(
      title: const Text(
        'Select Guests',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() => _GuestSelector(
            label: 'Adults',
            count: controller.adults.value,
            onIncrement: () => controller.adults.value++,
            onDecrement: () {
              if (controller.adults.value > 1) controller.adults.value--;
            },
          )),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}

class _GuestSelector extends StatelessWidget {
  final String label;
  final int count;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _GuestSelector({
    required this.label,
    required this.count,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            IconButton(
              onPressed: onDecrement,
              icon: const Icon(Icons.remove_circle_outline),
            ),
            Text(
              '$count',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            IconButton(
              onPressed: onIncrement,
              icon: const Icon(Icons.add_circle_outline),
            ),
          ],
        ),
      ],
    );
  }
}
