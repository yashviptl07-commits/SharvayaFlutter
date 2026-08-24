  /*
  Mode:Detail
  PinSearchKey:360
  ProductSearchKey:Nano
  CustomerID:10195
  LoginUserID:admin
  CompanyId:9356
  */

  class SOCustomerNearByPinCodeCommonRequest {
    String Mode;
    String PinSearchKey;
    String ProductSearchKey;
    String CustomerID;
    String LoginUserID;
    String CompanyId;

    SOCustomerNearByPinCodeCommonRequest({
      this.Mode,
      this.PinSearchKey,
      this.ProductSearchKey,
      this.CustomerID,
      this.LoginUserID,
      this.CompanyId,
    });

    SOCustomerNearByPinCodeCommonRequest.fromJson(Map<String, dynamic> json) {
      Mode = json['Mode'];
      PinSearchKey = json['PinSearchKey'];
      ProductSearchKey = json['ProductSearchKey'];
      CustomerID = json['CustomerID'];
      LoginUserID = json['LoginUserID'];
      CompanyId = json['CompanyId'];
    }

    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data['Mode'] = this.Mode;
      data['PinSearchKey'] = this.PinSearchKey;
      data['ProductSearchKey'] = this.ProductSearchKey;
      data['CustomerID'] = this.CustomerID;
      data['LoginUserID'] = this.LoginUserID;
      data['CompanyId'] = this.CompanyId;

      return data;
    }
  }
