import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:soleoserp/blocs/base/base_bloc.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/home_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path/path.dart' as p;
import 'package:dio/dio.dart';
import 'package:uri_to_file/uri_to_file.dart';
import 'package:flutter/services.dart';

class _R {
  final double sw;
  final double sh;
  final double px;

  _R(BuildContext context)
      : sw = MediaQuery.of(context).size.width,
        sh = MediaQuery.of(context).size.height,
        px = MediaQuery.of(context).size.width / 390;

  double s(double v) => (v * px).clamp(v * 0.75, v * 1.35);
  double f(double v) => (v * px).clamp(v * 0.82, v * 1.20);
}

class PDFViewerScreenArguments {
  String pdfUrl;
  PDFViewerScreenArguments(this.pdfUrl);
}

class PDFViewerScreen extends BaseStatefulWidget {
  static const routeName = '/PDFViewerScreen';

  final PDFViewerScreenArguments arguments;
  PDFViewerScreen(this.arguments);

  @override
  _PDFViewerScreenState createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends BaseState<PDFViewerScreen>
    with BasicScreen, WidgetsBindingObserver {
  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;

  String LoginUserID;
  String CompanyID;

  String remotePDFpath = "";
  int pages = 0;
  int currentPage = 0;
  bool isReady = false;
  String errorMessage = '';
  PdfViewerController _pdfViewerController;
  OverlayEntry _overlayEntry;
  PdfTextSearchResult _searchResult;

  bool _isDownloading = false;

  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    _searchResult = PdfTextSearchResult();

    super.initState();
    screenStatusBarColor = const Color(0xff0066b3);
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    LoginUserID = _offlineLoggedInData.details[0].userID;
    CompanyID = _offlineCompanyData.details[0].pkId.toString();

    remotePDFpath = widget.arguments.pdfUrl;
  }

  @override
  void dispose() {
    _pdfViewerController.dispose();
    super.dispose();
  }

  @override
  Widget buildBody(BuildContext context) {
    final r = _R(context);

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: const Color(0xffF2F5FA),
        appBar: NewGradientAppBar(
          title: const Text(
            'PDF Viewer',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          ),
          gradient: const LinearGradient(colors: [
            Color(0xff108dcf),
            Color(0xff0066b3),
            Color(0xff108dcf),
          ]),
          actions: [
            IconButton(
              icon: Icon(Icons.share, color: Colors.white, size: 22),
              onPressed: _sharePDF,
            ),
            const SizedBox(width: 4),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              _buildInfoPanel(context),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: _buildPDFViewer(r),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoPanel(BuildContext context) {
    final r = _R(context);
    bool isValidURL = Uri.parse(widget.arguments.pdfUrl).isAbsolute;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(r.s(16), r.s(12), r.s(16), r.s(12)),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(r.s(8)),
              decoration: BoxDecoration(
                color: isValidURL
                    ? const Color(0xff62bb47).withOpacity(0.1)
                    : Colors.red.shade50,
                borderRadius: BorderRadius.circular(r.s(12)),
              ),
              child: Icon(
                isValidURL ? Icons.picture_as_pdf : Icons.error_outline,
                color:
                    isValidURL ? const Color(0xff62bb47) : Colors.red.shade600,
                size: r.s(24),
              ),
            ),
            SizedBox(width: r.s(12)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isValidURL ? "Document Ready" : "No PDF Found",
                    style: TextStyle(
                      fontSize: r.f(14),
                      fontWeight: FontWeight.w600,
                      color: isValidURL
                          ? const Color(0xff1A2332)
                          : Colors.red.shade600,
                    ),
                  ),
                  SizedBox(height: r.s(4)),
                  Text(
                    isValidURL
                        ? "Tap and hold to select text"
                        : "Please check the document link",
                    style: TextStyle(
                      fontSize: r.f(11),
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
            if (_isDownloading)
              SizedBox(
                height: r.s(24),
                width: r.s(24),
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xff0066b3),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPDFViewer(_R r) {
    bool isValidURL = Uri.parse(widget.arguments.pdfUrl).isAbsolute;

    if (!isValidURL) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.picture_as_pdf,
              size: r.s(80),
              color: Colors.grey.shade300,
            ),
            SizedBox(height: r.s(16)),
            Text(
              "No PDF Document Found",
              style: TextStyle(
                fontSize: r.f(18),
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: r.s(8)),
            Text(
              "The requested document could not be loaded",
              style: TextStyle(
                fontSize: r.f(12),
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: EdgeInsets.all(r.s(8)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(r.s(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(r.s(12)),
        child: SfPdfViewer.network(
          widget.arguments.pdfUrl,
          canShowPaginationDialog: true,
          onDocumentLoaded: (PdfDocumentLoadedDetails details) {
            setState(() {
              pages = details.document.pages.count;
              isReady = true;
            });
          },
          onPageChanged: (PdfPageChangedDetails details) {
            setState(() {
              currentPage = details.newPageNumber;
            });
          },
          onTextSelectionChanged: (PdfTextSelectionChangedDetails details) {
            if (details.selectedText == null && _overlayEntry != null) {
              _overlayEntry.remove();
              _overlayEntry = null;
            } else if (details.selectedText != null && _overlayEntry == null) {
              _showContextMenu(context, details);
            }
          },
          currentSearchTextHighlightColor: Colors.yellow.withOpacity(0.6),
          otherSearchTextHighlightColor: Colors.yellow.withOpacity(0.3),
          controller: _pdfViewerController,
          pageLayoutMode: PdfPageLayoutMode.single,
          scrollDirection: PdfScrollDirection.vertical,
        ),
      ),
    );
  }

  void _showContextMenu(
      BuildContext context, PdfTextSelectionChangedDetails details) {
    final r = _R(context);
    final OverlayState _overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: details.globalSelectedRegion.center.dy - 55,
        left: details.globalSelectedRegion.bottomLeft.dx,
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(r.s(30)),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(r.s(30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildContextMenuItem(
                  context,
                  icon: Icons.copy,
                  label: "Copy",
                  onTap: () {
                    Clipboard.setData(
                        ClipboardData(text: details.selectedText));
                    _pdfViewerController.clearSelection();
                    _overlayEntry.remove();
                    _overlayEntry = null;
                    showCommonDialogWithSingleOption(
                      context,
                      "Text copied to clipboard",
                      positiveButtonTitle: "OK",
                      onTapOfPositiveButton: () => Navigator.of(context).pop(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
    _overlayState.insert(_overlayEntry);
  }

  Widget _buildContextMenuItem(BuildContext context,
      {IconData icon, String label, VoidCallback onTap}) {
    final r = _R(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(r.s(30)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: r.s(16), vertical: r.s(10)),
        child: Row(
          children: [
            Icon(icon, size: r.s(18), color: const Color(0xff0066b3)),
            SizedBox(width: r.s(8)),
            Text(
              label,
              style: TextStyle(
                fontSize: r.f(13),
                fontWeight: FontWeight.w500,
                color: const Color(0xff1A2332),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sharePDF() async {
    final r = _R(context);
    bool isValidURL = Uri.parse(widget.arguments.pdfUrl).isAbsolute;

    if (!isValidURL) {
      showCommonDialogWithSingleOption(
        context,
        "No PDF File Found",
        positiveButtonTitle: "OK",
      );
      return;
    }

    setState(() {
      _isDownloading = true;
    });

    baseBloc.emit(ShowProgressIndicatorState(true));

    try {
      Directory dir = await getTemporaryDirectory();
      dir.exists();
      String fileName = widget.arguments.pdfUrl.split('/').last;
      String pathName = p.join(dir.path, fileName);

      await Dio().download(widget.arguments.pdfUrl, pathName);
      print("Download Completed.");

      File file = await toFile(pathName);

      await Share.shareFiles([file.path], subject: "PDF File");

      // Delete temp file after sharing
      await file.delete();
    } catch (e) {
      print("Download Failed.\n\n" + e.toString());
      showCommonDialogWithSingleOption(
        context,
        "Failed to download PDF. Please try again.",
        positiveButtonTitle: "OK",
      );
    } finally {
      setState(() {
        _isDownloading = false;
      });
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Future<bool> _onBackPressed() async {
    Navigator.of(context).pop("Return_back");
    return false;
  }
}
