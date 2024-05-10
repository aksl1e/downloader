import 'package:downloader/downloader/widgets/AnimatedDownloadingText.dart';
import 'package:downloader/downloader/widgets/StatusRow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/downloader_bloc.dart';

class DownloaderView extends StatelessWidget {
  const DownloaderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(150, 100, 150, 100),
      child: BlocBuilder<DownloaderBloc, DownloaderState>(
        buildWhen: (prev, state) => prev.status != state.status,
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FloatingActionButton(
                        child: Icon(
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
                  AnimatedDownloadingText(),
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
                          context.read<DownloaderBloc>().add(DownloadPaused()),
                      )
                    ],
                  )
                ]
              );
            case DownloadStatus.completed:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Download has completed!'))
              );
              return const SizedBox();
            case DownloadStatus.canceled:
              return Text('Unspecified Error occurred!');
            case DownloadStatus.paused:
              return Text('Unspecified Error occurred!');
            default:
              return Text('Unspecified Error occurred!');
          }
        },
      ),
    );
  }
}
