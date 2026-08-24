/*
part of 'purchase_order_bloc.dart';

abstract class ManagePurchaseStates extends BaseStates {
  const ManagePurchaseStates();
}

///all states of AuthenticationStates
class ManagePurchaseStatesInitialState extends ManagePurchaseStates {}

class PurchaseOrderListCallResponseState extends ManagePurchaseStates {
  final PurchaseOrderListResponse response;
  final int newPage;
  PurchaseOrderListCallResponseState(this.response, this.newPage);
}

class SearchSalesOrderListByNameCallResponseState extends ManagePurchaseStates {
  final SearchSalesOrderListResponse response;

  SearchSalesOrderListByNameCallResponseState(this.response);
}

class SearchSalesOrderListByNumberCallResponseState
    extends ManagePurchaseStates {
  final SalesOrderListResponse response;

  SearchSalesOrderListByNumberCallResponseState(this.response);
}

class SalesOrderPDFGenerateResponseState extends ManagePurchaseStates {
  final SalesOrderPDFGenerateResponse response;

  SalesOrderPDFGenerateResponseState(this.response);
}

class BankDetailsListResponseState extends ManagePurchaseStates {
  final BankNameDropDownResponse response;

  BankDetailsListResponseState(this.response);
}

class BankDetailsDialogListResponseState extends ManagePurchaseStates {
  final BankNameDropDownResponse response;

  BankDetailsDialogListResponseState(this.response);
}

class QuotationProjectListResponseState extends ManagePurchaseStates {
  final QuotationProjectListResponse response;

  QuotationProjectListResponseState(this.response);
}

class QuotationTermsCondtionResponseState extends ManagePurchaseStates {
  final QuotationTermsCondtionResponse response;

  QuotationTermsCondtionResponseState(this.response);
}

class SearchCustomerListByNumberCallResponseState extends ManagePurchaseStates {
  String IsFromDialog;
  final CustomerDetailsResponse response;

  SearchCustomerListByNumberCallResponseState(this.IsFromDialog, this.response);
}

class SalesBill_INQ_QT_SO_NO_ListResponseState extends ManagePurchaseStates {
  final SalesBill_INQ_QT_SO_NO_ListResponse response;
  SalesBill_INQ_QT_SO_NO_ListResponseState(this.response);
}

class MultiNoToProductDetailsResponseState extends ManagePurchaseStates {
  String FetchFromWhichScreen;
  final MultiNoToProductDetailsResponse response;
  MultiNoToProductDetailsResponseState(
      this.FetchFromWhichScreen, this.response);
}

class MultiNoToProductDetailsResponseState1 extends ManagePurchaseStates {
  String FetchFromWhichScreen;
  final MultiNoToProductDetailsResponse1 response;
  MultiNoToProductDetailsResponseState1(
      this.FetchFromWhichScreen, this.response);
}

class SaleBillEmailContentResponseState extends ManagePurchaseStates {
  final SaleBillEmailContentResponse response;

  SaleBillEmailContentResponseState(this.response);
}

//MultiNoToProductDetailsResponse
*/
/*class FCMNotificationResponseState extends SalesOrderStates {
  final FCMNotificationResponse response;

  FCMNotificationResponseState(this.response);
}*//*

class FCMNotificationResponseNewState extends ManagePurchaseStates {
  final FCMNotificationResponse response;

  FCMNotificationResponseNewState(this.response);
}

class PaymentScheduleResponseState extends ManagePurchaseStates {
  final String response;

  PaymentScheduleResponseState(this.response);
}

class PaymentScheduleListResponseState extends ManagePurchaseStates {
  final List<SoPaymentScheduleTable> response;

  PaymentScheduleListResponseState(this.response);
}

class PaymentScheduleDeleteResponseState extends ManagePurchaseStates {
  final String response;

  PaymentScheduleDeleteResponseState(this.response);
}

class PaymentScheduleEditResponseState extends ManagePurchaseStates {
  final String response;

  PaymentScheduleEditResponseState(this.response);
}

class PaymentScheduleDeleteAllResponseState extends ManagePurchaseStates {
  final String response;

  PaymentScheduleDeleteAllResponseState(this.response);
}
//SaleOrderHeaderSaveResponse

class SaleOrderHeaderSaveResponseState extends ManagePurchaseStates {
  int pkID;
  final SaleOrderHeaderSaveResponse response;
  BuildContext context;
  SaleOrderHeaderSaveResponseState(this.context, this.pkID, this.response);
}

class SaleOrderProductSaveResponseState extends ManagePurchaseStates {
  final SaleOrderProductSaveResponse response;

  SaleOrderProductSaveResponseState(this.response);
}

class SaleOrderProductDeleteResponseState extends ManagePurchaseStates {
  final SaleOrderProductDeleteResponse response;

  SaleOrderProductDeleteResponseState(this.response);
}

class UserMenuRightsResponseState extends ManagePurchaseStates {
  final UserMenuRightsResponse userMenuRightsResponse;
  UserMenuRightsResponseState(this.userMenuRightsResponse);
}

class QuotationOtherCharge1ListResponseState extends SalesOrderStates {
  final QuotationOtherChargesListResponse quotationOtherChargesListResponse;

  QuotationOtherCharge1ListResponseState(
      this.quotationOtherChargesListResponse);
}

class GetGenericAddditionalChargesState extends ManagePurchaseStates {
  final GenericAddditionalCharges quotationOtherChargesListResponse;

  GetGenericAddditionalChargesState(this.quotationOtherChargesListResponse);
}

class QuotationOtherChargeListResponseState extends ManagePurchaseStates {
  final QuotationOtherChargesListResponse quotationOtherChargesListResponse;

  String headerDiscountController;
  QuotationOtherChargeListResponseState(
      this.headerDiscountController, this.quotationOtherChargesListResponse);
}

class GetQuotationProductListState extends ManagePurchaseStates {
  final List<SalesOrderTable> response;

  GetQuotationProductListState(this.response);
}

class GetPoProductListState extends ManagePurchaseStates {
  final List<PurchaseOrderTable> response;

  GetPoProductListState(this.response);
}

class InsertProductSucessResponseState extends ManagePurchaseStates {
  final String response;

  InsertProductSucessResponseState(this.response);
}

class DeleteALLQuotationProductTableState extends ManagePurchaseStates {
  final String response;

  DeleteALLQuotationProductTableState(this.response);
}

class AddGenericAddditionalChargesState extends ManagePurchaseStates {
  String response;
  AddGenericAddditionalChargesState(this.response);
}

class DeleteAllGenericAddditionalChargesState extends ManagePurchaseStates {
  String response;
  DeleteAllGenericAddditionalChargesState(this.response);
}
//

class GetQuotationSpecificationTableState extends ManagePurchaseStates {
  final List<QuotationSpecificationTable> response;

  GetQuotationSpecificationTableState(this.response);
}

class SpecificationListResponseState extends ManagePurchaseStates {
  final SpecificationListResponse response;

  SpecificationListResponseState(this.response);
}

class GenericOtherCharge1ListResponseState extends ManagePurchaseStates {
  final QuotationOtherChargesListResponse quotationOtherChargesListResponse;

  GenericOtherCharge1ListResponseState(this.quotationOtherChargesListResponse);
}

class SalesOrderDeleteResponseState extends ManagePurchaseStates {
  final SalesOrderDeleteResponse salesOrderDeleteResponse;

  SalesOrderDeleteResponseState(this.salesOrderDeleteResponse);
}

class SOCurrencyListResponseState extends ManagePurchaseStates {
  final SOCurrencyListResponse response;

  SOCurrencyListResponseState(this.response);
}

class SaveEmailContentResponseState extends ManagePurchaseStates {
  final SaveEmailContentResponse response;

  SaveEmailContentResponseState(this.response);
}

class SOProductOneDeleteState extends ManagePurchaseStates {
  final String response;

  SOProductOneDeleteState(this.response);
}

///SO Assembly offline DB CRUD
///
class SOAssemblyTableListState extends ManagePurchaseStates {
  final List<SOAssemblyTable> response;

  SOAssemblyTableListState(this.response);
}

class SOAssemblyTableInsertState extends ManagePurchaseStates {
  BuildContext context;
  String response;
  SOAssemblyTableInsertState(this.context, this.response);
}

class SOAssemblyTableUpdateState extends ManagePurchaseStates {
  BuildContext context;
  String response;
  SOAssemblyTableUpdateState(this.context, this.response);
}

class SOAssemblyTableOneItemDeleteState extends ManagePurchaseStates {
  String response;
  SOAssemblyTableOneItemDeleteState(this.response);
}

class SOAssemblyTableDeleteALLState extends ManagePurchaseStates {
  String response;
  SOAssemblyTableDeleteALLState(this.response);
}

class SalesTargetListCallResponseState extends ManagePurchaseStates {
  final SalesTargetListResponse response;
  final int newPage;
  SalesTargetListCallResponseState(this.response, this.newPage);
}

class SOShipmentlistResponseState extends ManagePurchaseStates {
  SOShipmentlistResponse response;
  PurchaseOrderListResponseDetails salesOrderDetails;

  SOShipmentlistResponseState(this.response, this.salesOrderDetails);
}

class SOShipmentSaveResponseState extends ManagePurchaseStates {
  SOShipmentSaveResponse response;
  SOShipmentSaveResponseState(this.response);
}

class SOShipmentDeleteResponseState extends ManagePurchaseStates {
  String response;
  SOShipmentDeleteResponseState(this.response);
}

class SalesOrderApprovalListResponseState extends ManagePurchaseStates {
  SalesOrderApprovalListResponse response;
  final int newPage;

  SalesOrderApprovalListResponseState(this.response, this.newPage);
}

class IndentApprovalListResponseState extends ManagePurchaseStates {
  MaterialIndentApprovalResponce response;
  final int newPage;

  IndentApprovalListResponseState(this.response, this.newPage);
}

class SalesOrderSaveResponseState extends ManagePurchaseStates {
  String response;
  BuildContext context;

  SalesOrderSaveResponseState(this.response, this.context);
}

class IndentApprovalSaveResponseState extends ManagePurchaseStates {
  String response;
  BuildContext context;

  IndentApprovalSaveResponseState(this.response, this.context);
}

class SalesOrderApprovalStatusListResponseState extends ManagePurchaseStates {
  SalesOrderApprovalStatusListResponse response;
  SalesOrderApprovalStatusListResponseState(this.response);
}

class SalesOrderAddressDropDownResponseState extends ManagePurchaseStates {
  SalesOrderAddressDropDownResponse response;
  SalesOrderAddressDropDownResponseState(this.response);
}

class SalesOrderAddressORGDropDownResponseState extends ManagePurchaseStates {
  SalesOrderAddressDropDownResponse response;
  SalesOrderAddressORGDropDownResponseState(this.response);
}

class SoNoToProductListCallResponseState extends ManagePurchaseStates {
  final SoNoToProductResponse response;
  int StateCode;
  SoNoToProductListCallResponseState(this.StateCode, this.response);
}

class SoKindAttListResponseState extends ManagePurchaseStates {
  final QuotationKindAttListResponse response;

  SoKindAttListResponseState(this.response);
}

class CountryListEventResponseState extends ManagePurchaseStates {
  final CountryListResponse countrylistresponse;
  CountryListEventResponseState(this.countrylistresponse);
}

class PurchaseOrderListResponseState extends ManagePurchaseStates {
  final int newPage;
  final PurchaseOrderListResponse response;
  PurchaseOrderListResponseState(this.newPage, this.response);
}

class PurchaseOrderDeleteCallState extends ManagePurchaseStates {
  final String response;
  PurchaseOrderDeleteCallState(this.response);
}

class ProjectTypeState extends ManagePurchaseStates {
  final ProjectTypeListModelResponce projectTypeListModelResponce;
  ProjectTypeState(
    this.projectTypeListModelResponce,
  );
}

class SalesBillPDFGenerateResponseState extends ManagePurchaseStates {
  final SalesBillPDFGenerateResponse response;

  SalesBillPDFGenerateResponseState(this.response);
}
*/
