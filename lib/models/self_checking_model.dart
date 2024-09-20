class SelfCheckInModel {
  final String documentType;
  final String frontDocumentUrl;
  final String backDocumentUrl;
  final String fullName;
  final String? email; // Optional
  final String contact;
  final String age;
  final String? address; // Optional
  final String? city; // Optional
  final String gender;
  final String country;
  final String regionState;
  final String? arrivingFrom; // Optional
  final String? goingTo; // Optional
  final String signatureUrl;

  SelfCheckInModel({
    required this.documentType,
    required this.frontDocumentUrl,
    required this.backDocumentUrl,
    required this.fullName,
    this.email,
    required this.contact,
    required this.age,
    this.address,
    this.city,
    required this.gender,
    required this.country,
    required this.regionState,
    this.arrivingFrom,
    this.goingTo,
    required this.signatureUrl,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {
      'documentType': documentType,
      'frontDocumentUrl': frontDocumentUrl,
      'backDocumentUrl': backDocumentUrl,
      'fullName': fullName,
      'contact': contact,
      'age': age,
      'gender': gender,
      'country': country,
      'regionState': regionState,
      'signatureUrl': signatureUrl,
    };

    // Add optional fields only if they're not null or empty
    if (email != null && email!.isNotEmpty) data['email'] = email;
    if (address != null && address!.isNotEmpty) data['address'] = address;
    if (city != null && city!.isNotEmpty) data['city'] = city;
    if (arrivingFrom != null && arrivingFrom!.isNotEmpty) data['arrivingFrom'] = arrivingFrom;
    if (goingTo != null && goingTo!.isNotEmpty) data['goingTo'] = goingTo;

    return data;
  }
}
