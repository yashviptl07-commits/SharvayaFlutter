/*
* Mode:organization
CustomerID:0
OrgCode:
CompanyId:4132*/
class SalesOrderAddressDropDownRequest {
  String Mode;
  String CustomerID;
  String OrgCode;
  String CompanyId;

  SalesOrderAddressDropDownRequest({this.Mode, this.CustomerID, this.OrgCode,this.CompanyId});

  SalesOrderAddressDropDownRequest.fromJson(Map<String, dynamic> json) {
    Mode = json['Mode'];
    CustomerID = json['CustomerID'];
    OrgCode = json['OrgCode'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Mode'] = this.Mode;
    data['CustomerID'] = this.CustomerID;
    data['OrgCode'] = this.OrgCode;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
