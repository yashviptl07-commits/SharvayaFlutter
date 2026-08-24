class ShortInvoiceShipmentSaveRequest {
  String pkID;
  String InvoiceNo;
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
  String LoginUserID;
  String CompanyId;

  ShortInvoiceShipmentSaveRequest({
    this.pkID,
    this.InvoiceNo,
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
    this.LoginUserID,
    this.CompanyId,
  });

  ShortInvoiceShipmentSaveRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    InvoiceNo = json['InvoiceNo'];
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
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['InvoiceNo'] = this.InvoiceNo;
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
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;
    return data;
  }
}
