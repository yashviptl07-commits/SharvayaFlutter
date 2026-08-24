// ignore_for_file: missing_return

import 'dart:io';

import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:soleoserp/blocs/MainBloc/mainBloc.dart';
import 'package:soleoserp/models/api_requests/Reports/customer_list.dart';
import 'package:soleoserp/models/api_requests/customer/customer_paggination_request.dart';
import 'package:soleoserp/models/api_requests/purchase_bill_screen/purchase_bill_list_screen_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/customer/customer_details_api_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/purchase_bill_screen/purchase_bill_list_screen_response.dart';
import 'package:soleoserp/models/common/all_name_id_list.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/res/image_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Purchase_screen/purchase_bill_screens/purchase_bill_add_edit/purchase_bill_add_edit_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/reports_screen/customer_reports_screen/Main_Screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/reports_screen/customer_reports_screen/pdf_View.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/reports_screen/inquiry_list_screen/Inquiry_reports_Screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/reports_screen/quotation_list_screen/quotation_list_reports.dart';
import 'package:soleoserp/ui/screens/DashBoard/home_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/ui/widgets/common_widgets.dart';
import 'package:soleoserp/utils/date_time_extensions.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';

class MainReportListScreen extends BaseStatefulWidget {
  static const routeName = '/MainReportListScreen';

  @override
  _MainReportListScreenState createState() => _MainReportListScreenState();
}

class _MainReportListScreenState extends BaseState<MainReportListScreen>
    with BasicScreen, WidgetsBindingObserver {
  MainBloc _mainBloc;
  Function refreshList;
  CustomerDetailsResponse Response;
  int _pageNo = 0;
  LoginUserDetialsResponse _offlineLoggedInData;
  CompanyDetailsResponse _offlineCompanyData;
  int CompanyID = 0;
  String LoginUserID = "";
  double CardViewHieght = 50;
  bool isDeleteVisible = true;
  int selected = 0;
  bool isExpand = false;
  double _fontSize_Label = 12;
  double _fontSize_Title = 15;
  final TextEditingController edt_CustomerName = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  List<File> documentList = [];
  int FinalTotalCount = 0;
  List<ALL_Name_ID> arr_ALL_Name_ID_For_LeadStatus = [];

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = colorPrimary;
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;
    _mainBloc = MainBloc(baseBloc);
    isExpand = false;
    edt_CustomerName.text = "";

    isDeleteVisible = viewvisiblitiyAsperClient(
        SerailsKey: _offlineLoggedInData.details[0].serialKey,
        RoleCode: _offlineLoggedInData.details[0].roleCode);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: true,
      create: (BuildContext context) => _mainBloc
        ..add(CustomerReportsListCallEvent(
            1,
            CustomerReportListRequest(
              companyId: CompanyID,
              loginUserID: LoginUserID,
              CustomerID: "",
              ListMode: "",
            ))),
      child: BlocConsumer<MainBloc, MainStates>(
        builder: (BuildContext context, MainStates state) {
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          return false;
        },
        listener: (BuildContext context, MainStates state) {
        },
        listenWhen: (oldState, currentState) {
          return false;
        },
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: colorWhite,
        appBar: NewGradientAppBar(
          title: Text('Reports Screen'),
          gradient: LinearGradient(colors: [
            Color(0xff108dcf),
            Color(0xff0066b3),
            Color(0xff62bb47),
          ]),
          leading: InkWell(
              onTap: () {
                navigateTo(context, HomeScreen.routeName, clearAllStack: true);
              },
              child: Icon(Icons.arrow_back_outlined)),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.water_damage_sharp,
                  color: colorWhite,
                  size: 30,
                ),
                onPressed: () {
                  navigateTo(context, HomeScreen.routeName,
                      clearAllStack: true);
                }),
          ],
        ),
        body: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                  child: Text("Leads", style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: colorBlack
                  ),)),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(width: 10),
                    ElevatedButton(onPressed: (){
                      navigateTo(context, ReportListScreen.routeName,
                          clearAllStack: true);
                    },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: colorPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            textStyle: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        child: Text("Customer Reports")),
                    SizedBox(width: 10),
                    ElevatedButton(onPressed: (){
                      navigateTo(context, InquiryReportListScreen.routeName,
                          clearAllStack: true);
                    },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: colorPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            textStyle: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        child: Text("Inquiry Reports")),
                    SizedBox(width: 10),
                    ElevatedButton(onPressed: (){
                      /*navigateTo(context, QuotationReportListScreen.routeName,
                          clearAllStack: true);*/
                    },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: colorPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            textStyle: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        child: Text("Quotation Reports")),
                    SizedBox(width: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
  }

}

