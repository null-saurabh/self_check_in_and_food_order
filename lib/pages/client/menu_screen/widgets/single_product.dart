import 'package:flutter/material.dart';
import '../../../../models/menu_item_model.dart';
import '../../../../widgets/widget_support.dart';
import 'count.dart';

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
          margin: const EdgeInsets.only(right: 16.0),
          child: Material(
            // elevation: 5.0,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border:
                      Border.all(width: 1, color: Colors.grey.withOpacity(0.4)),
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // menuItem.image == null
                  //     ? const SizedBox()
                  //     : Image.network(
                  //         menuItem.image!, // Ensure URL is properly encoded
                  //         fit: BoxFit.cover,
                  //         width: 65,
                  //         height: 65,
                  //         loadingBuilder: (context, child, loadingProgress) {
                  //           if (loadingProgress == null) return child;
                  //           return const Center(
                  //               child: CircularProgressIndicator());
                  //         },
                  //       ),
                  // const SizedBox(
                  //   width: 20.0,
                  // ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        menuItem.isVeg
                            ? Image.asset(
                                "assets/icons/veg_icon.png",
                                height: 16,
                                width: 16,
                              )
                            : Image.asset(
                                "assets/icons/non_veg_icon.png",
                                height: 16,
                                width: 16,
                              ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Text(
                          menuItem.name,
                          style: AppWidget.black16Text400Style(),
                        ),
                        // const SizedBox(
                        //   height: 2.0,
                        // ),
                        // menuItem.description == null
                        //     ? const SizedBox()
                        //     : SizedBox(
                        //         width: MediaQuery.of(context).size.width / 2,
                        //         child: Text(
                        //           menuItem.description!,
                        //           style: AppWidget.light16TextStyle(),
                        //         )),
                        // const SizedBox(
                        //   height: 5.0,
                        // ),
                        Text(
                          '\u{20B9}${menuItem.price}',
                          style: AppWidget.black14Text300Style(),
                        ),
                      ],
                    ),
                  ),
                  Count(
                    menuItem: menuItem,
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
