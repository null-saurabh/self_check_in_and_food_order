import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';
import '../../models/self_checking_model.dart';
import '../../service/database.dart';
import '../../widgets/bottom_nav.dart';


class SelfCheckInController extends GetxController {


  @override
  void onInit() {
    super.onInit();
    fetchCountries();
    fetchCountryCodes(); // Fetch countries from API when controller is initialized
  }


  final GlobalKey<FormState> formKeyPage1 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyPage2 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyPage3 = GlobalKey<FormState>();

  // Page 1
  var documentIssueCountry = Rx<Map<String, String>?>(null);
  var documentType = RxnString();
  Rxn<dynamic> frontDocument = Rxn<dynamic>();
  // var frontDocument = Rxn<File>();
  var frontDocumentName = Rxn<String>();
  Rxn<dynamic> backDocument = Rxn<dynamic>();
  // var backDocument = Rxn<File>();
  var backDocumentName = Rxn<String>();
  var termsAccepted = false.obs;
  var propertyTermsAccepted = false.obs;

  // Country List
  // RxList<String> countries = <String>[].obs;
  RxList<Map<String, String>> countries = <Map<String, String>>[].obs;
  // Image picker
  final ImagePicker _picker = ImagePicker();

  Future<void> fetchCountries() async {
    try {
      final response = await http.get(Uri.parse('http://api.geonames.org/countryInfoJSON?username=wandercrew'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['geonames'];
        countries.value = data.map((country) {
          return {
            'name': country['countryName'] as String,
            'code': country['geonameId'].toString(),
          };
        }).toList();
        countries.sort((a, b) => (a['name'] ?? '').compareTo(b['name'] ?? ''));// Sort countries alphabetically
        selectedCountry.value = countries.firstWhere(
              (country) => country['name'] == 'India',
          orElse: () => countries.first,
        );
        fetchStates(selectedCountry.value!['code']!);
        documentIssueCountry.value = selectedCountry.value;

      } else {
        // print("AAA");
        print(response.body);

        // Get.snackbar("Error", "Failed to fetch country list");
      }
    } catch (e) {
      // Get.snackbar("Error", "Unable to fetch countries. Please check your internet connection.");
    }
  }

  // Pick document from gallery (Front or Back)
  Future<void> pickDocument(bool isFront) async {
    try {
      if (kIsWeb){
        final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          if (isFront) {
            frontDocumentName.value =
                pickedFile.name; // Assign the file name to display
            final imageBytes = await pickedFile.readAsBytes();
            frontDocument.value =
                imageBytes;
          }
          else {
            final imageBytes = await pickedFile.readAsBytes();

            backDocument.value = imageBytes;   // Assign the file name to display
            backDocumentName.value = pickedFile.name;
          }
        }
      }
      else {
        final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          if (isFront) {
            frontDocument.value =
                File(pickedFile.path);
            frontDocumentName.value =
                pickedFile.name;
          }
          else {
            backDocument.value = File(pickedFile.path);   // Assign the file name to display
            backDocumentName.value = pickedFile.name;
          }
        }
      }

        // update();
      }
     catch (e) {
      Get.snackbar("Error", "Failed to pick image");
    }
  }






  // Page 2
  TextEditingController fullName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController city = TextEditingController();

  var gender = ''.obs;
  var country = 'India'.obs;
  var regionState = ''.obs;

  RxList<String> states = <String>[].obs;

  RxList<Map<String, String>> countryCodes = <Map<String, String>>[].obs;
  var selectedCountry = Rx<Map<String, String>?>(null);
  var selectedCountryCode = '+91'.obs;  // Default to India
  // var selectedCountryCode = RxnString();


  // Fetch country codes (with flags) from API
  Future<void> fetchCountryCodes() async {
    try {
      final response = await http.get(Uri.parse('https://restcountries.com/v3.1/all'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        countryCodes.value = data.map((country) {
          final root = country['idd']?['root']?.toString() ?? '';
          final suffix = (country['idd']?['suffixes'] is List && country['idd']?['suffixes']?.isNotEmpty == true)
              ? country['idd']['suffixes'][0].toString()
              : '';
          return {
            'name': country['name']['common']?.toString() ?? '',
            'code': (root + suffix).isNotEmpty ? root + suffix : '',  // Ensure root+suffix is combined correctly
            'flag': country['flags']?['png']?.toString() ?? '',  // Safely access the flag URL
          };
        }).where((code) => code['code'] != null && code['code']!.isNotEmpty).toList().cast<Map<String, String>>();  // Filter invalid entries and cast correctly
      } else {
        Get.snackbar("Error", "Failed to fetch country codes");
      }
    } catch (e) {
      Get.snackbar("Error", "Unable to fetch country codes. Please check your internet connection.");
    }
  }


  // Fetch state list based on selected country
  Future<void> fetchStates(String countryCode) async {
    try {
      final response = await http.get(Uri.parse('http://api.geonames.org/childrenJSON?geonameId=$countryCode&username=wandercrew'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['geonames'];
        states.value = data.map((state) => state['name'].toString()).toList();
        states.sort();  // Sort states alphabetically
      } else {
        Get.snackbar("Error", "Failed to fetch states");
      }
    } catch (e) {
      Get.snackbar("Error", "Unable to fetch states. Please check your internet connection.");
    }
  }















  // Page 3
  TextEditingController arrivingFromController = TextEditingController();
  TextEditingController goingToController = TextEditingController();
  final SignatureController signatureController = SignatureController(penStrokeWidth: 5, penColor: Colors.black);


  bool isSignatureEmpty() {
    return signatureController.isEmpty;
  }

  final FirebaseStorage storage = FirebaseStorage.instance;

  // Upload a document (Front/Back) and return the URL
  Future<String?> uploadDocument(var document, String fileName) async {
    try {
      Reference ref = storage.ref().child("documents").child(fileName);

      SettableMetadata metadata = SettableMetadata(contentType: 'image/jpeg');
      UploadTask task;
      if (kIsWeb) {
        // For web, use putData() since selectedImage.value is Uint8List
        task = ref.putData(document as Uint8List, metadata);
      } else {
        // For mobile, use putFile() since selectedImage.value is File
        task = ref.putFile(document as File);
      }

      // UploadTask uploadTask = ref.putFile(document);

      TaskSnapshot taskSnapshot = await task;
      // var downloadUrl = await (await uploadTask).ref.getDownloadURL();
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      // print("a");
      // print(e);
      Get.snackbar("Error", "Failed to upload document: $e", backgroundColor: Colors.redAccent, colorText: Colors.white);
      return null;
    }
  }

  // Upload signature and return the URL
  Future<String?> uploadSignature() async {
    if (signatureController.isEmpty) return null;
    try {
      var signatureBytes = await signatureController.toPngBytes();
      if (signatureBytes != null) {
        Reference ref = storage.ref().child("signatures/${fullName.value}");
        UploadTask uploadTask = ref.putData(signatureBytes);
        var downloadUrl = await (await uploadTask).ref.getDownloadURL();
        return downloadUrl;
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to upload signature: $e", backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
    return null;
  }



  // Function to submit data to Firebase
  Future<void> submitData() async {

      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      try {
        String? frontDocumentUrl;
        String? backDocumentUrl;
        String? signatureUrl;

        if (frontDocument.value != null) {
          frontDocumentUrl = await uploadDocument(frontDocument.value!, "front_${fullName.value}");
        }
        // print("1");
      if (backDocument.value != null) {
          backDocumentUrl = await uploadDocument(backDocument.value!, "back_${fullName.value}");
        }
        // print("2");

        signatureUrl = await uploadSignature();
        // print("3");

        if (frontDocumentUrl != null && backDocumentUrl != null && signatureUrl != null) {
          // Handle optional fields: email, address, city, arrivingFrom, goingTo
          SelfCheckInModel selfCheckInData = SelfCheckInModel(
            documentType: documentType.value ?? "",
            frontDocumentUrl: frontDocumentUrl,
            backDocumentUrl: backDocumentUrl,
            fullName: fullName.text,
            email: email.text.isNotEmpty ? email.text : null,  // Handle email
            contact: contact.text,
            age: age.text,
            address: address.text.isNotEmpty ? address.text : null,  // Handle address
            city: city.text.isNotEmpty ? city.text : null,  // Handle city
            gender: gender.value,
            country: country.value,
            regionState: regionState.value,
            arrivingFrom: arrivingFromController.text.isNotEmpty ? arrivingFromController.text : null,  // Handle arrivingFrom
            goingTo: goingToController.text.isNotEmpty ? goingToController.text : null,  // Handle goingTo
            signatureUrl: signatureUrl,
          );

          // print("4");
          await DatabaseMethods().addSelfCheckInData(selfCheckInData.toMap()).then((_) {
            // print("5");
            Get.back();
            // print("55");

            Get.snackbar(
              "Success",
              "Self check-in completed successfully!",
              backgroundColor: Colors.orangeAccent,
              colorText: Colors.white,
            );
            // print("6");
            clearFields();
          });
        } else {
          Get.snackbar("Error", "Failed to upload documents/signature. Please try again.");
        }
      } catch (e) {
        Get.snackbar(
          "Error",
          "Failed to complete self check-in: $e",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      } finally {
        // print("AAAA");
        // Get.back();
        Get.to(() => const BottomNav());
        //Close loading dialog
      }

  }



  // Clear form fields after submission
  void clearFields() {
    fullName.clear();
    email.clear();
    contact.clear();
    age.clear();
    address.clear();
    city.clear();
    documentType.value = '';
    // frontDocument.value = '';
    // backDocument.value.c;
    signatureController.clear();
    termsAccepted.value = false;
    propertyTermsAccepted.value = false;
    arrivingFromController.clear();
    goingToController.clear();
  }

}
