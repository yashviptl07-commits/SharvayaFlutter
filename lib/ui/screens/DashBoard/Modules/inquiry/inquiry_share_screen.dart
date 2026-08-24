import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:soleoserp/blocs/other/bloc_modules/inquiry/inquiry_bloc.dart';
import 'package:soleoserp/models/api_requests/inquiry/InquiryShareModel.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/inquiry/inquiry_share_emp_list_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/other/all_employee_List_response.dart';
import 'package:soleoserp/models/common/globals.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/res/image_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/home_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/ui/widgets/common_widgets.dart';
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

class AddInquiryShareScreenArguments {
  List<InquirySharedEmpDetails> arr_inquiry_share_emp_list;
  AddInquiryShareScreenArguments(this.arr_inquiry_share_emp_list);
}

class InquiryShareScreen extends BaseStatefulWidget {
  static const routeName = '/InquiryShareScreen';
  final AddInquiryShareScreenArguments arguments;

  InquiryShareScreen(this.arguments);

  @override
  _InquiryShareScreenState createState() => _InquiryShareScreenState();
}

class _InquiryShareScreenState extends BaseState<InquiryShareScreen>
    with BasicScreen, WidgetsBindingObserver {
  InquiryBloc _inquiryBloc;
  InquiryShareModel inquiryShareModel;
  List<InquiryShareModel> arrinquiryShareModel = [];

  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  int CompanyID = 0;
  String LoginUserID = "";

  String _InQNo;
  List<InquirySharedEmpDetails> _arr_inquiry_share_emp_list = [];

  ALL_EmployeeList_Response _offlineALLEmployeeListData;

  @override
  void initState() {
    super.initState();
    if (widget.arguments != null) {
      _arr_inquiry_share_emp_list.clear();
      _arr_inquiry_share_emp_list = widget.arguments.arr_inquiry_share_emp_list;
    }
    screenStatusBarColor = const Color(0xff0066b3);
    _offlineALLEmployeeListData =
        SharedPrefHelper.instance.getALLEmployeeList();

    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;
    _inquiryBloc = InquiryBloc(baseBloc);
    _onFollowerEmployeeListByStatusCallSuccess(_offlineALLEmployeeListData);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _inquiryBloc,
      child: BlocConsumer<InquiryBloc, InquiryStates>(
        builder: (BuildContext context, InquiryStates state) {
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          return false;
        },
        listener: (BuildContext context, InquiryStates state) {
          if (state is InquiryShareResponseState) {
            _OnInquiryShareSucessResponse(state);
          }
        },
        listenWhen: (oldState, currentState) {
          if (currentState is InquiryShareResponseState) {
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
            'Lead Share',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          ),
          gradient: const LinearGradient(colors: [
            Color(0xff108dcf),
            Color(0xff0066b3),
            Color(0xff108dcf),
          ]),
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
                child: _buildEmployeeList(context, r),
              ),
              _buildShareButton(context, r),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context, _R r) {
    int selectedCount =
        arrinquiryShareModel.where((item) => item.ISCHECKED == true).length;

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
            child: Icon(Icons.share_outlined,
                color: const Color(0xff108dcf), size: r.s(24)),
          ),
          SizedBox(width: r.s(14)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Share Lead",
                  style: TextStyle(
                    fontSize: r.f(14),
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff1A2332),
                  ),
                ),
                SizedBox(height: r.s(4)),
                Text(
                  "Select employees to share this lead",
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
              color: selectedCount > 0
                  ? const Color(0xff62bb47).withOpacity(0.1)
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(r.s(20)),
            ),
            child: Text(
              "$selectedCount Selected",
              style: TextStyle(
                fontSize: r.f(10),
                fontWeight: FontWeight.w600,
                color: selectedCount > 0
                    ? const Color(0xff62bb47)
                    : Colors.grey.shade500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeList(BuildContext context, _R r) {
    if (arrinquiryShareModel.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(NO_DATA_ANIMATED, height: r.s(150), width: r.s(150)),
            SizedBox(height: r.s(16)),
            Text(
              "No employees found",
              style: TextStyle(
                fontSize: r.f(14),
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: r.s(16)),
      itemCount: arrinquiryShareModel.length,
      itemBuilder: (context, index) {
        return _buildEmployeeCard(context, r, index);
      },
    );
  }

  Widget _buildEmployeeCard(BuildContext context, _R r, int index) {
    final model = arrinquiryShareModel[index];
    bool isSelected = model.ISCHECKED == true;

    return Container(
      margin: EdgeInsets.only(bottom: r.s(10)),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(r.s(14)),
        ),
        elevation: 2,
        shadowColor: Colors.blue.withOpacity(0.1),
        color: isSelected ? const Color(0xffE8F5E9) : Colors.white,
        child: InkWell(
          onTap: () {
            setState(() {
              model.ISCHECKED = !isSelected;
              arrinquiryShareModel[index] = model;
            });
          },
          borderRadius: BorderRadius.circular(r.s(14)),
          child: Container(
            padding:
                EdgeInsets.symmetric(horizontal: r.s(14), vertical: r.s(12)),
            child: Row(
              children: [
                Container(
                  width: r.s(44),
                  height: r.s(44),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xff0066b3).withOpacity(0.1),
                  ),
                  child: Center(
                    child: Text(
                      model.EmployeeName?.substring(0, 1).toUpperCase() ?? "E",
                      style: TextStyle(
                        fontSize: r.f(18),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff0066b3),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: r.s(14)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.EmployeeName ?? "N/A",
                        style: TextStyle(
                          fontSize: r.f(14),
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff1A2332),
                        ),
                      ),
                      SizedBox(height: r.s(2)),
                      Text(
                        "Employee",
                        style: TextStyle(
                          fontSize: r.f(10),
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: r.s(22),
                  height: r.s(22),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? const Color(0xff62bb47)
                        : Colors.grey.shade300,
                  ),
                  child: isSelected
                      ? Icon(Icons.check, size: r.s(14), color: Colors.white)
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShareButton(BuildContext context, _R r) {
    int selectedCount =
        arrinquiryShareModel.where((item) => item.ISCHECKED == true).length;

    return Container(
      padding: EdgeInsets.fromLTRB(r.s(16), r.s(12), r.s(16), r.s(24)),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () => _onSharePressed(),
        child: Container(
          height: r.s(50),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xff108dcf), Color(0xff0066b3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(r.s(14)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xff0066b3).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.send_rounded, color: Colors.white, size: r.s(20)),
                SizedBox(width: r.s(10)),
                Text(
                  "Share Lead ${selectedCount > 0 ? "($selectedCount)" : ""}",
                  style: TextStyle(
                    fontSize: r.f(15),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSharePressed() {
    var selectedCount =
        arrinquiryShareModel.where((item) => item.ISCHECKED == true).length;

    if (selectedCount == 0) {
      showCommonDialogWithSingleOption(
        context,
        "Please select at least one employee to share the lead!",
        positiveButtonTitle: "OK",
      );
    } else {
      List<InquiryShareModel> selectedEmployees =
          arrinquiryShareModel.where((item) => item.ISCHECKED == true).toList();
      _inquiryBloc.add(InquiryShareModelCallEvent(selectedEmployees));
    }
  }

  void _onFollowerEmployeeListByStatusCallSuccess(
      ALL_EmployeeList_Response offlineFollowerEmployeeListData) {
    arrinquiryShareModel.clear();

    String INQFFTNO = "";

    for (var i = 0; i < _arr_inquiry_share_emp_list.length; i++) {
      INQFFTNO = _arr_inquiry_share_emp_list[i].inquiryNo;
    }

    for (var i = 0; i < offlineFollowerEmployeeListData.details.length; i++) {
      int empID = offlineFollowerEmployeeListData.details[i].pkID;
      bool isChecked = false;

      for (var i1 = 0; i1 < _arr_inquiry_share_emp_list.length; i1++) {
        if (_arr_inquiry_share_emp_list[i1].employeeID == empID) {
          isChecked = true;
          break;
        }
      }

      inquiryShareModel = InquiryShareModel(
        LoginUserID,
        empID.toString(),
        CompanyID.toString(),
        INQFFTNO,
        isChecked,
        offlineFollowerEmployeeListData.details[i].employeeName,
      );
      arrinquiryShareModel.add(inquiryShareModel);
    }

    setState(() {});
  }

  void _OnInquiryShareSucessResponse(InquiryShareResponseState state) async {
    String msg = "";
    for (var i = 0; i < state.inquiryShareResponse.details.length; i++) {
      msg = state.inquiryShareResponse.details[i].column2;
      if (msg == "") {
        msg = "Inquiry Shared Successfully!";
      }
      await showCommonDialogWithSingleOption(
        Globals.context,
        msg,
        positiveButtonTitle: "OK",
        onTapOfPositiveButton: () {
          Navigator.of(context).pop();
        },
      );
    }
  }

  Future<bool> _onBackPressed() async {
    Navigator.of(context).pop();
    return false;
  }
}
