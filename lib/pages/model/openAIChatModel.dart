
class OpenAIChatModel {
  String role;
  String content;

  OpenAIChatModel({
    required this.content,
    required this.role,
  });

  // Convert an instance to a JSON map
  Map<String, String> toJson() {
    return {
      'role': role,
      'content': content,
    };
  }
  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'role': role,
      // Add other fields here
    };
  }

  factory OpenAIChatModel.fromMap(Map<String, dynamic> map) {
    return OpenAIChatModel(
      content: map['content'],
      role: map['role'],
      // Parse other fields here
    );
  }
}