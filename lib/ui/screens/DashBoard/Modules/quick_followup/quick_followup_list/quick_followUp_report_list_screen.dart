import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:soleoserp/blocs/MainBloc/mainBloc.dart';
import 'package:soleoserp/models/api_requests/followup/quick_followup_report_list_request.dart';
import 'package:soleoserp/models/api_requests/other/all_employee_list_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/followup/quick_followup_report_list_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/common/all_name_id_list.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/quick_followup/quick_followup_list/quick_followup_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/reports_screen/customer_reports_screen/pdf_View.dart';
import 'package:soleoserp/ui/screens/DashBoard/home_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:intl/intl.dart';

class QuickFollowUpReportScreen extends BaseStatefulWidget {
  static const routeName = '/QuickFollowUpReportScreen';

  @override
  _QuickFollowUpReportScreenState createState() =>
      _QuickFollowUpReportScreenState();
}

class _QuickFollowUpReportScreenState
    extends BaseState<QuickFollowUpReportScreen>
    with BasicScreen, WidgetsBindingObserver {
  // ─── BLoC & offline data ─────────────────────────────────────────────────
  MainBloc _mainBloc;
  LoginUserDetialsResponse _offlineLoggedInData;
  CompanyDetailsResponse _offlineCompanyData;
  int _companyID = 0;
  String _loginUserID = '';

  DateTime _selectedFromDate = DateTime.now();
  DateTime _selectedToDate = DateTime.now();
  String _fromDateLabel = '';
  String _toDateLabel = '';

  List<ALL_Name_ID> _employeeList = [];
  String _selectedEmployeeName = 'Select Employee';
  String _selectedEmployeeID = '0';
  bool _isLoadingEmployees = true;

  static const Color _gradientStart = Color(0xff108dcf);
  static const Color _gradientMid = Color(0xff0066b3);
  static const Color _gradientEnd = Color(0xff62bb47);
  static const Color _cardBg = Color(0xffffffff);
  static const Color _pageBg = Color(0xfff0f4f8);
  static const Color _fieldBg = Color(0xfff5f8fc);
  static const Color _fieldBorder = Color(0xffdde8f5);
  static const Color _labelColor = Color(0xff0066b3);
  static const Color _primaryText = Color(0xff1a1a1a);
  static const Color _secondaryText = Color(0xff6b7280);
  static const Color _dividerColor = Color(0xffeef1f5);
  static const Color _infoBg = Color(0xffe8f4fd);
  static const Color _infoBorder = Color(0xffc3dff5);
  static const Color _infoText = Color(0xff2a5a8a);

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = colorPrimary;
    _mainBloc = MainBloc(baseBloc);
    _fromDateLabel = DateFormat('dd-MM-yyyy').format(_selectedFromDate);
    _toDateLabel = DateFormat('dd-MM-yyyy').format(_selectedToDate);
    _initializeData();
  }

  Future<void> _initializeData() async {
    _offlineLoggedInData = await SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = await SharedPrefHelper.instance.getCompanyData();

    _companyID = _offlineCompanyData.details[0].pkId;
    _loginUserID = _offlineLoggedInData.details[0].userID;

    // Trigger employee list API
    _mainBloc.add(ALLEmployeeNameCallEvent(
        ALLEmployeeNameRequest(CompanyId: _companyID.toString())));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _mainBloc,
      child: BlocConsumer<MainBloc, MainStates>(
        buildWhen: (_, current) =>
            current is ALL_EmployeeNameListResponseState ||
            current is QuickFollowupReportListResponseState,
        builder: (_, __) => super.build(context),
        listenWhen: (_, current) =>
            current is ALL_EmployeeNameListResponseState ||
            current is QuickFollowupReportListResponseState,
        listener: (_, state) {
          if (state is ALL_EmployeeNameListResponseState) {
            _handleEmployeeListLoaded(state);
          } else if (state is QuickFollowupReportListResponseState) {
            _displayPdf(state.quickFollowupReportListResponse);
          }
        },
      ),
    );
  }

  /// Called from listener (safe to setState here).
  void _handleEmployeeListLoaded(ALL_EmployeeNameListResponseState state) {
    final details = state.all_employeeList_Response?.details;
    if (details == null || details.isEmpty) {
      setState(() => _isLoadingEmployees = false);
      return;
    }

    final List<ALL_Name_ID> built = [];

    built.add(ALL_Name_ID()
      ..Name = 'All Employees'
      ..pkID = 0);

    for (final d in details) {
      built.add(ALL_Name_ID()
        ..Name = d.employeeName
        ..pkID = d.pkID);
    }
    setState(() {
      _employeeList = built;
      _selectedEmployeeName = 'All Employees';
      _selectedEmployeeID = '0';
      _isLoadingEmployees = false;
    });
  }

  @override
  Widget buildBody(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: _pageBg,
        appBar: _buildAppBar(),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildFiltersCard(),
              const SizedBox(height: 14),
              _buildInfoBanner(),
              const SizedBox(height: 20),
              _buildGenerateButton(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return NewGradientAppBar(
      elevation: 0,
      gradient: const LinearGradient(
          colors: [_gradientStart, _gradientMid, _gradientEnd]),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text('Followup Report',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
          SizedBox(height: 2),
          Text('Generate & export as PDF',
              style: TextStyle(fontSize: 11, color: Colors.white70)),
        ],
      ),
      leading: _appBarIconButton(
        icon: Icons.arrow_back_ios_new_rounded,
        onTap: () => navigateTo(context, QuickFollowupListScreen.routeName,
            clearAllStack: true),
      ),
      actions: [
        _appBarIconButton(
          icon: Icons.home_rounded,
          onTap: () =>
              navigateTo(context, HomeScreen.routeName, clearAllStack: true),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _appBarIconButton({IconData icon, VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildFiltersCard() {
    return _surfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Icon(Icons.tune_rounded, size: 18, color: _labelColor),
              const SizedBox(width: 8),
              const Text('Filters',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: _primaryText)),
              const Spacer(),
              _chipBadge('3 fields'),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: _dividerColor, height: 1),
          const SizedBox(height: 16),

          _fieldLabel(Icons.person_outline_rounded, 'Employee'),
          const SizedBox(height: 8),
          _buildEmployeeField(),

          const SizedBox(height: 16),
          const Divider(color: _dividerColor, height: 1),
          const SizedBox(height: 16),

          _fieldLabel(Icons.calendar_month_rounded, 'Date Range'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                  child: _buildDateField(
                      sublabel: 'FROM',
                      valueText: _fromDateLabel,
                      onTap: _pickFromDate)),
              const SizedBox(width: 12),
              Expanded(
                  child: _buildDateField(
                      sublabel: 'TO',
                      valueText: _toDateLabel,
                      onTap: _pickToDate)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeField() {
    final bool ready = !_isLoadingEmployees && _employeeList.isNotEmpty;
    final bool hasSelection = _selectedEmployeeName != 'Select Employee';

    return GestureDetector(
      onTap: ready ? _showEmployeeSheet : null,
      child: _inputShell(
        child: Row(
          children: [
            if (_isLoadingEmployees) ...[
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: _labelColor),
              ),
              const SizedBox(width: 10),
              const Text('Loading employees...',
                  style: TextStyle(fontSize: 13, color: _secondaryText)),
            ] else ...[
              Expanded(
                child: Text(
                  _selectedEmployeeName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight:
                        hasSelection ? FontWeight.w600 : FontWeight.w400,
                    color: hasSelection ? _primaryText : _secondaryText,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: ready ? _labelColor : _secondaryText,
                size: 22,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDateField(
      {String sublabel, String valueText, VoidCallback onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(sublabel,
            style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: _secondaryText,
                letterSpacing: 0.8)),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: onTap,
          child: _inputShell(
            child: Row(
              children: [
                const Icon(Icons.calendar_today_rounded,
                    color: _labelColor, size: 16),
                const SizedBox(width: 8),
                Text(
                  valueText.isEmpty ? 'DD-MM-YYYY' : valueText,
                  style: TextStyle(
                    fontSize: 13,
                    color: valueText.isEmpty ? _secondaryText : _primaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: _infoBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _infoBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.info_outline_rounded, color: _labelColor, size: 18),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Select a date range and employee, then tap Generate Report to '
              'build a PDF with meeting notes, inquiry numbers, and location details.',
              style: TextStyle(fontSize: 12, color: _infoText, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenerateButton() {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [_gradientStart, _gradientMid, Color(0xff0e8c4a)]),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: _gradientMid.withOpacity(0.35),
              blurRadius: 12,
              offset: const Offset(0, 5))
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: _generateReport,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.picture_as_pdf_rounded, color: Colors.white, size: 20),
              SizedBox(width: 10),
              Text('Generate Report',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.3)),
            ],
          ),
        ),
      ),
    );
  }

  void _showEmployeeSheet() {
    String _sheetSelected = _selectedEmployeeName;
    final TextEditingController _searchCtrl = TextEditingController();
    List<ALL_Name_ID> _filtered = List.from(_employeeList);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheet) {
            void _onSearch(String q) {
              setSheet(() {
                _filtered = q.trim().isEmpty
                    ? List.from(_employeeList)
                    : _employeeList
                        .where((e) => e.Name.toLowerCase()
                            .contains(q.trim().toLowerCase()))
                        .toList();
              });
            }

            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
              ),
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.65),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // drag handle
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2)),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.people_outline_rounded,
                          color: _labelColor, size: 20),
                      const SizedBox(width: 8),
                      const Text('Select Employee',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: _primaryText)),
                      const Spacer(),
                      _chipBadge('${_filtered.length} found'),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          _searchCtrl.dispose();
                          Navigator.pop(ctx);
                        },
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                              color: _fieldBg,
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: _fieldBorder, width: 1)),
                          child: const Icon(Icons.close_rounded,
                              color: _secondaryText, size: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 42,
                    decoration: BoxDecoration(
                        color: _fieldBg,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: _fieldBorder, width: 1.5)),
                    child: TextField(
                      controller: _searchCtrl,
                      onChanged: _onSearch,
                      style: const TextStyle(fontSize: 13, color: _primaryText),
                      decoration: InputDecoration(
                        hintText: 'Search employee...',
                        hintStyle: const TextStyle(
                            fontSize: 13, color: _secondaryText),
                        prefixIcon: const Icon(Icons.search_rounded,
                            color: _labelColor, size: 18),
                        suffixIcon: _searchCtrl.text.isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  _searchCtrl.clear();
                                  _onSearch('');
                                },
                                child: const Icon(Icons.cancel_rounded,
                                    color: _secondaryText, size: 16))
                            : null,
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Divider(height: 1, color: _dividerColor),
                  _filtered.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32),
                          child: Column(
                            children: const [
                              Icon(Icons.search_off_rounded,
                                  color: _secondaryText, size: 36),
                              SizedBox(height: 8),
                              Text('No employee found',
                                  style: TextStyle(
                                      fontSize: 14, color: _secondaryText)),
                            ],
                          ),
                        )
                      : Flexible(
                          child: ListView.separated(
                            shrinkWrap: true,
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            itemCount: _filtered.length,
                            separatorBuilder: (_, __) =>
                                const Divider(height: 1, color: _dividerColor),
                            itemBuilder: (_, i) {
                              final item = _filtered[i];
                              final isAllOption =
                                  _employeeList.indexOf(item) == 0;
                              final isSelected = _sheetSelected == item.Name;
                              return Material(
                                color: isSelected
                                    ? _labelColor.withOpacity(0.06)
                                    : Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    setSheet(() => _sheetSelected = item.Name);
                                    setState(() {
                                      _selectedEmployeeName = item.Name;
                                      _selectedEmployeeID =
                                          item.pkID.toString();
                                    });
                                    Future.delayed(
                                      const Duration(milliseconds: 160),
                                      () {
                                        if (Navigator.canPop(ctx)) {
                                          _searchCtrl.dispose();
                                          Navigator.pop(ctx);
                                        }
                                      },
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 8),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 18,
                                          backgroundColor: isSelected
                                              ? _labelColor.withOpacity(0.15)
                                              : _fieldBg,
                                          child: Icon(
                                            isAllOption
                                                ? Icons.groups_2_rounded
                                                : Icons.person_outline_rounded,
                                            size: 17,
                                            color: isSelected
                                                ? _labelColor
                                                : _secondaryText,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            item.Name,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: isSelected
                                                  ? FontWeight.w700
                                                  : FontWeight.w500,
                                              color: isSelected
                                                  ? _labelColor
                                                  : _primaryText,
                                            ),
                                          ),
                                        ),
                                        if (isSelected)
                                          const Icon(Icons.check_circle_rounded,
                                              color: _labelColor, size: 20),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _pickFromDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedFromDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (_, child) => _datePickerTheme(child),
    );
    if (picked != null && mounted) {
      setState(() {
        _selectedFromDate = picked;
        _fromDateLabel = DateFormat('dd-MM-yyyy').format(picked);
        // Auto-correct To date if it's now before From date
        if (_selectedToDate.isBefore(_selectedFromDate)) {
          _selectedToDate = picked;
          _toDateLabel = _fromDateLabel;
        }
      });
    }
  }

  Future<void> _pickToDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedToDate,
      firstDate: _selectedFromDate, // can't pick before From
      lastDate: DateTime.now(),
      builder: (_, child) => _datePickerTheme(child),
    );
    if (picked != null && mounted) {
      setState(() {
        _selectedToDate = picked;
        _toDateLabel = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  Widget _datePickerTheme(Widget child) {
    return Theme(
      data: ThemeData.light().copyWith(
        colorScheme: const ColorScheme.light(
          primary: _gradientMid,
          onPrimary: Colors.white,
          surface: Colors.white,
          onSurface: _primaryText,
        ),
      ),
      child: child,
    );
  }

  void _generateReport() {
    _mainBloc.add(QuickFollowupReportListRequestEvent(
      QuickFollowupReportListRequest(
        FromDate: DateFormat('yyyy-MM-dd').format(_selectedFromDate),
        ToDate: DateFormat('yyyy-MM-dd').format(_selectedToDate),
        EmployeeID: _selectedEmployeeID,
        LoginUserID: _loginUserID,
        CompanyId: _companyID.toString(),
      ),
    ));
  }

  void _displayPdf(QuickFollowupReportListResponse response) {
    if (response == null) {
      _showToast('No response received');
      return;
    }
    if (response.details == null || response.details.isEmpty) {
      _showToast('No data available for selected criteria');
      return;
    }

    final doc = pw.Document();
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(32),
        build: (pw.Context ctx) => [
          pw.Center(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text('FOLLOWUP REPORT',
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 5),
                pw.Text('Period: $_fromDateLabel to $_toDateLabel',
                    style: pw.TextStyle(fontSize: 12)),
                pw.Text('Employee: $_selectedEmployeeName',
                    style: pw.TextStyle(fontSize: 12)),
                pw.SizedBox(height: 20),
              ],
            ),
          ),
          pw.Divider(thickness: 1),
          _pdfTableHeader(),
          pw.Divider(thickness: 1),
          ..._buildDataRows(response.details),
          pw.SizedBox(height: 10),
          pw.Divider(thickness: 1),
          pw.Center(
            child: pw.Text(
              'Generated on: ${DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now())}',
              style: pw.TextStyle(fontSize: 8),
            ),
          ),
        ],
      ),
    );

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PreviewScreen(
            doc: doc,
            PdfName:
                'Followup_Report_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.pdf',
          ),
        ),
      );
    }
  }

  pw.Widget _pdfTableHeader() {
    final s = pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10);
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Expanded(flex: 2, child: pw.Text('Date', style: s)),
        pw.Expanded(flex: 3, child: pw.Text('Customer', style: s)),
        pw.Expanded(flex: 2, child: pw.Text('Inquiry No', style: s)),
        pw.Expanded(flex: 4, child: pw.Text('Meeting Notes', style: s)),
        pw.Expanded(flex: 2, child: pw.Text('Next Date', style: s)),
        pw.Expanded(flex: 2, child: pw.Text('In Address', style: s)),
        pw.Expanded(flex: 2, child: pw.Text('Out Address', style: s)),
      ],
    );
  }

  List<pw.Widget> _buildDataRows(
      List<QuickFollowupReportListResponseDetails> details) {
    final s = pw.TextStyle(fontSize: 9);
    final rows = <pw.Widget>[];
    for (final item in details) {
      rows.add(pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
              flex: 2,
              child: pw.Text(_formatDate(item.followupDate), style: s)),
          pw.Expanded(
              flex: 3, child: pw.Text(item.customerName ?? '', style: s)),
          pw.Expanded(flex: 2, child: pw.Text(item.inquiryNo ?? '', style: s)),
          pw.Expanded(
              flex: 4, child: pw.Text(item.meetingNotes ?? '', style: s)),
          pw.Expanded(
              flex: 2,
              child: pw.Text(_formatDate(item.nextFollowupDate), style: s)),
          pw.Expanded(
              flex: 2, child: pw.Text(item.locationAddressIN ?? '', style: s)),
          pw.Expanded(
              flex: 2, child: pw.Text(item.locationAddressOUT ?? '', style: s)),
        ],
      ));
      rows.add(pw.SizedBox(height: 4));
    }
    return rows;
  }

  String _formatDate(String dateString) {
    if (dateString == null || dateString.isEmpty) return '';
    try {
      return DateFormat('dd-MM-yyyy').format(DateTime.parse(dateString));
    } catch (_) {
      return dateString;
    }
  }

  Widget _surfaceCard({Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.07), width: 0.5),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 3))
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }

  Widget _inputShell({Widget child}) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: _fieldBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _fieldBorder, width: 1.5),
      ),
      child: child,
    );
  }

  Widget _fieldLabel(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: _labelColor),
        const SizedBox(width: 6),
        Text(
          text.toUpperCase(),
          style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: _labelColor,
              letterSpacing: 0.8),
        ),
      ],
    );
  }

  Widget _chipBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
          color: _infoBg, borderRadius: BorderRadius.circular(20)),
      child: Text(label,
          style: const TextStyle(
              fontSize: 10, fontWeight: FontWeight.w700, color: _labelColor)),
    );
  }

  Future<bool> _onBackPressed() async {
    navigateTo(context, QuickFollowupListScreen.routeName, clearAllStack: true);
    return true;
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }
}
