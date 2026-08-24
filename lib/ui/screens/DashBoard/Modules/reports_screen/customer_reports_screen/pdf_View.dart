// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:soleoserp/ui/res/color_resources.dart';

class PreviewScreen extends StatelessWidget {
  final String PdfName;
  final pw.Document doc;

  const PreviewScreen({
    Key key,
    this.doc,
    this.PdfName
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorPrimary,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_outlined),
        ),
        centerTitle: true,
        title: Text("PDF Preview"),
      ),
      body:
      PdfPreview(
        build: (format) => doc.save(),
        allowSharing: true,
        allowPrinting: true,
        canChangePageFormat: false,
        canChangeOrientation: false,
        shouldRepaint: false,
        dynamicLayout :false,
        canDebug :false,
        initialPageFormat: PdfPageFormat.a4,
        pdfFileName: PdfName + ".pdf",
      ),
    );
  }
}



