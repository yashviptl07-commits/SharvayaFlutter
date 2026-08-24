/*
Module:SalesBill
CompanyId:4132*/
class FixedLedgerListRequest {
  String Module;
  String CompanyId;

  FixedLedgerListRequest({this.Module,this.CompanyId});

  FixedLedgerListRequest.fromJson(Map<String, dynamic> json) {
    Module = json['Module'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Module'] = this.Module;

    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
