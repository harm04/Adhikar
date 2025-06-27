class ReportModal {
  final String postId;
  final String reason;
  final String reporterUid;

  final String reportedUserUid;
  final String id;
  
  final DateTime createdAt;

  ReportModal({
    required this.postId,
    required this.reason,
    required this.reporterUid,
    required this.reportedUserUid,
    required this.id,
    
    required this.createdAt,
  });

  ReportModal copyWith({
    String? postId,
    String? reason,
    String? reporterUid,
    String? reportedUserUid,
    String? id,
    
    DateTime? createdAt,
  }) {
    return ReportModal(
      postId: postId ?? this.postId,
      reason: reason ?? this.reason,
      reporterUid: reporterUid ?? this.reporterUid,
      reportedUserUid: reportedUserUid ?? this.reportedUserUid,
      id: id ?? this.id,
 
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'postId': postId,
      'reason': reason,
      'reporterUid': reporterUid,
      'reportedUserUid': reportedUserUid,

      

      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory ReportModal.fromMap(Map<String, dynamic> map) {
    return ReportModal(
      postId: map['postId'] as String,
      reason: map['reason'] as String,
      reporterUid: map['reporterUid'] as String,
      reportedUserUid: map['reportedUserUid'] as String,
      id: map['\$id'] as String,
      
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }

  @override
  String toString() {
    return 'PostModel(postId:$postId,reason:$reason,reporterUid:$reporterUid,reportedUserUid:$reportedUserUid,id: $id, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant ReportModal other) {
    if (identical(this, other)) return true;

    return other.postId == postId &&
        other.reason == reason &&
        other.reporterUid == reporterUid &&
        other.reportedUserUid == reportedUserUid &&
        
        other.id == id &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return postId.hashCode ^
        reason.hashCode ^
        reporterUid.hashCode ^
        reportedUserUid.hashCode ^
       
        id.hashCode ^
        createdAt.hashCode;
  }
}
