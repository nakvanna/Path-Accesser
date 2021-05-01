import 'dart:io';

import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PathAccessingController extends GetxController {
  @override
  void onInit() async {
    PermissionStatus status = await Permission.storage.status;
    if (status.isDenied) {
      await Permission.storage
          .request()
          .then((value) => print('Permission granted!'));
    }
    super.onInit();
  }

  List<Map<String, dynamic>>? getDirectories(String path) {
    Directory directory = Directory(path);
    getNameFromPath(String path) {
      List list = path.split('/');
      return list.last;
    }

    Map<String, dynamic> fileOrDir(
        {required String name, required String path, required bool isFile}) {
      return {'name': name, 'path': path, 'isFile': isFile};
    }

    List<Map<String, dynamic>>? _list = [];
    try {
      List<FileSystemEntity> dirList = directory.listSync();
      for (int i = 0; i < dirList.length; i++) {
        FileSystemEntity f = dirList[i];
        if (f is File) {
          _list.add(
            fileOrDir(
              name: getNameFromPath(f.path),
              path: f.path,
              isFile: true,
            ),
          );
        } else if (f is Directory) {
          _list.add(
            fileOrDir(
              name: getNameFromPath(f.path),
              path: f.path,
              isFile: false,
            ),
          );
        }
      }
      return _list;
    } catch (e) {
      print('Get directories error $e');
    }
  }

  ///Convert path to file
  pathToFile(String path) {
    return File(path);
  }

  ///Get file size
  fileSize(String path) {
    File file = File(path);
    return (file.lengthSync() / 1024);
  }

  ///Rename file
  renameFile(String path, String nameOnly) async {
    try {
      List<String> _list = path.split('/');
      String oldName = _list.removeLast();
      String extension = oldName.split('.').last;
      String pathOnly = _list.join('/');

      File file = pathToFile(path);
      await file
          .rename('$pathOnly/$nameOnly.$extension')
          .then((value) => print('File rename: $value'));
    } catch (e) {
      print('Rename file error $e');
    }
  }

  ///Rename folder
  renameFolder(String oldPath, String newName) {
    Directory directory = Directory(oldPath).renameSync(newName);
    print(directory.path);
  }

  ///Create folder
  createFolder(String path) async {
    Directory directory = await Directory(path).create(recursive: true);
    print(directory.path);
  }

  ///Get last path
  lastPath(String path) {
    List _list = path.split('/');
    _list.removeLast();
    return _list.join('/');
  }

  ///Split file or directory from full path
  fileOrDir(String path) {
    return path.split('/').last;
  }
}
