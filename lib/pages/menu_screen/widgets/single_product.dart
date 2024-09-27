import 'package:flutter/material.dart';
import '../../../models/menu_item_model.dart';
import 'count.dart';
import '../../../widgets/widget_support.dart';

class SingleProduct extends StatelessWidget {
  final MenuItemModel menuItem;
  const SingleProduct({
    super.key,
    required this.menuItem,
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
                  menuItem.image == null
                      ? const SizedBox()
                      : Image.network(
                          menuItem.image!, // Ensure URL is properly encoded
                          fit: BoxFit.cover,
                          width: 65,
                          height: 65,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                                child: CircularProgressIndicator());
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
                              menuItem.name,
                              style: AppWidget.semiBoldTextFeildStyle(),
                            )),
                        const SizedBox(
                          height: 5.0,
                        ),
                        menuItem.description == null
                            ? const SizedBox()
                            : SizedBox(
                                width: MediaQuery.of(context).size.width / 2,
                                child: Text(
                                  menuItem.description!,
                                  style: AppWidget.LightTextFeildStyle(),
                                )),
                        const SizedBox(
                          height: 5.0,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: Text(
                            '\u{20B9}${menuItem.price}',
                            style: AppWidget.semiBoldTextFeildStyle(),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Count(
                          menuItem: menuItem,
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
