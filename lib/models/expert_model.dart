// import 'package:flutter/foundation.dart';
// @immutable
// class ExpertModel {
//   final String email;
//   final String password;
//   final String firstName;
//    final String lastName;
//   final String phone;
//   final String uid;
//   final double credits;
//   final List meetings;
//   final List<String> transactions;
//   final String dob;
//   final String state;
//   final String city;
//   final String address1;
//   final String address2;
//   final String proofDoc;
//   final String idDoc;
//   final String casesWon;
//   final String experience;
//   final String description;
//   final String approved;
//   final String profImage;
//   final List<String> tags; // <-- Add this
//   ExpertModel({
//     required this.email,
//     required this.password,
//     required this.firstName,
//     required this.lastName,
//     required this.phone,
//     required this.uid,
//     required this.transactions,
//     required this.dob,
//     required this.state,
//     required this.city,
//     required this.address1,
//     required this.address2,
//     required this.proofDoc,
//     required this.idDoc,
//     required this.casesWon,
//     required this.experience,
//     required this.description,
//     required this.approved,
//     required this.profImage,
//     required this.credits,
//     required this.meetings,
//     required this.tags, // <-- Add this
//   });

//   ExpertModel copyWith({
//     String? email,
//     String? password,
//     String? firstName,
//     String? lastName,
//     String? phone,
//     String? uid,
//     List<String>? transactions,
//     String? dob,
//     String? state,
//     String? city,
//     String? address1,
//     String? address2,
//     String? proofDoc,
//     String? idDoc,
//     String? casesWon,
//     List<String>? meetings,
//     double? credits,
//     String? experience,
//     String? description,
//     String? approved,
//     String? profImage,
//     List<String>? tags, // <-- Add this
//   }) {
//     return ExpertModel(
//       email: email ?? this.email,
//       password: password ?? this.password,
//       firstName: firstName ?? this.firstName,
//       lastName: lastName ?? this.lastName,
//       phone: phone ?? this.phone,
//       meetings: meetings ?? this.meetings,
//       credits: credits ?? this.credits,
//       uid: uid ?? this.uid,
//       transactions: transactions ?? this.transactions,
//       dob: dob ?? this.dob,
//       state: state ?? this.state,
//       city: city ?? this.city,
//       address1: address1 ?? this.address1,
//       address2: address2 ?? this.address2,
//       proofDoc: proofDoc ?? this.proofDoc,
//       idDoc: idDoc ?? this.idDoc,
//       casesWon: casesWon ?? this.casesWon,
//       experience: experience ?? this.experience,
//       description: description ?? this.description,
//       approved: approved ?? this.approved,
//       profImage: profImage ?? this.profImage,
//       tags: tags ?? this.tags, // <-- Add this
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'email': email,
//       'password': password,
//       'firstName': firstName,
//       'lastName': lastName,
//       'phone': phone,
//       'uid': uid,
//       'credits': credits,
//       'meetings': meetings,
//       'transactions': transactions,
//       'dob': dob,
//       'state': state,
//       'city': city,
//       'address1': address1,
//       'address2': address2,
//       'proofDoc': proofDoc,
//       'idDoc': idDoc,
//       'casesWon': casesWon,
//       'experience': experience,
//       'description': description,
//       'approved': approved,
//       'profImage': profImage,
//       'tags': tags, // <-- Add this
//     };
//   }

//   factory ExpertModel.fromMap(Map<String, dynamic> map) {
//     return ExpertModel(
//       email: map['email'] as String,
//       password: map['password'] as String,
//       firstName: map['firstName'] as String,
//       lastName: map['lastName'] as String,
//       phone: map['phone'] as String,
//       uid: map['uid'] as String,
//       transactions:
//           List<String>.from((map['transactions'] ?? []).map((x) => x as String)),
//            meetings:
//           List<String>.from((map['meetings'] ?? []).map((x) => x as String)),
//      credits: (map['credits'] is int) ? (map['credits'] as int).toDouble() : map['credits'] as double,
//       // transactions: List.from((map['transactions'] as List)),
//       dob: map['dob'] as String,
//       state: map['state'] as String,
//       city: map['city'] as String,
//       address1: map['address1'] as String,
//       address2: map['address2'] as String,
//       proofDoc: map['proofDoc'] as String,
//       idDoc: map['idDoc'] as String,
//       casesWon: map['casesWon'] as String,
//       experience: map['experience'] as String,
//       description: map['description'] as String,
//       approved: map['approved'] as String,
//       profImage: map['profImage'] as String,
//       tags: List<String>.from(map['tags'] ?? []), // <-- Add this
//     );
//   }

//   @override
//   String toString() {
//     return 'LawyerModel(email: $email, password: $password, firstName: $firstName, lastName: $lastName, phone: $phone, uid: $uid, transactions: $transactions, dob: $dob, state: $state, city: $city, address1: $address1, address2: $address2, proofDoc: $proofDoc, idDoc: $idDoc, casesWon: $casesWon, experience: $experience, description: $description, approved: $approved, profImage: $profImage, credits: $credits, meetings: $meetings, tags: $tags)';
//   }

//   @override
//   bool operator ==(covariant ExpertModel other) {
//     if (identical(this, other)) return true;
  
//     return 
//       other.email == email &&
//       other.password == password &&
//       other.firstName == firstName &&
//       other.lastName == lastName &&
//       other.phone == phone &&
//       other.uid == uid &&
//       listEquals(other.transactions, transactions) &&
//       listEquals(other.meetings, meetings) &&
//       other.credits == credits &&
//       other.dob == dob &&
//       other.state == state &&
//       other.city == city &&
//       other.address1 == address1 &&
//       other.address2 == address2 &&
//       other.proofDoc == proofDoc &&
//       other.idDoc == idDoc &&
//       other.casesWon == casesWon &&
//       other.experience == experience &&
//       other.description == description &&
//       other.approved == approved &&
//       other.profImage == profImage &&
//       listEquals(other.tags, tags); // <-- Add this
//   }

//   @override
//   int get hashCode {
//     return email.hashCode ^
//       password.hashCode ^
//       firstName.hashCode ^
//       lastName.hashCode ^
//       phone.hashCode ^
//       meetings.hashCode ^
//       credits.hashCode ^
//       uid.hashCode ^
//       transactions.hashCode ^
//       dob.hashCode ^
//       state.hashCode ^
//       city.hashCode ^
//       address1.hashCode ^
//       address2.hashCode ^
//       proofDoc.hashCode ^
//       idDoc.hashCode ^
//       casesWon.hashCode ^
//       experience.hashCode ^
//       description.hashCode ^
//       approved.hashCode ^
//       profImage.hashCode ^
//       tags.hashCode; // <-- Add this
//   }
// }