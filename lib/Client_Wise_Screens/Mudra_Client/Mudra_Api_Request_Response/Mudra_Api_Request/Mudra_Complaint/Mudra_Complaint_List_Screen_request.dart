/*
pkID:0
CustomerID:0
ComplaintStatus:
ComplaintType:
LoginUserID:admin
SearchKey:
PageNo:1
PageSize:10
CompanyId:7235*/

class MudraComplaintListRequest {
  String pkID;
  String CustomerID;
  String ComplaintStatus;
  String ComplaintType;
  String LoginUserID;
  String SearchKey;
  String PageNo;
  String PageSize;
  String CompanyId;

  MudraComplaintListRequest(
      {this.pkID,
      this.CustomerID,
      this.ComplaintStatus,
      this.ComplaintType,
      this.LoginUserID,
      this.SearchKey,
      this.PageNo,
      this.PageSize,
      this.CompanyId});

  MudraComplaintListRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    CustomerID = json['CustomerID'];
    ComplaintStatus = json['ComplaintStatus'];
    ComplaintType = json['ComplaintType'];
    LoginUserID = json['LoginUserID'];
    SearchKey = json['SearchKey'];
    PageNo = json['PageNo'];
    PageSize = json['PageSize'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['CustomerID'] = this.CustomerID;
    data['ComplaintStatus'] = this.ComplaintStatus;
    data['ComplaintType'] = this.ComplaintType;
    data['LoginUserID'] = this.LoginUserID;
    data['SearchKey'] = this.SearchKey;
    data['PageNo'] = this.PageNo;
    data['PageSize'] = this.PageSize;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
