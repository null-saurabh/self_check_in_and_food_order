import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import '../../../models/self_checking_model.dart';
import '../../../utils/date_time.dart';
import 'dart:io' as io;
import 'package:http/http.dart' as http;
import 'dart:html' as html;
import 'package:pdf/widgets.dart' as pw;

class CheckInListController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    fetchCheckInList(); // Fetch data when controller is initialized
  }

  RxList<SelfCheckInModel> checkInList =
      <SelfCheckInModel>[].obs; // Using observable list
  RxMap<String, List<SelfCheckInModel>> groupedCheckIns =
      <String, List<SelfCheckInModel>>{}.obs;

  Future<void> fetchCheckInList() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection("Self_Check_In").get();

      // Mapping Fire store data to model and updating observable list
      List<SelfCheckInModel> newList = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        return SelfCheckInModel.fromMap(
            data); // Using fromMap factory constructor
      }).toList();
      // print(newList);

      // Updating observable list
      checkInList.assignAll(newList);
      groupCheckInsByDate();
      update();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch list $e');
      // print(e);
    }
  }

  void groupCheckInsByDate() {
    Map<String, List<SelfCheckInModel>> groupedData = {};
    for (var checkIn in checkInList) {
      // Formatting DateTime to a string date
      String formattedDate =
          DateTimeUtils.formatDDMMYYYYWithSlashes(checkIn.createdAt!);
      if (!groupedData.containsKey(formattedDate)) {
        groupedData[formattedDate] = [];
      }
      groupedData[formattedDate]!.add(checkIn);
    }
    groupedCheckIns.assignAll(groupedData);
    update();
  }

  // Function to download an image (works for both Android and Web)
  void downloadFile({required String imageUrl, required String fileName}) async {
    if (kIsWeb) {
      // For Web
      downloadFileWeb(imageUrl,fileName);
    } else {
      // For Android
      await downloadFileAndroid(imageUrl, fileName);
    }
  }



  static Future<void> downloadFileWeb(String imageUrl,String imageName) async {
    try {
      // Fetch the image data from the URL
      final http.Response response = await http.get(Uri.parse(imageUrl));

      // Check if the response is successful
      if (response.statusCode == 200) {
        // Convert the image data to Base64 and create a Blob
        final blob = html.Blob([response.bodyBytes]);

        // Create an Object URL for the Blob
        final url = html.Url.createObjectUrlFromBlob(blob);

        // Create an anchor element and trigger the download
        final html.AnchorElement anchorElement = html.AnchorElement(href: url)
          ..setAttribute('download',
              imageName) // Use a default filename or modify accordingly
          ..click();

        // Revoke the Object URL to free memory
        html.Url.revokeObjectUrl(url);
      } else {
        debugPrint("Failed to download image: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error downloading image: $e");
    }
  }

  // Function for Android download
  static Future<void> downloadFileAndroid(
      String imageUrl, String fileName) async {
    try {
      // Get directory to save the file
      var directory = await getExternalStorageDirectory();
      String savePath = '${directory!.path}/$fileName';

      // Download the file using Dio
      Dio dio = Dio();
      await dio.download(imageUrl, savePath);

      // Notify user that the download is successful
      // print("File downloaded at $savePath");
    } catch (e) {
      // print("Error downloading file: $e");
    }
  }

  // Get the external storage directory for Android
  static Future<io.Directory?> getExternalStorageDirectory() async {
    io.Directory? directory = await getApplicationDocumentsDirectory();
    return directory;
  }












// Function to download the PDF
  Future<void> downloadCheckInAsPdf(SelfCheckInModel checkInItem) async {
    final pdf = pw.Document();

    // Fetch images first
    final frontImage = await _fetchImage(checkInItem.frontDocumentUrl);
    final backImage = await _fetchImage(checkInItem.backDocumentUrl);
    final signatureImage = await _fetchImage(checkInItem.signatureUrl);

    // Add a page with text and images
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Check-In Details',
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            _buildInfoRow('Full Name', checkInItem.fullName),
            _buildInfoRow('Document Type', checkInItem.documentType),
            _buildInfoRow('Contact', checkInItem.contact),
            _buildInfoRow('Age', checkInItem.age.toString()),
            _buildInfoRow('Gender', checkInItem.gender),
            _buildInfoRow('Country', checkInItem.country),
            _buildInfoRow('State', checkInItem.regionState),
            if (checkInItem.email != null)
              _buildInfoRow('Email', checkInItem.email!),
            if (checkInItem.address != null)
              _buildInfoRow('Address', checkInItem.address!),
            if (checkInItem.city != null)
              _buildInfoRow('City', checkInItem.city!),
            if (checkInItem.arrivingFrom != null)
              _buildInfoRow('Arriving From', checkInItem.arrivingFrom!),
            if (checkInItem.goingTo != null)
              _buildInfoRow('Going To', checkInItem.goingTo!),
            pw.SizedBox(height: 10),
            pw.Text('Documents',
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Image(frontImage, height: 150, width: 150, fit: pw.BoxFit.cover),
            pw.SizedBox(height: 10),
            pw.Image(backImage, height: 150, width: 150, fit: pw.BoxFit.cover),
            pw.SizedBox(height: 10),
            pw.Image(signatureImage, height: 150, width: 150, fit: pw.BoxFit.cover),
          ],
        ),
      ),
    );

    // Generate the PDF as bytes and save it
    await _savePdf(pdf,"${checkInItem.fullName} Check In Details.pdf");
  }

// Helper function to fetch images from URL
  static Future<pw.ImageProvider> _fetchImage(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      return pw.MemoryImage(bytes);
    } else {
      throw Exception('Failed to load image');
    }
  }

  // Helper function to build a text row for info
  static pw.Widget _buildInfoRow(String label, String value) {
    return pw.Row(
      children: [
        pw.Text('$label: ',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Text(value),
      ],
    );
  }




  // Function to save and download the PDF file
  static Future<void> _savePdf(pw.Document pdf,String fileName) async {
    // For Web
    if (kIsWeb) {
      final pdfBytes = await pdf.save();
      final blob = html.Blob([pdfBytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final html.AnchorElement anchorElement = html.AnchorElement(href: url)
        ..setAttribute('download', fileName)
        ..click();
      html.Url.revokeObjectUrl(url);
      // await Printing.sharePdf(bytes: pdfBytes, filename: 'checkin_details.pdf');
    } else {
      // For Mobile (Android/iOS)
      final pdfBytes = await pdf.save();
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/checkin_details.pdf');
      await file.writeAsBytes(pdfBytes);
      await Printing.sharePdf(bytes: pdfBytes, filename: 'checkin_details.pdf');
    }
  }
}
