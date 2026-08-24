
class MIGetFetDetailByOrderNoListRequest {
  String FetchType;
  String No;
  String CustomerID;
  String CompanyId;

  MIGetFetDetailByOrderNoListRequest(
      {this.FetchType, this.No, this.CustomerID, this.CompanyId});

  MIGetFetDetailByOrderNoListRequest.fromJson(
      Map<String, dynamic> json) {
    FetchType = json['FetchType'];
    No = json['No'];
    CustomerID = json['CustomerID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FetchType'] = this.FetchType;
    data['No'] = this.No;
    data['CustomerID'] = this.CustomerID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
