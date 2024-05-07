import 'package:equatable/equatable.dart';

final class Download extends Equatable {
  const Download({required this.id, required this.url, required this.fileName});

  final int id;
  final String url;
  final String fileName;

  @override
  List<Object> get props => [id, url, fileName];
}