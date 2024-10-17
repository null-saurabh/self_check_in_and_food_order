import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:wandercrew/widgets/text_view.dart';

import 'app_elevated_button.dart';

class DialogWidget extends StatelessWidget {
  final double? height;
  final double? minHeight;
  final bool addPadding;

  DialogWidget({
    Key? key,
    this.height,
    this.addPadding = true,
    this.minHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(top: addPadding ? MediaQueryData.fromView(View.of(context)).padding.top : 0),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            color: Colors.white,
          ),
          constraints: BoxConstraints(
            minHeight: minHeight ?? 0,
            maxHeight: height ?? MediaQuery.of(context).size.height / 1.2,
          ),
          padding: const EdgeInsets.only(top: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 10,
                    left: 15,
                  ),
                  child: Stack(
                    children: [

                      Align(
                        alignment: Alignment.center,
                        child: TextView(
                          "Are you sure you want to delete?",
                          textAlign: TextAlign.center,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      // if (showClose)
                      //   Align(
                      //     alignment: Alignment.centerLeft,
                      //     child: InkWell(
                      //         onTap: () {
                      //           onCloseClick();
                      //         },
                      //         child: const Icon(
                      //           Icons.arrow_back_ios_new_rounded,
                      //           size: 20,
                      //         )),
                      //   )
                      // else
                      //   const Offstage(),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Divider(
                  color: Color(0x193F526D),
                  height: 0,
                ),
                const SizedBox(
                  height: 10,
                ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextView(
                    "You Won't Be Able To Revert This!",
                    textColor: Colors.black54,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: AppElevatedButton(
                          title: "Yes, Delete It!",
                          height: 40,
                          titleTextSize: 14,
                          borderColor: Colors.transparent,
                          titleTextColor: Colors.white,
                          backgroundColor: const Color(0xFF3085d6),
                          onPressed: () {
                            context.pop(true);
                            // Navigator.pop(context, true);
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: AppElevatedButton(
                          title: "Cancel",
                          height: 40,
                          titleTextSize: 14,
                          titleTextColor: Colors.white,
                          backgroundColor: Colors.black,
                          onPressed: () {
                            context.pop(true);
                            // Navigator.pop(context, false);
                          },
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
