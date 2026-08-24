/*
pkID:0
SearchKey:
Month:10
Year:2025
PageNo:1
PageSize:1000
CompanyId:52315*/

class PaySlipListRequest {
  String pkID;
  String SearchKey;
  String Month;
  String Year;
  String PageNo;
  String PageSize;
  String CompanyId;

  PaySlipListRequest(
      {this.pkID,
      this.SearchKey,
      this.Month,
      this.Year,
      this.PageNo,
      this.PageSize,
      this.CompanyId});

  PaySlipListRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    SearchKey = json['SearchKey'];
    Month = json['Month'];
    Year = json['Year'];
    PageNo = json['PageNo'];
    PageSize = json['PageSize'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['SearchKey'] = this.SearchKey;
    data['Month'] = this.Month;
    data['Year'] = this.Year;
    data['PageNo'] = this.PageNo;
    data['PageSize'] = this.PageSize;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
