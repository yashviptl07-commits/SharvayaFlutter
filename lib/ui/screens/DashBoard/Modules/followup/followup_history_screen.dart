import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:soleoserp/blocs/other/bloc_modules/followup/followup_bloc.dart';
import 'package:soleoserp/models/api_requests/followup/followup_history_list_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/followup/followup_history_list_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/res/image_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/home_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/utils/date_time_extensions.dart';
import 'package:soleoserp/utils/general_utils.dart';
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

class FollowupHistoryScreenArguments {
  String InqNo, CustomerID;
  FollowupHistoryScreenArguments(this.InqNo, this.CustomerID);
}

class FollowupHistoryScreen extends BaseStatefulWidget {
  static const routeName = '/FollowupHistoryScreen';
  final FollowupHistoryScreenArguments arguments;

  FollowupHistoryScreen(this.arguments);

  @override
  _FollowupHistoryScreenState createState() => _FollowupHistoryScreenState();
}

class _FollowupHistoryScreenState extends BaseState<FollowupHistoryScreen>
    with BasicScreen, WidgetsBindingObserver {
  FollowupBloc _FollowupBloc;
  FollowupHistoryListResponse _searchCustomerListResponse;
  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  int CompanyID = 0;
  String LoginUserID = "";
  String InqNo;
  String CustomerID;

  @override
  void initState() {
    super.initState();
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;

    screenStatusBarColor = const Color(0xff0066b3);
    _FollowupBloc = FollowupBloc(baseBloc);
    InqNo = widget.arguments.InqNo;
    CustomerID = widget.arguments.CustomerID;

    _FollowupBloc.add(FollowupHistoryListRequestCallEvent(
        FollowupHistoryListRequest(
            InquiryNo: InqNo,
            CompanyId: CompanyID.toString(),
            CustomerID: CustomerID)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _FollowupBloc,
      child: BlocConsumer<FollowupBloc, FollowupStates>(
        builder: (BuildContext context, FollowupStates state) {
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          return false;
        },
        listener: (BuildContext context, FollowupStates state) {
          if (state is FollowupHistoryListResponseState) {
            _onSearchInquiryListCallSuccess(state.followupHistoryListResponse);
          }
        },
        listenWhen: (oldState, currentState) {
          return currentState is FollowupHistoryListResponseState;
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
            'Followup History',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          ),
          gradient: const LinearGradient(colors: [
            Color(0xff108dcf),
            Color(0xff0066b3),
            Color(0xff108dcf),
          ]),
          leading: IconButton(
            icon:
                const Icon(Icons.arrow_back_ios, color: Colors.white, size: 22),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
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
              _buildHeaderCard(context, r),
              Expanded(
                child: _buildFollowupList(context, r),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context, _R r) {
    int followupCount = _searchCustomerListResponse?.details?.length ?? 0;

    return Container(
      margin: EdgeInsets.all(r.s(16)),
      padding: EdgeInsets.all(r.s(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(r.s(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(r.s(12)),
            decoration: BoxDecoration(
              color: const Color(0xff108dcf).withOpacity(0.1),
              borderRadius: BorderRadius.circular(r.s(12)),
            ),
            child: Icon(Icons.history_outlined,
                color: const Color(0xff108dcf), size: r.s(24)),
          ),
          SizedBox(width: r.s(14)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Followup History",
                  style: TextStyle(
                    fontSize: r.f(14),
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff1A2332),
                  ),
                ),
                SizedBox(height: r.s(4)),
                Text(
                  "Inquiry No: $InqNo",
                  style: TextStyle(
                    fontSize: r.f(11),
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding:
                EdgeInsets.symmetric(horizontal: r.s(10), vertical: r.s(6)),
            decoration: BoxDecoration(
              color: const Color(0xff62bb47).withOpacity(0.1),
              borderRadius: BorderRadius.circular(r.s(20)),
            ),
            child: Text(
              "$followupCount Records",
              style: TextStyle(
                fontSize: r.f(10),
                fontWeight: FontWeight.w600,
                color: const Color(0xff62bb47),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFollowupList(BuildContext context, _R r) {
    if (_searchCustomerListResponse == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(NO_DATA_ANIMATED, height: r.s(150), width: r.s(150)),
            SizedBox(height: r.s(16)),
            Text(
              "Loading followups...",
              style: TextStyle(
                fontSize: r.f(14),
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    if (_searchCustomerListResponse.details.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(NO_SEARCH_RESULT_FOUND,
                height: r.s(180), width: r.s(180)),
            Text(
              "No Followup Found",
              style: TextStyle(
                fontSize: r.f(14),
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: r.s(8)),
            Text(
              "No followup records for this inquiry",
              style: TextStyle(
                fontSize: r.f(12),
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: r.s(16)),
      itemCount: _searchCustomerListResponse.details.length,
      itemBuilder: (context, index) {
        return _buildFollowupCard(context, r, index);
      },
    );
  }

  Widget _buildFollowupCard(BuildContext context, _R r, int index) {
    final model = _searchCustomerListResponse.details[index];

    String _fmtDate(String raw) {
      if (raw == null || raw.isEmpty) return "N/A";
      return raw.getFormattedDate(
              fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy") ??
          "N/A";
    }

    return Container(
      margin: EdgeInsets.only(bottom: r.s(12)),
      child: Card(
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
                  EdgeInsets.symmetric(horizontal: r.s(14), vertical: r.s(12)),
              decoration: BoxDecoration(
                color: const Color(0xff0066b3).withOpacity(0.05),
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(r.s(14))),
              ),
              child: Row(
                children: [
                  Container(
                    width: r.s(36),
                    height: r.s(36),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xff0066b3).withOpacity(0.1),
                    ),
                    child: Icon(Icons.person_outline,
                        color: const Color(0xff0066b3), size: r.s(18)),
                  ),
                  SizedBox(width: r.s(12)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          model.employeeName ?? "N/A",
                          style: TextStyle(
                            fontSize: r.f(14),
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff0066b3),
                          ),
                        ),
                        SizedBox(height: r.s(2)),
                        Text(
                          "Followup by ${model.employeeName ?? "Employee"}",
                          style: TextStyle(
                            fontSize: r.f(10),
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Body
            Padding(
              padding: EdgeInsets.all(r.s(14)),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _detailItem(
                          r,
                          icon: Icons.calendar_today_outlined,
                          label: "Followup Date",
                          value: _fmtDate(model.followupDate),
                        ),
                      ),
                      Expanded(
                        child: _detailItem(
                          r,
                          icon: Icons.calendar_today_outlined,
                          label: "Next Followup",
                          value: _fmtDate(model.nextFollowupDate),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: r.s(12)),
                  Row(
                    children: [
                      Expanded(
                        child: _detailItem(
                          r,
                          icon: Icons.category_outlined,
                          label: "Followup Type",
                          value: model.inquiryStatus ?? "N/A",
                        ),
                      ),
                      Expanded(
                        child: _detailItem(
                          r,
                          icon: Icons.confirmation_number_outlined,
                          label: "Lead #",
                          value: model.inquiryNo?.isNotEmpty == true
                              ? model.inquiryNo
                              : "N/A",
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: r.s(12)),
                  // Contact Number Row
                  _detailItem(
                    r,
                    icon: Icons.phone_outlined,
                    label: "Contact Number",
                    value: model.contactNo1?.isNotEmpty == true
                        ? model.contactNo1
                        : "N/A",
                  ),
                  SizedBox(height: r.s(12)),
                  // Notes Section
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(r.s(10)),
                    decoration: BoxDecoration(
                      color: const Color(0xffF2F5FA),
                      borderRadius: BorderRadius.circular(r.s(10)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.notes_outlined,
                                size: r.s(12), color: const Color(0xff0066b3)),
                            SizedBox(width: r.s(6)),
                            Text(
                              "Notes",
                              style: TextStyle(
                                fontSize: r.f(10),
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: r.s(6)),
                        Text(
                          model.meetingNotes?.isNotEmpty == true
                              ? model.meetingNotes
                              : "No notes available",
                          style: TextStyle(
                            fontSize: r.f(12),
                            color: const Color(0xff1A2332),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailItem(_R r, {IconData icon, String label, String value}) {
    return Container(
      padding: EdgeInsets.all(r.s(10)),
      decoration: BoxDecoration(
        color: const Color(0xffF2F5FA),
        borderRadius: BorderRadius.circular(r.s(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: r.s(12), color: const Color(0xff0066b3)),
              SizedBox(width: r.s(6)),
              Text(
                label,
                style: TextStyle(
                  fontSize: r.f(9),
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: r.s(6)),
          Text(
            value,
            style: TextStyle(
              fontSize: r.f(12),
              fontWeight: FontWeight.w500,
              color: const Color(0xff1A2332),
            ),
          ),
        ],
      ),
    );
  }

  void _onSearchInquiryListCallSuccess(
      FollowupHistoryListResponse followupHistoryListResponse) {
    if (!mounted) {
      return;
    }
    setState(() {
      _searchCustomerListResponse = followupHistoryListResponse;
    });
  }

  Future<bool> _onBackPressed() async {
    Navigator.of(context).pop();
    return false;
  }
}
