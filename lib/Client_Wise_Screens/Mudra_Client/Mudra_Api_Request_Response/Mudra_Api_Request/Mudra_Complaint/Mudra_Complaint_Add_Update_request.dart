/*
pkID:100143
ComplaintNo:TK-AUG23-007
ComplaintDate:2023-08-14
ComplaintStatus:Open
CustomerID:231324
ProductGroup:LENOVO
ReferenceNo:
ServiceType:AMC
ServiceTag:
ComplaintNotes:Complaint FAULT
ComplaintType:Offline
EmployeeID:50090
PreferredDate:2023-08-14
TimeFrom:04:00 PM
TimeTo:04:15 PM
LoginUserID:admin
CompanyId:7235*/
class MudraComplaintSaveRequest {
  String pkID;
  String ComplaintNo;
  String ComplaintDate;
  String ComplaintStatus;
  String CustomerID;
  String ProductGroup;
  String ReferenceNo;
  String ServiceType;
  String ServiceTag;
  String ComplaintNotes;
  String ComplaintType;
  String EmployeeID;
  String PreferredDate;
  String TimeFrom;
  String TimeTo;
  String LoginUserID;
  String CompanyId;

  MudraComplaintSaveRequest(
      {this.pkID,
      this.ComplaintNo,
      this.ComplaintDate,
      this.ComplaintStatus,
      this.CustomerID,
      this.ProductGroup,
      this.ReferenceNo,
      this.ServiceType,
      this.ServiceTag,
      this.ComplaintNotes,
      this.ComplaintType,
      this.EmployeeID,
      this.PreferredDate,
      this.TimeFrom,
      this.TimeTo,
      this.LoginUserID,
      this.CompanyId});

  MudraComplaintSaveRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    ComplaintNo = json['ComplaintNo'];
    ComplaintDate = json['ComplaintDate'];
    ComplaintStatus = json['ComplaintStatus'];
    CustomerID = json['CustomerID'];
    ProductGroup = json['ProductGroup'];
    ReferenceNo = json['ReferenceNo'];
    ServiceType = json['ServiceType'];
    ServiceTag = json['ServiceTag'];
    ComplaintNotes = json['ComplaintNotes'];
    ComplaintType = json['ComplaintType'];
    EmployeeID = json['EmployeeID'];
    PreferredDate = json['PreferredDate'];
    TimeFrom = json['TimeFrom'];
    TimeTo = json['TimeTo'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['ComplaintNo'] = this.ComplaintNo;
    data['ComplaintDate'] = this.ComplaintDate;
    data['ComplaintStatus'] = this.ComplaintStatus;
    data['CustomerID'] = this.CustomerID;
    data['ProductGroup'] = this.ProductGroup;
    data['ReferenceNo'] = this.ReferenceNo;
    data['ServiceType'] = this.ServiceType;
    data['ServiceTag'] = this.ServiceTag;
    data['ComplaintNotes'] = this.ComplaintNotes;
    data['ComplaintType'] = this.ComplaintType;
    data['EmployeeID'] = this.EmployeeID;
    data['PreferredDate'] = this.PreferredDate;
    data['TimeFrom'] = this.TimeFrom;
    data['TimeTo'] = this.TimeTo;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
