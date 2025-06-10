// ignore_for_file: public_member_api_docs, sort_constructors_first

class MeetingsModel {
  final String id;
  final DateTime createdAt;
  final String clientPhone;
  final String clientUid;
  final String expertUid;
  final String transactionID;
  final String meetingStatus;
  final String otp;

  MeetingsModel({
    required this.id,
    required this.createdAt,
    required this.clientPhone,
    required this.clientUid,
    required this.expertUid,
    required this.transactionID,
    required this.meetingStatus,
    required this.otp,
  });

  MeetingsModel copyWith({
    DateTime? createdAt,
    String? clientPhone,
    String? expertUid,
    String? clientUid,
    String? id,
    String? transactionID,
    String? meetingStatus,
    String? otp,
  }) {
    return MeetingsModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      clientPhone: clientPhone ?? this.clientPhone,
      expertUid: expertUid ?? this.expertUid,
      clientUid: clientUid ?? this.clientUid,
      transactionID: transactionID ?? this.transactionID,
      meetingStatus: meetingStatus ?? this.meetingStatus,
      otp: otp ?? this.otp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
    
      'createdAt': createdAt.millisecondsSinceEpoch,
      'clientPhone': clientPhone,
      'clientUid': clientUid,
      'expertUid': expertUid,
      'transactionID': transactionID,
      'meetingStatus': meetingStatus,
      'otp': otp,
    };
  }

  factory MeetingsModel.fromMap(Map<String, dynamic> map) {
    return MeetingsModel(
      id: map['\$id'] ?? map['id'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      clientPhone: map['clientPhone'],
      clientUid: map['clientUid'],
      expertUid: map['expertUid'],
      transactionID: map['transactionID'],
      meetingStatus: map['meetingStatus'],
      otp: map['otp'] ?? '',
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
