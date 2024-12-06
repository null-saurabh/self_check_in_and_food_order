import 'package:flutter/material.dart';

import '../../../../widgets/custom_text.dart';
import '../../../../widgets/widget_support.dart';

class WhyWandercrewSectionHomepage extends StatelessWidget {
  const WhyWandercrewSectionHomepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24),
      child: Column(
        children: [
          CustomText(
            text: "Why Wander Crew?",
            style: AppWidget.black32Text700Style(),
            textAlign: TextAlign.center,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                  child: Image.asset(
                    "assets/images/dorm.png",
                    height: 172,
                    width: 176,
                    fit: BoxFit.contain,
                  )),
              const SizedBox(
                width: 12,
              ),
              Flexible(
                  child: Image.asset("assets/images/room.png",
                      height: 172, width: 176, fit: BoxFit.contain)),
            ],
          ),
          SizedBox(height: 6,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                  child: Image.asset(
                    "assets/images/garden.png",
                    height: 172,
                    width: 176,
                    fit: BoxFit.contain,
                  )),
              const SizedBox(
                width: 12,
              ),
              Flexible(
                  child: Image.asset("assets/images/movie_night.png",
                      height: 172, width: 176, fit: BoxFit.contain)),
            ],
          ),
          SizedBox(height: 6,),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                  child: Image.asset(
                    "assets/images/rohtang.png",
                    height: 172,
                    width: 176,
                    fit: BoxFit.contain,
                  )),
              const SizedBox(
                width: 12,
              ),
              Flexible(
                  child: Image.asset("assets/images/sunset.png",
                      height: 172, width: 176, fit: BoxFit.contain)),
            ],
          )
        ],
      ),
    );
  }
}
