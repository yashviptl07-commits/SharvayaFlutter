class QUOShipmentSaveRequest {
  String QuotationNo;
  String SCompanyName;
  String SGSTNo;
  String SContactNo;
  String SContactPersonName;
  String SAddress;
  String SArea;
  String SCountryCode;
  String SCityCode;
  String SStateCode;
  String SPincode;
  String LoginUserID;
  String CompanyId;

  QUOShipmentSaveRequest(
      {this.QuotationNo,
        this.SCompanyName,
        this.SGSTNo,
        this.SContactNo,
        this.SContactPersonName,
        this.SAddress,
        this.SArea,
        this.SCountryCode,
        this.SCityCode,
        this.SStateCode,
        this.SPincode,
        this.LoginUserID,
        this.CompanyId});

  QUOShipmentSaveRequest.fromJson(Map<String, dynamic> json) {
    QuotationNo = json['QuotationNo'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
    SCompanyName = json['SCompanyName'];
    SGSTNo = json['SGSTNo'];
    SContactNo = json['SContactNo'];
    SContactPersonName = json['SContactPersonName'];
    SAddress = json['SAddress'];
    SArea = json['SArea'];
    SCountryCode = json['SCountryCode'];
    SCityCode = json['SCityCode'];
    SStateCode = json['SStateCode'];
    SPincode = json['SPincode'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['QuotationNo'] = this.QuotationNo;
    data['SCompanyName'] = this.SCompanyName;
    data['SGSTNo'] = this.SGSTNo;
    data['SContactNo'] = this.SContactNo;
    data['SContactPersonName'] = this.SContactPersonName;
    data['SAddress'] = this.SAddress;
    data['SArea'] = this.SArea;
    data['SCountryCode'] = this.SCountryCode;
    data['SCityCode'] = this.SCityCode;
    data['SStateCode'] = this.SStateCode;
    data['SPincode'] = this.SPincode;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
