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
import 'package:soleoserp/ui/screens/DashBoard/Modules/reports_screen/customer_reports_screen/pdf_View.dart';
import 'package:soleoserp/ui/screens/DashBoard/home_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/ui/widgets/common_widgets.dart';
import 'package:soleoserp/utils/date_time_extensions.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';

class ReportListScreen extends BaseStatefulWidget {
  static const routeName = '/ReportListScreen';

  @override
  _ReportListScreenState createState() => _ReportListScreenState();
}

class _ReportListScreenState extends BaseState<ReportListScreen>
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

    _mainBloc
      .add(CustomerReportsListCallEvent(
          1,
        CustomerReportListRequest(
              companyId: CompanyID,
              loginUserID: LoginUserID,
              CustomerID: "",
              ListMode: "",
        )));


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
          if (state is CustomerReportsCallState) {
            _onCustomerReportsResponseSuccess(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is CustomerReportsCallState) {
            return true;
          }
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
          child: _buildInquiryList(),
        ),
      ),
    );
  }

  Widget _buildInquiryList() {
    if (Response == null) {
      return Container();
    }
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (shouldPaginate(
          scrollInfo,
        )) {
          _onProductMasterPagination();
          return true;
        } else {
          return false;
        }
      },
      child: Response.details.length != 0
          ? ListView.builder(
        key: Key('selected $selected'),
        itemBuilder: (context, index) {
          return _buildCustomerList(index);
        },
        shrinkWrap: true,
        itemCount: 1,
      )
          : Container()
    );
  }

  Widget _buildCustomerList(int index) {
    return ExpantionCustomer(context, index);
  }

  void _onProductMasterPagination() {
    _mainBloc
        .add(CustomerReportsListCallEvent(
        _pageNo+1,
        CustomerReportListRequest(
          companyId: CompanyID,
          loginUserID: LoginUserID,
          CustomerID: "",
          ListMode: "",
        )));
  }


  Widget ExpantionCustomer(BuildContext context, int index) {
    List<CustomerDetails> PD = Response.details;

    return
      Container(
        margin: EdgeInsets.only(left: 50, right: 50, top: 30),
        height: 50,
        child: ElevatedButton(
            onPressed: (){
              _displayPdf(PD);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: colorPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.bold)),
            child: Text("Customer Report", style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w600
            ),)),
      );
  }

  void _displayPdf(List<CustomerDetails> productPaginationDetails) {
    final doc = pw.Document();
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a3,
        build: (pw.Context context) => [
          pw.Header(
              level: 0,
              child:

              pw.Center(
                child: pw.Text('Customer Report', style: pw.TextStyle(fontSize: 25, fontWeight: pw.FontWeight.bold)),
              )
          ),
          pw.SizedBox(
              height: 40
          ),
          pw.Table.fromTextArray(
            border: pw.TableBorder.all(),
            cellAlignment: pw.Alignment.center,
            cellHeight: 30,
            cellPadding: pw.EdgeInsets.all(5),
            headerAlignment: pw.Alignment.center,
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8),
            cellStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8),
            headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
            headers: ['Sr No.', 'Customer Name', 'Customer Type', 'Address', 'City', 'State', 'Country', 'ContactNo1', 'EmailAddress','Source','Employee Name'],
            columnWidths: {
              0: pw.FlexColumnWidth(1),
              1: pw.FlexColumnWidth(2.5), // Serial Number
              2: pw.FlexColumnWidth(2.5), // Serial Number
              3: pw.FlexColumnWidth(4), // Serial Number
              4: pw.FlexColumnWidth(2), // Serial Number
              5: pw.FlexColumnWidth(1.5), // Serial Number
              6: pw.FlexColumnWidth(2), // Serial Number
              7: pw.FlexColumnWidth(2), // Serial Number
              8: pw.FlexColumnWidth(3), // Serial Number
              9: pw.FlexColumnWidth(3), // Serial Number
              10: pw.FlexColumnWidth(2), // Serial Number
              11: pw.FlexColumnWidth(2), // Serial Number
            },
            data: List<List<dynamic>>.generate(
              productPaginationDetails.length,
                  (index) => [
                index + 1,
                productPaginationDetails[index].customerName,
                productPaginationDetails[index].customerType,
                productPaginationDetails[index].address,
                productPaginationDetails[index].cityName,
                productPaginationDetails[index].stateName,
                productPaginationDetails[index].countryName,
                productPaginationDetails[index].contactNo1,
                productPaginationDetails[index].emailAddress,
                productPaginationDetails[index].customerSourceName,
                productPaginationDetails[index].createdBy,
              ],
            ),
          ),
        ],
      ),
    );

    Navigator.push(context, MaterialPageRoute(builder: (context) => PreviewScreen(doc: doc, PdfName: "CustomerReport")));
  }

  Future<bool> _onBackPressed() {
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
  }

  void _onCustomerReportsResponseSuccess(CustomerReportsCallState state) {
    Response = state.response;
  }
}

