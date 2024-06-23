
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
}