// ignore_for_file: public_member_api_docs, sort_constructors_first

class MeetingsModel {
  final String id;

  final DateTime createdAt;
  final String clientPhone;
  final String clientUid;
  final String expertUid;
  final String meetingStatus;
  final String transactionID;

  MeetingsModel({
    required this.id,
    required this.clientUid,
    required this.expertUid,
    required this.createdAt,
    required this.clientPhone,
    required this.transactionID,
    required this.meetingStatus,
  });

  MeetingsModel copyWith({
    DateTime? createdAt,
    String? clientPhone,
    String? expertUid,
    String? clientUid,
    String? id,
    String? transactionID,
    String? meetingStatus,
  }) {
    return MeetingsModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      clientPhone: clientPhone ?? this.clientPhone,
      expertUid: expertUid ?? this.expertUid,
      clientUid: clientUid ?? this.clientUid,
      transactionID: transactionID ?? this.transactionID,
      meetingStatus: meetingStatus ?? this.meetingStatus,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'transactionID': transactionID,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'clientPhone': clientPhone,
      'expertUid': expertUid,
      'clientUid': clientUid,

      'meetingStatus': meetingStatus,
    };
  }

  factory MeetingsModel.fromMap(Map<String, dynamic> map) {
    return MeetingsModel(
      id: map['\$id'] as String,
      createdAt:DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      clientPhone: map['clientPhone'] as String,
      expertUid: map['expertUid'] as String,
      clientUid: map['clientUid'] as String,
      transactionID: map['transactionID'] as String,
      meetingStatus: map['meetingStatus'] as String,
    );
  }

  @override
  String toString() {
    return 'meetings(id: $id, createdAt:$createdAt,clientPhone:$clientPhone ,clientUid:$clientUid,expertUid:$expertUid,meetingStatus: $meetingStatus, transactionID: $transactionID)';
  }

  @override
  bool operator ==(covariant MeetingsModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.createdAt == createdAt &&
        other.clientPhone == clientPhone &&
        other.expertUid == expertUid &&
        other.clientUid == clientUid &&
        other.transactionID == transactionID &&
        other.meetingStatus == meetingStatus;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        createdAt.hashCode ^
        clientPhone.hashCode ^
        expertUid.hashCode ^
        transactionID.hashCode ^
        meetingStatus.hashCode ^
        clientUid.hashCode;
  }
}
