import 'dart:io';

import 'package:crumbs/globals.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class LocalStorage extends ChangeNotifier {
  Future<String> get documentsDirectory async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> createFile(String filePath) async {
    final documentsDirectoryPath = await documentsDirectory;
    var routeFile = File('$documentsDirectoryPath/routes/$filePath.txt').create(recursive: true);
    routeFilesListener.value = getAllRouteFiles();
    notifyListeners();

    return routeFile;
  }

  Future<File> writeContent(String content, File file) async {
    return file.writeAsString(content);
  }

  Future<String> readContent(File file) async {
    try {
      String content = await file.readAsString();
      return content;
    } catch (e) {
      return 'Error';
    }
  }

  Future<List<File>> getAllRouteFiles() async {
    final documentsDir = await documentsDirectory;
    List<FileSystemEntity> entities = await Directory(documentsDir + '/routes/').list().toList();
    //Directory(documentsDir + '/routes/').delete(recursive: true);

    var statResults = await Future.wait([
      for (var entity in entities) FileStat.stat(entity.path),
    ]);

    var changedTimes = <String, DateTime>{
      for (var i = 0; i < entities.length; i++) entities[i].path: statResults[i].changed,
    };

    entities.sort((a, b) {
      return changedTimes[a.path]!.compareTo(changedTimes[b.path]!);
    });

    return entities.whereType<File>().toList();
  }
}
