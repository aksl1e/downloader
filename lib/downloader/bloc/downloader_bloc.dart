import 'dart:async';

import 'package:background_downloader/background_downloader.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../models/models.dart';

part 'downloader_event.dart';
part 'downloader_state.dart';

class DownloaderBloc extends Bloc<DownloaderEvent, DownloaderState> {
  DownloaderBloc() : super(const DownloaderState()) {
    _specifyDownloadListener();

    on<DownloadStarted>(_onDownloadStarted);
    on<DownloadLinkChanged>(_onDownloadLinkChanged);
    on<DownloadProgressed>(_onDownloadProgressed);
    on<DownloadCancelSubmitted>(_onDownloadCancelSubmitted);
    on<DownloadCanceled>(_onDownloadCanceled);
    on<DownloadPauseSubmitted>(_onDownloadPauseSubmitted);
    on<DownloadPaused>(_onDownloadPaused);
    on<DownloadResumed>(_onDownloadResumed);
    on<DownloadCompleted>(_onDownloadCompleted);
  }

  void _specifyDownloadListener() {
    FileDownloader().updates.listen((update) {
      switch (update) {
        case TaskStatusUpdate():
          switch (update.status) {
            case TaskStatus.complete:
              add(DownloadCompleted());
              print("complete");

            case TaskStatus.paused:
              add(DownloadPaused());
              print("pause");

            case TaskStatus.canceled:
              add(DownloadCanceled());
              print("canceled");
            case TaskStatus.failed:
              print('failed');
            default:
              print('Default');
          }

        case TaskProgressUpdate():
          add(DownloadProgressed(update.progress, update.timeRemainingAsString));
          print("progressed");
      }
    });
  }

  FutureOr<void> _onDownloadStarted(DownloadStarted event, Emitter<DownloaderState> emit) async {
    print(state.url);
    var downloadsDirectory = await getDownloadsDirectory();

    emit(state.copyWith(
      status: DownloadStatus.downloading,
      download: Download(
        downloadTask: DownloadTask(
          url: state.url,
          directory: downloadsDirectory!.path, // TODO - MAKE A FOLDER SELECTION!
          filename: basename(state.url),
          updates: Updates.statusAndProgress,
          allowPause: true,
        ),
      ),
    ));

    await FileDownloader().enqueue(state.download.downloadTask!);
  }

  FutureOr<void> _onDownloadLinkChanged(DownloadLinkChanged event, Emitter<DownloaderState> emit) {
    emit(state.copyWith(
      url: event.url,
    ));
    print('changed! ${state.url}');
  }

  FutureOr<void> _onDownloadProgressed(DownloadProgressed event, Emitter<DownloaderState> emit) {
    if(state.status != DownloadStatus.paused)
    emit(state.copyWith(
      download: state.download.copyWith(
        progress: event.progress,
        timeRemainingAsString: event.timeRemainingAsString,
      ),
    ));
  }

  FutureOr<void> _onDownloadCancelSubmitted(DownloadCancelSubmitted event, Emitter<DownloaderState> emit) {
    emit(state.copyWith(
      status: DownloadStatus.canceled,
    ));

    FileDownloader().cancelTaskWithId(state.download.downloadTask!.taskId);
  }

  FutureOr<void> _onDownloadCanceled(DownloadCanceled event, Emitter<DownloaderState> emit) {
    emit(state.copyWith(
      status: DownloadStatus.initial,
      url: '',
      download: Download(),
    ));
  }

  FutureOr<void> _onDownloadPauseSubmitted(DownloadPauseSubmitted event, Emitter<DownloaderState> emit) async {
    await FileDownloader().pause(state.download.downloadTask!);
  }

  FutureOr<void> _onDownloadPaused(DownloadPaused event, Emitter<DownloaderState> emit) {
    emit(state.copyWith(
      status: DownloadStatus.paused,
    ));
  }

  FutureOr<void> _onDownloadResumed(DownloadResumed event, Emitter<DownloaderState> emit) async {
    await FileDownloader().resume(state.download.downloadTask!);

    emit(state.copyWith(
      status: DownloadStatus.downloading,
    ));
  }

  FutureOr<void> _onDownloadCompleted(DownloadCompleted event, Emitter<DownloaderState> emit) async {
    emit(state.copyWith(
      status: DownloadStatus.completed,
      url: '',
      download: Download(),
    ));
    await Future.delayed(Duration(milliseconds: 10));
    emit(state.copyWith(
      status: DownloadStatus.initial,
      url: '',
      download: Download(),
    ));
  }
}
