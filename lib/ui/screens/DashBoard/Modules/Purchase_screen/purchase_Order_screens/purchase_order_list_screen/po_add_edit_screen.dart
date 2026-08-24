import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:soleoserp/blocs/MainBloc/mainBloc.dart';
import 'package:soleoserp/models/api_requests/SalesBill/sale_bill_email_content_request.dart';
import 'package:soleoserp/models/api_requests/SalesBill/sales_bill_inq_QT_SO_NO_list_Request.dart';
import 'package:soleoserp/models/api_requests/other/bank_name_drop_down_request.dart';
import 'package:soleoserp/models/api_requests/product/product_master_list_request.dart';
import 'package:soleoserp/models/api_requests/purchase_order_screen/Po_header_add_update_request.dart';
import 'package:soleoserp/models/api_requests/purchase_order_screen/po_details_add_upadte_request.dart';
import 'package:soleoserp/models/api_requests/purchase_order_screen/po_details_list_request.dart';
import 'package:soleoserp/models/api_requests/purchase_order_screen/po_driver_no_list_request.dart';
import 'package:soleoserp/models/api_requests/purchase_order_screen/po_shipment_list_request.dart';
import 'package:soleoserp/models/api_requests/purchase_order_screen/po_shipment_sav_request.dart';
import 'package:soleoserp/models/api_requests/purchase_order_screen/po_tanker_no_list_request.dart';
import 'package:soleoserp/models/api_requests/quotation/qt_Organization_drop_down_list_request.dart';
import 'package:soleoserp/models/api_requests/quotation/quotation_kind_att_list_request.dart';
import 'package:soleoserp/models/api_requests/quotation/quotation_other_charge_list_request.dart';
import 'package:soleoserp/models/api_requests/quotation/quotation_project_list_request.dart';
import 'package:soleoserp/models/api_requests/quotation/quotation_terms_condition_request.dart';
import 'package:soleoserp/models/api_requests/quotation/save_email_content_request.dart';
import 'package:soleoserp/models/api_requests/salesOrder/shipment/so_shipment_address_drop_down_api_request.dart';
import 'package:soleoserp/models/api_requests/salesOrder/so_currency_list_request.dart';
import 'package:soleoserp/models/api_requests/short_invoice_request/short_invoice_assembly_load_request.dart';
import 'package:soleoserp/models/api_responses/company_details/company_details_response.dart';
import 'package:soleoserp/models/api_responses/customer/customer_label_value_response.dart';
import 'package:soleoserp/models/api_responses/login/login_user_details_api_response.dart';
import 'package:soleoserp/models/api_responses/other/all_employee_List_response.dart';
import 'package:soleoserp/models/api_responses/other/city_api_response.dart';
import 'package:soleoserp/models/api_responses/other/country_list_response.dart';
import 'package:soleoserp/models/api_responses/other/state_list_response.dart';
import 'package:soleoserp/models/api_responses/purchase_oredr_screen/purchase_order_list_screen_response.dart';
import 'package:soleoserp/models/api_responses/quotation/quotation_other_charges_list_response.dart';
import 'package:soleoserp/models/api_responses/saleOrder/shipment/so_shipment_address_drop_down_api_response.dart';
import 'package:soleoserp/models/common/Short_Invoice_Table.dart';
import 'package:soleoserp/models/common/all_name_id_list.dart';
import 'package:soleoserp/models/common/generic_addtional_calculation/generic_addtional_amount_calculation.dart';
import 'package:soleoserp/models/common/purchase_order_teble.dart';
import 'package:soleoserp/models/common/sales_order_table.dart';
import 'package:soleoserp/ui/res/color_resources.dart';
import 'package:soleoserp/ui/res/image_resources.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Customer/CustomerAdd_Edit/search_city_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Customer/CustomerAdd_Edit/search_state_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Purchase_screen/purchase_Order_screens/PO_generate_via_indent/pending_po_generate_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Purchase_screen/purchase_Order_screens/addtional_charges/po_summary_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Purchase_screen/purchase_Order_screens/products/po_product_list_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/Purchase_screen/purchase_Order_screens/purchase_order_list_screen/Po_list_screens.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/inquiry/customer_search/customer_search_screen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/other_screens/dropdownscreen.dart';
import 'package:soleoserp/ui/screens/DashBoard/Modules/salesorder/SaleOrder_manan_design/country_selection.dart';
import 'package:soleoserp/ui/screens/DashBoard/home_screen.dart';
import 'package:soleoserp/ui/screens/base/base_screen.dart';
import 'package:soleoserp/ui/widgets/common_widgets.dart';
import 'package:soleoserp/utils/calculation/additional_charges_calculation.dart';
import 'package:soleoserp/utils/calculation/model/additonalChargeDetails.dart';
import 'package:soleoserp/utils/calculation/purchase_order_calculation/purchase_order_header_discount_calculation.dart';
import 'package:soleoserp/utils/calculation/sales_order_calculation/sales_order_header_discount_calculation.dart';
import 'package:soleoserp/utils/date_time_extensions.dart';
import 'package:soleoserp/utils/general_utils.dart';
import 'package:soleoserp/utils/offline_db_helper.dart';
import 'package:soleoserp/utils/sales_order_payment_schedule.dart';
import 'package:soleoserp/utils/shared_pref_helper.dart';

class POAddEditScreenArguments {
  PurchaseOrderListResponseDetails editModel;

  POAddEditScreenArguments(this.editModel);
}

class POAddEditScreen extends BaseStatefulWidget {
  static const routeName = '/POAddEditScreen';

  final POAddEditScreenArguments arguments;

  POAddEditScreen(this.arguments);

  @override
  _POAddEditScreenState createState() => _POAddEditScreenState();
}

class _POAddEditScreenState extends BaseState<POAddEditScreen>
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
  TextEditingController edt_refNo = TextEditingController();
  TextEditingController edt_exchangeRate = TextEditingController();
  TextEditingController edt_BuyresRef = TextEditingController();
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
  TextEditingController edt_KindAtt = TextEditingController();
  TextEditingController edt_KindAttID = TextEditingController();
  TextEditingController edt_CurrencyName = TextEditingController();
  TextEditingController edt_CurrencyID = TextEditingController();
  TextEditingController edt_Orgname = TextEditingController();
  TextEditingController edt_OrgID = TextEditingController();

  /// Terms And Condition
  TextEditingController edt_termsAndCondition = TextEditingController();
  TextEditingController edt_select_termsAndConditionName =
      TextEditingController();
  TextEditingController edt_select_termsAndConditionId =
      TextEditingController();

  //Shipment Address
  TextEditingController _controller_company_name = TextEditingController();
  TextEditingController _controller_GSTNO = TextEditingController();
  TextEditingController _controller_contact_no = TextEditingController();
  TextEditingController _controller_contact_person_name =
      TextEditingController();
  TextEditingController _controller_address = TextEditingController();
  TextEditingController _controller_area = TextEditingController();
  TextEditingController edt_QualifiedCountry = TextEditingController();
  TextEditingController edt_QualifiedCountryCode = TextEditingController();
  TextEditingController edt_QualifiedState = TextEditingController();
  TextEditingController edt_QualifiedStateCode = TextEditingController();
  TextEditingController edt_QualifiedCity = TextEditingController();
  TextEditingController edt_QualifiedCityCode = TextEditingController();
  TextEditingController edt_QualifiedPinCode = TextEditingController();
  TextEditingController _controller_Module_NO = TextEditingController();
  TextEditingController edt_select_emailSubjectName = TextEditingController();
  TextEditingController edt_select_emailSubject = TextEditingController();
  TextEditingController edt_select_emailSubjectID = TextEditingController();
  TextEditingController edt_grossWeight = TextEditingController();
  TextEditingController edt_licenceNO = TextEditingController();
  TextEditingController edt_tareWeight = TextEditingController();
  TextEditingController edt_NetWeight = TextEditingController();
  TextEditingController edt_driverNumber = TextEditingController();
  TextEditingController edt_driverLicenceNo = TextEditingController();
  TextEditingController edt_driverDetails = TextEditingController();
  TextEditingController edt_conductorName = TextEditingController();
  TextEditingController edt_ModOfPayment = TextEditingController();
  TextEditingController edt_TransporterName = TextEditingController();
  TextEditingController edt_Distance = TextEditingController();
  TextEditingController edt_ConsigneeName = TextEditingController();
  TextEditingController edt_ConsigneeAddress = TextEditingController();
  TextEditingController edt_ConsigneeCity = TextEditingController();
  TextEditingController edt_driverName = TextEditingController();
  TextEditingController edt_tankerNumber = TextEditingController();

  List<ALL_Name_ID> arr_ALL_Name_ID_For_Sales_Order_Bank_Name = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Sales_Order_Select_Inquiry = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Sales_Order_Sales_Executive = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Sales_Order_Select_Currency = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Terms_And_Condition = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Email_Subject = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_ProjectList = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Payment_Schedual_List = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Sales_Order_Address_DROP_DOWN = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Sales_Order_Address_ORG_DROP_DOWN = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_ModeOfTransfer = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Product = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_KindAttList = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Org = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Tamker = [];
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Driver = [];

  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  ALL_EmployeeList_Response _offlineFollowerEmployeeListData;

  int pkID = 0;
  int ExportPkID = 0;
  int ShipmentPkID = 0;
  int CompanyID = 0;
  String LoginUserID = "";
  bool isAllEditable = false;
  PurchaseOrderListResponseDetails _editModel;
  DateTime selectedInvoiceDate = DateTime.now();
  DateTime selectedLRDate = DateTime.now();
  DateTime selectedDeliveryDate = DateTime.now();
  String SalesOrderNo = "";
  final TextEditingController edt_HeaderDisc = TextEditingController();
  List<PurchaseOrderTable> _inquiryProductList = [];
  List<PurchaseOrderDetailsAddUpdateRequest> arrSOProductList = [];
  final TextEditingController edt_StateCode = TextEditingController();
  List<SoPaymentScheduleTable> arr_PaymentScheduleList = [];
  TextEditingController _controllerAmountDialog = TextEditingController();
  TextEditingController _controllerDueDateDialog = TextEditingController();
  TextEditingController _controllerRevDueDateDialog = TextEditingController();
  TextEditingController _contrller_Email_Add_Subject = TextEditingController();
  TextEditingController _contrller_Email_Add_Content = TextEditingController();
  TextEditingController _eventHour = TextEditingController();
  TextEditingController _eventMinute = TextEditingController();
  AddditionalCharges addditionalCharges = AddditionalCharges();
  bool isUpdateCalculation = false;
  double Tot_otherChargeWithTax = 0.00;
  double Tot_otherChargeExcludeTax = 0.00;

  double HeaderDisAmnt = 0.00;
  List<OtherChargeDetails> arrGenericOtheCharge = [];

  TextEditingController _controller_reapeat = TextEditingController();
  TextEditingController _controller_pickupAddressName = TextEditingController();
  TextEditingController _controller_pickupOrgName = TextEditingController();
  TextEditingController _controller_mode_of_transfer = TextEditingController();
  TextEditingController _controller_Transporter = TextEditingController();
  TextEditingController _controller_LR_NO = TextEditingController();
  TextEditingController _controller_Remarks = TextEditingController();
  TextEditingController _controller_vihical_no = TextEditingController();
  TextEditingController _controller_Delivery_Notes = TextEditingController();
  TextEditingController _controller_e_way_bill_No = TextEditingController();
  TextEditingController _controller_Mode_of_Payment = TextEditingController();
  TextEditingController _controller_DeliverTo = TextEditingController();
  TextEditingController _controller_LR_date = TextEditingController();
  TextEditingController _controller_LR_date_Reveres = TextEditingController();

  TextEditingController edt_ProductID = TextEditingController();
  TextEditingController edt_ProductName = TextEditingController();
  TextEditingController edt_TankerID = TextEditingController();
  TextEditingController edt_TankerName = TextEditingController();
  TextEditingController edt_DriverID = TextEditingController();
  TextEditingController edt_DriverName = TextEditingController();
  TextEditingController edt_RefSelectedNo = TextEditingController();

  bool isOrganatiozation = false;
  bool isLoading = false;
  int EmployeeID = 0;

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
    EmployeeID = _offlineLoggedInData.details[0].employeeID;
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
    _controller_reapeat.text = "0";

    _mainBloc.add(PaymentScheduleListEvent());

    _mainBloc.add(GenericOtherChargeCallEvent(
        CompanyID.toString(), QuotationOtherChargesListRequest(pkID: "")));

    _isForUpdate = widget.arguments != null;
    edt_select_salesBill.addListener(() {
      setState(() {
        if (edt_customerName.text != null || edt_customerName.text != "") {
          if (edt_select_salesBill.text == "Sales Bill") {}
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
          if (state is PurchaseOrderShipmentListResponseState) {
            _OnShortInvoiceShipmentListResponseState(state);
          }
          if (state is PurchaseOrderDetailsListResponseState) {
            _onShortInvoiceDetailsListResponseState(state);
          }

          if (state is ShortInvoiceProductMainListResponseState) {
            _onShortInvoiceProductMainListResponseState(state);
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
              currentState is PurchaseOrderShipmentListResponseState ||
              currentState is PurchaseOrderDetailsListResponseState ||
              currentState is ShortInvoiceProductMainListResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, MainStates state) {
          if (state is ProductMainListResponseState) {
            _onProductMainListResponseState(state);
          }
          if (state is QuotationKindAttListResponseState) {
            _OnKindAttListResponseSucess(state);
          }
          if (state is QuotationOrganizationListResponseState) {
            _onQuotationOrganizationListResponse(state);
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
          if (state is PaymentScheduleEditResponseState) {
            OnUpdatePaymentSchedule(state);
          }
          if (state is PurchaseOrderAddUpdateResponseState) {
            _onShortInvoiceAddUpdateResponseState(state);
          }
          if (state is PurchaseOrderProductSaveResponseState) {
            _OnShortInvoiceProductSaveResponseState(state);
          }
          if (state is SaveEmailContentResponseState) {
            _OnSaveEmailContentResponse(state);
          }
          if (state is SaleBillEmailContentResponseState) {
            _OnEmailContentResponse(state);
          }
          if (state is QuotationTermsCondtionResponseState) {
            _OnTermsAndConditionResponse(state);
          }
          if (state is QuotationOtherChargeListResponseState) {
            _onOtherChargeListResponse(state);
          }
          if (state is SalesOrderAddressDropDownResponseState) {
            _onSalesOrderAddressDropDownResponseState(state);
          }
          if (state is SalesOrderAddressORGDropDownResponseState) {
            _onSalesOrderAddressORGDropDownResponseState(state);
          }
          if (state is BankDetailsDialogListResponseState) {
            _onBankDialgSelection(state);
          }
          if (state is QuotationProjectListResponseState) {
            _OnProjectList(state);
          }
          if (state is PurchaseOrderShipmentAddUpdateResponseState) {
            _onShortInvoiceShipmentAddUpdateResponseState(state);
          }
          if (state is PurchaseOrderDetailsDeleteResponseState) {
            _onShortInvoiceDetailsDeleteResponseState(state);
          }
          if (state is ShortInvoiceAssemblyLoadListResponseState) {
            _onShortInvoiceAssemblyLoadListResponseState(state);
          }
          if (state is PoDriverListResponseState) {
            _onPoDriverListResponseState(state);
          }
          if (state is PoTankerListResponseState) {
            _onPoTankerListResponseState(state);
          }
          if (state is SOCurrencyListResponseState) {
            _onSOCurrencyListResponseStateSuccess(state);
          }

          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is ProductMainListResponseState ||
              currentState is QuotationKindAttListResponseState ||
              currentState is QuotationOrganizationListResponseState ||
              currentState is MultiNoToProductDetailsResponseState ||
              currentState is PaymentScheduleResponseState ||
              currentState is PaymentScheduleDeleteResponseState ||
              currentState is PaymentScheduleEditResponseState ||
              currentState is SaveEmailContentResponseState ||
              currentState is SaleBillEmailContentResponseState ||
              currentState is QuotationTermsCondtionResponseState ||
              currentState is QuotationOtherChargeListResponseState ||
              currentState is SalesOrderAddressDropDownResponseState ||
              currentState is SalesOrderAddressORGDropDownResponseState ||
              currentState is BankDetailsDialogListResponseState ||
              currentState is QuotationProjectListResponseState ||
              currentState is PurchaseOrderAddUpdateResponseState ||
              currentState is PurchaseOrderProductSaveResponseState ||
              currentState is PurchaseOrderShipmentAddUpdateResponseState ||
              currentState is ShortInvoiceAssemblyLoadListResponseState ||
              currentState is PurchaseOrderDetailsDeleteResponseState ||
              currentState is PoDriverListResponseState ||
              currentState is PoTankerListResponseState ||
              currentState is SOCurrencyListResponseState) {
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
                  navigateTo(context, PoListScreen.routeName,
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
                      navigateTo(context, HomeScreen.routeName,
                          clearAllStack: true);
                    })
              ],
              title: Text("Purchase Order ${_isForUpdate ? "Update" : "Add"}"),
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
                              emailContent(),
                              space(5),
                              ShipmentDetails(),
                              space(5),
                              shipmentAddress(),
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
    navigateTo(context, PoListScreen.routeName, clearAllStack: true);
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
                "Order Date *",
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
                "Reference Date",
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

  Widget ExchangeRate() {
    return Container(
        child: Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                "Exchange Rate",
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
                        keyboardType: TextInputType.numberWithOptions(
                            signed: true, decimal: true),
                        controller: edt_exchangeRate,
                        decoration: InputDecoration(
                          hintText: "Enter Exchange Rate",
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

  Widget BuyersRef() {
    return Container(
        child: Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                "Buyer's reference No",
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
                        keyboardType: TextInputType.text,
                        controller: edt_BuyresRef,
                        decoration: InputDecoration(
                          hintText: "Enter Buyers Ref No",
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
                "Reference No",
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
                        keyboardType: TextInputType.text,
                        controller: edt_refNo,
                        decoration: InputDecoration(
                          hintText: "Enter Ref No",
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
                "Order No",
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
              CustomDropDownKindAtt(
                "Kind Attn.",
                enable1: false,
                icon: Icon(Icons.arrow_drop_down),
                controllerVehical: edt_KindAtt,
                vehicalList: arr_ALL_Name_ID_For_KindAttList,
              ),
              SizedBox(
                height: 10,
              ),
              CustomDropDownCurrency(
                "Select Currency",
                enable1: false,
                icon: Icon(Icons.arrow_drop_down),
                controllerVehical: edt_CurrencyName,
                vehicalList: arr_ALL_Name_ID_For_Sales_Order_Select_Currency,
              ),
              SizedBox(
                height: 10,
              ),
              ExchangeRate(),
              SizedBox(
                height: 10,
              ),
              SerialNO(),
              SizedBox(
                height: 10,
              ),
              _buildPIDate(),
              SizedBox(
                height: 10,
              ),
              BuyersRef(),
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
              _isForUpdate == false
                  ? Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 40),
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            child: Text(
                              "Show Pending Indent",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            onPressed: () async {
                              if (edt_customerName.text != "") {
                                navigateTo(context,
                                    PendingPoForIndentListScreen.routeName,
                                    arguments:
                                        PendingPoForIndentListScreenArguments(
                                            edt_StateCode.text));
                              } else {
                                showCommonDialogWithSingleOption(
                                    context, "Customer Name Is Required!!",
                                    positiveButtonTitle: "OK",
                                    onTapOfPositiveButton: () {
                                  Navigator.of(context).pop();
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
      ),
      // height: 60,
    );
  }

  Widget CustomDropDownForRef(
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
                  _mainBloc.add(SaleBill_INQ_QT_SO_NO_ListRequestEvent(
                      SaleBill_INQ_QT_SO_NO_ListRequest(
                          CompanyId: CompanyID.toString(),
                          CustomerID: edt_customerID.text.toString(),
                          ModuleType: "SalesBill")));
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
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      "Inquiry No",
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

  Widget CustomDropDownKindAtt(
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
                  _mainBloc.add(QuotationKindAttListCallEvent(
                      QuotationKindAttListApiRequest(
                          CompanyId: CompanyID.toString(),
                          CustomerID: edt_customerID.text)));
                } else {
                  showCommonDialogWithSingleOption(
                      context, "Customer Name is Required!",
                      positiveButtonTitle: "OK", onTapOfPositiveButton: () {
                    Navigator.pop(context);
                  });
                }
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
                          edt_KindAtt.text != ""
                              ? InkWell(
                                  onTap: () {
                                    edt_KindAtt.text = "";
                                    edt_KindAttID.text = "0";
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

  void _OnKindAttListResponseSucess(QuotationKindAttListResponseState state) {
    arr_ALL_Name_ID_For_KindAttList.clear();
    if (state.response.details.length != 0) {
      for (var i = 0; i < state.response.details.length; i++) {
        ALL_Name_ID categoryResponse123 = ALL_Name_ID();
        categoryResponse123.Name = state.response.details[i].contactPerson1;
        categoryResponse123.pkID = state.response.details[i].customerID;
        arr_ALL_Name_ID_For_KindAttList.add(categoryResponse123);
      }

      if (arr_ALL_Name_ID_For_KindAttList.length != 0) {
        navigateTo(context, VehicleListDropDownScreen.routeName,
                arguments: VehicleListDropDownScreenArgument(
                    arr_ALL_Name_ID_For_KindAttList,
                    "Types Of KindAttn List",
                    "Three Chars To Search KindAttn",
                    "Tap To Enter KindAttn"))
            .then((value) {
          if (value.toString() == "clear") {
            edt_KindAtt.text = "";
            edt_KindAttID.text = "0";
          } else {
            ALL_Name_ID model = value;
            edt_KindAtt.text = model.Name;
            edt_KindAttID.text = model.pkID.toString();
          }

          setState(() {});
        });
      }
    }
  }

  Widget CustomDropDownCurrency(
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
                _mainBloc.add(SOCurrencyListRequestEvent(SOCurrencyListRequest(
                    LoginUserID: LoginUserID,
                    CurrencyName: "",
                    CompanyID: CompanyID.toString())));
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
                          edt_CurrencyName.text != ""
                              ? InkWell(
                                  onTap: () {
                                    edt_CurrencyName.text = "";
                                    edt_CurrencyID.text = "0";
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

  void _onSOCurrencyListResponseStateSuccess(
      SOCurrencyListResponseState state) {
    arr_ALL_Name_ID_For_Sales_Order_Select_Currency.clear();
    if (state.response.details.length != 0) {
      for (var i = 0; i < state.response.details.length; i++) {
        ALL_Name_ID categoryResponse123 = ALL_Name_ID();
        categoryResponse123.Name = state.response.details[i].currencyName;
        categoryResponse123.Name1 = state.response.details[i].currencySymbol;
        arr_ALL_Name_ID_For_Sales_Order_Select_Currency
            .add(categoryResponse123);
      }

      if (arr_ALL_Name_ID_For_Sales_Order_Select_Currency.length != 0) {
        navigateTo(context, VehicleListDropDownScreen.routeName,
                arguments: VehicleListDropDownScreenArgument(
                    arr_ALL_Name_ID_For_Sales_Order_Select_Currency,
                    "Types Of Currency List",
                    "Three Chars To Search Currency",
                    "Tap To Enter Currency"))
            .then((value) {
          if (value.toString() == "clear") {
            edt_CurrencyName.text = "";
            edt_CurrencyID.text = "";
          } else {
            ALL_Name_ID model = value;
            edt_CurrencyName.text = model.Name;
            edt_CurrencyID.text = model.Name1;
          }

          setState(() {});
        });
      }
    }
  }

  Widget CustomDropDownOrg(
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
                _mainBloc.add(QuotationOrganizationListRequestEvent(
                    QuotationOrganazationListRequest(
                        CompanyID: CompanyID.toString(),
                        LoginUserID: LoginUserID)));
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
                          edt_Orgname.text != ""
                              ? InkWell(
                                  onTap: () {
                                    edt_Orgname.text = "";
                                    edt_OrgID.text = "";
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

  void _onQuotationOrganizationListResponse(
      QuotationOrganizationListResponseState state) {
    arr_ALL_Name_ID_For_Org.clear();
    if (state.quotationOrganizationListResponse.details.length != 0) {
      for (var i = 0;
          i < state.quotationOrganizationListResponse.details.length;
          i++) {
        if (state.quotationOrganizationListResponse.details[i].activeFlag ==
            true) {
          ALL_Name_ID all_name_id = ALL_Name_ID();
          all_name_id.Name =
              state.quotationOrganizationListResponse.details[i].orgName;
          all_name_id.Name1 =
              state.quotationOrganizationListResponse.details[i].orgCode;
          arr_ALL_Name_ID_For_Org.add(all_name_id);
        }
      }

      if (arr_ALL_Name_ID_For_Org.length != 0) {
        navigateTo(context, VehicleListDropDownScreen.routeName,
                arguments: VehicleListDropDownScreenArgument(
                    arr_ALL_Name_ID_For_Org,
                    "Types Of Org List",
                    "Three Chars To Search Org",
                    "Tap To Enter Org"))
            .then((value) {
          if (value.toString() == "clear") {
            edt_Orgname.text = "";
            edt_OrgID.text = "";
          } else {
            ALL_Name_ID model = value;
            edt_Orgname.text = model.Name;
            edt_OrgID.text = model.Name1.toString();
          }

          setState(() {});
        });
      }
    }
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
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
          }

          setState(() {});
        });
      }
    }
  }

  productDetails() {
    return Container(
        margin: EdgeInsets.all(10),
        child: getCommonButton(baseTheme, () {
          if (edt_customerName.text != "") {
            navigateTo(context, POProductListScreen.routeName,
                arguments: POProductListArgument(
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
    List<PurchaseOrderTable> temp =
        await OfflineDbHelper.getInstance().getPurchaseOrderProduct();
    print("Prodiuucy" + temp.length.toString());
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

  ///-------------------- Emails Content Start-----------------

  Widget emailContent() {
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
            "Email Content",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          leading: ClipRRect(
            child: Image.asset(
              EMAIL,
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
                  _buildRowWithTwoFields(
                    leftLabel: "Select Email Contents",
                    rightLabel: "Add New",
                    leftWidget: CustomDropDownEmails(
                      "Select Email Contents",
                      enable1: false,
                      icon: const Icon(Icons.arrow_drop_down),
                      controllerVehical: edt_select_emailSubjectName,
                      vehicalList: arr_ALL_Name_ID_For_Email_Subject,
                    ),
                    rightWidget: SizedBox(
                      height: 42,
                      child: FloatingActionButton(
                        onPressed: () {
                          showcustomdialogEmailContent(
                            context1: context,
                            Email: "sdfj",
                          );
                        },
                        child: const Icon(Icons.add, size: 20),
                        backgroundColor: Colors.pinkAccent,
                        heroTag: null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSingleField("Subject", Subject()),
                  const SizedBox(height: 12),
                  _buildSingleField("Introduction", EmailIntroduction()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget CustomDropDownEmails(
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
                _mainBloc.add(SalesBillEmailContentRequestEvent(
                    SalesBillEmailContentRequest(
                        CompanyId: CompanyID.toString(),
                        LoginUserID: LoginUserID)));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    elevation: 10,
                    color: colorWhite,
                    shadowColor: colorPrimary,
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
                          edt_select_emailSubjectName.text != ""
                              ? InkWell(
                                  onTap: () {
                                    edt_select_emailSubjectName.text = "";
                                    edt_select_termsAndConditionId.text = "0";
                                    edt_select_emailSubject.text = "";
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

  void _OnEmailContentResponse(SaleBillEmailContentResponseState state) {
    arr_ALL_Name_ID_For_Email_Subject.clear();
    if (state.response.details.length != 0) {
      for (var i = 0; i < state.response.details.length; i++) {
        ALL_Name_ID all_name_id = ALL_Name_ID();
        all_name_id.Name = state.response.details[i].subject;
        all_name_id.pkID = state.response.details[i].pkID;
        all_name_id.Name1 = state.response.details[i].contentData;
        arr_ALL_Name_ID_For_Email_Subject.add(all_name_id);
      }

      if (arr_ALL_Name_ID_For_Email_Subject.length != 0) {
        navigateTo(context, VehicleListDropDownScreen.routeName,
                arguments: VehicleListDropDownScreenArgument(
                    arr_ALL_Name_ID_For_Email_Subject,
                    "Types Of Email Contents",
                    "Three Chars To Search Email Contents",
                    "Tap To Enter Email Contents"))
            .then((value) {
          if (value.toString() == "clear") {
            edt_select_emailSubjectName.text = "";
            edt_select_emailSubjectID.text = "0";
            edt_select_emailSubject.text = "";
          } else {
            ALL_Name_ID model = value;
            edt_select_emailSubjectName.text = model.Name;
            edt_select_emailSubjectID.text = model.pkID.toString();
            edt_select_emailSubject.text = model.Name1;
          }

          setState(() {});
        });
      }
    } else {
      showCommonDialogWithSingleOption(context, "Projects is Empty !",
          positiveButtonTitle: "OK");
    }
  }

  Widget Subject() {
    return Container(
        child: Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              margin: EdgeInsets.symmetric(horizontal: 10),
              elevation: 10,
              color: colorWhite,
              shadowColor: colorPrimary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Container(
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        textInputAction: TextInputAction.next,
                        controller: edt_select_emailSubjectName,
                        decoration: InputDecoration(
                          hintText: "Email Subject",
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

  Widget EmailIntroduction() {
    return Container(
        child: Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              margin: EdgeInsets.symmetric(horizontal: 10),
              elevation: 10,
              color: colorWhite,
              shadowColor: colorPrimary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Container(
                height: 120,
                padding: EdgeInsets.only(left: 10, right: 10),
                width: double.maxFinite,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextField(
                          controller: edt_select_emailSubject,
                          keyboardType: TextInputType.multiline,
                          maxLines: 5,
                          decoration: InputDecoration(
                            counterText: "",
                            hintText: "Tap to enter Email Intro",
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
                  _buildRowWithTwoFields(
                    leftLabel: "Vehicle No.",
                    rightLabel: "Delivery Note",
                    leftWidget: createTextFormField(
                      _controller_vihical_no,
                      "Vehicle No.",
                      keyboardInput: TextInputType.text,
                    ),
                    rightWidget: createTextFormField(
                      _controller_Delivery_Notes,
                      "Delivery Note",
                      keyboardInput: TextInputType.text,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildRowWithTwoFields(
                    leftLabel: "e-Way Bill No.",
                    rightLabel: "Mode Of Payment",
                    leftWidget: createTextFormField(
                      _controller_e_way_bill_No,
                      "Bill No.",
                      keyboardInput: TextInputType.text,
                    ),
                    rightWidget: createTextFormField(
                      _controller_Mode_of_Payment,
                      "Mode Of Payment",
                      keyboardInput: TextInputType.text,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildRowWithTwoFields(
                    leftLabel: "Deliver To",
                    rightLabel: "Delivery Date",
                    leftWidget: createTextFormField(
                      _controller_DeliverTo,
                      "Deliver To",
                      keyboardInput: TextInputType.text,
                    ),
                    rightWidget: _buildDeliveryDate(),
                  ),
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

  ///-------------------- Shipment Details Start-----------------

  Widget ShipmentDetails() {
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
            "Shipment Detail",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          leading:
              const Icon(Icons.local_shipping_outlined, color: Colors.white),
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(15)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              child: Column(
                children: [
                  _buildSingleField(
                    "Tanker Name",
                    CustomDropDownTanker(
                      "",
                      enable1: false,
                      icon: Icon(Icons.arrow_drop_down),
                      controllerVehical: edt_TankerName,
                      vehicalList: arr_ALL_Name_ID_For_Tamker,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildRowWithTwoFields(
                    leftLabel: "gross Weight",
                    rightLabel: "Licence Number",
                    leftWidget: createTextFormField(
                      edt_grossWeight,
                      "Enter gross weight",
                    ),
                    rightWidget: createTextFormField(
                      edt_licenceNO,
                      "Enter net weight",
                      keyboardInput: TextInputType.text,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildRowWithTwoFields(
                    leftLabel: "tare Weight(ULW)",
                    rightLabel: "Net Weight(capacity)",
                    leftWidget: createTextFormField(
                      edt_tareWeight,
                      "Enter tare weight",
                    ),
                    rightWidget: createTextFormField(
                      edt_NetWeight,
                      "Enter net weight",
                      keyboardInput: TextInputType.text,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildSingleField(
                    "Driver Name",
                    CustomDropDownDriver(
                      "",
                      enable1: false,
                      icon: Icon(Icons.arrow_drop_down),
                      controllerVehical: edt_DriverName,
                      vehicalList: arr_ALL_Name_ID_For_Driver,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildRowWithTwoFields(
                    leftLabel: "Driver No",
                    rightLabel: "D.Licence No",
                    leftWidget: createTextFormField(
                      edt_driverNumber,
                      "Enter driver no",
                      keyboardInput: TextInputType.text,
                    ),
                    rightWidget: createTextFormField(
                      edt_driverLicenceNo,
                      "Enter d.Licence No",
                      keyboardInput: TextInputType.text,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildRowWithTwoFields(
                    leftLabel: "Driver Details",
                    rightLabel: "Conductor Name",
                    leftWidget: createTextFormField(
                      edt_driverDetails,
                      "Enter driver details.",
                    ),
                    rightWidget: createTextFormField(
                      edt_conductorName,
                      "Enter conductor name",
                      keyboardInput: TextInputType.text,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildRowWithTwoFields(
                    leftLabel: "Mod Of Payment",
                    rightLabel: "Transporter Name",
                    leftWidget: createTextFormField(
                      edt_ModOfPayment,
                      "Enter Mod Of Payment",
                      keyboardInput: TextInputType.text,
                    ),
                    rightWidget: createTextFormField(
                      edt_TransporterName,
                      "Enter Transporter Name",
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildRowWithTwoFields(
                    leftLabel: "Distance",
                    rightLabel: "Consignee Name",
                    leftWidget: createTextFormField(
                      edt_Distance,
                      "Enter distance",
                    ),
                    rightWidget: createTextFormField(
                      edt_ConsigneeName,
                      "Enter Consignee Name",
                      keyboardInput: TextInputType.text,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildRowWithTwoFields(
                    leftLabel: "Consignee Address",
                    rightLabel: "Consignee City",
                    leftWidget: createTextFormField(
                      edt_ConsigneeAddress,
                      "Enter consignee address",
                    ),
                    rightWidget: createTextFormField(
                      edt_ConsigneeCity,
                      "Enter Consignee City",
                      keyboardInput: TextInputType.text,
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

  Widget CustomDropDownTanker(
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
                _mainBloc.add(PoTankerDrpListRequestEvent(POTankerListRequest(
                    pkID: "0",
                    PageNo: "1",
                    PageSize: "100000",
                    LoginUserID: LoginUserID,
                    CompanyId: CompanyID.toString())));
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
                          edt_TankerName.text != ""
                              ? InkWell(
                                  onTap: () {
                                    edt_TankerName.text = "";
                                    edt_TankerID.text = "0";
                                    edt_grossWeight.text = "0.00";
                                    edt_tareWeight.text = "0.00";
                                    edt_NetWeight.text = "0.00";
                                    edt_licenceNO.text = "";
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

  void _onPoTankerListResponseState(PoTankerListResponseState state) {
    arr_ALL_Name_ID_For_Tamker.clear();
    if (state.poTankerListResponse.details.length != 0) {
      for (var i = 0; i < state.poTankerListResponse.details.length; i++) {
        ALL_Name_ID categoryResponse123 = ALL_Name_ID();
        categoryResponse123.Name =
            state.poTankerListResponse.details[i].registrationNo;
        categoryResponse123.pkID = state.poTankerListResponse.details[i].pkID;
        categoryResponse123.DoubleName =
            state.poTankerListResponse.details[i].grossWeight;
        categoryResponse123.DoubleName1 =
            state.poTankerListResponse.details[i].tareWeight;
        categoryResponse123.DoubleName2 =
            state.poTankerListResponse.details[i].netWeight;
        categoryResponse123.Name1 =
            state.poTankerListResponse.details[i].licenseNo;
        arr_ALL_Name_ID_For_Tamker.add(categoryResponse123);
      }

      if (arr_ALL_Name_ID_For_Tamker.length != 0) {
        navigateTo(context, VehicleListDropDownScreen.routeName,
                arguments: VehicleListDropDownScreenArgument(
                    arr_ALL_Name_ID_For_Tamker,
                    "Types Of Tanker List",
                    "Three Chars To Search Tanker",
                    "Tap To Enter Tanker"))
            .then((value) {
          if (value.toString() == "clear") {
            edt_TankerName.text = "";
            edt_TankerID.text = "0";
            edt_grossWeight.text = "0.00";
            edt_tareWeight.text = "0.00";
            edt_NetWeight.text = "0.00";
            edt_licenceNO.text = "";
          } else {
            ALL_Name_ID model = value;
            edt_TankerName.text = model.Name;
            edt_TankerID.text = model.pkID.toString();
            edt_grossWeight.text = model.DoubleName.toString();
            edt_tareWeight.text = model.DoubleName1.toString();
            edt_NetWeight.text = model.DoubleName2.toString();
            edt_licenceNO.text = model.Name1;
          }

          setState(() {});
        });
      }
    }
  }

  Widget CustomDropDownDriver(
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
                  _mainBloc.add(PoDriverDrpListRequestEvent(PODriverListRequest(
                      pkID: "0",
                      ListMode: "",
                      PageNo: "1",
                      PageSize: "100000",
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
                          edt_DriverName.text != ""
                              ? InkWell(
                                  onTap: () {
                                    edt_DriverName.text = "";
                                    edt_driverNumber.text = "";
                                    edt_DriverID.text = "0";
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

  void _onPoDriverListResponseState(PoDriverListResponseState state) {
    arr_ALL_Name_ID_For_Driver.clear();
    if (state.poDriverListResponse.details.length != 0) {
      for (var i = 0; i < state.poDriverListResponse.details.length; i++) {
        ALL_Name_ID categoryResponse123 = ALL_Name_ID();
        categoryResponse123.Name =
            state.poDriverListResponse.details[i].employeeName;
        categoryResponse123.pkID = state.poDriverListResponse.details[i].pkID;
        categoryResponse123.Name1 =
            state.poDriverListResponse.details[i].mobileNo;
        arr_ALL_Name_ID_For_Driver.add(categoryResponse123);
      }

      if (arr_ALL_Name_ID_For_Driver.length != 0) {
        navigateTo(context, VehicleListDropDownScreen.routeName,
                arguments: VehicleListDropDownScreenArgument(
                    arr_ALL_Name_ID_For_Driver,
                    "Types Of Driver List",
                    "Three Chars To Search Driver",
                    "Tap To Enter Driver"))
            .then((value) {
          if (value.toString() == "clear") {
            edt_DriverName.text = "";
            edt_driverNumber.text = "";
            edt_DriverID.text = "0";
          } else {
            ALL_Name_ID model = value;
            edt_DriverName.text = model.Name;
            edt_driverNumber.text = model.Name1;
            edt_DriverID.text = model.pkID.toString();
          }

          setState(() {});
        });
      }
    }
  }

  ///-------------------- Shipment Address Complete-----------------

  Widget shipmentAddress() {
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
            "Shipment Address",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          leading: const Icon(Icons.location_on, color: Colors.white),
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(15)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              child: Column(
                children: [
                  _buildSingleField(
                      "Pickup Address From", _BuildAddressDropDown()),
                  const SizedBox(height: 8),
                  if (isOrganatiozation)
                    _buildSingleField(
                        "Pickup Org. Address", _BuildOrgDropDown()),
                  if (isOrganatiozation) const SizedBox(height: 8),
                  _buildSingleField(
                    "Company Name",
                    createTextFormField(
                      _controller_company_name,
                      "Company Name",
                      keyboardInput: TextInputType.text,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildSingleField(
                    "Contact Person Name",
                    createTextFormField(
                      _controller_contact_person_name,
                      "Contact Person Name",
                      keyboardInput: TextInputType.text,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildRowWithTwoFields(
                    leftLabel: "Contact No.",
                    rightLabel: "GST No.",
                    leftWidget: createTextFormField(
                      _controller_contact_no,
                      "Enter Contact No.",
                    ),
                    rightWidget: createTextFormField(
                      _controller_GSTNO,
                      "Enter GST No.",
                      keyboardInput: TextInputType.text,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildSingleField(
                    "Address",
                    createTextFormField(
                      _controller_address,
                      "Enter Address",
                      minLines: 2,
                      maxLines: 5,
                      keyboardInput: TextInputType.text,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildSingleField(
                    "Area",
                    createTextFormField(
                      _controller_area,
                      "Enter Area",
                      keyboardInput: TextInputType.text,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(flex: 1, child: QualifiedCountry()),
                      SizedBox(width: 10),
                      Expanded(flex: 1, child: QualifiedState()),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(flex: 1, child: QualifiedCity()),
                      SizedBox(width: 10),
                      Expanded(flex: 1, child: QualifiedPinCode()),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
                    List<PurchaseOrderTable> temp =
                        await OfflineDbHelper.getInstance()
                            .getPurchaseOrderProduct();

                    if (temp.length != 0) {
                      showCommonDialogWithTwoOptions(context,
                          "Are you sure you want to Save this Record ?",
                          negativeButtonTitle: "No", positiveButtonTitle: "Yes",
                          onTapOfPositiveButton: () async {
                        Navigator.of(context).pop();

                        if (SalesOrderNo != '') {
                          _mainBloc.add(PurchaseOrderDetailsDeleteCallEvent(
                              PurchaseOrderDetailsListRequest(
                                  OrderNo: SalesOrderNo,
                                  CompanyId: CompanyID.toString())));
                        } else {
                          print("Add");
                        }

                        HeaderDisAmnt = edt_HeaderDisc.text.isNotEmpty
                            ? double.parse(edt_HeaderDisc.text)
                            : 0.00;

                        List<PurchaseOrderTable> TempproductList1 =
                            PurchaseOrderHeaderDiscountCalculation
                                .txtHeadDiscount_WithZero(
                                    temp,
                                    HeaderDisAmnt,
                                    _offlineLoggedInData.details[0].stateCode
                                        .toString(),
                                    edt_StateCode.text.toString());

                        List<PurchaseOrderTable> TempproductList =
                            PurchaseOrderHeaderDiscountCalculation
                                .txtHeadDiscount_TextChanged(
                                    TempproductList1,
                                    HeaderDisAmnt,
                                    _offlineLoggedInData.details[0].stateCode
                                        .toString(),
                                    edt_StateCode.text.toString());

                        for (int i = 0; i < temp.length; i++) {
                          print("productList" +
                              " AmountFromProductList : " +
                              temp[i].DiscountPercent.toString() +
                              " NetAmountFromProductList : " +
                              temp[i].DiscountAmt.toString() +
                              " NetRate : " +
                              temp[i].NetRate.toString() +
                              " BasicAmount : " +
                              temp[i].Amount.toString() +
                              " NetAmnount : " +
                              temp[i].NetAmount.toString());
                        }

                        for (int i = 0; i < TempproductList1.length; i++) {
                          print("TempproductList1" +
                              " AmountCalculation : " +
                              TempproductList1[i].DiscountPercent.toString() +
                              " NetAmountCalculation : " +
                              TempproductList1[i].DiscountAmt.toString() +
                              " NetRate : " +
                              TempproductList1[i].NetRate.toString() +
                              " BasicAmount : " +
                              TempproductList1[i].Amount.toString() +
                              " NetAmount : " +
                              TempproductList1[i].NetAmount.toString());
                        }

                        for (int i = 0; i < TempproductList.length; i++) {
                          print("TempproductList" +
                              " AmountCalculation : " +
                              TempproductList[i].DiscountPercent.toString() +
                              " NetAmountCalculation : " +
                              TempproductList[i].DiscountAmt.toString() +
                              " NetRate : " +
                              TempproductList[i].NetRate.toString() +
                              " BasicAmount : " +
                              TempproductList[i].Amount.toString() +
                              " NetAmount : " +
                              TempproductList[i].NetAmount.toString());
                        }

                        List<double> finalPrice =
                            UpdateHeaderDiscountCalculationNew(TempproductList);

                        _mainBloc.add(PurchaseOrderAddUpdateRequestEvent(
                          context,
                          PurchaseOrderAddUpdateRequest(
                            pkID: pkID,
                            OrderNo: edt_invoiceNo.text,
                            OrderDate: edt_rev_invoiceDate.text,
                            CustomerID: edt_customerID.text,
                            QuotationNo: "",
                            ReferenceDate: edt_rev_dispatchDate.text,
                            InquiryNo: "",
                            BuyerRef: edt_BuyresRef.text,
                            BillNo: "",
                            TermsCondition: edt_termsAndCondition.text,
                            EmployeeID: EmployeeID.toString(),
                            ApprovalStatus: "",
                            EmailHeader: edt_select_emailSubjectName.text,
                            EmailContent: edt_select_emailSubject.text,
                            ProjectName: edt_projectName.text,
                            PatientName: "",
                            PatientType: "",
                            FinalAmount: "0.00",
                            Percentage: "0.00",
                            EstimatedAmt: "0.00",
                            BasicAmt: finalPrice[0].toStringAsFixed(2),
                            DiscountPer: addditionalCharges.DisPer == null
                                ? "0.00"
                                : addditionalCharges.DisPer,
                            DiscountAmt: addditionalCharges.DiscountAmt,
                            SGSTAmt: finalPrice[4].toStringAsFixed(2),
                            CGSTAmt: finalPrice[3].toStringAsFixed(2),
                            IGSTAmt: finalPrice[5].toStringAsFixed(2),
                            ROffAmt: finalPrice[18].toStringAsFixed(2),
                            TankerNo: edt_tankerNumber.text,
                            Gross_Weight: edt_grossWeight.text == ""
                                ? "0.00"
                                : edt_grossWeight.text,
                            Tare_Weight: edt_tareWeight.text == ""
                                ? "0.00"
                                : edt_tareWeight.text,
                            Net_Weight: edt_NetWeight.text == ""
                                ? "0.00"
                                : edt_NetWeight.text,
                            LicenseNo: edt_licenceNO.text,
                            DriverDetails: edt_driverDetails.text,
                            DriverName: edt_driverName.text,
                            DrivingLicenseNo: edt_driverLicenceNo.text,
                            DriverNumber: edt_driverNumber.text,
                            ConductorName: edt_conductorName.text,
                            ModeOfPayment: edt_ModOfPayment.text,
                            TransporterName: edt_TransporterName.text,
                            ConsigneeName: edt_ConsigneeName.text,
                            ConsigneeAddress: edt_ConsigneeAddress.text,
                            ConsigneeCity: edt_ConsigneeCity.text,
                            TripDistance: edt_Distance.text,
                            DeliveryNote: "",
                            ChargeID1: addditionalCharges.ChargeID1,
                            ChargeAmt1: addditionalCharges.ChargeAmt1,
                            ChargeBasicAmt1: addditionalCharges.ChargeBasicAmt1,
                            ChargeGSTAmt1: addditionalCharges.ChargeGSTAmt1,
                            ChargeID2: addditionalCharges.ChargeID2,
                            ChargeAmt2: addditionalCharges.ChargeAmt2,
                            ChargeBasicAmt2: addditionalCharges.ChargeBasicAmt2,
                            ChargeGSTAmt2: addditionalCharges.ChargeGSTAmt2,
                            ChargeID3: addditionalCharges.ChargeID3,
                            ChargeAmt3: addditionalCharges.ChargeAmt3,
                            ChargeBasicAmt3: addditionalCharges.ChargeBasicAmt3,
                            ChargeGSTAmt3: addditionalCharges.ChargeGSTAmt3,
                            ChargeID4: addditionalCharges.ChargeID4,
                            ChargeAmt4: addditionalCharges.ChargeAmt4,
                            ChargeBasicAmt4: addditionalCharges.ChargeBasicAmt4,
                            ChargeGSTAmt4: addditionalCharges.ChargeGSTAmt4,
                            ChargeID5: addditionalCharges.ChargeID5,
                            ChargeAmt5: addditionalCharges.ChargeAmt5,
                            ChargeBasicAmt5: addditionalCharges.ChargeBasicAmt5,
                            ChargeGSTAmt5: addditionalCharges.ChargeGSTAmt5,
                            ChargePer1: addditionalCharges.ChargePer1,
                            ChargePer2: addditionalCharges.ChargePer2,
                            ChargePer3: addditionalCharges.ChargePer3,
                            ChargePer4: addditionalCharges.ChargePer4,
                            ChargePer5: addditionalCharges.ChargePer5,
                            NetAmt: finalPrice[17].toStringAsFixed(2),
                            AdvancePer: addditionalCharges.AdvancePer,
                            AdvanceAmt: addditionalCharges.AdvanceAmt,
                            CurrencyName: edt_CurrencyName.text,
                            CurrencySymbol: edt_CurrencyID.text,
                            ExchangeRate: edt_exchangeRate.text == ""
                                ? "0.00"
                                : edt_exchangeRate.text,
                            InvoiceNo: "",
                            InvoiceDate: "",
                            LRNo: "",
                            LRDate: "",
                            EwayBillNo: "",
                            EwayBillDate: "",
                            POKindAttn: edt_KindAtt.text,
                            OrgCode: edt_OrgID.text,
                            LoginUserID: LoginUserID,
                            RefType: "",
                            CompanyId: CompanyID.toString(),
                          ),
                        ));
                      });
                    } else {
                      showCommonDialogWithSingleOption(
                          context, "ProductDetails is required !",
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
      List<ShortInvoiceTable> tempproductList,
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
      List<PurchaseOrderTable> tempproductList) {
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
        Tot_GSTAmt += tempproductList[i].TaxAmount;
        Tot_CGSTAmt += tempproductList[i].CGSTAmt;
        Tot_SGSTAmt += tempproductList[i].SGSTAmt;
        Tot_IGSTAmt += tempproductList[i].IGSTAmt;

        Tot_otherChargeExcludeTax = 0.00;

        ///AFTER gst
        Tot_NetAmt += tempproductList[i].NetAmount;
      }

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

      /*double advper = addditionalCharges.AdvancePer == "" ||
              addditionalCharges.AdvancePer == "null"
          ? 0.00
          : double.parse(addditionalCharges.AdvancePer);*/

      //double tot_amt = netAmountController * advper;
      /*double advamnt = addditionalCharges.AdvanceAmt == "" ||
              addditionalCharges.AdvanceAmt == "null"
          ? tot_amt / 100
          : double.parse(addditionalCharges.AdvanceAmt);*/

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

  Widget QualifiedCountry() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Country *",
              style: TextStyle(
                  fontSize: 10,
                  color: colorBlack,
                  fontWeight: FontWeight.bold)),
        ),
        InkWell(
            onTap: () => _onTapOfSearchCountryView(
                _searchDetails == null ? "" : _searchDetails.countryCode),
            child: Card(
              elevation: 10,
              color: colorWhite,
              shadowColor: colorPrimary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                width: double.maxFinite,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                          enabled: false,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          controller: edt_QualifiedCountry,
                          decoration: InputDecoration(
                            hintText: "Country",
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
                    Icon(Icons.arrow_drop_down_outlined)
                  ],
                ),
              ),
            )),
      ],
    );
  }

  Future<void> _onTapOfSearchCountryView(String sw) async {
    edt_QualifiedState.text = "";
    edt_QualifiedStateCode.text = "0";
    edt_QualifiedCity.text = "";
    edt_QualifiedCityCode.text = "0";
    edt_QualifiedPinCode.text = "";
    navigateTo(context, SearchCountryForGreenEdgeScreen.routeName,
            arguments: SearchCountryForGreenEdgeScreenArguments(sw))
        .then((value) {
      if (value != null) {
        _searchDetails = SearchCountryDetails();
        _searchDetails = value;
        print("CountryName IS From SearchList" + _searchDetails.countryCode);
        edt_QualifiedCountryCode.text = _searchDetails.countryCode;
        edt_QualifiedCountry.text = _searchDetails.countryName;
      }
    });
  }

  Widget QualifiedState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("State * ",
              style: TextStyle(
                  fontSize: 10,
                  color: colorBlack,
                  fontWeight: FontWeight.bold)),
        ),
        InkWell(
          onTap: () {
            _onTapOfSearchStateView(edt_QualifiedCountryCode.text);
          },
          child: Card(
            elevation: 10,
            color: colorWhite,
            shadowColor: colorPrimary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                        enabled: false,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        controller: edt_QualifiedState,
                        decoration: InputDecoration(
                          hintText: "State",
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
                  Icon(Icons.arrow_drop_down_outlined)
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Future<void> _onTapOfSearchStateView(String sw1) async {
    navigateTo(context, SearchStateScreen.routeName,
            arguments: StateArguments(sw1))
        .then((value) {
      if (value != null) {
        _searchStateDetails = value;
        edt_QualifiedStateCode.text = _searchStateDetails.value.toString();
        edt_QualifiedState.text = _searchStateDetails.label.toString();
      }
    });
  }

  Widget QualifiedCity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("City * ",
              style: TextStyle(
                  fontSize: 10,
                  color: colorBlack,
                  fontWeight: FontWeight
                      .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

              ),
        ),
        InkWell(
          onTap: () {
            _onTapOfSearchCityView(edt_QualifiedStateCode.text);
          },
          child: Card(
            elevation: 10,
            color: colorWhite,
            shadowColor: colorPrimary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                        enabled: false,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        controller: edt_QualifiedCity,
                        decoration: InputDecoration(
                          //contentPadding: EdgeInsets.only(bottom: 10),

                          hintText: "City",
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
                  Icon(Icons.arrow_drop_down_outlined)
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Future<void> _onTapOfSearchCityView(String talukaCode) async {
    navigateTo(context, SearchCityScreen.routeName,
            arguments: CityArguments(talukaCode))
        .then((value) {
      if (value != null) {
        _searchCityDetails = value;
        edt_QualifiedCityCode.text = _searchCityDetails.cityCode.toString();
        edt_QualifiedCity.text = _searchCityDetails.cityName.toString();
      }
    });
  }

  Widget QualifiedPinCode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("PinCode",
              style: TextStyle(
                  fontSize: 10,
                  color: colorBlack,
                  fontWeight: FontWeight.bold)),
        ),
        Card(
          elevation: 10,
          color: colorWhite,
          shadowColor: colorPrimary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                      maxLength: 6,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      controller: edt_QualifiedPinCode,
                      decoration: InputDecoration(
                        counterText: "",
                        hintText: "PinCode",
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
        )
      ],
    );
  }

  void fillData() async {
    setState(() => isLoading = true); // Show loader

    try {
      pkID = _editModel.pkID;
      edt_invoiceNo.text = _editModel.orderNo?.toString() ?? '';
      edt_invoiceDate.text = _editModel.orderDate?.getFormattedDate(
              fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy") ??
          '';
      edt_rev_invoiceDate.text = _editModel.orderDate?.getFormattedDate(
              fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd") ??
          '';
      edt_customerName.text = _editModel.customerName ?? '';
      edt_customerID.text = _editModel.customerID?.toString() ?? '';
      edt_HeaderDisc.text = _editModel.discountAmt?.toString() ?? '';
      edt_termsAndCondition.text = _editModel.termsCondition ?? '';
      edt_refNo.text = _editModel.refNo ?? '';
      edt_CurrencyName.text = _editModel.currencyName ?? '';
      edt_CurrencyID.text = _editModel.currencySymbol ?? '';
      edt_dispatchDate.text = _editModel.referenceDate?.getFormattedDate(
              fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "dd-MM-yyyy") ??
          '';
      edt_rev_dispatchDate.text = _editModel.referenceDate?.getFormattedDate(
              fromFormat: "yyyy-MM-ddTHH:mm:ss", toFormat: "yyyy-MM-dd") ??
          '';
      edt_exchangeRate.text = _editModel.exchangeRate.toString();
      edt_BuyresRef.text = _editModel.buyerRef;
      edt_projectName.text = _editModel.projectName;
      edt_Orgname.text = _editModel.organizationName;
      edt_OrgID.text = _editModel.orgCode;
      edt_KindAtt.text = _editModel.pOKindAttn;

      SalesOrderNo = _editModel.orderNo?.toString();
      edt_select_emailSubjectName.text = _editModel.emailHeader;
      edt_select_emailSubject.text = _editModel.emailContent;

      edt_grossWeight.text = _editModel.grossWeight.toString();
      edt_licenceNO.text = _editModel.licenseNo;
      edt_tareWeight.text = _editModel.tareWeight.toString();
      edt_NetWeight.text = _editModel.netWeight.toString();
      edt_driverNumber.text = _editModel.driverName;
      edt_driverLicenceNo.text = _editModel.drivingLicenseNo;
      edt_driverDetails.text = _editModel.driverDetails;
      edt_conductorName.text = _editModel.conductorName;
      edt_ModOfPayment.text = _editModel.modeOfPayment;
      edt_TransporterName.text = _editModel.transporterName;
      edt_Distance.text = _editModel.tripDistance.toString();
      edt_ConsigneeName.text = _editModel.consigneeName;
      edt_ConsigneeAddress.text = _editModel.consigneeAddress;
      edt_ConsigneeCity.text = _editModel.consigneeCity;
      edt_driverName.text = _editModel.driverName;
      edt_tankerNumber.text = _editModel.tankerNo;

      int stateCode = _editModel.stateCode;
      edt_StateCode.text = stateCode.toString();

      await getInquiryProductDetails();

      _mainBloc.add(DeleteGenericAdditionalChargesEvent());

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

      // Set up additional charges safely
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
        ChargeGstPer1: '',
        ChargeIsBeforGst1: '',
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
        ROffAmt: _editModel.roffAmt?.toString() ?? '',
        ChargePer1: '0.00',
        ChargePer2: '0.00',
        ChargePer3: '0.00',
        ChargePer4: '0.00',
        ChargePer5: '0.00',
      );

      _mainBloc.add(QuotationOtherChargeCallEvent(
        _editModel.discountAmt?.toString() ?? '',
        CompanyID.toString(),
        QuotationOtherChargesListRequest(pkID: ''),
      ));

      if ((_editModel.orderNo?.toString() ?? '').isNotEmpty) {
        await _mainBloc.add(PurchaseOrderDetailsListRequestEvent(
            stateCode,
            LoginUserID,
            PurchaseOrderDetailsListRequest(
                OrderNo: _editModel.orderNo.toString(),
                CompanyId: CompanyID.toString())));

        await _mainBloc.add(
          PurchaseOrderShipmentListRequestEvent(
            PurchaseOrderShipmentListRequest(
              OrderNo: _editModel.orderNo,
              LoginUserID: LoginUserID,
              CompanyId: CompanyID.toString(),
            ),
          ),
        );
      }
    } catch (e, stackTrace) {
      print('fillData error: $e');
      print('Stack trace: $stackTrace');
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
    for (var i = 0; i < 1; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();

      if (i == 0) {
        all_name_id.Name = "Sales Bill";
      }
      arr_ALL_Name_ID_For_Sales_Order_Select_Inquiry.add(all_name_id);
    }
  }

  Widget EmailSubjectWithMultiID1(String Category,
      {bool enable1,
      Icon icon,
      String title,
      String hintTextvalue,
      List<ALL_Name_ID> Custom_values1}) {
    return Container(
      child: Column(
        children: [
          InkWell(
            onTap: () {
              print("sfdfsfffff");

              _mainBloc.add(SalesBillEmailContentRequestEvent(
                  SalesBillEmailContentRequest(
                      CompanyId: CompanyID.toString(),
                      LoginUserID: LoginUserID)));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                              controller: edt_select_emailSubject,
                              enabled: false,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 7),
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

  void OnUpdatePaymentSchedule(PaymentScheduleEditResponseState state) {
    print("UpdatePayment" + state.response);
    _mainBloc.add(PaymentScheduleListEvent());
  }

  void _onShortInvoiceAddUpdateResponseState(
      PurchaseOrderAddUpdateResponseState state) {
    int returnPKID = 0;
    String returnInvoiceNo = "";

    // Extract pkID and InvoiceNo from response
    for (final detail in state.purchaseBillAddUpdateResponse.details) {
      returnPKID = int.tryParse(detail.column1.toString()) ?? 0;
      returnInvoiceNo = detail.column3 ?? "";
    }

    // Prepare and dispatch shipment save request
    final shipmentRequest = PurchaseOrderShipmentSaveRequest(
      pkID: ShipmentPkID.toString(),
      OrderNo: returnInvoiceNo,
      SCompanyName: _controller_company_name.text,
      SGSTNo: _controller_GSTNO.text,
      SContactNo: _controller_contact_no.text,
      SContactPersonName: _controller_contact_person_name.text,
      SAddress: _controller_address.text,
      SArea: _controller_area.text,
      SCountryCode: edt_QualifiedCountry.text,
      SStateCode: edt_QualifiedStateCode.text,
      SCityCode: edt_QualifiedCityCode.text,
      SPincode: edt_QualifiedPinCode.text,
      Email: "",
      LoginUserID: LoginUserID,
      CompanyId: CompanyID.toString(),
    );

    _mainBloc.add(PurchaseOrderShipmentAddUpdateRequestEvent(shipmentRequest));

    // Update local DB with return values
    updateRetrunInquiryNoToDB(state.context, returnPKID, returnInvoiceNo);
  }

  void updateRetrunInquiryNoToDB(
      context1, int returnPKID, String retrunSO_No) async {
    await getInquiryProductDetails();

    List<PurchaseOrderTable> TempproductList1 =
        PurchaseOrderHeaderDiscountCalculation.txtHeadDiscount_WithZero(
            _inquiryProductList,
            HeaderDisAmnt,
            _offlineLoggedInData.details[0].stateCode.toString(),
            edt_StateCode.text.toString());

    List<PurchaseOrderTable> TempproductList =
        PurchaseOrderHeaderDiscountCalculation.txtHeadDiscount_TextChanged(
            TempproductList1,
            HeaderDisAmnt,
            _offlineLoggedInData.details[0].stateCode.toString(),
            edt_StateCode.text.toString());

    arrSOProductList.clear();
    for (int i = 0; i < TempproductList.length; i++) {
      PurchaseOrderDetailsAddUpdateRequest
          purchaseOrderDetailsAddUpdateRequest =
          PurchaseOrderDetailsAddUpdateRequest(
        pkID: 0,
        OrderNo: retrunSO_No,
        ProductID: TempproductList[i].ProductID,
        ProductSpecification: TempproductList[i].ProductSpecification,
        TaxType: TempproductList[i].TaxType,
        Quantity: TempproductList[i].Quantity,
        Unit: TempproductList[i].Unit,
        UnitRate: TempproductList[i].UnitRate,
        DiscountPercent: TempproductList[i].DiscountPercent,
        NetRate: TempproductList[i].NetRate,
        Amount: TempproductList[i].Amount,
        TaxRate: TempproductList[i].TaxRate,
        TaxAmount: TempproductList[i].TaxAmount,
        NetAmount: TempproductList[i].DiscountAmt,
        DeliveryDate: TempproductList[i].DeliveryDate,
        DiscountAmt: TempproductList[i].DiscountAmt,
        SGSTPer: TempproductList[i].SGSTPer,
        SGSTAmt: TempproductList[i].SGSTAmt,
        CGSTPer: TempproductList[i].CGSTPer,
        CGSTAmt: TempproductList[i].CGSTAmt,
        IGSTPer: TempproductList[i].IGSTPer,
        IGSTAmt: TempproductList[i].IGSTAmt,
        HeaderDiscAmt: TempproductList[i].HeaderDiscAmt,
        IndentNo: TempproductList[i].DocRef,
        LoginUserID: LoginUserID,
        CompanyId: CompanyID.toString(),
      );

      arrSOProductList.add(purchaseOrderDetailsAddUpdateRequest);
    }

    _mainBloc.add(PurchaseOrderDetailsAddUpdateCallEvent(
        context1, retrunSO_No, arrSOProductList));
  }

  void _OnShortInvoiceProductSaveResponseState(
      PurchaseOrderProductSaveResponseState state) async {
    String Msg = _isForUpdate == true
        ? "Purchase Order Updated Successfully"
        : "Purchase Order Added Successfully";

    showCommonDialogWithSingleOption(context, Msg, positiveButtonTitle: "OK",
        onTapOfPositiveButton: () {
      navigateTo(context, PoListScreen.routeName, clearAllStack: true);
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
    await OfflineDbHelper.getInstance().deleteALLPurchaseOrderProduct();
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
                          NewPoOtherChargeScreen.routeName,
                          arguments: NewPoOtherChargesScreenArguments(
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
                          NewPoOtherChargeScreen.routeName,
                          arguments: NewPoOtherChargesScreenArguments(
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

  showcustomdialogEmailContent({
    BuildContext context1,
    String Email,
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
                    "Add Email Subject",
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
                            child: Text("Subject *",
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
                            margin: EdgeInsets.only(left: 10, right: 10),
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
                                          controller:
                                              _contrller_Email_Add_Subject,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                            hintText: "Tap to enter Subject",
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
                            child: Text("Email Content *",
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
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: Card(
                              elevation: 5,
                              color: colorLightGray,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Container(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                width: double.maxFinite,
                                height: 100,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: TextField(
                                          controller:
                                              _contrller_Email_Add_Content,
                                          decoration: InputDecoration(
                                            hintText: "Tap to enter content",
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
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: getCommonButton(baseTheme, () async {
                            if (_contrller_Email_Add_Subject.text != "") {
                              if (_contrller_Email_Add_Content.text != "") {
                                Navigator.pop(context123);

                                _mainBloc.add(SaveEmailContentRequestEvent(
                                    SaveEmailContentRequest(
                                        pkID: "0",
                                        Subject:
                                            _contrller_Email_Add_Subject.text,
                                        ContentData:
                                            _contrller_Email_Add_Content.text,
                                        LoginUserID: LoginUserID,
                                        CompanyId: CompanyID.toString())));
                              } else {
                                showCommonDialogWithSingleOption(
                                    context, "Email content is required !",
                                    positiveButtonTitle: "OK");
                              }
                            } else {
                              showCommonDialogWithSingleOption(
                                  context, "Subject is required !",
                                  positiveButtonTitle: "OK");
                            }
                          }, "Add",
                              backGroundColor: colorPrimary,
                              textColor: colorWhite,
                              radius: 36),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 100,
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: getCommonButton(baseTheme, () {
                            Navigator.pop(context);
                          }, "Close",
                              backGroundColor: colorPrimary,
                              textColor: colorWhite,
                              radius: 36),
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

  void _OnSaveEmailContentResponse(SaveEmailContentResponseState state) {
    showCommonDialogWithSingleOption(context, state.response.details[0].column2,
        positiveButtonTitle: "OK");
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
      ROffAmt: _editModel.roffAmt.toStringAsFixed(2),
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
      AdvanceAmt: _editModel.advanceAmt.toStringAsFixed(2),
      AdvancePer: _editModel.advancePer.toStringAsFixed(2),
    );
  }

  Widget _BuildAddressDropDown() {
    return InkWell(
      onTap: () {
        if (edt_customerName.text != "") {
          showcustomdialogWithShipmentAddressOnlyName(
              values: arr_ALL_Name_ID_For_Sales_Order_Address_DROP_DOWN,
              context1: context,
              controller: _controller_pickupAddressName,
              lable: "Pickup Address From");
        } else {
          showCommonDialogWithSingleOption(
              context, "CustomerName is required !",
              positiveButtonTitle: "OK");
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                    child: TextField(
                      controller: _controller_pickupAddressName,
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: "Tap to select Pickup Address From",
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
                      ),
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
    );
  }

  Widget _BuildOrgDropDown() {
    return InkWell(
      onTap: () {
        if (edt_customerName.text != "") {
          _mainBloc.add(SalesOrderAddressORGDropDownRequestEvent(
              SalesOrderAddressDropDownRequest(
            Mode: "Organization",
            CustomerID: edt_customerID.text,
            OrgCode: "",
            CompanyId: CompanyID.toString(),
          )));
        } else {
          showCommonDialogWithSingleOption(
              context, "CustomerName is required !",
              positiveButtonTitle: "OK");
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                    child: TextField(
                      controller: _controller_pickupOrgName,
                      enabled: false,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 7),
                        hintText: "Tap to select Pickup Org.Address",
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
    );
  }

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

  showcustomdialogWithShipmentAddressOnlyName(
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

                                  if (controller.text.toString() !=
                                      "Organization") {
                                    _mainBloc.add(
                                        SalesOrderAddressDropDownRequestEvent(
                                            SalesOrderAddressDropDownRequest(
                                      Mode: controller.text,
                                      CustomerID: edt_customerID.text,
                                      OrgCode: "",
                                      CompanyId: CompanyID.toString(),
                                    )));
                                  }

                                  if (controller.text.toString() ==
                                      "Organization") {
                                    isOrganatiozation = true;
                                  } else {
                                    isOrganatiozation = false;
                                  }

                                  setState(() {});
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

  void _onSalesOrderAddressDropDownResponseState(
      SalesOrderAddressDropDownResponseState state) {
    if (state.response.details.length != 0) {
      _controller_company_name.text = state.response.details[0].name.toString();
      _controller_contact_person_name.text =
          state.response.details[0].name.toString();

      _controller_contact_no.text =
          state.response.details[0].contactNo.toString();
      _controller_GSTNO.text = state.response.details[0].gSTNo.toString();

      _controller_address.text = state.response.details[0].address.toString();
      _controller_area.text = state.response.details[0].area.toString();

      edt_QualifiedCountryCode.text =
          state.response.details[0].countryCode.toString();
      edt_QualifiedCountry.text =
          state.response.details[0].countryName.toString();

      edt_QualifiedStateCode.text =
          state.response.details[0].stateCode.toString();
      edt_QualifiedState.text = state.response.details[0].stateName.toString();

      edt_QualifiedCityCode.text =
          state.response.details[0].cityCode.toString();
      edt_QualifiedCity.text = state.response.details[0].cityName.toString();

      edt_QualifiedPinCode.text = state.response.details[0].pinCode.toString();
    }
  }

  void _onSalesOrderAddressORGDropDownResponseState(
      SalesOrderAddressORGDropDownResponseState state) {
    if (state.response.details.length != 0) {
      arr_ALL_Name_ID_For_Sales_Order_Address_ORG_DROP_DOWN.clear();
      for (int i = 0; i < state.response.details.length; i++) {
        ALL_Name_ID all_name_id = ALL_Name_ID();

        all_name_id.Name = state.response.details[i].name;

        arr_ALL_Name_ID_For_Sales_Order_Address_ORG_DROP_DOWN.add(all_name_id);
      }

      showcustomdialogWithShipmentAddressORGOnlyName(
          apiValues: state.response.details,
          values: arr_ALL_Name_ID_For_Sales_Order_Address_ORG_DROP_DOWN,
          context1: context,
          controller: _controller_pickupOrgName,
          lable: "Pickup Address From");
    }
  }

  showcustomdialogWithShipmentAddressORGOnlyName(
      {List<SalesOrderAddressDropDownResponseDetails> apiValues,
      List<ALL_Name_ID> values,
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

                                  for (int i = 0; i < apiValues.length; i++) {
                                    if (values[index].Name.toLowerCase() ==
                                        apiValues[i].name.toLowerCase()) {
                                      _controller_company_name.text =
                                          apiValues[i].name.toString();
                                      _controller_contact_person_name.text =
                                          apiValues[i].name.toString();

                                      _controller_contact_no.text =
                                          apiValues[i].contactNo.toString();
                                      _controller_GSTNO.text =
                                          apiValues[i].gSTNo.toString();

                                      _controller_address.text =
                                          apiValues[i].address.toString();
                                      _controller_area.text =
                                          apiValues[i].area.toString();

                                      edt_QualifiedCountryCode.text =
                                          apiValues[i].countryCode.toString();
                                      edt_QualifiedCountry.text =
                                          apiValues[i].countryName.toString();

                                      edt_QualifiedStateCode.text =
                                          apiValues[i].stateCode.toString();
                                      edt_QualifiedState.text =
                                          apiValues[i].stateName.toString();

                                      edt_QualifiedCityCode.text =
                                          apiValues[i].cityCode.toString();
                                      edt_QualifiedCity.text =
                                          apiValues[i].cityName.toString();

                                      edt_QualifiedPinCode.text =
                                          apiValues[i].pinCode.toString();
                                      break;
                                    }
                                  }
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
        navigateTo(context, POProductListScreen.routeName,
            arguments: POProductListArgument(
                SalesOrderNo, edt_StateCode.text, edt_HeaderDisc.text));
      }
    }
  }

  void _OnShortInvoiceShipmentListResponseState(
      PurchaseOrderShipmentListResponseState state) async {
    if (state.purchaseOrderShipmentListResponse.details.isNotEmpty) {
      final detail = state.purchaseOrderShipmentListResponse.details[0];

      ShipmentPkID = detail.pkID ?? '0';
      _controller_company_name.text = detail.sCompanyName ?? '';
      _controller_GSTNO.text = detail.sGSTNo ?? '';
      _controller_contact_no.text = detail.sContactNo ?? '';
      _controller_contact_person_name.text = detail.sContactPersonName ?? '';
      _controller_address.text = detail.sAddress ?? '';
      _controller_area.text = detail.sArea ?? '';

      edt_QualifiedCountry.text = detail.countryName ?? '';
      edt_QualifiedCountryCode.text = detail.sCountryCode?.toString() ?? '';
      edt_QualifiedState.text = detail.stateName ?? '';
      edt_QualifiedStateCode.text = detail.sStateCode?.toString() ?? '';
      edt_QualifiedCity.text = detail.cityName ?? '';
      edt_QualifiedCityCode.text = detail.sCityCode?.toString() ?? '';
      edt_QualifiedPinCode.text = detail.sPincode ?? '';
    }
  }

  void _onShortInvoiceDetailsListResponseState(
      PurchaseOrderDetailsListResponseState state) {}

  void _onShortInvoiceShipmentAddUpdateResponseState(
      PurchaseOrderShipmentAddUpdateResponseState state) {
    print(state.response.details[0].column2);
  }

  void _onShortInvoiceDetailsDeleteResponseState(
      PurchaseOrderDetailsDeleteResponseState state) {}

  void _onShortInvoiceAssemblyLoadListResponseState(
      ShortInvoiceAssemblyLoadListResponseState state) async {
    edt_ProductName.text = "";
    edt_ProductID.text = "0";

    if (state.response.details.isNotEmpty) {
      for (var detail in state.response.details) {
        final productId = detail.productID;

        // Check in database if product already exists
        bool exists = await OfflineDbHelper.getInstance()
            .isProductAlreadyStoredForOP(productId);
        if (exists) continue;

        final quantity = detail.quantity ?? 0.00;
        final unitPrice = detail.unitPrice ?? 0.00;
        final taxPer = detail.taxRate ?? 0.00;
        const taxType = 0; // 0 = Tax inclusive
        final netRate = unitPrice;

        double amount = 0.00;
        double taxAmount = 0.00;
        double totalAmount = 0.00;

        if (taxType == 1) {
          amount = quantity * netRate;
          taxAmount = (amount * taxPer) / 100;
          totalAmount = amount + taxAmount;
        } else {
          taxAmount = ((quantity * netRate) * taxPer) / (100 + taxPer);
          amount = (quantity * netRate) - taxAmount;
          totalAmount = quantity * netRate;
        }

        double cgstPer = 0.00;
        double sgstPer = 0.00;
        double igstPer = 0.00;
        double cgstAmount = 0.00;
        double sgstAmount = 0.00;
        double igstAmount = 0.00;

        final localStateCode = int.tryParse(edt_StateCode.text) ?? 0;
        final userStateCode = _offlineLoggedInData.details[0].stateCode;

        if (userStateCode == localStateCode) {
          cgstPer = taxPer / 2;
          sgstPer = taxPer / 2;
          cgstAmount = taxAmount / 2;
          sgstAmount = taxAmount / 2;
        } else {
          igstPer = taxPer;
          igstAmount = taxAmount;
        }

        await OfflineDbHelper.getInstance()
            .insertPurchaseOrderProduct(PurchaseOrderTable(
                "", //String PurchaseOrderNo,
                detail.productSpecification, //String ProductSpecification,
                productId, //int ProductID,
                detail.productName, //String ProductName,
                detail.unit, //String Unit,
                quantity, //double Quantity,
                unitPrice, //double UnitRate,
                0.00, //double DiscountPercent,
                0.00, //double DiscountAmt,
                netRate, //double NetRate,
                amount, //double Amount,
                taxPer, //double TaxRate,
                taxAmount, //double TaxAmount,
                totalAmount, //double NetAmount,
                taxType, //int TaxType,
                cgstPer, //double CGSTPer,
                sgstPer, //double SGSTPer,
                igstPer, //double IGSTPer,
                cgstAmount, //double CGSTAmt,
                sgstAmount, //double SGSTAmt,
                igstAmount, //double IGSTAmt,
                localStateCode, //int StateCode,
                pkID, //int pkID,
                LoginUserID, //String LoginUserID,
                CompanyID.toString(), //String CompanyId,
                0, //int BundleId,
                0.00, //double HeaderDiscAmt,
                "", //String DeliveryDate,
                "" //String DocRef,
                ));
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Assembly Load Successfully !!'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      _mainBloc.add(ShortInvoiceProductListRequestEvent(
          ProductMasterListRequest(
              ProductID: state.finishProductID.toString(),
              ListMode: "",
              SearchKey: "",
              PageNo: "1",
              PageSize: "10",
              LoginUserID: LoginUserID,
              CompanyId: CompanyID.toString())));
    }
  }

  void _onShortInvoiceProductMainListResponseState(
      ShortInvoiceProductMainListResponseState state) async {
    if (state.response.details.isNotEmpty) {
      for (var detail in state.response.details) {
        final productId = detail.pkID;

        // Check in database if product already exists
        bool exists = await OfflineDbHelper.getInstance()
            .isProductAlreadyStoredForOP(productId);
        if (exists) continue;

        final quantity = 1.0;
        final unitPrice = detail.unitPrice ?? 0.00;
        final taxPer = detail.taxRate ?? 0.00;
        const taxType = 0; // 0 = Tax inclusive
        final netRate = unitPrice;

        double amount = 0.00;
        double taxAmount = 0.00;
        double totalAmount = 0.00;

        if (taxType == 1) {
          amount = quantity * netRate;
          taxAmount = (amount * taxPer) / 100;
          totalAmount = amount + taxAmount;
        } else {
          taxAmount = ((quantity * netRate) * taxPer) / (100 + taxPer);
          amount = (quantity * netRate) - taxAmount;
          totalAmount = quantity * netRate;
        }

        double cgstPer = 0.00;
        double sgstPer = 0.00;
        double igstPer = 0.00;
        double cgstAmount = 0.00;
        double sgstAmount = 0.00;
        double igstAmount = 0.00;

        final localStateCode = int.tryParse(edt_StateCode.text) ?? 0;
        final userStateCode = _offlineLoggedInData.details[0].stateCode;

        if (userStateCode == localStateCode) {
          cgstPer = taxPer / 2;
          sgstPer = taxPer / 2;
          cgstAmount = taxAmount / 2;
          sgstAmount = taxAmount / 2;
        } else {
          igstPer = taxPer;
          igstAmount = taxAmount;
        }

        await OfflineDbHelper.getInstance()
            .insertPurchaseOrderProduct(PurchaseOrderTable(
                "", //String PurchaseOrderNo,
                detail.productSpecification, //String ProductSpecification,
                productId, //int ProductID,
                detail.productName, //String ProductName,
                detail.unit, //String Unit,
                quantity, //double Quantity,
                unitPrice, //double UnitRate,
                0.00, //double DiscountPercent,
                0.00, //double DiscountAmt,
                netRate, //double NetRate,
                amount, //double Amount,
                taxPer, //double TaxRate,
                taxAmount, //double TaxAmount,
                totalAmount, //double NetAmount,
                taxType, //int TaxType,
                cgstPer, //double CGSTPer,
                sgstPer, //double SGSTPer,
                igstPer, //double IGSTPer,
                cgstAmount, //double CGSTAmt,
                sgstAmount, //double SGSTAmt,
                igstAmount, //double IGSTAmt,
                localStateCode, //int StateCode,
                pkID, //int pkID,
                LoginUserID, //String LoginUserID,
                CompanyID.toString(), //String CompanyId,
                0, //int BundleId,
                0.00, //double HeaderDiscAmt,
                "", //String DeliveryDate,
                "" //String DocRef,
                ));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Product Load Successfully !!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
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
}
