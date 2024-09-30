import 'package:flutter/material.dart';
// import 'package:wandercrew/widgets/widget_support.dart';

class FormButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String name;

  const FormButton({
    super.key,
    required this.onPressed,
    required this.name
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 44,  // Set your desired height
        width: 108,  // Set to full width or a specific width
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/textures/button_texture.png'),  // Background image from assets
            fit: BoxFit.cover,  // Adjust the background to cover the whole button
          ),
          borderRadius: BorderRadius.circular(30),  // Rounded corners
        ),
        // child: Center(
        //   child: Text(
        //     name,
        //     style:AppWidget.whiteBold16TextStyle(),
        //   ),
        // ),
      ),
    );
  }
}
