import 'package:uuid/v4.dart';

mixin Codable<T> {
  final String id = const UuidV4().generate();
  Map<String, dynamic> toJson();
}
