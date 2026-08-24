part of 'mainBloc.dart';

@immutable
abstract class MainEvents {}

///all events of AuthenticationEvents

/*class LoginUserDetailsCallEvent extends MainEvents {
  final LoginUserDetialsAPIRequest request;

  LoginUserDetailsCallEvent(this.request);
}*/
class MayankBankVoucherListEvent extends MainEvents {
  final MayankBankVoucherListRequest mayankBankVoucherListRequest;
  final int pageNo;

  MayankBankVoucherListEvent(this.pageNo, this.mayankBankVoucherListRequest);
}

class MayankBankVoucherDeleteEvent extends MainEvents {
  final MayankBankVoucherDeleteRequest mayankBankVoucherDeleteRequest;

  MayankBankVoucherDeleteEvent(this.mayankBankVoucherDeleteRequest);
}

class MayankSearchBankVoucherCustomerListByNameCallEvent extends MainEvents {
  final CustomerLabelValueRequest request;

  MayankSearchBankVoucherCustomerListByNameCallEvent(this.request);
}

class MayankTransectionModeCallEvent extends MainEvents {
  final TransectionModeListRequest request;

  MayankTransectionModeCallEvent(this.request);
}

class MayankBankVoucherModeCallEvent extends MainEvents {
  final MayankBankVoucherInqNoRequest request;

  MayankBankVoucherModeCallEvent(this.request);
}

class MayankBankVoucherAmountCallEvent extends MainEvents {
  final MayankBankVoucherAmountRequest request;

  MayankBankVoucherAmountCallEvent(this.request);
}

class MayankBankVoucherSaveCallEvent extends MainEvents {
  final MayankBankVoucherAddEditRequest mayankBankVoucherAddEditRequest;
  //final BuildContext context;

  MayankBankVoucherSaveCallEvent(
    //this.context,
    this.mayankBankVoucherAddEditRequest,
  );
}

class MayankBankVoucherDetailsListEvent extends MainEvents {
  final int pageNo;
  final MayankBankVoucherDetailsListRequest mayankBankVoucherDetailsListRequest;

  MayankBankVoucherDetailsListEvent(
      this.pageNo, this.mayankBankVoucherDetailsListRequest);
}

class MayankBankVoucherDeleteDetailsEvent extends MainEvents {
  final MayankBankVoucherDeleteDetailsRequest
      mayankBankVoucherDeleteDetailsRequest;

  MayankBankVoucherDeleteDetailsEvent(
      this.mayankBankVoucherDeleteDetailsRequest);
}

class MayankBankVoucherDetailsAddEditEvent extends MainEvents {
  final BuildContext context;
  final MayankBankVoucherDetailsAddEditRequest
      mayankBankVoucherDetailsAddEditRequest;

  MayankBankVoucherDetailsAddEditEvent(
      this.context, this.mayankBankVoucherDetailsAddEditRequest);
}

class MayankBankVoucherDetailsAddEditEvent1 extends MainEvents {
  final List<BankVoucherDetailsTable> _contactsList;

  MayankBankVoucherDetailsAddEditEvent1(this._contactsList);
}

/// Purchase_Order AND Purchase_Bill
class PurchaseBillListRequestEvent extends MainEvents {
  final int pageNo;
  final PurchaseBillListRequest purchaseBillListRequest;

  PurchaseBillListRequestEvent(this.pageNo, this.purchaseBillListRequest);
}

class PurchaseBillDeleteRequestEvent extends MainEvents {
  final PurchaseBillDeleteDeleteRequest purchaseBillDeleteDeleteRequest;

  PurchaseBillDeleteRequestEvent(this.purchaseBillDeleteDeleteRequest);
}

class GetPBProductListEvent extends MainEvents {
  GetPBProductListEvent();
}

class InsertPBProductEvent extends MainEvents {
  List<PurchaseBillTable> quotationTable;
  InsertPBProductEvent(this.quotationTable);
}

class PBProductOneDeleteEvent extends MainEvents {
  final int tableId;

  PBProductOneDeleteEvent(this.tableId);
}

class SearchCustomerListByNameCallEvent extends MainEvents {
  final CustomerLabelValueRequest request;

  SearchCustomerListByNameCallEvent(this.request);
}

class TaskCategoryListCallEvent extends MainEvents {
  final TaskCategoryListRequest taskCategoryListRequest;

  TaskCategoryListCallEvent(this.taskCategoryListRequest);
}

class ModulesDropDownListRequestEvent extends MainEvents {
  final ModulesDropDownListRequest taskCategoryListRequest;
  ModulesDropDownListRequestEvent(this.taskCategoryListRequest);
}

class SharvayaDailyActivityListEvent extends MainEvents {
  final int pageNo;
  final SharvayaDailyActivityListRequest sharvayaDailyActivityListRequest;

  SharvayaDailyActivityListEvent(
      this.pageNo, this.sharvayaDailyActivityListRequest);
}

class SharvayaDailyActivityDeleteEvent extends MainEvents {
  final SharvayaDailyActivityDeleteRequest sharvayaDailyActivityDeleteRequest;

  SharvayaDailyActivityDeleteEvent(this.sharvayaDailyActivityDeleteRequest);
}

class SharvayaDailyActivitySaveCallEvent extends MainEvents {
  final SharvayaDailyActivitySaveRequest sharvayaDailyActivitySaveRequest;

  SharvayaDailyActivitySaveCallEvent(
    this.sharvayaDailyActivitySaveRequest,
  );
}

class UserMenuRightsRequestEvent extends MainEvents {
  String MenuID;

  final UserMenuRightsRequest userMenuRightsRequest;
  UserMenuRightsRequestEvent(this.MenuID, this.userMenuRightsRequest);
}

/// Po
class PoKindAttListCallEvent extends MainEvents {
  final QuotationKindAttListApiRequest request;

  PoKindAttListCallEvent(this.request);
}

class PoProjectListCallEvent extends MainEvents {
  final QuotationProjectListRequest request;

  PoProjectListCallEvent(this.request);
}

class PoTermsConditionCallEvent extends MainEvents {
  final QuotationTermsConditionRequest request;

  PoTermsConditionCallEvent(this.request);
}

/// reports
class CustomerReportsListCallEvent extends MainEvents {
  final int pageNo;
  final CustomerReportListRequest customerPaginationRequest;

  CustomerReportsListCallEvent(this.pageNo, this.customerPaginationRequest);
}

class InquiryListReportCallEvent extends MainEvents {
  final int pageNo;
  final InquiryListApiRequest inquiryListApiRequest;
  InquiryListReportCallEvent(this.pageNo, this.inquiryListApiRequest);
}

class QuotationReportListCallEvent extends MainEvents {
  final int pageNo;
  final QuotationListApiRequest quotationListApiRequest;
  QuotationReportListCallEvent(this.pageNo, this.quotationListApiRequest);
}

/// outward
class MaterialOutwardListCallEvent extends MainEvents {
  final int pageNo;
  final MaterialOutwardListMainRequest materialOutwardListRequest;
  MaterialOutwardListCallEvent(this.pageNo, this.materialOutwardListRequest);
}

class MaterialOutwardDeleteCallEvent extends MainEvents {
  final MaterialOutwardDeleteRequest materialOutwardDeleteRequest;

  MaterialOutwardDeleteCallEvent(this.materialOutwardDeleteRequest);
}

class MaterialOutwardAddEditCallEvent extends MainEvents {
  final MaterialOutwardAddUpdateRequest materialOutwardAddUpdateRequest;
  MaterialOutwardExportSaveRequest materialOutwardExportSaveRequest;
  List<File> invoiceDocumentList;
  List<File> invoiceDocumentList1;
  MaterialOutwardAddEditCallEvent(
    this.materialOutwardAddUpdateRequest,
    this.materialOutwardExportSaveRequest,
    this.invoiceDocumentList,
    this.invoiceDocumentList1,
  );
}

class MaterialOutwardExportListRequestEvent extends MainEvents {
  final MaterialOutwardExportListMainRequest request;

  MaterialOutwardExportListRequestEvent(this.request);
}

class MaterialOutwardGetSoNoRequestEvent extends MainEvents {
  final MaterialOutwardPendingSalesOrderListRequest
      materialOutwardPendingSalesOrderListRequest;

  MaterialOutwardGetSoNoRequestEvent(
      this.materialOutwardPendingSalesOrderListRequest);
}

class MaterialOutwardGetDetailsSoNoRequestEvent extends MainEvents {
  String FromWhichScreen;
  final MaterialOutwardPendingSalesOrderDetailsListRequest
      materialOutwardPendingSalesOrderDetailsListRequest;

  MaterialOutwardGetDetailsSoNoRequestEvent(this.FromWhichScreen,
      this.materialOutwardPendingSalesOrderDetailsListRequest);
}

class GetMaterialOutwardProductListEvent extends MainEvents {
  GetMaterialOutwardProductListEvent();
}

class MaterialOutwardProductOneDeleteEvent extends MainEvents {
  final int tableId;

  MaterialOutwardProductOneDeleteEvent(this.tableId);
}

class MaterialOutwardConstantRequestEvent extends MainEvents {
  String CompanyID;
  final ConstantRequest request;

  MaterialOutwardConstantRequestEvent(this.CompanyID, this.request);
}

class MaterialOutwardDetailsDeleteCallEvent extends MainEvents {
  final MaterialOutwardDetailsDeleteRequest materialOutwardDetailsDeleteRequest;

  MaterialOutwardDetailsDeleteCallEvent(
      this.materialOutwardDetailsDeleteRequest);
}

class MaterialOutwardDetailsListCallEvent extends MainEvents {
  int StateCode;
  String LoginUserId;
  final MaterialOutwardDetailsListRequest materialOutwardDetailsListRequest;

  MaterialOutwardDetailsListCallEvent(
      this.StateCode, this.LoginUserId, this.materialOutwardDetailsListRequest);
}

class MaterialOutwardGetDetailsOutwardNoByFetchTypeRequestEvent
    extends MainEvents {
  String FromWhichScreen;
  final MaterialOutwardPendingSalesOrderByFetchTypeDetailsListRequest
      materialOutwardPendingSalesOrderByFetchTypeDetailsListRequest;

  MaterialOutwardGetDetailsOutwardNoByFetchTypeRequestEvent(
      this.FromWhichScreen,
      this.materialOutwardPendingSalesOrderByFetchTypeDetailsListRequest);
}

class SalesBillPDFGenerateCallEvent extends MainEvents {
  final SalesBillPDFGenerateRequest request;

  SalesBillPDFGenerateCallEvent(this.request);
}

class InvoiceDocumentDeleteRequestEvent extends MainEvents {
  final MaterialOutwardDocumentDeleteRequest vehicleDocumentDeleteRequest;

  InvoiceDocumentDeleteRequestEvent(this.vehicleDocumentDeleteRequest);
}

class InvoiceDocumentListRequestEvent extends MainEvents {
  String SiteURL;
  MaterialOutwardListMainResponseDetails paginationmodel;
  final MaterialOutwardModuleListRequest vehicleModuleListRequest;

  InvoiceDocumentListRequestEvent(
      this.SiteURL, this.paginationmodel, this.vehicleModuleListRequest);
}

class InvoiceDocumentOnlyNameListRequestEvent extends MainEvents {
  String SiteURL;
  MaterialOutwardListMainResponseDetails paginationmodel;

  final MaterialOutwardModuleListRequest vehicleModuleListRequest;

  InvoiceDocumentOnlyNameListRequestEvent(
      this.SiteURL, this.paginationmodel, this.vehicleModuleListRequest);
}

class InvoiceDocumentOnlyNameListRequestEvent1 extends MainEvents {
  String SiteURL;
  MaterialOutwardListMainResponseDetails paginationmodel;

  final MaterialOutwardModuleListRequest vehicleModuleListRequest;
  final MaterialOutwardExportListMainRequest soExportListRequest;

  InvoiceDocumentOnlyNameListRequestEvent1(this.SiteURL, this.paginationmodel,
      this.vehicleModuleListRequest, this.soExportListRequest);
}

class ModuleAttachmentsItemWiseDeleteRequestEvent extends MainEvents {
  ModuleAttachmentsItemWiseDeleteRequest moduleAttachmentsItemWiseDeleteRequest;
  ModuleAttachmentsItemWiseDeleteRequestEvent(
      this.moduleAttachmentsItemWiseDeleteRequest);
}

class DefDocumentListRequestEvent extends MainEvents {
  String SiteURL;
  MaterialOutwardListMainResponseDetails vehicleDefDetails;
  final MaterialOutwardModuleListRequest vehicleModuleListRequest;
  final MaterialOutwardExportListMainRequest soExportListRequest;

  DefDocumentListRequestEvent(this.SiteURL, this.vehicleDefDetails,
      this.vehicleModuleListRequest, this.soExportListRequest);
}

class MaintenanceTermsConditionCallEvent extends MainEvents {
  final QuotationTermsConditionRequest request;

  MaintenanceTermsConditionCallEvent(this.request);
}

class GetMaintenanceProductTableEvent extends MainEvents {
  GetMaintenanceProductTableEvent();
}

class MaintenanceOneProductDeleteEvent extends MainEvents {
  int tableid;
  MaintenanceOneProductDeleteEvent(this.tableid);
}

///Maintenance
class MaintenanceListCallEvent extends MainEvents {
  final int pageNo;
  final MaintenanceListRequest maintenanceListRequest;

  MaintenanceListCallEvent(this.pageNo, this.maintenanceListRequest);
}

class MaintenanceDeleteCallEvent extends MainEvents {
  final MaintenanceDeleteRequest maintenanceDeleteRequest;
  MaintenanceDeleteCallEvent(this.maintenanceDeleteRequest);
}

class MaintenanceAddUpdateRequestCallEvent extends MainEvents {
  final MaintenanceAddEditRequest maintenanceAddEditRequest;
  MaintenanceAddUpdateRequestCallEvent(this.maintenanceAddEditRequest);
}

class MaintenanceCheckListDRPRequestCallEvent extends MainEvents {
  final MaintenanceCheckListDRPRequest maintenanceCheckListDRPRequest;
  MaintenanceCheckListDRPRequestCallEvent(this.maintenanceCheckListDRPRequest);
}

class MasterMaintenanceCheckListRequestCallEvent extends MainEvents {
  final MasterMaintenanceCheckListRequest masterMaintenanceCheckListRequest;
  MasterMaintenanceCheckListRequestCallEvent(
      this.masterMaintenanceCheckListRequest);
}

class MasterMaintenanceCheckListRequestCallEvent1 extends MainEvents {
  final MasterMaintenanceCheckListRequest masterMaintenanceCheckListRequest;
  MasterMaintenanceCheckListRequestCallEvent1(
      this.masterMaintenanceCheckListRequest);
}

class InquiryLeadStatusTypeListByNameCallEvent extends MainEvents {
  final FollowupInquiryStatusTypeListRequest
      followupInquiryStatusTypeListRequest;

  InquiryLeadStatusTypeListByNameCallEvent(
      this.followupInquiryStatusTypeListRequest);
}

class MaintenanceDetailsListCallEvent extends MainEvents {
  String LoginUserId;
  final MaintenanceDetailsListRequest maintenanceDetailsListRequest;

  MaintenanceDetailsListCallEvent(
      this.LoginUserId, this.maintenanceDetailsListRequest);
}

class ALLEmployeeNameCallEvent extends MainEvents {
  final ALLEmployeeNameRequest allEmployeeNameRequest;

  ALLEmployeeNameCallEvent(this.allEmployeeNameRequest);
}

/// Repairing

class RepairingListCallEvent extends MainEvents {
  final int pageNo;
  final RepairingListRequest repairingListRequest;

  RepairingListCallEvent(this.pageNo, this.repairingListRequest);
}

class RepairingDeleteCallEvent extends MainEvents {
  final RepairingDeleteRequest repairingDeleteRequest;
  RepairingDeleteCallEvent(this.repairingDeleteRequest);
}

class RepairingAddUpdateRequestCallEvent extends MainEvents {
  final RepairingAddEditRequest repairingAddEditRequest;
  RepairingAddUpdateRequestCallEvent(this.repairingAddEditRequest);
}

class RepairingListByDRPNameCallEvent extends MainEvents {
  final MaintenanceCheckListDRPRequest followupInquiryStatusTypeListRequest;

  RepairingListByDRPNameCallEvent(this.followupInquiryStatusTypeListRequest);
}

class UpdateAuditActivityDetailsTableEvent extends MainEvents {
  BuildContext context;
  final RepairingDetailsTable auditActivityDetailsTable;
  UpdateAuditActivityDetailsTableEvent(
      this.context, this.auditActivityDetailsTable);
}

class RepairingDetailsListCallEvent extends MainEvents {
  String LoginUserId;
  final RepairingDetailsListRequest maintenanceDetailsListRequest;

  RepairingDetailsListCallEvent(
      this.LoginUserId, this.maintenanceDetailsListRequest);
}

class RepairingLogListCallEvent extends MainEvents {
  final RepairingLogListRequest repairingLogListRequest;
  RepairingLogListCallEvent(this.repairingLogListRequest);
}

///Materials Inwards

class MaterialInwardListMeetCallEvent extends MainEvents {
  final int pageNo;
  final MaterialInwardListRequestMeet materialInwardListRequestMeet;
  MaterialInwardListMeetCallEvent(
      this.pageNo, this.materialInwardListRequestMeet);
}

class MaterialInwardDeleteCallEvent extends MainEvents {
  final MaterialInwardDeleteRequest materialInwardDeleteRequest;

  MaterialInwardDeleteCallEvent(this.materialInwardDeleteRequest);
}

class MaterialInwardCustomerListCallEvent extends MainEvents {
  final MaterialInwardCustomerListRequest materialInwardCustomerListRequest;
  MaterialInwardCustomerListCallEvent(this.materialInwardCustomerListRequest);
}

class MaterialInwardMasterSaveEvent extends MainEvents {
  final MaterialInwardMasterSaveRequest materialInwardMasterSaveRequest;
  MaterialInwardMasterSaveEvent(this.materialInwardMasterSaveRequest);
}

class MaterialInwardDetailsListEvent extends MainEvents {
  MaterialInwardDetailsListEvent();
}

class MaterialInwardDetailsDeleteEvent extends MainEvents {
  final int tableId;

  MaterialInwardDetailsDeleteEvent(this.tableId);
}

// Inward details list call kari che header ma j sql and offline db ma store thya he
class MaterialInwardDetailsListCallEvent extends MainEvents {
  String LoginUserId;
  String StateCode;
  String LocationID;
  final MaterialInwardDetailListRequest materialInwardDetailListRequest;
  MaterialInwardDetailsListCallEvent(this.LoginUserId,
      this.materialInwardDetailListRequest, this.StateCode, this.LocationID);
}

class GetOrderNoFromTheCustomerIdCallEvent extends MainEvents {
  String FromWhichScreen;
  final MaterialOutwardPendingSalesOrderDetailsListRequest
      materialOutwardPendingSalesOrderDetailsListRequest;

  GetOrderNoFromTheCustomerIdCallEvent(this.FromWhichScreen,
      this.materialOutwardPendingSalesOrderDetailsListRequest);
}

class MaterialInwardGetPoNoRequestEvent extends MainEvents {
  final MIGetOrderNoFromTheCustomerIdRequest
      mIGetOrderNoFromTheCustomerIdRequest;

  MaterialInwardGetPoNoRequestEvent(this.mIGetOrderNoFromTheCustomerIdRequest);
}

class MaterialInwardGetDetailsPoNoRequestEvent extends MainEvents {
  String FromWhichScreen;
  final MIGetFetDetailByOrderNoListRequest mIGetFetDetailByOrderNoListRequest;

  MaterialInwardGetDetailsPoNoRequestEvent(
      this.FromWhichScreen, this.mIGetFetDetailByOrderNoListRequest);
}

// PurchaseOrder
class PurchaseOrderListEvent extends MainEvents {
  final int pageNo;
  final PurchaseOrderListRequest purchaseOrderListRequest;

  PurchaseOrderListEvent(this.pageNo, this.purchaseOrderListRequest);
}

class PurchaseOrderDeleteCallEvent extends MainEvents {
  final PoHeaderDeleteRequest materialInwardDeleteRequest;

  PurchaseOrderDeleteCallEvent(this.materialInwardDeleteRequest);
}

class POApprovalListRequestEvent extends MainEvents {
  final POApprovalRequest poApprovalRequest;
  POApprovalListRequestEvent(this.poApprovalRequest);
}

class POApprovalSaveRequestEvent extends MainEvents {
  final POApprovalSaveRequest poApprovalSaveRequest;
  BuildContext context;
  POApprovalSaveRequestEvent(this.poApprovalSaveRequest, this.context);
}

class POApprovalStatusListRequestEvent extends MainEvents {
  final SalesOrderApprovalStatusListRequest statusListRequest;
  POApprovalStatusListRequestEvent(this.statusListRequest);
}

class PODrpListRequestEvent extends MainEvents {
  final PODrpListRequest poApprovalRequest;
  PODrpListRequestEvent(this.poApprovalRequest);
}

///ServiceReport

class ServiceReportListEvent extends MainEvents {
  final int pageNo;
  final ServiceReportListRequest serviceReportListRequest;

  ServiceReportListEvent(this.pageNo, this.serviceReportListRequest);
}

class ServiceReportDeleteRequestEvent extends MainEvents {
  final ServiceReportDeleteRequest serviceReportDeleteRequest;

  ServiceReportDeleteRequestEvent(this.serviceReportDeleteRequest);
}

class ServiceReportAddUpdateRequestEvent extends MainEvents {
  final ServiceReportAddUpdateRequest serviceReportAddUpdateRequest;
  ServiceReportAddUpdateRequestEvent(this.serviceReportAddUpdateRequest);
}

class MachineTypeListCallEvent extends MainEvents {
  final MachineMasterListRequest machineMasterListRequest;
  MachineTypeListCallEvent(this.machineMasterListRequest);
}

class ServiceReportDetailsListRequestEvent extends MainEvents {
  String LoginUserID;
  final ServiceReportDetailsListRequest serviceReportDetailsListRequest;
  ServiceReportDetailsListRequestEvent(
      this.LoginUserID, this.serviceReportDetailsListRequest);
}

/// ShortInvoice
class ShortInvoiceListRequestEvent extends MainEvents {
  final int pageNo;
  final ShortInvoiceListRequest shortInvoiceListRequest;
  ShortInvoiceListRequestEvent(this.pageNo, this.shortInvoiceListRequest);
}

class ShortInvoiceDeleteRequestEvent extends MainEvents {
  final ShortInvoiceDeleteRequest shortInvoiceDeleteRequest;
  ShortInvoiceDeleteRequestEvent(this.shortInvoiceDeleteRequest);
}

class PaymentScheduleListEvent extends MainEvents {
  PaymentScheduleListEvent();
}

class PaymentScheduleDeleteAllItemEvent extends MainEvents {
  PaymentScheduleDeleteAllItemEvent();
}

class DeleteGenericAdditionalChargesEvent extends MainEvents {
  DeleteGenericAdditionalChargesEvent();
}

class GenericOtherChargeCallEvent extends MainEvents {
  String CompanyID;
  final QuotationOtherChargesListRequest request;
  GenericOtherChargeCallEvent(this.CompanyID, this.request);
}

class SaleBill_INQ_QT_SO_NO_ListRequestEvent extends MainEvents {
  final SaleBill_INQ_QT_SO_NO_ListRequest request;
  SaleBill_INQ_QT_SO_NO_ListRequestEvent(this.request);
}

class AddGenericAdditionalChargesEvent extends MainEvents {
  final GenericAddditionalCharges genericAddditionalCharges;

  AddGenericAdditionalChargesEvent(this.genericAddditionalCharges);
}

class SaleOrderBankDetailsListRequestEvent extends MainEvents {
  final BankNameDropDownRequest request;

  SaleOrderBankDetailsListRequestEvent(this.request);
}

class SaleOrderBankDetailsListDialogRequestEvent extends MainEvents {
  final BankNameDropDownRequest request;

  SaleOrderBankDetailsListDialogRequestEvent(this.request);
}

class QuotationProjectListCallEvent extends MainEvents {
  final QuotationProjectListRequest request;

  QuotationProjectListCallEvent(this.request);
}

class QuotationTermsConditionCallEvent extends MainEvents {
  final QuotationTermsConditionRequest request;

  QuotationTermsConditionCallEvent(this.request);
}

class SalesBillEmailContentRequestEvent extends MainEvents {
  final SalesBillEmailContentRequest request;
  SalesBillEmailContentRequestEvent(this.request);
}

class PaymentScheduleDeleteEvent extends MainEvents {
  int id;
  PaymentScheduleDeleteEvent(this.id);
}

class PaymentScheduleEvent extends MainEvents {
  SoPaymentScheduleTable soPaymentScheduleTable;
  PaymentScheduleEvent(this.soPaymentScheduleTable);
}

class SearchCustomerListByNumberCallEvent extends MainEvents {
  String IsFromDialog;
  final CustomerSearchByIdRequest request;
  SearchCustomerListByNumberCallEvent(this.IsFromDialog, this.request);
}

class MultiNoToProductDetailsRequestEvent extends MainEvents {
  String FromWhichScreen;
  final MultiNoToProductDetailsRequest request;
  MultiNoToProductDetailsRequestEvent(this.FromWhichScreen, this.request);
}

class SalesOrderAddressDropDownRequestEvent extends MainEvents {
  final SalesOrderAddressDropDownRequest salesOrderAddressDropDownRequest;
  SalesOrderAddressDropDownRequestEvent(this.salesOrderAddressDropDownRequest);
}

class QuotationOtherChargeCallEvent extends MainEvents {
  String CompanyID;
  String headerDiscountController;
  final QuotationOtherChargesListRequest request;

  QuotationOtherChargeCallEvent(
      this.headerDiscountController, this.CompanyID, this.request);
}

class SalesOrderAddressORGDropDownRequestEvent extends MainEvents {
  final SalesOrderAddressDropDownRequest salesOrderAddressDropDownRequest;
  SalesOrderAddressORGDropDownRequestEvent(
      this.salesOrderAddressDropDownRequest);
}

class SaveEmailContentRequestEvent extends MainEvents {
  final SaveEmailContentRequest request;
  SaveEmailContentRequestEvent(this.request);
}

class PaymentScheduleEditEvent extends MainEvents {
  SoPaymentScheduleTable soPaymentScheduleTable;
  PaymentScheduleEditEvent(this.soPaymentScheduleTable);
}

class GetSIProductListEvent extends MainEvents {
  GetSIProductListEvent();
}

class SIProductOneDeleteEvent extends MainEvents {
  final int tableId;

  SIProductOneDeleteEvent(this.tableId);
}

class InsertProductEvent extends MainEvents {
  List<ShortInvoiceTable> quotationTable;
  InsertProductEvent(this.quotationTable);
}

class QuotationOtherCharge1CallEvent extends MainEvents {
  String CompanyID;
  final QuotationOtherChargesListRequest request;
  QuotationOtherCharge1CallEvent(this.CompanyID, this.request);
}

class GetGenericAdditionalChargesEvent extends MainEvents {
  GetGenericAdditionalChargesEvent();
}

class DeleteAllQuotationProductEvent extends MainEvents {
  DeleteAllQuotationProductEvent();
}

class ShortInvoiceShipmentListRequestEvent extends MainEvents {
  final ShortInvoiceShipmentListRequest request;
  ShortInvoiceShipmentListRequestEvent(this.request);
}

class ShortInvoiceExportListRequestEvent extends MainEvents {
  final ShortInvoiceExportListRequest request;
  ShortInvoiceExportListRequestEvent(this.request);
}

class ShortInvoiceDetailsListRequestEvent extends MainEvents {
  int StateCode;
  String LoginUserId;
  final ShortInvoiceDetailsListRequest request;
  ShortInvoiceDetailsListRequestEvent(
      this.StateCode, this.LoginUserId, this.request);
}

class ShortInvoiceAddUpdateRequestEvent extends MainEvents {
  BuildContext context;
  final ShortInvoiceAddUpdateRequest request;
  ShortInvoiceAddUpdateRequestEvent(this.context, this.request);
}

class ShortInvoiceProductSaveCallEvent extends MainEvents {
  String SO_NO;
  BuildContext context;
  final List<ShortInvoiceProductRequest> arrSalesOrderProductList;
  ShortInvoiceProductSaveCallEvent(
      this.context, this.SO_NO, this.arrSalesOrderProductList);
}

class ShortInvoiceExportAddUpdateRequestEvent extends MainEvents {
  final ShortInvoiceExportSaveRequest request;
  ShortInvoiceExportAddUpdateRequestEvent(this.request);
}

class ShortInvoiceShipmentAddUpdateRequestEvent extends MainEvents {
  final ShortInvoiceShipmentSaveRequest request;
  ShortInvoiceShipmentAddUpdateRequestEvent(this.request);
}

class ShortInvoiceDetailsDeleteCallEvent extends MainEvents {
  final ShortInvoiceDetailsListRequest shortInvoiceDetailsListRequest;

  ShortInvoiceDetailsDeleteCallEvent(this.shortInvoiceDetailsListRequest);
}

class ProductListRequestEvent extends MainEvents {
  final ProductMasterListRequest productMasterListRequest;
  ProductListRequestEvent(this.productMasterListRequest);
}

class ShortInvoiceAssemblyLoadListRequestEvent extends MainEvents {
  int finishProductID;
  final ShortInvoiceAssemblyLoadRequest shortInvoiceAssemblyLoadRequest;
  ShortInvoiceAssemblyLoadListRequestEvent(
      this.finishProductID, this.shortInvoiceAssemblyLoadRequest);
}

class ShortInvoiceProductListRequestEvent extends MainEvents {
  final ProductMasterListRequest productMasterListRequest;
  ShortInvoiceProductListRequestEvent(this.productMasterListRequest);
}

////Purchase Bill

class PurchaseBillAddUpdateRequestEvent extends MainEvents {
  BuildContext context;
  final PurchaseBillAddUpdateRequest request;
  PurchaseBillAddUpdateRequestEvent(this.context, this.request);
}

class PurchaseBillDetailsListRequestEvent extends MainEvents {
  int StateCode;
  String LoginUserId;
  final PurchaseBillDetailsListRequest request;
  PurchaseBillDetailsListRequestEvent(
      this.StateCode, this.LoginUserId, this.request);
}

class PurchaseBillDetailsDeleteCallEvent extends MainEvents {
  final PurchaseBillDetailsListRequest shortInvoiceDetailsListRequest;

  PurchaseBillDetailsDeleteCallEvent(this.shortInvoiceDetailsListRequest);
}

class PurchaseBillDetailsAddUpdateCallEvent extends MainEvents {
  String SO_NO;
  BuildContext context;
  final List<PurchaseBillDetailsAddUpdateRequest> arrSalesOrderProductList;
  PurchaseBillDetailsAddUpdateCallEvent(
      this.context, this.SO_NO, this.arrSalesOrderProductList);
}

class MultiNoToProductDetailsFromGrnRequestEvent extends MainEvents {
  String FromWhichScreen;
  final MultiNoToProductDetailsRequest request;
  MultiNoToProductDetailsFromGrnRequestEvent(
      this.FromWhichScreen, this.request);
}

class MultiNoToProductDetailsFromPurchaseOrderRequestEvent extends MainEvents {
  String FromWhichScreen;
  final MultiNoToProductDetailsRequest request;
  MultiNoToProductDetailsFromPurchaseOrderRequestEvent(
      this.FromWhichScreen, this.request);
}

class PurchaseBillACRequestEvent extends MainEvents {
  final PurchaseBillACRequest request;
  PurchaseBillACRequestEvent(this.request);
}

class PurchaseBillTODRequestEvent extends MainEvents {
  final PurchaseBillTODRequest request;
  PurchaseBillTODRequestEvent(this.request);
}

class PurchaseBillDeleteCallEvent extends MainEvents {
  final PoHeaderDeleteRequest materialInwardDeleteRequest;

  PurchaseBillDeleteCallEvent(this.materialInwardDeleteRequest);
}

class GetPOProductListEvent extends MainEvents {
  GetPOProductListEvent();
}

class POProductOneDeleteEvent extends MainEvents {
  final int tableId;

  POProductOneDeleteEvent(this.tableId);
}

class ConstantRequestEvent extends MainEvents {
  String CompanyID;
  final ConstantRequest request;

  ConstantRequestEvent(this.CompanyID, this.request);
}

class InsertPOProductEvent extends MainEvents {
  List<PurchaseOrderTable> quotationTable;
  InsertPOProductEvent(this.quotationTable);
}

class QuotationKindAttListCallEvent extends MainEvents {
  final QuotationKindAttListApiRequest request;

  QuotationKindAttListCallEvent(this.request);
}

class QuotationOrganizationListRequestEvent extends MainEvents {
  final QuotationOrganazationListRequest quotationOrganazationListRequest;

  QuotationOrganizationListRequestEvent(this.quotationOrganazationListRequest);
}

///Purchase Order

class PurchaseOrderAddUpdateRequestEvent extends MainEvents {
  BuildContext context;
  final PurchaseOrderAddUpdateRequest request;
  PurchaseOrderAddUpdateRequestEvent(this.context, this.request);
}

class PurchaseOrderDetailsListRequestEvent extends MainEvents {
  int StateCode;
  String LoginUserId;
  final PurchaseOrderDetailsListRequest request;
  PurchaseOrderDetailsListRequestEvent(
      this.StateCode, this.LoginUserId, this.request);
}

class PurchaseOrderDetailsDeleteCallEvent extends MainEvents {
  final PurchaseOrderDetailsListRequest shortInvoiceDetailsListRequest;

  PurchaseOrderDetailsDeleteCallEvent(this.shortInvoiceDetailsListRequest);
}

class PurchaseOrderDetailsAddUpdateCallEvent extends MainEvents {
  String SO_NO;
  BuildContext context;
  final List<PurchaseOrderDetailsAddUpdateRequest> arrSalesOrderProductList;
  PurchaseOrderDetailsAddUpdateCallEvent(
      this.context, this.SO_NO, this.arrSalesOrderProductList);
}

class PurchaseOrderShipmentListRequestEvent extends MainEvents {
  final PurchaseOrderShipmentListRequest request;
  PurchaseOrderShipmentListRequestEvent(this.request);
}

class PurchaseOrderShipmentAddUpdateRequestEvent extends MainEvents {
  final PurchaseOrderShipmentSaveRequest request;
  PurchaseOrderShipmentAddUpdateRequestEvent(this.request);
}

class POFromTheIndentNumberEvent extends MainEvents {
  final PoFromTheIndentListRequest request;
  POFromTheIndentNumberEvent(this.request);
}

class PoTankerDrpListRequestEvent extends MainEvents {
  final POTankerListRequest request;
  PoTankerDrpListRequestEvent(this.request);
}

class PoDriverDrpListRequestEvent extends MainEvents {
  final PODriverListRequest request;
  PoDriverDrpListRequestEvent(this.request);
}

class LocationListForInwardCallEvent extends MainEvents {
  final LocationListRequest locationListRequest;
  LocationListForInwardCallEvent(this.locationListRequest);
}

class LocationListCallEvent extends MainEvents {
  final DashboardLocationListRequest allEmployeeNameRequest;

  LocationListCallEvent(this.allEmployeeNameRequest);
}

class LocationLogListCallEvent extends MainEvents {
  final DashboardLocationListRequest allEmployeeNameRequest;

  LocationLogListCallEvent(this.allEmployeeNameRequest);
}

class PaySlipListListCallEvent extends MainEvents {
  final PaySlipListRequest paySlipListRequest;
  PaySlipListListCallEvent(this.paySlipListRequest);
}

class SalesOrderPDFGenerateCallEvent extends MainEvents {
  final SalesOrderPDFGenerateRequest request;

  SalesOrderPDFGenerateCallEvent(this.request);
}

/// Visitor management

class VisitorInfoListCallRequestEvent extends MainEvents {
  final VisitorInfoListApiRequest visitorInfoListApiRequest;
  final int pageNo;

  VisitorInfoListCallRequestEvent(this.pageNo, this.visitorInfoListApiRequest);
}

class VisitorInfoDeleteCallRequestEvent extends MainEvents {
  final VisitorInfoDeleteApiRequest visitorInfoDeleteApiRequest;

  VisitorInfoDeleteCallRequestEvent(this.visitorInfoDeleteApiRequest);
}

class VisitorInfoAddUpdateCallRequestEvent extends MainEvents {
  final VisitorInfoAddUpdateApiRequest request;

  VisitorInfoAddUpdateCallRequestEvent(this.request);
}

class CountryCallEvent extends MainEvents {
  final CountryListRequest countryListRequest;
  CountryCallEvent(this.countryListRequest);
}

class StateCallEvent extends MainEvents {
  final StateListRequest stateListRequest;
  StateCallEvent(this.stateListRequest);
}

class CityCallEvent extends MainEvents {
  final CityApiRequest cityApiRequest;
  CityCallEvent(this.cityApiRequest);
}

class SOCustomerNearByPinCodeSummaryRequestEvent extends MainEvents {
  final SOCustomerNearByPinCodeCommonRequest
      sOCustomerNearByPinCodeCommonRequest;
  SOCustomerNearByPinCodeSummaryRequestEvent(
      this.sOCustomerNearByPinCodeCommonRequest);
}

class SOCustomerNearByPinCodeDetailsRequestEvent extends MainEvents {
  final SOCustomerNearByPinCodeCommonRequest
      sOCustomerNearByPinCodeCommonRequest;
  SOCustomerNearByPinCodeDetailsRequestEvent(
      this.sOCustomerNearByPinCodeCommonRequest);
}

class InquiryProductSearchNameCallEvent extends MainEvents {
  final InquiryProductSearchRequest inquiryProductSearchRequest;

  InquiryProductSearchNameCallEvent(this.inquiryProductSearchRequest);
}

class SOCurrencyListRequestEvent extends MainEvents {
  final SOCurrencyListRequest request;

  SOCurrencyListRequestEvent(this.request);
}

class MaterialIndentListRequestEvent extends MainEvents {
  final MaterialIndentListRequest materialIndentListRequest;
  final int pageNo;

  MaterialIndentListRequestEvent(this.pageNo, this.materialIndentListRequest);
}

class MaterialIndentApprovalUpdateRequestEvent extends MainEvents {
  final MaterialIndentApprovalUpdateRequest materialIndentApprovalUpdateRequest;

  MaterialIndentApprovalUpdateRequestEvent(
      this.materialIndentApprovalUpdateRequest);
}

class MultiExpenseListRequestEvent extends MainEvents {
  final MultiExpenseListRequest multiExpenseListRequest;
  final int pageNo;

  MultiExpenseListRequestEvent(this.pageNo, this.multiExpenseListRequest);
}

class MultiExpenseDeleteRequestEvent extends MainEvents {
  final MultiExpenseDeleteRequest multiExpenseDeleteRequest;

  MultiExpenseDeleteRequestEvent(this.multiExpenseDeleteRequest);
}

class MultiExpenseAddUpdateRequestEvent extends MainEvents {
  final MultiExpenseAddUpdateRequest multiExpenseAddUpdateRequest;
  MultiExpenseAddUpdateRequestEvent(this.multiExpenseAddUpdateRequest);
}

class MultiExpenseADetailsListRequestEvent extends MainEvents {
  final String SiteURL;
  final MultiExpenseListRequest multiExpenseListRequest;

  MultiExpenseADetailsListRequestEvent(
      this.SiteURL, this.multiExpenseListRequest);
}

class MultiExpenseTypeListRequestEvent extends MainEvents {
  final MultiExpenseTypeListRequest multiExpenseTypeListRequest;

  MultiExpenseTypeListRequestEvent(this.multiExpenseTypeListRequest);
}

class MultiExpenseModeListRequestEvent extends MainEvents {
  final MultiExpenseModeListRequest multiExpenseModeListRequest;

  MultiExpenseModeListRequestEvent(this.multiExpenseModeListRequest);
}

class ExpenseCustomerListCallRequestEvent extends MainEvents {
  final CustomerPaginationRequest customerPaginationRequest;

  ExpenseCustomerListCallRequestEvent(this.customerPaginationRequest);
}

class DebitCreditNotesListCallRequestEvent extends MainEvents {
  final DebitCreditNotesListRequest debitCreditNotesListRequest;
  final int pageNo;

  DebitCreditNotesListCallRequestEvent(
      this.debitCreditNotesListRequest, this.pageNo);
}

class JournalVoucherMstAssetListCallRequestEvent extends MainEvents {
  final JournalVoucherMstAssetListRequest journalVoucherMstAssetListRequest;
  final int pageNo;

  JournalVoucherMstAssetListCallRequestEvent(
      this.journalVoucherMstAssetListRequest, this.pageNo);
}

class AssetIssueListCallRequestEvent extends MainEvents {
  final JournalVoucherMstAssetListRequest journalVoucherMstAssetListRequest;
  final int pageNo;

  AssetIssueListCallRequestEvent(
      this.journalVoucherMstAssetListRequest, this.pageNo);
}

class AssetReturnListCallRequestEvent extends MainEvents {
  final JournalVoucherMstAssetListRequest journalVoucherMstAssetListRequest;
  final int pageNo;

  AssetReturnListCallRequestEvent(
      this.journalVoucherMstAssetListRequest, this.pageNo);
}

class PettyCashListCallRequestEvent extends MainEvents {
  final PettyCashListRequest pettyCashListRequest;
  final int pageNo;

  PettyCashListCallRequestEvent(this.pettyCashListRequest, this.pageNo);
}

class OfficeRefTypeFromCustomerIDRequestEvent extends MainEvents {
  final OfficeRefTypeFromCustomerIDRequest officeRefTypeFromCustomerIDRequest;
  OfficeRefTypeFromCustomerIDRequestEvent(
      this.officeRefTypeFromCustomerIDRequest);
}

class MultiExpenseApprovalListRequestEvent extends MainEvents {
  final MultiExpenseApprovalListRequest multiExpenseApprovalListRequest;
  final int pageNo;

  MultiExpenseApprovalListRequestEvent(
      this.multiExpenseApprovalListRequest, this.pageNo);
}

class MultiExpenseApprovalStatusListRequestEvent extends MainEvents {
  final SalesOrderApprovalStatusListRequest statusListRequest;

  MultiExpenseApprovalStatusListRequestEvent(this.statusListRequest);
}

class MultiExpenseApprovalUpdateRequestEvent extends MainEvents {
  final MultiExpenseApprovalUpdateRequest multiExpenseApprovalUpdateRequest;
  MultiExpenseApprovalUpdateRequestEvent(
      this.multiExpenseApprovalUpdateRequest);
}


class QuickFollowupReportListRequestEvent extends MainEvents {
  final QuickFollowupReportListRequest quickFollowupReportListRequest;

  QuickFollowupReportListRequestEvent(this.quickFollowupReportListRequest);
}

class ExpenseTrackingListCallEvent extends MainEvents {
  final ExpenseTrackingListRequest expenseTrackingListRequest;

  ExpenseTrackingListCallEvent(this.expenseTrackingListRequest);
}

class ExpenseTrackingSaveCallEvent extends MainEvents {
  final ExpenseTrackingSaveRequest expenseTrackingSaveRequest;

  ExpenseTrackingSaveCallEvent(this.expenseTrackingSaveRequest);
}
