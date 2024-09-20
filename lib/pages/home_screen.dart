// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:signature/signature.dart';
//
// import '../widgets/widget_support.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//
//   final _formKey = GlobalKey<FormState>();
//
//   // Form fields controllers
//   TextEditingController nameController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController numberController = TextEditingController();
//   TextEditingController ageController = TextEditingController();
//   TextEditingController genderController = TextEditingController();
//   TextEditingController addressController = TextEditingController();
//   TextEditingController cityController = TextEditingController();
//   TextEditingController arrivingFromController = TextEditingController();
//   TextEditingController goingToController = TextEditingController();
//
//   String? documentType;
//   XFile? frontDocument;
//   XFile? backDocument;
//   final ImagePicker _picker = ImagePicker();
//
//   // Signature
//   final SignatureController _signatureController = SignatureController(
//     penStrokeWidth: 5,
//     penColor: Colors.black,
//   );
//
//   // Method to pick an image
//   Future<void> _pickDocument(bool isFront) async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     setState(() {
//       if (isFront) {
//         frontDocument = pickedFile;
//       } else {
//         backDocument = pickedFile;
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _signatureController.dispose();
//     super.dispose();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Contactless Guest Registration"),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 "Document Type",
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//               ),
//               const SizedBox(height: 10),
//               DropdownButtonFormField<String>(
//                 value: documentType,
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     documentType = newValue;
//                   });
//                 },
//                 items: <String>['Aadhar', 'Driving License', 'Passport']
//                     .map((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) =>
//                 value == null ? "Please select document type" : null,
//               ),
//               const SizedBox(height: 20),
//               _buildDocumentUploadSection(),
//               const SizedBox(height: 20),
//               _buildTextField("Name", nameController, TextInputType.name),
//               const SizedBox(height: 20),
//               _buildTextField(
//                   "Email", emailController, TextInputType.emailAddress),
//               const SizedBox(height: 20),
//               _buildTextField(
//                   "Phone Number", numberController, TextInputType.phone),
//               const SizedBox(height: 20),
//               _buildTextField("Age", ageController, TextInputType.number),
//               const SizedBox(height: 20),
//               _buildTextField("Gender", genderController, TextInputType.text),
//               const SizedBox(height: 20),
//               _buildTextField("Address", addressController, TextInputType.text),
//               const SizedBox(height: 20),
//               _buildTextField("City", cityController, TextInputType.text),
//               const SizedBox(height: 20),
//               _buildTextField("Arriving From", arrivingFromController,
//                   TextInputType.text),
//               const SizedBox(height: 20),
//               _buildTextField("Going To", goingToController, TextInputType.text),
//               const SizedBox(height: 30),
//               const Text(
//                 "Signature",
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//               ),
//               const SizedBox(height: 10),
//               _buildSignatureSection(),
//               const SizedBox(height: 30),
//               _buildSubmitButton(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Document Upload Section
//   Widget _buildDocumentUploadSection() {
//     return Column(
//       children: [
//         const Text(
//           "Upload Front Side of Document",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 10),
//         ElevatedButton(
//           onPressed: () => _pickDocument(true),
//           child: const Text("Upload Front"),
//         ),
//         if (frontDocument != null) Text("Front document uploaded"),
//         const SizedBox(height: 20),
//         const Text(
//           "Upload Back Side of Document",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 10),
//         ElevatedButton(
//           onPressed: () => _pickDocument(false),
//           child: const Text("Upload Back"),
//         ),
//         if (backDocument != null) Text("Back document uploaded"),
//       ],
//     );
//   }
//
//   // TextField builder
//   Widget _buildTextField(
//       String label, TextEditingController controller, TextInputType type) {
//     return TextFormField(
//       controller: controller,
//       decoration: InputDecoration(
//         labelText: label,
//         border: const OutlineInputBorder(),
//       ),
//       keyboardType: type,
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return "Please enter $label";
//         }
//         return null;
//       },
//     );
//   }
//
//   // Signature Section
//   Widget _buildSignatureSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           height: 150,
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.grey),
//           ),
//           child: Signature(
//             controller: _signatureController,
//             backgroundColor: Colors.white,
//           ),
//         ),
//         const SizedBox(height: 10),
//         ElevatedButton(
//           onPressed: () {
//             _signatureController.clear();
//           },
//           child: const Text("Clear Signature"),
//         ),
//       ],
//     );
//   }
//
//   // Submit Button
//   Widget _buildSubmitButton() {
//     return Center(
//       child: ElevatedButton(
//         onPressed: () {
//           if (_formKey.currentState?.validate() == true) {
//             // Proceed with form submission logic
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text("Form submitted successfully!")),
//             );
//           }
//         },
//         child: const Text("Submit"),
//       ),
//     );
//   }
// }
