import 'package:downloader/downloader/bloc/downloader_bloc.dart';
import 'package:downloader/downloader/view/downloader_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DownloaderPage extends StatelessWidget {
  const DownloaderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Downloader',
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
            color: Theme.of(context).colorScheme.onPrimary
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: BlocProvider<DownloaderBloc>(
        create: (BuildContext context) => DownloaderBloc(),
        child: const DownloaderView(),
      ),
    );
  }
}
