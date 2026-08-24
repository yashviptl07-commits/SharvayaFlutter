/*
pkID:0
LoginUserID:admin
SearchKey:
PageNo:1
PageSize:10
CompanyId:4132*/

class PurchaseOrderListRequest {
  int pkID;
  String SearchKey;
  int PageNo;
  int PageSize;
  String LoginUserID;
  int CompanyId;

  PurchaseOrderListRequest(
      {this.pkID,
      this.SearchKey,
      this.PageNo,
      this.PageSize,
      this.LoginUserID,
      this.CompanyId});

  PurchaseOrderListRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    SearchKey = json['SearchKey'];
    PageNo = json['PageNo'];
    PageSize = json['PageSize'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['SearchKey'] = this.SearchKey;
    data['PageNo'] = this.PageNo;
    data['PageSize'] = this.PageSize;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
