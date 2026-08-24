import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:soleoserp/blocs/MainBloc/mainBloc.dart';
import 'package:soleoserp/models/api_requests/Material_Inward_Request/Get_FetDetail_By_OrdedNo_Request.dart';
import 'package:soleoserp/models/api_requests/Material_Inward_Request/Get_OrdedNo_From_TheCustomerId_Request.dart';
import 'package:soleoserp/models/api_requests/Material_Inward_Request/Location_List_Request.dart';
import 'package:soleoserp/models/api_requests/Material_Inward_Request/Material_Inward_Customer_List_Request.dart';
import 'package:soleoserp/models/api_requests/Material_Inward_Request/Material_Inward_Details_LIst_Request.dart';
import 'package:soleoserp/models/api_requests/Material_Inward_Request/Material_Inward_Master_Save_Request.dart';
import 'package:soleoserp/models/api_requests/Material_Outward_Request/material_outward_for_get_so_by_fetchTyoe_details_list_request.dart';
import 'package:soleoserp/models/api_requests/Material_Outward_Request/material_outward_for_get_so_details_list_request.dart';
import 'package:soleoserp/models/api_requests/Material_Outward_Request/material_outward_for_get_so_list_request.dart';
import 'package:soleoserp/models/api_requests/service_report_request/service_report_add_update_request.dart';
import 'package:soleoserp/models/api_requests/service_report_request/service_report_details_list_request.dart';
import 'package:soleoserp/models/api_requests/service_report_request/service_report_machibe_type_request.dart';
import 'package:soleoserp/models/api_responses/Material_Inward_Responce/Material_Inward_list_Responce.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/customer/customer_label_value_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/service_report_response/service_report_list_response.dart';
import 'package:soleoserp/models/common/Common_model_table.dart';
import 'package:soleoserp/models/common/MaterialOutwardDetailsTable.dart';
import 'package:soleoserp/models/common/Material_Inward_Product_table.dart';
import 'package:soleoserp/models/common/all_name_id_list.dart';
import 'package:soleoserp/models/common/workNotes_model.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/res/image_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Material_Inward/Material_Inward/Material_Inward_Detail_Screen/test_list_inward.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Material_Inward/Material_Inward/Material_Inward_Header_Screen/Material_Inward_Header_List_Screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Service_Report/Service_Report_Details/service_report_details_list.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Service_Report/Service_Report_Header/Service_Report_Header_List.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/followup/search_followup_customer_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/other_screens/dropdownscreen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/salebill/sales_bill_add_edit/module_no_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/home_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/ui/widgets/common_widgets.dart';
import 'package:soleoserp/utils/date_time_extensions.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/offline_db_helper.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';

class ServiceReportAddEditScreenArguments {
  ServiceReportListResponseDetails editModel;
  ServiceReportAddEditScreenArguments(this.editModel);
}

class ServiceReportAddEditScreen extends BaseStatefulWidget {
  static const routeName = '/ServiceReportAddEditScreen';
  final ServiceReportAddEditScreenArguments arguments;

  ServiceReportAddEditScreen(this.arguments);

  @override
  _ServiceReportAddEditScreenState createState() =>
      _ServiceReportAddEditScreenState();
}

class _ServiceReportAddEditScreenState
    extends BaseState<ServiceReportAddEditScreen>
    with BasicScreen, WidgetsBindingObserver {
  MainBloc _mainBloc;
  Function refreshList;
  LoginUserDetialsResponse _offlineLoggedInData;
  CompanyDetailsResponse _offlineCompanyData;
  int CompanyID = 0;
  String LoginUserID = "";
  double CardViewHieght = 50;
  bool _isSwitched;
  bool _isForUpdate;
  FocusNode PicCodeFocus;
  SearchDetails _searchDetails;
  FocusNode myFocusNode;
  int pkID = 0;
  int CustomerId = 0;
  String InquiryNo = "";
  ServiceReportListResponseDetails _editModel;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  bool isCompare;
  DateTime selectedLRDate = DateTime.now();
  DateTime selectedDeliveryDate = DateTime.now();
  DateTime selectedInvoiceDate = DateTime.now();

  /// For New
  final TextEditingController edt_ServiceNo = TextEditingController();
  final TextEditingController edt_Service_date = TextEditingController();
  final TextEditingController edt_Rev_Service_date = TextEditingController();
  final TextEditingController edt_Customer = TextEditingController();
  final TextEditingController edt_CustomerId = TextEditingController();
  final TextEditingController edt_MachineTypeName = TextEditingController();
  final TextEditingController edt_MachineTypeId = TextEditingController();
  final TextEditingController edt_ModelNo = TextEditingController();
  final TextEditingController edt_OperationType = TextEditingController();
  final TextEditingController edt_OperationTypeOne = TextEditingController();
  final TextEditingController edt_EngineerNotes = TextEditingController();
  final TextEditingController edt_CustomerNotes = TextEditingController();
  final TextEditingController edt_MachinePerformance = TextEditingController();
  final TextEditingController edt_ConveynanceCharge = TextEditingController();
  final TextEditingController edt_TravellingCharge = TextEditingController();
  final TextEditingController edt_ComponentsCharge = TextEditingController();
  final TextEditingController edt_ServiceCharge = TextEditingController();
  final TextEditingController edt_Remark = TextEditingController();

  bool isDropdownVisible = false;
  bool isSaving = false;
  Set<String> savedProductIDs = {};

  List<ALL_Name_ID> arr_ALL_Name_ID_For_MachineType = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_OperationType = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_OperationTypeOne = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_CustomerName = [];

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
    myFocusNode = FocusNode();
    PicCodeFocus = FocusNode();
    getOperationType();
    getOperationTypeOne();
    isCompare = false;
    _isForUpdate = widget.arguments != null;

    if (_isForUpdate) {
      _editModel = widget.arguments.editModel;
      fillData();
    } else {
      edt_Service_date.text = selectedDate.day.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.year.toString();
      edt_Rev_Service_date.text = selectedDate.year.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.day.toString();

      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    myFocusNode.dispose();
    PicCodeFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _mainBloc,
      child: BlocConsumer<MainBloc, MainStates>(
        builder: (BuildContext context, MainStates state) {
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          return false;
        },
        listener: (BuildContext context, MainStates state) {
          if (state is ServiceReportAddUpdateResponseState) {
            _onServiceReportAddUpdateResponseState(state);
          }
          if (state is MachineTypeResponseState) {
            _onMachineTypeResponseState(state);
          }
          if (state is ServiceReportDetailsListResponseState) {
            _onServiceReportDetailsListResponseState(state);
          }
        },
        listenWhen: (oldState, currentState) {
          if (currentState is ServiceReportAddUpdateResponseState) {
            return true;
          }
          if (currentState is MachineTypeResponseState) {
            return true;
          }
          if (currentState is ServiceReportDetailsListResponseState) {
            return true;
          }
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
          title:
              Text('Service Report ${_isForUpdate == true ? "Update" : "Add"}'),
          gradient: LinearGradient(colors: [
            Color(0xff108dcf),
            Color(0xff0066b3),
            Color(0xff108dcf),
          ]),
          leading: InkWell(
              onTap: () async {
                navigateTo(context, ServiceReportListScreens.routeName,
                    clearAllStack: true);
              },
              child: Icon(Icons.arrow_back_outlined)),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.water_damage_sharp,
                  color: colorWhite,
                ),
                onPressed: () {
                  //_onTapOfLogOut();
                  navigateTo(context, HomeScreen.routeName,
                      clearAllStack: true);
                }),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(
                  left: 5,
                  right: 5,
                  top: 10,
                ),
                child: Column(
                  children: [
                    _isForUpdate == true
                        ? Column(
                            children: [
                              ServiceNo(),
                              SizedBox(height: 15),
                            ],
                          )
                        : Container(),
                    ServiceDate(),
                    SizedBox(height: 15),
                    _buildSearchView(),
                    SizedBox(height: 15),
                    CustomDropDownLocation(
                      "Machine Type",
                      enable1: false,
                      icon: Icon(Icons.arrow_drop_down),
                      controllerVehical: edt_MachineTypeName,
                      vehicalList: arr_ALL_Name_ID_For_MachineType,
                    ),
                    SizedBox(height: 15),
                    ModelNo(),
                    SizedBox(height: 15),
                    CustomDropDown1("Operation Type",
                        enable1: false,
                        title: "Select Operation Type",
                        hintTextvalue: "Tap to select",
                        icon: Icon(Icons.arrow_drop_down),
                        controllerForLeft: edt_OperationType,
                        Custom_values1: arr_ALL_Name_ID_For_OperationType),
                    SizedBox(height: 15),
                    CustomDropDown1("Operation Type",
                        enable1: false,
                        title: "Select Operation Type",
                        hintTextvalue: "Tap to select",
                        icon: Icon(Icons.arrow_drop_down),
                        controllerForLeft: edt_OperationTypeOne,
                        Custom_values1: arr_ALL_Name_ID_For_OperationTypeOne),
                    SizedBox(height: 15),
                    EngineerNotes(),
                    SizedBox(height: 15),
                    CustomerNotes(),
                    SizedBox(height: 15),
                    MachinePerformance(),
                    SizedBox(height: 15),
                    ConveyanceCharge(),
                    SizedBox(height: 15),
                    TravellingCharge(),
                    SizedBox(height: 15),
                    ComponentsCharge(),
                    SizedBox(height: 15),
                    ServiceCharge(),
                    SizedBox(height: 30),
                    Container(
                      margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
                      alignment: Alignment.bottomCenter,
                      child: getCommonButton(baseTheme, () {
                        if (edt_Customer.text != "") {
                          navigateTo(
                              context, ServiceReportWorkNotesScreen.routeName,
                              arguments: ServiceReportWorkNotesScreenArgument(
                                edt_ServiceNo.text,
                              ));
                        } else {
                          showCommonDialogWithSingleOption(
                              context, "Customer Name Is Required!!",
                              positiveButtonTitle: "OK",
                              onTapOfPositiveButton: () {
                            Navigator.of(context).pop();
                          });
                        }
                      }, "Work Notes",
                          width: 600,
                          textColor: colorWhite,
                          backGroundColor: colorDarkBlue,
                          radius: 25.0),
                    ),
                    SizedBox(height: 15),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        child: Text(
                          "Save",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () async {
                          _onTapOfSaveVehiclePunchAPICall();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget ServiceNo() {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          child: Text("Service No",
              style: TextStyle(
                  fontSize: 12,
                  color: colorBlack,
                  fontWeight: FontWeight
                      .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

              ),
        ),
        SizedBox(
          height: 5,
        ),
        Card(
          margin: EdgeInsets.only(left: 15, right: 15),
          elevation: 5,
          color: Colors.grey[50],
          shadowColor: Colors.blue,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: 50,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                      controller: edt_ServiceNo,
                      enabled: false,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        counterText: "",
                        hintText: "",
                        labelStyle: TextStyle(
                          color: Color(0xFF000000),
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF000000),
                      ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  Widget ServiceDate() {
    return Container(
      child: InkWell(
        onTap: () {
          _selectNextFollowupDate(context, edt_Service_date);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              child: Text("Service Date *",
                  style: TextStyle(
                      fontSize: 12,
                      color: colorBlack,
                      fontWeight: FontWeight
                          .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                  ),
            ),
            SizedBox(
              height: 5,
            ),
            Card(
              margin: EdgeInsets.only(left: 15, right: 15),
              elevation: 5,
              color: Colors.grey[50],
              shadowColor: Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Container(
                height: 50,
                padding: EdgeInsets.only(left: 20, right: 20),
                width: double.maxFinite,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        edt_Service_date.text == null ||
                                edt_Service_date.text == ""
                            ? "YYYY-MM--DD"
                            : edt_Service_date.text,
                        style: baseTheme.textTheme.displaySmall.copyWith(
                            color: edt_Rev_Service_date.text == null ||
                                    edt_Rev_Service_date.text == ""
                                ? colorGrayDark
                                : colorBlack),
                      ),
                    ),
                    Icon(
                      Icons.calendar_today_outlined,
                      color: colorGrayDark,
                      size: 18.w,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSearchView() {
    return InkWell(
        onTap: () {
          if (!_isForUpdate) {
            _onTapOfSearchView();
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Select Customer *",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 8),
            Card(
              margin: EdgeInsets.symmetric(horizontal: 16),
              elevation: 8,
              color: Colors.grey[50],
              shadowColor: Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Container(
                height: 55,
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        enabled: false,
                        textInputAction: TextInputAction.next,
                        controller: edt_Customer,
                        decoration: InputDecoration(
                          hintText: "Search customer",
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ),
                    Icon(
                      Icons.search,
                      color: colorGrayDark,
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Future<void> _onTapOfSearchView() async {
    navigateTo(context, SearchFollowupCustomerScreen.routeName).then((value) {
      if (value != null) {
        _searchDetails = value;
        edt_CustomerId.text = _searchDetails.value.toString();
        edt_Customer.text = _searchDetails.label.toString();

        _mainBloc.add(MaterialInwardGetPoNoRequestEvent(
            MIGetOrderNoFromTheCustomerIdRequest(
                CustomerID: edt_CustomerId.text,
                ModuleType: "PurchaseOrder",
                CompanyId: CompanyID.toString())));
      }
    });
  }

  Future<void> _selectNextFollowupDate(
      BuildContext context, TextEditingController F_datecontroller) async {
    DateTime selectedDate = DateTime.now();
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: selectedDate,
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        edt_Service_date.text = selectedDate.day.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.year.toString();
        edt_Rev_Service_date.text = selectedDate.year.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.day.toString();
      });
  }

  Widget CustomDropDownLocation(
    String Outsource, {
    bool enable1,
    Icon icon,
    TextEditingController controllerVehical,
    List<ALL_Name_ID> vehicalList,
  }) {
    return Container(
      child: Column(
        children: [
          InkWell(
              onTap: () {
                if (!_isForUpdate) {
                  _mainBloc.add(MachineTypeListCallEvent(
                      MachineMasterListRequest(
                          LoginUserID: LoginUserID,
                          CompanyId: CompanyID.toString(),
                          pkID: "0",
                          PageNo: "1",
                          PageSize: "100000",
                          SearchKey: "")));
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Machine Type *",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Card(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    elevation: 8,
                    color: Colors.grey[50],
                    shadowColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Container(
                      height: 55,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              enabled: false,
                              textInputAction: TextInputAction.next,
                              controller: controllerVehical,
                              decoration: InputDecoration(
                                hintText: "--- Select ---",
                                hintStyle:
                                    TextStyle(color: Colors.grey.shade400),
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                  fontSize: 16, color: Colors.black87),
                            ),
                          ),
                          edt_MachineTypeName.text != ""
                              ? !_isForUpdate
                                  ? InkWell(
                                      onTap: () {
                                        edt_MachineTypeName.text = "";
                                        edt_MachineTypeId.text = "0";
                                        edt_ModelNo.text = "";
                                        setState(() {});
                                      },
                                      child: Icon(
                                        Icons.close,
                                        color: colorGrayDark,
                                      ),
                                    )
                                  : Icon(
                                      Icons.arrow_drop_down,
                                      color: colorGrayDark,
                                    )
                              : Icon(
                                  Icons.arrow_drop_down,
                                  color: colorGrayDark,
                                )
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  void _onMachineTypeResponseState(MachineTypeResponseState state) {
    arr_ALL_Name_ID_For_MachineType.clear();
    if (state.response.details.length != 0) {
      for (var i = 0; i < state.response.details.length; i++) {
        ALL_Name_ID categoryResponse123 = ALL_Name_ID();
        categoryResponse123.Name = state.response.details[i].machineNameLong;
        categoryResponse123.pkID = state.response.details[i].pkID;
        categoryResponse123.Name1 = state.response.details[i].modelNo;
        arr_ALL_Name_ID_For_MachineType.add(categoryResponse123);
      }

      if (arr_ALL_Name_ID_For_MachineType.length != 0) {
        navigateTo(context, VehicleListDropDownScreen.routeName,
                arguments: VehicleListDropDownScreenArgument(
                    arr_ALL_Name_ID_For_MachineType,
                    "Types Of MachineType List",
                    "Three Chars To Search MachineType",
                    "Tap To Enter MachineType"))
            .then((value) {
          if (value.toString() == "clear") {
            edt_MachineTypeName.text = "";
            edt_MachineTypeId.text = "0";
            edt_ModelNo.text = "";
          } else {
            ALL_Name_ID model = value;
            edt_MachineTypeName.text = model.Name;
            edt_MachineTypeId.text = model.pkID.toString();
            edt_ModelNo.text = model.Name1;
          }

          setState(() {});
        });
      }
    }
  }

  Widget ModelNo() {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          child: Text("Model No",
              style: TextStyle(
                  fontSize: 12,
                  color: colorBlack,
                  fontWeight: FontWeight
                      .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

              ),
        ),
        SizedBox(
          height: 5,
        ),
        Card(
          margin: EdgeInsets.only(left: 15, right: 15),
          elevation: 5,
          color: Colors.grey[50],
          shadowColor: Colors.blue,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: 50,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                      controller: edt_ModelNo,
                      enabled: false,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        counterText: "",
                        hintText: "",
                        labelStyle: TextStyle(
                          color: Color(0xFF000000),
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF000000),
                      ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  Widget ConveyanceCharge() {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          child: Text("Conveyance Charge",
              style: TextStyle(
                  fontSize: 12,
                  color: colorBlack,
                  fontWeight: FontWeight
                      .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

              ),
        ),
        SizedBox(
          height: 5,
        ),
        Card(
          margin: EdgeInsets.only(left: 15, right: 15),
          elevation: 5,
          color: Colors.grey[50],
          shadowColor: Colors.blue,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: 50,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                      controller: edt_ConveynanceCharge,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      decoration: InputDecoration(
                        counterText: "",
                        hintText: "",
                        labelStyle: TextStyle(
                          color: Color(0xFF000000),
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF000000),
                      ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  Widget TravellingCharge() {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          child: Text("Travelling Charge",
              style: TextStyle(
                  fontSize: 12,
                  color: colorBlack,
                  fontWeight: FontWeight
                      .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

              ),
        ),
        SizedBox(
          height: 5,
        ),
        Card(
          margin: EdgeInsets.only(left: 15, right: 15),
          elevation: 5,
          color: Colors.grey[50],
          shadowColor: Colors.blue,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: 50,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                      controller: edt_TravellingCharge,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      decoration: InputDecoration(
                        counterText: "",
                        hintText: "",
                        labelStyle: TextStyle(
                          color: Color(0xFF000000),
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF000000),
                      )),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  Widget ComponentsCharge() {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          child: Text("Components Charge",
              style: TextStyle(
                  fontSize: 12,
                  color: colorBlack,
                  fontWeight: FontWeight
                      .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

              ),
        ),
        SizedBox(
          height: 5,
        ),
        Card(
          margin: EdgeInsets.only(left: 15, right: 15),
          elevation: 5,
          color: Colors.grey[50],
          shadowColor: Colors.blue,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: 50,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                      controller: edt_ComponentsCharge,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      decoration: InputDecoration(
                        counterText: "",
                        hintText: "",
                        labelStyle: TextStyle(
                          color: Color(0xFF000000),
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF000000),
                      ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  Widget ServiceCharge() {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          child: Text("Service Charge",
              style: TextStyle(
                  fontSize: 12,
                  color: colorBlack,
                  fontWeight: FontWeight
                      .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

              ),
        ),
        SizedBox(
          height: 5,
        ),
        Card(
          margin: EdgeInsets.only(left: 15, right: 15),
          elevation: 5,
          color: Colors.grey[50],
          shadowColor: Colors.blue,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: 50,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                      controller: edt_ServiceCharge,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      decoration: InputDecoration(
                        counterText: "",
                        hintText: "",
                        labelStyle: TextStyle(
                          color: Color(0xFF000000),
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF000000),
                      ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  Widget CustomDropDown1(
    String Category, {
    bool enable1,
    Icon icon,
    String title,
    String hintTextvalue,
    TextEditingController controllerForLeft,
    List<ALL_Name_ID> Custom_values1,
    Function(String selectedValue) onClose, // <-- Add this callback
  }) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            child: Text(
              '$Category',
              style: TextStyle(
                fontSize: 12,
                color: colorBlack,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              final result = await showcustomdialogWithOnlyName(
                values: Custom_values1,
                context1: context,
                controller: controllerForLeft,
                lable: "Select $Category",
              );

              if (result != null && onClose != null) {
                onClose(result); // Call the callback with selected value
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  margin: EdgeInsets.only(left: 15, right: 15),
                  elevation: 8,
                  color: Colors.grey[50],
                  shadowColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            enabled: false,
                            textInputAction: TextInputAction.next,
                            controller: controllerForLeft,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              hintText: "--- Select ---",
                              hintStyle: TextStyle(color: Colors.grey.shade400),
                              border: InputBorder.none,
                              isCollapsed: true,
                            ),
                            style:
                                TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: colorGrayDark,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void getOperationType() {
    arr_ALL_Name_ID_For_OperationType.clear();
    for (var i = 0; i < 2; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      if (i == 0) {
        all_name_id.Name = "Installation Machine";
      } else if (i == 1) {
        all_name_id.Name = "Service Machine";
      }
      arr_ALL_Name_ID_For_OperationType.add(all_name_id);
    }
  }

  void getOperationTypeOne() {
    arr_ALL_Name_ID_For_OperationTypeOne.clear();
    for (var i = 0; i < 3; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      if (i == 0) {
        all_name_id.Name = "Under Warranty";
      } else if (i == 1) {
        all_name_id.Name = "Outer Warranty";
      } else if (i == 2) {
        all_name_id.Name = "Annual Maintenance";
      }
      arr_ALL_Name_ID_For_OperationTypeOne.add(all_name_id);
    }
  }

  Widget EngineerNotes() {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          child: Text("Engineer Notes",
              style: TextStyle(
                  fontSize: 12,
                  color: colorBlack,
                  fontWeight: FontWeight
                      .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

              ),
        ),
        SizedBox(
          height: 5,
        ),
        Card(
          margin: EdgeInsets.only(left: 15, right: 15),
          elevation: 5,
          color: Colors.grey[50],
          shadowColor: Colors.blue,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: 100,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                      maxLines: 5,
                      controller: edt_EngineerNotes,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        counterText: "",
                        hintText: "",
                        labelStyle: TextStyle(
                          color: Color(0xFF000000),
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF000000),
                      ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  Widget CustomerNotes() {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          child: Text("Customer Notes",
              style: TextStyle(
                  fontSize: 12,
                  color: colorBlack,
                  fontWeight: FontWeight
                      .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

              ),
        ),
        SizedBox(
          height: 5,
        ),
        Card(
          margin: EdgeInsets.only(left: 15, right: 15),
          elevation: 5,
          color: Colors.grey[50],
          shadowColor: Colors.blue,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: 100,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                      maxLines: 5,
                      controller: edt_CustomerNotes,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        counterText: "",
                        hintText: "",
                        labelStyle: TextStyle(
                          color: Color(0xFF000000),
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF000000),
                      ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  Widget MachinePerformance() {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          child: Text("Machine Performance",
              style: TextStyle(
                  fontSize: 12,
                  color: colorBlack,
                  fontWeight: FontWeight
                      .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

              ),
        ),
        SizedBox(
          height: 5,
        ),
        Card(
          margin: EdgeInsets.only(left: 15, right: 15),
          elevation: 5,
          color: Colors.grey[50],
          shadowColor: Colors.blue,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: 100,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                      maxLines: 5,
                      controller: edt_MachinePerformance,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        counterText: "",
                        hintText: "",
                        labelStyle: TextStyle(
                          color: Color(0xFF000000),
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF000000),
                      ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  _onTapOfSaveVehiclePunchAPICall() async {
    if (edt_Customer.text.toString().isNotEmpty) {
      if (edt_MachineTypeName.text != "") {
        List<WorkNotesTable> temp =
            await OfflineDbHelper.getInstance().getWorkNotes();

        if (temp.length != 0) {
          showCommonDialogWithTwoOptions(
              context, "Are you sure you want to Save this record?",
              negativeButtonTitle: "No",
              positiveButtonTitle: "Yes", onTapOfPositiveButton: () async {
            Navigator.of(context).pop();

            _mainBloc.add(ServiceReportAddUpdateRequestEvent(
                ServiceReportAddUpdateRequest(
              pkID: pkID.toString(),
              ServiceNo: edt_ServiceNo.text,
              ServiceDate: edt_Rev_Service_date.text,
              CustomerID: edt_CustomerId.text,
              MachineID: edt_MachineTypeId.text,
              MachineModelNo: edt_ModelNo.text,
              OperationType: edt_OperationType.text,
              OperationTypeMachine: edt_OperationTypeOne.text,
              EngineerNotes: edt_EngineerNotes.text,
              CustomerNotes: edt_CustomerNotes.text,
              MachinePerformance: edt_MachinePerformance.text,
              ConveyanceCharge: edt_ConveynanceCharge.text == ""
                  ? "0.00"
                  : edt_ConveynanceCharge.text,
              TravellingCharge: edt_TravellingCharge.text == ""
                  ? "0.00"
                  : edt_TravellingCharge.text,
              ComponentsCharge: edt_ComponentsCharge.text == ""
                  ? "0.00"
                  : edt_ComponentsCharge.text,
              ServiceCharge: edt_ServiceCharge.text == ""
                  ? "0.00"
                  : edt_ServiceCharge.text,
              ServiceRating: "",
              LoginUserID: LoginUserID,
              CompanyId: CompanyID.toString(),
            )));
          });
        } else {
          showCommonDialogWithSingleOption(
              context, "At Least One Item Is Required !!",
              positiveButtonTitle: "OK", onTapOfPositiveButton: () {
            Navigator.of(context).pop();
          });
        }
      } else {
        showCommonDialogWithSingleOption(
            context, "Machine Selection Is Required", positiveButtonTitle: "OK",
            onTapOfPositiveButton: () {
          Navigator.of(context).pop();
        });
      }
    } else {
      showCommonDialogWithSingleOption(context, "Customer Name Is Required",
          positiveButtonTitle: "OK", onTapOfPositiveButton: () {
        Navigator.of(context).pop();
      });
    }
  }

  Future<bool> _onBackPressed() async {
    navigateTo(context, ServiceReportListScreens.routeName,
        clearAllStack: true);
  }

  void _onServiceReportAddUpdateResponseState(
      ServiceReportAddUpdateResponseState state) {
    showCommonDialogWithSingleOption(context,
        state.serviceReportAddUpdateResponse.details[0].column2.toString(),
        positiveButtonTitle: "OK", onTapOfPositiveButton: () async {
      navigateTo(context, ServiceReportListScreens.routeName,
          clearAllStack: true);
    });
  }

  void fillData() async {
    pkID = _editModel.pkID;
    edt_ServiceNo.text = _editModel.serviceNo;
    edt_Service_date.text = _editModel.serviceDate.getFormattedDate(
        fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy");
    edt_Rev_Service_date.text = _editModel.serviceDate.getFormattedDate(
        fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd");
    edt_Customer.text = _editModel.customerName;
    edt_CustomerId.text = _editModel.customerID.toString();
    edt_MachineTypeName.text = _editModel.machineName;
    edt_MachineTypeId.text = _editModel.machineID.toString();
    edt_ModelNo.text = _editModel.machineModelNo;
    edt_OperationType.text = _editModel.operationType;
    edt_OperationTypeOne.text = _editModel.operationTypeMachine;
    edt_EngineerNotes.text = _editModel.engineerNotes;
    edt_CustomerNotes.text = _editModel.customerNotes;
    edt_MachinePerformance.text = _editModel.machinePerformance;
    edt_ConveynanceCharge.text = _editModel.conveyanceCharge.toString();
    edt_TravellingCharge.text = _editModel.travellingCharge.toString();
    edt_ComponentsCharge.text = _editModel.componentsCharge.toString();
    edt_ServiceCharge.text = _editModel.serviceCharge.toString();

    if (_editModel.serviceNo.toString() != "") {
      _mainBloc.add(ServiceReportDetailsListRequestEvent(
          LoginUserID,
          ServiceReportDetailsListRequest(
            ServiceNo: _editModel.serviceNo.toString(),
            CompanyId: CompanyID.toString(),
          )));
    }
  }

  void _onServiceReportDetailsListResponseState(
      ServiceReportDetailsListResponseState state) async {}
}
