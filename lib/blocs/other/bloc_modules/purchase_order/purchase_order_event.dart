/*
part of 'purchase_order_bloc.dart';

@immutable
abstract class PurchaseOrderEvent {}

///all events of AuthenticationEvents
class SalesOrderListCallEvent extends PurchaseOrderEvent {
  final int pageNo;
  final SalesOrderListApiRequest salesOrderListApiRequest;
  SalesOrderListCallEvent(this.pageNo, this.salesOrderListApiRequest);
}

class SearchSalesOrderListByNameCallEvent extends PurchaseOrderEvent {
  final SearchSalesOrderListByNameRequest request;

  SearchSalesOrderListByNameCallEvent(this.request);
}

class SearchSalesOrderListByNumberCallEvent extends PurchaseOrderEvent {
  final int pkID;
  final SearchSalesOrderListByNumberRequest request;

  SearchSalesOrderListByNumberCallEvent(this.pkID, this.request);
}

class SalesOrderPDFGenerateCallEvent extends PurchaseOrderEvent {
  final SalesOrderPDFGenerateRequest request;

  SalesOrderPDFGenerateCallEvent(this.request);
}

class SaleOrderBankDetailsListRequestEvent extends PurchaseOrderEvent {
  final BankNameDropDownRequest request;

  SaleOrderBankDetailsListRequestEvent(this.request);
}

class SaleOrderBankDetailsListDialogRequestEvent extends PurchaseOrderEvent {
  final BankNameDropDownRequest request;

  SaleOrderBankDetailsListDialogRequestEvent(this.request);
}

class QuotationProjectListCallEvent extends PurchaseOrderEvent {
  final QuotationProjectListRequest request;

  QuotationProjectListCallEvent(this.request);
}

class QuotationTermsConditionCallEvent extends PurchaseOrderEvent {
  final QuotationTermsConditionRequest request;

  QuotationTermsConditionCallEvent(this.request);
}

class SearchCustomerListByNumberCallEvent extends PurchaseOrderEvent {
  String IsFromDialog;
  final CustomerSearchByIdRequest request;

  SearchCustomerListByNumberCallEvent(this.IsFromDialog, this.request);
}

class SaleBill_INQ_QT_SO_NO_ListRequestEvent extends PurchaseOrderEvent {
  final SaleBill_INQ_QT_SO_NO_ListRequest request;
  SaleBill_INQ_QT_SO_NO_ListRequestEvent(this.request);
}

class MultiNoToProductDetailsRequestEvent extends PurchaseOrderEvent {
  String FromWhichScreen;
  final MultiNoToProductDetailsRequest request;
  MultiNoToProductDetailsRequestEvent(this.FromWhichScreen, this.request);
}

class MultiNoToProductDetailsRequestEvent1 extends PurchaseOrderEvent {
  String FromWhichScreen;
  final MultiNoToProductDetailsRequest request;
  MultiNoToProductDetailsRequestEvent1(this.FromWhichScreen, this.request);
}

class SalesBillEmailContentRequestEvent extends PurchaseOrderEvent {
  final SalesBillEmailContentRequest request;
  SalesBillEmailContentRequestEvent(this.request);
}

class ProjectTypeEvent extends PurchaseOrderEvent {
  final ProjectTypeListModelRequest projectTypeListModelRequest;
  ProjectTypeEvent(this.projectTypeListModelRequest);
}

class FCMNotificationRequestNewEvent extends PurchaseOrderEvent {
  //final FCMNotificationRequest request;
  var request123;
  FCMNotificationRequestNewEvent(this.request123);
}

class PaymentScheduleEvent extends PurchaseOrderEvent {
  //final FCMNotificationRequest request;
  SoPaymentScheduleTable soPaymentScheduleTable;
  PaymentScheduleEvent(this.soPaymentScheduleTable);
}

class PaymentScheduleListEvent extends PurchaseOrderEvent {
  //final FCMNotificationRequest request;
  PaymentScheduleListEvent();
}

class PaymentScheduleDeleteEvent extends PurchaseOrderEvent {
  //final FCMNotificationRequest request;

  int id;
  PaymentScheduleDeleteEvent(this.id);
}

class PaymentScheduleEditEvent extends PurchaseOrderEvent {
  //final FCMNotificationRequest request;
  SoPaymentScheduleTable soPaymentScheduleTable;
  PaymentScheduleEditEvent(this.soPaymentScheduleTable);
}

class PaymentScheduleDeleteAllItemEvent extends PurchaseOrderEvent {
  //final FCMNotificationRequest request;
  PaymentScheduleDeleteAllItemEvent();
}

class SaleOrderHeaderSaveRequestEvent extends PurchaseOrderEvent {
  int pkID;
  SaleOrderHeaderSaveRequest saleOrderHeaderSaveRequest;
  SOShipmentSaveRequest soShipmentSaveRequest;

  BuildContext context;
  SaleOrderHeaderSaveRequestEvent(this.context, this.pkID,
      this.saleOrderHeaderSaveRequest, this.soShipmentSaveRequest);
}

class SaleOrderProductSaveCallEvent extends PurchaseOrderEvent {
  String SO_NO;
  BuildContext context;
  final List<SalesOrderProductRequest> arrSalesOrderProductList;
  SaleOrderProductSaveCallEvent(
      this.context, this.SO_NO, this.arrSalesOrderProductList);
}

class SalesOrderProductDeleteRequestEvent extends PurchaseOrderEvent {
  final SalesOrderAllProductDeleteRequest SalesOrderProductDeleteRequest;
  SalesOrderProductDeleteRequestEvent(this.SalesOrderProductDeleteRequest);
}

class UserMenuRightsRequestEvent extends PurchaseOrderEvent {
  String MenuID;

  final UserMenuRightsRequest userMenuRightsRequest;
  UserMenuRightsRequestEvent(this.MenuID, this.userMenuRightsRequest);
}

class QuotationOtherCharge1CallEvent extends PurchaseOrderEvent {
  String CompanyID;

  final QuotationOtherChargesListRequest request;

  QuotationOtherCharge1CallEvent(this.CompanyID, this.request);
}

class GetGenericAddditionalChargesEvent extends PurchaseOrderEvent {
  GetGenericAddditionalChargesEvent();
}

class QuotationOtherChargeCallEvent extends PurchaseOrderEvent {
  String CompanyID;
  String headerDiscountController;
  final QuotationOtherChargesListRequest request;

  QuotationOtherChargeCallEvent(
      this.headerDiscountController, this.CompanyID, this.request);
}

class GetQuotationProductListEvent extends PurchaseOrderEvent {
  //final FCMNotificationRequest request;
  GetQuotationProductListEvent();
}

class InsertProductEvent extends PurchaseOrderEvent {
  List<SalesOrderTable> quotationTable;
  InsertProductEvent(this.quotationTable);
}

class getInsertProductEvent extends PurchaseOrderEvent {
  List<PurchaseOrderTable> quotationTable;
  getInsertProductEvent(this.quotationTable);
}

class DeleteAllQuotationProductEvent extends PurchaseOrderEvent {
  //final FCMNotificationRequest request;
  DeleteAllQuotationProductEvent();
}

class AddGenericAddditionalChargesEvent extends PurchaseOrderEvent {
  final GenericAddditionalCharges genericAddditionalCharges;

  AddGenericAddditionalChargesEvent(this.genericAddditionalCharges);
}

class DeleteGenericAddditionalChargesEvent extends PurchaseOrderEvent {
  DeleteGenericAddditionalChargesEvent();
}

class GetQuotationSpecificationTableEvent extends PurchaseOrderEvent {
  //final FCMNotificationRequest request;
  GetQuotationSpecificationTableEvent();
}

class QuotationSpecificationCallEvent extends PurchaseOrderEvent {
  final SpecificationListRequest request;

  QuotationSpecificationCallEvent(this.request);
}

class GenericOtherChargeCallEvent extends PurchaseOrderEvent {
  String CompanyID;

  final QuotationOtherChargesListRequest request;

  GenericOtherChargeCallEvent(this.CompanyID, this.request);
}

class SalesOrderDeleteRequestEvent extends PurchaseOrderEvent {
  String pkID;

  final SalesOrderDeleteRequest request;

  SalesOrderDeleteRequestEvent(this.pkID, this.request);
}

class SOCurrencyListRequestEvent extends PurchaseOrderEvent {
  final SOCurrencyListRequest request;

  SOCurrencyListRequestEvent(this.request);
}

class SaveEmailContentRequestEvent extends PurchaseOrderEvent {
  final SaveEmailContentRequest request;
  SaveEmailContentRequestEvent(this.request);
}

class SOProductOneDeleteEvent extends PurchaseOrderEvent {
  final int tableId;

  SOProductOneDeleteEvent(this.tableId);
}

class POProductOneDeleteEvent extends PurchaseOrderEvent {
  final int tableId;

  POProductOneDeleteEvent(this.tableId);
}

///Asembly OfflineDB CRUD
///
class SOAssemblyTableListEvent extends PurchaseOrderEvent {
  String finishProductID;
  SOAssemblyTableListEvent(this.finishProductID);
}

class SOAssemblyTableInsertEvent extends PurchaseOrderEvent {
  BuildContext context;
  final SOAssemblyTable soAssemblyTable;

  SOAssemblyTableInsertEvent(this.context, this.soAssemblyTable);
}

class SOAssemblyTableUpdateEvent extends PurchaseOrderEvent {
  BuildContext context;
  final SOAssemblyTable soAssemblyTable;
  SOAssemblyTableUpdateEvent(this.context, this.soAssemblyTable);
}

class SOAssemblyTableOneItemDeleteEvent extends PurchaseOrderEvent {
  int tableid;
  SOAssemblyTableOneItemDeleteEvent(this.tableid);
}

class SOAssemblyTableALLDeleteEvent extends PurchaseOrderEvent {
  SOAssemblyTableALLDeleteEvent();
}

class SalesTargetListCallEvent extends PurchaseOrderEvent {
  final int pageNo;
  final SalaryTargetListRequest salaryTargetListRequest;
  SalesTargetListCallEvent(this.pageNo, this.salaryTargetListRequest);
}

class SOShipmentListRequestEvent extends PurchaseOrderEvent {
  final SOShipmentListRequest soShipmentListRequest;
  PurchaseOrderListResponseDetails salesOrderDetails;

  SOShipmentListRequestEvent(
      this.soShipmentListRequest, this.salesOrderDetails);
}

class SOShipmentSaveRequestEvent extends PurchaseOrderEvent {
  final SOShipmentSaveRequest soShipmentSaveRequest;
  SOShipmentSaveRequestEvent(this.soShipmentSaveRequest);
}

class SOShipmentDeleteRequestEvent extends PurchaseOrderEvent {
  final SOShipmentDeleteRequest soShipmentDeleteRequest;
  SOShipmentDeleteRequestEvent(this.soShipmentDeleteRequest);
}
//SalesOrderApprovalListRequest

class SalesOrderApprovalListRequestEvent extends PurchaseOrderEvent {
  final SalesOrderApprovalListRequest salesOrderApprovalListRequest;
  SalesOrderApprovalListRequestEvent(this.salesOrderApprovalListRequest);
}

class IndentApprovalListRequestEvent extends PurchaseOrderEvent {
  final MaterialIndentApprovalRequest materialIndentApprovalRequest;
  IndentApprovalListRequestEvent(this.materialIndentApprovalRequest);
}

class SalesOrderApprovalSaveRequestEvent extends PurchaseOrderEvent {
  final SalesOrderApprovalSaveRequest salesOrderApprovalSaveRequest;
  BuildContext context;

  SalesOrderApprovalSaveRequestEvent(
      this.salesOrderApprovalSaveRequest, this.context);
}

class IndentApprovalSaveRequestEvent extends PurchaseOrderEvent {
  final MaterialIndentApprovalSaveRequest materialIndentApprovalSaveRequest;
  BuildContext context;
  IndentApprovalSaveRequestEvent(
      this.materialIndentApprovalSaveRequest, this.context);
}

class SalesOrderApprovalStatusListRequestEvent extends PurchaseOrderEvent {
  final SalesOrderApprovalStatusListRequest salesOrderApprovalStatusListRequest;
  SalesOrderApprovalStatusListRequestEvent(
      this.salesOrderApprovalStatusListRequest);
}

class SalesOrderAddressDropDownRequestEvent extends PurchaseOrderEvent {
  final SalesOrderAddressDropDownRequest salesOrderAddressDropDownRequest;
  SalesOrderAddressDropDownRequestEvent(this.salesOrderAddressDropDownRequest);
}

class SalesOrderAddressORGDropDownRequestEvent extends PurchaseOrderEvent {
  final SalesOrderAddressDropDownRequest salesOrderAddressDropDownRequest;
  SalesOrderAddressORGDropDownRequestEvent(
      this.salesOrderAddressDropDownRequest);
}

class SoNoToProductListCallEvent extends PurchaseOrderEvent {
  int StateCode;
  String LoginUserId;
  final SoNoToProductListRequest request;
  SoNoToProductListCallEvent(this.StateCode, this.LoginUserId, this.request);
}

class SoKindAttListCallEvent extends PurchaseOrderEvent {
  final QuotationKindAttListApiRequest request;

  SoKindAttListCallEvent(this.request);
}

class CountryCallEvent extends PurchaseOrderEvent {
  final CountryListRequest countryListRequest;
  CountryCallEvent(this.countryListRequest);
}

// PurchaseOrder
class PurchaseOrderListEvent extends PurchaseOrderEvent {
  final int pageNo;
  final PurchaseOrderListRequest purchaseOrderListRequest;

  PurchaseOrderListEvent(this.pageNo, this.purchaseOrderListRequest);
}

class PurchaseOrderDeleteCallEvent extends PurchaseOrderEvent {
  final PoHeaderDeleteRequest materialInwardDeleteRequest;

  PurchaseOrderDeleteCallEvent(this.materialInwardDeleteRequest);
}

class SalesBillPDFGenerateCallEvent extends PurchaseOrderEvent {
  final SalesBillPDFGenerateRequest request;

  SalesBillPDFGenerateCallEvent(this.request);
}
//
*/
