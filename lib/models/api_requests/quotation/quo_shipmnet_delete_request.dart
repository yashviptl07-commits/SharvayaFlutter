/*
QuotationNo:QT-FEB22-004
LoginUserID:admin
CompanyId:9255
*/

class QuoShipmentDeleteRequest {
  String QuotationNo;
  String CompanyId;
  String LoginUserID;

  QuoShipmentDeleteRequest({this.QuotationNo, this.CompanyId, this.LoginUserID});

  QuoShipmentDeleteRequest.fromJson(Map<String, dynamic> json) {
    QuotationNo = json['QuotationNo'];
    CompanyId = json['CompanyId'];
    LoginUserID = json['LoginUserID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['QuotationNo'] = this.QuotationNo;
    data['CompanyId'] = this.CompanyId;
    data['LoginUserID'] = this.LoginUserID;

    return data;
  }
}
