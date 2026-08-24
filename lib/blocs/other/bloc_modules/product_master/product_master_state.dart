part of 'product_master_bloc.dart';

abstract class ProductMasterState extends BaseStates {
  const ProductMasterState();
}

///all states of AuthenticationStates
class ProductMasterStateInitialState extends ProductMasterState {}
//ProductMasterResponse

class ProductMasterResponseState
    extends ProductMasterState // Maint State Class Declare Here
{
  final int newPage;

  final ProductMasterResponse response;
  ProductMasterResponseState(this.newPage, this.response);
}

class UserMenuRightsResponseState extends ProductMasterState {
  final UserMenuRightsResponse userMenuRightsResponse;
  UserMenuRightsResponseState(this.userMenuRightsResponse);
}

class ProductBrandResponseState extends ProductMasterState {
  final ProductBrandResponse productBrandResponse;

  ProductBrandResponseState(this.productBrandResponse);
}

class ProductGroupDropDownResponseState extends ProductMasterState{
  final ProductGroupDropDownListResponse productGroupDropDownResponse;
  ProductGroupDropDownResponseState(this.productGroupDropDownResponse);
}

class ProductAddUpdateResponseState extends ProductMasterState{
  final ProductMasterAddEditResponse productMasterAddEditResponse;
  ProductAddUpdateResponseState(this.productMasterAddEditResponse);
}

class ProductDeleteResponseState extends ProductMasterState {
  final String response;

  ProductDeleteResponseState(this.response);
}

