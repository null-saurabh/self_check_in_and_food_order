import 'package:flutter/material.dart';

import '../../../../widgets/widget_support.dart';

class UploadDocumentWidget extends StatelessWidget {
  final String title;
  final String? fileName;
  final Function onTap;
  final bool isDocumentInvalid; // Pass the invalid state directly

  const UploadDocumentWidget({
    super.key,
    required this.title,
    required this.fileName,
    required this.onTap,
    required this.isDocumentInvalid,
  });

  @override
  Widget build(BuildContext context) {
    // print("az");
    // print(isDocumentInvalid);
    return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppWidget
                    .textField16Style(), // Replace with your text style
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  onTap(); // Action to trigger when tapped
                },
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.6),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.cloud_upload_sharp,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "Upload",
                        style: AppWidget
                            .textField16Style(), // Replace with your text style
                      )
                    ],
                  ),
                ),
              ),
              if (fileName != null) ...[
                const SizedBox(height: 4),
                Text(
                  "File name: $fileName",
                  style: AppWidget
                      .subHeadingTextStyle(), // Replace with your text style
                ),],
                if (isDocumentInvalid) ...[
                  const SizedBox(height: 4),
                  const Text(
                    "*Required.",
                    style: TextStyle(color: Colors.red),
                  ),
                ],
            ],
          );
  }
}
