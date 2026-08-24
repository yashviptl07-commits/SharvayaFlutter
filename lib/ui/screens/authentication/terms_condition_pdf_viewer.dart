import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/screens/authentication/serial_key_screen.dart';
import 'package:soleoserp/ui/screens/base/AnotherBaseScreen.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyScreen extends BaseStatefulWidgetNew {
  static const routeName = '/PrivacyPolicyScreen';

  @override
  _PrivacyPolicyScreenState createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends BaseStateNew<PrivacyPolicyScreen>
    with BasicScreenNew, WidgetsBindingObserver {
  bool checkedValue = false;

  @override
  Widget buildBody(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(
            vertical: height * 0.05,
            horizontal: width * 0.05,
          ),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(width * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ******************** GOOGLE PROMINENT DISCLOSURE ********************
                Text(
                  "This app collects and uses your Location data in both foreground and background to provide live location tracking and attendance verification. "
                  "Location is used to show your accurate real-time movement, track visits, and update your activity even when the app is closed or not in use.\n\n"
                  "Additionally, the app accesses Contacts, Call Logs, Camera, and Storage only to enable specific app features like call-to-lead conversion and uploading attachments.\n\n"
                  "Your data is never shared with any third party and is used strictly for app functionality. You may allow or deny each permission.",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: width * 0.045,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.justify,
                ),

                SizedBox(height: height * 0.02),

                /// ******************** YOUR ORIGINAL CONTENT ********************
                Text(
                  "It is important that you understand what information the app collects and how it is used.",
                  style: TextStyle(
                    fontSize: width * 0.04,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.justify,
                ),

                SizedBox(height: height * 0.02),

                /// CONTACTS
                _buildHeader("1)  Contacts & Call Logs", width),
                _buildDesc(
                  "The app uses your Contacts and Call Logs to convert incoming/outgoing calls into leads. "
                  "This information stays on your device and is not shared externally.",
                  width,
                ),

                SizedBox(height: height * 0.02),

                /// STORAGE
                _buildHeader("2)  External Storage (Images & Files)", width),
                _buildDesc(
                  "Storage permission is used only to upload, view, and save files or images required for business modules.",
                  width,
                ),

                SizedBox(height: height * 0.02),

                /// LOCATION
                _buildHeader("3)  Location (Foreground & Background)", width),
                _buildDesc(
                  "Location permission is used to capture latitude/longitude for attendance, visit tracking, "
                  "and live location updates. Background location ensures tracking continues even when minimized or closed.",
                  width,
                ),

                SizedBox(height: height * 0.02),

                /// CAMERA
                _buildHeader("4)  Camera", width),
                _buildDesc(
                  "Camera permission is used only to capture images for records or verification as per the app's usage.",
                  width,
                ),

                SizedBox(height: height * 0.02),

                /// NOTE
                Text(
                  "Important: This app does NOT sell, transfer, or share your personal or sensitive data with any third party. "
                  "All permissions are used strictly to enable core app features.",
                  style: TextStyle(
                    fontSize: width * 0.037,
                    fontWeight: FontWeight.w600,
                    color: colorBlack,
                  ),
                  textAlign: TextAlign.justify,
                ),

                SizedBox(height: height * 0.02),

                /// ******************** CHECKBOX + LINKS ********************
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: checkedValue,
                      onChanged: (newValue) {
                        setState(() {
                          checkedValue = newValue ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "By continuing you agree to our ",
                              style: TextStyle(fontSize: width * 0.037),
                            ),
                            _linkSpan(
                              "Privacy Policy",
                              "https://docs.google.com/document/d/13HliC_idDq4G-06Ii8z0gyzsXYZgSbvfzYThxTmQRpc/edit?usp=sharing",
                              width,
                            ),
                            TextSpan(
                              text: " & ",
                              style: TextStyle(fontSize: width * 0.037),
                            ),
                            _linkSpan(
                              "Terms & Conditions",
                              "https://docs.google.com/document/d/1Vaw_raFxfDK8Rj7nWsteafX8k47h0N3Ye0irNAV8oK4/edit?usp=sharing",
                              width,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: height * 0.02),

                /// ******************** BUTTONS ********************
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        SystemChannels.platform
                            .invokeMethod('SystemNavigator.pop');
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: width * 0.05,
                          color: colorPrimary,
                        ),
                      ),
                    ),
                    SizedBox(width: width * 0.05),
                    InkWell(
                      onTap: () {
                        if (checkedValue) {
                          SharedPrefHelper.instance.putBool(
                              SharedPrefHelper.IS_TERMSANDCONDITION, true);

                          navigateTo(
                            context,
                            SerialKeyScreen.routeName,
                            clearAllStack: true,
                          );
                        } else {
                          showCommonDialogWithSingleOption(
                            context,
                            "Kindly Accept the Privacy Policy!",
                            positiveButtonTitle: "OK",
                            onTapOfPositiveButton: () => Navigator.pop(context),
                          );
                        }
                      },
                      child: Text(
                        "Agree",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: width * 0.05,
                          color: colorPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------- REUSABLE WIDGETS ----------------------

  Widget _buildHeader(String text, double width) {
    return Padding(
      padding: EdgeInsets.only(top: width * 0.02),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: width * 0.05,
          color: colorBlack,
        ),
      ),
    );
  }

  Widget _buildDesc(String text, double width) {
    return Padding(
      padding: EdgeInsets.only(top: width * 0.02),
      child: Text(
        text,
        style: TextStyle(
          fontSize: width * 0.037,
          color: colorBlack,
        ),
        textAlign: TextAlign.justify,
      ),
    );
  }

  TextSpan _linkSpan(String title, String url, double width) {
    return TextSpan(
      text: title,
      style: TextStyle(
        fontSize: width * 0.04,
        color: Colors.blue,
        decoration: TextDecoration.underline,
      ),
      recognizer: TapGestureRecognizer()
        ..onTap = () async {
          if (await canLaunch(url)) launch(url);
        },
    );
  }
}
