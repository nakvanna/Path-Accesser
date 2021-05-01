import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:path_accesser/pages/controllers/path_accessing_controller.dart';

class PathAccessingUI extends GetView<PathAccessingController> {
  @override
  Widget build(BuildContext context) {
    ///Root path to go first at initialize time.
    String _goToPath = '/storage/emulated/0';

    ///GetX reactive variable.
    RxString _title = 'Directory'.obs;
    Rx<List<Map<String, dynamic>>> _directoryList =
        Rx<List<Map<String, dynamic>>>([]);

    ///Normal

    ///TextEditingController.
    TextEditingController _folderName = TextEditingController();
    TextEditingController _folderNewName = TextEditingController();

    return GetBuilder<PathAccessingController>(
      initState: (_) {
        try {
          _directoryList.value = controller.getDirectories(_goToPath)!;
        } catch (e) {
          print('Init error $e');
        }
      },
      builder: (ctrl) {
        ///Go to directory
        _openDirectory(String _goToPath) {
          _directoryList.value = ctrl.getDirectories(_goToPath)!;
        }

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                if (_goToPath == '/storage/emulated/0') {
                  Get.back();
                } else {
                  try {
                    _goToPath = ctrl.lastPath(_goToPath);
                    _openDirectory(_goToPath);

                    //Check conditional now just only work ft android emulator
                    // TODO for physical Device OR IOS
                    ctrl.fileOrDir(_goToPath) == '0'
                        ? _title.value = 'Directory'
                        : _title.value = ctrl.fileOrDir(_goToPath);
                  } catch (e) {
                    print('Go back error $e');
                  }
                }
              },
              icon: Icon(Icons.arrow_back),
            ),
            title: Obx(
              () {
                return Text(_title.value);
              },
            ),
            actions: [
              PopupMenuButton(
                child: Icon(Icons.app_registration),
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      child: ListTile(
                        onTap: () {
                          Navigator.pop(context);
                          Get.defaultDialog(
                            title: 'New Folder',
                            content: TextField(
                              autofocus: true,
                              controller: _folderName,
                              decoration: InputDecoration(
                                hintText: 'Folder name',
                              ),
                            ),
                            textConfirm: 'Ok',
                            textCancel: 'Cancel',
                            onCancel: () {
                              _folderName.text = '';
                            },
                            onConfirm: () async {
                              String pathCreate =
                                  '$_goToPath/${_folderName.text}';
                              Get.back();
                              await ctrl.createFolder(pathCreate);
                              _title.value = _folderName.text;
                              _openDirectory(pathCreate);
                              _folderName.text = '';
                            },
                          );
                        },
                        leading: Icon(Icons.create_new_folder),
                        title: Text('New Folder'),
                      ),
                    )
                  ];
                },
              )
            ],
          ),
          body: CustomScrollView(
            slivers: [
              Obx(
                () => SliverList(
                  delegate: SliverChildBuilderDelegate((_, int index) {
                    Map<String, dynamic> _mapDir = _directoryList.value[index];
                    return ListTile(
                      onTap: () {
                        if (_mapDir['isFile']) {
                          String filepath = _mapDir['path'];
                          String filename = filepath.split('/').last;
                          String fileExtension = filename.split('.').last;
                        } else {
                          try {
                            _directoryList.value =
                                ctrl.getDirectories(_mapDir['path'])!;
                            _title.value = _mapDir['name'];
                            _goToPath = _mapDir['path'];
                          } catch (e) {
                            print('This folder permission not allow!');
                          }
                        }
                      },
                      leading: _mapDir['isFile']
                          ? Image.file(
                              ctrl.pathToFile(_mapDir['path']),
                            )
                          : Icon(
                              Icons.folder_open,
                              size: 48,
                            ),
                      trailing: PopupMenuButton(
                          padding: EdgeInsets.all(0),
                          child: Icon(Icons.more_vert),
                          itemBuilder: (context) => <PopupMenuEntry<String>>[
                                PopupMenuItem(
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.pop(context);
                                      List _splitPath =
                                          '${_mapDir['path']}'.split('/');
                                      _splitPath.removeLast();
                                      String pathOnly = _splitPath.join('/');
                                      _folderNewName.text = _mapDir['name'];
                                      Get.defaultDialog(
                                          title: 'Rename',
                                          content: TextField(
                                            autofocus: true,
                                            controller: _folderNewName,
                                            decoration: InputDecoration(
                                              hintText: 'New name',
                                            ),
                                          ),
                                          textCancel: 'Cancel',
                                          textConfirm: 'Ok',
                                          onConfirm: () async {
                                            await ctrl.renameFolder(
                                                _mapDir['path'],
                                                '$pathOnly/${_folderNewName.text}');
                                            Get.back();
                                            _openDirectory(_goToPath);
                                          });
                                    },
                                    title: Text('Rename'),
                                  ),
                                ),
                                PopupMenuItem(
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    title: Text('Copy to...'),
                                  ),
                                ),
                                PopupMenuItem(
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    title: Text('Move to...'),
                                  ),
                                ),
                                PopupMenuDivider(),
                                PopupMenuItem(
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    title: Text('Delete'),
                                  ),
                                ),
                              ]),
                      title: Text('${_mapDir['name']}​'),
                      subtitle: _mapDir['isFile']
                          ? Text(
                              '${ctrl.fileSize(_mapDir['path']).toStringAsFixed(2)} KB')
                          : Container(),
                    );
                  }, childCount: _directoryList.value.length),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
