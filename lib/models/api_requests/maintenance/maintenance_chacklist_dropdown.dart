/*
CheckHead:Warrantytype
LoginUserID:admin
CompanyId:4132*/


class MaintenanceCheckListDRPRequest {
  String CheckHead;
  String LoginUserID;
  String CompanyId;

  MaintenanceCheckListDRPRequest({this.CheckHead, this.LoginUserID, this.CompanyId});

  MaintenanceCheckListDRPRequest.fromJson(Map<String, dynamic> json) {
    CheckHead = json['CheckHead'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CheckHead'] = this.CheckHead;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;
    return data;
  }
}

