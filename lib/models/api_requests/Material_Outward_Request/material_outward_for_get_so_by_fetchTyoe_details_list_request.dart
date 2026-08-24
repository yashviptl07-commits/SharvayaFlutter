/*
CustomerID:54
CompanyId:0*/
class MaterialOutwardPendingSalesOrderByFetchTypeDetailsListRequest {
  String FetchType;
  String No;
  String Ids;
  String CustomerID;
  String CompanyId;

  MaterialOutwardPendingSalesOrderByFetchTypeDetailsListRequest(
      {this.FetchType, this.No, this.Ids, this.CustomerID, this.CompanyId});

  MaterialOutwardPendingSalesOrderByFetchTypeDetailsListRequest.fromJson(
      Map<String, dynamic> json) {
    FetchType = json['FetchType'];
    No = json['No'];
    Ids = json['Ids'];
    CustomerID = json['CustomerID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FetchType'] = this.FetchType;
    data['No'] = this.No;
    data['Ids'] = this.Ids;
    data['CustomerID'] = this.CustomerID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
