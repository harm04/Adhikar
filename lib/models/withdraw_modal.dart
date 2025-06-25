class WithdrawModal {
  final String amount;
  final String upiId;
  final String status;

  final String uid;
  final String id;

  final DateTime createdAt;

  WithdrawModal({
    required this.amount,
    required this.upiId,
    required this.uid,
    required this.status,
    required this.id,

    required this.createdAt,
  });

  WithdrawModal copyWith({
    String? upiId,
    String? amount,
    String? status,
    String? uid,
    String? id,

    DateTime? createdAt,
  }) {
    return WithdrawModal(
      amount: amount ?? this.amount,
      status: status ?? this.status,
      upiId: upiId ?? this.upiId,

      uid: uid ?? this.uid,
      id: id ?? this.id,

      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'amount': amount,
      'status': status,
      'upiId': upiId,
      'uid': uid,

      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory WithdrawModal.fromMap(Map<String, dynamic> map) {
    return WithdrawModal(
      amount: map['amount'] as String,
      status: map['status'] as String,

      uid: map['uid'] as String,
      id: map['\$id'] as String,
      upiId: map['upiId'] as String,

      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }

  @override
  String toString() {
    return 'PostModel(amount: $amount,status:$status, upiId: $upiId,uid: $uid, id: $id, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant WithdrawModal other) {
    if (identical(this, other)) return true;

    return other.amount == amount &&
        other.status == status &&
        other.upiId == upiId &&
        other.uid == uid &&
        other.id == id &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return amount.hashCode ^
        status.hashCode ^
        upiId.hashCode ^
        uid.hashCode ^
        id.hashCode ^
        createdAt.hashCode;
  }
}
