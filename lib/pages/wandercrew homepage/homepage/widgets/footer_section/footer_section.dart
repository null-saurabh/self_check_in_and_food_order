import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wandercrew/pages/wandercrew%20homepage/homepage/widgets/footer_section/social_media_icon_row.dart';

import '../../../../../utils/routes.dart';
import '../../../../../widgets/custom_text.dart';
import '../../../../../widgets/widget_support.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff333333),
      padding: const EdgeInsets.only(top: 75,bottom: 75,left: 28,right: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomText(text: "About Us",
            style: AppWidget.white16Text600Style(),
            onTap: () {
              context.go(Routes.aboutUs); // Replace with your actual route
            },
          ),
          CustomText(text: "Contact Us",
            style: AppWidget.white16Text400Style(),
            onTap: () {
              context.go(Routes.contactUs); // Replace with your actual route
            },
          ),
          CustomText(text: "Term and Conditions",
            style: AppWidget.white16Text400Style(),
            onTap: () {
              context.go(Routes.termAndCondition); // Replace with your actual route
            },
          ),
          CustomText(text: "Privacy Policy",
            style: AppWidget.white16Text400Style(),
            onTap: () {
              context.go(Routes.privacyPolicy); // Replace with your actual route
            },
          ),

          CustomText(text: "FAQ",
            style: AppWidget.white16Text400Style(),),
          const SizedBox(height: 12,),
          CustomText(text: "Follow us",
            style: AppWidget.white16Text600Style(),),
          const SocialIconsRow()


        ],
      ),
    );
  }
}
