import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/self_checking_model.dart';
import 'check_in_list_controller.dart';

class CheckInListAdmin extends StatelessWidget {
  const CheckInListAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckInListController>(
      init: CheckInListController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Self Check-In List'),
            backgroundColor: Colors.deepPurple,
          ),
          body: controller.checkInList.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.builder(
              itemCount: controller.checkInList.length,
              itemBuilder: (context, index) {
                SelfCheckInModel checkIn = controller.checkInList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          checkIn.fullName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildInfoRow('Document Type', checkIn.documentType),
                        _buildInfoRow('Contact', checkIn.contact),
                        _buildInfoRow('Name', checkIn.fullName),
                        _buildInfoRow('Age', checkIn.age),
                        _buildInfoRow('Gender', checkIn.gender),
                        _buildInfoRow('Country', checkIn.country),
                        _buildInfoRow('State', checkIn.regionState),
                        if (checkIn.email != null && checkIn.email!.isNotEmpty)
                          _buildInfoRow('Email', checkIn.email!),
                        if (checkIn.address != null && checkIn.address!.isNotEmpty)
                          _buildInfoRow('Address', checkIn.address!),
                        if (checkIn.city != null && checkIn.city!.isNotEmpty)
                          _buildInfoRow('City', checkIn.city!),
                        if (checkIn.arrivingFrom != null && checkIn.arrivingFrom!.isNotEmpty)
                          _buildInfoRow('Arriving From', checkIn.arrivingFrom!),
                        if (checkIn.goingTo != null && checkIn.goingTo!.isNotEmpty)
                          _buildInfoRow('Going To', checkIn.goingTo!),
                        const SizedBox(height: 10),
                        _buildDocumentSection('Front Document', checkIn.frontDocumentUrl),
                        _buildDocumentSection('Back Document', checkIn.backDocumentUrl),
                        const SizedBox(height: 10),
                        _buildSignatureSection(checkIn.signatureUrl),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentSection(String label, String documentUrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 5),
        Image.network(
          documentUrl,
          height: 150,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ],
    );
  }

  Widget _buildSignatureSection(String signatureUrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Signature:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 5),
        Image.network(
          signatureUrl,
          height: 100,
          width: double.infinity,
          fit: BoxFit.contain,
        ),
      ],
    );
  }
}
