import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:signature/signature.dart';
import '../../../models/self_checking_model.dart';
import '../../../service/database.dart';



class CheckInController extends GetxController {


  @override
  void onInit() {
    super.onInit();
    fetchCountries();
    fetchCountryCodes(); // Fetch countries from API when controller is initialized
  }


  final GlobalKey<FormState> formKeyPage1 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyPage2 = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyPage3 = GlobalKey<FormState>();
  RxString receptionistText = "Hi, Please Enter your details!".obs;

  PageController pageController = PageController(); // For form navigation
  var currentPage = 0.obs; // To track the current form page

  void nextPage() {
    if (currentPage.value < 2) {
      currentPage.value++;
    }
    update();
  }
  void previousPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
      update();

    }
  }



  // Page 1

  var documentIssueCountry = RxnString();
  // var documentIssueCountry = Rx<Map<String, String>?>(null);
  RxnString documentType = RxnString();

  Rxn<dynamic> frontDocument = Rxn<dynamic>();
  var frontDocumentName = Rxn<String>();
  var isFrontDocumentInvalid = false.obs;

  Rxn<dynamic> backDocument = Rxn<dynamic>();
  var backDocumentName = Rxn<String>();
  var isBackDocumentInvalid = false.obs;

  var termsAccepted = false.obs;
  var isTermAccepted = false.obs;

  RxList<Map<String, String>> countries = <Map<String, String>>[].obs;
  final ImagePicker _picker = ImagePicker();

  Future<void> fetchCountries() async {
    try {
      // print("fetching country 1");

      final response = await http.get(Uri.parse('https://secure.geonames.org/countryInfoJSON?username=wandercrew'));
      // print("fetching country 2");
      if (response.statusCode == 200) {
        // print("fetching country 3");

        final List<dynamic> data = jsonDecode(response.body)['geonames'];
        // print("fetching country 4");

        countries.value = data.map((country) {
          return {
            'name': country['countryName'] as String,
            'code': country['geonameId'].toString(),
          };
        }).toList();
        // print("fetching country 5");

        countries.sort((a, b) => (a['name'] ?? '').compareTo(b['name'] ?? ''));// Sort countries alphabetically
        selectedCountry.value = countries.firstWhere(
              (country) => country['name'] == 'India',
          orElse: () => countries.first,
        );
        // print("fetching country 6");
        fetchStates(selectedCountry.value!['code']!);
        // print("fetching country 6");
        documentIssueCountry.value = selectedCountry.value!['name'];
        // print("fetching country 6");

        update();
        // print("fetching country 7");

      } else {
        // print("self country:");
        // print(response.body);

        Get.snackbar("Error", "Failed to fetch country list");
      }
    } catch (e) {
      Get.snackbar("Error", "Unable to fetch countries. Please check your internet connection.");

      // print("eeee");
      // print(e);
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

  bool validateFormPage1() {

    final isValid = formKeyPage1.currentState?.validate() ?? false;

    // Manually validate the front document and back document
    if (frontDocument.value == null) {
      isFrontDocumentInvalid.value = true;
    } else {
      isFrontDocumentInvalid.value = false;
    }

    if (backDocument.value == null) {
      if (documentType == "Passport"){
        isBackDocumentInvalid.value = false;

      } else {
        isBackDocumentInvalid.value = true;
      }
    } else {
      isBackDocumentInvalid.value = false;
    }

    if (!termsAccepted.value) {
      isTermAccepted.value = true;
    } else {
      isTermAccepted.value = false;
    }

    update();

    // Return whether the entire form is valid
    return isValid && !isFrontDocumentInvalid.value && !isBackDocumentInvalid.value;
  }



  // Page 2
  TextEditingController fullName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController city = TextEditingController();

  RxnString gender = RxnString();
  var country = 'India'.obs;
  var regionState = ''.obs;

  RxList<String> states = <String>[].obs;

  RxList<Map<String, String>> countryCodes = <Map<String, String>>[].obs;
  // Ensure the countryCodes list is populated correctly
  // RxList<Map<String, String>> countryCodes = <Map<String, String>>[
  //   {
  //     'code': '+91',
  //     'flag': 'https://example.com/india_flag.png'  // Replace with actual image URL
  //   },
  //   {
  //     'code': '+1',
  //     'flag': 'https://example.com/us_flag.png'  // Replace with actual image URL
  //   },
  //   // Add more countries here...
  // ].obs;
  var selectedCountry = Rx<Map<String, String>?>(null);
  RxString selectedCountryCode = '+91'.obs;  // Default to India
  // var selectedCountryCode = RxnString();


  // Fetch country codes (with flags) from API
  Future<void> fetchCountryCodes() async {
    try {
      // print("fetching country codes 1");
      final response = await http.get(Uri.parse('https://restcountries.com/v3.1/all'));
      if (response.statusCode == 200) {
        // print("fetching country codes 2");

        final List<dynamic> data = jsonDecode(response.body);
        // print("fetching country codes 3");

        countryCodes.value = data.map((country) {
          final root = country['idd']?['root']?.toString() ?? '';
          final suffix = (country['idd']?['suffixes'] is List && country['idd']?['suffixes']?.isNotEmpty == true)
              ? country['idd']['suffixes'][0].toString()
              : '';
          // print("fetching country codes 4");
          return {
            'name': country['name']['common']?.toString() ?? '',
            'code': (root + suffix).isNotEmpty ? root + suffix : '',  // Ensure root+suffix is combined correctly
            'flag': country['flags']?['png']?.toString() ?? '',  // Safely access the flag URL
          };
        }).where((code) => code['code'] != null && code['code']!.isNotEmpty).toList().cast<Map<String, String>>();  // Filter invalid entries and cast correctly
        // print("fetching country codes 5");
        // print(countryCodes.length);
        update();

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
      final response = await http.get(Uri.parse('https://secure.geonames.org/childrenJSON?geonameId=$countryCode&username=wandercrew'));
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
  var propertyTermsAccepted = false.obs;


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

        String addId = randomAlphaNumeric(10);
        if (frontDocumentUrl != null  && signatureUrl != null) {
          if (documentType.value == "Passport" ? true : backDocumentUrl != null) {
          // Handle optional fields: email, address, city, arrivingFrom, goingTo
          SelfCheckInModel selfCheckInData = SelfCheckInModel(
            id: addId,
            documentIssueCountry: documentIssueCountry.value ?? "",
            documentType: documentType.value ?? "",
            frontDocumentUrl: frontDocumentUrl,
            backDocumentUrl: backDocumentUrl,
            fullName: fullName.text,
            email: email.text.isNotEmpty ? email.text : null,  // Handle email
            contact: selectedCountryCode.value + contact.text,
            age: age.text,
            address: address.text.isNotEmpty ? address.text : null,  // Handle address
            city: city.text.isNotEmpty ? city.text : null,  // Handle city
            gender: gender.value!,
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
        } }else {
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
        Get.toNamed("/reception");
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
