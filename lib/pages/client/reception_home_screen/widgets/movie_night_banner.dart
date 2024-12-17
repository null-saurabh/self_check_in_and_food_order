import 'package:flutter/material.dart';

class MovieNightBanner extends StatelessWidget {
  const MovieNightBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xff5964ec),
      ),
      child: const Column(
        children: [

          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "🎬 Limited-Time Deal:\n",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                TextSpan(
                  text: "Movie Night Now ",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                TextSpan(
                  text: "₹300", // Price with strikethrough
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent, // Highlight in red
                    decoration: TextDecoration.lineThrough, // Strike-through
                    decorationColor: Colors.redAccent,
                    decorationThickness: 2, // Boldness of strikethrough
                  ),
                ),
                TextSpan(
                  text: " Free!",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.greenAccent, // Highlight 'Free' in green
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),

        ],
      ),
    );
  }
}
