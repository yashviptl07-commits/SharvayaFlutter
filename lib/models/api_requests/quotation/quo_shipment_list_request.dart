/*
* OrderNo:SO-AUG22-007
LoginUserID:admin
CompanyId:4132*/
class QuoShipmentListRequest {
  String QuotationNo;
  String LoginUserID;
  String CompanyId;

  QuoShipmentListRequest({this.QuotationNo, this.LoginUserID, this.CompanyId});

  QuoShipmentListRequest.fromJson(Map<String, dynamic> json) {
    QuotationNo = json['QuotationNo'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['QuotationNo'] = this.QuotationNo;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
