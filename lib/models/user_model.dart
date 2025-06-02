import 'package:flutter/foundation.dart';

@immutable
class UserModel {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String profileImage;
  final List<String> meetings;
  final double credits;
  final String bio;
  final String phone;
  final String createdAt;
  final String summary;
  final List<String> following;
  final List<String> followers;
  final List<String> bookmarked;
  final bool isVerified;
  final String uid;
  final String location;
  final String linkedin;
  final String twitter;
  final String instagram;
  final String facebook;
  final String experienceTitle;
  final String experienceSummary;
  final String experienceOrganization;
  final String eduStream;
  final String eduDegree;
  final String eduUniversity;
  final String userType;
  const UserModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.credits,
    required this.meetings,
    required this.password,
    required this.profileImage,
    required this.bio,
    required this.createdAt,
    required this.summary,
    required this.phone,
    required this.following,
    required this.followers,
    required this.bookmarked,
    required this.isVerified,
    required this.uid,
    required this.location,
    required this.linkedin,
    required this.twitter,
    required this.instagram,
    required this.facebook,
    required this.experienceTitle,
    required this.experienceSummary,
    required this.experienceOrganization,
    required this.eduStream,
    required this.eduDegree,
    required this.eduUniversity,
    required this.userType,
  });

  UserModel copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? password,
    String? profileImage,
    String? bio,
    String? createdAt,
    String? summary,
    List<String>? following,
    List<String>? followers,
    List<String>? bookmarked,
    List<String>? meetings,
    double? credits,
    bool? isVerified,
    String? uid,
    String? location,
    String? linkedin,
    String? twitter,
    String? instagram,
    String? facebook,
    String? experienceTitle,
    String? experienceSummary,
    String? experienceOrganization,
    String? eduStream,
    String? eduDegree,
    String? eduUniversity,
    String? userType,
  }) {
    return UserModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      password: password ?? this.password,
      profileImage: profileImage ?? this.profileImage,
      bio: bio ?? this.bio,
      createdAt: createdAt ?? this.createdAt,
      summary: summary ?? this.summary,
      following: following ?? this.following,
      followers: followers ?? this.followers,
      meetings: meetings ?? this.meetings,
      credits: credits ?? this.credits,
      bookmarked: bookmarked ?? this.bookmarked,
      isVerified: isVerified ?? this.isVerified,
      uid: uid ?? this.uid,
      location: location ?? this.location,
      linkedin: linkedin ?? this.linkedin,
      twitter: twitter ?? this.twitter,
      instagram: instagram ?? this.instagram,
      facebook: facebook ?? this.facebook,
      experienceTitle: experienceTitle ?? this.experienceTitle,
      experienceSummary: experienceSummary ?? this.experienceSummary,
      experienceOrganization:
          experienceOrganization ?? this.experienceOrganization,
      eduStream: eduStream ?? this.eduStream,
      eduDegree: eduDegree ?? this.eduDegree,
      eduUniversity: eduUniversity ?? this.eduUniversity,
      userType: userType ?? this.userType,
      phone: phone ?? this.phone,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'profileImage': profileImage,
      'bio': bio,
      'createdAt': createdAt,
      'summary': summary,
      'following': following,
      'followers': followers,
      'bookmarked': bookmarked,
      'phone': phone,
      'meetings': meetings,
      'credits': credits,
      'isVerified': isVerified,
      'location': location,
      'linkedin': linkedin,
      'twitter': twitter,
      'instagram': instagram,
      'facebook': facebook,
      'experienceTitle': experienceTitle,
      'experienceSummary': experienceSummary,
      'experienceOrganization': experienceOrganization,
      'eduStream': eduStream,
      'eduDegree': eduDegree,
      'eduUniversity': eduUniversity,
      'userType': userType,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String? ?? '',
      password: map['password'] as String,
      profileImage: map['profileImage'] as String,
      bio: map['bio'] as String,
      createdAt: map['createdAt'] as String,
      summary: map['summary'] as String,
      followers:
          List<String>.from((map['followers'] ?? []).map((x) => x as String)),
      meetings:
          List<String>.from((map['meetings'] ?? []).map((x) => x as String)),
      following:
          List<String>.from((map['following'] ?? []).map((x) => x as String)),
      bookmarked:
          List<String>.from((map['bookmarked'] ?? []).map((x) => x as String)),
      credits: (map['credits'] is int) ? (map['credits'] as int).toDouble() : map['credits'] as double,

//change this default generated code to above code for list.

      // following: List<String>.from((map['following'] as List<String>)),
      // followers: List<String>.from((map['followers'] as List<String>)),
      // bookmarked: List<String>.from((map['bookmarked'] as List<String>)),
      isVerified: map['isVerified'] as bool,
      uid: map['\$id'] as String,
      location: map['location'] as String,
      linkedin: map['linkedin'] as String,
      twitter: map['twitter'] as String,
      instagram: map['instagram'] as String,
      facebook: map['facebook'] as String,
      experienceTitle: map['experienceTitle'] as String,
      experienceSummary: map['experienceSummary'] as String,
      experienceOrganization: map['experienceOrganization'] as String,
      eduStream: map['eduStream'] as String,
      eduDegree: map['eduDegree'] as String,
      eduUniversity: map['eduUniversity'] as String,
      userType: map['userType'] as String,
    );
  }

  @override
  String toString() {
    return 'UserModel(firstName: $firstName,phone:$phone, lastName: $lastName, email: $email, password: $password, profileImage: $profileImage, bio: $bio, createdAt: $createdAt, summary: $summary, following: $following, followers: $followers, bookmarked: $bookmarked, isVerified: $isVerified, uid: $uid, location: $location, linkedin: $linkedin, twitter: $twitter, instagram: $instagram, facebook: $facebook, experienceTitle: $experienceTitle, experienceSummary: $experienceSummary, experienceOrganization: $experienceOrganization, eduStream: $eduStream, eduDegree: $eduDegree, eduUniversity: $eduUniversity, userType: $userType, credits: $credits, meetings: $meetings)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.firstName == firstName &&
        other.lastName == lastName &&
        other.email == email &&
        other.phone == phone &&
        other.password == password &&
        other.profileImage == profileImage &&
        other.bio == bio &&
        other.createdAt == createdAt &&
        other.summary == summary &&
        listEquals(other.following, following) &&
        listEquals(other.followers, followers) &&
        listEquals(other.meetings, meetings) &&
        listEquals(other.bookmarked, bookmarked) &&
        other.credits == credits &&
        other.isVerified == isVerified &&
        other.uid == uid &&
        other.location == location &&
        other.linkedin == linkedin &&
        other.twitter == twitter &&
        other.instagram == instagram &&
        other.facebook == facebook &&
        other.experienceTitle == experienceTitle &&
        other.experienceSummary == experienceSummary &&
        other.experienceOrganization == experienceOrganization &&
        other.eduStream == eduStream &&
        other.eduDegree == eduDegree &&
        other.eduUniversity == eduUniversity &&
        other.userType == userType;
  }

  @override
  int get hashCode {
    return firstName.hashCode ^
        lastName.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        password.hashCode ^
        profileImage.hashCode ^
        bio.hashCode ^
        createdAt.hashCode ^
        meetings.hashCode ^
        credits.hashCode ^
        summary.hashCode ^
        following.hashCode ^
        followers.hashCode ^
        bookmarked.hashCode ^
        isVerified.hashCode ^
        uid.hashCode ^
        location.hashCode ^
        linkedin.hashCode ^
        twitter.hashCode ^
        instagram.hashCode ^
        facebook.hashCode ^
        experienceTitle.hashCode ^
        experienceSummary.hashCode ^
        experienceOrganization.hashCode ^
        eduStream.hashCode ^
        eduDegree.hashCode ^
        eduUniversity.hashCode ^
        userType.hashCode;
  }
}