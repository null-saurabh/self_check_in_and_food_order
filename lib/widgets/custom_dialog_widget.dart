// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wandercrew/widgets/text_view.dart';

class CustomDialogWidget extends StatelessWidget {
  final String dialogTitle;
  final double? height;
  final double? minHeight;
  final Widget child;
  final bool showClose;
  final bool addPadding;
  final VoidCallback? onCloseClick;

  const CustomDialogWidget({
    super.key,
    required this.dialogTitle,
    this.height,
    this.addPadding = true,
    required this.child,
    this.showClose = false,
    this.onCloseClick,
    this.minHeight,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(top: addPadding ? MediaQueryData.fromView(View.of(context)).padding.top : 0),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
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
              maxHeight: height ?? Get.height / 1.2,
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
                            dialogTitle,
                            textAlign: TextAlign.center,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        if (showClose)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: InkWell(
                                onTap: () {
                                  onCloseClick!();
                                },
                                child: const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  size: 20,
                                )),
                          )
                        else
                          const Offstage(),
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
                  child,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
