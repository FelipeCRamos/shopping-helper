import 'package:uuid/v4.dart';

class Codable {
  final String id;

  Codable({String? id}) : id = id ?? const UuidV4().generate();

  factory Codable.fromJson(Map<String, dynamic> json) =>
      Codable(id: json['id']);

  Map<String, dynamic> toJson() => {'id': id};
}
