import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:wandercrew/pages/wandercrew%20homepage/widgets/book_now_section/widgets/custom_info_widget.dart';
import 'package:wandercrew/pages/wandercrew%20homepage/widgets/book_now_section/widgets/date_picker_dialog.dart';
import 'package:wandercrew/pages/wandercrew%20homepage/widgets/book_now_section/widgets/guest_picker_dialog.dart';

import '../../home_screen_controller.dart';

class BookNowSectionHomePage extends StatelessWidget {
  final HomeScreenController controller = Get.put(HomeScreenController());

  BookNowSectionHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.yellow, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Dates Section
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const DatePickerPopUp();
                        },
                      );
                    },
                    child: Obx(() => CustomInfoWidget(
                          icon: Icons.calendar_today,
                          title: 'Dates',
                          subtitle:
                              '${_formatDate(controller.startDate.value)} - ${_formatDate(controller.endDate.value)}',
                        )),
                  ),
                  // Divider
                  Container(
                    height: 40,
                    width: 1,
                    color: Colors.grey[400],
                  ),
                  // Guests Section
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const GuestsPickerDialog();
                        },
                      );
                    },
                    child: Obx(() => CustomInfoWidget(
                          icon: Icons.group,
                          title: 'Guests',
                          subtitle: '${controller.adults.value}',
                        )),
                  ),
                ],
              ),
            ),
            // Book Now Button
            GestureDetector(
              onTap: () {
                // Add action for "Book Now"
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    'Book Now',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat("d MMM").format(date);
  }

}











