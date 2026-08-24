
class MIGetOrderNoFromTheCustomerIdRequest {
  String CustomerID;
  String ModuleType;
  String CompanyId;

  MIGetOrderNoFromTheCustomerIdRequest(
      {this.ModuleType, this.CustomerID, this.CompanyId});

  MIGetOrderNoFromTheCustomerIdRequest.fromJson(
      Map<String, dynamic> json) {
    ModuleType = json['ModuleType'];
    CustomerID = json['CustomerID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ModuleType'] = this.ModuleType;
    data['CustomerID'] = this.CustomerID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
