import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../home_screen_controller.dart';

class DatePickerPopUp extends StatelessWidget {
  const DatePickerPopUp({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeScreenController>();

    return AlertDialog(
      title: const Text(
        'Select Dates',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Obx(() => TableCalendar(
          focusedDay: controller.startDate.value,
          firstDay: DateTime.now(),
          lastDay: DateTime.now().add(const Duration(days: 365)),
          rangeStartDay: controller.startDate.value,
          rangeEndDay: controller.endDate.value,
          selectedDayPredicate: (day) =>
          day.isAtSameMomentAs(controller.startDate.value) ||
              day.isAtSameMomentAs(controller.endDate.value),
          onDaySelected: (selectedDay, focusedDay) {
            // Logic for selecting start and end dates
            if (controller.startDate.value == controller.endDate.value) {
              // First selection, set start date
              controller.startDate.value = selectedDay;
              controller.endDate.value = selectedDay;
            } else if (selectedDay.isBefore(controller.endDate.value)) {
              // Update the start date
              controller.startDate.value = selectedDay;
            } else {
              // Update the end date
              controller.endDate.value = selectedDay;
            }
          },
          calendarStyle: CalendarStyle(
            rangeHighlightColor: Colors.yellow.withOpacity(0.5),
            rangeStartDecoration: const BoxDecoration(
              color: Colors.yellow,
              shape: BoxShape.circle,
            ),
            rangeEndDecoration: const BoxDecoration(
              color: Colors.yellow,
              shape: BoxShape.circle,
            ),
          ),
        )),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        Obx(() {
          final isConfirmEnabled = controller.startDate.value != controller.endDate.value;
          return TextButton(
            onPressed: isConfirmEnabled ? () => Navigator.pop(context) : null,
            child: const Text('Confirm'),
          );
        }),
      ],
    );
  }
}
