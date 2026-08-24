/*
pkID:0
InquiryNo:
VisitDate:2026-01-26
VisitTime:12:01 PM
VisitorName:Nikhil Yadav
VisitorContact:1238523690
VisitorEmail:nikhil@gmail.com
PurposeOfVisit:hi sharvaya
CustomerID:0
CompanyName:sharvaya
CompanyContact:4563217890
Address:sharvaya
City:350
State:12
Pincode:385620
Country:IND
EmployeeID:0
Department:Sharvaya Flutter
MeetingTo:ABC
LoginUserID:admin
CompanyId:52315
VisitorImage:+File
VisitorDocument:+File*/

import 'dart:io';

class VisitorInfoAddUpdateApiRequest {
  String pkID;
  String InquiryNo;
  String VisitDate;
  String VisitTime;
  String VisitorName;
  String VisitorContact;
  String VisitorEmail;
  String PurposeOfVisit;
  String CustomerID;
  String CompanyName;
  String CompanyContact;
  String Address;
  String City;
  String State;
  String Pincode;
  String Country;
  String EmployeeID;
  String Department;
  String MeetingTo;
  String LoginUserID;
  String CompanyId;
  File VisitorImage;
  File VisitorDocument;

  VisitorInfoAddUpdateApiRequest({
    this.pkID,
    this.InquiryNo,
    this.VisitDate,
    this.VisitTime,
    this.VisitorName,
    this.VisitorContact,
    this.VisitorEmail,
    this.PurposeOfVisit,
    this.CustomerID,
    this.CompanyName,
    this.CompanyContact,
    this.Address,
    this.City,
    this.State,
    this.Pincode,
    this.Country,
    this.EmployeeID,
    this.Department,
    this.MeetingTo,
    this.LoginUserID,
    this.CompanyId,
    this.VisitorImage,
    this.VisitorDocument,
  });

  VisitorInfoAddUpdateApiRequest.fromJson(Map<String, dynamic> json)
      : pkID = json['pkID'],
        InquiryNo = json['InquiryNo'],
        VisitDate = json['VisitDate'],
        VisitTime = json['VisitTime'],
        VisitorName = json['VisitorName'],
        VisitorContact = json['VisitorContact'],
        VisitorEmail = json['VisitorEmail'],
        PurposeOfVisit = json['PurposeOfVisit'],
        CustomerID = json['CustomerID'],
        CompanyName = json['CompanyName'],
        CompanyContact = json['CompanyContact'],
        Address = json['Address'],
        City = json['City'],
        State = json['State'],
        Pincode = json['Pincode'],
        Country = json['Country'],
        EmployeeID = json['EmployeeID'],
        Department = json['Department'],
        MeetingTo = json['MeetingTo'],
        LoginUserID = json['LoginUserID'],
        CompanyId = json['CompanyId'],
        VisitorImage = null,
        VisitorDocument = null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pkID'] = pkID;
    data['InquiryNo'] = InquiryNo;
    data['VisitDate'] = VisitDate;
    data['VisitTime'] = VisitTime;
    data['VisitorName'] = VisitorName;
    data['VisitorContact'] = VisitorContact;
    data['VisitorEmail'] = VisitorEmail;
    data['PurposeOfVisit'] = PurposeOfVisit;
    data['CustomerID'] = CustomerID;
    data['CompanyName'] = CompanyName;
    data['CompanyContact'] = CompanyContact;
    data['Address'] = Address;
    data['City'] = City;
    data['State'] = State;
    data['Pincode'] = Pincode;
    data['Country'] = Country;
    data['EmployeeID'] = EmployeeID;
    data['Department'] = Department;
    data['MeetingTo'] = MeetingTo;
    data['LoginUserID'] = LoginUserID;
    data['CompanyId'] = CompanyId;
    return data;
  }
}
