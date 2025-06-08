class NotificationModel {
  final String id;
  final String userId; // Who receives the notification
  final String senderId; // Who triggered the notification
  final String type; // like, comment, message, upvote, milestone, etc.
  final String? postId;
  final String? showcaseId;
  final String? messageId;
  final String title;
  final String body;
  final bool isRead;
  final DateTime createdAt;
  final Map<String, dynamic>? extraData;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.senderId,
    required this.type,
    this.postId,
    this.showcaseId,
    this.messageId,
    required this.title,
    required this.body,
    this.isRead = false,
    required this.createdAt,
    this.extraData,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'senderId': senderId,
      'type': type,
      'postId': postId,
      'showcaseId': showcaseId,
      'messageId': messageId,
      'title': title,
      'body': body,
      'isRead': isRead,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'extraData': extraData,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      senderId: map['senderId'] ?? '',
      type: map['type'] ?? '',
      postId: map['postId'],
      showcaseId: map['showcaseId'],
      messageId: map['messageId'],
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      isRead: map['isRead'] ?? false,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      extraData: map['extraData'] != null
          ? Map<String, dynamic>.from(map['extraData'])
          : null,
    );
  }
}
