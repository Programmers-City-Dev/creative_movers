import 'dart:convert';

FaqsResponse faqsResponseFromJson(String str) =>
    FaqsResponse.fromJson(json.decode(str));

String faqsResponseToJson(FaqsResponse data) => json.encode(data.toJson());

class FaqsResponse {
  FaqsResponse({
    required this.status,
    required this.faqs,
  });

  String status;
  List<Faq> faqs;

  FaqsResponse copyWith({
    String? status,
    List<Faq>? faqs,
  }) =>
      FaqsResponse(
        status: status ?? this.status,
        faqs: faqs ?? this.faqs,
      );

  factory FaqsResponse.fromJson(Map<String, dynamic> json) => FaqsResponse(
        status: json["status"],
        faqs: List<Faq>.from(json["faqs"].map((x) => Faq.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "faqs": List<dynamic>.from(faqs.map((x) => x.toJson())),
      };
}

class Faq {
  Faq({
    required this.id,
    required this.question,
    required this.answer,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String question;
  String answer;
  DateTime createdAt;
  DateTime updatedAt;

  Faq copyWith({
    int? id,
    String? question,
    String? answer,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Faq(
        id: id ?? this.id,
        question: question ?? this.question,
        answer: answer ?? this.answer,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Faq.fromJson(Map<String, dynamic> json) => Faq(
        id: json["id"],
        question: json["question"],
        answer: json["answer"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "question": question,
        "answer": answer,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
