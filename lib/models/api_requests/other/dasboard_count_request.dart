/*UserID:dhara
FromDate:2023-06-16
ToDate:2023-06-16
CompanyId:1*/

class DashBoardCountRequest {
  String UserID;
  String FromDate;
  String ToDate;
  String CompanyId;

  DashBoardCountRequest(
  {this.UserID, this.FromDate, this.ToDate, this.CompanyId});


  DashBoardCountRequest.fromJson(Map<String, dynamic> json) {
    UserID = json['UserID'];
    FromDate = json['FromDate'];
    ToDate = json['ToDate'];
    CompanyId = json['CompanyId'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserID'] = this.UserID;
    data['FromDate'] = this.FromDate;
    data['ToDate'] = this.ToDate;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}