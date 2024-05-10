import 'package:equatable/equatable.dart';

final class Download extends Equatable {
  const Download({
    this.id = '',
    this.url = '',
    this.progress = 0,
    this.timeRemainingAsString = '',
  });

  final String id;
  final String url;
  final double progress;
  final String timeRemainingAsString;

  Download copyWith(
    String? id,
    String? url,
    double? progress,
    String? timeRemainingAsString
  ) {
    return Download(
      id: id ?? this.id,
      url: url ?? this.url,
      progress: progress ?? this.progress,
      timeRemainingAsString: timeRemainingAsString ?? this.timeRemainingAsString,
    );
  }

  @override
  List<Object> get props => [id, url, progress, timeRemainingAsString];
}