import 'dart:convert';

MessageModel messageModelFromJson(String str) =>
    MessageModel.fromJson(json.decode(str));

String messageModelToJson(MessageModel data) => json.encode(data.toJson());

class MessageModel {
  int id;
  String type;
  DateTime createdAt;
  String message;

  MessageModel({
    required this.id,
    required this.type,
    required this.createdAt,
    required this.message,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        id: json["id"],
        type: json["type"],
        createdAt: DateTime.parse(json["CreatedAt"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "CreatedAt": createdAt.toIso8601String(),
        "message": message,
      };
}
