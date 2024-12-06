import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialIconsRow extends StatelessWidget {
  const SocialIconsRow({super.key});

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch $url');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => _launchURL('https://www.instagram.com/wandercrew.in/'),
          child: Image.asset(
            'assets/icons/insta.png', // Path to Instagram icon
            width: 24,
            height: 24,
          ),
        ),
        const SizedBox(width: 12), // Spacing between the icons
        GestureDetector(
          onTap: () => _launchURL('https://www.facebook.com/profile.php?id=61565694202556&mibextid=LQQJ4d'),
          child: Image.asset(
            'assets/icons/fb.png', // Path to Facebook icon
            width: 20,
            height: 20,
          ),
        ),
      ],
    );
  }
}
