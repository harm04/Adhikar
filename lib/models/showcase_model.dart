import 'package:adhikar/common/enums/post_type_enum.dart';
import 'package:flutter/foundation.dart';

class ShowcaseModel {
  final String title;
  final String tagline;
  final String description;
  final List<String> hashtags;
  final String uid;
  final String id;
  final String link;
  final String bannerImage; // CHANGED
  final String logoImage;   // CHANGED
  final DateTime createdAt;
  final List<String> images;
  final List<String> upvotes;
  final List<String> commentIds;
  final PostType type;
  final String commentedTo;
  ShowcaseModel({
    required this.title,
    required this.tagline,
    required this.hashtags,
    required this.uid,
    required this.description,
    required this.id,
    required this.bannerImage, // CHANGED
    required this.link,
    required this.logoImage,   // CHANGED
    required this.createdAt,
    required this.images,
    required this.upvotes,
    required this.commentIds,
    required this.type,
    required this.commentedTo,
  });

  ShowcaseModel copyWith({
    String? title,
    String? tagline,
    List<String>? hashtags,
    String? uid,
    String? id,
    String? description,
    String? link,
    String? bannerImage, // CHANGED
    String? logoImage,   // CHANGED
    DateTime? createdAt,
    List<String>? images,
    List<String>? upvotes,
    List<String>? commentIds,
    PostType? type,
    String? commentedTo,
  }) {
    return ShowcaseModel(
      title: title ?? this.title,
      tagline: tagline ?? this.tagline,
      link: link ?? this.link,
      hashtags: hashtags ?? this.hashtags,
      uid: uid ?? this.uid,
      id: id ?? this.id,
      description: description ?? this.description,
      bannerImage: bannerImage ?? this.bannerImage, // CHANGED
      createdAt: createdAt ?? this.createdAt,
      images: images ?? this.images,
      upvotes: upvotes ?? this.upvotes,
      logoImage: logoImage ?? this.logoImage,       // CHANGED
      commentIds: commentIds ?? this.commentIds,
      type: type ?? this.type,
      commentedTo: commentedTo ?? this.commentedTo,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'tagline': tagline,
      'hashtags': hashtags,
      'uid': uid,
      'description': description,
      'link': link,
      'bannerImage': bannerImage, // CHANGED
      'logoImage': logoImage,     // CHANGED
      'createdAt': createdAt.millisecondsSinceEpoch,
      'images': images,
      'upvotes': upvotes,
      'commentIds': commentIds,
      'type': type.type,
      'commentedTo': commentedTo,
    };
  }

  factory ShowcaseModel.fromMap(Map<String, dynamic> map) {
    return ShowcaseModel(
      title: map['title'] as String,
      tagline: map['tagline'] as String,
      hashtags: List<String>.from((map['hashtags'] ?? []).map((x) => x as String)),
      uid: map['uid'] as String,
      id: map['\$id'] as String,
      description: map['description'] as String,
      bannerImage: map['bannerImage'] as String, // CHANGED
      logoImage: map['logoImage'] as String,     // CHANGED
      link: map['link'] as String? ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      images: List<String>.from((map['images'] ?? []).map((x) => x as String)),
      upvotes: List<String>.from((map['upvotes'] ?? []).map((x) => x as String)),
      commentIds: List<String>.from((map['commentIds'] ?? []).map((x) => x as String)),
      type: (map['type'] as String).toPostTypeEnum(),
      commentedTo: map['commentedTo'] as String,
    );
  }

  @override
  String toString() {
    return 'PostModel(title: $title,link:$link, tagline: $tagline, hashtags: $hashtags, uid: $uid, id: $id, description: $description, bannerImage: $bannerImage, createdAt: $createdAt, images: $images, upvotes: $upvotes, commentIds: $commentIds, type: $type, commentedTo: $commentedTo, logoImage: $logoImage )';
  }

  @override
  bool operator ==(covariant ShowcaseModel other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.tagline == tagline &&
        other.hashtags == hashtags &&
        other.link == link &&
        other.uid == uid &&
        other.id == id &&
        other.description == description &&
        other.bannerImage == bannerImage && // CHANGED
        other.logoImage == logoImage &&     // CHANGED
        other.createdAt == createdAt &&
        listEquals(other.images, images) &&
        listEquals(other.upvotes, upvotes) &&
        listEquals(other.commentIds, commentIds) &&
        other.type == type &&
        other.commentedTo == commentedTo;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        tagline.hashCode ^
        hashtags.hashCode ^
        uid.hashCode ^
        id.hashCode ^
        description.hashCode ^
        bannerImage.hashCode ^
        link.hashCode ^
        logoImage.hashCode ^
        createdAt.hashCode ^
        images.hashCode ^
        upvotes.hashCode ^
        commentIds.hashCode ^
        type.hashCode ^
        commentedTo.hashCode;
  }
}
