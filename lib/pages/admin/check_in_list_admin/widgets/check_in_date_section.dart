
import 'package:flutter/material.dart';
import 'package:wandercrew/widgets/widget_support.dart';

import '../../../../models/self_checking_model.dart';
import 'expandable_check_in_item.dart';

class CheckInDateSection extends StatelessWidget {
  final String date;
  final List<SelfCheckInModel> checkInAtDate;
  const CheckInDateSection({super.key, required this.date, required this.checkInAtDate});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          date,
          style: AppWidget.red16Text500Style(),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: checkInAtDate.length,
          itemBuilder: (context, index) {
            final checkIn = checkInAtDate[index];
            return ExpandableCheckInItem(checkInItem: checkIn,);
          },
        ),
        const SizedBox(height: 8),

      ],
    );
  }
}
