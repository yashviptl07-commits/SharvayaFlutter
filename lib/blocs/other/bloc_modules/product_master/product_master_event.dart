part of 'product_master_bloc.dart';

@immutable
abstract class ProductMasterEvent {}

///all events of AuthenticationEvents
class ProductMasterListEvent extends ProductMasterEvent //Main Event Class
{
  final int pageNo;
  final ProductMasterListRequest productMasterListRequest;
  ProductMasterListEvent(this.pageNo, this.productMasterListRequest);
}

class UserMenuRightsRequestEvent extends ProductMasterEvent {
  String MenuID;

  final UserMenuRightsRequest userMenuRightsRequest;
  UserMenuRightsRequestEvent(this.MenuID, this.userMenuRightsRequest);
}

class ProductBrandListRequestEvent extends ProductMasterEvent {
  final ProductBrandListRequest productBrandListRequest;

  ProductBrandListRequestEvent(this.productBrandListRequest);
}

class ProductGroupDropDownRequestCallEvent extends ProductMasterEvent {
  final ProductGroupDropDownListRequest packingProductAssamblyListRequest;
  ProductGroupDropDownRequestCallEvent(this.packingProductAssamblyListRequest);
}

class ProductAddUpdateRequestCallEvent extends ProductMasterEvent {
  final ProductMasterAddEditRequest productMasterAddEditRequest;
  ProductAddUpdateRequestCallEvent(this.productMasterAddEditRequest);
}

class ProductDeleteDeleteEvent extends ProductMasterEvent {
  final ProductDeleteRequest productDeleteRequest;

  ProductDeleteDeleteEvent(this.productDeleteRequest);
}


