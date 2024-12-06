import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:wandercrew/pages/admin/check_in_list_admin/check_in_list_controller.dart';
import 'package:wandercrew/utils/date_time.dart';
import 'package:wandercrew/widgets/app_elevated_button.dart';
import 'package:wandercrew/widgets/widget_support.dart';
import '../../../../models/self_checking_model.dart';

class ExpandableCheckInItem extends StatelessWidget {
  final SelfCheckInModel checkInItem;
  const ExpandableCheckInItem({super.key, required this.checkInItem});

  @override
  Widget build(BuildContext context) {
    final CheckInListController controller = Get.find<CheckInListController>();

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            border: Border.all(color: Colors.black.withOpacity(0.12)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 0.1,
                blurRadius: 8,
              ),
            ],
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              dividerColor:
                  Colors.transparent, // Removes the border between expanded items
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ExpansionTile(
                maintainState: true,
                showTrailingIcon: false,
                // backgroundColor: Colors.white,
                // collapsedBackgroundColor: Colors.white,
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          checkInItem.fullName,
                          style: AppWidget.black16Text600Style(),
                        ),
                        GestureDetector(
                                onTap: () {
                                  controller.downloadCheckInAsPdf(context,checkInItem);
                                },
                                child: const Icon(
                                  Icons.download,
                                  color: Colors.green,
                                ),
                              ),
                      ],
                    ),
                    SizedBox(height: 8,),
                    // Text('${checkInItem.age}, ${checkInItem.gender}',
                    //     style: AppWidget.black16Text500Style()),
                    Row(
                      children: [
                        Text(
                          "Contact: ",
                          style: AppWidget.black14Text600Style(),
                        ),
                        Text(
                          checkInItem.contact,
                          style: AppWidget.black14Text400Style(),
                        ),
                        SizedBox(width: 4,),
                        GestureDetector(
                          onTap: (){
                            controller.makePhoneCall(checkInItem.contact);
                          },
                          child: Icon(Icons.call,color: Colors.green,size: 20,),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Check-In Time: ",
                          style: AppWidget.black14Text600Style(),
                        ),
                        Text(
                          DateTimeUtils.format12Hour(checkInItem.createdAt!),
                          style: AppWidget.black14Text400Style(),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Document Type: ",
                          style: AppWidget.black14Text600Style(),
                        ),
                        Text(
                          checkInItem.documentType,
                          style: AppWidget.black14Text400Style(),
                        ),
                      ],
                    ),
                      if(checkInItem.notes != null) ...[
                    SizedBox(height: 4,),
                    Row(
                      children: [
                        Text(
                          "Note: ",
                          style: AppWidget.black14Text600Style(),
                        ),
                        Text(
                          checkInItem.notes!,
                          style: AppWidget.black14Text400Style(color: Colors.red),
                        ),
                        SizedBox(width: 4,),
                        GestureDetector(
                          onTap: (){
                            controller.addNote(context,checkInItem);
                          },
                          child: Icon(Icons.edit,size: 20,),
                        ),
                        SizedBox(width: 4,),
                        GestureDetector(
                          onTap: (){
                            controller.deleteNote(context,checkInItem);
                          },
                          child: Icon(Icons.delete,color: Colors.red,size: 20,),
                        ),

                      ],
                    ),],
                    SizedBox(height: 8,),

                    Row(
                      children: [
                        if(checkInItem.notes == null) ...[
                        AppElevatedButton(
                          contentPadding: EdgeInsets.all(8),
                          onPressed: (){
                            controller.addNote(context,checkInItem);
                          },
                          backgroundColor: Colors.transparent,
                          showBorder: true,
                          child: Text("Add Note +",style: TextStyle(color: Colors.black),),
                        ),
                        SizedBox(width: 8,),],
                        AppElevatedButton(
                          // onPressed: (){},
                          disableColor: Colors.black,
                          child: Text("View",style: TextStyle(color: Colors.white),),
                        ),
                      ],
                    )



                  ],
                ),

                children: [
                  _buildInfoRow('Age', checkInItem.age),
                  _buildInfoRow('Gender', checkInItem.gender),
                  _buildInfoRow('Email', checkInItem.email),
                  // _buildInfoRow('City', checkInItem.city),
                  // _buildInfoRow('State', checkInItem.regionState),
                  _buildInfoRow('Country', checkInItem.country),
                  // _buildInfoRow('Address', checkInItem.address),
                  _buildInfoRow('Arriving From', checkInItem.arrivingFrom),
                  _buildInfoRow('Going To', checkInItem.goingTo),
                  _buildInfoRow('Document Type', checkInItem.documentType),
                  // controller.downloadFile(checkInItem.frontDocumentUrl)
                  _buildDocumentSection(
                      'Front Document', checkInItem.frontDocumentUrl, () {
                    controller.downloadFile(
                      context: context,
                        imageUrl: checkInItem.frontDocumentUrl,
                        fileName:
                            '${checkInItem.fullName}_${checkInItem.documentType}_front.jpg');
                  }),
                  if(checkInItem.backDocumentUrl != null)
                  _buildDocumentSection(
                      'Back Document', checkInItem.backDocumentUrl!, () {
                    controller.downloadFile(
                        context: context,

                        imageUrl: checkInItem.backDocumentUrl!,
                        fileName:
                            '${checkInItem.fullName}_${checkInItem.documentType}_back.jpg');
                  }),
                  _buildSignatureSection(checkInItem.signatureUrl, () {
                    controller.downloadFile(
                        context: context,
                        imageUrl: checkInItem.signatureUrl,
                        fileName: '${checkInItem.fullName}_signature.jpg');
                  }),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),

      ],
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: AppWidget.black14Text600Style(),
          ),
          Expanded(
            child: Text(value ?? "", style: AppWidget.black14Text400Style()),
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
          GestureDetector(
            onTap: onPressed,
            child: const Icon(
              Icons.download_outlined,
              color: Colors.green,
            ),
          ),
          const SizedBox(width: 4),
          Image.network(
            documentUrl,
            height: 100,
            fit: BoxFit.cover,
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
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onPressed,
            child: const Icon(
              Icons.download_outlined,
              color: Colors.green,
            ),
          ),
          const SizedBox(width: 4),

          Image.network(
            signatureUrl,
            height: 100,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
