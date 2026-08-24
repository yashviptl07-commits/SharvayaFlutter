/*
pkID:0
SearchKey:
ApprovalStatus:
PageNo:1
PageSize:11
LoginUserID:admin
CompanyId:7291*/

class MaterialIndentListRequest {
  String pkID;
  String SearchKey;
  String ApprovalStatus;
  String PageNo;
  String PageSize;
  String LoginUserID;
  String CompanyId;

  MaterialIndentListRequest({
    this.pkID,
    this.SearchKey,
    this.ApprovalStatus,
    this.PageNo,
    this.PageSize,
    this.LoginUserID,
    this.CompanyId,
  });

  MaterialIndentListRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    SearchKey = json['SearchKey'];
    ApprovalStatus = json['ApprovalStatus'];
    PageNo = json['PageNo'];
    PageSize = json['PageSize'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['SearchKey'] = this.SearchKey;
    data['ApprovalStatus'] = this.ApprovalStatus;
    data['PageNo'] = this.PageNo;
    data['PageSize'] = this.PageSize;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
