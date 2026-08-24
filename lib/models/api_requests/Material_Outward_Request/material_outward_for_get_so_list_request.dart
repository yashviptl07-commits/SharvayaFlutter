/*
CustomerID:4
ModuleType:PendingSalesOrder
CompanyId:0*/
class MaterialOutwardPendingSalesOrderListRequest {
  String CustomerID;
  String ModuleType;
  String CompanyId;

  MaterialOutwardPendingSalesOrderListRequest(
      {this.CustomerID, this.ModuleType, this.CompanyId});

  MaterialOutwardPendingSalesOrderListRequest.fromJson(
      Map<String, dynamic> json) {
    CustomerID = json['CustomerID'];
    ModuleType = json['ModuleType'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CustomerID'] = this.CustomerID;
    data['ModuleType'] = this.ModuleType;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
