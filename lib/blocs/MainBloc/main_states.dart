part of 'mainBloc.dart';

abstract class MainStates extends BaseStates {
  const MainStates();
}

///all states of AuthenticationStates

class MainInitialState extends MainStates {}

/*
class LoginUserDetialsCallEventResponseState extends MainStates {
  LoginUserDetialsResponse response;

  LoginUserDetialsCallEventResponseState(this.response);
}*/
class MayankBankVoucherListResponseState extends MainStates {
  final int newPage;
  final MayankBankVoucherListResponse response;
  MayankBankVoucherListResponseState(this.newPage, this.response);
}

class MayankBankVoucherDeleteResponseState extends MainStates {
  final String response;

  MayankBankVoucherDeleteResponseState(this.response);
}

class MayankBankVoucherCustomerListByNameCallResponseState extends MainStates {
  final CustomerLabelvalueRsponse response;

  MayankBankVoucherCustomerListByNameCallResponseState(this.response);
}

class MayankTransectionModeResponseState extends MainStates {
  final TransectionModeListResponse transectionModeListResponse;

  MayankTransectionModeResponseState(this.transectionModeListResponse);
}

class MayankBankVoucherModeResponseState extends MainStates {
  final MayankBankVoucherInqNoResponse mayankBankVoucherInqNoResponse;

  MayankBankVoucherModeResponseState(this.mayankBankVoucherInqNoResponse);
}

class MayankBankVoucherAmountResponseState extends MainStates {
  final MayankBankVoucherAmountResponse mayankBankVoucherAmountResponse;

  MayankBankVoucherAmountResponseState(this.mayankBankVoucherAmountResponse);
}

class MayankBankVoucherSaveResponseState extends MainStates {
  final MayankBankVoucherAddEditResponse mayankBankVoucherAddEditResponse;
  //final BuildContext context;

  MayankBankVoucherSaveResponseState(
      /*this.context, */ this.mayankBankVoucherAddEditResponse);
}

class MayankBankVoucherDetailsListResponseState extends MainStates {
  final String detailsResponse;
  MayankBankVoucherDetailsListResponseState(this.detailsResponse);
}

class MayankBankVoucherDeleteDetailsResponseState extends MainStates {
  final String response;

  MayankBankVoucherDeleteDetailsResponseState(this.response);
}

class MayankBankVoucherDetailsAddEditResponseState extends MainStates {
  BuildContext contextfromlistscreen;
  final MayankBankVoucherDetailsAddEditResponse response;

  MayankBankVoucherDetailsAddEditResponseState(
      this.contextfromlistscreen, this.response);
}

class MayankBankVoucherDetailsAddEditResponseState1 extends MainStates {
  final MayankBankVoucherDetailsAddEditResponse response;

  MayankBankVoucherDetailsAddEditResponseState1(this.response);
}

/// Purchase_Order AND Purchase_Bill
class PurchaseBillListResponseState extends MainStates {
  final int newPage;
  final PurchaseBillListResponse response;
  PurchaseBillListResponseState(this.newPage, this.response);
}

class PurchaseBillDeleteResponseState extends MainStates {
  final String response;

  PurchaseBillDeleteResponseState(this.response);
}

class GetPBProductListState extends MainStates {
  final List<PurchaseBillTable> response;

  GetPBProductListState(this.response);
}

class SearchCustomerListByNameCallResponseState extends MainStates {
  final CustomerLabelvalueRsponse response;

  SearchCustomerListByNameCallResponseState(this.response);
}

class TaskCategoryCallResponseState extends MainStates {
  final TaskCategoryResponse taskCategoryResponse;

  TaskCategoryCallResponseState(this.taskCategoryResponse);
}

class ModulesDropDownListResponseState extends MainStates {
  final ModulesDropDownListResponse taskCategoryResponse;

  ModulesDropDownListResponseState(this.taskCategoryResponse);
}

class SharvayaDailyActivityListResponseState extends MainStates {
  final int newPage;
  final SharvayaDailyActivityListResponse response;
  SharvayaDailyActivityListResponseState(this.newPage, this.response);
}

class SharvayaDailyActivityDeleteResponseState extends MainStates {
  final String response;

  SharvayaDailyActivityDeleteResponseState(this.response);
}

// SharvayaDailyActivitySaveResponse

class SharvayaDailyActivitySaveResponseState extends MainStates {
  final SharvayaDailyActivitySaveResponse response;

  SharvayaDailyActivitySaveResponseState(this.response);
}

class UserMenuRightsResponseState extends MainStates {
  final UserMenuRightsResponse userMenuRightsResponse;
  UserMenuRightsResponseState(this.userMenuRightsResponse);
}

/// purchase Order
class PoKindAttListResponseState extends MainStates {
  final QuotationKindAttListResponse response;

  PoKindAttListResponseState(this.response);
}

class PoProjectListResponseState extends MainStates {
  final QuotationProjectListResponse response;

  PoProjectListResponseState(this.response);
}

class PoTermsConditionResponseState extends MainStates {
  final QuotationTermsCondtionResponse response;

  PoTermsConditionResponseState(this.response);
}

/// Reports
class CustomerReportsCallState extends MainStates {
  CustomerDetailsResponse response;
  final int newpage;

  CustomerReportsCallState(this.response, this.newpage);
}

class InquiryListResponseCallResponseState extends MainStates {
  final InquiryListResponse response;
  final int newPage;
  InquiryListResponseCallResponseState(this.response, this.newPage);
}

class QuotationReportListCallResponseState extends MainStates {
  final QuotationListResponse response;
  final int newPage;
  QuotationReportListCallResponseState(this.response, this.newPage);
}

/// outward
class MaterialOutwardListCallResponseState extends MainStates {
  final MaterialOutwardListMainResponse response;
  final int newPage;
  MaterialOutwardListCallResponseState(this.response, this.newPage);
}

class MaterialOutwardDeleteCallResponseState extends MainStates {
  final String response;

  MaterialOutwardDeleteCallResponseState(this.response);
}

class MaterialOutwardAddUpdateCallResponseState extends MainStates {
  final MaterialOutwardAddUpdateResponse materialOutwardAddUpdateResponse;
  MaterialOutwardAddUpdateCallResponseState(
      this.materialOutwardAddUpdateResponse);
}

class MaterialOutwardExportListResponseState extends MainStates {
  final MaterialOutwardExportListMainResponse response;

  MaterialOutwardExportListResponseState(this.response);
}

class MaterialOutwardGetSoNoResponseState extends MainStates {
  final MaterialOutwardPendingSalesOrderListResponse response;

  MaterialOutwardGetSoNoResponseState(this.response);
}

class MaterialOutwardGetDetailsSoNoResponseState extends MainStates {
  final MaterialOutwardPendingSalesOrderDetailsListResponse response;

  MaterialOutwardGetDetailsSoNoResponseState(this.response);
}

class GetMaterialOutwardProductListState extends MainStates {
  final List<MaterialOutwardTable> response;

  GetMaterialOutwardProductListState(this.response);
}

class SBMaterialOutwardOneDeleteState extends MainStates {
  final String response;

  SBMaterialOutwardOneDeleteState(this.response);
}

class MaterialOutwardConstantResponseState extends MainStates {
  final ConstantResponse response;

  MaterialOutwardConstantResponseState(this.response);
}

class MaterialOutwardDetailsDeleteCallResponseState extends MainStates {
  final String response;

  MaterialOutwardDetailsDeleteCallResponseState(this.response);
}

class MaterialOutwardProductAddUpdateState extends MainStates {
  final List<MaterialOutwardTable> response;
  MaterialOutwardProductAddUpdateState(this.response);
}

class MaterialOutwardDetailsListCallResponseState extends MainStates {
  int StateCode;
  final MaterialOutwardDetailsListResponse response;
  MaterialOutwardDetailsListCallResponseState(this.StateCode, this.response);
}

class MaterialOutwardGetDetailsOutwardNoBYFetchTypeResponseState
    extends MainStates {
  final MaterialOutwardPendingSalesOrderDetailsByFetchTypeListResponse response;

  MaterialOutwardGetDetailsOutwardNoBYFetchTypeResponseState(this.response);
}

class SalesBillPDFGenerateResponseState extends MainStates {
  final SalesBillPDFGenerateResponse response;

  SalesBillPDFGenerateResponseState(this.response);
}

class InvoiceDocumentDeleteResponseState extends MainStates {
  final MaterialOutwardDocumentDeleteResponse response;
  InvoiceDocumentDeleteResponseState(this.response);
}

class InvoiceDocumentListResponseState extends MainStates {
  final MaterialOutwardDocumentListResponse response;
  List<File> DocumentList;
  MaterialOutwardListMainResponseDetails paginationmodel;
  InvoiceDocumentListResponseState(
      this.response, this.paginationmodel, this.DocumentList);
}

/*class InvoiceDocumentOnlyNameListResponseState extends MainStates {
  final MaterialOutwardDocumentListResponse response;
  MaterialOutwardListMainResponseDetails paginationmodel;

  InvoiceDocumentOnlyNameListResponseState(this.response, this.paginationmodel);
}*/

class DefDocumentListResponseState extends MainStates {
  final MaterialOutwardDocumentListResponse response;
  List<File> DocumentList;
  List<File> DocumentListForSlip;
  MaterialOutwardListMainResponseDetails vehicleDefDetails;
  MaterialOutwardExportListMainResponse materialOutwardExportListMainResponse;
  DefDocumentListResponseState(
      this.response,
      this.vehicleDefDetails,
      this.DocumentList,
      this.DocumentListForSlip,
      this.materialOutwardExportListMainResponse);
}

class InvoiceDocumentOnlyNameListResponseState1 extends MainStates {
  final MaterialOutwardDocumentListResponse response;
  MaterialOutwardListMainResponseDetails paginationmodel;
  MaterialOutwardExportListMainResponse materialOutwardExportListMainResponse;

  InvoiceDocumentOnlyNameListResponseState1(this.response, this.paginationmodel,
      this.materialOutwardExportListMainResponse);
}

class ModuleAttachmentItemWiseDeleteResponseState extends MainStates {
  final ModuleAttachmentItemWiseDeleteResponse resposne;

  ModuleAttachmentItemWiseDeleteResponseState(this.resposne);
}

class MaintenanceTermsConditionResponseState extends MainStates {
  final QuotationTermsCondtionResponse response;

  MaintenanceTermsConditionResponseState(this.response);
}

class GetMaintenanceProductListState extends MainStates {
  final List<MaintenanceProductModel> response;

  GetMaintenanceProductListState(this.response);
}

class MaintenanceOneProductDeleteState extends MainStates {
  final String response;

  MaintenanceOneProductDeleteState(this.response);
}

///Maintenance
class MaintenanceListResponseState extends MainStates {
  final MaintenanceListResponse maintenanceListResponse;
  final int newPage;

  MaintenanceListResponseState(this.newPage, this.maintenanceListResponse);
}

class MaintenanceDeleteCallResponseState extends MainStates {
  final String response;

  MaintenanceDeleteCallResponseState(this.response);
}

class MaintenanceAddUpdateCallResponseState extends MainStates {
  final MaintenanceAddUpdateResponse maintenanceAddUpdateResponse;
  MaintenanceAddUpdateCallResponseState(this.maintenanceAddUpdateResponse);
}

class MaintenanceCheckListDRPResponseState extends MainStates {
  final MaintenanceCheckListDRPResponse response;

  MaintenanceCheckListDRPResponseState(this.response);
}

class MasterMaintenanceCheckListResponseState extends MainStates {
  final MasterMaintenanceCheckListResponse response;

  MasterMaintenanceCheckListResponseState(this.response);
}

class MasterMaintenanceCheckListResponseState1 extends MainStates {
  final MasterMaintenanceCheckListResponse1 response;

  MasterMaintenanceCheckListResponseState1(this.response);
}

class InquiryLeadStatusListCallResponseState extends MainStates {
  final InquiryStatusListResponse inquiryStatusListResponse;

  InquiryLeadStatusListCallResponseState(this.inquiryStatusListResponse);
}

class MaintenanceDetailsListCallResponseState extends MainStates {
  final MaintenanceDetailsListResponse response;
  MaintenanceDetailsListCallResponseState(this.response);
}

class ALL_EmployeeNameListResponseState extends MainStates {
  final ALL_EmployeeList_Response all_employeeList_Response;

  ALL_EmployeeNameListResponseState(this.all_employeeList_Response);
}

///Repairing
class RepairingListResponseState extends MainStates {
  final RepairingListResponse repairingListResponse;
  final int newPage;

  RepairingListResponseState(this.newPage, this.repairingListResponse);
}

class RepairingDeleteCallResponseState extends MainStates {
  final String response;

  RepairingDeleteCallResponseState(this.response);
}

class RepairingAddUpdateCallResponseState extends MainStates {
  final RepairingAddUpdateResponse repairingAddUpdateResponse;
  RepairingAddUpdateCallResponseState(this.repairingAddUpdateResponse);
}

class RepairingListCallDRPResponseState extends MainStates {
  final MaintenanceCheckListDRPResponse inquiryStatusListResponse;

  RepairingListCallDRPResponseState(this.inquiryStatusListResponse);
}

class UpdateAuditActivityDetailsTableState extends MainStates {
  BuildContext context;
  final String response;

  UpdateAuditActivityDetailsTableState(this.context, this.response);
}

class RepairingDetailsListCallResponseState extends MainStates {
  final RepairingDetailsListResponse response;
  RepairingDetailsListCallResponseState(this.response);
}

class RepairingLogListResponseState extends MainStates {
  final RepairingLogListResponse repairingLogListResponse;
  RepairingLogListResponseState(this.repairingLogListResponse);
}

/// Material Inward
class MaterialInwardListCallMeetResponseState extends MainStates {
  final MaterialInwardListMeetResponse response;
  final int newPage;
  MaterialInwardListCallMeetResponseState(this.response, this.newPage);
}

class MaterialInwardDeleteCallResponseState extends MainStates {
  final String response;

  MaterialInwardDeleteCallResponseState(this.response);
}

class MaterialInwardCustomerListCallState extends MainStates {
  final MaterialInwardCustomerListResponce materialInwardCustomerListResponce;
  MaterialInwardCustomerListCallState(this.materialInwardCustomerListResponce);
}

class MaterialInwardMasterSaveState extends MainStates {
  final MaterialInwardMasterSaveResponce materialInwardMasterSaveResponce;
  MaterialInwardMasterSaveState(this.materialInwardMasterSaveResponce);
}

class MaterialInwardDetailsListState extends MainStates {
  final List<MaterialInwardTable> response;

  MaterialInwardDetailsListState(this.response);
}

class MaterialInwardDetailsOneDeleteState extends MainStates {
  final String response;

  MaterialInwardDetailsOneDeleteState(this.response);
}

// Inward details list call kari che header ma j sql and offline db ma store thya he
class MaterialInwardDetailsListCallResponseState extends MainStates {
  final MaterialInwardDetailListResponse response;
  MaterialInwardDetailsListCallResponseState(this.response);
}

class LocationListCallResponseState extends MainStates {
  final LocationListResponse response;
  LocationListCallResponseState(this.response);
}

class MaterialInwardGetPoNoResponseState extends MainStates {
  final MaterialInwardPendingPurchaseOrderListResponse response;

  MaterialInwardGetPoNoResponseState(this.response);
}

class MaterialInwardGetDetailsPoNoResponseState extends MainStates {
  final MIGetFetDetailByOrderNoListResponse response;

  MaterialInwardGetDetailsPoNoResponseState(this.response);
}

/// Purchase Order

class PurchaseOrderListResponseState extends MainStates {
  final int newPage;
  final PurchaseOrderListResponse response;
  PurchaseOrderListResponseState(this.newPage, this.response);
}

class PurchaseOrderDeleteCallState extends MainStates {
  final String response;
  PurchaseOrderDeleteCallState(this.response);
}

class POApprovalListResponseState extends MainStates {
  POApprovalListResponse response;
  final int newPage;

  POApprovalListResponseState(this.response, this.newPage);
}

class POApprovalSaveResponseState extends MainStates {
  String response;
  BuildContext context;

  POApprovalSaveResponseState(this.response, this.context);
}

class POApprovalStatusListResponseState extends MainStates {
  final SalesOrderApprovalStatusListResponse response;

  POApprovalStatusListResponseState(this.response);
}

class PODrpListResponseState extends MainStates {
  PODrpListResponse response;

  PODrpListResponseState(this.response);
}

/// ServiceReport
class ServiceReportListResponseState extends MainStates {
  final int newPage;
  final ServiceReportListResponse response;
  ServiceReportListResponseState(this.newPage, this.response);
}

class ServiceReportDeleteResponseState extends MainStates {
  final String response;

  ServiceReportDeleteResponseState(this.response);
}

class ServiceReportAddUpdateResponseState extends MainStates {
  final ServiceReportAddUpdateResponse serviceReportAddUpdateResponse;
  ServiceReportAddUpdateResponseState(this.serviceReportAddUpdateResponse);
}

class MachineTypeResponseState extends MainStates {
  final MachineMasterListRequestResponse response;
  MachineTypeResponseState(this.response);
}

class ServiceReportDetailsListResponseState extends MainStates {
  final ServiceReportDetailsListResponse response;
  ServiceReportDetailsListResponseState(this.response);
}

/// ShortInvoice

class ShortInvoiceListResponseState extends MainStates {
  final int newPage;
  final ShortInvoiceListResponse response;
  ShortInvoiceListResponseState(this.newPage, this.response);
}

class ShortInvoiceDeleteResponseState extends MainStates {
  final String response;

  ShortInvoiceDeleteResponseState(this.response);
}

class DeleteAllGenericAdditionalChargesState extends MainStates {
  String response;
  DeleteAllGenericAdditionalChargesState(this.response);
}

class PaymentScheduleDeleteAllResponseState extends MainStates {
  final String response;

  PaymentScheduleDeleteAllResponseState(this.response);
}

class PaymentScheduleListResponseState extends MainStates {
  final List<SoPaymentScheduleTable> response;

  PaymentScheduleListResponseState(this.response);
}

class GenericOtherCharge1ListResponseState extends MainStates {
  final QuotationOtherChargesListResponse quotationOtherChargesListResponse;
  GenericOtherCharge1ListResponseState(this.quotationOtherChargesListResponse);
}

class SalesBill_INQ_QT_SO_NO_ListResponseState extends MainStates {
  final SalesBill_INQ_QT_SO_NO_ListResponse response;
  SalesBill_INQ_QT_SO_NO_ListResponseState(this.response);
}

class AddGenericAdditionalChargesState extends MainStates {
  String response;
  AddGenericAdditionalChargesState(this.response);
}

class BankDetailsListResponseState extends MainStates {
  final BankNameDropDownResponse response;
  BankDetailsListResponseState(this.response);
}

class BankDetailsDialogListResponseState extends MainStates {
  final BankNameDropDownResponse response;
  BankDetailsDialogListResponseState(this.response);
}

class QuotationProjectListResponseState extends MainStates {
  final QuotationProjectListResponse response;
  QuotationProjectListResponseState(this.response);
}

class QuotationTermsCondtionResponseState extends MainStates {
  final QuotationTermsCondtionResponse response;
  QuotationTermsCondtionResponseState(this.response);
}

class SaleBillEmailContentResponseState extends MainStates {
  final SaleBillEmailContentResponse response;

  SaleBillEmailContentResponseState(this.response);
}

class PaymentScheduleDeleteResponseState extends MainStates {
  final String response;

  PaymentScheduleDeleteResponseState(this.response);
}

class PaymentScheduleResponseState extends MainStates {
  final String response;
  PaymentScheduleResponseState(this.response);
}

class SearchCustomerListByNumberCallResponseState extends MainStates {
  String IsFromDialog;
  final CustomerDetailsResponse response;
  SearchCustomerListByNumberCallResponseState(this.IsFromDialog, this.response);
}

class MultiNoToProductDetailsResponseState extends MainStates {
  String FetchFromWhichScreen;
  final MultiNoToProductDetailsResponse response;
  MultiNoToProductDetailsResponseState(
      this.FetchFromWhichScreen, this.response);
}

class SalesOrderAddressDropDownResponseState extends MainStates {
  SalesOrderAddressDropDownResponse response;
  SalesOrderAddressDropDownResponseState(this.response);
}

class QuotationOtherChargeListResponseState extends MainStates {
  final QuotationOtherChargesListResponse quotationOtherChargesListResponse;
  String headerDiscountController;
  QuotationOtherChargeListResponseState(
      this.headerDiscountController, this.quotationOtherChargesListResponse);
}

class SalesOrderAddressORGDropDownResponseState extends MainStates {
  SalesOrderAddressDropDownResponse response;
  SalesOrderAddressORGDropDownResponseState(this.response);
}

class SaveEmailContentResponseState extends MainStates {
  final SaveEmailContentResponse response;

  SaveEmailContentResponseState(this.response);
}

class PaymentScheduleEditResponseState extends MainStates {
  final String response;

  PaymentScheduleEditResponseState(this.response);
}

class GetSIProductListState extends MainStates {
  final List<ShortInvoiceTable> response;

  GetSIProductListState(this.response);
}

class SIProductOneDeleteState extends MainStates {
  final String response;

  SIProductOneDeleteState(this.response);
}

class InsertProductSuccessResponseState extends MainStates {
  final String response;

  InsertProductSuccessResponseState(this.response);
}

class QuotationOtherCharge1ListResponseState extends MainStates {
  final QuotationOtherChargesListResponse quotationOtherChargesListResponse;

  QuotationOtherCharge1ListResponseState(
      this.quotationOtherChargesListResponse);
}

class GetGenericAdditionalChargesState extends MainStates {
  final GenericAddditionalCharges quotationOtherChargesListResponse;

  GetGenericAdditionalChargesState(this.quotationOtherChargesListResponse);
}

class DeleteALLQuotationProductTableState extends MainStates {
  final String response;

  DeleteALLQuotationProductTableState(this.response);
}

class ShortInvoiceShipmentListResponseState extends MainStates {
  final ShortInvoiceShipmentListResponse shortInvoiceShipmentListResponse;
  ShortInvoiceShipmentListResponseState(this.shortInvoiceShipmentListResponse);
}

class ShortInvoiceExportListResponseState extends MainStates {
  final ShortInvoiceExportListResponse shortInvoiceExportListResponse;
  ShortInvoiceExportListResponseState(this.shortInvoiceExportListResponse);
}

class ShortInvoiceDetailsListResponseState extends MainStates {
  final ShortInvoiceDetailsListResponse shortInvoiceDetailsListResponse;
  ShortInvoiceDetailsListResponseState(this.shortInvoiceDetailsListResponse);
}

class ShortInvoiceAddUpdateResponseState extends MainStates {
  BuildContext context;
  final ShortInvoiceAddUpdateResponse shortInvoiceAddUpdateResponse;
  ShortInvoiceAddUpdateResponseState(
      this.context, this.shortInvoiceAddUpdateResponse);
}

class ShortInvoiceProductSaveResponseState extends MainStates {
  final SaleOrderProductSaveResponse response;

  ShortInvoiceProductSaveResponseState(this.response);
}

class ShortInvoiceExportAddUpdateResponseState extends MainStates {
  final SaleOrderProductSaveResponse response;

  ShortInvoiceExportAddUpdateResponseState(this.response);
}

class ShortInvoiceShipmentAddUpdateResponseState extends MainStates {
  final SaleOrderProductSaveResponse response;

  ShortInvoiceShipmentAddUpdateResponseState(this.response);
}

class ShortInvoiceDetailsDeleteResponseState extends MainStates {
  final String response;

  ShortInvoiceDetailsDeleteResponseState(this.response);
}

class ProductMainListResponseState extends MainStates {
  final ProductMasterResponse response;
  ProductMainListResponseState(this.response);
}

class ShortInvoiceAssemblyLoadListResponseState extends MainStates {
  int finishProductID;
  final ShortInvoiceAssemblyLoadResponse response;
  ShortInvoiceAssemblyLoadListResponseState(
      this.finishProductID, this.response);
}

class ShortInvoiceProductMainListResponseState extends MainStates {
  final ProductMasterResponse response;
  ShortInvoiceProductMainListResponseState(this.response);
}

/// PurchaseBill
class PurchaseBillAddUpdateResponseState extends MainStates {
  BuildContext context;
  final PurchaseBillAddUpdateResponse purchaseBillAddUpdateResponse;
  PurchaseBillAddUpdateResponseState(
      this.context, this.purchaseBillAddUpdateResponse);
}

class PurchaseBillDetailsListResponseState extends MainStates {
  final PurchaseBillDetailsListResponse shortInvoiceDetailsListResponse;
  PurchaseBillDetailsListResponseState(this.shortInvoiceDetailsListResponse);
}

class PurchaseBillDetailsDeleteResponseState extends MainStates {
  final String response;
  PurchaseBillDetailsDeleteResponseState(this.response);
}

class PurchaseBillProductSaveResponseState extends MainStates {
  final PurchaseBillAddUpdateResponse response;
  PurchaseBillProductSaveResponseState(this.response);
}

class MultiNoToProductDetailsFromGrnResponseState extends MainStates {
  String FetchFromWhichScreen;
  final MultiNoToProductDetailsFromGRNResponse response;
  MultiNoToProductDetailsFromGrnResponseState(
      this.FetchFromWhichScreen, this.response);
}

class MultiNoToProductDetailsFromPurchaseOrderResponseState extends MainStates {
  String FetchFromWhichScreen;
  final MultiNoToProductDetailsFromPurchaseOrderResponse response;
  MultiNoToProductDetailsFromPurchaseOrderResponseState(
      this.FetchFromWhichScreen, this.response);
}

class PurchaseBillACResponseState extends MainStates {
  final PurchaseBillACResponse response;
  PurchaseBillACResponseState(this.response);
}

class PurchaseBillTODResponseState extends MainStates {
  final PurchaseBillTODResponse response;
  PurchaseBillTODResponseState(this.response);
}

class GetPOProductListState extends MainStates {
  final List<PurchaseOrderTable> response;

  GetPOProductListState(this.response);
}

class ConstantResponseState extends MainStates {
  final ConstantResponse response;
  ConstantResponseState(this.response);
}

class QuotationKindAttListResponseState extends MainStates {
  final QuotationKindAttListResponse response;

  QuotationKindAttListResponseState(this.response);
}

class QuotationOrganizationListResponseState extends MainStates {
  final QuotationOrganizationListResponse quotationOrganizationListResponse;
  QuotationOrganizationListResponseState(
      this.quotationOrganizationListResponse);
}

/// Purchase Order
class PurchaseOrderAddUpdateResponseState extends MainStates {
  BuildContext context;
  final PurchaseOrderAddUpdateResponse purchaseBillAddUpdateResponse;
  PurchaseOrderAddUpdateResponseState(
      this.context, this.purchaseBillAddUpdateResponse);
}

class PurchaseOrderDetailsListResponseState extends MainStates {
  final PurchaseOrderDetailsListResponse shortInvoiceDetailsListResponse;
  PurchaseOrderDetailsListResponseState(this.shortInvoiceDetailsListResponse);
}

class PurchaseOrderDetailsDeleteResponseState extends MainStates {
  final String response;
  PurchaseOrderDetailsDeleteResponseState(this.response);
}

class PurchaseOrderProductSaveResponseState extends MainStates {
  final PurchaseOrderAddUpdateResponse response;
  PurchaseOrderProductSaveResponseState(this.response);
}

class PurchaseOrderShipmentAddUpdateResponseState extends MainStates {
  final PurchaseOrderAddUpdateResponse response;

  PurchaseOrderShipmentAddUpdateResponseState(this.response);
}

class PurchaseOrderShipmentListResponseState extends MainStates {
  final PurchaseOrderShipmentListResponse purchaseOrderShipmentListResponse;
  PurchaseOrderShipmentListResponseState(
      this.purchaseOrderShipmentListResponse);
}

class POFromTheIndentNumberState extends MainStates {
  final PoFromTheIndentListResponse poFromTheIndentListResponse;
  POFromTheIndentNumberState(this.poFromTheIndentListResponse);
}

class PoTankerListResponseState extends MainStates {
  final POTankerListResponse poTankerListResponse;
  PoTankerListResponseState(this.poTankerListResponse);
}

class PoDriverListResponseState extends MainStates {
  final PODriverListResponse poDriverListResponse;
  PoDriverListResponseState(this.poDriverListResponse);
}

class LocationListResponseState extends MainStates {
  final DashboardLocationListResponse all_employeeList_Response;

  LocationListResponseState(this.all_employeeList_Response);
}

class LocationLogListResponseState extends MainStates {
  final DashboardLocationLogListResponse all_employeeList_Response;

  LocationLogListResponseState(this.all_employeeList_Response);
}

class PaySlipListResponseState extends MainStates {
  final PaySlipListResponse response;
  PaySlipListResponseState(this.response);
}

class SalesOrderPDFGenerateResponseState extends MainStates {
  final SalesOrderPDFGenerateResponse response;

  SalesOrderPDFGenerateResponseState(this.response);
}

/// Visitor management
class VisitorInfoListCallResponseState extends MainStates {
  final int newPage;
  final VisitorInfoListApiResponse response;
  VisitorInfoListCallResponseState(this.newPage, this.response);
}

class VisitorInfoDeleteCallResponseState extends MainStates {
  final String response;

  VisitorInfoDeleteCallResponseState(this.response);
}

class VisitorInfoAddUpdateCallResponseState extends MainStates {
  final VisitorInfoAddUpdateApiResponse response;

  VisitorInfoAddUpdateCallResponseState(this.response);
}

class CountryListEventResponseState extends MainStates {
  final CountryListResponse countrylistresponse;
  CountryListEventResponseState(this.countrylistresponse);
}

class StateListEventResponseState extends MainStates {
  final StateListResponse statelistresponse;
  StateListEventResponseState(this.statelistresponse);
}

class CityListEventResponseState extends MainStates {
  final CityApiRespose cityApiRespose;
  CityListEventResponseState(this.cityApiRespose);
}

class SOCustomerNearByPinCodeSummaryResponseState extends MainStates {
  final SOCustomerNearByPinCodeSummaryResponse
      sOCustomerNearByPinCodeSummaryResponse;
  SOCustomerNearByPinCodeSummaryResponseState(
      this.sOCustomerNearByPinCodeSummaryResponse);
}

class SOCustomerNearByPinCodeDetailsResponseState extends MainStates {
  final SOCustomerNearByPinCodeDetailsResponse
      sOCustomerNearByPinCodeDetailsResponse;
  SOCustomerNearByPinCodeDetailsResponseState(
      this.sOCustomerNearByPinCodeDetailsResponse);
}

class InquiryProductSearchResponseState extends MainStates {
  final InquiryProductSearchResponse inquiryProductSearchResponse;
  InquiryProductSearchResponseState(this.inquiryProductSearchResponse);
}

class SOCurrencyListResponseState extends MainStates {
  final SOCurrencyListResponse response;

  SOCurrencyListResponseState(this.response);
}

class MaterialIndentListResponseState extends MainStates {
  final int newPage;
  final MaterialIndentListResponse response;
  MaterialIndentListResponseState(this.newPage, this.response);
}

class MaterialIndentApprovalUpdateResponseState extends MainStates {
  final MaterialIndentApprovalUpdateResponse response;

  MaterialIndentApprovalUpdateResponseState(this.response);
}

class MultiExpenseListResponseState extends MainStates {
  final int newPage;
  final MultiExpenseListResponse response;
  MultiExpenseListResponseState(this.newPage, this.response);
}

class MultiExpenseDeleteResponseState extends MainStates {
  final String response;

  MultiExpenseDeleteResponseState(this.response);
}

class MultiExpenseAddUpUpdateResponseState extends MainStates {
  final MultiExpenseAddUpdateResponse multiExpenseAddUpdateResponse;
  MultiExpenseAddUpUpdateResponseState(this.multiExpenseAddUpdateResponse);
}

class MultiExpenseADetailsListResponseState extends MainStates {
  final MultipleExpenseDetailsListResponse multipleExpenseDetailsListResponse;
  MultiExpenseADetailsListResponseState(
      this.multipleExpenseDetailsListResponse);
}

class MultiExpenseTypeListResponseState extends MainStates {
  final MultiExpenseTypeListResponse multiExpenseTypeListResponse;
  MultiExpenseTypeListResponseState(this.multiExpenseTypeListResponse);
}

class MultiExpenseModeListResponseState extends MainStates {
  final MultiExpenseModeListResponse multiExpenseModeListResponse;
  MultiExpenseModeListResponseState(this.multiExpenseModeListResponse);
}

class ExpenseCustomerListCallResponseState extends MainStates {
  final CustomerDetailsResponse response;
  ExpenseCustomerListCallResponseState(this.response);
}

class DebitNotesListCallResponseState extends MainStates {
  final int newPage;
  final DebitNotesListResponse response;
  DebitNotesListCallResponseState(this.newPage, this.response);
}

class CreditNotesListCallResponseState extends MainStates {
  final int newPage;
  final CreditNotesListResponse response;
  CreditNotesListCallResponseState(this.newPage, this.response);
}

class AssetIssueListCallResponseState extends MainStates {
  final int newPage;
  final AssetIssueListResponse response;
  AssetIssueListCallResponseState(this.newPage, this.response);
}

class JournalVoucherListCallResponseState extends MainStates {
  final int newPage;
  final JournalVoucherListResponse response;
  JournalVoucherListCallResponseState(this.newPage, this.response);
}

class PettyCashListCallResponseState extends MainStates {
  final int newPage;
  final PettyCashListResponse response;
  PettyCashListCallResponseState(this.newPage, this.response);
}

class AssetReturnListCallResponseState extends MainStates {
  final int newPage;
  final AssetReturnListResponse response;
  AssetReturnListCallResponseState(this.newPage, this.response);
}

class OfficeRefTypeFromCustomerIDResponseState extends MainStates {
  final OfficeRefTypeFromCustomerIDResponse response;
  OfficeRefTypeFromCustomerIDResponseState(this.response);
}

class MultiExpenseApprovalListResponseState extends MainStates {
  final int newPage;
  final MultipleExpenseApprovalListResponse response;
  MultiExpenseApprovalListResponseState(this.newPage, this.response);
}

class MultiExpenseApprovalUpdateResponseState extends MainStates {
  final MultipleExpenseApprovalUpdateResponse response;
  MultiExpenseApprovalUpdateResponseState(this.response);
}

class MultiExpenseApprovalStatusListResponseState extends MainStates {
  final SalesOrderApprovalStatusListResponse response;
  MultiExpenseApprovalStatusListResponseState(this.response);
}

class QuickFollowupReportListResponseState extends MainStates {
  final QuickFollowupReportListResponse quickFollowupReportListResponse;

  QuickFollowupReportListResponseState(this.quickFollowupReportListResponse);
}

class ExpenseTrackingListResponseState extends MainStates {
  final int newPage;
  final ExpenseTrackingListResponse expenseTrackingListResponse;

  ExpenseTrackingListResponseState(
      this.newPage, this.expenseTrackingListResponse);
}

class ExpenseTrackingSaveResponseState extends MainStates {
  final ExpenseTrackingSaveResponse expenseTrackingSaveResponse;

  ExpenseTrackingSaveResponseState(this.expenseTrackingSaveResponse);
}
