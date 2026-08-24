/*
Module:
CompanyId:7313*/
class PurchaseBillACRequest {
  String Module;
  int CompanyId;

  PurchaseBillACRequest({this.Module, this.CompanyId});

  PurchaseBillACRequest.fromJson(Map<String, dynamic> json) {
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
