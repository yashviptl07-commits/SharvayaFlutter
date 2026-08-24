/*
CustomerID:141852
ContactType:ContactPerson
LoginUserID:admin
CompanyId:4132*/


class   MasterMaintenanceCheckListRequest {
  String CustomerID;
  String ContactType;
  String LoginUserID;
  String CompanyId;

  MasterMaintenanceCheckListRequest({this.CustomerID, this.ContactType, this.LoginUserID, this.CompanyId});

  MasterMaintenanceCheckListRequest.fromJson(Map<String, dynamic> json) {
    CustomerID = json['CustomerID'];
    ContactType = json['ContactType'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CustomerID'] = this.CustomerID;
    data['ContactType'] = this.ContactType;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;
    return data;
  }
}