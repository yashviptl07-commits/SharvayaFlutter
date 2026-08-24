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
import 'package:soleoserp/models/api_responses/Material_Inward_Responce/Material_Inward_list_Responce.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/customer/customer_label_value_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/common/Common_model_table.dart';
import 'package:soleoserp/models/common/MaterialOutwardDetailsTable.dart';
import 'package:soleoserp/models/common/Material_Inward_Product_table.dart';
import 'package:soleoserp/models/common/all_name_id_list.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/res/image_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Material_Inward/Material_Inward/Material_Inward_Detail_Screen/test_list_inward.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Material_Inward/Material_Inward/Material_Inward_Header_Screen/Material_Inward_Header_List_Screen.dart';
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

class MaterialInwardAddEditMainScreenArguments {
  MaterialInwardListMeetResponseDetails editModel;
  MaterialInwardAddEditMainScreenArguments(this.editModel);
}

class MaterialInwardAddEditMainScreen extends BaseStatefulWidget {
  static const routeName = '/MaterialInwardAddEditMainScreen';
  final MaterialInwardAddEditMainScreenArguments arguments;

  MaterialInwardAddEditMainScreen(this.arguments);

  @override
  _MaterialInwardAddEditMainScreenState createState() =>
      _MaterialInwardAddEditMainScreenState();
}

class _MaterialInwardAddEditMainScreenState
    extends BaseState<MaterialInwardAddEditMainScreen>
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
  MaterialInwardListMeetResponseDetails _editModel;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  bool isCompare;
  DateTime selectedLRDate = DateTime.now();
  DateTime selectedDeliveryDate = DateTime.now();
  DateTime selectedInvoiceDate = DateTime.now();

  /// For New
  final TextEditingController edt_InwardNo = TextEditingController();
  final TextEditingController edt_ChallanNo = TextEditingController();
  final TextEditingController edt_InvoiceNo = TextEditingController();
  final TextEditingController edt_Inward_date = TextEditingController();
  final TextEditingController edt_Rev_Indent_date = TextEditingController();
  final TextEditingController edt_StateCode = TextEditingController();
  final TextEditingController edt_LocationName = TextEditingController();
  final TextEditingController edt_LocationpkID = TextEditingController();
  final TextEditingController edt_Customer = TextEditingController();
  final TextEditingController edt_CustomerId = TextEditingController();
  final TextEditingController edt_Remark = TextEditingController();
  final TextEditingController edt_LR_date = TextEditingController();
  final TextEditingController edt_LR_date_Reveres = TextEditingController();
  final TextEditingController edt_delivery_date = TextEditingController();
  final TextEditingController edt_rev_delivery_date = TextEditingController();
  final TextEditingController edt_DeliverTo = TextEditingController();
  final TextEditingController edt_Mode_of_Payment = TextEditingController();
  final TextEditingController edt_e_way_bill_No = TextEditingController();
  final TextEditingController edt_Delivery_Notes = TextEditingController();
  final TextEditingController edt_vihical_no = TextEditingController();
  final TextEditingController edt_Remarks = TextEditingController();
  final TextEditingController edt_LR_NO = TextEditingController();
  final TextEditingController edt_DC_NO = TextEditingController();
  final TextEditingController edt_Transporter = TextEditingController();
  final TextEditingController edt_mode_of_transfer = TextEditingController();
  final TextEditingController edt_Module_NO = TextEditingController();
  final TextEditingController edt_Module_NO1 = TextEditingController();
  final TextEditingController edt_SelectSoDropDown = TextEditingController();
  TextEditingController edt_NetAmount = TextEditingController();
  TextEditingController edt_BasicAmt = TextEditingController();
  TextEditingController edt_SGSTAmt = TextEditingController();
  TextEditingController edt_CGSTAmt = TextEditingController();
  TextEditingController edt_IGSTAmt = TextEditingController();
  TextEditingController edt_ROffAmt = TextEditingController();
  TextEditingController edt_roundoff = TextEditingController();
  TextEditingController edt_TotalGST = TextEditingController();
  bool isDropdownVisible = false;
  bool isSaving = false;
  Set<String> savedProductIDs = {};

  List<ALL_Name_ID> arr_ALL_Name_ID_For_Location = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_CustomerName = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_ModeOfTransfer = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_SelectSoDropDown = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_SelectSoDropDown2 = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_SO_Filter_List = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_SO_Filter_List2 = [];

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
    isCompare = false;
    getModeOfTransport();
    ForTesting();
    _isForUpdate = widget.arguments != null;

    if (_isForUpdate) {
      _editModel = widget.arguments.editModel;
      fillData();
    } else {
      edt_StateCode.text = "";

      edt_Inward_date.text = selectedDate.day.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.year.toString();
      edt_Rev_Indent_date.text = selectedDate.year.toString() +
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
          if (state is MaterialInwardMasterSaveState) {
            _onMaterialOutwardAddUpdateResponse(state);
          }
          if (state is LocationListCallResponseState) {
            _onLocationListCallResponse(state);
          }
          if (state is MaterialInwardCustomerListCallState) {
            _onCustomerListResponse(state);
          }
          if (state is MaterialInwardGetDetailsPoNoResponseState) {
            _onMaterialOutwardGetDetailsSoNoResponse(state);
          }
          if (state is MaterialInwardGetPoNoResponseState) {
            _onMaterialOutwardGetSoNoResponse(state);
          }
          if (state
              is MaterialOutwardGetDetailsOutwardNoBYFetchTypeResponseState) {
            _onMaterialOutwardGetDetailsOutwardNoBYFetchTypeResponse(state);
          }
        },
        listenWhen: (oldState, currentState) {
          if (currentState is MaterialInwardMasterSaveState) {
            return true;
          }
          if (currentState is LocationListCallResponseState) {
            return true;
          }
          if (currentState is MaterialInwardCustomerListCallState) {
            return true;
          }
          if (currentState is MaterialInwardGetDetailsPoNoResponseState) {
            return true;
          }
          if (currentState is MaterialInwardGetPoNoResponseState) {
            return true;
          }
          if (currentState
              is MaterialOutwardGetDetailsOutwardNoBYFetchTypeResponseState) {
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
          title: Text('Material Inward'),
          gradient: LinearGradient(colors: [
            Color(0xff108dcf),
            Color(0xff0066b3),
            Color(0xff108dcf),
          ]),
          leading: InkWell(
              onTap: () async {
                navigateTo(context, MaterialInwardListScreens.routeName);
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
                              IndentNo(),
                              SizedBox(height: 15),
                            ],
                          )
                        : Container(),
                    IndentDate(),
                    SizedBox(height: 15),
                    _buildSearchView(),
                    SizedBox(height: 15),
                    CustomDropDownLocation(
                      "Location",
                      enable1: false,
                      icon: Icon(Icons.arrow_drop_down),
                      controllerVehical: edt_LocationName,
                      vehicalList: arr_ALL_Name_ID_For_Location,
                    ),
                    _isForUpdate == true
                        ? Container()
                        : Column(
                            children: [
                              SizedBox(height: 15),
                              Column(
                                children: [
                                  _ModuleDropDown(context),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  _ModuleDropDown2(context),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                    SizedBox(height: 15),
                    ProductDetails(),
                    TransportDetails(),
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

  Widget IndentNo() {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          child: Text("Inward",
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
                      controller: edt_InwardNo,
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

  Widget ChallanNo() {
    return Container(
        child: Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              child: Text("Challan No",
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
                      child: TextField(
                          controller: edt_ChallanNo,
                          // enabled: false,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            counterText: "",
                            hintText: "Enter Callan No",
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
            )
          ],
        ),
      ],
    ));
  }

  Widget InvoiceNo() {
    return Container(
        child: Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              child: Text("Invoice No",
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
                      child: TextField(
                          controller: edt_InvoiceNo,
                          // enabled: false,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            counterText: "",
                            hintText: "Enter Invoice No",
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
            )
          ],
        ),
      ],
    ));
  }

  Widget IndentDate() {
    return Container(
      child: InkWell(
        onTap: () {
          _selectNextFollowupDate(context, edt_Inward_date);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              child: Text("Inward Date *",
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
                        edt_Inward_date.text == null ||
                                edt_Inward_date.text == ""
                            ? "YYYY-MM--DD"
                            : edt_Inward_date.text,
                        style: baseTheme.textTheme.displaySmall.copyWith(
                            color: edt_Rev_Indent_date.text == null ||
                                    edt_Rev_Indent_date.text == ""
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
          _onTapOfSearchView();
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
        edt_StateCode.text = _searchDetails.stateCode.toString();

        _mainBloc.add(MaterialInwardGetPoNoRequestEvent(
            MIGetOrderNoFromTheCustomerIdRequest(
                CustomerID: edt_CustomerId.text,
                ModuleType: "PurchaseOrder",
                CompanyId: CompanyID.toString())));
      }
    });
  }

  void _onMaterialOutwardGetSoNoResponse(
      MaterialInwardGetPoNoResponseState state) {
    if (state.response.details.length != 0) {
      arr_ALL_Name_ID_For_SelectSoDropDown.clear();
      for (var i = 0; i < state.response.details.length; i++) {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = state.response.details[i].orderNo;
        all_name_id.isChecked = false;
        arr_ALL_Name_ID_For_SelectSoDropDown.add(all_name_id);

        print("avkeklg" + all_name_id.Name);
      }
    }
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
        edt_Inward_date.text = selectedDate.day.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.year.toString();
        edt_Rev_Indent_date.text = selectedDate.year.toString() +
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
                _mainBloc.add(LocationListForInwardCallEvent(
                    LocationListRequest(
                        LoginUserID: LoginUserID,
                        CompanyId: CompanyID.toString(),
                        pkID: "0",
                        PageNo: "1",
                        PageSize: "100000",
                        SearchKey: "")));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Location *",
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
                          edt_LocationName.text != ""
                              ? InkWell(
                                  onTap: () {
                                    edt_LocationName.text = "";
                                    edt_LocationpkID.text = "0";
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

  void _onLocationListCallResponse(LocationListCallResponseState state) {
    arr_ALL_Name_ID_For_Location.clear();
    if (state.response.details.length != 0) {
      for (var i = 0; i < state.response.details.length; i++) {
        ALL_Name_ID categoryResponse123 = ALL_Name_ID();
        categoryResponse123.Name = state.response.details[i].locationName;
        categoryResponse123.pkID = state.response.details[i].pkID;
        arr_ALL_Name_ID_For_Location.add(categoryResponse123);
      }

      if (arr_ALL_Name_ID_For_Location.length != 0) {
        navigateTo(context, VehicleListDropDownScreen.routeName,
                arguments: VehicleListDropDownScreenArgument(
                    arr_ALL_Name_ID_For_Location,
                    "Types Of Location List",
                    "Three Chars To Search Location ",
                    "Tap To Enter Location"))
            .then((value) {
          if (value.toString() == "clear") {
            edt_LocationName.text = "";
            edt_LocationpkID.text = "0";
          } else {
            ALL_Name_ID model = value;
            edt_LocationName.text = model.Name;
            edt_LocationpkID.text = model.pkID.toString();
          }

          setState(() {});
        });
      }
    }
  }

  Widget CustomDropDownBlock(
    String Outsource, {
    bool enable1,
    Icon icon,
    TextEditingController controllerId,
    TextEditingController controllerVehical,
    List<ALL_Name_ID> vehicalList,
  }) {
    return Container(
      child: Column(
        children: [
          InkWell(
              onTap: () {
                _mainBloc.add(MaterialInwardCustomerListCallEvent(
                    MaterialInwardCustomerListRequest(
                        CompanyId: CompanyID.toString(),
                        LoginUserID: LoginUserID,
                        word: edt_Customer.text)));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Supplier Name *",
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
                          edt_Customer.text != ""
                              ? InkWell(
                                  onTap: () {
                                    edt_Customer.text = "";
                                    edt_CustomerId.text = "0";
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

  void _onCustomerListResponse(MaterialInwardCustomerListCallState state) {
    arr_ALL_Name_ID_For_CustomerName.clear();
    if (state.materialInwardCustomerListResponce.details.length != 0) {
      for (var i = 0;
          i < state.materialInwardCustomerListResponce.details.length;
          i++) {
        ALL_Name_ID categoryResponse123 = ALL_Name_ID();
        categoryResponse123.Name =
            state.materialInwardCustomerListResponce.details[i].label;
        categoryResponse123.pkID =
            state.materialInwardCustomerListResponce.details[i].value;
        arr_ALL_Name_ID_For_CustomerName.add(categoryResponse123);
        print(state.materialInwardCustomerListResponce.details[i].value
            .toString());
      }

      if (arr_ALL_Name_ID_For_CustomerName.length != 0) {
        navigateTo(context, VehicleListDropDownScreen.routeName,
                arguments: VehicleListDropDownScreenArgument(
                    arr_ALL_Name_ID_For_CustomerName,
                    "Module Name List",
                    "Three Chars To Search Module ",
                    "Tap To Enter Modules"))
            .then((value) {
          if (value.toString() == "clear") {
            edt_Customer.text = "";
            edt_CustomerId.text = "0";
          } else {
            ALL_Name_ID model = value;
            edt_Customer.text = model.Name;
            edt_CustomerId.text = model.pkID.toString();
            // print("${CustomerId.toString()}");
            print("${edt_CustomerId.text}");
          }

          setState(() {});
        });
      }
    }
  }

  Widget _ModuleDropDown(BuildContext context) {
    return InkWell(
      onTap: () {
        if (edt_Customer.text != "") {
          if (arr_ALL_Name_ID_For_SelectSoDropDown.length != 0) {
            navigateTo(context, ModuleNoListScreen.routeName,
                    arguments: AddModuleNoScreenArguments(
                        arr_ALL_Name_ID_For_SelectSoDropDown,
                        "Material Inward"))
                .then((value) {
              setState(() {
                arr_ALL_Name_ID_For_SO_Filter_List = value;
                if (arr_ALL_Name_ID_For_SO_Filter_List.length != 0) {
                  List<String> ModuleNoList = [];
                  for (int i = 0;
                      i < arr_ALL_Name_ID_For_SO_Filter_List.length;
                      i++) {
                    ModuleNoList.add(
                        arr_ALL_Name_ID_For_SO_Filter_List[i].Name);
                    if (ModuleNoList.length != 0) {
                      var stringwe = ModuleNoList.join(',');

                      edt_Module_NO.text = stringwe.toString();
                      _mainBloc.add(MaterialInwardGetDetailsPoNoRequestEvent(
                          "Edit",
                          MIGetFetDetailByOrderNoListRequest(
                              FetchType: "PurchaseOrder",
                              No: "," + stringwe.toString() + ",",
                              CustomerID: edt_CustomerId.text,
                              CompanyId: CompanyID.toString())));
                    }
                  }
                }
              });
            });
          } else {
            showCommonDialogWithSingleOption(
                context, edt_SelectSoDropDown.text + " No. Not Exist !",
                positiveButtonTitle: "OK", onTapOfPositiveButton: () {
              Navigator.pop(context);
            });
          }
        } else {
          showCommonDialogWithSingleOption(
              context, "Customer name is required To view Option !",
              positiveButtonTitle: "OK");
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 15, right: 15, bottom: 5),
            child: Text("Select P.O Product",
                style: TextStyle(
                    fontSize: 12,
                    color: colorBlack,
                    fontWeight: FontWeight.bold)),
          ),
          arr_ALL_Name_ID_For_SO_Filter_List.length != 0
              ? Card(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  elevation: 8,
                  color: Colors.grey[50],
                  shadowColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(left: 20, right: 20),
                            width: double.maxFinite,
                            height: 60,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Center(
                                  child: Card(
                                    elevation: 5,
                                    color: colorPrimary,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(5),
                                          child: Text(
                                            arr_ALL_Name_ID_For_SO_Filter_List[
                                                    index]
                                                .Name,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: colorWhite),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              itemCount:
                                  arr_ALL_Name_ID_For_SO_Filter_List.length,
                            )),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: colorGrayDark,
                        size: 24,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                    ],
                  ),
                )
              : Card(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  elevation: 8,
                  color: Colors.grey[50],
                  shadowColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Container(
                    height: 55,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    width: double.maxFinite,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                              enabled: false,
                              decoration: InputDecoration(
                                hintText: "Tap to Select No.",
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
                        Icon(
                          Icons.arrow_drop_down,
                          color: colorGrayDark,
                        )
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  void _onMaterialOutwardGetDetailsSoNoResponse(
      MaterialInwardGetDetailsPoNoResponseState state) {
    if (state.response.details.length != 0) {
      arr_ALL_Name_ID_For_SelectSoDropDown2.clear();
      for (var i = 0; i < state.response.details.length; i++) {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = state.response.details[i].displayProductName;
        all_name_id.pkID = state.response.details[i].pkID;
        all_name_id.Name1 = state.response.details[i].orderNo;
        all_name_id.isChecked = false;
        arr_ALL_Name_ID_For_SelectSoDropDown2.add(all_name_id);
      }
    }
  }

  Widget _ModuleDropDown2(BuildContext context) {
    return InkWell(
      onTap: () {
        if (edt_Customer.text != "") {
          if (arr_ALL_Name_ID_For_SelectSoDropDown2.length != 0) {
            navigateTo(context, ModuleNoListScreen.routeName,
                    arguments: AddModuleNoScreenArguments(
                        arr_ALL_Name_ID_For_SelectSoDropDown2,
                        "Material Outward"))
                .then((value) {
              setState(() {
                arr_ALL_Name_ID_For_SO_Filter_List2 = value;

                if (arr_ALL_Name_ID_For_SO_Filter_List2.length != 0) {
                  List<String> ModuleNoList = [];
                  List<String> ModuleNoList1 = [];
                  for (int i = 0;
                      i < arr_ALL_Name_ID_For_SO_Filter_List2.length;
                      i++) {
                    ModuleNoList.add(
                        arr_ALL_Name_ID_For_SO_Filter_List2[i].Name1);
                    ModuleNoList1.add(
                        arr_ALL_Name_ID_For_SO_Filter_List2[i].pkID.toString());

                    if (ModuleNoList.length != 0) {
                      var stringwe = ModuleNoList.join(',');
                      var stringwe1 = ModuleNoList1.join(',');
                      edt_Module_NO.text = stringwe.toString();
                      _mainBloc.add(
                          MaterialOutwardGetDetailsOutwardNoByFetchTypeRequestEvent(
                              "Edit",
                              MaterialOutwardPendingSalesOrderByFetchTypeDetailsListRequest(
                                  FetchType: "PurchaseOrder",
                                  No: "," + stringwe.toString() + ",",
                                  Ids: "," + stringwe1.toString() + ",",
                                  CustomerID: edt_CustomerId.text,
                                  CompanyId: CompanyID.toString())));
                    }
                  }
                }
              });
            });
          } else {
            showCommonDialogWithSingleOption(
                context, edt_SelectSoDropDown.text + " No. Not Exist !",
                positiveButtonTitle: "OK", onTapOfPositiveButton: () {
              Navigator.pop(context);
            });
          }
        } else {
          showCommonDialogWithSingleOption(
              context, "Customer name is required To view Option !",
              positiveButtonTitle: "OK");
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 15, right: 15, bottom: 5),
            child: Text("Select P.O Product",
                style: TextStyle(
                    fontSize: 12,
                    color: colorBlack,
                    fontWeight: FontWeight.bold)),
          ),
          arr_ALL_Name_ID_For_SO_Filter_List2.length != 0
              ? Card(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  elevation: 8,
                  color: Colors.grey[50],
                  shadowColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(left: 20, right: 20),
                            width: double.maxFinite,
                            height: 60,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Center(
                                  child: Card(
                                    elevation: 5,
                                    color: colorPrimary,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      child: Text(
                                        arr_ALL_Name_ID_For_SO_Filter_List2[
                                                index]
                                            .Name,
                                        style: TextStyle(
                                            fontSize: 12, color: colorWhite),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemCount:
                                  arr_ALL_Name_ID_For_SO_Filter_List2.length,
                            )),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: colorGrayDark,
                        size: 24,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                    ],
                  ),
                )
              : Card(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  elevation: 8,
                  color: Colors.grey[50],
                  shadowColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Container(
                    height: 55,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    width: double.maxFinite,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                              enabled: false,
                              decoration: InputDecoration(
                                hintText: "Tap to Select No.",
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
                        Icon(
                          Icons.arrow_drop_down,
                          color: colorGrayDark,
                        )
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  ProductDetails() {
    return Container(
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        elevation: 2,
        child: Container(
          decoration: BoxDecoration(
              color: colorPrimary, borderRadius: BorderRadius.circular(20)),
          child: Theme(
            data: ThemeData().copyWith(
              dividerColor: Colors.transparent,
            ),
            child: ListTileTheme(
              dense: true,
              child: ExpansionTile(
                iconColor: Colors.white,
                collapsedIconColor: Colors.white,

                // backgroundColor: Colors.grey[350],
                title: Text(
                  "Product Details",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),

                leading: Container(
                  child: ClipRRect(
                    child: Image.asset(
                      BASIC_INFORMATION,
                      width: 28,
                    ),
                  ),
                ),

                children: [
                  Column(
                    children: [
                      Container(
                        margin:
                            EdgeInsets.only(left: 15, right: 15, bottom: 15),
                        alignment: Alignment.bottomCenter,
                        child: getCommonButton(baseTheme, () {
                          if (edt_Customer.text != "") {
                            if (edt_LocationName.text != "") {
                              navigateTo(context,
                                  MaterialInwardProductListScreen.routeName,
                                  arguments:
                                      MaterialInwardProductListScreenArgument(
                                          InquiryNo,
                                          edt_StateCode.text,
                                          edt_LocationpkID.text,
                                          edt_CustomerId.text));
                            } else {
                              showCommonDialogWithSingleOption(
                                  context, "Location Selection Is Required!!",
                                  positiveButtonTitle: "OK",
                                  onTapOfPositiveButton: () {
                                Navigator.of(context).pop();
                              });
                            }
                          } else {
                            showCommonDialogWithSingleOption(
                                context, "Customer Name Is Required!!",
                                positiveButtonTitle: "OK",
                                onTapOfPositiveButton: () {
                              Navigator.of(context).pop();
                            });
                          }
                        }, "Products",
                            width: 600,
                            textColor: colorBlack,
                            backGroundColor: colorWhite,
                            radius: 25.0),
                      ),
                    ],
                  )
                ], // children:
              ),
            ),
          ),
          // height: 60,
        ),
      ),
    );
  }

  TransportDetails() {
    return Container(
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        elevation: 2,
        child: Container(
          decoration: BoxDecoration(
              color: colorPrimary, borderRadius: BorderRadius.circular(20)),
          child: Theme(
            data: ThemeData().copyWith(
              dividerColor: Colors.transparent,
            ),
            child: ListTileTheme(
              dense: true,
              child: ExpansionTile(
                iconColor: Colors.white,
                collapsedIconColor: Colors.white,

                // backgroundColor: Colors.grey[350],
                title: Text(
                  "Transport Details",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),

                leading: Container(
                  child: ClipRRect(
                    child: Image.asset(
                      BASIC_INFORMATION,
                      width: 28,
                    ),
                  ),
                ),

                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15))),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: createTextLabel(
                                  "Mode Of Transport #", 10.0, 0.0),
                            ),
                            Flexible(
                              child: createTextLabel(
                                  "Transporter Name", 10.0, 0.0),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Flexible(
                              // flex: 2,
                              child: CustomDropDown1("Mode Of Transport #",
                                  enable1: false,
                                  title: "Select Mode",
                                  hintTextvalue: "Tap to select",
                                  icon: Icon(Icons.arrow_drop_down),
                                  controllerForLeft: edt_mode_of_transfer,
                                  Custom_values1:
                                      arr_ALL_Name_ID_For_ModeOfTransfer),
                            ),
                            Flexible(
                                // flex: 1,
                                child: createTextFormField(
                                    edt_Transporter, "Transporter Name",
                                    keyboardInput: TextInputType.text)),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: createTextLabel("Vehicle No.", 10.0, 0.0),
                            ),
                            Flexible(
                              child:
                                  createTextLabel("Delivery Note", 10.0, 0.0),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Flexible(
                                // flex: 1,
                                child: createTextFormField(
                                    edt_vihical_no, "Vehicle No.",
                                    keyboardInput: TextInputType.text)),
                            Flexible(
                                // flex: 1,
                                child: createTextFormField(
                                    edt_Delivery_Notes, "Delivery Note",
                                    keyboardInput: TextInputType.text)),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: createTextLabel("LR No.", 10.0, 0.0),
                            ),
                            Flexible(
                              child: createTextLabel("LR Date", 10.0, 0.0),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Flexible(
                                // flex: 1,
                                child:
                                    createTextFormField(edt_LR_NO, "LR No.")),
                            Flexible(child: _buildLRDate())
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        createTextLabel("Remarks", 10.0, 0.0),
                        createTextFormField(edt_Remarks, "Tap to enter remarks",
                            minLines: 2,
                            maxLines: 5,
                            height: 70,
                            keyboardInput: TextInputType.text),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                ], // children:
              ),
            ),
          ),
          // height: 60,
        ),
      ),
    );
  }

  Widget CustomDropDown1(String Category,
      {bool enable1,
      Icon icon,
      String title,
      String hintTextvalue,
      TextEditingController controllerForLeft,
      List<ALL_Name_ID> Custom_values1}) {
    return Container(
      child: Column(
        children: [
          InkWell(
            onTap: () {
              if (Category == "Option") {
                if (edt_Customer.text != "") {
                  showcustomdialogWithOnlyName(
                      values: Custom_values1,
                      context1: context,
                      controller: controllerForLeft,
                      lable: "Select $Category");
                } else {
                  showCommonDialogWithSingleOption(
                      context, "CustomerName is required !",
                      positiveButtonTitle: "OK");
                }
              } else {
                showcustomdialogWithOnlyName(
                    values: Custom_values1,
                    context1: context,
                    controller: controllerForLeft,
                    lable: "$Category");
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 8,
                  color: Colors.grey[50],
                  shadowColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Container(
                    height: 40,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            enabled: false,
                            textInputAction: TextInputAction.next,
                            controller: controllerForLeft,
                            textAlignVertical: TextAlignVertical
                                .center, // Align text vertically
                            decoration: InputDecoration(
                              hintText: "--- Select ---",
                              hintStyle: TextStyle(color: Colors.grey.shade400),
                              border: InputBorder.none,
                              isCollapsed:
                                  true, // Ensures content aligns properly
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

  void getModeOfTransport() {
    arr_ALL_Name_ID_For_ModeOfTransfer.clear();
    for (var i = 0; i < 4; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      if (i == 0) {
        all_name_id.Name = "Road";
      } else if (i == 1) {
        all_name_id.Name = "Rail";
      } else if (i == 2) {
        all_name_id.Name = "Air";
      } else if (i == 3) {
        all_name_id.Name = "Ship";
      }
      arr_ALL_Name_ID_For_ModeOfTransfer.add(all_name_id);
    }
  }

  Widget _buildDeliveryDate() {
    return InkWell(
      onTap: () {
        _selectDeliveryDate(context, edt_delivery_date, edt_rev_delivery_date);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 8,
            color: Colors.grey[50],
            shadowColor: Colors.blue,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Container(
              height: 40,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Align children vertically
                children: [
                  Expanded(
                    child: Text(
                      edt_delivery_date.text == null ||
                              edt_delivery_date.text.isEmpty
                          ? "YYYY-MM-DD"
                          : edt_delivery_date.text,
                      style: baseTheme.textTheme.displaySmall.copyWith(
                          color: edt_rev_delivery_date.text == null ||
                                  edt_rev_delivery_date.text.isEmpty
                              ? colorGrayDark
                              : colorBlack,
                          fontSize: 15),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Icon(
                    Icons.calendar_today_outlined,
                    color: colorGrayDark,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDeliveryDate(
      BuildContext context,
      TextEditingController F_datecontroller,
      TextEditingController Rev_dateController) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDeliveryDate,
        firstDate: selectedInvoiceDate,
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDeliveryDate = picked;
        F_datecontroller.text = selectedDeliveryDate.day.toString() +
            "-" +
            selectedDeliveryDate.month.toString() +
            "-" +
            selectedDeliveryDate.year.toString();
        Rev_dateController.text = selectedDeliveryDate.year.toString() +
            "-" +
            selectedDeliveryDate.month.toString() +
            "-" +
            selectedDeliveryDate.day.toString();
      });
  }

  Widget _buildLRDate() {
    return InkWell(
      onTap: () {
        _selectLRDate(context, edt_LR_date, edt_LR_date_Reveres);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 8,
            color: Colors.grey[50],
            shadowColor: Colors.blue,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Container(
              height: 40,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Align children vertically
                children: [
                  Expanded(
                    child: Text(
                      edt_LR_date.text == null || edt_LR_date.text.isEmpty
                          ? "YYYY-MM-DD"
                          : edt_LR_date.text,
                      style: baseTheme.textTheme.displaySmall.copyWith(
                          color: edt_LR_date_Reveres.text == null ||
                                  edt_LR_date_Reveres.text.isEmpty
                              ? colorGrayDark
                              : colorBlack,
                          fontSize: 15),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Icon(
                    Icons.calendar_today_outlined,
                    color: colorGrayDark,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectLRDate(
      BuildContext context,
      TextEditingController F_datecontroller,
      TextEditingController Rev_dateController) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedLRDate,
        firstDate: selectedInvoiceDate,
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedLRDate = picked;
        F_datecontroller.text = selectedLRDate.day.toString() +
            "-" +
            selectedLRDate.month.toString() +
            "-" +
            selectedLRDate.year.toString();
        Rev_dateController.text = selectedLRDate.year.toString() +
            "-" +
            selectedLRDate.month.toString() +
            "-" +
            selectedLRDate.day.toString();
      });
  }

  Widget createTextLabel(String labelName, double leftPad, double rightPad) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.only(left: leftPad, right: rightPad),
        child: Row(
          children: [
            Text(labelName,
                style: TextStyle(
                    fontSize: 12,
                    color: colorBlack,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget createTextFormField(
      TextEditingController _controller, String _hintText,
      {int minLines = 1,
      int maxLines = 1,
      double height = 40,
      double left = 5,
      double right = 5,
      double top = 8,
      double bottom = 10,
      bool isEnable = true,
      TextInputType keyboardInput = TextInputType.number}) {
    return Card(
      margin:
          EdgeInsets.only(left: left, right: right, top: top, bottom: bottom),
      elevation: 8,
      color: Colors.grey[50],
      shadowColor: Colors.blue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        height: height,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: TextFormField(
          minLines: minLines,
          maxLines: maxLines,
          enabled: isEnable,
          style: TextStyle(fontSize: 13),
          controller: _controller,
          textInputAction: TextInputAction.next,
          keyboardType: keyboardInput,
          decoration: InputDecoration(
              hintText: _hintText,
              hintStyle: TextStyle(fontSize: 13, color: colorGrayDark),
              fillColor: colorLightGray,
              contentPadding: EdgeInsets.symmetric(horizontal: 14),
              border: InputBorder.none,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
              )),
        ),
      ),
    );
  }

  Future<void> ForTesting() async {
    List<MaterialOutwardTable> value =
        await OfflineDbHelper.getInstance().getMaterialOutwardProduct();

    double totalSumOfNetAmount = 0; // total sum of base rating
    double totalSumOfBasicAmt = 0; // total sum of base rating
    double totalSumOfSGSTAmt = 0; // total sum of base rating
    double totalSumOfCGSTAmt = 0; // total sum of base rating
    double totalSumOfIGSTAmt = 0; // total sum of base rating
    double totalGSTAmount = 0; // total sum of base rating

    if (value.length != 0) {
      for (int i = 0; i < value.length; i++) {
        totalSumOfNetAmount += value[i].NetAmount.toDouble();
        totalSumOfBasicAmt += value[i].Amount.toDouble();
        totalSumOfSGSTAmt += value[i].SGSTAmt.toDouble();
        totalSumOfCGSTAmt += value[i].CGSTAmt.toDouble();
        totalSumOfIGSTAmt += value[i].IGSTAmt.toDouble();
        totalGSTAmount = value[i].SGSTAmt.toDouble() +
            value[i].CGSTAmt.toDouble() +
            value[i].IGSTAmt.toDouble();
      }
      print("chjhiducgv" + totalGSTAmount.toString());
    }
    edt_NetAmount.text = totalSumOfNetAmount.toString();
    edt_BasicAmt.text = totalSumOfBasicAmt.toString();
    edt_SGSTAmt.text = totalSumOfSGSTAmt.toString();
    edt_CGSTAmt.text = totalSumOfCGSTAmt.toString();
    edt_IGSTAmt.text = totalSumOfIGSTAmt.toString();

    // Calculate round off value
    double roundOffValue = totalSumOfNetAmount - totalSumOfNetAmount.round();
    edt_roundoff.text =
        roundOffValue.toStringAsFixed(2); // Round off to 2 decimal places

    edt_TotalGST.text = totalGSTAmount.toString();
  }

  _onTapOfSaveVehiclePunchAPICall() async {
    await ForTesting();

    if (edt_LocationName.text.toString().isNotEmpty) {
      if (edt_Customer.text.toString().isNotEmpty) {
        List<MaterialInwardTable> temp =
            await OfflineDbHelper.getInstance().getMaterialinwardProducts();

        if (temp.length != 0) {
          showCommonDialogWithTwoOptions(
              context, "Are you sure you want to Save this record?",
              negativeButtonTitle: "No",
              positiveButtonTitle: "Yes", onTapOfPositiveButton: () async {
            Navigator.of(context).pop();

            _mainBloc.add(
                MaterialInwardMasterSaveEvent(MaterialInwardMasterSaveRequest(
              pkID: pkID.toString(),
              LoginUserID: LoginUserID,
              CompanyId: CompanyID.toString(),
              InwardNo: edt_InwardNo.text,
              InwardDate: edt_Rev_Indent_date.text,
              CustomerID: edt_CustomerId.text,
              LocationID: edt_LocationpkID.text,
              BasicAmt: edt_BasicAmt.text == null ? "0.00" : edt_BasicAmt.text,
              SGSTAmt: edt_SGSTAmt.text == null ? "0.00" : edt_SGSTAmt.text,
              CGSTAmt: edt_CGSTAmt.text == null ? "0.00" : edt_CGSTAmt.text,
              IGSTAmt: edt_IGSTAmt.text == null ? "0.00" : edt_IGSTAmt.text,
              ROffAmt: edt_roundoff.text == null ? "0.00" : edt_roundoff.text,
              NetAmt: edt_NetAmount.text == null ? "0.00" : edt_NetAmount.text,
              DiscountAmt: "0.00",
              ModeOfTransport: edt_mode_of_transfer.text,
              TransporterName: edt_Transporter.text,
              VehicleNo: edt_vihical_no.text,
              LRNo: edt_LR_NO.text,
              LRDate: edt_LR_date_Reveres.text,
              TransportRemark: edt_Remarks.text,
              ManuaLInwardNo: "",
              ManuaLInwardDate: "",
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
        showCommonDialogWithSingleOption(context, "Supplier Name Is Required",
            positiveButtonTitle: "OK", onTapOfPositiveButton: () {
          Navigator.of(context).pop();
        });
      }
    } else {
      showCommonDialogWithSingleOption(context, "Location is Required",
          positiveButtonTitle: "OK", onTapOfPositiveButton: () {
        Navigator.of(context).pop();
      });
    }
  }

  Future<bool> _onBackPressed() async {
    navigateTo(context, MaterialInwardListScreens.routeName,
        clearAllStack: true);
  }

  void _onMaterialOutwardAddUpdateResponse(
      MaterialInwardMasterSaveState state) {
    showCommonDialogWithSingleOption(context,
        state.materialInwardMasterSaveResponce.details[0].column2.toString(),
        positiveButtonTitle: "OK", onTapOfPositiveButton: () async {
      navigateTo(context, MaterialInwardListScreens.routeName,
          clearAllStack: true);
    });
  }

  void fillData() async {
    pkID = _editModel.pkID;
    edt_Inward_date.text = _editModel.inwardDate.getFormattedDate(
        fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy");
    edt_Rev_Indent_date.text = _editModel.inwardDate.getFormattedDate(
        fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd");
    edt_InwardNo.text = _editModel.inwardNo.toString();
    edt_LocationName.text = _editModel.locationName;
    edt_LocationpkID.text = _editModel.locationID.toString();
    edt_CustomerId.text = _editModel.customerID.toString();
    edt_Customer.text = _editModel.customerName.toString();
    edt_ChallanNo.text = _editModel.challanNo.toString();
    edt_InvoiceNo.text = _editModel.invoiceNo.toString();
    edt_StateCode.text = _editModel.stateCode.toString();

    edt_mode_of_transfer.text = _editModel.modeOfTransport;
    edt_Transporter.text = _editModel.transporterName;
    edt_vihical_no.text = _editModel.vehicleNo;
    edt_LR_NO.text = _editModel.lRNo;
    edt_LR_date.text = _editModel.lRDate.getFormattedDate(
        fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy");
    edt_LR_date_Reveres.text = _editModel.lRDate.getFormattedDate(
        fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd");

    edt_NetAmount.text = _editModel.netAmt.toString();
    edt_BasicAmt.text = _editModel.basicAmt.toString();
    edt_SGSTAmt.text = _editModel.sGSTAmt.toString();
    edt_CGSTAmt.text = _editModel.cGSTAmt.toString();
    edt_IGSTAmt.text = _editModel.iGSTAmt.toString();
    edt_roundoff.text = _editModel.rOffAmt.toString();

    if (_editModel.inwardNo.toString() != "") {
      _mainBloc.add(MaterialInwardDetailsListCallEvent(
          LoginUserID,
          MaterialInwardDetailListRequest(
            InwardNo: _editModel.inwardNo.toString(),
            CompanyId: CompanyID.toString(),
          ),
          edt_StateCode.text,
          edt_LocationpkID.text));
    }
  }

  Future<File> testCompressAndGetFile(File file, String targetPath) async {
    print('testCompressAndGetFile');
    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 90,
      minWidth: 1024,
      minHeight: 1024,
    );
    print(file.lengthSync());
    print(result?.lengthSync());
    return result;
  }

  void _onMaterialOutwardGetDetailsOutwardNoBYFetchTypeResponse(
      MaterialOutwardGetDetailsOutwardNoBYFetchTypeResponseState state) async {
    if (state.response.details.length != 0) {
      await OfflineDbHelper.getInstance()
          .deleteallMaterialInwardProductsProducts();

      for (var i = 0; i < state.response.details.length; i++) {
        await OfflineDbHelper.getInstance()
            .insertMaterialinwardProduct(MaterialInwardTable(
          "", //RowNum,
          "0", //pkID,
          LoginUserID, //LoginUserID,
          CompanyID.toString(), //CompanyId,
          "", //InwardNo,
          "", //InwardDate,
          "", //DateCode,
          "", //CustomerID,
          "", //CustomerName,
          state.response.details[i].productID.toString(), //ProductID,
          state.response.details[i].productName, //ProductName,
          "", //ProductNameLong,
          "", //ProductSpecification,
          state.response.details[i].quantity.toString(), //Quantity,
          state.response.details[i].unit, //Unit,
          state.response.details[i].unitRate.toString(), //UnitRate,
          state.response.details[i].discountPercent
              .toString(), //DiscountPercent,
          state.response.details[i].discountAmt.toString(), //DiscountAmt,
          state.response.details[i].netRate.toString(), //NetRate,
          state.response.details[i].amount.toString(), //Amount,
          state.response.details[i].taxType.toString(), //TaxType,
          state.response.details[i].taxRate.toString(), //TaxRate,
          state.response.details[i].taxAmount.toString(), //TaxAmount,
          state.response.details[i].netAmount.toString(), //NetAmount,
          state.response.details[i].cGSTPer.toString(), //CGSTPer,
          state.response.details[i].cGSTAmt.toString(), //CGSTAmt,
          state.response.details[i].sGSTPer.toString(), //SGSTPer,
          state.response.details[i].sGSTAmt.toString(), //SGSTAmt,
          state.response.details[i].iGSTPer.toString(), //IGSTPer,
          state.response.details[i].iGSTAmt.toString(), //IGSTAmt,
          state.response.details[i].orderNo, //OrderNo,
          edt_StateCode.text, //StateCode,
          edt_LocationpkID.text, //LocationID,
          state.response.details[i].sampleQuantity.toString(), //SampleQuantity,
        ));
      }
    }
  }
}
