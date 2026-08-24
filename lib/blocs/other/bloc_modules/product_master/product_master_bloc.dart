import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soleoserp/blocs/base/base_bloc.dart';
import 'package:soleoserp/models/api_requests/other/product_group_drop_down_request.dart';
import 'package:soleoserp/models/api_requests/product/product_add_update_screen.dart';
import 'package:soleoserp/models/api_requests/product/product_brand_list_request.dart';
import 'package:soleoserp/models/api_requests/product/product_delete_request.dart';
import 'package:soleoserp/models/api_requests/product/product_group_request.dart';
import 'package:soleoserp/models/api_requests/product/product_master_list_request.dart';
import 'package:soleoserp/models/api_responses/other/product_group_dropdown_response.dart';
import 'package:soleoserp/models/api_responses/product_master/prduct_add_update_response.dart';
import 'package:soleoserp/models/api_responses/product_master/product_brand_list_response.dart';
import 'package:soleoserp/models/api_responses/product_master/product_group_list_response.dart';
import 'package:soleoserp/models/api_responses/product_master/product_master_list_response.dart';
import 'package:soleoserp/models/common/menu_rights/request/user_menu_rights_request.dart';
import 'package:soleoserp/models/common/menu_rights/response/user_menu_rights_response.dart';
import 'package:soleoserp/repositories/repository.dart';

part 'product_master_event.dart';
part 'product_master_state.dart';

class ManagePurchaseBloc extends Bloc<ProductMasterEvent, ProductMasterState> {
  Repository userRepository = Repository.getInstance();
  BaseBloc baseBloc;

  ///Bloc Constructor
  ManagePurchaseBloc(this.baseBloc) : super(ProductMasterStateInitialState());

  @override
  Stream<ProductMasterState> mapEventToState(ProductMasterEvent event) async* {
    if (event is ProductMasterListEvent) {
      yield* _mapProductMasterListEventToState(event);
    }
    if (event is UserMenuRightsRequestEvent) {
      yield* _mapUserMenuRightsRequestEventState(event);
    }
    if (event is ProductBrandListRequestEvent) {
      yield* _mapProductBrandListRequestEventState(event);
    }
    if (event is ProductGroupDropDownRequestCallEvent) {
      yield* _mapProductGroupDropDownCallEventToState(event);
    }
    if (event is ProductAddUpdateRequestCallEvent) {
      yield* _mapProductAddUpdateEventToState(event);
    }
    if (event is ProductDeleteDeleteEvent) {
      yield* _mapMayankBankVoucherDeleteEventState(event);
    }
  }

  Stream<ProductMasterState> _mapProductMasterListEventToState(
      ProductMasterListEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));
      //call your api as follows
      print("hi");
      ProductMasterResponse respo = await userRepository.productmasterListAPi(
          event.pageNo, event.productMasterListRequest);

      yield ProductMasterResponseState(event.pageNo, respo);
    } catch (error, stacktrace) {
      print(error.toString());

      baseBloc.emit(ApiCallFailureState(error));
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ProductMasterState> _mapUserMenuRightsRequestEventState(
      UserMenuRightsRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      UserMenuRightsResponse respo = await userRepository.user_menurightsapi(
          event.MenuID, event.userMenuRightsRequest);
      yield UserMenuRightsResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ProductMasterState> _mapProductBrandListRequestEventState(
      ProductBrandListRequestEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      ProductBrandResponse respo = await userRepository
          .productBrandListAPI(event.productBrandListRequest);
      yield ProductBrandResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ProductMasterState> _mapProductGroupDropDownCallEventToState(
      ProductGroupDropDownRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      ProductGroupDropDownListResponse respo =
      await userRepository.ProductGroupDropDownListAPi(
          event.packingProductAssamblyListRequest);
      yield ProductGroupDropDownResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ProductMasterState> _mapProductAddUpdateEventToState(
      ProductAddUpdateRequestCallEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      ProductMasterAddEditResponse respo =
      await userRepository.getProductAddUpdateAPi(
          event.productMasterAddEditRequest);

      yield ProductAddUpdateResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

  Stream<ProductMasterState> _mapMayankBankVoucherDeleteEventState(
      ProductDeleteDeleteEvent event) async* {
    try {
      baseBloc.emit(ShowProgressIndicatorState(true));

      String respo = await userRepository.getProductMasterDeleteAPI(
          event.productDeleteRequest);
      yield ProductDeleteResponseState(respo);
    } catch (error, stacktrace) {
      baseBloc.emit(ApiCallFailureState(error));
      print(stacktrace);
    } finally {
      baseBloc.emit(ShowProgressIndicatorState(false));
    }
  }

}
