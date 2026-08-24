/*
pkID:50073
ComplaintNo:100143
CustomerID:231324
ServiceTag:
VisitDate:2023-08-14
TimeFrom:05:00 PM
TimeTo:05:30 PM
VisitNotes:Visit Notes.
VisitType:Charged
VisitChargeType:Cash
VisitCharge:565.00
ComplaintStatus:Inward
VisitDocument:visitdocuments/visit-document-50073.png
EngineerNotes:Engineer Notes.
FromKMS:14350
ToKMS:14365
LoginUserID:admin
CompanyId:7235*/
class MudraAttendVisitSaveRequest {
  String pkID;
  String ComplaintNo;
  String VisitDate;
  String ComplaintStatus;
  String CustomerID;
  String VisitCharge;
  String FromKMS;
  String VisitType;
  String ServiceTag;
  String VisitNotes;
  String EngineerNotes;
  String VisitChargeType;
  String ToKMS;
  String TimeFrom;
  String TimeTo;
  String LoginUserID;
  String CompanyId;
  String VisitDocument;

  MudraAttendVisitSaveRequest(
      {this.pkID,
      this.ComplaintNo,
      this.VisitDate,
      this.ComplaintStatus,
      this.CustomerID,
      this.VisitCharge,
      this.FromKMS,
      this.VisitType,
      this.ServiceTag,
      this.VisitNotes,
      this.EngineerNotes,
      this.VisitChargeType,
      this.ToKMS,
      this.TimeFrom,
      this.TimeTo,
      this.LoginUserID,
      this.VisitDocument,
      this.CompanyId});

  MudraAttendVisitSaveRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    ComplaintNo = json['ComplaintNo'];
    VisitDate = json['VisitDate'];
    ComplaintStatus = json['ComplaintStatus'];
    CustomerID = json['CustomerID'];
    VisitCharge = json['VisitCharge'];
    FromKMS = json['FromKMS'];
    VisitType = json['VisitType'];
    ServiceTag = json['ServiceTag'];
    VisitNotes = json['VisitNotes'];
    EngineerNotes = json['EngineerNotes'];
    VisitChargeType = json['VisitChargeType'];
    ToKMS = json['ToKMS'];
    TimeFrom = json['TimeFrom'];
    TimeTo = json['TimeTo'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
    VisitDocument = json['VisitDocument'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['ComplaintNo'] = this.ComplaintNo;
    data['VisitDate'] = this.VisitDate;
    data['ComplaintStatus'] = this.ComplaintStatus;
    data['CustomerID'] = this.CustomerID;
    data['VisitCharge'] = this.VisitCharge;
    data['FromKMS'] = this.FromKMS;
    data['VisitType'] = this.VisitType;
    data['ServiceTag'] = this.ServiceTag;
    data['VisitNotes'] = this.VisitNotes;
    data['EngineerNotes'] = this.EngineerNotes;
    data['VisitChargeType'] = this.VisitChargeType;
    data['ToKMS'] = this.ToKMS;
    data['TimeFrom'] = this.TimeFrom;
    data['TimeTo'] = this.TimeTo;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;
    data['VisitDocument'] = this.VisitDocument;

    return data;
  }
}
