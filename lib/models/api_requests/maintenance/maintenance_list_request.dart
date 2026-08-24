/*
pkID:0
LoginUserID:admin
SearchKey:
Status:
PageNo:1
PageSize:10
CompanyId:4132*/


class MaintenanceListRequest {
  String pkID;
  String SearchKey;
  String Status;
  int PageNo;
  int PageSize;
  String LoginUserID;
  String CompanyId;

  MaintenanceListRequest({this.pkID, this.SearchKey, this.Status, this.PageNo,
      this.PageSize, this.LoginUserID, this.CompanyId});

  MaintenanceListRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    SearchKey = json['SearchKey'];
    Status = json['Status'];
    PageNo = json['PageNo'];
    PageSize = json['PageSize'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['SearchKey'] = this.SearchKey;
    data['Status'] = this.Status;
    data['PageNo'] = this.PageNo;
    data['PageSize'] = this.PageSize;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;
    return data;
  }
}

