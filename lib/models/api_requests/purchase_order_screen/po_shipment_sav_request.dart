class PurchaseOrderShipmentSaveRequest {
  String pkID;
  String OrderNo;
  String SCompanyName;
  String SGSTNo;
  String SContactNo;
  String SContactPersonName;
  String SAddress;
  String SArea;
  String SCountryCode;
  String SStateCode;
  String SCityCode;
  String SPincode;
  String Email;
  String LoginUserID;
  String CompanyId;

  PurchaseOrderShipmentSaveRequest({
    this.pkID,
    this.OrderNo,
    this.SCompanyName,
    this.SGSTNo,
    this.SContactNo,
    this.SContactPersonName,
    this.SAddress,
    this.SArea,
    this.SCountryCode,
    this.SStateCode,
    this.SCityCode,
    this.SPincode,
    this.Email,
    this.LoginUserID,
    this.CompanyId,
  });

  PurchaseOrderShipmentSaveRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    OrderNo = json['OrderNo'];
    SCompanyName = json['SCompanyName'];
    SGSTNo = json['SGSTNo'];
    SContactNo = json['SContactNo'];
    SContactPersonName = json['SContactPersonName'];
    SAddress = json['SAddress'];
    SArea = json['SArea'];
    SCountryCode = json['SCountryCode'];
    SStateCode = json['SStateCode'];
    SCityCode = json['SCityCode'];
    SPincode = json['SPincode'];
    Email = json['Email'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['OrderNo'] = this.OrderNo;
    data['SCompanyName'] = this.SCompanyName;
    data['SGSTNo'] = this.SGSTNo;
    data['SContactNo'] = this.SContactNo;
    data['SContactPersonName'] = this.SContactPersonName;
    data['SAddress'] = this.SAddress;
    data['SArea'] = this.SArea;
    data['SCountryCode'] = this.SCountryCode;
    data['SStateCode'] = this.SStateCode;
    data['SCityCode'] = this.SCityCode;
    data['SPincode'] = this.SPincode;
    data['Email'] = this.Email;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;
    return data;
  }
}
