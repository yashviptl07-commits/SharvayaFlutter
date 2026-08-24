import 'package:flutter/material.dart';
import 'package:soleoserp/models/common/all_name_id_list.dart';
import 'package:soleoserp/ui/res/color_resources.dart';

Widget buildTextField({
  String label,
  String hint,
  TextEditingController controller,
  IconData icon,
  BuildContext context,
  VoidCallback onIconPressed,
  String Function(String) validator,
}) {
  double deviceWidth = MediaQuery.of(context).size.width;
  double smallFontSize = deviceWidth * 0.045;
  double fontSize = deviceWidth * 0.040;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.01),
        child: Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      Card(
        color: colorWhite,
        elevation: 10,
        shadowColor: colorPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.03),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  keyboardType: TextInputType.text,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: TextStyle(
                    fontSize: smallFontSize,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(
                      fontSize: fontSize,
                      color: Colors.black26,
                      fontWeight: FontWeight.w500,
                    ),
                    border: InputBorder.none,
                    errorStyle: TextStyle(
                      fontSize: fontSize,
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: deviceWidth * 0.03,
                    ),
                  ),
                  validator: validator,
                ),
              ),
              Icon(icon)
            ],
          ),
        ),
      ),
    ],
  );
}

Widget buildTextFieldForDecimal({
  String label,
  BuildContext context,
  TextEditingController controller,
  IconData icon,
  String hintText,
  String Function(String) validator,
}) {
  Size screenSize = MediaQuery.of(context).size;
  double deviceWidth = screenSize.width;
  double smallFontSize = deviceWidth * 0.04;

  double fontSize = deviceWidth * 0.045;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.01),
        child: Text(
          label,
          style: TextStyle(
            fontSize: smallFontSize,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      //const SizedBox(height: 3),
      Card(
        color: Colors.grey.shade100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          height: deviceWidth * 0.15,
          padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.03),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  keyboardType: TextInputType.numberWithOptions(
                      signed: true, decimal: true),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: TextStyle(
                    fontSize: smallFontSize,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: TextStyle(
                      fontSize: fontSize,
                      color: Colors.black26,
                      fontWeight: FontWeight.w500,
                    ),
                    border: InputBorder.none,
                    errorStyle: TextStyle(
                      fontSize: fontSize,
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  validator: validator,
                ),
              ),
              IconButton(
                icon: Icon(
                  icon,
                  color: Colors.black26,
                ),
                onPressed: null,
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget buildCommonDropDown({
  String label,
  BuildContext context,
  TextEditingController nameController,
  TextEditingController idController,
  String hintText,
  List<ALL_Name_ID> CommonList,
  String Function(String) validator,
  VoidCallback onTap,
  void Function(VoidCallback fn) customSetState, // <== added this
}) {
  Size screenSize = MediaQuery.of(context).size;
  double deviceWidth = screenSize.width;
  double smallFontSize = deviceWidth * 0.04;
  double fontSize = deviceWidth * 0.045;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.01),
        child: Text(
          label,
          style: TextStyle(
            fontSize: smallFontSize,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      Card(
        color: colorWhite,
        elevation: 10,
        shadowColor: colorPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          height: deviceWidth * 0.13,
          padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.03),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onTap,
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: nameController,
                      style: TextStyle(
                        fontSize: smallFontSize,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        hintText: hintText,
                        hintStyle: TextStyle(
                          fontSize: fontSize,
                          color: Colors.black26,
                          fontWeight: FontWeight.w500,
                        ),
                        border: InputBorder.none,
                      ),
                      validator: validator,
                      enabled: true,
                    ),
                  ),
                ),
              ),
              Icon(Icons.arrow_drop_down, color: Colors.grey),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget buildTextFieldForLargeBox({
  String label,
  BuildContext context,
  TextEditingController controller,
  String hintText,
  String Function(String) validator,
}) {
  Size screenSize = MediaQuery.of(context).size;
  double deviceWidth = screenSize.width;
  double deviceHeight = screenSize.height;
  double smallFontSize = deviceWidth * 0.04;
  double fontSize = deviceWidth * 0.045;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.01),
        child: Text(
          label,
          style: TextStyle(
            fontSize: smallFontSize,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      //const SizedBox(height: 3),
      Card(
        color: Colors.grey.shade100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          height: deviceWidth * 0.25,
          padding: EdgeInsets.symmetric(
              horizontal: deviceWidth * 0.03, vertical: deviceHeight * 0.008),
          child: TextFormField(
            maxLines: 5,
            controller: controller,
            keyboardType: TextInputType.text,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            style: TextStyle(
              fontSize: smallFontSize,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                fontSize: fontSize,
                color: Colors.black26,
                fontWeight: FontWeight.w500,
              ),
              border: InputBorder.none,
              errorStyle: TextStyle(
                fontSize: fontSize,
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
            validator: validator,
          ),
        ),
      ),
    ],
  );
}

Widget buildCommonButton({
  String text,
  Color colors,
  Color textColors,
  VoidCallback onPressed,
  BuildContext context,
}) {
  double deviceWidth = MediaQuery.of(context).size.width;
  double fontSize = deviceWidth * 0.05;

  return Container(
    margin: EdgeInsets.symmetric(horizontal: deviceWidth * 0.04),
    height: deviceWidth * 0.13,
    width: double.infinity,
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 20,
          spreadRadius: 3,
          offset: Offset(0, 6),
        ),
      ],
      borderRadius: BorderRadius.circular(15),
    ),
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: colors,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          color: textColors,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}

Widget buildTimeBox({
  BuildContext context,
  String hintText = "hh:mm",
  TextEditingController controller,
  VoidCallback onTap,
}) {
  double deviceWidth = MediaQuery.of(context).size.width;
  double smallFontSize = deviceWidth * 0.04;
  double fontSize = deviceWidth * 0.05;

  return Expanded(
    child: Card(
      elevation: 5,
      color: Colors.grey.shade100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: deviceWidth * 0.15,
          margin: EdgeInsets.symmetric(horizontal: deviceWidth * 0.04),
          alignment: Alignment.center,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  enabled: false,
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: TextStyle(
                      fontSize: fontSize,
                      color: Colors.black26,
                      fontWeight: FontWeight.w500,
                    ),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    fontSize: smallFontSize,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(Icons.access_time,
                  color: Colors.grey), // Optional clock icon
            ],
          ),
        ),
      ),
    ),
  );
}

void showCustomSnackBar(
  BuildContext context, {
  String message,
  Color iconColor = Colors.greenAccent,
  Color backgroundColor = Colors.blueGrey,
  IconData icon = Icons.check_circle_rounded,
  double fontSize = 14.0,
  Duration duration = const Duration(seconds: 1),
}) {
  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger == null) return;

  messenger.showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: fontSize,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      elevation: 8,
    ),
  );
}

Widget buildDropdownField({
  BuildContext context,
  String label,
  List<String> items,
  String selectedValue,
  Function(String) onChanged,
}) {
  Size screenSize = MediaQuery.of(context).size;
  double deviceWidth = screenSize.width;
  double titleFontSize = deviceWidth * 0.045;
  Color textColor = Colors.black;
  Color cardColor = Colors.grey[300];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.01),
        child: Text(
          label,
          style: TextStyle(
            fontSize: titleFontSize,
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      Card(
          color: colorWhite,
          elevation: 10,
          shadowColor: colorPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            height: deviceWidth * 0.13,
            padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.03),
            child: DropdownButtonFormField<String>(
              value: selectedValue,
              icon: Icon(Icons.arrow_drop_down, color: textColor),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.transparent,
                border: InputBorder.none,
              ),
              items: items.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: titleFontSize,
                      color: textColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
              dropdownColor: cardColor,
              style: TextStyle(
                fontSize: titleFontSize,
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          )),
    ],
  );
}

Widget buildTimePickerField({
  BuildContext context,
  String label,
  TextEditingController controller,
  VoidCallback onTap,
  bool visible = true,
}) {
  Size screenSize = MediaQuery.of(context).size;
  double deviceWidth = screenSize.width;
  double smallFontSize = deviceWidth * 0.04;

  return Visibility(
    visible: visible,
    child: InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.01),
            child: Text(
              label,
              style: TextStyle(
                fontSize: smallFontSize,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Card(
            elevation: 5,
            color: Colors.grey.shade100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              height: deviceWidth * 0.15,
              padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.03),
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      controller.text.isEmpty ? "HH:MM:SS" : controller.text,
                      style: TextStyle(
                        fontSize: smallFontSize,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(Icons.watch_later_outlined, color: Colors.grey),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
