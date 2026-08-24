import 'dart:io';

import 'package:flutter/material.dart' hide Key;
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soleoserp/models/common/globals.dart';
import 'package:soleoserp/repositories/custom_exception.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/widgets/common_widgets.dart';

Future navigateTo(BuildContext context, String routeName,
    {Object arguments,
    bool clearAllStack: false,
    bool clearSingleStack: false,
    bool useRootNavigator: false,
    String clearUntilRoute}) async {
  if (clearAllStack) {
    await Navigator.of(context, rootNavigator: useRootNavigator)
        .pushNamedAndRemoveUntil(routeName, (route) => false,
            arguments: arguments);
  } else if (clearSingleStack) {
    await Navigator.of(context, rootNavigator: useRootNavigator)
        .popAndPushNamed(routeName, arguments: arguments);
  } else if (clearUntilRoute != null) {
    await Navigator.of(context, rootNavigator: useRootNavigator)
        .pushNamedAndRemoveUntil(
            routeName, ModalRoute.withName(clearUntilRoute),
            arguments: arguments);
  } else {
    return await Navigator.of(context, rootNavigator: useRootNavigator)
        .pushNamed(routeName, arguments: arguments);
  }
}

Future<void> showCommonDialogWithTwoOptions(
  BuildContext context,
  String message, {
  String negativeButtonTitle = "Cancel",
  String positiveButtonTitle = "OK",
  bool useRootNavigator = true,
  GestureTapCallback onTapOfNegativeButton,
  GestureTapCallback onTapOfPositiveButton,
}) async {
  ThemeData baseTheme = Theme.of(context);

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context2) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: EdgeInsets.all(20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.info_outline, size: 40, color: colorPrimaryLight),
            SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: baseTheme.textTheme.subtitle1?.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: onTapOfNegativeButton ??
                        () {
                          Navigator.of(context, rootNavigator: useRootNavigator)
                              .pop();
                        },
                    child: Text(
                      negativeButtonTitle,
                      style: baseTheme.textTheme.button?.copyWith(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: onTapOfPositiveButton ??
                        () {
                          Navigator.of(context, rootNavigator: useRootNavigator)
                              .pop();
                        },
                    child: Text(
                      positiveButtonTitle,
                      style: baseTheme.textTheme.button?.copyWith(
                        color: colorPrimaryLight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

Future showCommonDialogWithSingleOption(
  BuildContext context,
  String message, {
  String positiveButtonTitle = "OK",
  GestureTapCallback onTapOfPositiveButton,
  bool useRootNavigator = true,
  EdgeInsetsGeometry margin: const EdgeInsets.only(left: 20, right: 20),
}) async {
  ThemeData baseTheme = Theme.of(context);

  await showDialog(
    context: context,
    builder: (context2) {
      return Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: colorWhite,
          ),
          width: double.maxFinite,
          margin: margin,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                constraints: BoxConstraints(minHeight: 100),
                padding: EdgeInsets.all(10),
                child: Center(
                  child: SingleChildScrollView(
                    child: Text(
                      message,
                      maxLines: 15,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: baseTheme.textTheme.button,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                child: getCommonDivider(),
              ),
              GestureDetector(
                child: Container(
                  height: 60,
                  color: Colors.transparent,
                  child: Center(
                    child: Text(
                      positiveButtonTitle,
                      textAlign: TextAlign.center,
                      style: baseTheme.textTheme.button
                          .copyWith(color: colorPrimaryLight),
                    ),
                  ),
                ),
                onTap: onTapOfPositiveButton ??
                    () {
                      Navigator.of(Globals.context).pop();
                      // Navigator.of(context, rootNavigator: true).pop();
                    },
              )
            ],
          ),
        ),
      );
    },
  );
}

bool shouldPaginate(dynamic scrollInfo,
    {AxisDirection axisDirection: AxisDirection.down}) {
  return scrollInfo is ScrollEndNotification &&
      scrollInfo.metrics.extentAfter == 0 &&
      scrollInfo.metrics.maxScrollExtent > 0 &&
      scrollInfo.metrics.axisDirection == axisDirection;
}

bool shouldPaginateFromController(ScrollController scrollController) {
  final maxScroll = scrollController.position.maxScrollExtent;
  final currentScroll = scrollController.offset;

  if (currentScroll >= (maxScroll * 0.9) &&
      scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
    return true;
  } else {
    return false;
  }
}

pickImage(
  BuildContext context, {
  @required Function(File f) onImageSelection,
}) {
  FocusScope.of(context).unfocus();
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text('Photo Library'),
                    onTap: () async {
                      Navigator.of(context).pop();
                      XFile capturedFile = await ImagePicker().pickImage(
                          source: ImageSource.gallery, imageQuality: 85);

                      if (capturedFile != null) {
                        onImageSelection(File(capturedFile.path));
                      }
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text('Camera'),
                  onTap: () async {
                    Navigator.of(context).pop();
                    XFile capturedFile = await ImagePicker().pickImage(
                        source: ImageSource.camera, imageQuality: 85);
                    if (capturedFile != null) {
                      onImageSelection(File(capturedFile.path));
                    }
                  },
                ),
              ],
            ),
          ),
        );
      });
}

MaterialPageRoute getMaterialPageRoute(Widget screen) {
  return MaterialPageRoute(
    builder: (context) {
      return screen;
    },
  );
}

bool viewvisiblitiyAsperClient({String SerailsKey, String RoleCode}) {
  if (SerailsKey.toLowerCase().toString() == "abcd-efgh-ijkl-mnow" ||
      SerailsKey.toLowerCase().toString() == "dol2-6uh7-ph03-in5h") {
    if (RoleCode.toLowerCase() == "admin") {
      return true;
    } else {
      return false;
    }
  } else {
    return true;
  }
}

Widget showCustomToast({String Title}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.black,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check, color: Colors.white),
        SizedBox(
          width: 12.0,
        ),
        Text(
          Title,
          style: TextStyle(color: Colors.white),
        ),
      ],
    ),
  );
}

pickMultipleImage(
  BuildContext context, {
  @required Function(File f) onImageSelection,
  @required Function(List<File> f) onMultipleImageSelection,
}) {
  FocusScope.of(context).unfocus();
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text('Photo Library'),
                    onTap: () async {
                      Navigator.of(context).pop();

                      final List<XFile> images =
                          await ImagePicker().pickMultiImage(imageQuality: 100);

                      List<File> fileList = [];
                      for (int i = 0; i < images.length; i++) {
                        fileList.add(File(images[i].path));
                      }

                      onMultipleImageSelection(fileList);
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text('Camera'),
                  onTap: () async {
                    Navigator.of(context).pop();
                    XFile capturedFile = await ImagePicker().pickImage(
                        source: ImageSource.camera, imageQuality: 100);

                    List<File> fileList = [];
                    fileList.add(File(capturedFile.path));
                    onMultipleImageSelection(fileList);

                    /*  if (capturedFile != null) {
                      onImageSelection(File(capturedFile.path));
                    }*/
                  },
                ),
              ],
            ),
          ),
        );
      });
}

String getUserFriendlyErrorMessage(dynamic exception) {
  if (exception is CustomException) {
    return exception.getUserFriendlyMessage();
  }
  return "Something went wrong. Please try again.";
}

Future<void> showUserFriendlyErrorDialog(
  BuildContext context,
  String message, {
  String technicalDetails,
  String positiveButtonTitle = "OK",
  bool useRootNavigator = true,
  GestureTapCallback onTapOfPositiveButton,
}) async {
  ThemeData baseTheme = Theme.of(context);
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context2) {
      bool _showDetails = false;
      return StatefulBuilder(
        builder: (context, setState) {
          return Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: colorWhite,
              ),
              width: double.maxFinite,
              margin: EdgeInsets.only(left: 20, right: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Icon(Icons.error_outline,
                                color: Colors.redAccent, size: 48),
                            SizedBox(height: 16),
                            Text(
                              message,
                              textAlign: TextAlign.center,
                              style: baseTheme.textTheme.subtitle1?.copyWith(
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (technicalDetails != null &&
                                technicalDetails.isNotEmpty) ...[
                              SizedBox(height: 16),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _showDetails = !_showDetails;
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "View Details",
                                      style: TextStyle(
                                        color: colorPrimaryLight,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Icon(
                                      _showDetails
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                      color: colorPrimaryLight,
                                    ),
                                  ],
                                ),
                              ),
                              if (_showDetails) ...[
                                SizedBox(height: 8),
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    technicalDetails,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                    child: getCommonDivider(),
                  ),
                  Container(
                    height: 60,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            child: Container(
                              color: Colors.transparent,
                              child: Center(
                                child: Text(
                                  positiveButtonTitle,
                                  textAlign: TextAlign.center,
                                  style: baseTheme.textTheme.button
                                      ?.copyWith(color: colorPrimaryLight),
                                ),
                              ),
                            ),
                            onTap: onTapOfPositiveButton ??
                                () {
                                  Navigator.of(context,
                                          rootNavigator: useRootNavigator)
                                      .pop();
                                },
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

Future showAPINetworkErrorDialog(BuildContext context, String message,
    {String positiveButtonTitle = "OK",
    String errortext,
    bool useRootNavigator = true,
    GestureTapCallback onTapOfPositiveButton}) async {
  return showUserFriendlyErrorDialog(
    context,
    message,
    technicalDetails: errortext,
    positiveButtonTitle: positiveButtonTitle,
    useRootNavigator: useRootNavigator,
    onTapOfPositiveButton: onTapOfPositiveButton,
  );
}

int parseInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String && value.isNotEmpty) return int.tryParse(value) ?? 0;
  return 0;
}

double parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String && value.isNotEmpty) return double.tryParse(value) ?? 0.0;
  return 0.0;
}
