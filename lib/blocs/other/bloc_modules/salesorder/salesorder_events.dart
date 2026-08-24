part of 'salesorder_bloc.dart';

@immutable
abstract class SalesOrderEvents {}

///all events of AuthenticationEvents
class SalesOrderListCallEvent extends SalesOrderEvents {
  final int pageNo;
  final SalesOrderListApiRequest salesOrderListApiRequest;
  SalesOrderListCallEvent(this.pageNo, this.salesOrderListApiRequest);
}

class SearchSalesOrderListByNameCallEvent extends SalesOrderEvents {
  final SearchSalesOrderListByNameRequest request;

  SearchSalesOrderListByNameCallEvent(this.request);
}

class SearchSalesOrderListByNumberCallEvent extends SalesOrderEvents {
  final int pkID;
  final SearchSalesOrderListByNumberRequest request;

  SearchSalesOrderListByNumberCallEvent(this.pkID, this.request);
}

class SalesOrderPDFGenerateCallEvent extends SalesOrderEvents {
  final SalesOrderPDFGenerateRequest request;

  SalesOrderPDFGenerateCallEvent(this.request);
}

class SaleOrderBankDetailsListRequestEvent extends SalesOrderEvents {
  final BankNameDropDownRequest request;

  SaleOrderBankDetailsListRequestEvent(this.request);
}

class SaleOrderBankDetailsListDialogRequestEvent extends SalesOrderEvents {
  final BankNameDropDownRequest request;

  SaleOrderBankDetailsListDialogRequestEvent(this.request);
}

class QuotationProjectListCallEvent extends SalesOrderEvents {
  final QuotationProjectListRequest request;

  QuotationProjectListCallEvent(this.request);
}

class QuotationTermsConditionCallEvent extends SalesOrderEvents {
  final QuotationTermsConditionRequest request;

  QuotationTermsConditionCallEvent(this.request);
}

class SearchCustomerListByNumberCallEvent extends SalesOrderEvents {
  String IsFromDialog;
  final CustomerSearchByIdRequest request;

  SearchCustomerListByNumberCallEvent(this.IsFromDialog, this.request);
}

class SaleBill_INQ_QT_SO_NO_ListRequestEvent extends SalesOrderEvents {
  final SaleBill_INQ_QT_SO_NO_ListRequest request;
  SaleBill_INQ_QT_SO_NO_ListRequestEvent(this.request);
}

class MultiNoToProductDetailsRequestEvent extends SalesOrderEvents {
  String FromWhichScreen;
  final MultiNoToProductDetailsRequest request;
  MultiNoToProductDetailsRequestEvent(this.FromWhichScreen, this.request);
}

class MultiNoToProductDetailsRequestEvent1 extends SalesOrderEvents {
  String FromWhichScreen;
  final MultiNoToProductDetailsRequest request;
  MultiNoToProductDetailsRequestEvent1(this.FromWhichScreen, this.request);
}

class SalesBillEmailContentRequestEvent extends SalesOrderEvents {
  final SalesBillEmailContentRequest request;
  SalesBillEmailContentRequestEvent(this.request);
}

//MultiNoToProductDetailsRequest
/*class FCMNotificationRequestEvent extends SalesOrderEvents {
  //final FCMNotificationRequest request;
  var request123;
  FCMNotificationRequestEvent(this.request123);
}*/

class FCMNotificationRequestNewEvent extends SalesOrderEvents {
  //final FCMNotificationRequest request;
  var request123;
  FCMNotificationRequestNewEvent(this.request123);
}

class PaymentScheduleEvent extends SalesOrderEvents {
  //final FCMNotificationRequest request;
  SoPaymentScheduleTable soPaymentScheduleTable;
  PaymentScheduleEvent(this.soPaymentScheduleTable);
}

class PaymentScheduleListEvent extends SalesOrderEvents {
  //final FCMNotificationRequest request;
  PaymentScheduleListEvent();
}

class PaymentScheduleDeleteEvent extends SalesOrderEvents {
  //final FCMNotificationRequest request;

  int id;
  PaymentScheduleDeleteEvent(this.id);
}

class PaymentScheduleEditEvent extends SalesOrderEvents {
  //final FCMNotificationRequest request;
  SoPaymentScheduleTable soPaymentScheduleTable;
  PaymentScheduleEditEvent(this.soPaymentScheduleTable);
}

class PaymentScheduleDeleteAllItemEvent extends SalesOrderEvents {
  //final FCMNotificationRequest request;
  PaymentScheduleDeleteAllItemEvent();
}

class SaleOrderHeaderSaveRequestEvent extends SalesOrderEvents {
  int pkID;
  SaleOrderHeaderSaveRequest saleOrderHeaderSaveRequest;

  SOShipmentSaveRequest soShipmentSaveRequest;

  SOExportSaveRequest soExportSaveRequest;

  BuildContext context;
  SaleOrderHeaderSaveRequestEvent(
      this.context,
      this.pkID,
      this.saleOrderHeaderSaveRequest,
      this.soShipmentSaveRequest,
      this.soExportSaveRequest);
}

class SaleOrderProductSaveCallEvent extends SalesOrderEvents {
  String SO_NO;
  BuildContext context;
  final List<SalesOrderProductRequest> arrSalesOrderProductList;
  SaleOrderProductSaveCallEvent(
      this.context, this.SO_NO, this.arrSalesOrderProductList);
}

class SalesOrderProductDeleteRequestEvent extends SalesOrderEvents {
  int pkID;
  final SalesOrderAllProductDeleteRequest SalesOrderProductDeleteRequest;

  SalesOrderProductDeleteRequestEvent(
      this.pkID, this.SalesOrderProductDeleteRequest);
}

class UserMenuRightsRequestEvent extends SalesOrderEvents {
  String MenuID;

  final UserMenuRightsRequest userMenuRightsRequest;
  UserMenuRightsRequestEvent(this.MenuID, this.userMenuRightsRequest);
}

class QuotationOtherCharge1CallEvent extends SalesOrderEvents {
  String CompanyID;

  final QuotationOtherChargesListRequest request;

  QuotationOtherCharge1CallEvent(this.CompanyID, this.request);
}

class GetGenericAddditionalChargesEvent extends SalesOrderEvents {
  GetGenericAddditionalChargesEvent();
}

class QuotationOtherChargeCallEvent extends SalesOrderEvents {
  String CompanyID;
  String headerDiscountController;
  final QuotationOtherChargesListRequest request;

  QuotationOtherChargeCallEvent(
      this.headerDiscountController, this.CompanyID, this.request);
}

class GetQuotationProductListEvent extends SalesOrderEvents {
  //final FCMNotificationRequest request;
  GetQuotationProductListEvent();
}

class InsertProductEvent extends SalesOrderEvents {
  List<SalesOrderTable> quotationTable;
  InsertProductEvent(this.quotationTable);
}

class getInsertProductEvent extends SalesOrderEvents {
  List<PurchaseOrderTable> quotationTable;
  getInsertProductEvent(this.quotationTable);
}

class DeleteAllQuotationProductEvent extends SalesOrderEvents {
  //final FCMNotificationRequest request;
  DeleteAllQuotationProductEvent();
}

class AddGenericAddditionalChargesEvent extends SalesOrderEvents {
  final GenericAddditionalCharges genericAddditionalCharges;

  AddGenericAddditionalChargesEvent(this.genericAddditionalCharges);
}

class DeleteGenericAddditionalChargesEvent extends SalesOrderEvents {
  DeleteGenericAddditionalChargesEvent();
}

class GetQuotationSpecificationTableEvent extends SalesOrderEvents {
  //final FCMNotificationRequest request;
  GetQuotationSpecificationTableEvent();
}

class QuotationSpecificationCallEvent extends SalesOrderEvents {
  final SpecificationListRequest request;

  QuotationSpecificationCallEvent(this.request);
}

class GenericOtherChargeCallEvent extends SalesOrderEvents {
  String CompanyID;

  final QuotationOtherChargesListRequest request;

  GenericOtherChargeCallEvent(this.CompanyID, this.request);
}

class SalesOrderDeleteRequestEvent extends SalesOrderEvents {
  String pkID;

  final SalesOrderDeleteRequest request;

  SalesOrderDeleteRequestEvent(this.pkID, this.request);
}

class SOCurrencyListRequestEvent extends SalesOrderEvents {
  final SOCurrencyListRequest request;

  SOCurrencyListRequestEvent(this.request);
}

class SaveEmailContentRequestEvent extends SalesOrderEvents {
  final SaveEmailContentRequest request;
  SaveEmailContentRequestEvent(this.request);
}

class SOProductOneDeleteEvent extends SalesOrderEvents {
  final int tableId;

  SOProductOneDeleteEvent(this.tableId);
}

class POProductOneDeleteEvent extends SalesOrderEvents {
  final int tableId;

  POProductOneDeleteEvent(this.tableId);
}

///Asembly OfflineDB CRUD
///
class SOAssemblyTableListEvent extends SalesOrderEvents {
  String finishProductID;
  SOAssemblyTableListEvent(this.finishProductID);
}

class SOAssemblyTableInsertEvent extends SalesOrderEvents {
  BuildContext context;
  final SOAssemblyTable soAssemblyTable;

  SOAssemblyTableInsertEvent(this.context, this.soAssemblyTable);
}

class SOAssemblyTableUpdateEvent extends SalesOrderEvents {
  BuildContext context;
  final SOAssemblyTable soAssemblyTable;
  SOAssemblyTableUpdateEvent(this.context, this.soAssemblyTable);
}

class SOAssemblyTableOneItemDeleteEvent extends SalesOrderEvents {
  int tableid;
  SOAssemblyTableOneItemDeleteEvent(this.tableid);
}

class SOAssemblyTableALLDeleteEvent extends SalesOrderEvents {
  SOAssemblyTableALLDeleteEvent();
}

class SalesTargetListCallEvent extends SalesOrderEvents {
  final int pageNo;
  final SalaryTargetListRequest salaryTargetListRequest;
  SalesTargetListCallEvent(this.pageNo, this.salaryTargetListRequest);
}

class SalesTargetDeleteCallEvent extends SalesOrderEvents {
  final SalesTargetDeleteRequest salesTargetDeleteRequest;

  SalesTargetDeleteCallEvent(this.salesTargetDeleteRequest);
}

class SalesTargetAddUpdateCallEvent extends SalesOrderEvents {
  final SalasTargetAddUpdateRequest salesTargetAddUpdateRequest;

  SalesTargetAddUpdateCallEvent(this.salesTargetAddUpdateRequest);
}


class SOShipmentListRequestEvent extends SalesOrderEvents {
  final SOShipmentListRequest soShipmentListRequest;
  final SOExportListRequest soExportListRequest;
  SalesOrderDetails salesOrderDetails;
  bool isCopy;

  SOShipmentListRequestEvent(this.soShipmentListRequest, this.salesOrderDetails,
      this.soExportListRequest, this.isCopy);
}

class SOShipmentSaveRequestEvent extends SalesOrderEvents {
  final SOShipmentSaveRequest soShipmentSaveRequest;
  SOShipmentSaveRequestEvent(this.soShipmentSaveRequest);
}

class SOShipmentDeleteRequestEvent extends SalesOrderEvents {
  final SOShipmentDeleteRequest soShipmentDeleteRequest;
  SOShipmentDeleteRequestEvent(this.soShipmentDeleteRequest);
}
//SalesOrderApprovalListRequest

class SalesOrderApprovalListRequestEvent extends SalesOrderEvents {
  final SalesOrderApprovalListRequest salesOrderApprovalListRequest;
  SalesOrderApprovalListRequestEvent(this.salesOrderApprovalListRequest);
}

class SalesOrderApprovalListRequestForDashBoardEvent extends SalesOrderEvents {
  final SalesOrderApprovalListRequest salesOrderApprovalListRequest;
  SalesOrderApprovalListRequestForDashBoardEvent(this.salesOrderApprovalListRequest);
}

class SalesOrderApprovalSaveRequestEvent extends SalesOrderEvents {
  final SalesOrderApprovalSaveRequest salesOrderApprovalSaveRequest;
  BuildContext context;

  SalesOrderApprovalSaveRequestEvent(
      this.salesOrderApprovalSaveRequest, this.context);
}

class SalesOrderApprovalStatusListRequestEvent extends SalesOrderEvents {
  final SalesOrderApprovalStatusListRequest salesOrderApprovalStatusListRequest;
  SalesOrderApprovalStatusListRequestEvent(
      this.salesOrderApprovalStatusListRequest);
}

class SalesOrderAddressDropDownRequestEvent extends SalesOrderEvents {
  final SalesOrderAddressDropDownRequest salesOrderAddressDropDownRequest;
  SalesOrderAddressDropDownRequestEvent(this.salesOrderAddressDropDownRequest);
}

class SalesOrderAddressORGDropDownRequestEvent extends SalesOrderEvents {
  final SalesOrderAddressDropDownRequest salesOrderAddressDropDownRequest;
  SalesOrderAddressORGDropDownRequestEvent(
      this.salesOrderAddressDropDownRequest);
}

class SoNoToProductListCallEvent extends SalesOrderEvents {
  int StateCode;
  String LoginUserId;
  final SoNoToProductListRequest request;
  SoNoToProductListCallEvent(this.StateCode, this.LoginUserId, this.request);
}

class SoKindAttListCallEvent extends SalesOrderEvents {
  final QuotationKindAttListApiRequest request;

  SoKindAttListCallEvent(this.request);
}

class CountryCallEvent extends SalesOrderEvents {
  final CountryListRequest countryListRequest;
  CountryCallEvent(this.countryListRequest);
}
//
