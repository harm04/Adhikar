// ignore_for_file: public_member_api_docs, sort_constructors_first

class TransactionModel {
  final String id;
  final String paymentID;
  final DateTime createdAt;
  final String paymentStatus;
  final String paymentDescription;
  final String clientPhone;
  final int amount;
  final String clientUid;
  final String expertUid;

  TransactionModel({
    required this.id,
    required this.paymentID,
    required this.paymentStatus,
    required this.amount,
    required this.paymentDescription,
    required this.clientUid,
    required this.expertUid,
    required this.createdAt,
    required this.clientPhone,
  });

  TransactionModel copyWith({
    DateTime? createdAt,
    String? clientPhone,
    String? expertUid,
    String? clientUid,
    int? amount, // fixed type
    String? id,
    String? paymentID,
    String? paymentStatus,
    String? paymentDescription,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      paymentID: paymentID ?? this.paymentID,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentDescription: paymentDescription ?? this.paymentDescription,
      createdAt: createdAt ?? this.createdAt,
      clientPhone: clientPhone ?? this.clientPhone,
      expertUid: expertUid ?? this.expertUid,
      clientUid: clientUid ?? this.clientUid,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'paymentID': paymentID,
      'paymentStatus': paymentStatus,
      'paymentDescription': paymentDescription,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'clientPhone': clientPhone,
      'expertUid': expertUid,
      'clientUid': clientUid,
      'amount': amount,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['\$id'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      clientPhone: map['clientPhone'] as String,
      expertUid: map['expertUid'] as String,
      clientUid: map['clientUid'] as String,
      paymentID: map['paymentID'] as String,
      paymentStatus: map['paymentStatus'] as String? ?? 'pending',
      paymentDescription: map['paymentDescription'] as String,
      amount: map['amount'] as int,
    );
  }

  @override
  String toString() {
    return 'TransactionModel(id: $id, paymentStatus: $paymentStatus, paymentDescription: $paymentDescription, paymentID: $paymentID, createdAt: $createdAt, clientPhone: $clientPhone, clientUid: $clientUid, expertUid: $expertUid, amount: $amount)';
  }

  @override
  bool operator ==(covariant TransactionModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.createdAt == createdAt &&
        other.clientPhone == clientPhone &&
        other.expertUid == expertUid &&
        other.clientUid == clientUid &&
        other.paymentID == paymentID &&
        other.paymentStatus == paymentStatus &&
        other.paymentDescription == paymentDescription &&
        other.amount == amount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        createdAt.hashCode ^
        clientPhone.hashCode ^
        expertUid.hashCode ^
        paymentDescription.hashCode ^
        paymentStatus.hashCode ^
        paymentID.hashCode ^
        clientUid.hashCode ^
        amount.hashCode;
  }
}
