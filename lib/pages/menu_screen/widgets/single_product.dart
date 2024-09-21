import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'count.dart';
import '../../../widgets/widget_support.dart';


class SingleProduct extends StatelessWidget {
  final String productImage;
  final String productName;
  final String productPrice;
  final String productId;
  const SingleProduct({super.key,required this.productId,
      required this.productImage,
      required this.productName,
      required this.productPrice
      });

  @override
  Widget build(BuildContext context) {
    // print("Image URL: $productImage");

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 20.0),
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // HtmlElementView(viewType: 'image-view'),
                  // CachedNetworkImage(imageUrl: productImage),
                  Image.network(
                    productImage, // Ensure URL is properly encoded
                    fit: BoxFit.cover,
                    width: 65,
                    height: 65,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Text(
                              productName,
                              style: AppWidget.semiBoldTextFeildStyle(),
                            )),
                        const SizedBox(
                          height: 5.0,
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Text(
                              "Honey got cheese",
                              style: AppWidget.LightTextFeildStyle(),
                            )),
                        const SizedBox(
                          height: 5.0,
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Text(
                              "\$ $productPrice",
                              style: AppWidget.semiBoldTextFeildStyle(),
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        Count(
                          productId: productId,
                          productImage: productImage,
                          productName: productName,
                          productPrice: productPrice,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }
}

