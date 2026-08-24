import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:soleoserp/blocs/MainBloc/mainBloc.dart';
import 'package:soleoserp/models/Model_Classis_Fro_ODB/bank_voucher_detail_model.dart';
import 'package:soleoserp/models/api_requests/Mayank_BankVoucher_Request/Mayank_BankVoucher_Delete_Request.dart';
import 'package:soleoserp/models/api_requests/Mayank_BankVoucher_Request/Mayank_BankVoucher_List_Request.dart';
import 'package:soleoserp/models/api_responses/Mayank_BankVoucher_Response/Mayank_BankVoucher_List_Respnse.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/res/image_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/bank_voucher1/BankVoucher_Add_Edit.dart';
import 'package:soleoserp/ui/screens/DashBoard/home_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/ui/widgets/common_widgets.dart';
import 'package:soleoserp/utils/date_time_extensions.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/offline_db_helper.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';

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

class MayankBankVoucherListScreen extends BaseStatefulWidget {
  static const routeName = '/MayankBankVoucherListScreen';

  @override
  _MayankBankVoucherListScreenScreen createState() =>
      _MayankBankVoucherListScreenScreen();
}

class _MayankBankVoucherListScreenScreen
    extends BaseState<MayankBankVoucherListScreen>
    with BasicScreen, WidgetsBindingObserver {
  MainBloc _mainBloc;
  MayankBankVoucherListResponse _listResponse;
  int _pageNo = 0;
  LoginUserDetialsResponse _offlineLoggedInData;
  CompanyDetailsResponse _offlineCompanyData;
  int CompanyID = 0;
  String LoginUserID = "";
  bool isDeleteVisible = true;
  int selected = 0;
  final TextEditingController _searchCtrl = TextEditingController();
  Timer _debounceTimer;
  int FinalTotalCount = 0;

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = const Color(0xff0066b3);
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;
    _mainBloc = MainBloc(baseBloc);
    _fetchList();

    isDeleteVisible = viewvisiblitiyAsperClient(
        SerailsKey: _offlineLoggedInData.details[0].serialKey,
        RoleCode: _offlineLoggedInData.details[0].roleCode);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _fetchList() {
    _mainBloc.add(MayankBankVoucherListEvent(
        1,
        MayankBankVoucherListRequest(
          pkID: 0,
          SearchKey: _searchCtrl.text.trim(),
          TrType: "bank",
          PageNo: 1,
          PageSize: 10,
          LoginUserID: LoginUserID,
          CompanyId: CompanyID,
        )));
  }

  void _onSearchChanged(String value) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 600), () {
      _fetchList();
    });
  }

  void _clearSearch() {
    _searchCtrl.clear();
    _debounceTimer?.cancel();
    _fetchList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _mainBloc,
      child: BlocConsumer<MainBloc, MainStates>(
        builder: (BuildContext context, MainStates state) {
          if (state is MayankBankVoucherListResponseState) {
            _onMayankBankVoucherSuccess(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is MayankBankVoucherListResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, MainStates state) {
          if (state is MayankBankVoucherDeleteResponseState) {
            _onDeleteBankVoucher(state);
          }
        },
        listenWhen: (oldState, currentState) {
          if (currentState is MayankBankVoucherDeleteResponseState) {
            return true;
          }
          return false;
        },
      ),
    );
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
            'Bank Voucher',
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
              onPressed: () async {
                await _onTapOfDeleteALLContact();
                navigateTo(context, MayankBankVoucherAddEdit.routeName,
                    clearAllStack: true);
              },
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
          child: Column(
            children: [
              _buildSearchPanel(context, r),
              Expanded(
                child: RefreshIndicator(
                  color: const Color(0xff0066b3),
                  onRefresh: () async => _fetchList(),
                  child: _buildVoucherList(context, r),
                ),
              ),
            ],
          ),
        ),
        drawer: build_Drawer(
            context: context, UserName: "KISHAN", RolCode: "Admin"),
      ),
    );
  }

  Widget _buildSearchPanel(BuildContext context, _R r) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(r.s(12), r.s(10), r.s(12), r.s(10)),
        child: Container(
          height: r.s(44),
          padding: EdgeInsets.symmetric(horizontal: r.s(12)),
          decoration: BoxDecoration(
            color: const Color(0xffF2F5FA),
            borderRadius: BorderRadius.circular(r.s(10)),
            border: Border.all(color: const Color(0xffDDE3EF)),
          ),
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.grey.shade500, size: r.s(20)),
              SizedBox(width: r.s(10)),
              Expanded(
                child: TextField(
                  controller: _searchCtrl,
                  textInputAction: TextInputAction.search,
                  onChanged: (v) {
                    _onSearchChanged(v);
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    hintText: "Search by customer name...",
                    hintStyle: TextStyle(
                        color: Colors.grey.shade400, fontSize: r.f(13)),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  style: TextStyle(fontSize: r.f(13), color: Colors.black87),
                ),
              ),
              if (_searchCtrl.text.isNotEmpty)
                GestureDetector(
                  onTap: _clearSearch,
                  child: Icon(Icons.close,
                      size: r.s(16), color: Colors.grey.shade500),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVoucherList(BuildContext context, _R r) {
    if (_listResponse == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_listResponse.details.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(NO_SEARCH_RESULT_FOUND,
                height: r.s(180), width: r.s(180)),
            Text(
              "No Vouchers Found",
              style: TextStyle(
                  fontSize: r.f(14),
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (shouldPaginate(scrollInfo)) {
          _onInquiryListPagination();
          return true;
        }
        return false;
      },
      child: ListView.builder(
        padding: EdgeInsets.fromLTRB(r.s(12), r.s(12), r.s(12), r.s(24)),
        itemCount: _listResponse.details.length,
        itemBuilder: (ctx, i) => _buildVoucherCard(ctx, r, i),
      ),
    );
  }

  Widget _buildVoucherCard(BuildContext context, _R r, int index) {
    final model = _listResponse.details[index];

    String _fmtDate(String raw) {
      if (raw == null || raw.isEmpty) return "N/A";
      return raw.getFormattedDate(
              fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy") ??
          "N/A";
    }

    return Card(
      margin: EdgeInsets.only(bottom: r.s(10)),
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(r.s(14))),
      elevation: 3,
      shadowColor: Colors.blue.withOpacity(0.12),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                CircleAvatar(
                  radius: r.s(20),
                  backgroundColor: const Color(0xff0066b3).withOpacity(0.1),
                  child: Text(
                    model.customerName?.substring(0, 1).toUpperCase() ?? "C",
                    style: TextStyle(
                        fontSize: r.f(16),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff0066b3)),
                  ),
                ),
                SizedBox(width: r.s(10)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.customerName ?? "N/A",
                        style: TextStyle(
                            fontSize: r.f(14),
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff0066b3)),
                      ),
                      SizedBox(height: r.s(2)),
                      Text(
                        model.voucherNo ?? "N/A",
                        style:
                            TextStyle(fontSize: r.f(11), color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(r.s(14), r.s(10), r.s(14), 0),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        _infoTile(r, Icons.calendar_today_outlined,
                            "Voucher Date", _fmtDate(model.voucherDate)),
                        SizedBox(height: r.s(7)),
                        _infoTile(r, Icons.category_outlined, "Voucher Type",
                            model.voucherType ?? "N/A"),
                      ],
                    ),
                  ),
                  SizedBox(width: r.s(12)),
                  Expanded(
                    child: Column(
                      children: [
                        _infoTile(r, Icons.currency_rupee, "Amount",
                            "₹${model.voucherAmount?.toString() ?? "0"}"),
                        SizedBox(height: r.s(7)),
                        _infoTile(r, Icons.swap_horiz, "Rec/Pay",
                            model.recPay ?? "N/A"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(r.s(14), r.s(8), r.s(14), r.s(8)),
            child: Column(
              children: [
                _detailRow(r, "Invoice No", model.invoiceNo ?? "N/A"),
                SizedBox(height: r.s(6)),
                _detailRow(r, "Account Name", model.accountName ?? "N/A"),
                SizedBox(height: r.s(6)),
                _detailRow(r, "Employee Name", model.employeeName ?? "N/A"),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(r.s(14), r.s(8), r.s(14), r.s(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => _onTapOfEditVehicleFuel(model),
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
                if (isDeleteVisible == true)
                  GestureDetector(
                    onTap: () => _showDeleteConfirmation(model.pkID),
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

  Widget _infoTile(_R r, IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: r.s(13), color: const Color(0xff0066b3)),
        SizedBox(width: r.s(5)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      fontSize: r.f(10),
                      color: Colors.grey,
                      fontWeight: FontWeight.w500)),
              Text(value,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(fontSize: r.f(12), color: Colors.black87)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _detailRow(_R r, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            width: r.s(80),
            child: Text(label,
                style:
                    TextStyle(fontSize: r.f(10), color: Colors.grey.shade500))),
        SizedBox(width: r.s(8)),
        Expanded(
            child: Text(value,
                style: TextStyle(fontSize: r.f(11), color: Colors.black87))),
      ],
    );
  }

  void _showDeleteConfirmation(int id) {
    showCommonDialogWithTwoOptions(
      context,
      "Are you sure you want to delete this record?",
      negativeButtonTitle: "No",
      positiveButtonTitle: "Yes",
      onTapOfPositiveButton: () {
        Navigator.of(context).pop();
        _mainBloc.add(MayankBankVoucherDeleteEvent(
          MayankBankVoucherDeleteRequest(pkID: id, CompanyId: CompanyID),
        ));
      },
    );
  }

  void _onInquiryListPagination() {
    _mainBloc.add(MayankBankVoucherListEvent(
        _pageNo + 1,
        MayankBankVoucherListRequest(
          pkID: 0,
          SearchKey: _searchCtrl.text.trim(),
          TrType: "bank",
          PageNo: _pageNo + 1,
          PageSize: 10,
          LoginUserID: LoginUserID,
          CompanyId: CompanyID,
        )));
  }

  void _onMayankBankVoucherSuccess(MayankBankVoucherListResponseState state) {
    if (_pageNo != state.newPage || state.newPage == 1) {
      if (state.newPage == 1) {
        _listResponse = state.response;
      } else {
        _listResponse.details.addAll(state.response.details);
      }
      FinalTotalCount = state.response.totalCount;
      _pageNo = state.newPage;
    }
  }

  void _onTapOfEditVehicleFuel(MayankBankVoucherListDetails model) async {
    navigateTo(context, MayankBankVoucherAddEdit.routeName,
            arguments: AddUpdateVehiclePunchArguments2(model))
        .then((value) => _fetchList());
  }

  void _onDeleteBankVoucher(MayankBankVoucherDeleteResponseState state) {
    showCommonDialogWithSingleOption(context, state.response,
        positiveButtonTitle: "OK", onTapOfPositiveButton: () {
      Navigator.pop(context);
      _fetchList();
    });
  }

  Future<void> _onTapOfDeleteALLContact() async {
    await OfflineDbHelper.getInstance().deleteAllBankVoucher();
  }

  Future<bool> _onBackPressed() async {
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
    return false;
  }
}
