import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:soleoserp/models/common/multiple_expense_table.dart';
import 'package:soleoserp/ui/res/image_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/multiple_expense/me_detail/me_details_add_update.dart';
import 'package:soleoserp/ui/screens/DashBoard/home_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/utils/image_full_screen.dart';
import 'package:soleoserp/utils/date_time_extensions.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/offline_db_helper.dart';
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';

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

class MultipleExpenseDetailsScreenArgument {
  MultipleExpenseDetailsScreenArgument();
}

class MultipleExpenseDetailsScreen extends BaseStatefulWidget {
  static const routeName = '/MultipleExpenseDetailsScreen';
  final MultipleExpenseDetailsScreenArgument arguments;

  MultipleExpenseDetailsScreen(this.arguments);

  @override
  _MultipleExpenseDetailsScreenState createState() =>
      _MultipleExpenseDetailsScreenState();
}

class _MultipleExpenseDetailsScreenState
    extends BaseState<MultipleExpenseDetailsScreen>
    with BasicScreen, WidgetsBindingObserver {
  List<MultipleExpenseTable> _expenseList = [];
  Function onTapOfBack;

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = const Color(0xff0066b3);
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    try {
      List<MultipleExpenseTable> list =
          await OfflineDbHelper.getInstance().getMultipleExpense();
      if (!mounted) return;
      setState(() {
        _expenseList = list ?? [];
      });
    } catch (e) {
      debugPrint("Load expenses error: $e");
      if (!mounted) return;
      setState(() {
        _expenseList = [];
      });
    }
  }

  Future<bool> _onBackPressed() async {
    if (onTapOfBack == null) {
      Navigator.of(context).pop();
    } else {
      onTapOfBack();
    }
    return true;
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
            'Expense Details',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          ),
          gradient: const LinearGradient(colors: [
            Color(0xff108dcf),
            Color(0xff0066b3),
            Color(0xff108dcf),
          ]),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add_circle_sharp,
                  color: Colors.white, size: 24),
              onPressed: () => _navigateToAddEdit(null),
            ),
            IconButton(
              icon: const Icon(Icons.home_outlined,
                  color: Colors.white, size: 24),
              onPressed: () {
                navigateTo(context, HomeScreen.routeName, clearAllStack: true);
              },
            ),
            const SizedBox(width: 4),
          ],
        ),
        body: SafeArea(
          child: RefreshIndicator(
            color: const Color(0xff0066b3),
            onRefresh: _loadExpenses,
            child: _expenseList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(NO_DATA_ANIMATED,
                            height: r.s(180), width: r.s(180)),
                        Text(
                          "No Expenses Found",
                          style: TextStyle(
                              fontSize: r.f(14),
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding:
                        EdgeInsets.fromLTRB(r.s(12), r.s(12), r.s(12), r.s(24)),
                    itemCount: _expenseList.length,
                    itemBuilder: (context, index) =>
                        _buildExpenseCard(context, r, _expenseList[index]),
                  ),
          ),
        ),
      ),
    );
  }

  // model.Voucher is a File. A remote (already-uploaded) voucher is
  // represented as a File whose .path happens to be an http(s) URL string
  // (see me_details_add_update.dart's _save()), so all path reads below
  // go through .path, never .toString() — File.toString() returns
  // "File: '/some/path'" (quoted + prefixed), NOT the raw path, so using
  // it as a path caused every image/PDF preview to fail to load. That
  // was the actual root cause of vouchers "not being visible".
  bool _isRemote(String path) =>
      path != null &&
      (path.startsWith('http://') || path.startsWith('https://'));

  // Opens the voucher file — local PDF via the device's PDF viewer app,
  // remote PDF (already-uploaded URL) via the browser / external app.
  Future<void> _openVoucher(String path) async {
    if (path == null || path.isEmpty) return;
    try {
      if (_isRemote(path)) {
        final uri = Uri.parse(path);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          _showOpenVoucherError();
        }
      } else {
        final result = await OpenFile.open(path);
        if (result.type != ResultType.done) {
          _showOpenVoucherError();
        }
      }
    } catch (e) {
      debugPrint("Open voucher error: $e");
      _showOpenVoucherError();
    }
  }

  void _showOpenVoucherError() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not open the file")),
      );
    }
  }

  Widget _buildExpenseCard(
      BuildContext context, _R r, MultipleExpenseTable model) {
    String _fmtDate(String raw) {
      if (raw == null || raw.isEmpty) return "N/A";
      final formatted = raw.getFormattedDate(
          fromFormat: "yyyy-MM-dd", toFormat: "dd-MM-yyyy");
      return formatted ?? "N/A";
    }

    // FIX: was model.Voucher?.toString() — wrong, see note above.
    // model.Voucher.path gives the actual usable path/url string.
    bool hasVoucher = false;
    String voucherPath;
    try {
      voucherPath = model.Voucher?.path?.trim();
      if (voucherPath != null && voucherPath.isNotEmpty) {
        if (_isRemote(voucherPath)) {
          hasVoucher = true;
        } else {
          hasVoucher = File(voucherPath).existsSync();
        }
      }
    } catch (e) {
      debugPrint("Voucher check error: $e");
      hasVoucher = false;
    }

    return Card(
      margin: EdgeInsets.only(bottom: r.s(10)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(r.s(14)),
      ),
      elevation: 3,
      shadowColor: Colors.blue.withOpacity(0.12),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding:
                EdgeInsets.symmetric(horizontal: r.s(14), vertical: r.s(10)),
            decoration: BoxDecoration(
              color: const Color(0xff0066b3).withOpacity(0.05),
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(r.s(14))),
            ),
            child: Row(
              children: [
                if (hasVoucher) _buildVoucherPreview(r, voucherPath),
                if (hasVoucher) SizedBox(width: r.s(10)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.ExpenseTypeName ?? "N/A",
                        style: TextStyle(
                            fontSize: r.f(14),
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff0066b3)),
                      ),
                      SizedBox(height: r.s(2)),
                      Text(
                        "Amount: ₹${model.Amount ?? "0"}",
                        style:
                            TextStyle(fontSize: r.f(11), color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Body
          Padding(
            padding: EdgeInsets.fromLTRB(r.s(14), r.s(10), r.s(14), r.s(8)),
            child: Column(
              children: [
                _detailRow(r, "From", model.FromLocation ?? "N/A"),
                SizedBox(height: r.s(8)),
                _detailRow(r, "To", model.ToLocation ?? "N/A"),
                SizedBox(height: r.s(8)),
                _detailRow(r, "Date", _fmtDate(model.ExpenseDateDetail ?? "")),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(r.s(14), r.s(8), r.s(14), r.s(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => _navigateToAddEdit(model),
                  child: Container(
                    padding: EdgeInsets.all(r.s(8)),
                    decoration: BoxDecoration(
                      color: const Color(0xff108dcf).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(r.s(8)),
                    ),
                    child: Icon(Icons.edit_outlined,
                        size: r.s(18), color: const Color(0xff0066b3)),
                  ),
                ),
                SizedBox(width: r.s(8)),
                GestureDetector(
                  onTap: () => _showDeleteConfirmation(model.id),
                  child: Container(
                    padding: EdgeInsets.all(r.s(8)),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(r.s(8)),
                    ),
                    child: Icon(Icons.delete_outline,
                        size: r.s(18), color: Colors.red.shade400),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(_R r, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            width: r.s(60),
            child: Text(
              label,
              style: TextStyle(fontSize: r.f(10), color: Colors.grey.shade500),
            )),
        SizedBox(width: r.s(8)),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: r.f(12), color: Colors.black87),
          ),
        ),
      ],
    );
  }

  // Renders the voucher preview: PDF chip (tap to open) or image thumbnail
  // (tap to open too, plus full-screen zoom via ImageFullScreenWrapperWidget
  // when it's a local image).
  Widget _buildVoucherPreview(_R r, String voucherPath) {
    try {
      final fileName = voucherPath.split(RegExp(r'[\\/]')).last;
      final isPdf = fileName.toLowerCase().trim().endsWith('.pdf');

      if (isPdf) {
        return InkWell(
          borderRadius: BorderRadius.circular(r.s(10)),
          onTap: () => _openVoucher(voucherPath),
          child: Container(
            constraints: BoxConstraints(maxWidth: r.s(110)),
            padding: EdgeInsets.all(r.s(10)),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(r.s(10)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.picture_as_pdf,
                    color: Colors.red.shade600, size: r.s(24)),
                SizedBox(width: r.s(6)),
                Flexible(
                  child: Text(
                    fileName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: r.f(10), color: Colors.red.shade700),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      final isRemote = _isRemote(voucherPath);

      return InkWell(
        borderRadius: BorderRadius.circular(r.s(10)),
        onTap: isRemote ? () => _openVoucher(voucherPath) : null,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(r.s(10)),
          child: isRemote
              ? Image.network(
                  voucherPath,
                  height: r.s(75),
                  width: r.s(75),
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      height: r.s(75),
                      width: r.s(75),
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: r.s(18),
                        width: r.s(18),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    debugPrint("Voucher network image error: $error");
                    return Container(
                      height: r.s(75),
                      width: r.s(75),
                      color: Colors.grey.shade200,
                      child: Icon(Icons.insert_drive_file,
                          color: Colors.grey.shade500, size: r.s(28)),
                    );
                  },
                )
              : ImageFullScreenWrapperWidget(
                  dark: true,
                  child: Image.file(
                    File(voucherPath),
                    height: r.s(75),
                    width: r.s(75),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      debugPrint("Voucher image render error: $error");
                      return Container(
                        height: r.s(75),
                        width: r.s(75),
                        color: Colors.grey.shade200,
                        child: Icon(Icons.insert_drive_file,
                            color: Colors.grey.shade500, size: r.s(28)),
                      );
                    },
                  ),
                ),
        ),
      );
    } catch (e) {
      debugPrint("Voucher preview build error: $e");
      return Container(
        height: r.s(75),
        width: r.s(75),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(r.s(10)),
        ),
        child: Icon(Icons.insert_drive_file,
            color: Colors.grey.shade500, size: r.s(28)),
      );
    }
  }

  void _showDeleteConfirmation(int id) {
    showCommonDialogWithTwoOptions(
      context,
      "Are you sure you want to delete this record?",
      negativeButtonTitle: "No",
      positiveButtonTitle: "Yes",
      onTapOfPositiveButton: () {
        Navigator.of(context).pop();
        OfflineDbHelper.getInstance().deleteMultipleExpense(id);
        _loadExpenses();
      },
    );
  }

  void _navigateToAddEdit(MultipleExpenseTable model) async {
    await navigateTo(
      context,
      MultiExpenseDetailsAddEditScreen.routeName,
      arguments: MultiExpenseDetailsAddEditScreenArguments(model),
    );
    _loadExpenses();
  }
}
