import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class OfferSectionHomepage extends StatelessWidget {
  const OfferSectionHomepage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> images = [
      'assets/images/dorm_1.jpg',
      'assets/images/dorm_2.jpg',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            // Auto-slider for images
            CarouselSlider(
              items: images.map((imagePath) {
                return Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  // height: 600,
                );
              }).toList(),
              options: CarouselOptions(
                autoPlay: true,
                aspectRatio:  440 / 611,
                viewportFraction: 1.0,
                enableInfiniteScroll: true,
              ),
            ),
            // Overlay text
             Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Fall in the ',
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                blurRadius: 5.0,
                                color: Colors.black45,
                                offset: Offset(2.0, 2.0),
                              ),
                            ],
                          ),
                        ),
                        TextSpan(
                          text: 'deal',
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.yellow,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                blurRadius: 5.0,
                                color: Colors.black45,
                                offset: Offset(2.0, 2.0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    textAlign: TextAlign.start,
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Book with code Fall24\nand get ',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 5.0,
                                color: Colors.black45,
                                offset: Offset(2.0, 2.0),
                              ),
                            ],
                          ),
                        ),
                        TextSpan(
                          text: '20% off',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.yellow,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                blurRadius: 5.0,
                                color: Colors.black45,
                                offset: Offset(2.0, 2.0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
