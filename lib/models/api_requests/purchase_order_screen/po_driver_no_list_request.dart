/*
pkID:0
ListMode:L
PageNo:0
PageSize:0
CompanyId:7313 */

class PODriverListRequest {
  String pkID;
  String PageNo;
  String PageSize;
  String ListMode;
  String CompanyId;

  PODriverListRequest(
      {this.pkID, this.PageNo, this.PageSize, this.ListMode, this.CompanyId});

  PODriverListRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    PageNo = json['PageNo'];
    PageSize = json['PageSize'];
    ListMode = json['ListMode'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['PageNo'] = this.PageNo;
    data['PageSize'] = this.PageSize;
    data['ListMode'] = this.ListMode;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
