part of 'downloader_bloc.dart';

sealed class DownloaderEvent extends Equatable {
  const DownloaderEvent();
  @override
  List<Object> get props => [];
}

final class DownloadLinkChanged extends DownloaderEvent {
  const DownloadLinkChanged(this.url);

  final String url;

  @override
  List<Object> get props => [url];
}

final class DownloadStarted extends DownloaderEvent {}
final class DownloadCompleted extends DownloaderEvent {}
final class DownloadProgressed extends DownloaderEvent {
  const DownloadProgressed(this.progress, this.timeRemainingAsString);

  final double progress;
  final String timeRemainingAsString;

  @override
  List<Object> get props => [progress, timeRemainingAsString];
}
final class DownloadPauseSubmitted extends DownloaderEvent {}
final class DownloadPaused extends DownloaderEvent {}
final class DownloadCancelSubmitted extends DownloaderEvent {}
final class DownloadCanceled extends DownloaderEvent {}
final class DownloadResumed extends DownloaderEvent {}
