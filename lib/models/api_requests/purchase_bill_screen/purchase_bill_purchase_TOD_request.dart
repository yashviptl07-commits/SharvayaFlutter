/*
CountryCode:
StateCode:0
ListMode:L
PageNo:1
PageSize:5000
CompanyId:7313*/

class PurchaseBillTODRequest {
  String CountryCode;
  String StateCode;
  String ListMode;
  int PageNo;
  int PageSize;
  int CompanyId;

  PurchaseBillTODRequest({this.CountryCode, this.StateCode, this.ListMode,
      this.PageNo, this.PageSize, this.CompanyId});

  PurchaseBillTODRequest.fromJson(Map<String, dynamic> json) {
    CountryCode = json['CountryCode'];
    StateCode = json['StateCode'];
    ListMode = json['ListMode'];
    PageNo = json['PageNo'];
    PageSize = json['PageSize'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CountryCode'] = this.CountryCode;
    data['StateCode'] = this.StateCode;
    data['ListMode'] = this.ListMode;
    data['PageNo'] = this.PageNo;
    data['PageSize'] = this.PageSize;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
