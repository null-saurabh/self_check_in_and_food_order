import 'package:flutter/material.dart';
import '../../../../models/menu_item_model.dart';
import '../../../../widgets/widget_support.dart';
import 'count.dart';

class SingleProduct extends StatelessWidget {
  final MenuItemModel menuItem;
  final bool isCart;
  const SingleProduct({
    super.key,
    this.isCart = false,
    required this.menuItem,
  });

  @override
  Widget build(BuildContext context) {
    // print("Image URL: $productImage");

    return Column(
      children: [
        Container(
          height: isCart ? 124 : 104,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              border:
                  Border.all(color: Colors.grey.withOpacity(0.4)),
              borderRadius: BorderRadius.circular(12)),
          // padding: const EdgeInsets.all(12),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.end,
            children: [
            
              Container(
                width: 10,
                decoration: const BoxDecoration(
                  color: Colors.black, // Yellow left border
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12), // Match outer corner radius
                    bottomLeft: Radius.circular(12), // Match outer corner radius
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          Text(
                            menuItem.name,
                            style: AppWidget.black16Text500Style(),
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
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




                        ],
                      ),
                      const SizedBox(
                        height: 2.0,
                      ),
                      menuItem.description == null
                          ? const SizedBox()
                          : SizedBox(
                          // width: MediaQuery.of(context).size.width / 2,
                          child: Text(
                            menuItem.description!,
                            style: AppWidget.black10Text400Style(),
                          )),
                      // const SizedBox(
                      //   height: 4.0,
                      // ),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '\u{20B9}',
                                  style: AppWidget.black16Text500Style(),
                                ),Text(
                                  ' ${menuItem.price}',
                                  style: AppWidget.black16Text300Style(),
                                ),
                              ],
                            ),
                            // Spacer(),
                            Count(
                              isCart: isCart,
                              menuItem: menuItem,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),


            ],
          ),
        ),
        // if(!isCart)
        const SizedBox(
          height: 12 ,
        )
      ],
    );
  }
}
