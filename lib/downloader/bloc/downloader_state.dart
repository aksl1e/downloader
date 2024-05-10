part of 'downloader_bloc.dart';


enum DownloadStatus { initial, downloading, paused, completed, canceled }

final class DownloaderState extends Equatable {
  const DownloaderState({
    this.status = DownloadStatus.initial,
    this.url = '',
    this.download = const Download(),
  });

  final DownloadStatus status;
  final String url;
  final Download download;

  DownloaderState copyWith({
    DownloadStatus? status,
    String? url,
    Download? download,
  }) {
    return DownloaderState(
      status: status ?? this.status,
      url: url ?? this.url,
      download: download ?? this.download,
    );
  }

  @override
  List<Object> get props => [status, url, download];
}

