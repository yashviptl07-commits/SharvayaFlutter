/*
CustomerID:61519
LoginUserID:admin
CompanyId:4132*/
class CustomerHistoryListRequest {
  String CustomerID;
  String LoginUserID;
  String CompanyID;
  CustomerHistoryListRequest(
      {this.CustomerID, this.LoginUserID, this.CompanyID});
  CustomerHistoryListRequest.fromJson(Map<String, dynamic> json) {
    CustomerID = json['CustomerID'];
    LoginUserID = json['LoginUserID'];
    CompanyID = json['CompanyId'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CustomerID'] = this.CustomerID;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyID;
    return data;
  }
}