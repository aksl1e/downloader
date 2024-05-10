import 'dart:async';

import 'package:background_downloader/background_downloader.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:path/path.dart';

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
    on<DownloadPaused>(_onDownloadPaused);
    on<DownloadResumed>(_onDownloadResumed);
  }

  void _specifyDownloadListener() {
    FileDownloader().updates.listen((update) {
      switch (update) {
        case TaskStatusUpdate():
          switch (update.status) {
            case TaskStatus.complete:
              print('Task ${update.task.taskId} success!');

            case TaskStatus.paused:
              add(DownloadPaused());

            case TaskStatus.canceled:
              add(DownloadCanceled());

            default:
              print('Download not successful');
          }

        case TaskProgressUpdate():
          add(DownloadProgressed(update.progress, update.timeRemainingAsString));
      }
    });
  }

  FutureOr<void> _onDownloadStarted(DownloadStarted event, Emitter<DownloaderState> emit) async {
    var downloadTask = DownloadTask(
      url: state.url,
      directory: 'C:/Users/aksl1e/Downloads',
      filename: basename(state.download.url),
      updates: Updates.statusAndProgress,
      allowPause: true,
    );

    await FileDownloader().enqueue(downloadTask);

    emit(state.copyWith(
      status: DownloadStatus.downloading,
      download: Download(
        id: downloadTask.taskId,
        url: state.url,
      ),
    ));
  }

  FutureOr<void> _onDownloadLinkChanged(DownloadLinkChanged event, Emitter<DownloaderState> emit) {
    emit(state.copyWith(
      url: event.url,
    ));
  }

  FutureOr<void> _onDownloadProgressed(DownloadProgressed event, Emitter<DownloaderState> emit) {
    emit(state.copyWith(
      download: Download(
        progress: event.progress,
        timeRemainingAsString: event.timeRemainingAsString,
      ),
    ));
  }

  FutureOr<void> _onDownloadCancelSubmitted(DownloadCancelSubmitted event, Emitter<DownloaderState> emit) async {
    await FileDownloader().cancelTaskWithId(state.download.id);
    
    emit(state.copyWith(
      status: DownloadStatus.canceled,
    ));
  }

  FutureOr<void> _onDownloadCanceled(DownloadCanceled event, Emitter<DownloaderState> emit) {
    emit(state.copyWith(
      status: DownloadStatus.initial,
      download: Download(),
    ));
  }

  FutureOr<void> _onDownloadPaused(DownloadPaused event, Emitter<DownloaderState> emit) async {
    await FileDownloader().pause(DownloadTask(
      url: state.download.url,
      directory: 'C:/Users/aksl1e/Downloads',
      filename: basename(state.download.url),
      updates: Updates.statusAndProgress,
      allowPause: true,
      taskId: state.download.id
    ));

    emit(state.copyWith(
      status: DownloadStatus.paused,
    ));
  }

  FutureOr<void> _onDownloadResumed(DownloadResumed event, Emitter<DownloaderState> emit) async {
    await FileDownloader().resume(DownloadTask(
        url: state.download.url,
        directory: 'C:/Users/aksl1e/Downloads',
        filename: basename(state.download.url),
        updates: Updates.statusAndProgress,
        allowPause: true,
        taskId: state.download.id
    ));

    emit(state.copyWith(
      status: DownloadStatus.downloading,
    ));
  }


}
