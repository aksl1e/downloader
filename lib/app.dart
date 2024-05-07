import 'package:flutter/material.dart';

import 'downloader/downloader.dart';

class App extends MaterialApp {
  const App({super.key}) : super(home: const DownloaderPage(), debugShowCheckedModeBanner: false);
}