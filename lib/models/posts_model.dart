import 'package:adhikar/common/enums/post_type_enum.dart';
import 'package:flutter/foundation.dart';


class PostModel {
  final String text;
  final String link;
  final List<String> hashtags;
  final String uid;
  final String id;
  final String pod;
  final bool isAnonymous;
  final DateTime createdAt;
  final List<String> images;
  final List<String> likes;
  final List<String> commentIds;
  final PostType type;
  final String commentedTo;
  PostModel({
    required this.text,
    required this.link,
    required this.hashtags,
    required this.uid,
    required this.id,
    required this.pod,
    required this.isAnonymous,
    required this.createdAt,
    required this.images,
    required this.likes,
    required this.commentIds,
    required this.type,
    required this.commentedTo,
  });

  PostModel copyWith({
    String? text,
    String? link,
     List<String>? hashtags,
    String? uid,
    String? id,
    String? pod,
    bool? isAnonymous,
    DateTime? createdAt,
    List<String>? images,
    List<String>? likes,
    List<String>? commentIds,
    PostType? type,
    String? commentedTo,
  }) {
    return PostModel(
      text: text ?? this.text,
      link: link ?? this.link,
       hashtags: hashtags ?? this.hashtags,
      uid: uid ?? this.uid,
      id: id ?? this.id,
      pod: pod ?? this.pod,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      createdAt: createdAt ?? this.createdAt,
      images: images ?? this.images,
      likes: likes ?? this.likes,
      commentIds: commentIds ?? this.commentIds,
      type: type ?? this.type,
      commentedTo: commentedTo ?? this.commentedTo,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'link': link,
      'hashtags': hashtags,
      'uid': uid,
      
      'pod': pod,
      'isAnonymous': isAnonymous,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'images': images,
      'likes': likes,
      'commentIds': commentIds,
      'type': type.type,
      'commentedTo': commentedTo,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      text: map['text'] as String,
      link: map['link'] as String,
      hashtags: List<String>.from((map['hashtags'] ?? []).map((x) => x as String)),
      uid: map['uid'] as String,
      id: map['\$id'] as String,
      pod: map['pod'] as String,
      isAnonymous: map['isAnonymous'] as bool,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      images: List<String>.from((map['images'] ?? []).map((x) => x as String)),
      likes: List<String>.from((map['likes'] ?? []).map((x) => x as String)),
      commentIds:
          List<String>.from((map['commentIds'] ?? []).map((x) => x as String)),
      type: (map['type'] as String).toPostTypeEnum(),
      commentedTo: map['commentedTo'] as String,
    );
  }

  @override
  String toString() {
    return 'PostModel(text: $text, link: $link, hashtags: $hashtags, uid: $uid, id: $id, pod: $pod, isAnonymous: $isAnonymous, createdAt: $createdAt, images: $images, likes: $likes, commentIds: $commentIds, type: $type, commentedTo: $commentedTo)';
  }

  @override
  bool operator ==(covariant PostModel other) {
    if (identical(this, other)) return true;

    return other.text == text &&
        other.link == link &&
        other.hashtags == hashtags &&
        other.uid == uid &&
        other.id == id &&
        other.pod == pod &&
        other.isAnonymous == isAnonymous &&
        other.createdAt == createdAt &&
        listEquals(other.images, images) &&
        listEquals(other.likes, likes) &&
        listEquals(other.commentIds, commentIds) &&
        other.type == type &&
        other.commentedTo == commentedTo;
  }

  @override
  int get hashCode {
    return text.hashCode ^
        link.hashCode ^
        hashtags.hashCode ^
        uid.hashCode ^
        id.hashCode ^
        pod.hashCode ^
        isAnonymous.hashCode ^
        createdAt.hashCode ^
        images.hashCode ^
        likes.hashCode ^
        commentIds.hashCode ^
        type.hashCode ^
        commentedTo.hashCode;
  }
}