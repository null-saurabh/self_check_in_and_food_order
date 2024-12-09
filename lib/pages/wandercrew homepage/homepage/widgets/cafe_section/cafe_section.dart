import 'package:flutter/material.dart';

import '../../../../../widgets/custom_text.dart';
import '../../../../../widgets/widget_support.dart';

class CafeSectionHomePage extends StatelessWidget {
  const CafeSectionHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 24),
          child: CustomText(
            text: "Feel the good vibes at the cafe",
            style: AppWidget.black32Text700Style(),
            textAlign: TextAlign.center,
          ),
        ),
        Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/rooftop.png",
              height: 156,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
            // const SizedBox(
            //   height: 6,
            // ),
            Image.asset(
              "assets/images/movie.png",
              height: 156,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
            // const SizedBox(
            //   height: 6,
            // ),
            Image.asset(
              "assets/images/tandoor.png",
              height: 156,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
            // const SizedBox(
            //   height: 6,
            // ),
            Image.asset(
              "assets/images/dj.png",
              height: 156,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          ],
        )
      ],
    );
  }
}

