import 'dart:math';

import 'package:flutter/material.dart';
import 'package:soleoserp/ui/res/color_resources.dart';

//---------------------------------Row Wise List--------------------------------
Widget MultipleList(
    {String label = "",
      String value = "",
      icon,
      String label1 = "",
      String value1 = "",
      icon1}) {
  return Column(
    children: [
      Row(
        children: [
          Flexible(
            child: Row(
              children: [
                icon,
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  // Use Expanded to allow the text to wrap onto new lines
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label,
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: colorBlack,
                            fontSize: 12,
                          )),
                      // Wrap the value text to a new line if it exceeds two lines
                      Text(value,
                          maxLines: max(0, 100), // Maximum of 2 lines
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: colorBlack,
                              fontWeight: FontWeight.bold,
                              fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Flexible(
            child: Row(
              children: [
                icon1,
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  // Use Expanded to allow the text to wrap onto new lines
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label1,
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: colorBlack,
                            fontSize: 12,
                          )),
                      // Wrap the value text to a new line if it exceeds two lines
                      Text(value1,
                          maxLines: max(0, 100), // Maximum of 2 lines
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: colorBlack,
                              fontWeight: FontWeight.bold,
                              fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}

Widget MultipleList1(
    {String label = "",
      double value = 0.00,
      icon,
      String label1 = "",
      double value1 = 0.00,
      icon1}) {
  return Column(
    children: [
      Row(
        children: [
          Flexible(
            child: Row(
              children: [
                icon,
                SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: colorPrimary,
                          fontSize: 10,
                        )),
                    Text(value.toString(), //put your own long text here.
                        maxLines: 3,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                            color: colorBlack,
                            fontWeight: FontWeight.bold,
                            fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Flexible(
            child: Row(
              children: [
                icon1,
                SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label1,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: colorPrimary,
                          fontSize: 10,
                        )),
                    Text(value1.toString(),
                        maxLines: 3,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                            color: colorBlack,
                            fontWeight: FontWeight.bold,
                            fontSize: 12)),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
      SizedBox(
        height: 3,
      ),
      Divider(
        thickness: 2,
        height: 2,
      ),
      SizedBox(
        height: 3,
      ),
    ],
  );
}

//-----------------------------Single Wise List---------------------------------

Widget SimgleList({String label = "", String value = "", icon}) {
  return Column(
    children: [
      Row(
        children: [
          Flexible(
            child: Row(
              children: [
                icon,
                SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: colorBlack,
                          fontSize: 10,
                        )),
                    Text(value,
                        maxLines: 10,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                            color: colorBlack,
                            fontWeight: FontWeight.bold,
                            fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      SizedBox(
        height: 3,
      ),
      Divider(
        thickness: 2,
        height: 2,
      ),
      SizedBox(
        height: 3,
      ),
    ],
  );
}

//-----------------------------Single Wise List---------------------------------

Widget SimgleList12({String label = "", String value = "", icon}) {
  return Column(
    children: [
      Row(
        children: [
          icon,
          SizedBox(
            width: 10,
          ),
          Row(
            children: [
              Text(label,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: colorBlack,
                    fontSize: 10,
                  )),
              Flexible(
                child: Text(value,
                    maxLines: 10,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                        color: colorBlack,
                        fontWeight: FontWeight.bold,
                        fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
      SizedBox(
        height: 3,
      ),
      Divider(
        thickness: 2,
        height: 2,
      ),
      SizedBox(
        height: 3,
      ),
    ],
  );
}


Widget ChetGptKiKrupa({String label = "", String value = "", icon}) {
  return Column(
    children: [
      Row(
        children: [
          Flexible(
            child: Row(
              children: [
                icon,
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  // Use Expanded to allow the text to wrap onto new lines
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label,
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: colorBlack,
                            fontSize: 12,
                          )),
                      // Wrap the value text to a new line if it exceeds two lines
                      Text(value,
                          maxLines: max(0, 100), // Maximum of 2 lines
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: colorBlack,
                              fontWeight: FontWeight.bold,
                              fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}



