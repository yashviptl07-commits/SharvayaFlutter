/*
pkID:0
ListMode:
LoginUserID:admin
SearchKey:
PageNo:1
PageSize:10
CompanyId:45297*/

class OfficeRefTypeFromCustomerIDRequest {
  String CustomerID;
  String Type;
  String CompanyId;

  OfficeRefTypeFromCustomerIDRequest(
      {this.CustomerID, this.Type, this.CompanyId});

  OfficeRefTypeFromCustomerIDRequest.fromJson(Map<String, dynamic> json) {
    CustomerID = json['CustomerID'];
    Type = json['Type'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['CustomerID'] = this.CustomerID;
    data['Type'] = this.Type;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
