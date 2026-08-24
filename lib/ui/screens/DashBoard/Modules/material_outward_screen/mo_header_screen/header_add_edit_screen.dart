import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:soleoserp/blocs/MainBloc/mainBloc.dart';
import 'package:soleoserp/blocs/base/base_bloc.dart';
import 'package:soleoserp/models/Model_Classis_Fro_ODB/bank_voucher_detail_model.dart';
import 'package:soleoserp/models/api_requests/Material_Outward_Request/materail_outward_export_list_request.dart';
import 'package:soleoserp/models/api_requests/Material_Outward_Request/material_outward_add_update_request.dart';
import 'package:soleoserp/models/api_requests/Material_Outward_Request/material_outward_details_list_request.dart';
import 'package:soleoserp/models/api_requests/Material_Outward_Request/material_outward_expoet_save_request.dart';
import 'package:soleoserp/models/api_requests/Material_Outward_Request/material_outward_for_get_so_by_fetchTyoe_details_list_request.dart';
import 'package:soleoserp/models/api_requests/Material_Outward_Request/material_outward_for_get_so_details_list_request.dart';
import 'package:soleoserp/models/api_requests/Material_Outward_Request/material_outward_for_get_so_list_request.dart';
import 'package:soleoserp/models/api_requests/customer/customer_label_value_request.dart';
import 'package:soleoserp/models/api_requests/moduleAttachments/module_attachment_item_wise_delete_request.dart';
import 'package:soleoserp/models/api_responses/Material_Outward_Response/materail_outward_export_list_response.dart';
import 'package:soleoserp/models/api_responses/Material_Outward_Response/material_outward_list_response.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/customer/customer_label_value_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/other/follower_employee_list_response.dart';
import 'package:soleoserp/models/common/MaterialOutwardDetailsTable.dart';
import 'package:soleoserp/models/common/all_name_id_list.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/res/image_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/followup/search_followup_customer_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/material_outward_screen/mo_details_screens/details_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/material_outward_screen/mo_header_screen/header_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/salebill/sales_bill_add_edit/module_no_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/home_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/ui/widgets/common_widgets.dart';
import 'package:soleoserp/utils/date_time_extensions.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/offline_db_helper.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';
import 'package:uri_to_file/uri_to_file.dart';
import 'package:permission_handler/permission_handler.dart'
    as permissionHandler;

class MaterialOutwardAddEditMainScreenArguments {
  MaterialOutwardListMainResponseDetails editModel;
  List<File> documentList;
  List<File> documentListForSlip;
  MaterialOutwardExportListMainResponse soExportListResponse;
  MaterialOutwardAddEditMainScreenArguments(this.editModel, this.documentList,
      this.documentListForSlip, this.soExportListResponse);
}

class MaterialOutwardAddEditMainScreen extends BaseStatefulWidget {
  static const routeName = '/MaterialOutwardAddEditMainScreen';
  final MaterialOutwardAddEditMainScreenArguments arguments;

  MaterialOutwardAddEditMainScreen(this.arguments);

  @override
  _MaterialOutwardAddEditMainScreenState createState() =>
      _MaterialOutwardAddEditMainScreenState();
}

class _MaterialOutwardAddEditMainScreenState
    extends BaseState<MaterialOutwardAddEditMainScreen>
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
  MaterialOutwardListMainResponseDetails _editModel;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  FollowerEmployeeListResponse _offlineFollowerEmployeeListData;
  List<BankVoucherDetailsTable> _inquiryProductList = [];
  bool isCompare;
  DateTime selectedLRDate = DateTime.now();
  DateTime selectedDeliveryDate = DateTime.now();
  DateTime selectedInvoiceDate = DateTime.now();

  /// For New
  final TextEditingController edt_OutwardNo = TextEditingController();
  final TextEditingController edt_Outward_date = TextEditingController();
  final TextEditingController edt_Reverse_Outward_date =
      TextEditingController();
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
  final TextEditingController edt_CustomerName = TextEditingController();
  final TextEditingController edt_CustomerpkID = TextEditingController();
  final TextEditingController edt_SelectSoDropDown = TextEditingController();
  final TextEditingController edt_Module_NO = TextEditingController();
  final TextEditingController edt_SelectSoDropDownId = TextEditingController();
  final TextEditingController edt_TransactionNotes = TextEditingController();
  TextEditingController _controller_transport_name = TextEditingController();

  TextEditingController _controller_place_of_rec = TextEditingController();
  TextEditingController _controller_flight_no = TextEditingController();
  TextEditingController _controller_port_of_loading = TextEditingController();
  TextEditingController _controller_port_of_dispatch = TextEditingController();
  TextEditingController _controller_port_of_destination =
      TextEditingController();
  TextEditingController _controller_container_no = TextEditingController();
  TextEditingController _controller_packages = TextEditingController();

  TextEditingController _controller_type_of_package = TextEditingController();
  TextEditingController _controller_net_weight = TextEditingController();
  TextEditingController _controller_gross_weight = TextEditingController();
  TextEditingController _controller_FOB = TextEditingController();
  TextEditingController edt_StateCode = TextEditingController();
  TextEditingController edt_NetAmount = TextEditingController();
  TextEditingController edt_BasicAmt = TextEditingController();
  TextEditingController edt_SGSTAmt = TextEditingController();
  TextEditingController edt_CGSTAmt = TextEditingController();
  TextEditingController edt_IGSTAmt = TextEditingController();
  TextEditingController edt_ROffAmt = TextEditingController();
  TextEditingController edt_roundoff = TextEditingController();
  TextEditingController edt_TotalGST = TextEditingController();

  List<ALL_Name_ID> arr_ALL_Name_ID_For_ModeOfTransfer = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_SelectSoDropDown = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_SelectSoDropDown2 = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_SO_Filter_List = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_SO_Filter_List2 = [];

  List<ALL_Name_ID> fileListName = [];
  List<File> MultipleVideoList = [];
  final imagepicker = ImagePicker();
  bool permissionGranted;
  List<ALL_Name_ID> fileListName1 = [];
  List<File> MultipleVideoList1 = [];
  MaterialOutwardExportListMainResponse _soExportListResponse;

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

      edt_Outward_date.text = selectedDate.day.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.year.toString();
      edt_Reverse_Outward_date.text = selectedDate.year.toString() +
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
          if (state is MaterialOutwardDetailsListCallResponseState) {
            MaterialOutwardDetailsListCallResponse(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is MaterialOutwardDetailsListCallResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, MainStates state) {
          if (state is MaterialOutwardAddUpdateCallResponseState) {
            _onMaterialOutwardAddUpdateResponse(state);
          }
          if (state is MaterialOutwardGetSoNoResponseState) {
            _onMaterialOutwardGetSoNoResponse(state);
          }
          if (state is MaterialOutwardGetDetailsSoNoResponseState) {
            _onMaterialOutwardGetDetailsSoNoResponse(state);
          }
          if (state
              is MaterialOutwardGetDetailsOutwardNoBYFetchTypeResponseState) {
            _onMaterialOutwardGetDetailsOutwardNoBYFetchTypeResponse(state);
          }
          /*if (state is DefDocumentListResponseState) {
            _onInvoiceDocumentOnlyNameListResponseState(state);
          }*/
          if (state is ModuleAttachmentItemWiseDeleteResponseState) {
            _onModuleAttachmentItemWiseDeleteResponse(state);
          }
        },
        listenWhen: (oldState, currentState) {
          if (currentState is MaterialOutwardAddUpdateCallResponseState ||
              currentState is MaterialOutwardGetSoNoResponseState ||
              currentState is MaterialOutwardGetDetailsSoNoResponseState ||
              /*currentState is DefDocumentListResponseState ||*/
              currentState
                  is MaterialOutwardGetDetailsOutwardNoBYFetchTypeResponseState ||
              currentState is ModuleAttachmentItemWiseDeleteResponseState) {
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
          title: Text('Outward Detail'),
          gradient: LinearGradient(colors: [
            Color(0xff108dcf),
            Color(0xff0066b3),
            Color(0xff108dcf),
          ]),
          leading: InkWell(
              onTap: () async {
                navigateTo(context, MaterialOutwardListMainScreen.routeName);
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
                    outwardNo(),
                    SizedBox(height: 15),
                    PunchDate(),
                    SizedBox(height: 15),
                    _buildSearchView(),
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
                    ShipmentDetails(),
                    SizedBox(height: 10),
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

  Widget outwardNo() {
    return Container(
        child: Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              child: Text("Outward ",
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
                          controller: edt_OutwardNo,
                          enabled: false,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            counterText: "",
                            hintText: "",
                            /*contentPadding:
                                EdgeInsets.only(bottom: 12, top: 12),*/
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

  Widget PunchDate() {
    return InkWell(
      onTap: () {
        _selectNextFollowupDate(context, edt_Outward_date);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            child: Text("Outward Date *",
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
                    child: Text(
                      edt_Outward_date.text == null ||
                              edt_Outward_date.text == ""
                          ? "YYYY-MM--DD"
                          : edt_Outward_date.text,
                      style: baseTheme.textTheme.displaySmall.copyWith(
                          color: edt_Reverse_Outward_date.text == null ||
                                  edt_Reverse_Outward_date.text == ""
                              ? colorGrayDark
                              : colorBlack),
                    ),
                  ),
                  Icon(
                    Icons.calendar_today_outlined,
                    color: colorGrayDark,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
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
        edt_Outward_date.text = selectedDate.day.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.year.toString();
        edt_Reverse_Outward_date.text = selectedDate.year.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.day.toString();
      });
  }

  Widget _buildSearchView() {
    return InkWell(
      onTap: () {
        _onTapOfSearchView();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            child: Text("Customer Name * ",
                style: TextStyle(
                    fontSize: 12,
                    color: colorBlack,
                    fontWeight: FontWeight.bold)),
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
                        controller: edt_CustomerName,
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: "Search customer",
                          //contentPadding: EdgeInsets.only(bottom: 12, top: 12),
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
                    Icons.search,
                    color: colorGrayDark,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _onTapOfSearchView() async {
    navigateTo(context, SearchFollowupCustomerScreen.routeName).then((value) {
      if (value != null) {
        _searchDetails = value;
        edt_CustomerpkID.text = _searchDetails.value.toString();
        edt_CustomerName.text = _searchDetails.label.toString();
        edt_StateCode.text = _searchDetails.stateCode.toString();

        _mainBloc.add(MayankSearchBankVoucherCustomerListByNameCallEvent(
            CustomerLabelValueRequest(
                CompanyId: CompanyID.toString(),
                LoginUserID: LoginUserID.toString(),
                word: _searchDetails.value.toString())));

        _mainBloc.add(MaterialOutwardGetSoNoRequestEvent(
            MaterialOutwardPendingSalesOrderListRequest(
                CustomerID: edt_CustomerpkID.text,
                ModuleType: "PendingSalesOrder",
                CompanyId: CompanyID.toString())));
      }
      print("CustomerInfo : " +
          edt_CustomerName.text.toString() +
          " CustomerID : " +
          edt_CustomerpkID.text.toString());
    });
  }

  Widget selectSoDropDown(
      {bool enable1,
      Icon icon,
      String hintTextvalue,
      TextEditingController controllerForLeft,
      TextEditingController controller1,
      List<ALL_Name_ID> Custom_values1}) {
    return Container(
      child: Column(
        children: [
          InkWell(
            onTap: () {
              if (edt_CustomerName.text != "") {
                _mainBloc.add(MaterialOutwardGetSoNoRequestEvent(
                    MaterialOutwardPendingSalesOrderListRequest(
                        CustomerID: edt_CustomerpkID.text,
                        CompanyId: CompanyID.toString())));
              } else {
                showCommonDialogWithSingleOption(
                    context, "Customer Selection Is Required !",
                    positiveButtonTitle: "OK", onTapOfPositiveButton: () {
                  Navigator.of(context).pop();
                });
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15, right: 15),
                  child: Text("Select So",
                      style: TextStyle(
                          fontSize: 12,
                          color: colorBlack,
                          fontWeight: FontWeight.bold)),
                ),
                Card(
                  margin: EdgeInsets.only(left: 15, right: 15, top: 5),
                  elevation: 5,
                  color: colorLightGray,
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
                              controller: controllerForLeft,
                              enabled: false,
                              decoration: InputDecoration(
                                hintText: hintTextvalue,
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
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onMaterialOutwardGetSoNoResponse(
      MaterialOutwardGetSoNoResponseState state) {
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

  Widget _ModuleDropDown(BuildContext context) {
    return InkWell(
      onTap: () {
        if (edt_CustomerName.text != "") {
          if (arr_ALL_Name_ID_For_SelectSoDropDown.length != 0) {
            navigateTo(context, ModuleNoListScreen.routeName,
                    arguments: AddModuleNoScreenArguments(
                        arr_ALL_Name_ID_For_SelectSoDropDown,
                        "Material Outward"))
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
                      print("7upTTT7upTTT" + stringwe);
                      edt_Module_NO.text = stringwe.toString();
                      _mainBloc.add(MaterialOutwardGetDetailsSoNoRequestEvent(
                          "Edit",
                          MaterialOutwardPendingSalesOrderDetailsListRequest(
                              FetchType: "PendingSalesOrder",
                              No: "," + stringwe.toString() + ",",
                              CustomerID: edt_CustomerpkID.text,
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
            child: Text("Select S.O Product",
                style: TextStyle(
                    fontSize: 12,
                    color: colorBlack,
                    fontWeight: FontWeight.bold)),
          ),
          arr_ALL_Name_ID_For_SO_Filter_List.length != 0
              ? Card(
                  margin: EdgeInsets.only(left: 15, right: 15),
                  elevation: 5,
                  color: Colors.grey[50],
                  shadowColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
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
      MaterialOutwardGetDetailsSoNoResponseState state) {
    if (state.response.details.length != 0) {
      arr_ALL_Name_ID_For_SelectSoDropDown2.clear();
      for (var i = 0; i < state.response.details.length; i++) {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = state.response.details[i].displayProductName;
        all_name_id.pkID = state.response.details[i].pkid;
        all_name_id.Name1 = state.response.details[i].orderNo;
        all_name_id.isChecked = false;
        arr_ALL_Name_ID_For_SelectSoDropDown2.add(all_name_id);
      }
    }
  }

  Widget _ModuleDropDown2(BuildContext context) {
    return InkWell(
      onTap: () {
        if (edt_CustomerName.text != "") {
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
                                  FetchType: "PendingSalesOrder",
                                  No: "," + stringwe.toString() + ",",
                                  Ids: "," + stringwe1.toString() + ",",
                                  CustomerID: edt_CustomerpkID.text,
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
            child: Text("Select S.O Product",
                style: TextStyle(
                    fontSize: 12,
                    color: colorBlack,
                    fontWeight: FontWeight.bold)),
          ),
          arr_ALL_Name_ID_For_SO_Filter_List2.length != 0
              ? Card(
                  margin: EdgeInsets.only(left: 15, right: 15),
                  elevation: 5,
                  color: Colors.grey[50],
                  shadowColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
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
                          if (edt_CustomerName.text != "") {
                            navigateTo(context,
                                MaterialOutwardProductListScreen.routeName,
                                arguments:
                                    MaterialOutwardProductListScreenArgument(
                                  InquiryNo,
                                  edt_StateCode.text,
                                ));
                          } else {
                            showCommonDialogWithSingleOption(context,
                                "Customer name is required To view Product !",
                                positiveButtonTitle: "OK");
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: createTextLabel("DC No.", 10.0, 0.0),
                            ),
                            Flexible(
                              child: createTextLabel("DC Date", 10.0, 0.0),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Flexible(
                                // flex: 1,
                                child:
                                    createTextFormField(edt_DC_NO, "DC No.")),
                            Flexible(child: _buildDeliveryDate())
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

  Widget _buildDeliveryDate() {
    return InkWell(
      onTap: () {
        _selectDeliveryDate(context, edt_delivery_date, edt_rev_delivery_date);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /*  SizedBox(
            height: 5,
          ),*/
          Card(
            elevation: 8,
            color: Colors.grey[50],
            shadowColor: Colors.blue,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Container(
              height: 40,
              padding: EdgeInsets.only(left: 20, right: 20),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      edt_delivery_date.text == null ||
                              edt_delivery_date.text == ""
                          ? "DD-MM-YYYY"
                          : edt_delivery_date.text,
                      style: baseTheme.textTheme.headline3.copyWith(
                          color: edt_delivery_date.text == null ||
                                  edt_delivery_date.text == ""
                              ? colorGrayDark
                              : colorBlack,
                          fontSize: 15),
                    ),
                  ),
                  Icon(
                    Icons.calendar_today_outlined,
                    color: colorGrayDark,
                    size: 17,
                  )
                ],
              ),
            ),
          )
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
                if (edt_CustomerName.text != "") {
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
                /*SizedBox(
                  height: 5,
                ),*/
                Card(
                  elevation: 5,
                  color: Colors.grey[50],
                  shadowColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    height: 40,
                    padding: EdgeInsets.only(left: 20, right: 20),
                    width: double.maxFinite,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                              controller: controllerForLeft,
                              enabled: false,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 10),
                                hintText: hintTextvalue,
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

  ShipmentDetails() {
    return Container(
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        elevation: 2,
        child: Container(
          decoration: BoxDecoration(
              color: colorPrimary, borderRadius: BorderRadius.circular(20)),
          child: Theme(
            data: ThemeData().copyWith(
              dividerColor: Colors.white70,
            ),
            child: ListTileTheme(
              dense: true,
              child: ExpansionTile(
                iconColor: Colors.white,
                collapsedIconColor: Colors.white,

                // backgroundColor: Colors.grey[350],
                title: Text(
                  "Shipment Detail",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),

                leading: Container(child: Icon(Icons.local_shipping_outlined)),

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
                        createTextLabel(
                            "Pre Carriage By (Transporter Name)", 10.0, 0.0),
                        createTextFormField(
                            _controller_transport_name, "Enter Transport Name",
                            keyboardInput: TextInputType.text),
                        SizedBox(
                          height: 3,
                        ),
                        createTextLabel(
                            "Place Of Rec.By Pre Carrier", 10.0, 0.0),
                        createTextFormField(
                            _controller_place_of_rec, "Enter Place",
                            keyboardInput: TextInputType.text),
                        SizedBox(
                          height: 3,
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: createTextLabel(
                                  "Vessel/Flight No", 10.0, 0.0),
                            ),
                            Flexible(
                              child:
                                  createTextLabel("Port Of Loading", 10.0, 0.0),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: createTextFormField(
                                  _controller_flight_no, "Enter Flight No."),
                            ),
                            Flexible(
                              child: createTextFormField(
                                  _controller_port_of_loading,
                                  "Enter Port Of Loading",
                                  keyboardInput: TextInputType.text),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: createTextLabel(
                                  "Port Of Dispatch", 10.0, 0.0),
                            ),
                            Flexible(
                              child: createTextLabel(
                                  "Port Of Destination", 10.0, 0.0),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: createTextFormField(
                                  _controller_port_of_dispatch,
                                  "Enter Port Of Dispatch",
                                  keyboardInput: TextInputType.text),
                            ),
                            Flexible(
                              child: createTextFormField(
                                  _controller_port_of_destination,
                                  "Enter Port Of Destination",
                                  keyboardInput: TextInputType.text),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Flexible(
                              child:
                                  createTextLabel("Container No.", 10.0, 0.0),
                            ),
                            Flexible(
                              child: createTextLabel("Packages", 10.0, 0.0),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: createTextFormField(
                                  _controller_container_no,
                                  "Enter Container No."),
                            ),
                            Flexible(
                              child: createTextFormField(
                                  _controller_packages, "Enter Packages",
                                  keyboardInput: TextInputType.text),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Row(
                          children: [
                            Flexible(
                              child:
                                  createTextLabel("Packages Types", 10.0, 0.0),
                            ),
                            Flexible(
                              child:
                                  createTextLabel("Net Weight(KGs)", 10.0, 0.0),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: createTextFormField(
                                  _controller_type_of_package,
                                  "Enter packages type",
                                  keyboardInput: TextInputType.text),
                            ),
                            Flexible(
                              child: createTextFormField(
                                  _controller_net_weight, "Enter Net Weight"),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: createTextLabel(
                                  "Gross Weight(KGs)", 10.0, 0.0),
                            ),
                            Flexible(
                              child: createTextLabel(
                                  "FOB (Free Of Board)", 10.0, 0.0),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: createTextFormField(
                                  _controller_gross_weight,
                                  "Enter Gross Weight"),
                            ),
                            Flexible(
                              child: createTextFormField(
                                  _controller_FOB, "Enter FOB",
                                  keyboardInput: TextInputType.text),
                            ),
                          ],
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

    if (edt_CustomerpkID.text.toString() != "") {
      List<MaterialOutwardTable> temp =
          await OfflineDbHelper.getInstance().getMaterialOutwardProduct();

      if (temp.length != 0) {
        showCommonDialogWithTwoOptions(
            context, "Are you sure you want to Save this record ?",
            negativeButtonTitle: "No",
            positiveButtonTitle: "Yes", onTapOfPositiveButton: () async {
          Navigator.of(context).pop();

          List<File> tempMultipleVideoList = [];

          List<File> tempMultipleVideoListForSlip = [];

          if (MultipleVideoList.length != 0) {
            for (int i = 0; i < MultipleVideoList.length; i++) {
              final extension = p.extension(MultipleVideoList[i].path);
              if (extension.toString() == ".jpg" ||
                  extension.toString() == ".jpeg") {
                final dir = await getTemporaryDirectory();
                int timestamp1 = DateTime.now().millisecondsSinceEpoch;
                final targetPath = dir.absolute.path +
                    "/" +
                    i.toString() +
                    timestamp1.toString() +
                    extension.toString();
                File file1231 = await testCompressAndGetFile(
                    MultipleVideoList[i], targetPath);
                tempMultipleVideoList.add(file1231);
              } else {
                final dir = await getTemporaryDirectory();
                int timestamp1 = DateTime.now().millisecondsSinceEpoch;
                final targetPath = dir.absolute.path +
                    "/" +
                    i.toString() +
                    timestamp1.toString() +
                    extension.toString();
                tempMultipleVideoList
                    .add(MultipleVideoList[i].renameSync(targetPath));
              }
            }
          }

          if (MultipleVideoList1.length != 0) {
            for (int i = 0; i < MultipleVideoList1.length; i++) {
              final extension = p.extension(MultipleVideoList1[i].path);
              if (extension.toLowerCase().toString() == ".jpg") {
                final dir = await getTemporaryDirectory();
                int timestamp1 = DateTime.now().millisecondsSinceEpoch;
                final targetPath = dir.absolute.path +
                    "/" +
                    i.toString() +
                    timestamp1.toString() +
                    extension.toString();
                print("sldjsdjf4rddf_jpg" + targetPath.toString());
                File file1231 = await testCompressAndGetFile(
                    MultipleVideoList1[i], targetPath);
                tempMultipleVideoListForSlip.add(file1231);
              } else if (extension.toLowerCase().toString() == ".jpeg") {
                final dir = await getTemporaryDirectory();
                int timestamp1 = DateTime.now().millisecondsSinceEpoch;
                final targetPath = dir.absolute.path +
                    "/" +
                    i.toString() +
                    timestamp1.toString() +
                    extension.toString();
                print("sldjsdjf4rddf_jpeg" + targetPath.toString());
                File file1231 = await testCompressAndGetFile(
                    MultipleVideoList1[i], targetPath);
                tempMultipleVideoListForSlip.add(file1231);
              } else {
                final dir = await getTemporaryDirectory();
                int timestamp1 = DateTime.now().millisecondsSinceEpoch;
                final targetPath = dir.absolute.path +
                    "/" +
                    i.toString() +
                    timestamp1.toString() +
                    extension.toString();
                tempMultipleVideoListForSlip
                    .add(MultipleVideoList1[i].renameSync(targetPath));
              }
            }
          }

          _mainBloc.add(MaterialOutwardAddEditCallEvent(
            MaterialOutwardAddUpdateRequest(
              pkID: pkID.toString(),
              OutwardNo: edt_OutwardNo.text,
              OutwardDate: edt_Reverse_Outward_date.text,
              CustomerID: edt_CustomerpkID.text,
              LocationID: "0",
              ExporterRef: "",
              SupOrderRef: "",
              SupOrderDate: "",
              OtherRef: "",
              OrderNo: "",
              OrderStatus: "",
              ModeOfTransport: edt_mode_of_transfer.text,
              TransporterName: edt_Transporter.text,
              VehicleNo: edt_vihical_no.text,
              LRNo: edt_LR_NO.text,
              LRDate: edt_LR_date_Reveres.text,
              DCNo: edt_DC_NO.text,
              DCDate: edt_rev_delivery_date.text,
              DeliveryNote: edt_Delivery_Notes.text,
              Remarks: edt_Remarks.text,
              BasicAmt: edt_BasicAmt.text == null ? "0.00" : edt_BasicAmt.text,
              SGSTAmt: edt_SGSTAmt.text == null ? "0.00" : edt_SGSTAmt.text,
              CGSTAmt: edt_CGSTAmt.text == null ? "0.00" : edt_CGSTAmt.text,
              IGSTAmt: edt_IGSTAmt.text == null ? "0.00" : edt_IGSTAmt.text,
              ROffAmt: edt_roundoff.text == null ? "0.00" : edt_roundoff.text,
              NetAmt: edt_NetAmount.text == null ? "0.00" : edt_NetAmount.text,
              LoginUserID: LoginUserID,
              CompanyId: CompanyID.toString(),
            ),
            MaterialOutwardExportSaveRequest(
                OutwardNo: "",
                PreCarrBy: _controller_transport_name.text.toString(),
                PreCarrRecPlace: _controller_place_of_rec.text.toString(),
                FlightNo: _controller_flight_no.text.toString(),
                PortOfLoading: _controller_port_of_loading.text.toString(),
                PortOfDispatch: _controller_port_of_dispatch.text.toString(),
                PortOfDestination:
                    _controller_port_of_destination.text.toString(),
                MarksNo: _controller_container_no.text.toString(),
                Packages: _controller_packages.text.toString(),
                NetWeight: _controller_net_weight.text.toString(),
                GrossWeight: _controller_gross_weight.text.toString(),
                PackageType: _controller_type_of_package.text.toString(),
                FreeOnBoard: _controller_FOB.text.toString(),
                LoginUserID: LoginUserID.toString(),
                CompanyId: CompanyID.toString()),
            tempMultipleVideoList,
            tempMultipleVideoListForSlip,
          ));
        });
      } else {
        showCommonDialogWithSingleOption(
            context, "ProductDetails is required !", positiveButtonTitle: "OK",
            onTapOfPositiveButton: () {
          Navigator.pop(context);
        });
      }
    } else {
      showCommonDialogWithSingleOption(
          context, "Customer Selection Is Required !",
          positiveButtonTitle: "OK", onTapOfPositiveButton: () {
        Navigator.of(context).pop();
      });
    }
  }

  Future<bool> _onBackPressed() async {
    navigateTo(context, MaterialOutwardListMainScreen.routeName);
  }

  void _onMaterialOutwardAddUpdateResponse(
      MaterialOutwardAddUpdateCallResponseState state) {
    showCommonDialogWithSingleOption(context,
        state.materialOutwardAddUpdateResponse.details[0].column2.toString(),
        positiveButtonTitle: "OK", onTapOfPositiveButton: () async {
      navigateTo(context, MaterialOutwardListMainScreen.routeName,
          clearAllStack: true);
    });
  }

  void fillData() async {
    pkID = _editModel.pkID;

    edt_Outward_date.text = _editModel.outwardDate.getFormattedDate(
        fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy");
    edt_Reverse_Outward_date.text = _editModel.outwardDate.getFormattedDate(
        fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd");

    edt_OutwardNo.text = _editModel.outwardNo.toString();
    edt_CustomerpkID.text = _editModel.customerID.toString();
    edt_CustomerName.text = _editModel.customerName;

    edt_mode_of_transfer.text = _editModel.modeOfTransport;
    edt_Transporter.text = _editModel.transporterName;
    edt_vihical_no.text = _editModel.vehicleNo;
    edt_LR_NO.text = _editModel.lRNo;
    edt_LR_date.text = _editModel.lRDate.getFormattedDate(
        fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy");
    edt_LR_date_Reveres.text = _editModel.lRDate.getFormattedDate(
        fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd");
    edt_DC_NO.text = _editModel.dCNo;
    edt_delivery_date.text = _editModel.dCDate.getFormattedDate(
        fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy");
    edt_rev_delivery_date.text = _editModel.dCDate.getFormattedDate(
        fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd");
    edt_Delivery_Notes.text = _editModel.deliveryNote;
    edt_Remarks.text = _editModel.remarks;

    edt_StateCode.text = _editModel.stateCode.toString();

    edt_NetAmount.text = _editModel.netAmt.toString();
    edt_BasicAmt.text = _editModel.basicAmt.toString();
    edt_SGSTAmt.text = _editModel.sGSTAmt.toString();
    edt_CGSTAmt.text = _editModel.cGSTAmt.toString();
    edt_IGSTAmt.text = _editModel.iGSTAmt.toString();
    edt_roundoff.text = _editModel.rOffAmt.toString();

    //_onSO ExportList Response

    _soExportListResponse = widget.arguments.soExportListResponse;

    _controller_transport_name.text =
        _soExportListResponse.details[0].preCarrBy;
    _controller_place_of_rec.text =
        _soExportListResponse.details[0].preCarrRecPlace;
    _controller_flight_no.text = _soExportListResponse.details[0].flightNo;
    _controller_port_of_loading.text =
        _soExportListResponse.details[0].portOfLoading;
    _controller_port_of_dispatch.text =
        _soExportListResponse.details[0].portOfDispatch;
    _controller_port_of_destination.text =
        _soExportListResponse.details[0].portOfDestination;
    _controller_container_no.text = _soExportListResponse.details[0].marksNo;

    _controller_packages.text = _soExportListResponse.details[0].packages;
    _controller_net_weight.text = _soExportListResponse.details[0].netWeight;

    _controller_gross_weight.text =
        _soExportListResponse.details[0].grossWeight;

    _controller_type_of_package.text =
        _soExportListResponse.details[0].packageType;

    _controller_FOB.text = _soExportListResponse.details[0].freeOnBoard;

    int stateCode = _editModel.stateCode;

    if (_editModel.outwardNo.toString() != "") {
      _mainBloc.add(MaterialOutwardDetailsListCallEvent(
          stateCode,
          LoginUserID,
          MaterialOutwardDetailsListRequest(
              OutwardNo: _editModel.outwardNo.toString(),
              CompanyId: CompanyID.toString())));

      /*_mainBloc.add(MaterialOutwardExportListRequestEvent(
          MaterialOutwardExportListMainRequest(
              OutwardNo: _editModel.outwardNo.toString(),
              LoginUserID: LoginUserID,
              CompanyId: CompanyID.toString())));*/
    }

    if (widget.arguments.documentList.isNotEmpty) {
      MultipleVideoList.clear();
      for (int i = 0; i < widget.arguments.documentList.length; i++) {
        MultipleVideoList.add(widget.arguments.documentList[i]);
      }
    }

    if (widget.arguments.documentListForSlip.isNotEmpty) {
      MultipleVideoList1.clear();
      for (int i = 0; i < widget.arguments.documentListForSlip.length; i++) {
        MultipleVideoList1.add(widget.arguments.documentListForSlip[i]);
      }
    }
  }

  void MaterialOutwardDetailsListCallResponse(
      MaterialOutwardDetailsListCallResponseState state) async {
    if (state.response.details.length != 0) {
      await OfflineDbHelper.getInstance().deleteALLMaterialOutwardProduct();

      for (var i = 0; i < state.response.details.length; i++) {
        double Quantity = state.response.details[i].quantity;
        double UnitPrice = state.response.details[i].unitRate;
        int DisPer = state.response.details[i].discountPercent;
        double DisAmount = state.response.details[i].discountAmt;
        double NetRate = state.response.details[i].netRate;
        double Amount = state.response.details[i].amount;
        double TaxPer = state.response.details[i].taxRate;
        double TaxAmount = state.response.details[i].taxAmount;
        int TaxType = state.response.details[i].taxType;
        double TotalAmount = state.response.details[i].netAmount;
        double CGSTPer = state.response.details[i].cGSTPer;
        double SGSTPer = state.response.details[i].sGSTPer;
        double IGSTPer = state.response.details[i].iGSTPer;
        double CGSTAmount = state.response.details[i].cGSTAmt;
        double SGSTAmount = state.response.details[i].sGSTAmt;
        double IGSTAmount = state.response.details[i].iGSTAmt;

        await OfflineDbHelper.getInstance()
            .insertMaterialOutwardProduct(MaterialOutwardTable(
          state.response.details[i].pkID, //int    pkID,
          state.response.details[i].outwardNo, //String OutwardNo,
          state.response.details[i].productID, //int    ProductID,
          state.response.details[i].productName, //String ProductName,
          state.response.details[i].quantity, //double Quantity,
          state.response.details[i]
              .productSpecification, //String ProductSpecification,
          state.response.details[i].quantityWeight, //double QuantityWeight,
          state.response.details[i].serialNo, //String SerialNo,
          state.response.details[i].boxNo, //String BoxNo,
          state.response.details[i].unit, //String Unit,
          state.response.details[i].unitRate, //double UnitRate,
          DisPer.toDouble(), //double DiscountPercent,
          state.response.details[i].netRate, //double NetRate,
          state.response.details[i].amount, //double Amount,
          state.response.details[i].taxRate, //double TaxRate,
          state.response.details[i].taxAmount, //double TaxAmount,
          state.response.details[i].netAmount, //double NetAmount,
          state.response.details[i].orderNo, //String OrderNo,
          state.response.details[i].locationID, //int    LocationID,
          state.response.details[i].iGSTPer, //double IGSTPer,
          state.response.details[i].discountAmt, //double DiscountAmt,
          state.response.details[i].sGSTAmt, //double SGSTAmt,
          state.response.details[i].cGSTAmt, //double CGSTAmt,
          state.response.details[i].iGSTAmt, //double IGSTAmt,
          state.response.details[i].sampleQuantity, //double SampleQuantity,
          state.response.details[i].dateCode, //String DateCode,
          state.response.details[i].taxType, //int    TaxType,
          state.response.details[i].sGSTPer, //double SGSTPer,
          state.response.details[i].cGSTPer, //double CGSTPer,
          int.parse(edt_StateCode.text), //int    StateCode,
          LoginUserID, //String LoginUserID,
          CompanyID.toString(), //String CompanyId,
        ));
      }
    }
  }

  void _onMaterialOutwardGetDetailsOutwardNoBYFetchTypeResponse(
      MaterialOutwardGetDetailsOutwardNoBYFetchTypeResponseState state) async {
    if (state.response.details.length != 0) {
      await OfflineDbHelper.getInstance().deleteALLMaterialOutwardProduct();

      for (var i = 0; i < state.response.details.length; i++) {
        double Quantity = state.response.details[i].quantity;
        double UnitPrice = state.response.details[i].unitRate;
        double DisPer = state.response.details[i].discountPercent;
        double DisAmount = state.response.details[i].discountAmt;
        double NetRate = state.response.details[i].netRate;
        double Amount = state.response.details[i].amount;
        double TaxPer = state.response.details[i].taxRate;
        double TaxAmount = state.response.details[i].taxAmount;
        int TaxType = state.response.details[i].taxType;
        double TotalAmount = state.response.details[i].netAmount;
        double CGSTPer = state.response.details[i].cGSTPer;
        double SGSTPer = state.response.details[i].sGSTPer;
        double IGSTPer = state.response.details[i].iGSTPer;
        double CGSTAmount = state.response.details[i].cGSTAmt;
        double SGSTAmount = state.response.details[i].sGSTAmt;
        double IGSTAmount = state.response.details[i].iGSTAmt;

        await OfflineDbHelper.getInstance()
            .insertMaterialOutwardProduct(MaterialOutwardTable(
          0, //int    pkID,
          "", //String OutwardNo,
          state.response.details[i].productID, //int    ProductID,
          state.response.details[i].productName, //String ProductName,
          state.response.details[i].quantity, //double Quantity,
          "", //String ProductSpecification,
          0.00, //double QuantityWeight,
          "", //String SerialNo,
          "", //String BoxNo,
          state.response.details[i].unit, //String Unit,
          state.response.details[i].unitRate, //double UnitRate,
          DisPer, //double DiscountPercent,
          state.response.details[i].netRate, //double NetRate,
          state.response.details[i].amount, //double Amount,
          state.response.details[i].taxRate, //double TaxRate,
          state.response.details[i].taxAmount, //double TaxAmount,
          state.response.details[i].netAmount, //double NetAmount,
          state.response.details[i].orderNo, //String OrderNo,
          0, //int    LocationID,
          state.response.details[i].iGSTPer, //double IGSTPer,
          state.response.details[i].discountAmt, //double DiscountAmt,
          state.response.details[i].sGSTAmt, //double SGSTAmt,
          state.response.details[i].cGSTAmt, //double CGSTAmt,
          state.response.details[i].iGSTAmt, //double IGSTAmt,
          state.response.details[i].sampleQuantity, //double SampleQuantity,
          "", //String DateCode,
          state.response.details[i].taxType, //int    TaxType,
          state.response.details[i].sGSTPer, //double SGSTPer,
          state.response.details[i].cGSTPer, //double CGSTPer,
          int.parse(edt_StateCode.text), //int    StateCode,
          LoginUserID, //String LoginUserID,
          CompanyID.toString(), //String CompanyId,
        ));
      }
    }
  }

  void _onInvoiceDocumentOnlyNameListResponseState(
      DefDocumentListResponseState state) {
    if (state.response.details != 0) {
      fileListName.clear();
      for (int i = 0; i < state.response.details.length; i++) {
        String uriString = _offlineCompanyData.details[0].siteURL.toString() +
            "/ModuleDocs/" +
            state.response.details[i].docName;

        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = state.response.details[i].docName;
        all_name_id.Name1 = uriString;

        fileListName.add(all_name_id);
      }
    }
  }

  void _onInvoiceDocumentOnlyNameListResponseState1(
      InvoiceDocumentOnlyNameListResponseState1 state) {
    if (state.response.details != 0) {
      fileListName1.clear();
      for (int i = 0; i < state.response.details.length; i++) {
        String uriString = _offlineCompanyData.details[0].siteURL.toString() +
            "/ModuleDocs/" +
            state.response.details[i].docName;

        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = state.response.details[i].docName;
        all_name_id.Name1 = uriString;

        fileListName1.add(all_name_id);
      }
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

  /*Attachments() {
    return Container(
      child: Card(
        color: Color(0xff362d8b),
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        elevation: 2,
        child: Container(
          decoration: BoxDecoration(
              ),
          child: Theme(
            data: ThemeData().copyWith(
              dividerColor: Colors.white70,
            ),
            child: ListTileTheme(
              dense: true,
              child: ExpansionTile(
                iconColor: Colors.white,
                collapsedIconColor: Colors.white,
                // backgroundColor: Colors.grey[350],
                title: Text(
                  "Outward Attachment",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                leading: Container(child: Icon(Icons.attachment)),
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
                        AttachedFileList(),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                          child: getCommonButton(baseTheme, () async {
                            if (permissionGranted == false) {
                              //await Permission.storage.request();

                              _getStoragePermission();
                              // checkPhotoPermissionStatus();
                            } else {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext bc) {
                                    return SafeArea(
                                      child: Container(
                                        child: new Wrap(
                                          children: <Widget>[
                                            new ListTile(
                                                leading:
                                                    new Icon(Icons.photo_library),
                                                title: new Text('Choose Files'),
                                                onTap: () async {
                                                  Navigator.of(context).pop();
                                                  FilePickerResult result =
                                                      await FilePicker.platform
                                                          .pickFiles(
                                                    type: FileType.custom,
                                                    allowedExtensions: [
                                                      'jpg',
                                                      'pdf',
                                                      'doc',
                                                      'png'
                                                    ],
                                                    allowMultiple: true,
                                                  );
                                                  if (result != null) {
                                                    List<File> files =
                                                        result.paths.map((path) {
                                                      bool ISDuplicate = false;
                                                      if (MultipleVideoList
                                                              .length !=
                                                          0) {
                                                        for (int i = 0;
                                                            i <
                                                                MultipleVideoList
                                                                    .length;
                                                            i++) {
                                                          if (path ==
                                                              MultipleVideoList[i]
                                                                  .path) {
                                                            ISDuplicate = true;
                                                          } else {
                                                            ISDuplicate = false;
                                                          }
                                                        }
                                                      }
                                                      if (ISDuplicate == true) {
                                                        showCommonDialogWithSingleOption(
                                                            context,
                                                            "File Is Already Exist !",
                                                            positiveButtonTitle:
                                                                "OK");
                                                      } else {
                                                        final bytes = File(path)
                                                            .readAsBytesSync()
                                                            .lengthInBytes;
                                                        final kb = bytes / 1024;
                                                        final mb = kb / 1024;
                                                        if (mb >= 15) {
                                                          showCommonDialogWithSingleOption(
                                                              context,
                                                              "Document Size Should not be Greater than 15 MB !",
                                                              positiveButtonTitle:
                                                                  "OK");
                                                        } else {
                                                          MultipleVideoList.add(
                                                              File(path));
                                                        }
                                                      }
                                                    }).toList();

                                                    setState(() {});
                                                  } else {
                                                    // User canceled the picker
                                                  }
                                                }),
                                            new ListTile(
                                              leading:
                                                  new Icon(Icons.photo_camera),
                                              title: new Text('Choose Camera'),
                                              onTap: () async {
                                                Navigator.of(context).pop();
                                                bool ISDuplicate = false;

                                                XFile file =
                                                    await imagepicker.pickImage(
                                                  source: ImageSource.camera,
                                                );

                                                File file1 = File(file.path);
                                                final dir =
                                                    await getTemporaryDirectory();
                                                final extension =
                                                    p.extension(file1.path);
                                                int timestamp1 = DateTime.now()
                                                    .millisecondsSinceEpoch;
                                                String filenamepunchin =

                                                    */ /*_offlineLoggedInData.details[0].employeeID.toString() +
                                                        "_" +*/ /*
                                                    DateTime.now()
                                                            .day
                                                            .toString() +
                                                        "_" +
                                                        DateTime.now()
                                                            .month
                                                            .toString() +
                                                        "_" +
                                                        DateTime.now()
                                                            .year
                                                            .toString() +
                                                        "_" +
                                                        timestamp1.toString() +
                                                        extension;

                                                final targetPath =
                                                    dir.absolute.path +
                                                        "/" +
                                                        filenamepunchin;
                                                File newRenameFile =
                                                    await File(file1.path)
                                                        .copy(targetPath);
                                                final bytes = newRenameFile
                                                    .readAsBytesSync()
                                                    .lengthInBytes;
                                                final kb = bytes / 1024;
                                                final mb = kb / 1024;

                                                if (mb >= 15) {
                                                  showCommonDialogWithSingleOption(
                                                      context,
                                                      "Image Size Should not be Greater than 15 MB !",
                                                      positiveButtonTitle: "OK");
                                                } else {
                                                  // videofile = file;

                                                  MultipleVideoList.add(
                                                      File(newRenameFile.path));

                                                  setState(() {});
                                                }
                                                setState(() {});
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            }
                          }, "Choose File",
                              radius: 15,
                              backGroundColor: colorPrimary,
                              textColor: colorWhite),
                        )
                      ],
                    ),
                  ),
                ], // children:
              ),
            ),
          ),
        ),
      ),
    );
  }

  AttachedFileList() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(top: 5, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showCommonDialogWithTwoOptions(context,
                            "Are you sure you want to delete this File ?",
                            negativeButtonTitle: "No",
                            positiveButtonTitle: "Yes",
                            onTapOfPositiveButton: () {
                          Navigator.of(context).pop();

                          _isForUpdate == true ?
                          _mainBloc.add(
                              ModuleAttachmentsItemWiseDeleteRequestEvent(
                                  ModuleAttachmentsItemWiseDeleteRequest(
                                    pkID: fileListName[index]
                                        .pkID
                                        .toString(),
                                    ModuleName: "outward",
                                    LoginUserID: LoginUserID,
                                    CompanyId: CompanyID.toString(),
                                  )))
                              : MultipleVideoList.removeAt(index);
                          setState(() {});
                        });
                      },
                      child: Icon(
                        Icons.delete_forever,
                        size: 32,
                        color: colorBlack,
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          await OpenFile.open(
                              MultipleVideoList[index].path);
                          // OpenFile.open('assets/images/features.png');
                        },
                        child: Card(
                          elevation: 5,
                          color: colorWhite,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            width: double.infinity,
                            child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  child: Text(
                                    MultipleVideoList[index].path.split('/').last,
                                    softWrap: true,
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: colorPrimary,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline
                                    ),
                                  ),
                                )),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            shrinkWrap: true,
            itemCount: MultipleVideoList.length,
          ),
        ],
      ),
    );
  }

  APIAttachedFileList() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return fileListName[index].isChecked == false
                  ? Container(
                      margin: EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        //crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          */ /*GestureDetector(
                            onTap: () {
                              showCommonDialogWithTwoOptions(context,
                                  "Are you sure you want to delete this File ?",
                                  negativeButtonTitle: "No",
                                  positiveButtonTitle: "Yes",
                                  onTapOfPositiveButton: () {
                                Navigator.of(context).pop();
                                _isForUpdate == true
                                    ? _mainBloc.add(
                                        ModuleAttachmentsItemWiseDeleteRequestEvent(
                                            ModuleAttachmentsItemWiseDeleteRequest(
                                        pkID:
                                            fileListName[index].pkID.toString(),
                                        ModuleName: "outward",
                                        LoginUserID: LoginUserID,
                                        CompanyId: CompanyID.toString(),
                                      )))
                                    : fileListName[index].isChecked = true;
                                setState(() {});
                              });
                            },
                            child: Icon(
                              Icons.delete_forever,
                              size: 32,
                              color: colorPrimary,
                            ),
                          ),*/ /*
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                baseBloc.emit(
                                    ShowProgressIndicatorState(true));

                                try {
                                  Directory dir = await path_provider
                                      .getTemporaryDirectory();
                                  dir.exists();
                                  String pathName = p.join(dir.path,
                                      fileListName[index].Name);

                                  await Dio().download(
                                      fileListName[index].Name1,
                                      pathName);
                                  print("Download Completed.");

                                  File file = await toFile(pathName);
                                  MultipleVideoList.add(file);
                                  fileListName[index].isChecked = true;
                                } catch (e) {
                                  print("Download Failed.\n\n" +
                                      e.toString());
                                }

                                baseBloc.emit(
                                    ShowProgressIndicatorState(false));
                                setState(() {
                                  //  fileListName.removeAt(index);
                                  fileListName[index].isChecked = true;
                                });
                              },
                              child: Card(
                                elevation: 5,
                                color: colorLightGray,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Container(
                                  width: double.infinity,
                                  child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.download,
                                              size: 20,
                                              color: colorBlack,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Flexible(
                                              child: Text(
                                                fileListName[index].Name,
                                                softWrap: true,
                                                overflow: TextOverflow.clip,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: colorPrimary,
                                                    fontWeight: FontWeight.bold,
                                                    decoration: TextDecoration.underline
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container();

              // }
            },
            shrinkWrap: true,
            itemCount: fileListName.length,
          ),
        ],
      ),
    );
  }

  Attachments1() {
    return Container(
      child: Card(
        color: Color(0xff362d8b),
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        elevation: 2,
        child: Container(
          decoration: BoxDecoration(),
          child: Theme(
            data: ThemeData().copyWith(
              dividerColor: Colors.white70,
            ),
            child: ListTileTheme(
              dense: true,
              child: ExpansionTile(
                iconColor: Colors.white,
                collapsedIconColor: Colors.white,
                // backgroundColor: Colors.grey[350],
                title: Text(
                  "Outward-Sales Attachment",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                leading: Container(child: Icon(Icons.attachment)),
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
                        AttachedFileList1(),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                          child: getCommonButton(baseTheme, () async {
                            if (permissionGranted == false) {
                              //await Permission.storage.request();

                              _getStoragePermission();
                              // checkPhotoPermissionStatus();
                            } else {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext bc) {
                                    return SafeArea(
                                      child: Container(
                                        child: new Wrap(
                                          children: <Widget>[
                                            new ListTile(
                                                leading:
                                                    new Icon(Icons.photo_library),
                                                title: new Text('Choose Files'),
                                                onTap: () async {
                                                  Navigator.of(context).pop();
                                                  FilePickerResult result =
                                                      await FilePicker.platform
                                                          .pickFiles(
                                                    type: FileType.custom,
                                                    allowedExtensions: [
                                                      'jpg',
                                                      'pdf',
                                                      'doc',
                                                      'png'
                                                    ],
                                                    allowMultiple: true,
                                                  );
                                                  if (result != null) {
                                                    List<File> files =
                                                        result.paths.map((path) {
                                                      bool ISDuplicate = false;
                                                      if (MultipleVideoList1
                                                              .length !=
                                                          0) {
                                                        for (int i = 0;
                                                            i <
                                                                MultipleVideoList1
                                                                    .length;
                                                            i++) {
                                                          if (path ==
                                                              MultipleVideoList1[
                                                                      i]
                                                                  .path) {
                                                            ISDuplicate = true;
                                                          } else {
                                                            ISDuplicate = false;
                                                          }
                                                        }
                                                      }
                                                      if (ISDuplicate == true) {
                                                        showCommonDialogWithSingleOption(
                                                            context,
                                                            "File Is Already Exist !",
                                                            positiveButtonTitle:
                                                                "OK");
                                                      } else {
                                                        final bytes = File(path)
                                                            .readAsBytesSync()
                                                            .lengthInBytes;
                                                        final kb = bytes / 1024;
                                                        final mb = kb / 1024;
                                                        if (mb >= 15) {
                                                          showCommonDialogWithSingleOption(
                                                              context,
                                                              "Document Size Should not be Greater than 15 MB !",
                                                              positiveButtonTitle:
                                                                  "OK");
                                                        } else {
                                                          MultipleVideoList1.add(
                                                              File(path));
                                                        }
                                                      }
                                                    }).toList();

                                                    setState(() {});
                                                  } else {
                                                    // User canceled the picker
                                                  }
                                                }),
                                            new ListTile(
                                              leading:
                                                  new Icon(Icons.photo_camera),
                                              title: new Text('Choose Camera'),
                                              onTap: () async {
                                                Navigator.of(context).pop();
                                                bool ISDuplicate = false;

                                                XFile file =
                                                    await imagepicker.pickImage(
                                                  source: ImageSource.camera,
                                                );

                                                File file1 = File(file.path);
                                                final dir =
                                                    await getTemporaryDirectory();
                                                final extension =
                                                    p.extension(file1.path);
                                                int timestamp1 = DateTime.now()
                                                    .millisecondsSinceEpoch;
                                                String filenamepunchin =

                                                    */ /*_offlineLoggedInData.details[0].employeeID.toString() +
                                                        "_" +*/ /*
                                                    DateTime.now()
                                                            .day
                                                            .toString() +
                                                        "_" +
                                                        DateTime.now()
                                                            .month
                                                            .toString() +
                                                        "_" +
                                                        DateTime.now()
                                                            .year
                                                            .toString() +
                                                        "_" +
                                                        timestamp1.toString() +
                                                        extension;

                                                final targetPath =
                                                    dir.absolute.path +
                                                        "/" +
                                                        filenamepunchin;
                                                File newRenameFile =
                                                    await File(file1.path)
                                                        .copy(targetPath);
                                                final bytes = newRenameFile
                                                    .readAsBytesSync()
                                                    .lengthInBytes;
                                                final kb = bytes / 1024;
                                                final mb = kb / 1024;

                                                if (mb >= 15) {
                                                  showCommonDialogWithSingleOption(
                                                      context,
                                                      "Image Size Should not be Greater than 15 MB !",
                                                      positiveButtonTitle: "OK");
                                                } else {
                                                  // videofile = file;

                                                  MultipleVideoList1.add(
                                                      File(newRenameFile.path));

                                                  setState(() {});
                                                }
                                                setState(() {});
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            }
                          }, "Choose File",
                              radius: 15,
                              backGroundColor: colorPrimary,
                              textColor: colorWhite),
                        )
                      ],
                    ),
                  ),
                ], // children:
              ),
            ),
          ),
        ),
      ),
    );
  }

  AttachedFileList1() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(top: 5, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showCommonDialogWithTwoOptions(context,
                            "Are you sure you want to delete this File ?",
                            negativeButtonTitle: "No",
                            positiveButtonTitle: "Yes",
                            onTapOfPositiveButton: () {
                          Navigator.of(context).pop();

                          _isForUpdate == true ?
                          _mainBloc.add(
                              ModuleAttachmentsItemWiseDeleteRequestEvent(
                                  ModuleAttachmentsItemWiseDeleteRequest(
                                    pkID: fileListName1[index]
                                        .pkID
                                        .toString(),
                                    ModuleName: "outward-sales",
                                    LoginUserID: LoginUserID,
                                    CompanyId: CompanyID.toString(),
                                  )))
                           : MultipleVideoList1.removeAt(index);
                          setState(() {});
                        });
                      },
                      child: Icon(
                        Icons.delete_forever,
                        size: 32,
                        color: colorBlack,
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          await OpenFile.open(
                              MultipleVideoList1[index].path);
                          // OpenFile.open('assets/images/features.png');
                        },
                        child: Card(
                          elevation: 5,
                          color: colorWhite,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            width: double.infinity,
                            child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  child: Text(
                                    MultipleVideoList1[index]
                                        .path
                                        .split('/')
                                        .last,
                                    softWrap: true,
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                        fontSize: 13, color: colorPrimary,
                                    fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline
                                    ),
                                  ),
                                )),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            shrinkWrap: true,
            itemCount: MultipleVideoList1.length,
          ),
        ],
      ),
    );
  }

  APIAttachedFileList1() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return fileListName1[index].isChecked == false
                  ? Container(
                      margin: EdgeInsets.only(top: 5, bottom: 5, right: 15, left: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          */ /*GestureDetector(
                            onTap: () {
                              showCommonDialogWithTwoOptions(context,
                                  "Are you sure you want to delete this File ?",
                                  negativeButtonTitle: "No",
                                  positiveButtonTitle: "Yes",
                                  onTapOfPositiveButton: () {
                                Navigator.of(context).pop();
                                _isForUpdate == true
                                    ? _mainBloc.add(
                                        ModuleAttachmentsItemWiseDeleteRequestEvent(
                                            ModuleAttachmentsItemWiseDeleteRequest(
                                        pkID: fileListName1[index]
                                            .pkID
                                            .toString(),
                                        ModuleName: "outward-sales",
                                        LoginUserID: LoginUserID,
                                        CompanyId: CompanyID.toString(),
                                      )))
                                    : fileListName1[index].isChecked = true;
                                setState(() {});
                              });
                            },
                            child: Icon(
                              Icons.delete_forever,
                              size: 32,
                              color: colorPrimary,
                            ),
                          ),*/ /*
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                baseBloc.emit(
                                    ShowProgressIndicatorState(true));

                                try {
                                  Directory dir = await path_provider
                                      .getTemporaryDirectory();
                                  dir.exists();
                                  String pathName = p.join(dir.path,
                                      fileListName1[index].Name);

                                  await Dio().download(
                                      fileListName1[index].Name1,
                                      pathName);
                                  print("Download Completed.");

                                  File file = await toFile(pathName);
                                  MultipleVideoList1.add(file);
                                  fileListName1[index].isChecked = true;
                                } catch (e) {
                                  print("Download Failed.\n\n" +
                                      e.toString());
                                }

                                baseBloc.emit(
                                    ShowProgressIndicatorState(false));
                                setState(() {
                                  //  fileListName.removeAt(index);
                                  fileListName1[index].isChecked = true;
                                });
                              },
                              child: Card(
                                elevation: 5,
                                color: colorLightGray,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Container(
                                  width: double.infinity,
                                  child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.download,
                                              size: 20,
                                              color: colorBlack,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Flexible(
                                              child: Text(
                                                fileListName1[index].Name,
                                                softWrap: true,
                                                overflow: TextOverflow.clip,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: colorPrimary,
                                                    fontWeight: FontWeight.bold,
                                                    decoration: TextDecoration.underline
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container();

              // }
            },
            shrinkWrap: true,
            itemCount: fileListName1.length,
          ),
        ],
      ),
    );
  }*/

  Attachments() {
    return Container(
      child: Card(
        color: Colors.pink,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        elevation: 2,
        child: Container(
          decoration: BoxDecoration(
              //color: Colors.pink, borderRadius: BorderRadius.circular(20)
              // boxShadow: [
              //   BoxShadow(
              //       color: Colors.grey, blurRadius: 3.0, offset: Offset(2, 2),
              //       spreadRadius: 1.0
              //   ),
              // ]
              ),
          child: Theme(
            data: ThemeData().copyWith(
              dividerColor: Colors.white70,
            ),
            child: ListTileTheme(
              dense: true,
              child: ExpansionTile(
                iconColor: Colors.white,
                collapsedIconColor: Colors.white,
                // backgroundColor: Colors.grey[350],
                title: Text(
                  "Attachment For Dispenser",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                leading: Container(child: Icon(Icons.attachment)),
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
                        AttachedFileList(),
                        SizedBox(
                          height: 5,
                        ),
                        getCommonButton(baseTheme, () async {
                          if (permissionGranted == false) {
                            //await Permission.storage.request();

                            _getStoragePermission();
                            //checkPhotoPermissionStatus();
                          } else {
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext bc) {
                                  return SafeArea(
                                    child: Container(
                                      child: new Wrap(
                                        children: <Widget>[
                                          new ListTile(
                                              leading:
                                                  new Icon(Icons.photo_library),
                                              title: new Text('Choose Files'),
                                              onTap: () async {
                                                Navigator.of(context).pop();
                                                FilePickerResult result =
                                                    await FilePicker.platform
                                                        .pickFiles(
                                                  type: FileType.custom,
                                                  allowedExtensions: [
                                                    'jpg',
                                                    'pdf',
                                                    'doc',
                                                    'png'
                                                  ],
                                                  allowMultiple: true,
                                                );
                                                if (result != null) {
                                                  List<File> files =
                                                      result.paths.map((path) {
                                                    bool ISDuplicate = false;
                                                    if (MultipleVideoList
                                                            .length !=
                                                        0) {
                                                      for (int i = 0;
                                                          i <
                                                              MultipleVideoList
                                                                  .length;
                                                          i++) {
                                                        if (path ==
                                                            MultipleVideoList[i]
                                                                .path) {
                                                          ISDuplicate = true;
                                                        } else {
                                                          ISDuplicate = false;
                                                        }
                                                      }
                                                    }
                                                    if (ISDuplicate == true) {
                                                      showCommonDialogWithSingleOption(
                                                          context,
                                                          "File Is Already Exist !",
                                                          positiveButtonTitle:
                                                              "OK");
                                                    } else {
                                                      final bytes = File(path)
                                                          .readAsBytesSync()
                                                          .lengthInBytes;
                                                      final kb = bytes / 1024;
                                                      final mb = kb / 1024;
                                                      if (mb >= 15) {
                                                        showCommonDialogWithSingleOption(
                                                            context,
                                                            "Document Size Should not be Greater than 15 MB !",
                                                            positiveButtonTitle:
                                                                "OK");
                                                      } else {
                                                        MultipleVideoList.add(
                                                            File(path));
                                                      }
                                                    }
                                                  }).toList();

                                                  setState(() {});
                                                } else {
                                                  // User canceled the picker
                                                }
                                              }),
                                          new ListTile(
                                            leading:
                                                new Icon(Icons.photo_camera),
                                            title: new Text('Choose Camera'),
                                            onTap: () async {
                                              Navigator.of(context).pop();
                                              bool ISDuplicate = false;

                                              XFile file =
                                                  await imagepicker.pickImage(
                                                source: ImageSource.camera,
                                              );

                                              File file1 = File(file.path);
                                              final dir =
                                                  await getTemporaryDirectory();
                                              final extension =
                                                  p.extension(file1.path);
                                              int timestamp1 = DateTime.now()
                                                  .millisecondsSinceEpoch;
                                              String filenamepunchin =

                                                  /*_offlineLoggedInData.details[0].employeeID.toString() +
                                                      "_" +*/
                                                  DateTime.now()
                                                          .day
                                                          .toString() +
                                                      "_" +
                                                      DateTime.now()
                                                          .month
                                                          .toString() +
                                                      "_" +
                                                      DateTime.now()
                                                          .year
                                                          .toString() +
                                                      "_" +
                                                      timestamp1.toString() +
                                                      extension;

                                              final targetPath =
                                                  dir.absolute.path +
                                                      "/" +
                                                      filenamepunchin;
                                              File newRenameFile =
                                                  await File(file1.path)
                                                      .copy(targetPath);
                                              final bytes = newRenameFile
                                                  .readAsBytesSync()
                                                  .lengthInBytes;
                                              final kb = bytes / 1024;
                                              final mb = kb / 1024;

                                              // videofile = file;

                                              if (mb >= 15) {
                                                showCommonDialogWithSingleOption(
                                                    context,
                                                    "Image Size Should not be Greater than 15 MB !",
                                                    positiveButtonTitle: "OK");
                                              } else {
                                                // videofile = file;

                                                MultipleVideoList.add(
                                                    File(newRenameFile.path));

                                                setState(() {});

                                                //  dataList.add(VideoListData("Video ", file.path));

                                                //  await _playVideo(videofile);
                                              }

                                              /* XFile file =
                                                  await imagepicker.pickImage(
                                                source: ImageSource.camera,
                                              );

                                              final bytes = File(file.path)
                                                  .readAsBytesSync()
                                                  .lengthInBytes;
                                              final kb = bytes / 1024;
                                              final mb = kb / 1024;
                                              if (mb >= 15) {
                                                showCommonDialogWithSingleOption(
                                                    context,
                                                    "Document Size Should not be Greater than 15 MB !",
                                                    positiveButtonTitle: "OK");
                                              } else {
                                                MultipleVideoList.add(
                                                    File(file.path));
                                              }
*/
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          }
                        }, "Choose File",
                            radius: 20,
                            backGroundColor: Color(0xff02b1fc),
                            textColor: colorWhite)
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

  Attachments1() {
    return Container(
      child: Card(
        color: Colors.pink,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        elevation: 2,
        child: Container(
          decoration: BoxDecoration(
              //color: Colors.pink, borderRadius: BorderRadius.circular(20)
              // boxShadow: [
              //   BoxShadow(
              //       color: Colors.grey, blurRadius: 3.0, offset: Offset(2, 2),
              //       spreadRadius: 1.0
              //   ),
              // ]
              ),
          child: Theme(
            data: ThemeData().copyWith(
              dividerColor: Colors.white70,
            ),
            child: ListTileTheme(
              dense: true,
              child: ExpansionTile(
                iconColor: Colors.white,
                collapsedIconColor: Colors.white,
                // backgroundColor: Colors.grey[350],
                title: Text(
                  "Attachment For Slip",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                leading: Container(child: Icon(Icons.attachment)),
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
                        AttachedFileListForSlip(),
                        SizedBox(
                          height: 5,
                        ),
                        getCommonButton(baseTheme, () async {
                          if (permissionGranted == false) {
                            //await Permission.storage.request();

                            _getStoragePermission();
                            //checkPhotoPermissionStatus();
                          } else {
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext bc) {
                                  return SafeArea(
                                    child: Container(
                                      child: new Wrap(
                                        children: <Widget>[
                                          new ListTile(
                                              leading:
                                                  new Icon(Icons.photo_library),
                                              title: new Text('Choose Files'),
                                              onTap: () async {
                                                Navigator.of(context).pop();
                                                FilePickerResult result =
                                                    await FilePicker.platform
                                                        .pickFiles(
                                                  type: FileType.custom,
                                                  allowedExtensions: [
                                                    'jpg',
                                                    'pdf',
                                                    'doc',
                                                    'png'
                                                  ],
                                                  allowMultiple: true,
                                                );
                                                if (result != null) {
                                                  List<File> files =
                                                      result.paths.map((path) {
                                                    bool ISDuplicate = false;
                                                    if (MultipleVideoList1
                                                            .length !=
                                                        0) {
                                                      for (int i = 0;
                                                          i <
                                                              MultipleVideoList1
                                                                  .length;
                                                          i++) {
                                                        if (path ==
                                                            MultipleVideoList1[
                                                                    i]
                                                                .path) {
                                                          ISDuplicate = true;
                                                        } else {
                                                          ISDuplicate = false;
                                                        }
                                                      }
                                                    }
                                                    if (ISDuplicate == true) {
                                                      showCommonDialogWithSingleOption(
                                                          context,
                                                          "File Is Already Exist !",
                                                          positiveButtonTitle:
                                                              "OK");
                                                    } else {
                                                      final bytes = File(path)
                                                          .readAsBytesSync()
                                                          .lengthInBytes;
                                                      final kb = bytes / 1024;
                                                      final mb = kb / 1024;
                                                      if (mb >= 15) {
                                                        showCommonDialogWithSingleOption(
                                                            context,
                                                            "Document Size Should not be Greater than 15 MB !",
                                                            positiveButtonTitle:
                                                                "OK");
                                                      } else {
                                                        MultipleVideoList1.add(
                                                            File(path));
                                                      }
                                                    }
                                                  }).toList();

                                                  setState(() {});
                                                } else {
                                                  // User canceled the picker
                                                }
                                              }),
                                          new ListTile(
                                            leading:
                                                new Icon(Icons.photo_camera),
                                            title: new Text('Choose Camera'),
                                            onTap: () async {
                                              Navigator.of(context).pop();
                                              bool ISDuplicate = false;

                                              XFile file =
                                                  await imagepicker.pickImage(
                                                source: ImageSource.camera,
                                              );

                                              File file1 = File(file.path);
                                              final dir =
                                                  await getTemporaryDirectory();
                                              final extension =
                                                  p.extension(file1.path);
                                              int timestamp1 = DateTime.now()
                                                  .millisecondsSinceEpoch;
                                              String filenamepunchin =

                                                  /*_offlineLoggedInData.details[0].employeeID.toString() +
                                                      "_" +*/
                                                  DateTime.now()
                                                          .day
                                                          .toString() +
                                                      "_" +
                                                      DateTime.now()
                                                          .month
                                                          .toString() +
                                                      "_" +
                                                      DateTime.now()
                                                          .year
                                                          .toString() +
                                                      "_" +
                                                      timestamp1.toString() +
                                                      extension;

                                              final targetPath =
                                                  dir.absolute.path +
                                                      "/" +
                                                      filenamepunchin;
                                              File newRenameFile =
                                                  await File(file1.path)
                                                      .copy(targetPath);
                                              final bytes = newRenameFile
                                                  .readAsBytesSync()
                                                  .lengthInBytes;
                                              final kb = bytes / 1024;
                                              final mb = kb / 1024;

                                              // videofile = file;

                                              if (mb >= 15) {
                                                showCommonDialogWithSingleOption(
                                                    context,
                                                    "Image Size Should not be Greater than 15 MB !",
                                                    positiveButtonTitle: "OK");
                                              } else {
                                                // videofile = file;

                                                MultipleVideoList1.add(
                                                    File(newRenameFile.path));

                                                setState(() {});

                                                //  dataList.add(VideoListData("Video ", file.path));

                                                //  await _playVideo(videofile);
                                              }
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          }
                        }, "Choose File For Slip",
                            radius: 20,
                            backGroundColor: Color(0xff02b1fc),
                            textColor: colorWhite)
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

  AttachedFileList() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(top: 5, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showCommonDialogWithTwoOptions(context,
                            "Are you sure you want to delete this File ?",
                            negativeButtonTitle: "No",
                            positiveButtonTitle: "Yes",
                            onTapOfPositiveButton: () {
                          Navigator.of(context).pop();

                          // print("sdjdsfj" + MultipleVideoList[index].path);
                          // OpenFile.open(MultipleVideoList[index].path);
                          MultipleVideoList.removeAt(index);
                          setState(() {});
                        });
                      },
                      child: Icon(
                        Icons.delete_forever,
                        size: 32,
                        color: colorPrimary,
                      ),
                    ),
                    Card(
                      elevation: 5,
                      color: colorLightGray,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        /* decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: colorLightGray,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),*/
                        child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                OpenFile.open(MultipleVideoList[index].path);
                              },
                              child: Text(
                                MultipleVideoList[index].path.split('/').last,
                                softWrap: true,

                                //overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 10, color: colorPrimary),
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
              );

              // }
            },
            shrinkWrap: true,
            itemCount: MultipleVideoList.length,
          ),
        ],
      ),
    );
  }

  AttachedFileListForSlip() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(top: 5, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showCommonDialogWithTwoOptions(context,
                            "Are you sure you want to delete this File ?",
                            negativeButtonTitle: "No",
                            positiveButtonTitle: "Yes",
                            onTapOfPositiveButton: () {
                          Navigator.of(context).pop();
                          MultipleVideoList1.removeAt(index);
                          setState(() {});
                        });
                      },
                      child: Icon(
                        Icons.delete_forever,
                        size: 32,
                        color: colorPrimary,
                      ),
                    ),
                    Card(
                      elevation: 5,
                      color: colorLightGray,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        /* decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: colorLightGray,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),*/
                        child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                OpenFile.open(MultipleVideoList1[index].path);
                              },
                              child: Text(
                                MultipleVideoList1[index].path.split('/').last,
                                softWrap: true,

                                //overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 10, color: colorPrimary),
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
              );

              // }
            },
            shrinkWrap: true,
            itemCount: MultipleVideoList1.length,
          ),
        ],
      ),
    );
  }

  Future<void> _getStoragePermission() async {
    DeviceInfoPlugin plugin = DeviceInfoPlugin();
    AndroidDeviceInfo android = await plugin.androidInfo;

    // For Android 12 and below (API < 33)
    if (android.version.sdkInt < 33) {
      permissionHandler.PermissionStatus status =
      await permissionHandler.Permission.storage.request();

      if (status.isGranted) {
        setState(() {
          permissionGranted = true;
        });
      } else if (status.isPermanentlyDenied) {
        _showPermissionDialog(
          'Storage Permission Required',
          'Storage permission is needed for temporary image processing. Please enable it in app settings.',
        );
      } else {
        setState(() {
          permissionGranted = false;
        });
      }
    } else {
      // For Android 13+ - NO STORAGE PERMISSIONS NEEDED!
      // Camera photos are saved to app-specific cache automatically
      setState(() {
        permissionGranted = true;
      });
    }
  }

// Helper method to show permission dialog
  void _showPermissionDialog(String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false, // User must tap a button
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                permissionHandler.openAppSettings();
              },
              child: Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }

  void _onModuleAttachmentItemWiseDeleteResponse(
      ModuleAttachmentItemWiseDeleteResponseState state) {
    showCommonDialogWithSingleOption(
        context, state.resposne.details[0].column2.toString(),
        positiveButtonTitle: "OK", onTapOfPositiveButton: () async {
      navigateTo(context, MaterialOutwardListMainScreen.routeName,
          clearAllStack: true);
    });
  }
}
