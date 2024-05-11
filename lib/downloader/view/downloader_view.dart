import 'package:downloader/downloader/widgets/AnimatedDownloadingText.dart';
import 'package:downloader/downloader/widgets/StatusRow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/downloader_bloc.dart';

class DownloaderView extends StatelessWidget {
  const DownloaderView({
    this.downloadingKey = const Key('downloadingKey'),
    this.pausedKey = const Key('pausedKey'),
    super.key
  });

  final Key downloadingKey;
  final Key pausedKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(150, 100, 150, 100),
      child: BlocBuilder<DownloaderBloc, DownloaderState>(
        builder: (context, state) {
          switch (state.status) {
            case DownloadStatus.initial:
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Enter your link here",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  TextField(
                    onChanged:(text) => context
                        .read<DownloaderBloc>()
                        .add(DownloadLinkChanged(text)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Destination Path: ${context.read<DownloaderBloc>().state.destFolder}',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      FloatingActionButton.extended(
                        label: Text('Select'),
                        icon: Icon(
                          Icons.folder
                        ),
                        onPressed: () =>
                          context.read<DownloaderBloc>().add(DownloadFolderSelectClicked()),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FloatingActionButton.extended(
                        label: Text('Download'),
                        icon: Icon(
                          Icons.download
                        ),
                        onPressed: () =>
                            context.read<DownloaderBloc>().add(DownloadStarted()),
                      )
                    ],
                  )
                ],
              );
            case DownloadStatus.downloading:
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AnimatedDownloadingText('Downloading...', downloadingKey),
                  StatusRow(
                    context.read<DownloaderBloc>().state.download.progress,
                    context.read<DownloaderBloc>().state.download.timeRemainingAsString,
                  ),
                  LinearProgressIndicator(
                    value: context.watch<DownloaderBloc>().state.download.progress,
                    minHeight: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FloatingActionButton(
                        child: Icon(
                          Icons.pause
                        ),
                        onPressed: () =>
                          context.read<DownloaderBloc>().add(DownloadPauseSubmitted()),
                      ),
                      FloatingActionButton(
                        child: Icon(
                            Icons.cancel
                        ),
                        onPressed: () =>
                            context.read<DownloaderBloc>().add(DownloadCancelSubmitted()),
                      )
                    ],
                  )
                ]
              );
            case DownloadStatus.completed:
             WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
               ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(content: Text('Download has completed!'))
               );
             });
             return const SizedBox();
            case DownloadStatus.canceled:
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Download has been canceled!'))
                );
              });
              return const SizedBox();
            case DownloadStatus.failed:
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Download has failed! - ${context.read<DownloaderBloc>().state.message}'),
                      showCloseIcon: true,
                      duration: Duration(seconds: 15),
                    )
                );
              });
              return const SizedBox();
            case DownloadStatus.paused:
              return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AnimatedDownloadingText('Paused...', pausedKey),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        FloatingActionButton(
                          child: Icon(
                              Icons.play_circle
                          ),
                          onPressed: () =>
                              context.read<DownloaderBloc>().add(DownloadResumed()),
                        ),
                        FloatingActionButton(
                          child: Icon(
                              Icons.cancel
                          ),
                          onPressed: () =>
                              context.read<DownloaderBloc>().add(DownloadCancelSubmitted()),
                        )
                      ],
                    )
                  ]
              );
            default:
              return Text('Unspecified Error occurred!');
          }
        },
      ),
    );
  }
}
