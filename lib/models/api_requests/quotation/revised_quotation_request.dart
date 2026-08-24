/*pkID:10131
LoginUserID:admin
CompanyId:4132*/

class RevisedQuotationRequest {
  String CompanyId;
  String LoginUserID;
  String pkID;

  RevisedQuotationRequest({this.CompanyId,this.LoginUserID,this.pkID});

  RevisedQuotationRequest.fromJson(Map<String, dynamic> json) {
    CompanyId = json['CompanyId'];
    LoginUserID = json['LoginUserID'];
    pkID=json['pkID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CompanyId'] = this.CompanyId;
    data['LoginUserID'] = this.LoginUserID;
    data['pkID'] = this.pkID;

    return data;
  }
}