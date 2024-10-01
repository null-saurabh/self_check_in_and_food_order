import 'package:flutter/material.dart';
// import 'package:get/get_common/get_reset.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:wandercrew/pages/admin/check_in_list_admin/check_in_list_controller.dart';
// import 'package:wandercrew/pages/client/self_checking_screen/check_in_controller.dart';
import 'package:wandercrew/utils/date_time.dart';
import 'package:wandercrew/widgets/widget_support.dart';
import '../../../../models/self_checking_model.dart';

class ExpandableCheckInItem extends StatelessWidget {
  final SelfCheckInModel checkInItem;
  const ExpandableCheckInItem({super.key, required this.checkInItem});

  @override
  Widget build(BuildContext context) {
    final CheckInListController controller = Get.find<CheckInListController>();

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: ExpansionTile(
            backgroundColor: Colors.white,
            collapsedBackgroundColor: Colors.white,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  checkInItem.fullName,
                  style: AppWidget.whiteBold16TextStyle(),
                ),
                Text(' (${checkInItem.age}, ${checkInItem.gender})',
                    style: AppWidget.black14Text400Style()),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.access_time_filled,
                  color: Colors.green,
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  DateTimeUtils.format12Hour(checkInItem.createdAt!),
                  style: AppWidget.black14Text400Style(),
                ),
                const Icon(
                  Icons.navigate_next_outlined,
                  color: Colors.grey,
                ),
              ],
            ),
            showTrailingIcon: true,
            // subtitle: Text('Check-in time: ${checkInItem.createdAt}'),
            children: [
              TextButton(
                  onPressed: () {
                    controller.downloadCheckInAsPdf(checkInItem);
                  },
                  child: Text("Download")),
              _buildInfoRow('Contact', checkInItem.contact),
              _buildInfoRow('Email', checkInItem.email),
              _buildInfoRow('Age', checkInItem.age),
              _buildInfoRow('Gender', checkInItem.gender),
              _buildInfoRow('City', checkInItem.city),
              _buildInfoRow('State', checkInItem.regionState),
              _buildInfoRow('Country', checkInItem.country),
              _buildInfoRow('Address', checkInItem.address),
              _buildInfoRow('Arriving From', checkInItem.arrivingFrom),
              _buildInfoRow('Going To', checkInItem.goingTo),
              _buildInfoRow('Document Type', checkInItem.documentType),
              // controller.downloadFile(checkInItem.frontDocumentUrl)
              _buildDocumentSection(
                  'Front Document', checkInItem.frontDocumentUrl, () {
                controller.downloadFile(
                    imageUrl: checkInItem.frontDocumentUrl, fileName: '${checkInItem.fullName}_${checkInItem.documentType}_front.jpg');
              }),
              _buildDocumentSection(
                  'Back Document', checkInItem.backDocumentUrl, () {
                controller.downloadFile(imageUrl: checkInItem.backDocumentUrl, fileName: '${checkInItem.fullName}_${checkInItem.documentType}_back.jpg');
              }),
              _buildSignatureSection(checkInItem.signatureUrl,() {
                controller.downloadFile(imageUrl: checkInItem.signatureUrl, fileName: '${checkInItem.fullName}_signature.jpg');
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: AppWidget.whiteBold16TextStyle(),
          ),
          Expanded(
            child: Text(value ?? "", style: AppWidget.black16Text400Style()),
          ),
        ],
      ),
    );
  }

  // Widget _buildOptionalInfo(String label, String? value) {
  //   if (value == null || value.isEmpty) return const SizedBox.shrink();
  //   return _buildInfoRow(label, value);,
  // }

  Widget _buildDocumentSection(
      String label, String documentUrl, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label:', style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 4),
          Image.network(
            documentUrl,
            height: 100,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 4),
          ElevatedButton(
            onPressed: onPressed,
            child: const Text('Download'),
          ),
        ],
      ),
    );
  }

  Widget _buildSignatureSection(String signatureUrl, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Signature:',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Image.network(
            signatureUrl,
            height: 100,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 4),
          ElevatedButton(
            onPressed: onPressed,
            child: const Text('Download'),
          ),
        ],
      ),
    );
  }
}
