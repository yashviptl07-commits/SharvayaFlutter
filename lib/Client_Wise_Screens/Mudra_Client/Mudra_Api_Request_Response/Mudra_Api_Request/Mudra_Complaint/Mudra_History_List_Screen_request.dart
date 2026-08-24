/*
ComplaintNo:100144
CompanyId:7235*/
class MudraHistoryListRequest {
  String ComplaintNo;
  String CompanyId;

  MudraHistoryListRequest({this.ComplaintNo, this.CompanyId});

  MudraHistoryListRequest.fromJson(Map<String, dynamic> json) {
    ComplaintNo = json['ComplaintNo'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ComplaintNo'] = this.ComplaintNo;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}