/*
CustomerID:
CompanyId:7235*/

class MudraServiceListRequest {
  String CustomerID;
  String CompanyId;

  MudraServiceListRequest({this.CustomerID, this.CompanyId});

  MudraServiceListRequest.fromJson(Map<String, dynamic> json) {
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
