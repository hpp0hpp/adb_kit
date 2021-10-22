import 'package:adb_tool/app/modules/developer_tool/foundation/adb_channel.dart';
import 'package:adb_tool/themes/app_colors.dart';
import 'package:adb_tool/utils/plugin_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:global_repository/global_repository.dart';
import 'package:path/path.dart' as p;

class InstallApkDialog extends StatefulWidget {
  const InstallApkDialog({
    Key key,
    this.paths,
    @required this.adbChannel,
  }) : super(key: key);
  final List<String> paths;
  final ADBChannel adbChannel;

  @override
  _InstallApkDialogState createState() => _InstallApkDialogState();
}

class _InstallApkDialogState extends State<InstallApkDialog> {
  String currentFile = '';
  double progress = 1;
  @override
  void initState() {
    super.initState();
    push();
  }

  Future<void> push() async {
    PluginUtil.addHandler((call) {
      if (call.method == 'Progress') {
        Log.e('Progress -> ${call.arguments}');
        progress = (call.arguments as int) / 100.0;
        setState(() {});
      }
    });
    for (final String path in widget.paths) {
      final String name = p.basename(path);
      currentFile = name;
      setState(() {});
      await widget.adbChannel.install(path);
      // showToast('$name 已上传');
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        borderRadius: BorderRadius.circular(12.w),
        child: SizedBox(
          width: 300.w,
          height: 64.w,
          child: Padding(
            padding: EdgeInsets.all(8.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '上传 $currentFile 中...',
                  style: TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.w,
                  ),
                ),
                SizedBox(
                  height: 12.w,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.w),
                  child: LinearProgressIndicator(
                    value: progress,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}