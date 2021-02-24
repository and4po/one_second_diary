import 'package:get/get.dart';
import 'package:one_second_diary/utils/shared_preferences_util.dart';
import 'package:one_second_diary/utils/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' as io;

class StorageController extends GetxController {
  @override
  void onInit() {
    print('started storage controller');
    _getStoragePermission();
    _createFolder();

    super.onInit();
  }

  void _getStoragePermission() async {
    await Utils.requestPermission(Permission.storage);
  }

  void _createFolder() async {
    try {
      io.Directory directory;
      directory = await getExternalStorageDirectory();
      //print('First directory path: ' + directory.path);

      String appPath = '';

      List<String> folders = directory.path.split('/');
      for (int i = 1; i < folders.length; i++) {
        String folder = folders[i];
        if (folder != "Android") {
          appPath += "/" + folder;
        } else {
          break;
        }
      }

      appPath = appPath + "/OneSecondDiary/";
      directory = io.Directory(appPath);

      StorageUtil.putString('appPath', appPath);

      Utils().logInfo('APP PATH: $appPath');

      if (!await directory.exists()) {
        print("Directory does not exist");
        await directory.create(recursive: true);
        print("Directory created");
        print('Final Directory path: ' + directory.path);
      } else {
        print("Directory already exists");
      }
    } catch (e) {
      print('$e');
    }
  }
}
