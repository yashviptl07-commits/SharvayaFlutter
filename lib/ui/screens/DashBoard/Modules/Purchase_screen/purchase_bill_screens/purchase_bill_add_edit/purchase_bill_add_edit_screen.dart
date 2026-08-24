import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:soleoserp/blocs/MainBloc/mainBloc.dart';
import 'package:soleoserp/models/api_requests/SalesBill/sale_bill_email_content_request.dart';
import 'package:soleoserp/models/api_requests/SalesBill/sales_bill_inq_QT_SO_NO_list_Request.dart';
import 'package:soleoserp/models/api_requests/SalesOrder/multi_no_to_product_details_request.dart';
import 'package:soleoserp/models/api_requests/other/bank_name_drop_down_request.dart';
import 'package:soleoserp/models/api_requests/product/product_master_list_request.dart';
import 'package:soleoserp/models/api_requests/purchase_bill_screen/purchase_bill_add_update_request.dart';
import 'package:soleoserp/models/api_requests/purchase_bill_screen/purchase_bill_details_add_update_request.dart';
import 'package:soleoserp/models/api_requests/purchase_bill_screen/purchase_bill_details_list_request.dart';
import 'package:soleoserp/models/api_requests/purchase_bill_screen/purchase_bill_purchase_TOD_request.dart';
import 'package:soleoserp/models/api_requests/purchase_bill_screen/purchase_bill_purchase_ac_request.dart';
import 'package:soleoserp/models/api_requests/quotation/quotation_other_charge_list_request.dart';
import 'package:soleoserp/models/api_requests/quotation/quotation_project_list_request.dart';
import 'package:soleoserp/models/api_requests/quotation/quotation_terms_condition_request.dart';
import 'package:soleoserp/models/api_requests/short_invoice_request/short_invoice_assembly_load_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/customer/customer_label_value_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/other/all_employee_List_response.dart';
import 'package:soleoserp/models/api_responses/other/city_api_response.dart';
import 'package:soleoserp/models/api_responses/other/country_list_response.dart';
import 'package:soleoserp/models/api_responses/other/state_list_response.dart';
import 'package:soleoserp/models/api_responses/purchase_bill_screen/purchase_bill_list_screen_response.dart';
import 'package:soleoserp/models/api_responses/quotation/quotation_other_charges_list_response.dart';
import 'package:soleoserp/models/common/all_name_id_list.dart';
import 'package:soleoserp/models/common/generic_addtional_calculation/generic_addtional_amount_calculation.dart';
import 'package:soleoserp/models/common/purchase_bill_table.dart';
import 'package:soleoserp/models/common/sales_order_table.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/res/image_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Customer/CustomerAdd_Edit/search_city_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Customer/CustomerAdd_Edit/search_state_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Purchase_screen/purchase_bill_screens/purchase_bill_add_edit/purchase_bill_db_details/pb_product_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Purchase_screen/purchase_bill_screens/purchase_bill_add_edit/purchase_bill_db_details/purchase_bill_summary_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Purchase_screen/purchase_bill_screens/purchase_bill_list_screen/purchase_bill_list_screens.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/inquiry/customer_search/customer_search_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/other_screens/dropdownscreen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/salebill/sales_bill_add_edit/module_no_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/salesorder/SaleOrder_manan_design/country_selection.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/short_invoice/short_invoice_manan_design/products/short_invoice_product_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/home_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/ui/widgets/common_widgets.dart';
import 'package:soleoserp/utils/calculation/additional_charges_calculation.dart';
import 'package:soleoserp/utils/calculation/model/additonalChargeDetails.dart';
import 'package:soleoserp/utils/calculation/purchase_bill_calculation/purchase_bill_header_discount_calculation.dart';
import 'package:soleoserp/utils/calculation/sales_order_calculation/sales_order_header_discount_calculation.dart';
import 'package:soleoserp/utils/date_time_extensions.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/offline_db_helper.dart';
import 'package:soleoserp/utils/sales_order_payment_schedule.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';

class PurchaseBillAddEditScreenArguments {
  PurchaseBillListResponseDetails editModel;

  PurchaseBillAddEditScreenArguments(this.editModel);
}

class PurchaseBillAddEditScreen extends BaseStatefulWidget {
  static const routeName = '/PurchaseBillAddEditScreen';

  final PurchaseBillAddEditScreenArguments arguments;

  PurchaseBillAddEditScreen(this.arguments);

  @override
  _PurchaseBillAddEditScreenState createState() =>
      _PurchaseBillAddEditScreenState();
}

class _PurchaseBillAddEditScreenState
    extends BaseState<PurchaseBillAddEditScreen>
    with BasicScreen, WidgetsBindingObserver, TickerProviderStateMixin {
  MainBloc _mainBloc;
  SearchDetails searchCustomerDetails;
  SearchCountryDetails _searchDetails;
  SearchStateDetails _searchStateDetails;
  SearchCityDetails _searchCityDetails;
  bool _isForUpdate;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime selectedDatePI = DateTime.now();
  DateTime selectedDateRefrence = DateTime.now();
  DateTime selectedDateDelivery = DateTime.now();
  DateTime selectedDateWorkOrder = DateTime.now();
  double dateFontSize = 13;

  /// Basic Info

  TextEditingController edt_invoiceNo = TextEditingController();
  TextEditingController edt_customerName = TextEditingController();
  TextEditingController edt_customerID = TextEditingController();
  TextEditingController edt_invoiceDate = TextEditingController();
  TextEditingController edt_rev_invoiceDate = TextEditingController();
  TextEditingController edt_serialNo = TextEditingController();
  TextEditingController edt_dispatchDate = TextEditingController();
  TextEditingController edt_rev_dispatchDate = TextEditingController();
  TextEditingController edt_bankName = TextEditingController();
  TextEditingController edt_projectName = TextEditingController();
  TextEditingController edt_projectID = TextEditingController();
  TextEditingController edt_bankID = TextEditingController();
  TextEditingController edt_select_salesBill = TextEditingController();
  TextEditingController edt_SuppRef = TextEditingController();
  TextEditingController edt_ref_date = TextEditingController();
  TextEditingController edt_rev_ref_date = TextEditingController();
  TextEditingController edt_deliveryDate = TextEditingController();
  TextEditingController edt_rev_deliveryDate = TextEditingController();
  TextEditingController edt_otherReference = TextEditingController();
  TextEditingController edt_crDays = TextEditingController();

  /// Terms And Condition
  TextEditingController edt_termsAndCondition = TextEditingController();
  TextEditingController edt_select_termsAndConditionName =
      TextEditingController();
  TextEditingController edt_select_termsAndConditionId =
      TextEditingController();

  TextEditingController _controller_Module_NO = TextEditingController();

  List<ALL_Name_ID> arr_ALL_Name_ID_For_Sales_Order_Bank_Name = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Sales_Order_Select_Inquiry = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Sales_Order_Sales_Executive = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Sales_Order_Select_Currency = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Terms_And_Condition = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Email_Subject = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_ProjectList = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_INQ_QT_SO_List = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_INQ_QT_SO_Filter_List = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Payment_Schedual_List = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Sales_Order_Address_DROP_DOWN = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Sales_Order_Address_ORG_DROP_DOWN = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_ModeOfTransfer = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Product = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_PurchaseAC = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_TOD = [];

  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  ALL_EmployeeList_Response _offlineFollowerEmployeeListData;

  int pkID = 0;
  int ExportPkID = 0;
  int ShipmentPkID = 0;
  int CompanyID = 0;
  String LoginUserID = "";
  bool isAllEditable = false;
  PurchaseBillListResponseDetails _editModel;
  DateTime selectedInvoiceDate = DateTime.now();
  DateTime selectedLRDate = DateTime.now();
  DateTime selectedDeliveryDate = DateTime.now();
  String SalesOrderNo = "";
  final TextEditingController edt_HeaderDisc = TextEditingController();
  List<PurchaseBillTable> _inquiryProductList = [];
  List<PurchaseBillDetailsAddUpdateRequest> arrSOProductList = [];
  final TextEditingController edt_StateCode = TextEditingController();
  List<SoPaymentScheduleTable> arr_PaymentScheduleList = [];
  TextEditingController _controllerAmountDialog = TextEditingController();
  TextEditingController _controllerDueDateDialog = TextEditingController();
  TextEditingController _controllerRevDueDateDialog = TextEditingController();
  TextEditingController _eventHour = TextEditingController();
  TextEditingController _eventMinute = TextEditingController();
  AddditionalCharges addditionalCharges = AddditionalCharges();
  bool isUpdateCalculation = false;
  double Tot_otherChargeWithTax = 0.00;
  double Tot_otherChargeExcludeTax = 0.00;

  double HeaderDisAmnt = 0.00;
  List<OtherChargeDetails> arrGenericOtheCharge = [];
  TextEditingController _controller_mode_of_transfer = TextEditingController();
  TextEditingController _controller_Transporter = TextEditingController();
  TextEditingController _controller_LR_NO = TextEditingController();
  TextEditingController _controller_Remarks = TextEditingController();
  TextEditingController _controller_vihical_no = TextEditingController();
  TextEditingController _controller_LR_date = TextEditingController();
  TextEditingController _controller_LR_date_Reveres = TextEditingController();
  TextEditingController edt_ProductID = TextEditingController();
  TextEditingController edt_ProductName = TextEditingController();
  TextEditingController edt_RefSelectedNo = TextEditingController();
  TextEditingController edt_PurchaseACName = TextEditingController();
  TextEditingController edt_PurchaseACID = TextEditingController();
  TextEditingController edt_TODName = TextEditingController();
  TextEditingController edt_TODID = TextEditingController();

  bool isOrganatiozation = false;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    screenStatusBarColor = Color(0xff0066b3);
    _mainBloc = MainBloc(baseBloc);
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;
    _offlineFollowerEmployeeListData =
        SharedPrefHelper.instance.getALLEmployeeList();
    arr_ALL_Name_ID_For_Payment_Schedual_List.clear();
    _onFollowerEmployeeListByStatusCallSuccess(
        _offlineFollowerEmployeeListData);
    getSelectOptionList();
    getAddressDropDownList();
    getModeOfTransport();
    _eventHour.text = "00";
    _eventMinute.text = "00";

    _mainBloc.add(GenericOtherChargeCallEvent(
        CompanyID.toString(), QuotationOtherChargesListRequest(pkID: "")));

    _isForUpdate = widget.arguments != null;
    edt_select_salesBill.addListener(() {
      setState(() {
        if (edt_customerName.text != null || edt_customerName.text != "") {
          if (edt_select_salesBill.text == "G.R.N") {
            _mainBloc.add(SaleBill_INQ_QT_SO_NO_ListRequestEvent(
                SaleBill_INQ_QT_SO_NO_ListRequest(
                    CompanyId: CompanyID.toString(),
                    CustomerID: edt_customerID.text.toString(),
                    ModuleType: "GRN")));
          } else if (edt_select_salesBill.text == "Purchase Order") {
            _mainBloc.add(SaleBill_INQ_QT_SO_NO_ListRequestEvent(
                SaleBill_INQ_QT_SO_NO_ListRequest(
                    CompanyId: CompanyID.toString(),
                    CustomerID: edt_customerID.text.toString(),
                    ModuleType: "PO")));
          }
        } else {
          showCommonDialogWithSingleOption(
              context, "Customer name is required To view Option !",
              positiveButtonTitle: "OK");
        }
      });
    });
    if (_isForUpdate) {
      _editModel = widget.arguments.editModel;
      fillData();
    } else {
      print("dljsf" + _offlineLoggedInData.details[0].CityCode.toString());
      _searchStateDetails = SearchStateDetails();

      edt_invoiceDate.text = selectedDate.day.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.year.toString();
      edt_rev_invoiceDate.text = selectedDate.year.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.day.toString();

      edt_dispatchDate.text = selectedDatePI.day.toString() +
          "-" +
          selectedDatePI.month.toString() +
          "-" +
          selectedDatePI.year.toString();
      edt_rev_dispatchDate.text = selectedDatePI.year.toString() +
          "-" +
          selectedDatePI.month.toString() +
          "-" +
          selectedDatePI.day.toString();

      edt_deliveryDate.text = selectedDateDelivery.day.toString() +
          "-" +
          selectedDateDelivery.month.toString() +
          "-" +
          selectedDateDelivery.year.toString();
      edt_rev_deliveryDate.text = selectedDateDelivery.year.toString() +
          "-" +
          selectedDateDelivery.month.toString() +
          "-" +
          selectedDateDelivery.day.toString();

      _controller_LR_date.text = selectedDateDelivery.day.toString() +
          "-" +
          selectedDateDelivery.month.toString() +
          "-" +
          selectedDateDelivery.year.toString();
      _controller_LR_date_Reveres.text = selectedDateDelivery.year.toString() +
          "-" +
          selectedDateDelivery.month.toString() +
          "-" +
          selectedDateDelivery.day.toString();

      edt_StateCode.text = "";
      _mainBloc.add(DeleteGenericAdditionalChargesEvent());

      _mainBloc.add(AddGenericAdditionalChargesEvent(GenericAddditionalCharges(
          "0.00",
          "0",
          "0.00",
          "0",
          "0.00",
          "0",
          "0.00",
          "0",
          "0.00",
          "0",
          "0.00",
          "",
          "",
          "",
          "",
          "")));

      addditionalCharges = AddditionalCharges(
          DiscountAmt: "0.00",
          SGSTAmt: "0.00",
          CGSTAmt: "0.00",
          IGSTAmt: "0.00",
          //_totalIGSST_AMOUNT_Controller.text.toString(),

          ChargeID1: "0",
          ChargeName1: "",
          ChargeAmt1: "0.00",
          ChargeBasicAmt1: "0.00",
          ChargeGSTAmt1: "0.00",
          ChargeTaxType1: "0",
          ChargeGstPer1: "0.00",
          ChargeIsBeforGst1: "false",
          ChargeID2: "0",
          ChargeName2: "",
          ChargeAmt2: "0.00",
          ChargeBasicAmt2: "0.00",
          ChargeGSTAmt2: "0.00",
          ChargeTaxType2: "0",
          ChargeGstPer2: "0.00",
          ChargeIsBeforGst2: "false",
          ChargeID3: "0",
          ChargeName3: "",
          ChargeAmt3: "0.00",
          ChargeBasicAmt3: "0.00",
          ChargeGSTAmt3: "0.00",
          ChargeTaxType3: "0",
          ChargeGstPer3: "0.00",
          ChargeIsBeforGst3: "false",
          ChargeID4: "0",
          ChargeName4: "",
          ChargeAmt4: "0.00",
          ChargeBasicAmt4: "0.00",
          ChargeGSTAmt4: "0.00",
          ChargeTaxType4: "0",
          ChargeGstPer4: "0.00",
          ChargeIsBeforGst4: "false",
          ChargeID5: "0",
          ChargeName5: "",
          ChargeAmt5: "0.00",
          ChargeBasicAmt5: "0.00",
          ChargeGSTAmt5: "0.00",
          ChargeTaxType5: "0",
          ChargeGstPer5: "0.00",
          ChargeIsBeforGst5: "false",
          NetAmt: "0.00",
          BasicAmt: "0.00",
          ROffAmt: "0.00",
          ChargePer1: "0.00",
          ChargePer2: "0.00",
          ChargePer3: "0.00",
          ChargePer4: "0.00",
          ChargePer5: "0.00",
          AdvanceAmt: "0.00",
          AdvancePer: "0.00");

      _mainBloc.add(SaleOrderBankDetailsListRequestEvent(
          BankNameDropDownRequest(
              CompanyId: CompanyID.toString(),
              pkID: "",
              LoginUserID: LoginUserID)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _mainBloc,
      child: BlocConsumer<MainBloc, MainStates>(
        builder: (BuildContext context, MainStates state) {
          //handle states
          if (state is BankDetailsListResponseState) {
            _onBankDetailsList(state);
          }
          if (state is PaymentScheduleListResponseState) {
            _OnPaymentScheduleSucessList(state);
          }
          if (state is AddGenericAdditionalChargesState) {
            _OnGenericIsertCallSucess(state);
          }
          if (state is DeleteAllGenericAdditionalChargesState) {
            _onDeleteAllGenericAddtionalAmount(state);
          }
          if (state is SearchCustomerListByNumberCallResponseState) {
            _ONOnlyCustomerDetails(state);
          }
          if (state is GenericOtherCharge1ListResponseState) {
            _OnGenricOtherChargeResponse(state);
          }
          if (state is PurchaseBillDetailsListResponseState) {
            _onPurchaseBillDetailsListResponseState(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is BankDetailsListResponseState ||
              currentState is PaymentScheduleListResponseState ||
              currentState is AddGenericAdditionalChargesState ||
              currentState is DeleteAllGenericAdditionalChargesState ||
              currentState is SearchCustomerListByNumberCallResponseState ||
              currentState is GenericOtherCharge1ListResponseState ||
              currentState is PurchaseBillDetailsListResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, MainStates state) {
          if (state is ProductMainListResponseState) {
            _onProductMainListResponseState(state);
          }
          if (state is SalesBill_INQ_QT_SO_NO_ListResponseState) {
            _OnINQ_QT_SO_NO_Response(state);
          }
          if (state is MultiNoToProductDetailsResponseState) {
            _On_No_To_ProductDetails(state);
          }
          if (state is PaymentScheduleResponseState) {
            _onInsertPaymentScheduleSucess(state);
          }
          if (state is PaymentScheduleDeleteResponseState) {
            _ondeletePaymentSchedule(state);
          }
          if (state is PurchaseBillAddUpdateResponseState) {
            _onPurchaseBillAddUpdateResponseState(state);
          }
          if (state is PurchaseBillProductSaveResponseState) {
            _OnPurchaseBillProductSaveResponseState(state);
          }
          if (state is QuotationTermsCondtionResponseState) {
            _OnTermsAndConditionResponse(state);
          }
          if (state is QuotationOtherChargeListResponseState) {
            _onOtherChargeListResponse(state);
          }
          if (state is BankDetailsDialogListResponseState) {
            _onBankDialgSelection(state);
          }
          if (state is QuotationProjectListResponseState) {
            _OnProjectList(state);
          }
          if (state is PurchaseBillDetailsDeleteResponseState) {
            _onPurchaseBillDetailsDeleteResponseState(state);
          }
          if (state is MultiNoToProductDetailsFromGrnResponseState) {
            _onMultiNoToProductDetailsFromGrnResponseState(state);
          }
          if (state is MultiNoToProductDetailsFromPurchaseOrderResponseState) {
            _onMultiNoToProductDetailsFromPurchaseOrderResponseState(state);
          }
          if (state is PurchaseBillACResponseState) {
            _onPurchaseBillACResponseState(state);
          }

          if (state is PurchaseBillTODResponseState) {
            _omPurchaseBillTODResponseState(state);
          }

          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is ProductMainListResponseState ||
              currentState is SalesBill_INQ_QT_SO_NO_ListResponseState ||
              currentState is MultiNoToProductDetailsResponseState ||
              currentState is PaymentScheduleResponseState ||
              currentState is PaymentScheduleDeleteResponseState ||
              currentState is QuotationTermsCondtionResponseState ||
              currentState is QuotationOtherChargeListResponseState ||
              currentState is BankDetailsDialogListResponseState ||
              currentState is QuotationProjectListResponseState ||
              currentState is PurchaseBillAddUpdateResponseState ||
              currentState is PurchaseBillProductSaveResponseState ||
              currentState is PurchaseBillDetailsDeleteResponseState ||
              currentState is MultiNoToProductDetailsFromGrnResponseState ||
              currentState
                  is MultiNoToProductDetailsFromPurchaseOrderResponseState ||
              currentState is PurchaseBillACResponseState ||
              currentState is PurchaseBillTODResponseState) {
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
      child: DefaultTabController(
        length: 7,
        child: Scaffold(
            appBar: NewGradientAppBar(
              gradient: LinearGradient(colors: [
                Color(0xff108dcf),
                Color(0xff0066b3),
                Color(0xff108dcf),
              ]),
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 19,
                ),
                onPressed: () async {
                  await _onTapOfDeleteALLProduct();
                  navigateTo(context, PurchaseBillListScreen.routeName,
                      clearAllStack: true);
                },
              ),
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
                    })
              ],
              title: Text("Purchase Bill ${_isForUpdate ? "Update" : "Add"}"),
            ),
            body: isLoading == true
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              mandatoryDetails(),
                              space(10),
                              ProductAndAddtionalCharges(),
                              space(5),
                              termsAndCondition(),
                              space(5),
                              TransportDetails(),
                              space(20),
                              save(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
      ),
    );
  } // Widget build(BuildContext context)

  Future<bool> _onBackPressed() async {
    await _onTapOfDeleteALLProduct();
    navigateTo(context, PurchaseBillListScreen.routeName, clearAllStack: true);
  }

  Widget ProductDetails() {
    return Container(
      child: Text("Welcome To Tesla Bikes Collections"),
    );
  }

  Widget _buildOrderDate() {
    return InkWell(
        onTap: () {
          _selectOrderDate(context, edt_invoiceDate, edt_rev_invoiceDate);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                "Invoice Date *",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 5),
            Card(
              margin: EdgeInsets.symmetric(horizontal: 10),
              elevation: 8,
              color: Colors.grey[50],
              shadowColor: Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Container(
                height: 50,
                padding: EdgeInsets.only(left: 20, right: 20),
                width: double.maxFinite,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        edt_invoiceDate.text == null ||
                                edt_invoiceDate.text == ""
                            ? "DD-MM-YYYY"
                            : edt_invoiceDate.text,
                        style: baseTheme.textTheme.headline3.copyWith(
                            color: edt_invoiceDate.text == null ||
                                    edt_invoiceDate.text == ""
                                ? colorGrayDark
                                : colorBlack,
                            fontSize: dateFontSize),
                      ),
                    ),
                    Icon(
                      Icons.calendar_today_outlined,
                      color: colorGrayDark,
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildPIDate() {
    return InkWell(
        onTap: () {
          _selectPIDate(context, edt_dispatchDate, edt_rev_dispatchDate);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                "Due Date",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 5),
            Card(
              margin: EdgeInsets.symmetric(horizontal: 10),
              elevation: 8,
              color: Colors.grey[50],
              shadowColor: Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Container(
                height: 50,
                padding: EdgeInsets.only(left: 20, right: 20),
                width: double.maxFinite,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        edt_dispatchDate.text == null ||
                                edt_dispatchDate.text == ""
                            ? "DD-MM-YYYY"
                            : edt_dispatchDate.text,
                        style: baseTheme.textTheme.headline3.copyWith(
                            color: edt_dispatchDate.text == null ||
                                    edt_dispatchDate.text == ""
                                ? colorGrayDark
                                : colorBlack,
                            fontSize: dateFontSize),
                      ),
                    ),
                    Icon(
                      Icons.calendar_today_outlined,
                      color: colorGrayDark,
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildDeliveryDate() {
    return InkWell(
      onTap: () {
        _selectDeliveryDate(context, edt_deliveryDate, edt_rev_deliveryDate);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /*  SizedBox(
            height: 5,
          ),*/
          Card(
            elevation: 10,
            color: colorWhite,
            shadowColor: colorPrimary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              height: 48,
              padding: EdgeInsets.only(left: 20, right: 20),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      edt_deliveryDate.text == null ||
                              edt_deliveryDate.text == ""
                          ? "DD-MM-YYYY"
                          : edt_deliveryDate.text,
                      style: baseTheme.textTheme.headline3.copyWith(
                          color: edt_deliveryDate.text == null ||
                                  edt_deliveryDate.text == ""
                              ? colorGrayDark
                              : colorBlack,
                          fontSize: dateFontSize),
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

  Future<void> _selectOrderDate(
      BuildContext context,
      TextEditingController F_datecontroller,
      TextEditingController Rev_dateController) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        F_datecontroller.text = selectedDate.day.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.year.toString();
        Rev_dateController.text = selectedDate.year.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.day.toString();
      });
  }

  Future<void> _selectPIDate(
      BuildContext context,
      TextEditingController F_datecontroller,
      TextEditingController Rev_dateController) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDatePI,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDatePI = picked;
        F_datecontroller.text = selectedDatePI.day.toString() +
            "-" +
            selectedDatePI.month.toString() +
            "-" +
            selectedDatePI.year.toString();
        Rev_dateController.text = selectedDatePI.year.toString() +
            "-" +
            selectedDatePI.month.toString() +
            "-" +
            selectedDatePI.day.toString();
      });
  }

  Future<void> _selectDeliveryDate(
      BuildContext context,
      TextEditingController F_datecontroller,
      TextEditingController Rev_dateController) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDateDelivery,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDateDelivery = picked;
        F_datecontroller.text = selectedDateDelivery.day.toString() +
            "-" +
            selectedDateDelivery.month.toString() +
            "-" +
            selectedDateDelivery.year.toString();
        Rev_dateController.text = selectedDateDelivery.year.toString() +
            "-" +
            selectedDateDelivery.month.toString() +
            "-" +
            selectedDateDelivery.day.toString();
      });
  }

  Widget SerialNO() {
    return Container(
        child: Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                "CR days",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 5),
            Card(
              margin: EdgeInsets.symmetric(horizontal: 10),
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
                        textInputAction: TextInputAction.next,
                        controller: edt_serialNo,
                        decoration: InputDecoration(
                          hintText: "Enter Serial No",
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    ));
  }

  Widget ShortInvoice() {
    return Container(
        child: Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                "Invoice No",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 5),
            Card(
              margin: EdgeInsets.symmetric(horizontal: 10),
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
                        textInputAction: TextInputAction.next,
                        controller: edt_invoiceNo,
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: "",
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    ));
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
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                "Select Customer *",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 5),
            Card(
              margin: EdgeInsets.symmetric(horizontal: 10),
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
                        controller: edt_customerName,
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
                if (edt_customerName.text != "") {
                  arr_ALL_Name_ID_For_INQ_QT_SO_Filter_List.clear();
                  _controller_Module_NO.text = "";

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
                  elevation: 10,
                  color: colorWhite,
                  shadowColor: colorPrimary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    height: 48,
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
                              )),
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

  Widget CustomDropDownWithID1(
    String Category, {
    bool enable1,
    Icon icon,
    String title,
    String hintTextvalue,
    TextEditingController controllerForLeft,
    TextEditingController controllerForID,
    List<ALL_Name_ID> Custom_values1,
  }) {
    return InkWell(
      onTap: () {
        _mainBloc.add(SaleOrderBankDetailsListDialogRequestEvent(
          BankNameDropDownRequest(
            CompanyId: CompanyID.toString(),
            pkID: "",
            LoginUserID: LoginUserID,
          ),
        ));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              title ?? "", // Show title if provided
              style: TextStyle(
                fontSize: 13,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 5),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 10),
            elevation: 8,
            color: Colors.grey[50],
            shadowColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controllerForLeft,
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: hintTextvalue ?? "Select option",
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade400,
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
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

  Widget CustomDropDownProjectWithID1(
    String Category, {
    bool enable1,
    Icon icon,
    String title,
    String hintTextvalue,
    TextEditingController controllerForLeft,
    TextEditingController controllerForID,
    List<ALL_Name_ID> Custom_values1,
  }) {
    return InkWell(
      onTap: () {
        _mainBloc.add(QuotationProjectListCallEvent(
          QuotationProjectListRequest(
            CompanyId: CompanyID.toString(),
            LoginUserID: LoginUserID,
          ),
        ));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null && title.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          const SizedBox(height: 5),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            elevation: 8,
            shadowColor: Colors.blue,
            color: Colors.grey[50],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controllerForLeft,
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: hintTextvalue ?? "Select Project",
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade400,
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
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

  Widget CustomDropDownWithMultiID1(
    String Category, {
    bool enable1,
    Icon icon,
    String title,
    String hintTextvalue,
  }) {
    return Container(
      child: Column(
        children: [
          InkWell(
            onTap: () {
              _mainBloc.add(QuotationTermsConditionCallEvent(
                  QuotationTermsConditionRequest(
                      CompanyId: CompanyID.toString(),
                      LoginUserID: LoginUserID)));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*SizedBox(
                  height: 5,
                ),*/
                Card(
                  elevation: 3,
                  color: colorLightGray,
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
                            controller: edt_select_termsAndConditionName,
                            enabled: false,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(bottom: 7),
                              hintText: hintTextvalue,
                              hintStyle:
                                  TextStyle(fontSize: 13, color: colorGrayDark),
                              labelStyle: TextStyle(
                                color: Color(0xFF000000),
                              ),
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF000000),
                            )
                            // baseTheme.textTheme.headline2.copyWith(color: colorBlack),
                            ,
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

  showcustomdialogWithOnlyName(
      {List<ALL_Name_ID> values,
      BuildContext context1,
      TextEditingController controller,
      String lable}) async {
    await showDialog(
      barrierDismissible: false,
      context: context1,
      builder: (BuildContext context123) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          title: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: colorBlack, //                   <--- border color
                ),
                borderRadius: BorderRadius.all(Radius.circular(
                        15.0) //                 <--- border radius here
                    ),
              ),
              child: Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    lable,
                    style: TextStyle(
                        color: colorBlack, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ))),
          children: [
            SizedBox(
                width: MediaQuery.of(context123).size.width,
                child: Column(
                  children: [
                    SingleChildScrollView(
                        physics: ScrollPhysics(),
                        child: Column(children: <Widget>[
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (ctx, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context1).pop();
                                  controller.text = values[index].Name;
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: 25, top: 10, bottom: 10, right: 10),
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: colorBlack), //Change color
                                        width: 10.0,
                                        height: 10.0,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 1.5),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        values[index].Name,
                                        style: TextStyle(color: colorBlack),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            itemCount: values.length,
                          ),
                        ])),
                  ],
                )),
          ],
        );
      },
    );
  }

  Widget createTextFormField(
    TextEditingController controller,
    String hintText, {
    int minLines = 1,
    int maxLines = 1,
    double left = 5,
    double right = 5,
    double top = 8,
    double bottom = 10,
    bool isEnable = true,
    TextInputType keyboardInput = TextInputType.text,
  }) {
    return Card(
      color: colorWhite,
      margin:
          EdgeInsets.only(left: left, right: right, top: top, bottom: bottom),
      elevation: 10,
      shadowColor: colorPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: TextFormField(
          controller: controller,
          enabled: isEnable,
          minLines: minLines,
          maxLines: maxLines,
          textInputAction: TextInputAction.next,
          keyboardType: keyboardInput,
          style: const TextStyle(fontSize: 15, color: Colors.black),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(fontSize: 14, color: colorGrayDark),
            border: InputBorder.none,
          ),
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

  Future<void> _onTapOfSearchView() async {
    await _onTapOfDeleteALLProduct();

    if (_isForUpdate == false) {
      navigateTo(context, SearchInquiryCustomerScreen.routeName).then((value) {
        if (value != null) {
          searchCustomerDetails = value;
          edt_customerName.text = searchCustomerDetails.label;
          edt_customerID.text = searchCustomerDetails.value.toString();

          arr_ALL_Name_ID_For_INQ_QT_SO_List.clear();
          arr_ALL_Name_ID_For_INQ_QT_SO_Filter_List.clear();
          _controller_Module_NO.text = "";
          edt_select_salesBill.text = "";

          edt_StateCode.text = searchCustomerDetails.stateCode.toString();
        }
      });
    }
  }

  mandatoryDetails() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Theme(
        data: ThemeData().copyWith(
          dividerColor: Colors.transparent,
        ),
        child: Container(
          child: Column(
            children: [
              ShortInvoice(),
              SizedBox(
                height: 10,
              ),
              _buildOrderDate(),
              SizedBox(
                height: 10,
              ),
              _buildSearchView(),
              SizedBox(
                height: 10,
              ),
              CustomDropDownPurchaseAC(
                "Purchase AC",
                enable1: false,
                icon: Icon(Icons.arrow_drop_down),
                controllerVehical: edt_PurchaseACName,
                vehicalList: arr_ALL_Name_ID_For_PurchaseAC,
              ),
              SizedBox(
                height: 10,
              ),
              CustomDropDownWithID1("BankName",
                  enable1: false,
                  title: "Select Bank",
                  hintTextvalue: "Tap to Select Bank",
                  icon: Icon(Icons.arrow_drop_down),
                  controllerForLeft: edt_bankName,
                  controllerForID: edt_bankID,
                  Custom_values1: arr_ALL_Name_ID_For_Sales_Order_Bank_Name),
              SizedBox(
                height: 10,
              ),
              CustomDropDownTOD(
                "Termination Of Delivery",
                enable1: false,
                icon: Icon(Icons.arrow_drop_down),
                controllerVehical: edt_TODName,
                vehicalList: arr_ALL_Name_ID_For_TOD,
              ),
              SizedBox(
                height: 10,
              ),
              _isForUpdate != true
                  ? Column(
                      children: [
                        CustomDropDown("Option",
                            enable1: false,
                            title: "Select Option",
                            hintTextvalue: "Tap to select",
                            context: context,
                            icon: Icon(Icons.arrow_drop_down),
                            controllerForLeft: edt_select_salesBill,
                            Custom_values1:
                                arr_ALL_Name_ID_For_Sales_Order_Select_Inquiry),
                        SizedBox(
                          height: 15,
                        ),
                        _ModuleDropDown(context),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    )
                  : Container(),
              SerialNO(),
              SizedBox(
                height: 10,
              ),
              _buildPIDate(),
              SizedBox(
                height: 10,
              ),
              CustomDropDownProjectWithID1("Project",
                  enable1: false,
                  title: "Select Project",
                  hintTextvalue: "Tap to Select Projects",
                  icon: Icon(Icons.arrow_drop_down),
                  controllerForLeft: edt_projectName,
                  controllerForID: edt_projectID,
                  Custom_values1: arr_ALL_Name_ID_For_ProjectList),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget CustomDropDownPurchaseAC(
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
                _mainBloc.add(PurchaseBillACRequestEvent(
                    PurchaseBillACRequest(CompanyId: CompanyID, Module: "")));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      Outsource,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Card(
                    margin: EdgeInsets.symmetric(horizontal: 10),
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
                          Icon(
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

  void _onPurchaseBillACResponseState(PurchaseBillACResponseState state) {
    arr_ALL_Name_ID_For_PurchaseAC.clear();
    if (state.response.details.length != 0) {
      for (var i = 0; i < state.response.details.length; i++) {
        ALL_Name_ID categoryResponse123 = ALL_Name_ID();
        categoryResponse123.Name = state.response.details[i].customerName;
        categoryResponse123.pkID = state.response.details[i].customerID;
        arr_ALL_Name_ID_For_PurchaseAC.add(categoryResponse123);
      }
    }

    showcustomdialogWithID(
        values: arr_ALL_Name_ID_For_PurchaseAC,
        context1: context,
        controller: edt_PurchaseACName,
        controllerID: edt_PurchaseACID,
        lable: "Purchase AC");
  }

  Widget CustomDropDownTOD(
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
                _mainBloc
                    .add(PurchaseBillTODRequestEvent(PurchaseBillTODRequest(
                  CountryCode: "",
                  StateCode: "",
                  ListMode: "L",
                  PageNo: 1,
                  PageSize: 10000,
                  CompanyId: CompanyID,
                )));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      Outsource,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Card(
                    margin: EdgeInsets.symmetric(horizontal: 10),
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
                          Icon(
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

  void _omPurchaseBillTODResponseState(PurchaseBillTODResponseState state) {
    arr_ALL_Name_ID_For_TOD.clear();
    if (state.response.details.length != 0) {
      for (var i = 0; i < state.response.details.length; i++) {
        ALL_Name_ID categoryResponse123 = ALL_Name_ID();
        categoryResponse123.Name = state.response.details[i].stateName;
        categoryResponse123.pkID = state.response.details[i].stateCode;
        arr_ALL_Name_ID_For_TOD.add(categoryResponse123);
      }
    }

    showcustomdialogWithID(
        values: arr_ALL_Name_ID_For_TOD,
        context1: context,
        controller: edt_TODName,
        controllerID: edt_TODID,
        lable: "Termination Of delivery");
  }

  void _OnINQ_QT_SO_NO_Response(
      SalesBill_INQ_QT_SO_NO_ListResponseState state) {
    arr_ALL_Name_ID_For_INQ_QT_SO_List.clear();

    if (state.response.details.length != 0) {
      for (int i = 0; i < state.response.details.length; i++) {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = state.response.details[i].orderNo;
        all_name_id.isChecked = false;
        arr_ALL_Name_ID_For_INQ_QT_SO_List.add(all_name_id);
      }
    }
  }

  Widget _ModuleDropDown(BuildContext context) {
    return InkWell(
      onTap: () {
        if (edt_customerName.text != "") {
          if (arr_ALL_Name_ID_For_INQ_QT_SO_List.length != 0) {
            navigateTo(context, ModuleNoListScreen.routeName,
                    arguments: AddModuleNoScreenArguments(
                        arr_ALL_Name_ID_For_INQ_QT_SO_List,
                        edt_select_salesBill.text))
                .then((value) {
              setState(() {
                arr_ALL_Name_ID_For_INQ_QT_SO_Filter_List = value;

                print("7upyyt" +
                    arr_ALL_Name_ID_For_INQ_QT_SO_Filter_List.length
                        .toString());

                if (arr_ALL_Name_ID_For_INQ_QT_SO_Filter_List.length != 0) {
                  List<String> ModuleNoList = [];
                  for (int i = 0;
                      i < arr_ALL_Name_ID_For_INQ_QT_SO_Filter_List.length;
                      i++) {
                    print("sldsdf" +
                        " Filter InqList : " +
                        arr_ALL_Name_ID_For_INQ_QT_SO_Filter_List[i].Name +
                        " ISChecked : " +
                        arr_ALL_Name_ID_For_INQ_QT_SO_Filter_List[i]
                            .isChecked
                            .toString());
                    ModuleNoList.add(
                        arr_ALL_Name_ID_For_INQ_QT_SO_Filter_List[i].Name);
                    if (ModuleNoList.length != 0) {
                      var stringwe = ModuleNoList.join(',');
                      print("7upTTT7upTTT" + stringwe);
                      _controller_Module_NO.text = stringwe.toString();

                      if (edt_select_salesBill.text == "G.R.N") {
                        _mainBloc.add(
                            MultiNoToProductDetailsFromGrnRequestEvent(
                                "Edit",
                                MultiNoToProductDetailsRequest(
                                    FetchType: "GRN",
                                    No: "," + stringwe.toString() + ",",
                                    CustomerID: edt_customerID.text,
                                    CompanyId: CompanyID.toString())));
                      } else {
                        _mainBloc.add(
                            MultiNoToProductDetailsFromPurchaseOrderRequestEvent(
                                "Edit",
                                MultiNoToProductDetailsRequest(
                                    FetchType: "PurchaseOrder",
                                    No: "," + stringwe.toString() + ",",
                                    CustomerID: edt_customerID.text,
                                    CompanyId: CompanyID.toString())));
                      }
                    }
                  }
                }
              });
            });
          } else {
            showCommonDialogWithSingleOption(
                context, edt_select_salesBill.text + " No. Not Exist !",
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
          createTextLabel("Inq/QT/SO No.", 10.0, 0.0),
          arr_ALL_Name_ID_For_INQ_QT_SO_Filter_List.length != 0
              ? Card(
                  elevation: 10,
                  color: colorWhite,
                  shadowColor: colorPrimary,
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
                                        arr_ALL_Name_ID_For_INQ_QT_SO_Filter_List[
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
                                  arr_ALL_Name_ID_For_INQ_QT_SO_Filter_List
                                      .length,
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
                  elevation: 10,
                  color: colorWhite,
                  shadowColor: colorPrimary,
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
                                contentPadding: EdgeInsets.only(bottom: 7),
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

  Widget CustomDropDownProducts(
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
                if (edt_customerName.text != "") {
                  _mainBloc.add(ProductListRequestEvent(
                      ProductMasterListRequest(
                          ProductID: "0",
                          ListMode: "",
                          SearchKey: "",
                          PageNo: "1",
                          PageSize: "100000",
                          LoginUserID: LoginUserID,
                          CompanyId: CompanyID.toString())));
                } else {
                  showCommonDialogWithSingleOption(
                      context, "Customer name is required To view Product !",
                      positiveButtonTitle: "OK");
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Products",
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
                          edt_ProductName.text != ""
                              ? InkWell(
                                  onTap: () {
                                    edt_ProductName.text = "";
                                    edt_ProductID.text = "0";
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

  void _onProductMainListResponseState(ProductMainListResponseState state) {
    arr_ALL_Name_ID_For_Product.clear();
    if (state.response.details.length != 0) {
      for (var i = 0; i < state.response.details.length; i++) {
        ALL_Name_ID categoryResponse123 = ALL_Name_ID();
        categoryResponse123.Name = state.response.details[i].productName;
        categoryResponse123.pkID = state.response.details[i].pkID;
        arr_ALL_Name_ID_For_Product.add(categoryResponse123);
      }

      if (arr_ALL_Name_ID_For_Product.length != 0) {
        navigateTo(context, VehicleListDropDownScreen.routeName,
                arguments: VehicleListDropDownScreenArgument(
                    arr_ALL_Name_ID_For_Product,
                    "Types Of Product List",
                    "Three Chars To Search Product",
                    "Tap To Enter Product"))
            .then((value) {
          if (value.toString() == "clear") {
            edt_ProductName.text = "";
            edt_ProductID.text = "0";
          } else {
            ALL_Name_ID model = value;
            edt_ProductName.text = model.Name;
            edt_ProductID.text = model.pkID.toString();

            _mainBloc.add(ShortInvoiceAssemblyLoadListRequestEvent(
                model.pkID,
                ShortInvoiceAssemblyLoadRequest(
                    FinishProductID: model.pkID.toString(),
                    CompanyId: CompanyID.toString())));
          }

          setState(() {});
        });
      }
    }
  }

  Widget CustomDropDown(
    String category, {
    TextEditingController controllerForLeft,
    List<ALL_Name_ID> Custom_values1,
    BuildContext context,
    bool enable1 = true,
    Icon icon,
    String title,
    String hintTextvalue,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            title ?? "", // Show title if provided
            style: TextStyle(
              fontSize: 13,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (edt_customerName.text.isNotEmpty) {
              arr_ALL_Name_ID_For_INQ_QT_SO_Filter_List.clear();
              _controller_Module_NO.text = "";

              showcustomdialogWithOnlyName(
                values: Custom_values1,
                context1: context,
                controller: controllerForLeft,
                lable: "Select $category",
              );
            } else {
              showCommonDialogWithSingleOption(
                context,
                "Customer Name is required!",
                positiveButtonTitle: "OK",
              );
            }
          },
          child: Card(
            margin: EdgeInsets.symmetric(horizontal: 10),
            elevation: 8,
            color: Colors.grey[50],
            shadowColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      controllerForLeft.text.isNotEmpty
                          ? controllerForLeft.text
                          : hintTextvalue ?? "Select $category",
                      style: TextStyle(
                        fontSize: 14,
                        color: controllerForLeft.text.isNotEmpty
                            ? Colors.black
                            : colorGrayDark,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: colorGrayDark,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  productDetails() {
    return Container(
        margin: EdgeInsets.all(10),
        child: getCommonButton(baseTheme, () {
          if (edt_customerName.text != "") {
            navigateTo(context, PBProductListScreen.routeName,
                arguments: PBProductListScreenArgument(
                    SalesOrderNo, edt_StateCode.text, edt_HeaderDisc.text));
          } else {
            showCommonDialogWithSingleOption(
                context, "Customer name is required To view Product !",
                positiveButtonTitle: "OK");
          }
        }, "Products",
            width: double.infinity,
            textColor: colorPrimary,
            backGroundColor: colorGreenLight,
            radius: 25.0));
  }

  Future<void> getInquiryProductDetails() async {
    _inquiryProductList.clear();
    List<PurchaseBillTable> temp =
        await OfflineDbHelper.getInstance().getPurchaseBillProduct();
    _inquiryProductList.addAll(temp);
    setState(() {});
  }

  ///-------------------- T&C Start-----------------

  Widget termsAndCondition() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      elevation: 3,
      color: colorPrimary,
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: Colors.white,
          collapsedIconColor: Colors.white,
          title: const Text(
            "Terms & Condition",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          leading: ClipRRect(
            child: Image.asset(
              CREDIT_INFORMATION,
              width: 27,
              color: Colors.white,
            ),
          ),
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(15)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSingleField(
                    "Select Terms & Conditions",
                    CustomDropDownTermsAndConition(
                      "Select Terms & Conditions",
                      enable1: false,
                      icon: const Icon(Icons.arrow_drop_down),
                      controllerVehical: edt_select_termsAndConditionName,
                      vehicalList: arr_ALL_Name_ID_For_Terms_And_Condition,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSingleField("Content", TermsAndCondition()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget CustomDropDownTermsAndConition(
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
                _mainBloc.add(QuotationTermsConditionCallEvent(
                    QuotationTermsConditionRequest(
                        CompanyId: CompanyID.toString(),
                        LoginUserID: LoginUserID)));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    elevation: 8,
                    color: Colors.grey[50],
                    shadowColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Container(
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: 12),
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
                          edt_select_termsAndConditionName.text != ""
                              ? InkWell(
                                  onTap: () {
                                    edt_select_termsAndConditionName.text = "";
                                    edt_select_termsAndConditionId.text = "0";
                                    edt_termsAndCondition.text = "";
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

  void _OnTermsAndConditionResponse(QuotationTermsCondtionResponseState state) {
    arr_ALL_Name_ID_For_Terms_And_Condition.clear();
    if (state.response.details.length != 0) {
      for (var i = 0; i < state.response.details.length; i++) {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = state.response.details[i].tNCHeader;
        all_name_id.pkID = state.response.details[i].pkID;
        all_name_id.Name1 = state.response.details[i].tNCContent;
        arr_ALL_Name_ID_For_Terms_And_Condition.add(all_name_id);
      }

      if (arr_ALL_Name_ID_For_Terms_And_Condition.length != 0) {
        navigateTo(context, VehicleListDropDownScreen.routeName,
                arguments: VehicleListDropDownScreenArgument(
                    arr_ALL_Name_ID_For_Terms_And_Condition,
                    "Types Of T&C",
                    "Three Chars To Search T&C",
                    "Tap To Enter T&C"))
            .then((value) {
          if (value.toString() == "clear") {
            edt_select_termsAndConditionName.text = "";
            edt_select_termsAndConditionId.text = "0";
            edt_termsAndCondition.text = "";
          } else {
            ALL_Name_ID model = value;
            edt_select_termsAndConditionName.text = model.Name;
            edt_select_termsAndConditionId.text = model.pkID.toString();
            edt_termsAndCondition.text = model.Name1.toString();
          }

          setState(() {});
        });
      }
    } else {
      showCommonDialogWithSingleOption(context, "Projects is Empty !",
          positiveButtonTitle: "OK");
    }
  }

  Widget TermsAndCondition() {
    return Container(
        child: Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              margin: EdgeInsets.symmetric(horizontal: 10),
              elevation: 8,
              color: Colors.grey[50],
              shadowColor: Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Container(
                height: 100,
                padding: EdgeInsets.only(left: 10, right: 10),
                width: double.maxFinite,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextField(
                          controller: edt_termsAndCondition,
                          keyboardType: TextInputType.multiline,
                          maxLines: 5,
                          decoration: InputDecoration(
                            counterText: "",
                            hintText: "Tap to enter T&C",
                            contentPadding: EdgeInsets.only(
                                left: 7, top: 15, bottom: 10, right: 7),
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
        )
      ],
    ));
  }

  Widget TransportDetails() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 3,
      color: colorPrimary,
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: Colors.white,
          collapsedIconColor: Colors.white,
          title: Text(
            "Transport Details",
            style: const TextStyle(color: Colors.white, fontSize: 17),
          ),
          leading: ClipRRect(
            child: Image.asset(BASIC_INFORMATION, width: 28),
          ),
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(15),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              child: Column(
                children: [
                  _buildRowWithTwoFields(
                    leftLabel: "Mode Of Transport",
                    rightLabel: "Transporter Name",
                    leftWidget: CustomDropDown1(
                      "Mode Of Transport",
                      enable1: false,
                      hintTextvalue: "Tap to select",
                      icon: const Icon(Icons.arrow_drop_down),
                      controllerForLeft: _controller_mode_of_transfer,
                      Custom_values1: arr_ALL_Name_ID_For_ModeOfTransfer,
                    ),
                    rightWidget: createTextFormField(
                      _controller_Transporter,
                      "Transporter Name",
                      keyboardInput: TextInputType.text,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildRowWithTwoFields(
                    leftLabel: "LR No./DC No.",
                    rightLabel: "LR Date/DC Date",
                    leftWidget: createTextFormField(
                      _controller_LR_NO,
                      "LR No./DC No.",
                    ),
                    rightWidget: _buildLRDate(),
                  ),
                  const SizedBox(height: 8),
                  _buildSingleField(
                      "Remarks",
                      createTextFormField(
                        _controller_Remarks,
                        "Tap to enter remarks",
                        minLines: 2,
                        maxLines: 5,
                        keyboardInput: TextInputType.text,
                      )),
                  const SizedBox(height: 8),
                  _buildSingleField(
                      "Vehicle No.",
                      createTextFormField(
                        _controller_vihical_no,
                        "Vehicle No.",
                        minLines: 2,
                        maxLines: 2,
                        keyboardInput: TextInputType.text,
                      )),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRowWithTwoFields({
    String leftLabel,
    String rightLabel,
    Widget leftWidget,
    Widget rightWidget,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: createTextLabel(leftLabel, 10.0, 0.0)),
            const SizedBox(width: 10),
            Expanded(child: createTextLabel(rightLabel, 10.0, 0.0)),
          ],
        ),
        Row(
          children: [
            Expanded(child: leftWidget),
            const SizedBox(width: 10),
            Expanded(child: rightWidget),
          ],
        ),
      ],
    );
  }

  Widget _buildSingleField(String label, Widget widget) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        createTextLabel(label, 10.0, 0.0),
        widget,
      ],
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

  Widget _buildLRDate() {
    return InkWell(
      onTap: () {
        _selectLRDate(
            context, _controller_LR_date, _controller_LR_date_Reveres);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /*  SizedBox(
            height: 5,
          ),*/
          Card(
            elevation: 10,
            color: colorWhite,
            shadowColor: colorPrimary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              height: 48,
              padding: EdgeInsets.only(left: 20, right: 20),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _controller_LR_date.text == null ||
                              _controller_LR_date.text == ""
                          ? "DD-MM-YYYY"
                          : _controller_LR_date.text,
                      style: baseTheme.textTheme.headline3.copyWith(
                          color: _controller_LR_date.text == null ||
                                  _controller_LR_date.text == ""
                              ? colorGrayDark
                              : colorBlack,
                          fontSize: dateFontSize),
                    ),
                  ),
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 17,
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

  save() {
    return // Save
        Container(
            margin: EdgeInsets.only(left: 8, right: 8),
            child: getCommonButton(
              baseTheme,
              () async {
                if (edt_invoiceDate.text != "") {
                  if (edt_customerName.text != "") {
                    if (edt_bankName.text != "") {
                      List<PurchaseBillTable> temp =
                          await OfflineDbHelper.getInstance()
                              .getPurchaseBillProduct();

                      if (temp.length != 0) {
                        showCommonDialogWithTwoOptions(context,
                            "Are you sure you want to Save this record ?",
                            negativeButtonTitle: "No",
                            positiveButtonTitle: "Yes",
                            onTapOfPositiveButton: () async {
                          Navigator.of(context).pop();

                          if (SalesOrderNo != '') {
                            _mainBloc.add(PurchaseBillDetailsDeleteCallEvent(
                                PurchaseBillDetailsListRequest(
                                    InvoiceNo: SalesOrderNo,
                                    CompanyId: CompanyID.toString())));
                          } else {
                            print("Add");
                          }

                          HeaderDisAmnt = edt_HeaderDisc.text.isNotEmpty
                              ? double.parse(edt_HeaderDisc.text)
                              : 0.00;

                          List<PurchaseBillTable> TempproductList1 =
                              PurchaseBillOrderHeaderDiscountCalculation
                                  .txtHeadDiscount_WithZero(
                                      temp,
                                      HeaderDisAmnt,
                                      _offlineLoggedInData.details[0].stateCode
                                          .toString(),
                                      edt_StateCode.text.toString());

                          List<PurchaseBillTable> TempproductList =
                              PurchaseBillOrderHeaderDiscountCalculation
                                  .txtHeadDiscount_TextChanged(
                                      TempproductList1,
                                      HeaderDisAmnt,
                                      _offlineLoggedInData.details[0].stateCode
                                          .toString(),
                                      edt_StateCode.text.toString());

                          for (int i = 0; i < temp.length; i++) {
                            print("productList" +
                                " AmountFromProductList : " +
                                temp[i].DiscountPer.toString() +
                                " NetAmountFromProductList : " +
                                temp[i].DiscountAmt.toString() +
                                " NetRate : " +
                                temp[i].NetRate.toString() +
                                " BasicAmount : " +
                                temp[i].Amount.toString() +
                                " NetAmnount : " +
                                temp[i].NetAmt.toString());
                          }

                          for (int i = 0; i < TempproductList1.length; i++) {
                            print("TempproductList1" +
                                " AmountCalculation : " +
                                TempproductList1[i].DiscountPer.toString() +
                                " NetAmountCalculation : " +
                                TempproductList1[i].DiscountAmt.toString() +
                                " NetRate : " +
                                TempproductList1[i].NetRate.toString() +
                                " BasicAmount : " +
                                TempproductList1[i].Amount.toString() +
                                " NetAmount : " +
                                TempproductList1[i].NetAmt.toString());
                          }

                          for (int i = 0; i < TempproductList.length; i++) {
                            print("TempproductList" +
                                " AmountCalculation : " +
                                TempproductList[i].DiscountPer.toString() +
                                " NetAmountCalculation : " +
                                TempproductList[i].DiscountAmt.toString() +
                                " NetRate : " +
                                TempproductList[i].NetRate.toString() +
                                " BasicAmount : " +
                                TempproductList[i].Amount.toString() +
                                " NetAmount : " +
                                TempproductList[i].NetAmt.toString());
                          }

                          List<double> finalPrice =
                              UpdateHeaderDiscountCalculationNew(
                                  TempproductList);

                          _mainBloc.add(PurchaseBillAddUpdateRequestEvent(
                            context,
                            PurchaseBillAddUpdateRequest(
                              pkID: pkID.toString(),
                              InvoiceNo: edt_invoiceNo.text,
                              InvoiceDate: edt_rev_invoiceDate.text,
                              FixedLedgerID: edt_PurchaseACID.text,
                              CustomerID: edt_customerID.text,
                              LocationID: "0",
                              BankID: edt_bankID.text,
                              TerminationOfDeliery: edt_TODID.text,
                              TermsCondition: edt_termsAndCondition.text,
                              BillNo: "",
                              BasicAmt: finalPrice[0].toStringAsFixed(2),
                              DiscountPer: addditionalCharges.DisPer == null
                                  ? "0.00"
                                  : addditionalCharges.DisPer,
                              DiscountAmt: addditionalCharges.DiscountAmt,
                              SGSTAmt: finalPrice[4].toStringAsFixed(2),
                              CGSTAmt: finalPrice[3].toStringAsFixed(2),
                              IGSTAmt: finalPrice[5].toStringAsFixed(2),
                              ROffAmt: finalPrice[18].toStringAsFixed(2),
                              ChargeID1: addditionalCharges.ChargeID1,
                              ChargeAmt1: addditionalCharges.ChargeAmt1,
                              ChargeBasicAmt1:
                                  addditionalCharges.ChargeBasicAmt1,
                              ChargeGSTAmt1: addditionalCharges.ChargeGSTAmt1,
                              ChargeID2: addditionalCharges.ChargeID2,
                              ChargeAmt2: addditionalCharges.ChargeAmt2,
                              ChargeBasicAmt2:
                                  addditionalCharges.ChargeBasicAmt2,
                              ChargeGSTAmt2: addditionalCharges.ChargeGSTAmt2,
                              ChargeID3: addditionalCharges.ChargeID3,
                              ChargeAmt3: addditionalCharges.ChargeAmt3,
                              ChargeBasicAmt3:
                                  addditionalCharges.ChargeBasicAmt3,
                              ChargeGSTAmt3: addditionalCharges.ChargeGSTAmt3,
                              ChargeID4: addditionalCharges.ChargeID4,
                              ChargeAmt4: addditionalCharges.ChargeAmt4,
                              ChargeBasicAmt4:
                                  addditionalCharges.ChargeBasicAmt4,
                              ChargeGSTAmt4: addditionalCharges.ChargeGSTAmt4,
                              ChargeID5: addditionalCharges.ChargeID5,
                              ChargeAmt5: addditionalCharges.ChargeAmt5,
                              ChargeBasicAmt5:
                                  addditionalCharges.ChargeBasicAmt5,
                              ChargeGSTAmt5: addditionalCharges.ChargeGSTAmt5,
                              ModeOfTransport:
                                  _controller_mode_of_transfer.text,
                              TransporterName: _controller_Transporter.text,
                              VehicleNo: _controller_vihical_no.text,
                              LRNo: _controller_LR_NO.text,
                              LRDate: _controller_LR_date_Reveres.text,
                              TransportRemark: _controller_Remarks.text,
                              NetAmt: finalPrice[17].toStringAsFixed(2),
                              ForCoustmerID: "0",
                              CRDays: edt_serialNo.text,
                              DueDate: edt_rev_dispatchDate.text,
                              CurrencyName: "",
                              CurrencySymbol: "",
                              ExchangeRate: "0.00",
                              ProjectName: edt_projectName.text,
                              LoginUserID: LoginUserID,
                              CompanyId: CompanyID.toString(),
                            ),
                          ));
                        });
                      } else {
                        showCommonDialogWithSingleOption(
                            context, "ProductDetails is required !",
                            positiveButtonTitle: "OK",
                            onTapOfPositiveButton: () {
                          Navigator.pop(context);
                        });
                      }
                    } else {
                      showCommonDialogWithSingleOption(
                          context, "Bank Name is required !",
                          positiveButtonTitle: "OK", onTapOfPositiveButton: () {
                        Navigator.pop(context);
                      });
                    }
                  } else {
                    showCommonDialogWithSingleOption(
                        context, "CustomerName is required !",
                        positiveButtonTitle: "OK", onTapOfPositiveButton: () {
                      Navigator.pop(context);
                    });
                  }
                } else {
                  showCommonDialogWithSingleOption(
                      context, "SaleOrder date is required !",
                      positiveButtonTitle: "OK", onTapOfPositiveButton: () {
                    Navigator.pop(context);
                  });
                }
              },
              "Save",
              backGroundColor: Color(0xff362d8b),
              radius: 18,
            ));
  }

  List<double> UpdateHeaderDiscountCalculation(
      List<PurchaseBillTable> tempproductList,
      List<GenericAddditionalCharges> quotationOtherChargesListResponse1) {
    if (tempproductList != null) {
      ///From OtherCharge DropDown API
      String _otherChargeTaxTypeController1 = "";
      String _otherChargeTaxTypeController2 = "";
      String _otherChargeTaxTypeController3 = "";
      String _otherChargeTaxTypeController4 = "";
      String _otherChargeTaxTypeController5 = "";

      String _otherChargeBeForeGSTController1 = "";
      String _otherChargeBeForeGSTController2 = "";
      String _otherChargeBeForeGSTController3 = "";
      String _otherChargeBeForeGSTController4 = "";
      String _otherChargeBeForeGSTController5 = "";

      String _otherChargeGSTPerController1 = "";
      String _otherChargeGSTPerController2 = "";
      String _otherChargeGSTPerController3 = "";
      String _otherChargeGSTPerController4 = "";
      String _otherChargeGSTPerController5 = "";

      /// From GenericAddtionalCharge DB Table
      String _otherChargeIDController1 = "";
      String _otherChargeIDController2 = "";
      String _otherChargeIDController3 = "";
      String _otherChargeIDController4 = "";
      String _otherChargeIDController5 = "";

      String _otherChargeNameController1 = "";
      String _otherChargeNameController2 = "";
      String _otherChargeNameController3 = "";
      String _otherChargeNameController4 = "";
      String _otherChargeNameController5 = "";

      String _otherAmount1 = "";
      String _otherAmount2 = "";
      String _otherAmount3 = "";
      String _otherAmount4 = "";
      String _otherAmount5 = "";

      double Tot_BasicAmount = 0.00;
      double Tot_GSTAmt = 0.00;
      double Tot_CGSTAmt = 0.00;
      double Tot_SGSTAmt = 0.00;
      double Tot_IGSTAmt = 0.00;

      double Tot_NetAmt = 0.00;
      Tot_otherChargeWithTax = 0.0;
      Tot_otherChargeExcludeTax = 0.0;
      List<GenericAddditionalCharges> quotationOtherChargesListResponse =
          quotationOtherChargesListResponse1;

      _otherChargeIDController1 =
          quotationOtherChargesListResponse[0].ChargeID1;
      _otherChargeIDController2 =
          quotationOtherChargesListResponse[0].ChargeID2;
      _otherChargeIDController3 =
          quotationOtherChargesListResponse[0].ChargeID3;
      _otherChargeIDController4 =
          quotationOtherChargesListResponse[0].ChargeID4;
      _otherChargeIDController5 =
          quotationOtherChargesListResponse[0].ChargeID5;

      _otherChargeNameController1 =
          quotationOtherChargesListResponse[0].ChargeName1;
      _otherChargeNameController2 =
          quotationOtherChargesListResponse[0].ChargeName2;
      _otherChargeNameController3 =
          quotationOtherChargesListResponse[0].ChargeName3;
      _otherChargeNameController4 =
          quotationOtherChargesListResponse[0].ChargeName4;
      _otherChargeNameController5 =
          quotationOtherChargesListResponse[0].ChargeName5;

      _otherAmount1 = quotationOtherChargesListResponse[0].ChargeAmt1;
      _otherAmount2 = quotationOtherChargesListResponse[0].ChargeAmt2;
      _otherAmount3 = quotationOtherChargesListResponse[0].ChargeAmt3;
      _otherAmount4 = quotationOtherChargesListResponse[0].ChargeAmt4;
      _otherAmount5 = quotationOtherChargesListResponse[0].ChargeAmt5;

      // productList.clear();

      for (int i = 0; i < tempproductList.length; i++) {
        print("Amount" +
            tempproductList[i].Amount.toString() +
            "NetAmount : " +
            tempproductList[i].Amount.toString());
        // productList.add(tempproductList[i]);
        Tot_BasicAmount += tempproductList[i].Amount;
        Tot_otherChargeWithTax = 0.00;

        ///Before Gst
        Tot_GSTAmt += tempproductList[i].AddTaxAmt;
        Tot_CGSTAmt += tempproductList[i].CGSTAmt;
        Tot_SGSTAmt += tempproductList[i].SGSTAmt;
        Tot_IGSTAmt += tempproductList[i].IGSTAmt;

        Tot_otherChargeExcludeTax = 0.00;

        ///AFTER gst
        Tot_NetAmt += tempproductList[i].NetAmt;
      }

      print("FinalAmount" +
          " BasicAmount : " +
          Tot_BasicAmount.toString() +
          " TotalGST Amnt : " +
          Tot_GSTAmt.toString() +
          " Tot_NetAmt : " +
          Tot_NetAmt.toString());

      HeaderDisAmnt = edt_HeaderDisc.text.isNotEmpty
          ? double.parse(edt_HeaderDisc.text)
          : 0.00;

      List<double> hdnOthChrgGST1hdnOthChrgBasic1 = [],
          hdnOthChrgGST1hdnOthChrgBasic2 = [],
          hdnOthChrgGST1hdnOthChrgBasic3 = [],
          hdnOthChrgGST1hdnOthChrgBasic4 = [],
          hdnOthChrgGST1hdnOthChrgBasic5 = [];

      Tot_otherChargeWithTax = 0.00;

      for (int i = 0; i < arrGenericOtheCharge.length; i++) {
        print("TAXXXXX" + arrGenericOtheCharge[i].chargeName);
        if (_otherChargeIDController1 ==
            arrGenericOtheCharge[i].pkId.toString()) {
          _otherChargeTaxTypeController1 =
              arrGenericOtheCharge[i].taxType.toString();
          _otherChargeBeForeGSTController1 =
              arrGenericOtheCharge[i].beforeGST.toString();

          _otherChargeGSTPerController1 =
              arrGenericOtheCharge[i].gSTPer.toString();
        }

        if (_otherChargeIDController2 ==
            arrGenericOtheCharge[i].pkId.toString()) {
          _otherChargeTaxTypeController2 =
              arrGenericOtheCharge[i].taxType.toString();
          _otherChargeBeForeGSTController2 =
              arrGenericOtheCharge[i].beforeGST.toString();
          _otherChargeGSTPerController2 =
              arrGenericOtheCharge[i].gSTPer.toString();
        }
        if (_otherChargeIDController3 ==
            arrGenericOtheCharge[i].pkId.toString()) {
          _otherChargeTaxTypeController3 =
              arrGenericOtheCharge[i].taxType.toString();
          _otherChargeBeForeGSTController3 =
              arrGenericOtheCharge[i].beforeGST.toString();
          _otherChargeGSTPerController3 =
              arrGenericOtheCharge[i].gSTPer.toString();
        }
        if (_otherChargeIDController4 ==
            arrGenericOtheCharge[i].pkId.toString()) {
          _otherChargeTaxTypeController4 =
              arrGenericOtheCharge[i].taxType.toString();
          _otherChargeBeForeGSTController4 =
              arrGenericOtheCharge[i].beforeGST.toString();
          _otherChargeGSTPerController4 =
              arrGenericOtheCharge[i].gSTPer.toString();
        }
        if (_otherChargeIDController5 ==
            arrGenericOtheCharge[i].pkId.toString()) {
          _otherChargeTaxTypeController5 =
              arrGenericOtheCharge[i].taxType.toString();
          _otherChargeBeForeGSTController5 =
              arrGenericOtheCharge[i].beforeGST.toString();
          _otherChargeGSTPerController5 =
              arrGenericOtheCharge[i].gSTPer.toString();
        }
      }

      if (_otherChargeNameController1.isNotEmpty) {
        if (_otherChargeNameController1.toString() != "null") {
          print("AA1" + _otherChargeBeForeGSTController1.toString());

          hdnOthChrgGST1hdnOthChrgBasic1 =
              AddtionalCharges.txtOthChrgAmt1_TextChanged(
                  _otherChargeIDController1.isNotEmpty
                      ? int.parse(_otherChargeIDController1)
                      : 0,
                  _otherAmount1.isNotEmpty ? double.parse(_otherAmount1) : 0.00,
                  _otherChargeGSTPerController1.isNotEmpty
                      ? double.parse(_otherChargeGSTPerController1)
                      : 0.00,
                  _otherChargeTaxTypeController1.isNotEmpty
                      ? int.parse(
                          _otherChargeTaxTypeController1.toString() == "0.00"
                              ? "0"
                              : _otherChargeTaxTypeController1.toString())
                      : 0,
                  _otherChargeBeForeGSTController1.toString() == "true"
                      ? true
                      : false);

          if (_otherChargeBeForeGSTController1 == "true") {
            Tot_otherChargeWithTax += hdnOthChrgGST1hdnOthChrgBasic1[1];
          } else {
            Tot_otherChargeExcludeTax += hdnOthChrgGST1hdnOthChrgBasic1[1];
          }
        } else {
          _otherChargeNameController1 = "";
        }
      }
      if (_otherChargeNameController2.isNotEmpty) {
        if (_otherChargeNameController2.toString() != "null") {
          hdnOthChrgGST1hdnOthChrgBasic2 =
              AddtionalCharges.txtOthChrgAmt1_TextChanged(
                  _otherChargeIDController2.isNotEmpty
                      ? int.parse(_otherChargeIDController2)
                      : 0,
                  _otherAmount2.isNotEmpty ? double.parse(_otherAmount2) : 0.00,
                  _otherChargeGSTPerController2.isNotEmpty
                      ? double.parse(_otherChargeGSTPerController2)
                      : 0.00,
                  _otherChargeTaxTypeController2.isNotEmpty
                      ? int.parse(
                          _otherChargeTaxTypeController2.toString() == "0.00"
                              ? "0"
                              : _otherChargeTaxTypeController2.toString())
                      : 0,
                  _otherChargeBeForeGSTController2.toString() == "true"
                      ? true
                      : false);

          if (_otherChargeBeForeGSTController2 == "true") {
            Tot_otherChargeWithTax += hdnOthChrgGST1hdnOthChrgBasic2[1];
          } else {
            Tot_otherChargeExcludeTax += hdnOthChrgGST1hdnOthChrgBasic2[1];
          }
        } else {
          _otherChargeNameController2 = "";
        }
      }

      print("ds9980" + _otherChargeNameController3.toString());
      if (_otherChargeNameController3.isNotEmpty) {
        if (_otherChargeNameController3.toString() != "null") {
          hdnOthChrgGST1hdnOthChrgBasic3 =
              AddtionalCharges.txtOthChrgAmt1_TextChanged(
                  _otherChargeIDController3.isNotEmpty
                      ? int.parse(_otherChargeIDController3)
                      : 0,
                  _otherAmount3.isNotEmpty ? double.parse(_otherAmount3) : 0.00,
                  _otherChargeGSTPerController3.isNotEmpty
                      ? double.parse(_otherChargeGSTPerController3)
                      : 0.00,
                  _otherChargeTaxTypeController3.isNotEmpty
                      ? int.parse(
                          _otherChargeTaxTypeController3.toString() == "0.00"
                              ? "0"
                              : _otherChargeTaxTypeController3.toString())
                      : 0,
                  _otherChargeBeForeGSTController3.toString() == "true"
                      ? true
                      : false);
          if (_otherChargeBeForeGSTController3 == "true") {
            Tot_otherChargeWithTax += hdnOthChrgGST1hdnOthChrgBasic3[1];
          } else {
            Tot_otherChargeExcludeTax += hdnOthChrgGST1hdnOthChrgBasic3[1];
          }
        } else {
          _otherChargeNameController3 = "";
        }
      }

      if (_otherChargeNameController4.isNotEmpty) {
        if (_otherChargeNameController4.toString() != "null") {
          hdnOthChrgGST1hdnOthChrgBasic4 =
              AddtionalCharges.txtOthChrgAmt1_TextChanged(
                  _otherChargeIDController4.isNotEmpty
                      ? int.parse(_otherChargeIDController4)
                      : 0,
                  _otherAmount4.isNotEmpty ? double.parse(_otherAmount4) : 0.00,
                  _otherChargeGSTPerController4.isNotEmpty
                      ? double.parse(_otherChargeGSTPerController4)
                      : 0.00,
                  _otherChargeTaxTypeController4.isNotEmpty
                      ? int.parse(
                          _otherChargeTaxTypeController4.toString() == "0.00"
                              ? "0"
                              : _otherChargeTaxTypeController4.toString())
                      : 0,
                  _otherChargeBeForeGSTController4.toString() == "true"
                      ? true
                      : false);
          if (_otherChargeBeForeGSTController4 == "true") {
            Tot_otherChargeWithTax += hdnOthChrgGST1hdnOthChrgBasic4[1];
          } else {
            Tot_otherChargeExcludeTax += hdnOthChrgGST1hdnOthChrgBasic4[1];
          }
        } else {
          _otherChargeNameController4 = "";
        }
      }

      if (_otherChargeNameController5.isNotEmpty) {
        if (_otherChargeNameController5.toString() != "null") {
          hdnOthChrgGST1hdnOthChrgBasic5 =
              AddtionalCharges.txtOthChrgAmt1_TextChanged(
                  _otherChargeIDController5.isNotEmpty
                      ? int.parse(_otherChargeIDController5)
                      : 0,
                  _otherAmount5.isNotEmpty ? double.parse(_otherAmount5) : 0.00,
                  _otherChargeGSTPerController5.isNotEmpty
                      ? double.parse(_otherChargeGSTPerController5)
                      : 0.00,
                  _otherChargeTaxTypeController5.isNotEmpty
                      ? int.parse(
                          _otherChargeTaxTypeController5.toString() == "0.00"
                              ? "0"
                              : _otherChargeTaxTypeController5.toString())
                      : 0,
                  _otherChargeBeForeGSTController5.toString() == "true"
                      ? true
                      : false);
          if (_otherChargeBeForeGSTController5 == "true") {
            Tot_otherChargeWithTax += hdnOthChrgGST1hdnOthChrgBasic5[1];
          } else {
            Tot_otherChargeExcludeTax += hdnOthChrgGST1hdnOthChrgBasic5[1];
          }
        } else {
          _otherChargeNameController5 = "";
        }
      }

      double otherChargeGstAmnt1 = hdnOthChrgGST1hdnOthChrgBasic1.length != 0
          ? hdnOthChrgGST1hdnOthChrgBasic1[0]
          : 0.00;
      double otherChargeGstBasicAmnt1 =
          hdnOthChrgGST1hdnOthChrgBasic1.length != 0
              ? hdnOthChrgGST1hdnOthChrgBasic1[1]
              : 0.00;
      double otherChargeGstAmnt2 = hdnOthChrgGST1hdnOthChrgBasic2.length != 0
          ? hdnOthChrgGST1hdnOthChrgBasic2[0]
          : 0.00;
      double otherChargeGstBasicAmnt2 =
          hdnOthChrgGST1hdnOthChrgBasic2.length != 0
              ? hdnOthChrgGST1hdnOthChrgBasic2[1]
              : 0.00;
      double otherChargeGstAmnt3 = hdnOthChrgGST1hdnOthChrgBasic3.length != 0
          ? hdnOthChrgGST1hdnOthChrgBasic3[0]
          : 0.00;
      double otherChargeGstBasicAmnt3 =
          hdnOthChrgGST1hdnOthChrgBasic3.length != 0
              ? hdnOthChrgGST1hdnOthChrgBasic3[1]
              : 0.00;
      double otherChargeGstAmnt4 = hdnOthChrgGST1hdnOthChrgBasic4.length != 0
          ? hdnOthChrgGST1hdnOthChrgBasic4[0]
          : 0.00;
      double otherChargeGstBasicAmnt4 =
          hdnOthChrgGST1hdnOthChrgBasic4.length != 0
              ? hdnOthChrgGST1hdnOthChrgBasic4[1]
              : 0.00;

      double otherChargeGstAmnt5 = hdnOthChrgGST1hdnOthChrgBasic5.length != 0
          ? hdnOthChrgGST1hdnOthChrgBasic5[0]
          : 0.00;
      double otherChargeGstBasicAmnt5 =
          hdnOthChrgGST1hdnOthChrgBasic5.length != 0
              ? hdnOthChrgGST1hdnOthChrgBasic5[1]
              : 0.00;

      List<double> TempproductList =
          SalesOrderHeaderDiscountCalculation.funCalculateTotal(
              otherChargeGstAmnt1,
              otherChargeGstAmnt2,
              otherChargeGstAmnt3,
              otherChargeGstAmnt4,
              otherChargeGstAmnt5,
              otherChargeGstBasicAmnt1,
              otherChargeGstBasicAmnt2,
              otherChargeGstBasicAmnt3,
              otherChargeGstBasicAmnt4,
              otherChargeGstBasicAmnt5,
              Tot_CGSTAmt,
              Tot_SGSTAmt,
              Tot_IGSTAmt,
              Tot_BasicAmount,
              Tot_NetAmt,
              HeaderDisAmnt,
              Tot_otherChargeWithTax,
              Tot_otherChargeExcludeTax);

      double totalGstController = 0.00,
          netAmountController = 0.00,
          roundOFController = 0.00;
      totalGstController = TempproductList[2];
      netAmountController = TempproductList[4];
      roundOFController = TempproductList[5];

      List<double> finalcalculation = [
        /*0*/ Tot_BasicAmount,
        /*1*/ Tot_otherChargeWithTax,
        /*2*/ Tot_otherChargeExcludeTax,
        /*3*/ Tot_CGSTAmt,
        /*4*/ Tot_SGSTAmt,
        /*5*/ Tot_IGSTAmt,
        /*6*/ otherChargeGstBasicAmnt1,
        /*7*/ otherChargeGstBasicAmnt2,
        /*8*/ otherChargeGstBasicAmnt3,
        /*9*/ otherChargeGstBasicAmnt4,
        /*10*/ otherChargeGstBasicAmnt5,
        /*11*/ otherChargeGstAmnt1,
        /*12*/ otherChargeGstAmnt2,
        /*13*/ otherChargeGstAmnt3,
        /*14*/ otherChargeGstAmnt4,
        /*15*/ otherChargeGstAmnt5,
        /*16*/ totalGstController,
        /*17*/ netAmountController,
        /*18*/ roundOFController
      ];

      return finalcalculation;
    }
  }

  List<double> UpdateHeaderDiscountCalculationNew(
      List<PurchaseBillTable> tempproductList) {
    if (tempproductList != null) {
      String _otherChargeTaxTypeController1 = "";
      String _otherChargeTaxTypeController2 = "";
      String _otherChargeTaxTypeController3 = "";
      String _otherChargeTaxTypeController4 = "";
      String _otherChargeTaxTypeController5 = "";

      String _otherChargeBeForeGSTController1 = "";
      String _otherChargeBeForeGSTController2 = "";
      String _otherChargeBeForeGSTController3 = "";
      String _otherChargeBeForeGSTController4 = "";
      String _otherChargeBeForeGSTController5 = "";

      String _otherChargeGSTPerController1 = "";
      String _otherChargeGSTPerController2 = "";
      String _otherChargeGSTPerController3 = "";
      String _otherChargeGSTPerController4 = "";
      String _otherChargeGSTPerController5 = "";

      /// From GenericAddtionalCharge DB Table
      String _otherChargeIDController1 = "";
      String _otherChargeIDController2 = "";
      String _otherChargeIDController3 = "";
      String _otherChargeIDController4 = "";
      String _otherChargeIDController5 = "";

      String _otherChargeNameController1 = "";
      String _otherChargeNameController2 = "";
      String _otherChargeNameController3 = "";
      String _otherChargeNameController4 = "";
      String _otherChargeNameController5 = "";

      String _otherAmount1 = "";
      String _otherAmount2 = "";
      String _otherAmount3 = "";
      String _otherAmount4 = "";
      String _otherAmount5 = "";

      Tot_otherChargeWithTax = 0.0;
      Tot_otherChargeExcludeTax = 0.0;

      double Tot_BasicAmount = 0.00;
      double Tot_GSTAmt = 0.00;
      double Tot_CGSTAmt = 0.00;
      double Tot_SGSTAmt = 0.00;
      double Tot_IGSTAmt = 0.00;

      double Tot_NetAmt = 0.00;
      // productList.clear();

      for (int i = 0; i < tempproductList.length; i++) {
        print("Amount" +
            tempproductList[i].Amount.toString() +
            "NetAmount : " +
            tempproductList[i].Amount.toString());
        // productList.add(tempproductList[i]);
        Tot_BasicAmount += tempproductList[i].Amount;
        Tot_otherChargeWithTax = 0.00;

        ///Before Gst
        Tot_GSTAmt += tempproductList[i].AddTaxAmt;
        Tot_CGSTAmt += tempproductList[i].CGSTAmt;
        Tot_SGSTAmt += tempproductList[i].SGSTAmt;
        Tot_IGSTAmt += tempproductList[i].IGSTAmt;

        Tot_otherChargeExcludeTax = 0.00;

        ///AFTER gst
        Tot_NetAmt += tempproductList[i].NetAmt;
      }

      print("FinalAmount" +
          " BasicAmount : " +
          Tot_BasicAmount.toString() +
          " TotalGST Amnt : " +
          Tot_GSTAmt.toString() +
          " Tot_NetAmt : " +
          Tot_NetAmt.toString());
      HeaderDisAmnt = addditionalCharges.DiscountAmt.isNotEmpty
          ? double.parse(addditionalCharges.DiscountAmt)
          : 0.00;

      List<double> hdnOthChrgGST1hdnOthChrgBasic1 = [],
          hdnOthChrgGST1hdnOthChrgBasic2 = [],
          hdnOthChrgGST1hdnOthChrgBasic3 = [],
          hdnOthChrgGST1hdnOthChrgBasic4 = [],
          hdnOthChrgGST1hdnOthChrgBasic5 = [];

      Tot_otherChargeWithTax = 0.00;

      if (addditionalCharges.ChargeName1.isNotEmpty) {
        if (addditionalCharges.ChargeName1.toString() != "null") {
          print("AA1" + _otherChargeBeForeGSTController1.toString());

          hdnOthChrgGST1hdnOthChrgBasic1 =
              AddtionalCharges.txtOthChrgAmt1_TextChanged(
                  addditionalCharges.ChargeID1.isNotEmpty
                      ? int.parse(addditionalCharges.ChargeID1)
                      : 0,
                  addditionalCharges.ChargeAmt1.isNotEmpty
                      ? double.parse(addditionalCharges.ChargeAmt1)
                      : 0.00,
                  addditionalCharges.ChargeGstPer1.isNotEmpty
                      ? double.parse(addditionalCharges.ChargeGstPer1)
                      : 0.00,
                  addditionalCharges.ChargeTaxType1.isNotEmpty
                      ? int.parse(
                          addditionalCharges.ChargeTaxType1.toString() == "0.00"
                              ? "0"
                              : addditionalCharges.ChargeTaxType1.toString())
                      : 0,
                  addditionalCharges.ChargeIsBeforGst1.toString() == "true"
                      ? true
                      : false);

          if (addditionalCharges.ChargeIsBeforGst1 == "true") {
            Tot_otherChargeWithTax += hdnOthChrgGST1hdnOthChrgBasic1[1];
          } else {
            Tot_otherChargeExcludeTax += hdnOthChrgGST1hdnOthChrgBasic1[1];
          }
        } else {
          _otherChargeNameController1 = "";
        }
      }

      if (addditionalCharges.ChargeName2.isNotEmpty) {
        if (addditionalCharges.ChargeName2.toString() != "null") {
          print("AA1" + _otherChargeBeForeGSTController2.toString());

          hdnOthChrgGST1hdnOthChrgBasic2 =
              AddtionalCharges.txtOthChrgAmt1_TextChanged(
                  addditionalCharges.ChargeID2.isNotEmpty
                      ? int.parse(addditionalCharges.ChargeID2)
                      : 0,
                  addditionalCharges.ChargeAmt2.isNotEmpty
                      ? double.parse(addditionalCharges.ChargeAmt2)
                      : 0.00,
                  addditionalCharges.ChargeGstPer2.isNotEmpty
                      ? double.parse(addditionalCharges.ChargeGstPer2)
                      : 0.00,
                  addditionalCharges.ChargeTaxType2.isNotEmpty
                      ? int.parse(
                          addditionalCharges.ChargeTaxType2.toString() == "0.00"
                              ? "0"
                              : addditionalCharges.ChargeTaxType2.toString())
                      : 0,
                  addditionalCharges.ChargeIsBeforGst2.toString() == "true"
                      ? true
                      : false);

          if (addditionalCharges.ChargeIsBeforGst2 == "true") {
            Tot_otherChargeWithTax += hdnOthChrgGST1hdnOthChrgBasic2[1];
          } else {
            Tot_otherChargeExcludeTax += hdnOthChrgGST1hdnOthChrgBasic2[1];
          }
        } else {
          _otherChargeNameController2 = "";
        }
      }

      if (addditionalCharges.ChargeName3.isNotEmpty) {
        if (addditionalCharges.ChargeName3.toString() != "null") {
          print("AA1" + _otherChargeBeForeGSTController3.toString());

          hdnOthChrgGST1hdnOthChrgBasic3 =
              AddtionalCharges.txtOthChrgAmt1_TextChanged(
                  addditionalCharges.ChargeID3.isNotEmpty
                      ? int.parse(addditionalCharges.ChargeID3)
                      : 0,
                  addditionalCharges.ChargeAmt3.isNotEmpty
                      ? double.parse(addditionalCharges.ChargeAmt3)
                      : 0.00,
                  addditionalCharges.ChargeGstPer3.isNotEmpty
                      ? double.parse(addditionalCharges.ChargeGstPer3)
                      : 0.00,
                  addditionalCharges.ChargeTaxType3.isNotEmpty
                      ? int.parse(
                          addditionalCharges.ChargeTaxType3.toString() == "0.00"
                              ? "0"
                              : addditionalCharges.ChargeTaxType3.toString())
                      : 0,
                  addditionalCharges.ChargeIsBeforGst3.toString() == "true"
                      ? true
                      : false);

          if (addditionalCharges.ChargeIsBeforGst3 == "true") {
            Tot_otherChargeWithTax += hdnOthChrgGST1hdnOthChrgBasic3[1];
          } else {
            Tot_otherChargeExcludeTax += hdnOthChrgGST1hdnOthChrgBasic3[1];
          }
        } else {
          _otherChargeNameController3 = "";
        }
      }

      if (addditionalCharges.ChargeName4.isNotEmpty) {
        if (addditionalCharges.ChargeName4.toString() != "null") {
          print("AA1" + _otherChargeBeForeGSTController4.toString());

          hdnOthChrgGST1hdnOthChrgBasic4 =
              AddtionalCharges.txtOthChrgAmt1_TextChanged(
                  addditionalCharges.ChargeID4.isNotEmpty
                      ? int.parse(addditionalCharges.ChargeID4)
                      : 0,
                  addditionalCharges.ChargeAmt4.isNotEmpty
                      ? double.parse(addditionalCharges.ChargeAmt4)
                      : 0.00,
                  addditionalCharges.ChargeGstPer4.isNotEmpty
                      ? double.parse(addditionalCharges.ChargeGstPer4)
                      : 0.00,
                  addditionalCharges.ChargeTaxType4.isNotEmpty
                      ? int.parse(
                          addditionalCharges.ChargeTaxType4.toString() == "0.00"
                              ? "0"
                              : addditionalCharges.ChargeTaxType4.toString())
                      : 0,
                  addditionalCharges.ChargeIsBeforGst4.toString() == "true"
                      ? true
                      : false);

          if (addditionalCharges.ChargeIsBeforGst4 == "true") {
            Tot_otherChargeWithTax += hdnOthChrgGST1hdnOthChrgBasic4[1];
          } else {
            Tot_otherChargeExcludeTax += hdnOthChrgGST1hdnOthChrgBasic4[1];
          }
        } else {
          _otherChargeNameController4 = "";
        }
      }

      if (addditionalCharges.ChargeName5.isNotEmpty) {
        if (addditionalCharges.ChargeName5.toString() != "null") {
          print("AA1ssdsd" + addditionalCharges.ChargeIsBeforGst5.toString());

          hdnOthChrgGST1hdnOthChrgBasic5 =
              AddtionalCharges.txtOthChrgAmt1_TextChanged(
                  addditionalCharges.ChargeID5.isNotEmpty
                      ? int.parse(addditionalCharges.ChargeID5)
                      : 0,
                  addditionalCharges.ChargeAmt5.isNotEmpty
                      ? double.parse(addditionalCharges.ChargeAmt5)
                      : 0.00,
                  addditionalCharges.ChargeGstPer5.isNotEmpty
                      ? double.parse(addditionalCharges.ChargeGstPer5)
                      : 0.00,
                  addditionalCharges.ChargeTaxType5.isNotEmpty
                      ? int.parse(
                          addditionalCharges.ChargeTaxType5.toString() == "0.00"
                              ? "0"
                              : addditionalCharges.ChargeTaxType5.toString())
                      : 0,
                  addditionalCharges.ChargeIsBeforGst5.toString() == "true"
                      ? true
                      : false);
          print("AA1ssdssdsd" + hdnOthChrgGST1hdnOthChrgBasic5[1].toString());

          if (addditionalCharges.ChargeIsBeforGst5 == "true") {
            Tot_otherChargeWithTax += hdnOthChrgGST1hdnOthChrgBasic5[1];
          } else {
            Tot_otherChargeExcludeTax += hdnOthChrgGST1hdnOthChrgBasic5[1];
          }
        } else {
          _otherChargeNameController5 = "";
        }
      }

      double otherChargeGstAmnt1 = hdnOthChrgGST1hdnOthChrgBasic1.length != 0
          ? hdnOthChrgGST1hdnOthChrgBasic1[0]
          : 0.00;
      double otherChargeGstBasicAmnt1 =
          hdnOthChrgGST1hdnOthChrgBasic1.length != 0
              ? hdnOthChrgGST1hdnOthChrgBasic1[1]
              : 0.00;
      double otherChargeGstAmnt2 = hdnOthChrgGST1hdnOthChrgBasic2.length != 0
          ? hdnOthChrgGST1hdnOthChrgBasic2[0]
          : 0.00;
      double otherChargeGstBasicAmnt2 =
          hdnOthChrgGST1hdnOthChrgBasic2.length != 0
              ? hdnOthChrgGST1hdnOthChrgBasic2[1]
              : 0.00;
      double otherChargeGstAmnt3 = hdnOthChrgGST1hdnOthChrgBasic3.length != 0
          ? hdnOthChrgGST1hdnOthChrgBasic3[0]
          : 0.00;
      double otherChargeGstBasicAmnt3 =
          hdnOthChrgGST1hdnOthChrgBasic3.length != 0
              ? hdnOthChrgGST1hdnOthChrgBasic3[1]
              : 0.00;
      double otherChargeGstAmnt4 = hdnOthChrgGST1hdnOthChrgBasic4.length != 0
          ? hdnOthChrgGST1hdnOthChrgBasic4[0]
          : 0.00;
      double otherChargeGstBasicAmnt4 =
          hdnOthChrgGST1hdnOthChrgBasic4.length != 0
              ? hdnOthChrgGST1hdnOthChrgBasic4[1]
              : 0.00;

      double otherChargeGstAmnt5 = hdnOthChrgGST1hdnOthChrgBasic5.length != 0
          ? hdnOthChrgGST1hdnOthChrgBasic5[0]
          : 0.00;
      double otherChargeGstBasicAmnt5 =
          hdnOthChrgGST1hdnOthChrgBasic5.length != 0
              ? hdnOthChrgGST1hdnOthChrgBasic5[1]
              : 0.00;

      List<double> TempproductList =
          SalesOrderHeaderDiscountCalculation.funCalculateTotal(
              otherChargeGstAmnt1,
              otherChargeGstAmnt2,
              otherChargeGstAmnt3,
              otherChargeGstAmnt4,
              otherChargeGstAmnt5,
              otherChargeGstBasicAmnt1,
              otherChargeGstBasicAmnt2,
              otherChargeGstBasicAmnt3,
              otherChargeGstBasicAmnt4,
              otherChargeGstBasicAmnt5,
              Tot_CGSTAmt,
              Tot_SGSTAmt,
              Tot_IGSTAmt,
              Tot_BasicAmount,
              Tot_NetAmt,
              HeaderDisAmnt,
              Tot_otherChargeWithTax,
              Tot_otherChargeExcludeTax);

      double totalGstController = 0.00,
          netAmountController = 0.00,
          roundOFController = 0.00;
      totalGstController = TempproductList[2];

      netAmountController = TempproductList[4];
      roundOFController = TempproductList[5];

      addditionalCharges = AddditionalCharges(
          DiscountAmt: HeaderDisAmnt.toStringAsFixed(2),
          SGSTAmt: Tot_SGSTAmt.toStringAsFixed(2),
          CGSTAmt: Tot_CGSTAmt.toStringAsFixed(2),
          IGSTAmt: Tot_IGSTAmt.toStringAsFixed(2),
          ChargeID1: addditionalCharges.ChargeID1,
          ChargeAmt1: addditionalCharges.ChargeAmt1,
          ChargeBasicAmt1: otherChargeGstBasicAmnt1.toStringAsFixed(2),
          ChargeGSTAmt1: otherChargeGstAmnt1.toStringAsFixed(2),
          ChargeID2: addditionalCharges.ChargeID2,
          ChargeAmt2: addditionalCharges.ChargeAmt2,
          ChargeBasicAmt2: otherChargeGstBasicAmnt2.toStringAsFixed(2),
          ChargeGSTAmt2: otherChargeGstAmnt2.toStringAsFixed(2),
          ChargeID3: addditionalCharges.ChargeID3,
          ChargeAmt3: addditionalCharges.ChargeAmt3,
          ChargeBasicAmt3: otherChargeGstBasicAmnt3.toStringAsFixed(2),
          ChargeGSTAmt3: otherChargeGstAmnt3.toStringAsFixed(2),
          ChargeID4: addditionalCharges.ChargeID4,
          ChargeAmt4: addditionalCharges.ChargeAmt4,
          ChargeBasicAmt4: otherChargeGstBasicAmnt4.toStringAsFixed(2),
          ChargeGSTAmt4: otherChargeGstAmnt4.toStringAsFixed(2),
          ChargeID5: addditionalCharges.ChargeID5,
          ChargeAmt5: addditionalCharges.ChargeAmt5,
          ChargeBasicAmt5: otherChargeGstBasicAmnt5.toStringAsFixed(2),
          ChargeGSTAmt5: otherChargeGstAmnt5.toStringAsFixed(2),
          NetAmt: netAmountController.toStringAsFixed(2),
          BasicAmt: Tot_BasicAmount.toStringAsFixed(2),
          ROffAmt: roundOFController.toStringAsFixed(2),
          ChargePer1: addditionalCharges.ChargePer1.toString(),
          ChargePer2: addditionalCharges.ChargePer2.toString(),
          ChargePer3: addditionalCharges.ChargePer3.toString(),
          ChargePer4: addditionalCharges.ChargePer4.toString(),
          ChargePer5: addditionalCharges.ChargePer5.toString(),
          ChargeName1: addditionalCharges.ChargeName1.toString(),
          ChargeName2: addditionalCharges.ChargeName2.toString(),
          ChargeName3: addditionalCharges.ChargeName3.toString(),
          ChargeName4: addditionalCharges.ChargeName4.toString(),
          ChargeName5: addditionalCharges.ChargeName5.toString(),
          ChargeTaxType1: addditionalCharges.ChargeTaxType1.toString(),
          ChargeTaxType2: addditionalCharges.ChargeTaxType2.toString(),
          ChargeTaxType3: addditionalCharges.ChargeTaxType3.toString(),
          ChargeTaxType4: addditionalCharges.ChargeTaxType4.toString(),
          ChargeTaxType5: addditionalCharges.ChargeTaxType5.toString(),
          ChargeGstPer1: addditionalCharges.ChargeGstPer1.toString(),
          ChargeGstPer2: addditionalCharges.ChargeGstPer2.toString(),
          ChargeGstPer3: addditionalCharges.ChargeGstPer3.toString(),
          ChargeGstPer4: addditionalCharges.ChargeGstPer4.toString(),
          ChargeGstPer5: addditionalCharges.ChargeGstPer5.toString(),
          ChargeIsBeforGst1: addditionalCharges.ChargeIsBeforGst1,
          ChargeIsBeforGst2: addditionalCharges.ChargeIsBeforGst2,
          ChargeIsBeforGst3: addditionalCharges.ChargeIsBeforGst3,
          ChargeIsBeforGst4: addditionalCharges.ChargeIsBeforGst4,
          ChargeIsBeforGst5: addditionalCharges.ChargeIsBeforGst5,
          OtherChargeWithTax: Tot_otherChargeWithTax.toStringAsFixed(2),
          OtherChargeWithExcludTax:
              Tot_otherChargeExcludeTax.toStringAsFixed(2),
          TotalGSTAmnt: totalGstController.toStringAsFixed(2),
          AdvancePer: "0.00",
          AdvanceAmt: "0.00");

      print("tttyyyeeetr" + " TotalGST : " + totalGstController.toString());

      List<double> finalcalculation = [
        /*0*/ Tot_BasicAmount,
        /*1*/ Tot_otherChargeWithTax,
        /*2*/ Tot_otherChargeExcludeTax,
        /*3*/ Tot_CGSTAmt,
        /*4*/ Tot_SGSTAmt,
        /*5*/ Tot_IGSTAmt,
        /*6*/ otherChargeGstBasicAmnt1,
        /*7*/ otherChargeGstBasicAmnt2,
        /*8*/ otherChargeGstBasicAmnt3,
        /*9*/ otherChargeGstBasicAmnt4,
        /*10*/ otherChargeGstBasicAmnt5,
        /*11*/ otherChargeGstAmnt1,
        /*12*/ otherChargeGstAmnt2,
        /*13*/ otherChargeGstAmnt3,
        /*14*/ otherChargeGstAmnt4,
        /*15*/ otherChargeGstAmnt5,
        /*16*/ totalGstController,
        /*17*/ netAmountController,
        /*18*/ roundOFController
      ];

      return finalcalculation;
    }
  }

  space(double height) {
    return SizedBox(
      height: height,
    );
  }

  void _onBankDetailsList(
      BankDetailsListResponseState bankDetailsListResponseState) {
    if (bankDetailsListResponseState.response.details.length != 0) {
      arr_ALL_Name_ID_For_Sales_Order_Bank_Name.clear();
      for (int i = 0;
          i < bankDetailsListResponseState.response.details.length;
          i++) {
        if (i == 0) {
          edt_bankName.text =
              bankDetailsListResponseState.response.details[i].bankName;
          edt_bankID.text =
              bankDetailsListResponseState.response.details[i].pkID.toString();
        }
      }
    }
  }

  void _onFollowerEmployeeListByStatusCallSuccess(
      ALL_EmployeeList_Response state) {
    arr_ALL_Name_ID_For_Sales_Order_Sales_Executive.clear();
    if (state.details != null) {
      for (var i = 0; i < state.details.length; i++) {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = state.details[i].employeeName;
        all_name_id.pkID = state.details[i].pkID;
        arr_ALL_Name_ID_For_Sales_Order_Sales_Executive.add(all_name_id);
      }
    }
  }

  void _OnProjectList(QuotationProjectListResponseState state) {
    if (state.response.details.length != 0) {
      arr_ALL_Name_ID_For_ProjectList.clear();
      for (var i = 0; i < state.response.details.length; i++) {
        print("InquiryStatus : " + state.response.details[i].projectName);
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = state.response.details[i].projectName;
        all_name_id.pkID = state.response.details[i].pkID;
        arr_ALL_Name_ID_For_ProjectList.add(all_name_id);
      }
      if (arr_ALL_Name_ID_For_ProjectList.length != 0) {
        showcustomdialogWithID(
            values: arr_ALL_Name_ID_For_ProjectList,
            context1: context,
            controller: edt_projectName,
            controllerID: edt_projectID,
            lable: "Select Project ");
      } else {
        showCommonDialogWithSingleOption(context, "Project Details are Empty !",
            positiveButtonTitle: "OK", onTapOfPositiveButton: () {
          Navigator.pop(context);
        });
      }
    } else {
      showCommonDialogWithSingleOption(context, "Project Details are Empty !",
          positiveButtonTitle: "OK", onTapOfPositiveButton: () {
        Navigator.pop(context);
      });
    }
  }

  void fillData() async {
    setState(() => isLoading = true); // Show loader

    try {
      // Assign basic fields
      pkID = _editModel.pkID;

      edt_invoiceNo.text = _editModel.invoiceNo?.toString() ?? '';
      edt_invoiceDate.text = _editModel.invoiceDate?.getFormattedDate(
              fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy") ??
          '';
      edt_rev_invoiceDate.text = _editModel.invoiceDate?.getFormattedDate(
              fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd") ??
          '';

      edt_customerName.text = _editModel.customerName ?? '';
      edt_customerID.text = _editModel.customerID?.toString() ?? '';
      edt_HeaderDisc.text = _editModel.discountAmt?.toString() ?? '';
      edt_termsAndCondition.text = _editModel.termsCondition ?? '';
      edt_PurchaseACID.text = _editModel.fixedLedgerID.toString() ?? '';
      edt_PurchaseACName.text = _editModel.fixedLedgerName ?? '';
      edt_TODID.text = _editModel.terminationOfDeliery.toString() ?? '';
      edt_projectName.text = _editModel.projectName ?? '';
      edt_serialNo.text = _editModel.cRDays?.toString() ?? '';

      edt_dispatchDate.text = _editModel.dueDate?.getFormattedDate(
              fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy") ??
          '';
      edt_rev_dispatchDate.text = _editModel.dueDate?.getFormattedDate(
              fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd") ??
          '';
      edt_otherReference.text = _editModel.exchangeRate?.toString() ?? '';
      edt_bankName.text = _editModel.bankName ?? '';
      edt_bankID.text = _editModel.bankID?.toString() ?? '';
      edt_StateCode.text = _editModel.stateCode.toString();
      print("edt_StateCode.text" + edt_StateCode.text);

      // Transport controller fields
      _controller_mode_of_transfer.text = _editModel.modeOfTransport ?? '';
      _controller_Transporter.text = _editModel.transporterName ?? '';
      _controller_LR_NO.text = _editModel.lRNo ?? '';
      _controller_Remarks.text = _editModel.transportRemark ?? '';
      _controller_vihical_no.text = _editModel.vehicleNo ?? '';

      _controller_LR_date.text = _editModel.lRDate?.getFormattedDate(
              fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy") ??
          '';
      _controller_LR_date_Reveres.text = _editModel.lRDate?.getFormattedDate(
              fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd") ??
          '';

      SalesOrderNo = _editModel.invoiceNo?.toString() ?? '';

      /// Fetch product details
      await getInquiryProductDetails();

      /// Clear previous charges
      _mainBloc.add(DeleteGenericAdditionalChargesEvent());

      /// Add current additional charges
      _mainBloc.add(AddGenericAdditionalChargesEvent(GenericAddditionalCharges(
        _editModel.discountAmt?.toString() ?? '',
        _editModel.chargeID1?.toString() ?? '',
        _editModel.chargeAmt1?.toString() ?? '',
        _editModel.chargeID2?.toString() ?? '',
        _editModel.chargeAmt2?.toString() ?? '',
        _editModel.chargeID3?.toString() ?? '',
        _editModel.chargeAmt3?.toString() ?? '',
        _editModel.chargeID4?.toString() ?? '',
        _editModel.chargeAmt4?.toString() ?? '',
        _editModel.chargeID5?.toString() ?? '',
        _editModel.chargeAmt5?.toString() ?? '',
        _editModel.chargeName1 ?? '',
        _editModel.chargeName2 ?? '',
        _editModel.chargeName3 ?? '',
        _editModel.chargeName4 ?? '',
        _editModel.chargeName5 ?? '',
      )));

      /// Set detailed additional charges
      addditionalCharges = AddditionalCharges(
        DiscountAmt: _editModel.discountAmt?.toString() ?? '',
        SGSTAmt: _editModel.sGSTAmt?.toString() ?? '',
        CGSTAmt: _editModel.cGSTAmt?.toString() ?? '',
        IGSTAmt: _editModel.iGSTAmt?.toString() ?? '',
        ChargeID1: _editModel.chargeID1?.toString() ?? '',
        ChargeName1: _editModel.chargeName1 ?? '',
        ChargeAmt1: _editModel.chargeAmt1?.toString() ?? '',
        ChargeBasicAmt1: _editModel.chargeBasicAmt1?.toString() ?? '',
        ChargeGSTAmt1: _editModel.chargeGSTAmt1?.toString() ?? '',
        ChargeTaxType1: '0',
        ChargeGstPer1: '0.00',
        ChargeIsBeforGst1: '0.00',
        ChargeID2: _editModel.chargeID2?.toString() ?? '',
        ChargeName2: _editModel.chargeName2 ?? '',
        ChargeAmt2: _editModel.chargeAmt2?.toString() ?? '',
        ChargeBasicAmt2: _editModel.chargeBasicAmt2?.toString() ?? '',
        ChargeGSTAmt2: _editModel.chargeGSTAmt2?.toString() ?? '',
        ChargeTaxType2: '0',
        ChargeGstPer2: '0.00',
        ChargeIsBeforGst2: '0.00',
        ChargeID3: _editModel.chargeID3?.toString() ?? '',
        ChargeName3: _editModel.chargeName3 ?? '',
        ChargeAmt3: _editModel.chargeAmt3?.toString() ?? '',
        ChargeBasicAmt3: _editModel.chargeBasicAmt3?.toString() ?? '',
        ChargeGSTAmt3: _editModel.chargeGSTAmt3?.toString() ?? '',
        ChargeTaxType3: '0',
        ChargeGstPer3: '0.00',
        ChargeIsBeforGst3: '0.00',
        ChargeID4: _editModel.chargeID4?.toString() ?? '',
        ChargeName4: _editModel.chargeName4 ?? '',
        ChargeAmt4: _editModel.chargeAmt4?.toString() ?? '',
        ChargeBasicAmt4: _editModel.chargeBasicAmt4?.toString() ?? '',
        ChargeGSTAmt4: _editModel.chargeGSTAmt4?.toString() ?? '',
        ChargeTaxType4: '0',
        ChargeGstPer4: '0.00',
        ChargeIsBeforGst4: '0.00',
        ChargeID5: _editModel.chargeID5?.toString() ?? '',
        ChargeName5: _editModel.chargeName5 ?? '',
        ChargeAmt5: _editModel.chargeAmt5?.toString() ?? '',
        ChargeBasicAmt5: _editModel.chargeBasicAmt5?.toString() ?? '',
        ChargeGSTAmt5: _editModel.chargeGSTAmt5?.toString() ?? '',
        ChargeTaxType5: '0',
        ChargeGstPer5: '0.00',
        ChargeIsBeforGst5: '0.00',
        NetAmt: _editModel.netAmt?.toString() ?? '',
        BasicAmt: _editModel.basicAmt?.toString() ?? '',
        ROffAmt: _editModel.rOffAmt?.toString() ?? '',
        ChargePer1: '0.00',
        ChargePer2: '0.00',
        ChargePer3: '0.00',
        ChargePer4: '0.00',
        ChargePer5: '0.00',
      );

      // Load Quotation Other Charges
      _mainBloc.add(QuotationOtherChargeCallEvent(
        _editModel.discountAmt?.toString() ?? '',
        CompanyID.toString(),
        QuotationOtherChargesListRequest(pkID: ''),
      ));

      // If invoice exists, fetch Purchase Bill Details
      if ((_editModel.invoiceNo?.toString() ?? '').isNotEmpty) {
        await _mainBloc.add(PurchaseBillDetailsListRequestEvent(
          _editModel.stateCode,
          LoginUserID,
          PurchaseBillDetailsListRequest(
            InvoiceNo: _editModel.invoiceNo.toString(),
            CompanyId: CompanyID.toString(),
          ),
        ));
      }
    } catch (e) {
      print('fillData error: $e');
    } finally {
      if (mounted) {
        setState(() => isLoading = false); // Hide loader
      }
    }
  }

  BankDetails(BuildContext context) {
    return EditText(context,
        hint: "Select Bank Name",
        radius: 10,
        readOnly: true,
        controller: edt_bankName,
        boxheight: 40, onPressed: () {
      showcustomdialogWithID(
          values: arr_ALL_Name_ID_For_Sales_Order_Bank_Name,
          context1: context,
          controller: edt_bankName,
          controllerID: edt_bankID,
          lable: "Bank Details");
    },
        inputTextStyle: TextStyle(fontSize: 15),
        suffixIcon: Icon(
          Icons.arrow_drop_down,
          color: colorGrayDark,
          size: 32,
        ));
  }

  void getSelectOptionList() {
    arr_ALL_Name_ID_For_Sales_Order_Select_Inquiry.clear();
    for (var i = 0; i < 2; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      if (i == 0) {
        all_name_id.Name = "G.R.N";
      } else if (i == 1) {
        all_name_id.Name = "Purchase Order";
      }
      arr_ALL_Name_ID_For_Sales_Order_Select_Inquiry.add(all_name_id);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _OnPaymentScheduleSucessList(PaymentScheduleListResponseState state) {
    arr_PaymentScheduleList.clear();
    for (int i = 0; i < state.response.length; i++) {
      arr_PaymentScheduleList.add(SoPaymentScheduleTable(
          state.response[i].amount,
          state.response[i].dueDate,
          state.response[i].revdueDate,
          id: state.response[i].id));
    }
  }

  void _onInsertPaymentScheduleSucess(PaymentScheduleResponseState state) {
    print("Paymenf" + state.response);
    _mainBloc.add(PaymentScheduleListEvent());
  }

  void _ondeletePaymentSchedule(PaymentScheduleDeleteResponseState state) {
    print("Paymenf" + state.response);
    _mainBloc.add(PaymentScheduleListEvent());
  }

  showcustomdialogSendEmail({
    BuildContext context1,
    int updatedID,
    // SoPaymentScheduleTable paymentScheduleModel
  }) async {
    await showDialog(
      barrierDismissible: false,
      context: context1,
      builder: (BuildContext context123) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          title: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: colorPrimary, //                   <--- border color
                ),
                borderRadius: BorderRadius.all(Radius.circular(
                        15.0) //                 <--- border radius here
                    ),
              ),
              child: Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Update Payment Schedule",
                    style: TextStyle(
                        color: colorPrimary, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ))),
          children: [
            SizedBox(
                width: MediaQuery.of(context123).size.width,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: Text("Amount",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: colorPrimary,
                                    fontWeight: FontWeight
                                        .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                                ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: Card(
                              elevation: 5,
                              color: colorLightGray,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Container(
                                padding: EdgeInsets.only(left: 20, right: 20),
                                width: double.maxFinite,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                          controller: _controllerAmountDialog,
                                          textInputAction: TextInputAction.next,
                                          keyboardType:
                                              TextInputType.numberWithOptions(
                                                  decimal: true),
                                          decoration: InputDecoration(
                                            hintText: "Tap to enter Amount",
                                            labelStyle: TextStyle(
                                              color: Color(0xFF000000),
                                            ),
                                            border: InputBorder.none,
                                          ),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF000000),
                                          ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: Text("Date",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: colorPrimary,
                                    fontWeight: FontWeight
                                        .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                                ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: Card(
                              elevation: 5,
                              color: colorLightGray,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Container(
                                padding: EdgeInsets.only(left: 25, right: 20),
                                width: double.maxFinite,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          _selectOrderDate(
                                              context,
                                              _controllerDueDateDialog,
                                              _controllerRevDueDateDialog);
                                        },
                                        child: TextField(
                                            controller:
                                                _controllerDueDateDialog,
                                            enabled: false,
                                            decoration: InputDecoration(
                                              hintText: "DD-MM-YYYY",
                                              labelStyle: TextStyle(
                                                color: Color(0xFF000000),
                                              ),
                                              border: InputBorder.none,
                                            ),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF000000),
                                            ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: getCommonButton(
                            baseTheme,
                            () async {
                              if (_controllerAmountDialog.text != "") {
                                if (_controllerDueDateDialog.text != "") {
                                  _mainBloc.add(PaymentScheduleEditEvent(
                                      SoPaymentScheduleTable(
                                          double.parse(
                                              _controllerAmountDialog.text),
                                          _controllerDueDateDialog.text,
                                          _controllerRevDueDateDialog.text,
                                          id: updatedID)));
                                } else {
                                  showCommonDialogWithSingleOption(
                                      context, "Date is Required !",
                                      positiveButtonTitle: "OK");
                                }
                              } else {
                                showCommonDialogWithSingleOption(
                                    context, "Amount is Required !",
                                    positiveButtonTitle: "OK");
                              }

                              Navigator.pop(context);
                            },
                            "Update",
                            textSize: 12,
                            backGroundColor: colorPrimary,
                            textColor: colorWhite,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 100,
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: getCommonButton(
                            baseTheme,
                            () {
                              Navigator.pop(context);
                            },
                            "Close",
                            textSize: 12,
                            backGroundColor: colorPrimary,
                            textColor: colorWhite,
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
          ],
        );
      },
    );
  }

  void _onPurchaseBillAddUpdateResponseState(
      PurchaseBillAddUpdateResponseState state) {
    int returnPKID = 0;
    String returnInvoiceNo = "";

    // Extract pkID and InvoiceNo from response
    for (final detail in state.purchaseBillAddUpdateResponse.details) {
      returnPKID = int.tryParse(detail.column1.toString()) ?? 0;
      returnInvoiceNo = detail.column3 ?? "";
    }

    updateRetrunInquiryNoToDB(state.context, returnPKID, returnInvoiceNo);
  }

  void updateRetrunInquiryNoToDB(
      context1, int returnPKID, String retrunSO_No) async {
    await getInquiryProductDetails();

    List<PurchaseBillTable> TempproductList1 =
        PurchaseBillOrderHeaderDiscountCalculation.txtHeadDiscount_WithZero(
            _inquiryProductList,
            HeaderDisAmnt,
            _offlineLoggedInData.details[0].stateCode.toString(),
            edt_StateCode.text.toString());

    List<PurchaseBillTable> TempproductList =
        PurchaseBillOrderHeaderDiscountCalculation.txtHeadDiscount_TextChanged(
            TempproductList1,
            HeaderDisAmnt,
            _offlineLoggedInData.details[0].stateCode.toString(),
            edt_StateCode.text.toString());

    arrSOProductList.clear();
    for (int i = 0; i < TempproductList.length; i++) {
      PurchaseBillDetailsAddUpdateRequest purchaseBillDetailsAddUpdateRequest =
          PurchaseBillDetailsAddUpdateRequest(
        pkID: 0,
        InvoiceNo: retrunSO_No,
        ProductID: TempproductList[i].ProductID,
        ProductSpecification: TempproductList[i].ProductSpecification,
        LocationID: TempproductList[i].LocationID,
        TaxType: TempproductList[i].TaxType,
        Qty: TempproductList[i].Qty,
        Unit: TempproductList[i].Unit,
        Rate: TempproductList[i].Rate,
        DiscountPer: TempproductList[i].DiscountPer,
        DiscountAmt: TempproductList[i].DiscountAmt,
        NetRate: TempproductList[i].NetRate,
        Amount: TempproductList[i].Amount,
        SGSTPer: TempproductList[i].SGSTPer,
        SGSTAmt: TempproductList[i].SGSTAmt,
        CGSTPer: TempproductList[i].CGSTPer,
        CGSTAmt: TempproductList[i].CGSTAmt,
        IGSTPer: TempproductList[i].IGSTPer,
        IGSTAmt: TempproductList[i].IGSTAmt,
        AddTaxPer: TempproductList[i].AddTaxPer,
        AddTaxAmt: TempproductList[i].AddTaxAmt,
        NetAmt: TempproductList[i].NetAmt,
        HeaderDiscAmt: TempproductList[i].HeaderDiscAmt,
        OrderNo: TempproductList[i].OrderNo,
        LoginUserID: LoginUserID,
        CompanyId: CompanyID,
      );

      arrSOProductList.add(purchaseBillDetailsAddUpdateRequest);
    }

    _mainBloc.add(PurchaseBillDetailsAddUpdateCallEvent(
        context1, retrunSO_No, arrSOProductList));
  }

  void _OnPurchaseBillProductSaveResponseState(
      PurchaseBillProductSaveResponseState state) async {
    String Msg = _isForUpdate == true
        ? "PurchaseBill Updated Successfully"
        : "PurchaseBill Added Successfully";

    showCommonDialogWithSingleOption(context, Msg, positiveButtonTitle: "OK",
        onTapOfPositiveButton: () {
      navigateTo(context, PurchaseBillListScreen.routeName,
          clearAllStack: true);
    });
  }

  void _OnGenericIsertCallSucess(AddGenericAdditionalChargesState state) {
    print("_OnGenericIsertCallSucess" + state.response);
  }

  void _onDeleteAllGenericAddtionalAmount(
      DeleteAllGenericAdditionalChargesState state) {
    print("DeleteAllGenericAddditionalChargesState" + state.response);
  }

  void _ONOnlyCustomerDetails(
      SearchCustomerListByNumberCallResponseState state) {
    edt_StateCode.text = state.response.details[0].stateCode.toString();
  }

  Future<void> _onTapOfDeleteALLProduct() async {
    await OfflineDbHelper.getInstance().deleteAllShortInvoices();
  }

  void _OnGenricOtherChargeResponse(
      GenericOtherCharge1ListResponseState state) {
    arrGenericOtheCharge.clear();

    for (int i = 0;
        i < state.quotationOtherChargesListResponse.details.length;
        i++) {
      arrGenericOtheCharge
          .add(state.quotationOtherChargesListResponse.details[i]);
    }
  }

  void AddAddtionalCharge() async {
    await OfflineDbHelper.getInstance()
        .insertGenericAddditionalCharges(GenericAddditionalCharges(
      edt_HeaderDisc.text,
      _editModel.chargeID1.toString(),
      _editModel.chargeAmt1.toString(),
      _editModel.chargeID2.toString(),
      _editModel.chargeAmt2.toString(),
      _editModel.chargeID3.toString(),
      _editModel.chargeAmt3.toString(),
      _editModel.chargeID4.toString(),
      _editModel.chargeAmt4.toString(),
      _editModel.chargeID5.toString(),
      _editModel.chargeAmt5.toString(),
      _editModel.chargeName1,
      _editModel.chargeName2,
      _editModel.chargeName3,
      _editModel.chargeName4,
      _editModel.chargeName5,
    ));
  }

  Widget ProductAndAddtionalCharges() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      elevation: 10,
      color: colorPrimary,
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: Colors.white,
          collapsedIconColor: Colors.white,
          title: const Text(
            "Products & Additional Charges",
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: ClipRRect(
            child: Image.asset(
              BASIC_INFORMATION,
              width: 27,
              color: Colors.white,
            ),
          ),
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(15)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  productDetails(),
                  const SizedBox(height: 10),
                  _buildChargesButton(
                    title: "Additional Charges",
                    onPressed: () async {
                      await getInquiryProductDetails();
                      if (_inquiryProductList.isNotEmpty) {
                        navigateTo(
                          context,
                          NewPurchaseBillOtherChargeScreen.routeName,
                          arguments: NewPurchaseBillOtherChargeScreenArguments(
                            int.tryParse(edt_StateCode.text) ?? 0,
                            _editModel,
                            edt_HeaderDisc.text,
                            "OtherCharge",
                            addditionalCharges,
                          ),
                        ).then((value) {
                          setState(() {
                            addditionalCharges = value;
                            isUpdateCalculation = true;
                            edt_HeaderDisc.text =
                                addditionalCharges.DiscountAmt;
                          });
                        });
                      } else {
                        showCommonDialogWithSingleOption(
                          context,
                          "At least one product is required to view other charges!",
                          positiveButtonTitle: "OK",
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildChargesButton(
                    title: "Final Summary",
                    onPressed: () async {
                      await getInquiryProductDetails();
                      if (_inquiryProductList.isNotEmpty) {
                        navigateTo(
                          context,
                          NewPurchaseBillOtherChargeScreen.routeName,
                          arguments: NewPurchaseBillOtherChargeScreenArguments(
                            int.tryParse(edt_StateCode.text) ?? 0,
                            _editModel,
                            edt_HeaderDisc.text,
                            "Calculation",
                            addditionalCharges,
                          ),
                        ).then((value) {
                          setState(() {
                            addditionalCharges = value;
                            isUpdateCalculation = true;
                            edt_HeaderDisc.text =
                                addditionalCharges.DiscountAmt;
                          });
                        });
                      } else {
                        showCommonDialogWithSingleOption(
                          context,
                          "At least one product is required to view final summary!",
                          positiveButtonTitle: "OK",
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChargesButton({
    String title,
    VoidCallback onPressed,
  }) {
    return Center(
      child: getCommonButton(
        baseTheme,
        onPressed,
        title,
        width: double.infinity,
        textColor: colorPrimary,
        backGroundColor: colorGreenLight,
        radius: 25.0,
      ),
    );
  }

  void _onOtherChargeListResponse(QuotationOtherChargeListResponseState state) {
    int chrID1 = 0;
    int chrID2 = 0;
    int chrID3 = 0;
    int chrID4 = 0;
    int chrID5 = 0;

    int ChargeTaxType1 = 0;
    int ChargeTaxType2 = 0;
    int ChargeTaxType3 = 0;
    int ChargeTaxType4 = 0;
    int ChargeTaxType5 = 0;

    double ChargeGstPer1 = 0.00;
    double ChargeGstPer2 = 0.00;
    double ChargeGstPer3 = 0.00;
    double ChargeGstPer4 = 0.00;
    double ChargeGstPer5 = 0.00;

    bool ChargeIsBeforGst1 = false;
    bool ChargeIsBeforGst2 = false;
    bool ChargeIsBeforGst3 = false;
    bool ChargeIsBeforGst4 = false;
    bool ChargeIsBeforGst5 = false;

    double OtherChargeWithTax = 0.00;

    for (int i = 0;
        i < state.quotationOtherChargesListResponse.details.length;
        i++) {
      if (_editModel.chargeID1 ==
          state.quotationOtherChargesListResponse.details[i].pkId) {
        ChargeTaxType1 =
            state.quotationOtherChargesListResponse.details[i].taxType;
        ChargeGstPer1 =
            state.quotationOtherChargesListResponse.details[i].gSTPer;
        ChargeIsBeforGst1 =
            state.quotationOtherChargesListResponse.details[i].beforeGST;
      }
      if (_editModel.chargeID2 ==
          state.quotationOtherChargesListResponse.details[i].pkId) {
        ChargeTaxType2 =
            state.quotationOtherChargesListResponse.details[i].taxType;
        ChargeGstPer2 =
            state.quotationOtherChargesListResponse.details[i].gSTPer;
        ChargeIsBeforGst2 =
            state.quotationOtherChargesListResponse.details[i].beforeGST;
      }

      if (_editModel.chargeID3 ==
          state.quotationOtherChargesListResponse.details[i].pkId) {
        ChargeTaxType3 =
            state.quotationOtherChargesListResponse.details[i].taxType;
        ChargeGstPer3 =
            state.quotationOtherChargesListResponse.details[i].gSTPer;
        ChargeIsBeforGst3 =
            state.quotationOtherChargesListResponse.details[i].beforeGST;
      }

      if (_editModel.chargeID4 ==
          state.quotationOtherChargesListResponse.details[i].pkId) {
        ChargeTaxType4 =
            state.quotationOtherChargesListResponse.details[i].taxType;
        ChargeGstPer4 =
            state.quotationOtherChargesListResponse.details[i].gSTPer;
        ChargeIsBeforGst4 =
            state.quotationOtherChargesListResponse.details[i].beforeGST;
      }
      if (_editModel.chargeID5 ==
          state.quotationOtherChargesListResponse.details[i].pkId) {
        ChargeTaxType5 =
            state.quotationOtherChargesListResponse.details[i].taxType;
        ChargeGstPer5 =
            state.quotationOtherChargesListResponse.details[i].gSTPer;
        ChargeIsBeforGst5 =
            state.quotationOtherChargesListResponse.details[i].beforeGST;
      }
    }

    double totgsttemp =
        _editModel.cGSTAmt + _editModel.sGSTAmt + _editModel.iGSTAmt;
    addditionalCharges = AddditionalCharges(
      DiscountAmt: _editModel.discountAmt.toString(),
      SGSTAmt: _editModel.sGSTAmt.toString(),
      CGSTAmt: _editModel.cGSTAmt.toString(),
      IGSTAmt: _editModel.iGSTAmt.toString(),
      ChargeID1: _editModel.chargeID1.toString(),
      ChargeAmt1: _editModel.chargeAmt1.toStringAsFixed(2),
      ChargeBasicAmt1: _editModel.chargeBasicAmt1.toStringAsFixed(2),
      ChargeGSTAmt1: _editModel.chargeGSTAmt1.toStringAsFixed(2),
      ChargeID2: _editModel.chargeID2.toString(),
      ChargeAmt2: _editModel.chargeAmt2.toStringAsFixed(2),
      ChargeBasicAmt2: _editModel.chargeBasicAmt2.toStringAsFixed(2),
      ChargeGSTAmt2: _editModel.chargeGSTAmt2.toStringAsFixed(2),
      ChargeID3: _editModel.chargeID3.toString(),
      ChargeAmt3: _editModel.chargeAmt3.toStringAsFixed(2),
      ChargeBasicAmt3: _editModel.chargeBasicAmt3.toStringAsFixed(2),
      ChargeGSTAmt3: _editModel.chargeGSTAmt3.toStringAsFixed(2),
      ChargeID4: _editModel.chargeID4.toString(),
      ChargeAmt4: _editModel.chargeAmt4.toStringAsFixed(2),
      ChargeBasicAmt4: _editModel.chargeBasicAmt4.toStringAsFixed(2),
      ChargeGSTAmt4: _editModel.chargeGSTAmt4.toStringAsFixed(2),
      ChargeID5: _editModel.chargeID5.toString(),
      ChargeAmt5: _editModel.chargeAmt5.toStringAsFixed(2),
      ChargeBasicAmt5: _editModel.chargeBasicAmt5.toStringAsFixed(2),
      ChargeGSTAmt5: _editModel.chargeGSTAmt5.toStringAsFixed(2),
      NetAmt: _editModel.netAmt.toStringAsFixed(2),
      BasicAmt: _editModel.basicAmt.toStringAsFixed(2),
      ROffAmt: _editModel.rOffAmt.toStringAsFixed(2),
      ChargePer1: "0.00",
      ChargePer2: "0.00",
      ChargePer3: "0.00",
      ChargePer4: "0.00",
      ChargePer5: "0.00",
      ChargeName1: _editModel.chargeName1.toString(),
      ChargeName2: _editModel.chargeName2.toString(),
      ChargeName3: _editModel.chargeName3.toString(),
      ChargeName4: _editModel.chargeName4.toString(),
      ChargeName5: _editModel.chargeName5.toString(),
      ChargeTaxType1: ChargeTaxType1.toString(),
      ChargeTaxType2: ChargeTaxType2.toString(),
      ChargeTaxType3: ChargeTaxType3.toString(),
      ChargeTaxType4: ChargeTaxType4.toString(),
      ChargeTaxType5: ChargeTaxType5.toString(),
      ChargeGstPer1: ChargeGstPer1.toStringAsFixed(2),
      ChargeGstPer2: ChargeGstPer2.toStringAsFixed(2),
      ChargeGstPer3: ChargeGstPer3.toStringAsFixed(2),
      ChargeGstPer4: ChargeGstPer4.toStringAsFixed(2),
      ChargeGstPer5: ChargeGstPer5.toStringAsFixed(2),
      ChargeIsBeforGst1: ChargeIsBeforGst1.toString(),
      ChargeIsBeforGst2: ChargeIsBeforGst2.toString(),
      ChargeIsBeforGst3: ChargeIsBeforGst3.toString(),
      ChargeIsBeforGst4: ChargeIsBeforGst4.toString(),
      ChargeIsBeforGst5: ChargeIsBeforGst5.toString(),
      OtherChargeWithTax: "",
      OtherChargeWithExcludTax: "",
      TotalGSTAmnt: totgsttemp.toStringAsFixed(2),
      //AdvanceAmt: _editModel.AdvanceAmt.toStringAsFixed(2),
      //AdvancePer: _editModel.AdvancePer.toStringAsFixed(2),
    );
  }

  void _onBankDialgSelection(BankDetailsDialogListResponseState state) {
    arr_ALL_Name_ID_For_Sales_Order_Bank_Name.clear();
    for (int i = 0; i < state.response.details.length; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      all_name_id.Name = state.response.details[i].bankName;
      all_name_id.pkID = state.response.details[i].pkID;
      arr_ALL_Name_ID_For_Sales_Order_Bank_Name.add(all_name_id);
    }

    if (arr_ALL_Name_ID_For_Sales_Order_Bank_Name.length != 0) {
      showcustomdialogWithID(
          values: arr_ALL_Name_ID_For_Sales_Order_Bank_Name,
          context1: context,
          controller: edt_bankName,
          controllerID: edt_bankID,
          lable: "Select Bank");
    } else {
      showCommonDialogWithSingleOption(context, "Bank Details is Empty !",
          positiveButtonTitle: "OK", onTapOfPositiveButton: () {
        Navigator.pop(context);
      });
    }
  }

  void _On_No_To_ProductDetails(
      MultiNoToProductDetailsResponseState state) async {
    if (state.response.details.length != 0) {
      await OfflineDbHelper.getInstance().deleteALLSalesOrderProduct();

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
        double headerDiscountAmt = state.response.details[i].headerDiscAmt;
        String DocRef = state.response.details[i].docRefNo;

        await OfflineDbHelper.getInstance().insertSalesOrderProduct(
            SalesOrderTable(
                "",
                state.response.details[i].productSpecification,
                state.response.details[i].productID,
                state.response.details[i].productName,
                state.response.details[i].unit,
                Quantity,
                UnitPrice,
                DisPer,
                DisAmount,
                NetRate,
                Amount,
                TaxPer,
                TaxAmount,
                TotalAmount,
                TaxType,
                CGSTPer,
                SGSTPer,
                IGSTPer,
                CGSTAmount,
                SGSTAmount,
                IGSTAmount,
                int.parse(edt_StateCode.text),
                0,
                LoginUserID,
                CompanyID.toString(),
                0,
                headerDiscountAmt,
                selectedDate.year.toString() +
                    "-" +
                    selectedDate.month.toString() +
                    "-" +
                    selectedDate.day.toString(),
                DocRef));
      }

      if (state.FetchFromWhichScreen == "Add") {
        navigateTo(context, ShortInvoiceProductListScreen.routeName,
            arguments: ShortInvoiceProductListArgument(
                SalesOrderNo, edt_StateCode.text, edt_HeaderDisc.text));
      }
    }
  }

  void _onPurchaseBillDetailsListResponseState(
      PurchaseBillDetailsListResponseState state) {}

  void _onPurchaseBillDetailsDeleteResponseState(
      PurchaseBillDetailsDeleteResponseState state) {}

  void getAddressDropDownList() {
    arr_ALL_Name_ID_For_Sales_Order_Address_DROP_DOWN.clear();
    for (var i = 0; i < 3; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      if (i == 0) {
        all_name_id.Name = "Primary";
      } else if (i == 1) {
        all_name_id.Name = "Secondary";
      } else if (i == 2) {
        all_name_id.Name = "Organization";
      }
      arr_ALL_Name_ID_For_Sales_Order_Address_DROP_DOWN.add(all_name_id);
    }
  }

  void _onMultiNoToProductDetailsFromGrnResponseState(
      MultiNoToProductDetailsFromGrnResponseState state) async {
    if (state.response.details.length != 0) {
      await OfflineDbHelper.getInstance().deleteALLPurchaseBillProduct();

      for (var i = 0; i < state.response.details.length; i++) {
        await OfflineDbHelper.getInstance()
            .insertPurchaseBillProduct(PurchaseBillTable(
          0, //pkID,
          "", //InvoiceNo,
          state.response.details[i].inwardNo, //OrderNo,
          state.response.details[i].productID, //int ProductID,
          state.response.details[i].productName, //String ProductName,
          state.response.details[i]
              .productSpecification, //String ProductSpecification,
          0, //LocationID,
          state.response.details[i].taxType, //int TaxType,
          state.response.details[i].quantity, //Qty,
          state.response.details[i].unitRate, //Rate,
          state.response.details[i].discountPercent, //DiscountPer,
          state.response.details[i].discountAmt, //DiscountAmt,
          state.response.details[i].netRate, //NetRate,
          state.response.details[i].amount, //Amount,
          state.response.details[i].cGSTPer, //CGSTPer,
          state.response.details[i].sGSTPer, //SGSTPer,
          state.response.details[i].iGSTPer, //IGSTPer,
          state.response.details[i].cGSTAmt, //CGSTAmt,
          state.response.details[i].sGSTAmt, //SGSTAmt,
          state.response.details[i].iGSTAmt, //IGSTAmt,
          state.response.details[i].taxRate, //AddTaxPer,
          state.response.details[i].taxAmount, //AddTaxAmt,
          state.response.details[i].netAmount, //NetAmt,
          state.response.details[i].headerDiscAmt, //HeaderDiscAmt,
          state.response.details[i].unit, //Unit,
          int.parse(edt_StateCode.text), //int StateCode,
          LoginUserID, //String LoginUserID,
          CompanyID.toString(), //String CompanyId,
        ));
      }
    }
  }

  void _onMultiNoToProductDetailsFromPurchaseOrderResponseState(
      MultiNoToProductDetailsFromPurchaseOrderResponseState state) async {
    if (state.response.details.length != 0) {
      await OfflineDbHelper.getInstance().deleteALLPurchaseBillProduct();

      for (var i = 0; i < state.response.details.length; i++) {
        await OfflineDbHelper.getInstance()
            .insertPurchaseBillProduct(PurchaseBillTable(
          0, //pkID,
          "", //InvoiceNo,
          state.response.details[i].orderNo, //OrderNo,
          state.response.details[i].productID, //int ProductID,
          state.response.details[i].productName, //String ProductName,
          state.response.details[i]
              .productSpecification, //String ProductSpecification,
          0, //LocationID,
          state.response.details[i].taxType, //int TaxType,
          state.response.details[i].quantity, //Qty,
          state.response.details[i].unitRate, //Rate,
          state.response.details[i].discountPercent, //DiscountPer,
          state.response.details[i].discountAmt, //DiscountAmt,
          state.response.details[i].netRate, //NetRate,
          state.response.details[i].amount, //Amount,
          state.response.details[i].cGSTPer, //CGSTPer,
          state.response.details[i].sGSTPer, //SGSTPer,
          state.response.details[i].iGSTPer, //IGSTPer,
          state.response.details[i].cGSTAmt, //CGSTAmt,
          state.response.details[i].sGSTAmt, //SGSTAmt,
          state.response.details[i].iGSTAmt, //IGSTAmt,
          state.response.details[i].taxRate, //AddTaxPer,
          state.response.details[i].taxAmount, //AddTaxAmt,
          state.response.details[i].netAmount, //NetAmt,
          state.response.details[i].headerDiscAmt, //HeaderDiscAmt,
          state.response.details[i].unit, //Unit,
          int.parse(edt_StateCode.text), //int StateCode,
          LoginUserID, //String LoginUserID,
          CompanyID.toString(), //String CompanyId,
        ));
      }
    }
  }
}
