part of 'downloader_bloc.dart';


enum DownloadStatus { initial, downloading, paused, completed, canceled, failed }

final class DownloaderState extends Equatable {
  const DownloaderState({
    this.status = DownloadStatus.initial,
    this.url = '',
    this.destFolder = '',
    this.message = '',
    this.download = const Download(),
  });

  final DownloadStatus status;
  final String url;
  final String destFolder;
  final String message;
  final Download download;

  DownloaderState copyWith({
    DownloadStatus? status,
    String? url,
    String? destFolder,
    String? message,
    Download? download,
  }) {
    return DownloaderState(
      status: status ?? this.status,
      url: url ?? this.url,
      destFolder: destFolder ?? this.destFolder,
      message: message ?? this.message,
      download: download ?? this.download,
    );
  }

  @override
  List<Object> get props => [status, url, destFolder, message, download];
}

