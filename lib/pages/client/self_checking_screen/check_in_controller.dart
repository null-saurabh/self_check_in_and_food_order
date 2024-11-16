import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';
import 'package:wandercrew/utils/routes.dart';
import '../../../models/self_checking_model.dart';
import 'package:go_router/go_router.dart';


class CheckInController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    // fetchCountries();
    // fetchCountryCodes(); // Fetch countries from API when controller is initialized
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

      final response = await http.get(Uri.parse(
          'https://secure.geonames.org/countryInfoJSON?username=wandercrew'));
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

        countries.sort((a, b) => (a['name'] ?? '')
            .compareTo(b['name'] ?? '')); // Sort countries alphabetically
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
        debugPrint("Error Failed to fetch country list");

        // Get.snackbar("Error", "Failed to fetch country list");
      }
    } catch (e) {
      debugPrint(e.toString());
      // Get.snackbar("Error",
      //     "Unable to fetch countries. Please check your internet connection.");

      // print("eeee");
      // print(e);
    }
  }

  // Pick document from gallery (Front or Back)
  Future<void> pickDocument(bool isFront) async {
    try {
      if (kIsWeb) {
        final XFile? pickedFile =
            await _picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          if (isFront) {
            frontDocumentName.value =
                pickedFile.name; // Assign the file name to display
            final imageBytes = await pickedFile.readAsBytes();
            frontDocument.value = imageBytes;
          } else {
            final imageBytes = await pickedFile.readAsBytes();

            backDocument.value = imageBytes; // Assign the file name to display
            backDocumentName.value = pickedFile.name;
          }
        }
      } else {
        final XFile? pickedFile =
            await _picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          if (isFront) {
            frontDocument.value = File(pickedFile.path);
            frontDocumentName.value = pickedFile.name;
          } else {
            backDocument.value =
                File(pickedFile.path); // Assign the file name to display
            backDocumentName.value = pickedFile.name;
          }
        }
      }

      // update();
    } catch (e) {
      debugPrint("Error: Failed to pick image");
      // Get.snackbar("Error", "Failed to pick image");
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
      if (documentType == "Passport") {
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
    return isValid &&
        !isFrontDocumentInvalid.value &&
        !isBackDocumentInvalid.value;
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


  var selectedCountry = Rx<Map<String, String>?>(null);
  RxString selectedCountryCode = '+91'.obs; // Default to India
  // var selectedCountryCode = RxnString();

  // Fetch country codes (with flags) from API

  // Future<void> fetchCountryCodes() async {
  //   try {
  //     // print("fetching country codes 1");
  //     final response =
  //         await http.get(Uri.parse('https://restcountries.com/v3.1/all'));
  //     if (response.statusCode == 200) {
  //       // print("fetching country codes 2");
  //
  //       final List<dynamic> data = jsonDecode(response.body);
  //       // print("fetching country codes 3");
  //
  //       countryCodes.value = data
  //           .map((country) {
  //             final root = country['idd']?['root']?.toString() ?? '';
  //             final suffix = (country['idd']?['suffixes'] is List &&
  //                     country['idd']?['suffixes']?.isNotEmpty == true)
  //                 ? country['idd']['suffixes'][0].toString()
  //                 : '';
  //             // print("fetching country codes 4");
  //             return {
  //               'name': country['name']['common']?.toString() ?? '',
  //               'code': (root + suffix).isNotEmpty
  //                   ? root + suffix
  //                   : '', // Ensure root+suffix is combined correctly
  //               'flag': country['flags']?['png']?.toString() ??
  //                   '', // Safely access the flag URL
  //             };
  //           })
  //           .where((code) => code['code'] != null && code['code']!.isNotEmpty)
  //           .toList()
  //           .cast<
  //               Map<String,
  //                   String>>(); // Filter invalid entries and cast correctly
  //       // print("fetching country codes 5");
  //       // print(countryCodes.length);
  //       update();
  //     } else {
  //       debugPrint("Error: Failed to fetch country codes");
  //
  //     }
  //   } catch (e) {
  //     debugPrint(
  //         "Error: Unable to fetch country codes. Please check your internet connection.");
  //   } }




  // Fetch state list based on selected country
  Future<void> fetchStates(String countryCode) async {
    try {
      final response = await http.get(Uri.parse(
          'https://secure.geonames.org/childrenJSON?geonameId=$countryCode&username=wandercrew'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['geonames'];
        states.value = data.map((state) => state['name'].toString()).toList();
        states.sort(); // Sort states alphabetically
      } else {
        debugPrint("Error: Failed to fetch states");

      }
    } catch (e) {
    debugPrint("Error: Unable to fetch states. Please check your internet connection.");

    }
  }

  // Page 3
  TextEditingController arrivingFromController = TextEditingController();
  TextEditingController goingToController = TextEditingController();
  final SignatureController signatureController =
      SignatureController(penStrokeWidth: 5, penColor: Colors.black);
  var propertyTermsAccepted = false.obs;

  bool isSignatureEmpty() {
    return signatureController.isEmpty;
  }

  final FirebaseStorage storage = FirebaseStorage.instance;

  // Upload a document (Front/Back) and return the URL
  Future<String?> uploadDocument(BuildContext context,var document, String fileName) async {
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
      final snackBar = SnackBar(
        content: Text('Failed to fetch admin users: $e'),
        backgroundColor: Colors.red,
      );

// Show the snackbar
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

    }

      return null;
    }

  // Upload signature and return the URL
  Future<String?> uploadSignature(BuildContext context,) async {
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
      final snackBar = SnackBar(
        content: Text('Failed to upload signature: $e'),
        backgroundColor: Colors.red,
      );

// Show the snackbar
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      return null;
    }
    return null;

  }
  // Function to submit data to Firebase
  Future<void> submitData(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents the user from dismissing the dialog
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
    try {
      String? frontDocumentUrl;
      String? backDocumentUrl;
      String? signatureUrl;

      // if (frontDocument.value != null) {
      //   frontDocumentUrl = await uploadDocument(context,
      //       frontDocument.value!, "front_${fullName.value}");
      // }
      // // print("1");
      // if (backDocument.value != null) {
      //   backDocumentUrl =
      //   await uploadDocument(
      //       context, backDocument.value!, "back_${fullName.value}");
      // }
      // // print("2");
      //
      // signatureUrl = await uploadSignature(context);
      // print("3");



      // Use Future.wait to upload documents in parallel
      List<Future> uploadTasks = [];

      if (frontDocument.value != null) {
        uploadTasks.add(uploadDocument(context, frontDocument.value!, "front_${fullName.value}").then((url) {
          frontDocumentUrl = url;
        }));
      }

      if (backDocument.value != null) {
        uploadTasks.add(uploadDocument(context, backDocument.value!, "back_${fullName.value}").then((url) {
          backDocumentUrl = url;
        }));
      }

      uploadTasks.add(uploadSignature(context).then((url) {
        signatureUrl = url;
      }));

      // Wait for all upload tasks to finish
      await Future.wait(uploadTasks);


      if (frontDocumentUrl != null && signatureUrl != null) {
        if (documentType.value == "Passport" ? true : backDocumentUrl != null) {
          // Handle optional fields: email, address, city, arrivingFrom, goingTo
          SelfCheckInModel selfCheckInData = SelfCheckInModel(
            id: "",
            documentIssueCountry: documentIssueCountry.value ?? "",
            documentType: documentType.value ?? "",
            frontDocumentUrl: frontDocumentUrl!,
            backDocumentUrl: backDocumentUrl,
            fullName: fullName.text,
            email: email.text.isNotEmpty ? email.text : null,
            // Handle email
            contact: selectedCountryCode.value + contact.text,
            age: age.text,
            address: address.text.isNotEmpty ? address.text : null,
            // Handle address
            city: city.text.isNotEmpty ? city.text : null,
            // Handle city
            gender: gender.value!,
            country: country.value,
            regionState: regionState.value,
            arrivingFrom: arrivingFromController.text.isNotEmpty
                ? arrivingFromController.text
                : null,
            // Handle arrivingFrom
            goingTo: goingToController.text.isNotEmpty
                ? goingToController.text
                : null,
            // Handle goingTo
            signatureUrl: signatureUrl!,
            createdAt: DateTime.now(),
          );

          // print("4");

          DocumentReference docRef = await FirebaseFirestore.instance
              .collection('Self_Check_In')
              .add(selfCheckInData.toMap());

          String id = docRef.id; // Retrieve the autogenerated ID

          // Optionally, update the document with the newly assigned ID
          await docRef.update({'id': id});

          context.pop();
          // print("55");

          final snackBar = SnackBar(
            content: Text("Success: Self check-in completed successfully!",),
            backgroundColor: Colors.green,
          );

// Show the snackbar
          ScaffoldMessenger.of(context).showSnackBar(snackBar);

          // print("6");
          clearFields();
        }
      } else {
        final snackBar = SnackBar(
          content: Text(
              "Error: Failed to upload documents/signature. Please try again."),
          backgroundColor: Colors.red,
        );

// Show the snackbar
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      final snackBar = SnackBar(
        content: Text("Error: Failed to complete self check-in: $e"),
        backgroundColor: Colors.red,
      );

// Show the snackbar
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } finally {
      // print("AAAA");
      // ""();
      context.go(Routes.receptionHome);

      //Close loading dialog
    }
  }


  RxList<Map<String, String>> countryCodes = <Map<String, String>>[
    {'name': 'Afghanistan', 'code': '+93', 'flag': 'https://flagcdn.com/w320/af.png'},
    {'name': 'Albania', 'code': '+355', 'flag': 'https://flagcdn.com/w320/al.png'},
    {'name': 'Algeria', 'code': '+213', 'flag': 'https://flagcdn.com/w320/dz.png'},
    {'name': 'American Samoa', 'code': '+1684', 'flag': 'https://flagcdn.com/w320/as.png'},
    {'name': 'Andorra', 'code': '+376', 'flag': 'https://flagcdn.com/w320/ad.png'},
    {'name': 'Angola', 'code': '+244', 'flag': 'https://flagcdn.com/w320/ao.png'},
    {'name': 'Anguilla', 'code': '+1264', 'flag': 'https://flagcdn.com/w320/ai.png'},
    {'name': 'Antigua and Barbuda', 'code': '+1268', 'flag': 'https://flagcdn.com/w320/ag.png'},
    {'name': 'Argentina', 'code': '+54', 'flag': 'https://flagcdn.com/w320/ar.png'},
    {'name': 'Armenia', 'code': '+374', 'flag': 'https://flagcdn.com/w320/am.png'},
    {'name': 'Aruba', 'code': '+297', 'flag': 'https://flagcdn.com/w320/aw.png'},
    {'name': 'Australia', 'code': '+61', 'flag': 'https://flagcdn.com/w320/au.png'},
    {'name': 'Austria', 'code': '+43', 'flag': 'https://flagcdn.com/w320/at.png'},
    {'name': 'Azerbaijan', 'code': '+994', 'flag': 'https://flagcdn.com/w320/az.png'},
    {'name': 'Bahamas', 'code': '+1242', 'flag': 'https://flagcdn.com/w320/bs.png'},
    {'name': 'Bahrain', 'code': '+973', 'flag': 'https://flagcdn.com/w320/bh.png'},
    {'name': 'Bangladesh', 'code': '+880', 'flag': 'https://flagcdn.com/w320/bd.png'},
    {'name': 'Barbados', 'code': '+1246', 'flag': 'https://flagcdn.com/w320/bb.png'},
    {'name': 'Belarus', 'code': '+375', 'flag': 'https://flagcdn.com/w320/by.png'},
    {'name': 'Belgium', 'code': '+32', 'flag': 'https://flagcdn.com/w320/be.png'},
    {'name': 'Belize', 'code': '+501', 'flag': 'https://flagcdn.com/w320/bz.png'},
    {'name': 'Benin', 'code': '+229', 'flag': 'https://flagcdn.com/w320/bj.png'},
    {'name': 'Bermuda', 'code': '+1441', 'flag': 'https://flagcdn.com/w320/bm.png'},
    {'name': 'Bhutan', 'code': '+975', 'flag': 'https://flagcdn.com/w320/bt.png'},
    {'name': 'Bolivia', 'code': '+591', 'flag': 'https://flagcdn.com/w320/bo.png'},
    {'name': 'Bosnia and Herzegovina', 'code': '+387', 'flag': 'https://flagcdn.com/w320/ba.png'},
    {'name': 'Botswana', 'code': '+267', 'flag': 'https://flagcdn.com/w320/bw.png'},
    {'name': 'Brazil', 'code': '+55', 'flag': 'https://flagcdn.com/w320/br.png'},
    {'name': 'British Virgin Islands', 'code': '+1284', 'flag': 'https://flagcdn.com/w320/vg.png'},
    {'name': 'Brunei', 'code': '+673', 'flag': 'https://flagcdn.com/w320/bn.png'},
    {'name': 'Bulgaria', 'code': '+359', 'flag': 'https://flagcdn.com/w320/bg.png'},
    {'name': 'Burkina Faso', 'code': '+226', 'flag': 'https://flagcdn.com/w320/bf.png'},
    {'name': 'Burundi', 'code': '+257', 'flag': 'https://flagcdn.com/w320/bi.png'},
    {'name': 'Cambodia', 'code': '+855', 'flag': 'https://flagcdn.com/w320/kh.png'},
    {'name': 'Cameroon', 'code': '+237', 'flag': 'https://flagcdn.com/w320/cm.png'},
    {'name': 'Canada', 'code': '+1', 'flag': 'https://flagcdn.com/w320/ca.png'},
    {'name': 'Cape Verde', 'code': '+238', 'flag': 'https://flagcdn.com/w320/cv.png'},
    {'name': 'Cayman Islands', 'code': '+1345', 'flag': 'https://flagcdn.com/w320/ky.png'},
    {'name': 'Central African Republic', 'code': '+236', 'flag': 'https://flagcdn.com/w320/cf.png'},
    {'name': 'Chad', 'code': '+235', 'flag': 'https://flagcdn.com/w320/td.png'},
    {'name': 'Chile', 'code': '+56', 'flag': 'https://flagcdn.com/w320/cl.png'},
    {'name': 'China', 'code': '+86', 'flag': 'https://flagcdn.com/w320/cn.png'},
    {'name': 'Colombia', 'code': '+57', 'flag': 'https://flagcdn.com/w320/co.png'},
    {'name': 'Comoros', 'code': '+269', 'flag': 'https://flagcdn.com/w320/km.png'},
    {'name': 'Congo', 'code': '+242', 'flag': 'https://flagcdn.com/w320/cg.png'},
    {'name': 'Cook Islands', 'code': '+682', 'flag': 'https://flagcdn.com/w320/ck.png'},
    {'name': 'Costa Rica', 'code': '+506', 'flag': 'https://flagcdn.com/w320/cr.png'},
    {'name': 'Croatia', 'code': '+385', 'flag': 'https://flagcdn.com/w320/hr.png'},
    {'name': 'Cuba', 'code': '+53', 'flag': 'https://flagcdn.com/w320/cu.png'},
    {'name': 'Cyprus', 'code': '+357', 'flag': 'https://flagcdn.com/w320/cy.png'},
    {'name': 'Czech Republic', 'code': '+420', 'flag': 'https://flagcdn.com/w320/cz.png'},
    {'name': 'Denmark', 'code': '+45', 'flag': 'https://flagcdn.com/w320/dk.png'},
    {'name': 'Djibouti', 'code': '+253', 'flag': 'https://flagcdn.com/w320/dj.png'},
    {'name': 'Dominica', 'code': '+1767', 'flag': 'https://flagcdn.com/w320/dm.png'},
    {'name': 'Dominican Republic', 'code': '+1849', 'flag': 'https://flagcdn.com/w320/do.png'},
    {'name': 'Ecuador', 'code': '+593', 'flag': 'https://flagcdn.com/w320/ec.png'},
    {'name': 'Egypt', 'code': '+20', 'flag': 'https://flagcdn.com/w320/eg.png'},
    {'name': 'El Salvador', 'code': '+503', 'flag': 'https://flagcdn.com/w320/sv.png'},
    {'name': 'Equatorial Guinea', 'code': '+240', 'flag': 'https://flagcdn.com/w320/gq.png'},
    {'name': 'Eritrea', 'code': '+291', 'flag': 'https://flagcdn.com/w320/er.png'},
    {'name': 'Estonia', 'code': '+372', 'flag': 'https://flagcdn.com/w320/ee.png'},
    {'name': 'Eswatini', 'code': '+268', 'flag': 'https://flagcdn.com/w320/sz.png'},
    {'name': 'Ethiopia', 'code': '+251', 'flag': 'https://flagcdn.com/w320/et.png'},
    {'name': 'Fiji', 'code': '+679', 'flag': 'https://flagcdn.com/w320/fj.png'},
    {'name': 'Finland', 'code': '+358', 'flag': 'https://flagcdn.com/w320/fi.png'},
    {'name': 'France', 'code': '+33', 'flag': 'https://flagcdn.com/w320/fr.png'},
    {'name': 'Gabon', 'code': '+241', 'flag': 'https://flagcdn.com/w320/ga.png'},
    {'name': 'Gambia', 'code': '+220', 'flag': 'https://flagcdn.com/w320/gm.png'},
    {'name': 'Georgia', 'code': '+995', 'flag': 'https://flagcdn.com/w320/ge.png'},
    {'name': 'Germany', 'code': '+49', 'flag': 'https://flagcdn.com/w320/de.png'},
    {'name': 'Ghana', 'code': '+233', 'flag': 'https://flagcdn.com/w320/gh.png'},
    {'name': 'Greece', 'code': '+30', 'flag': 'https://flagcdn.com/w320/gr.png'},
    {'name': 'Greenland', 'code': '+299', 'flag': 'https://flagcdn.com/w320/gl.png'},
    {'name': 'Grenada', 'code': '+1473', 'flag': 'https://flagcdn.com/w320/gd.png'},
    {'name': 'Guam', 'code': '+1671', 'flag': 'https://flagcdn.com/w320/gu.png'},
    {'name': 'Guatemala', 'code': '+502', 'flag': 'https://flagcdn.com/w320/gt.png'},
    {'name': 'Guernsey', 'code': '+44', 'flag': 'https://flagcdn.com/w320/gg.png'},
    {'name': 'Guinea', 'code': '+224', 'flag': 'https://flagcdn.com/w320/gn.png'},
    {'name': 'Guinea-Bissau', 'code': '+245', 'flag': 'https://flagcdn.com/w320/gw.png'},
    {'name': 'Guyana', 'code': '+592', 'flag': 'https://flagcdn.com/w320/gy.png'},
    {'name': 'Haiti', 'code': '+509', 'flag': 'https://flagcdn.com/w320/ht.png'},
    {'name': 'Honduras', 'code': '+504', 'flag': 'https://flagcdn.com/w320/hn.png'},
    {'name': 'Hong Kong', 'code': '+852', 'flag': 'https://flagcdn.com/w320/hk.png'},
    {'name': 'Hungary', 'code': '+36', 'flag': 'https://flagcdn.com/w320/hu.png'},
    {'name': 'Iceland', 'code': '+354', 'flag': 'https://flagcdn.com/w320/is.png'},
    {'name': 'India', 'code': '+91', 'flag': 'https://flagcdn.com/w320/in.png'},
    {'name': 'Indonesia', 'code': '+62', 'flag': 'https://flagcdn.com/w320/id.png'},
    {'name': 'Iran', 'code': '+98', 'flag': 'https://flagcdn.com/w320/ir.png'},
    {'name': 'Iraq', 'code': '+964', 'flag': 'https://flagcdn.com/w320/iq.png'},
    {'name': 'Ireland', 'code': '+353', 'flag': 'https://flagcdn.com/w320/ie.png'},
    {'name': 'Isle of Man', 'code': '+44', 'flag': 'https://flagcdn.com/w320/im.png'},
    {'name': 'Israel', 'code': '+972', 'flag': 'https://flagcdn.com/w320/il.png'},
    {'name': 'Italy', 'code': '+39', 'flag': 'https://flagcdn.com/w320/it.png'},
    {'name': 'Jamaica', 'code': '+1876', 'flag': 'https://flagcdn.com/w320/jm.png'},
    {'name': 'Japan', 'code': '+81', 'flag': 'https://flagcdn.com/w320/jp.png'},
    {'name': 'Jersey', 'code': '+44', 'flag': 'https://flagcdn.com/w320/je.png'},
    {'name': 'Jordan', 'code': '+962', 'flag': 'https://flagcdn.com/w320/jo.png'},
    {'name': 'Kazakhstan', 'code': '+7', 'flag': 'https://flagcdn.com/w320/kz.png'},
    {'name': 'Kenya', 'code': '+254', 'flag': 'https://flagcdn.com/w320/ke.png'},
    {'name': 'Kiribati', 'code': '+686', 'flag': 'https://flagcdn.com/w320/ki.png'},
    {'name': 'Korea (North)', 'code': '+850', 'flag': 'https://flagcdn.com/w320/kp.png'},
    {'name': 'Korea (South)', 'code': '+82', 'flag': 'https://flagcdn.com/w320/kr.png'},
    {'name': 'Kuwait', 'code': '+965', 'flag': 'https://flagcdn.com/w320/kw.png'},
    {'name': 'Kyrgyzstan', 'code': '+996', 'flag': 'https://flagcdn.com/w320/kg.png'},
    {'name': 'Laos', 'code': '+856', 'flag': 'https://flagcdn.com/w320/la.png'},
    {'name': 'Latvia', 'code': '+371', 'flag': 'https://flagcdn.com/w320/lv.png'},
    {'name': 'Lebanon', 'code': '+961', 'flag': 'https://flagcdn.com/w320/lb.png'},
    {'name': 'Lesotho', 'code': '+266', 'flag': 'https://flagcdn.com/w320/ls.png'},
    {'name': 'Liberia', 'code': '+231', 'flag': 'https://flagcdn.com/w320/lr.png'},
    {'name': 'Libya', 'code': '+218', 'flag': 'https://flagcdn.com/w320/ly.png'},
    {'name': 'Liechtenstein', 'code': '+423', 'flag': 'https://flagcdn.com/w320/li.png'},
    {'name': 'Lithuania', 'code': '+370', 'flag': 'https://flagcdn.com/w320/lt.png'},
    {'name': 'Luxembourg', 'code': '+352', 'flag': 'https://flagcdn.com/w320/lu.png'},
    {'name': 'Macau', 'code': '+853', 'flag': 'https://flagcdn.com/w320/mo.png'},
    {'name': 'Madagascar', 'code': '+261', 'flag': 'https://flagcdn.com/w320/mg.png'},
    {'name': 'Malawi', 'code': '+265', 'flag': 'https://flagcdn.com/w320/mw.png'},
    {'name': 'Malaysia', 'code': '+60', 'flag': 'https://flagcdn.com/w320/my.png'},
    {'name': 'Maldives', 'code': '+960', 'flag': 'https://flagcdn.com/w320/mv.png'},
    {'name': 'Mali', 'code': '+223', 'flag': 'https://flagcdn.com/w320/ml.png'},
    {'name': 'Malta', 'code': '+356', 'flag': 'https://flagcdn.com/w320/mt.png'},
    {'name': 'Marshall Islands', 'code': '+692', 'flag': 'https://flagcdn.com/w320/mh.png'},
    {'name': 'Martinique', 'code': '+596', 'flag': 'https://flagcdn.com/w320/mq.png'},
    {'name': 'Mauritania', 'code': '+222', 'flag': 'https://flagcdn.com/w320/mr.png'},
    {'name': 'Mauritius', 'code': '+230', 'flag': 'https://flagcdn.com/w320/mu.png'},
    {'name': 'Mayotte', 'code': '+262', 'flag': 'https://flagcdn.com/w320/yt.png'},
    {'name': 'Mexico', 'code': '+52', 'flag': 'https://flagcdn.com/w320/mx.png'},
    {'name': 'Micronesia', 'code': '+691', 'flag': 'https://flagcdn.com/w320/fm.png'},
    {'name': 'Moldova', 'code': '+373', 'flag': 'https://flagcdn.com/w320/md.png'},
    {'name': 'Monaco', 'code': '+377', 'flag': 'https://flagcdn.com/w320/MC.png'},
    {'name': 'Mongolia', 'code': '+976', 'flag': 'https://flagcdn.com/w320/mn.png'},
    {'name': 'Montenegro', 'code': '+382', 'flag': 'https://flagcdn.com/w320/me.png'},
    {'name': 'Montserrat', 'code': '+1664', 'flag': 'https://flagcdn.com/w320/ms.png'},
    {'name': 'Morocco', 'code': '+212', 'flag': 'https://flagcdn.com/w320/ma.png'},
    {'name': 'Mozambique', 'code': '+258', 'flag': 'https://flagcdn.com/w320/mz.png'},
    {'name': 'Myanmar', 'code': '+95', 'flag': 'https://flagcdn.com/w320/mm.png'},
    {'name': 'Namibia', 'code': '+264', 'flag': 'https://flagcdn.com/w320/na.png'},
    {'name': 'Nauru', 'code': '+674', 'flag': 'https://flagcdn.com/w320/nr.png'},
    {'name': 'Nepal', 'code': '+977', 'flag': 'https://flagcdn.com/w320/np.png'},
    {'name': 'Netherlands', 'code': '+31', 'flag': 'https://flagcdn.com/w320/nl.png'},
    {'name': 'New Caledonia', 'code': '+687', 'flag': 'https://flagcdn.com/w320/nc.png'},
    {'name': 'New Zealand', 'code': '+64', 'flag': 'https://flagcdn.com/w320/nz.png'},
    {'name': 'Nicaragua', 'code': '+505', 'flag': 'https://flagcdn.com/w320/ni.png'},
    {'name': 'Niger', 'code': '+227', 'flag': 'https://flagcdn.com/w320/ne.png'},
    {'name': 'Nigeria', 'code': '+234', 'flag': 'https://flagcdn.com/w320/ng.png'},
    {'name': 'Niue', 'code': '+683', 'flag': 'https://flagcdn.com/w320/nu.png'},
    {'name': 'Norfolk Island', 'code': '+672', 'flag': 'https://flagcdn.com/w320/nf.png'},
    {'name': 'North Macedonia', 'code': '+389', 'flag': 'https://flagcdn.com/w320/mk.png'},
    {'name': 'Northern Mariana Islands', 'code': '+1670', 'flag': 'https://flagcdn.com/w320/mp.png'},
    {'name': 'Norway', 'code': '+47', 'flag': 'https://flagcdn.com/w320/no.png'},
    {'name': 'Oman', 'code': '+968', 'flag': 'https://flagcdn.com/w320/om.png'},
    {'name': 'Pakistan', 'code': '+92', 'flag': 'https://flagcdn.com/w320/pk.png'},
    {'name': 'Palau', 'code': '+680', 'flag': 'https://flagcdn.com/w320/pw.png'},
    {'name': 'Palestinian Territory', 'code': '+970', 'flag': 'https://flagcdn.com/w320/ps.png'},
    {'name': 'Panama', 'code': '+507', 'flag': 'https://flagcdn.com/w320/pa.png'},
    {'name': 'Papua New Guinea', 'code': '+675', 'flag': 'https://flagcdn.com/w320/pg.png'},
    {'name': 'Paraguay', 'code': '+595', 'flag': 'https://flagcdn.com/w320/py.png'},
    {'name': 'Peru', 'code': '+51', 'flag': 'https://flagcdn.com/w320/pe.png'},
    {'name': 'Philippines', 'code': '+63', 'flag': 'https://flagcdn.com/w320/ph.png'},
    {'name': 'Pitcairn Islands', 'code': '+64', 'flag': 'https://flagcdn.com/w320/pn.png'},
    {'name': 'Poland', 'code': '+48', 'flag': 'https://flagcdn.com/w320/pl.png'},
    {'name': 'Portugal', 'code': '+351', 'flag': 'https://flagcdn.com/w320/pt.png'},
    {'name': 'Puerto Rico', 'code': '+1939', 'flag': 'https://flagcdn.com/w320/pr.png'},
    {'name': 'Qatar', 'code': '+974', 'flag': 'https://flagcdn.com/w320/qa.png'},
    {'name': 'Réunion', 'code': '+262', 'flag': 'https://flagcdn.com/w320/re.png'},
    {'name': 'Romania', 'code': '+40', 'flag': 'https://flagcdn.com/w320/ro.png'},
    {'name': 'Russia', 'code': '+7', 'flag': 'https://flagcdn.com/w320/ru.png'},
    {'name': 'Rwanda', 'code': '+250', 'flag': 'https://flagcdn.com/w320/rw.png'},
    {'name': 'Saint Barthélemy', 'code': '+590', 'flag': 'https://flagcdn.com/w320/bl.png'},
    {'name': 'Saint Helena, Ascension and Tristan da Cunha', 'code': '+290', 'flag': 'https://flagcdn.com/w320/sh.png'},
    {'name': 'Saint Kitts and Nevis', 'code': '+1869', 'flag': 'https://flagcdn.com/w320/kn.png'},
    {'name': 'Saint Lucia', 'code': '+1758', 'flag': 'https://flagcdn.com/w320/lc.png'},
    {'name': 'Saint Martin', 'code': '+590', 'flag': 'https://flagcdn.com/w320/mf.png'},
    {'name': 'Saint Pierre and Miquelon', 'code': '+508', 'flag': 'https://flagcdn.com/w320/pm.png'},
    {'name': 'Saint Vincent and the Grenadines', 'code': '+1784', 'flag': 'https://flagcdn.com/w320/vc.png'},
    {'name': 'Samoa', 'code': '+685', 'flag': 'https://flagcdn.com/w320/ws.png'},
    {'name': 'San Marino', 'code': '+378', 'flag': 'https://flagcdn.com/w320/sm.png'},
    {'name': 'Sao Tome and Principe', 'code': '+239', 'flag': 'https://flagcdn.com/w320/st.png'},
    {'name': 'Saudi Arabia', 'code': '+966', 'flag': 'https://flagcdn.com/w320/sa.png'},
    {'name': 'Senegal', 'code': '+221', 'flag': 'https://flagcdn.com/w320/sn.png'},
    {'name': 'Serbia', 'code': '+381', 'flag': 'https://flagcdn.com/w320/rs.png'},
    {'name': 'Seychelles', 'code': '+248', 'flag': 'https://flagcdn.com/w320/sc.png'},
    {'name': 'Sierra Leone', 'code': '+232', 'flag': 'https://flagcdn.com/w320/sl.png'},
    {'name': 'Singapore', 'code': '+65', 'flag': 'https://flagcdn.com/w320/sg.png'},
    {'name': 'Sint Maarten', 'code': '+1721', 'flag': 'https://flagcdn.com/w320/sx.png'},
    {'name': 'Slovakia', 'code': '+421', 'flag': 'https://flagcdn.com/w320/sk.png'},
    {'name': 'Slovenia', 'code': '+386', 'flag': 'https://flagcdn.com/w320/si.png'},
    {'name': 'Solomon Islands', 'code': '+677', 'flag': 'https://flagcdn.com/w320/sb.png'},
    {'name': 'Somalia', 'code': '+252', 'flag': 'https://flagcdn.com/w320/so.png'},
    {'name': 'South Africa', 'code': '+27', 'flag': 'https://flagcdn.com/w320/za.png'},
    {'name': 'South Georgia and the South Sandwich Islands', 'code': '+500', 'flag': 'https://flagcdn.com/w320/gs.png'},
    {'name': 'South Korea', 'code': '+82', 'flag': 'https://flagcdn.com/w320/kr.png'},
    {'name': 'South Sudan', 'code': '+211', 'flag': 'https://flagcdn.com/w320/ss.png'},
    {'name': 'Spain', 'code': '+34', 'flag': 'https://flagcdn.com/w320/es.png'},
    {'name': 'Sri Lanka', 'code': '+94', 'flag': 'https://flagcdn.com/w320/lk.png'},
    {'name': 'Sudan', 'code': '+249', 'flag': 'https://flagcdn.com/w320/sd.png'},
    {'name': 'Suriname', 'code': '+597', 'flag': 'https://flagcdn.com/w320/sr.png'},
    {'name': 'Svalbard and Jan Mayen', 'code': '+47', 'flag': 'https://flagcdn.com/w320/sj.png'},
    {'name': 'Sweden', 'code': '+46', 'flag': 'https://flagcdn.com/w320/se.png'},
    {'name': 'Switzerland', 'code': '+41', 'flag': 'https://flagcdn.com/w320/ch.png'},
    {'name': 'Syria', 'code': '+963', 'flag': 'https://flagcdn.com/w320/sy.png'},
    {'name': 'Taiwan', 'code': '+886', 'flag': 'https://flagcdn.com/w320/tw.png'},
    {'name': 'Tajikistan', 'code': '+992', 'flag': 'https://flagcdn.com/w320/tj.png'},
    {'name': 'Tanzania', 'code': '+255', 'flag': 'https://flagcdn.com/w320/tz.png'},
    {'name': 'Thailand', 'code': '+66', 'flag': 'https://flagcdn.com/w320/th.png'},
    {'name': 'Timor-Leste', 'code': '+670', 'flag': 'https://flagcdn.com/w320/tl.png'},
    {'name': 'Togo', 'code': '+228', 'flag': 'https://flagcdn.com/w320/tg.png'},
    {'name': 'Tokelau', 'code': '+690', 'flag': 'https://flagcdn.com/w320/tk.png'},
    {'name': 'Tonga', 'code': '+676', 'flag': 'https://flagcdn.com/w320/to.png'},
    {'name': 'Trinidad and Tobago', 'code': '+1868', 'flag': 'https://flagcdn.com/w320/tt.png'},
    {'name': 'Tunisia', 'code': '+216', 'flag': 'https://flagcdn.com/w320/tn.png'},
    {'name': 'Turkey', 'code': '+90', 'flag': 'https://flagcdn.com/w320/tr.png'},
    {'name': 'Turkmenistan', 'code': '+993', 'flag': 'https://flagcdn.com/w320/tm.png'},
    {'name': 'Tuvalu', 'code': '+688', 'flag': 'https://flagcdn.com/w320/tv.png'},
    {'name': 'Uganda', 'code': '+256', 'flag': 'https://flagcdn.com/w320/ug.png'},
    {'name': 'Ukraine', 'code': '+380', 'flag': 'https://flagcdn.com/w320/ua.png'},
    {'name': 'United Arab Emirates', 'code': '+971', 'flag': 'https://flagcdn.com/w320/ae.png'},
    {'name': 'United Kingdom', 'code': '+44', 'flag': 'https://flagcdn.com/w320/gb.png'},
    {'name': 'United States', 'code': '+1', 'flag': 'https://flagcdn.com/w320/us.png'},
    {'name': 'Uruguay', 'code': '+598', 'flag': 'https://flagcdn.com/w320/uy.png'},
    {'name': 'Uzbekistan', 'code': '+998', 'flag': 'https://flagcdn.com/w320/uz.png'},
    {'name': 'Vanuatu', 'code': '+678', 'flag': 'https://flagcdn.com/w320/vu.png'},
    {'name': 'Vatican City', 'code': '+379', 'flag': 'https://flagcdn.com/w320/va.png'},
    {'name': 'Venezuela', 'code': '+58', 'flag': 'https://flagcdn.com/w320/ve.png'},
    {'name': 'Vietnam', 'code': '+84', 'flag': 'https://flagcdn.com/w320/vn.png'},
    {'name': 'Wallis and Futuna', 'code': '+681', 'flag': 'https://flagcdn.com/w320/wf.png'},
    {'name': 'Western Sahara', 'code': '+212', 'flag': 'https://flagcdn.com/w320/eh.png'},
    {'name': 'Yemen', 'code': '+967', 'flag': 'https://flagcdn.com/w320/ye.png'},
    {'name': 'Zambia', 'code': '+260', 'flag': 'https://flagcdn.com/w320/zm.png'},
    {'name': 'Zimbabwe', 'code': '+263', 'flag': 'https://flagcdn.com/w320/zw.png'}
  ].obs;

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
    currentPage.value = 0;
  }
}
