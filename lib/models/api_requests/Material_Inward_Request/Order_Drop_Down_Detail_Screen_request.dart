/*
CustomerID:525335
CompanyId:7291*/

class OrderDropDownDetailRequest {
  String CustomerID;
  String CompanyId;

  OrderDropDownDetailRequest({
    this.CustomerID,
    this.CompanyId,
  });

  OrderDropDownDetailRequest.fromJson(Map<String, dynamic> json) {
    CustomerID = json['CustomerID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CustomerID'] = this.CustomerID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
