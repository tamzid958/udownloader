import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:ext_storage/ext_storage.dart';
import 'dart:io';

var yt = YoutubeExplode();
double statistics = 0.0;
String filename1 = '';
void logCallback(int level, double message) {
  statistics = message;
}

extractvideo(url) async {
  url.trim();

  var storageperm = Permission.storage;
  await storageperm.request();

  // Save the video to the download directory.
  var dir = await ExtStorage.getExternalStoragePublicDirectory(
      ExtStorage.DIRECTORY_DOWNLOADS);

  print(dir);
  // Get video metadata.
  var video = await yt.videos.get(url);

  // Get the video manifest.
  var manifest = await yt.videos.streamsClient.getManifest(url);
  var streams = manifest.muxed;

  // Get the audio track with the highest bitrate.
  var audio = streams.withHighestBitrate();
  var audioStream = yt.videos.streamsClient.get(audio);

  // Compose the file name removing the unallowed characters in windows.
  var fileName = '${video.title}.${audio.container.name.toString()}'
      .replaceAll(r'\', '')
      .replaceAll('/', '')
      .replaceAll('*', '')
      .replaceAll('?', '')
      .replaceAll('"', '')
      .replaceAll('<', '')
      .replaceAll('>', '')
      .replaceAll('|', '');
  var file = File('$dir/$fileName');

  // Delete the file if exists.
  if (file.existsSync()) {
    file.deleteSync();
  }

  // Open the file in writeAppend.
  // ignore: close_sinks
  var output = file.openWrite(mode: FileMode.writeOnlyAppend);

  // Track the file download status.
  double len = audio.size.totalBytes.toDouble();
  double count = 0;

  filename1 = 'Downloading ${video.title}.${audio.container.name}';
  // Listen for data received.
  await for (var data in audioStream) {
    // Keep track of the current downloaded data.
    count += data.length.toDouble();

    // Calculate the current progress.

    double progress = ((count / len) / 1);
    // Update the progressbar.
    logCallback(100, progress);

    // Write to file.
    output.add(data);
  }
}

extractaudio(url) async {
  url.trim();
  var storageperm = Permission.storage;
  await storageperm.request();
  // Save the video to the download directory.
  var dir = await ExtStorage.getExternalStoragePublicDirectory(
      ExtStorage.DIRECTORY_DOWNLOADS);
  print(dir);
  // Get video metadata.
  var video = await yt.videos.get(url);

  // Get the video manifest.
  var manifest = await yt.videos.streamsClient.getManifest(url);
  var streams = manifest.audioOnly;

  // Get the audio track with the highest bitrate.
  var audio = streams.withHighestBitrate();
  var audioStream = yt.videos.streamsClient.get(audio);

  // Compose the file name removing the unallowed characters in windows.
  var fileName = '${video.title}.${audio.container.name.toString()}'
      .replaceAll(r'\', '')
      .replaceAll('/', '')
      .replaceAll('*', '')
      .replaceAll('?', '')
      .replaceAll('"', '')
      .replaceAll('<', '')
      .replaceAll('>', '')
      .replaceAll('|', '')
      .replaceAll(' ', "_");

  var file = File('$dir/$fileName');

  // Delete the file if exists.
  if (file.existsSync()) {
    file.deleteSync();
  }

  // Open the file in writeAppend.

  // ignore: close_sinks
  var output = file.openWrite(mode: FileMode.writeOnlyAppend);

  // Track the file download status.
  double len = audio.size.totalBytes.toDouble();
  double count = 0;

  filename1 = 'Downloading ${video.title}.${audio.container.name}';
  // Listen for data received.
  await for (var data in audioStream) {
    // Keep track of the current downloaded data.
    count += data.length.toDouble();

    // Calculate the current progress.

    double progress = ((count / len) / 1);
    // Update the progressbar.
    logCallback(100, progress);

    // Write to file.
    output.add(data);
  }
}
