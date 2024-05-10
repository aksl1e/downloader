import 'package:background_downloader/background_downloader.dart';
import 'package:equatable/equatable.dart';

final class Download extends Equatable {
  const Download({
    this.downloadTask = null,
    this.progress = 0,
    this.timeRemainingAsString = '',
  });

  final DownloadTask? downloadTask;
  final double progress;
  final String timeRemainingAsString;

  Download copyWith({
    DownloadTask? downloadTask,
    double? progress,
    String? timeRemainingAsString
  }) {
    return Download(
      downloadTask: downloadTask ?? this.downloadTask,
      progress: progress ?? this.progress,
      timeRemainingAsString: timeRemainingAsString ?? this.timeRemainingAsString,
    );
  }

  @override
  List<Object> get props => [progress, timeRemainingAsString];
}