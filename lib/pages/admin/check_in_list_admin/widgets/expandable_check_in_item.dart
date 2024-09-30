import 'package:flutter/material.dart';

import '../../../../models/self_checking_model.dart';

class ExpandableCheckInItem extends StatelessWidget {
  final SelfCheckInModel checkInItem;
  const ExpandableCheckInItem({super.key, required this.checkInItem});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Material(
        elevation: 5,

        child: ExpansionTile(
          backgroundColor: Colors.white,
          collapsedBackgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(checkInItem.fullName),
              Text('${checkInItem.gender} / ${checkInItem.age}'),
            ],
          ),
          subtitle: Text('Check-in time: ${checkInItem.createdAt}'),
          children: [
            _buildInfoRow('Document Type', checkInItem.documentType),
            _buildInfoRow('Contact', checkInItem.contact),
            _buildInfoRow('Country', checkInItem.country),
            _buildInfoRow('State', checkInItem.regionState),
            _buildOptionalInfo('Email', checkInItem.email),
            _buildOptionalInfo('Address', checkInItem.address),
            _buildOptionalInfo('City', checkInItem.city),
            _buildOptionalInfo('Arriving From', checkInItem.arrivingFrom),
            _buildOptionalInfo('Going To', checkInItem.goingTo),
            _buildDocumentSection('Front Document', checkInItem.frontDocumentUrl),
            _buildDocumentSection('Back Document', checkInItem.backDocumentUrl),
            _buildSignatureSection(checkInItem.signatureUrl),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionalInfo(String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();
    return _buildInfoRow(label, value);
  }

  Widget _buildDocumentSection(String label, String documentUrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label:', style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Image.network(
          documentUrl,
          height: 150,
          fit: BoxFit.cover,
        ),
        const SizedBox(height: 5),
        ElevatedButton(
          onPressed: () {
            // Logic to download the document
          },
          child: const Text('Download'),
        ),
      ],
    );
  }

  Widget _buildSignatureSection(String signatureUrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Signature:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Image.network(
          signatureUrl,
          height: 100,
          fit: BoxFit.contain,
        ),
      ],
    );
  }
}
