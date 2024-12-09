import 'package:flutter/material.dart';

import '../../../../../widgets/custom_text.dart';
import '../../../../../widgets/widget_support.dart';

class LastSectionHomepage extends StatelessWidget {
  const LastSectionHomepage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24),
      child: Column(
        children: [
          CustomText(
            text: "Follow Us and don't miss anything!",
            style: AppWidget.black32Text700Style(),
            textAlign: TextAlign.center,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                  child: Image.asset(
                "assets/images/paragliding.png",
                height: 172,
                width: 176,
                fit: BoxFit.contain,
              )),
              const SizedBox(
                width: 12,
              ),
              Flexible(
                  child: Image.asset("assets/images/river.png",
                      height: 172, width: 176, fit: BoxFit.contain)),
            ],
          )
        ],
      ),
    );
  }
}
