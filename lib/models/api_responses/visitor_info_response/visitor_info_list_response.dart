class VisitorInfoListApiResponse {
  List<VisitorInfoListApiResponseDetails> details;
  int totalCount;

  VisitorInfoListApiResponse({this.details, this.totalCount});

  VisitorInfoListApiResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new VisitorInfoListApiResponseDetails.fromJson(v));
      });
    }
    totalCount = json['TotalCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.details != null) {
      data['details'] = this.details.map((v) => v.toJson()).toList();
    }
    data['TotalCount'] = this.totalCount;
    return data;
  }
}

class VisitorInfoListApiResponseDetails {
  int rowNum;
  int pkID;
  String inquiryNo;
  String visitDate;
  String visitTime;
  String visitorName;
  String visitorContact;
  String visitorEmail;
  String purposeOfVisit;
  String department;
  String meetingTo;
  int customerID;
  String companyName;
  String companyContact;
  String address;
  String city;
  String cityName;
  String pincode;
  String state;
  String stateName;
  String country;
  String countryName;
  String visitorImage;
  String visitorDocument;
  String employeeName;
  String designation;
  String createdBy;
  int companyID;

  VisitorInfoListApiResponseDetails(
      {this.rowNum,
      this.pkID,
      this.inquiryNo,
      this.visitDate,
      this.visitTime,
      this.visitorName,
      this.visitorContact,
      this.visitorEmail,
      this.purposeOfVisit,
      this.department,
      this.meetingTo,
      this.customerID,
      this.companyName,
      this.companyContact,
      this.address,
      this.city,
      this.cityName,
      this.pincode,
      this.state,
      this.stateName,
      this.country,
      this.countryName,
      this.visitorImage,
      this.visitorDocument,
      this.employeeName,
      this.designation,
      this.createdBy,
      this.companyID});

  VisitorInfoListApiResponseDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'];
    pkID = json['pkID'];
    inquiryNo = json['InquiryNo'];
    visitDate = json['VisitDate'];
    visitTime = json['VisitTime'];
    visitorName = json['VisitorName'];
    visitorContact = json['VisitorContact'];
    visitorEmail = json['VisitorEmail'];
    purposeOfVisit = json['PurposeOfVisit'];
    department = json['Department'];
    meetingTo = json['MeetingTo'];
    customerID = json['CustomerID'];
    companyName = json['CompanyName'];
    companyContact = json['CompanyContact'];
    address = json['Address'];
    city = json['City'];
    cityName = json['CityName'];
    pincode = json['Pincode'];
    state = json['State'];
    stateName = json['StateName'];
    country = json['Country'];
    countryName = json['CountryName'];
    visitorImage = json['VisitorImage'];
    visitorDocument = json['VisitorDocument'];
    employeeName = json['EmployeeName'];
    designation = json['Designation'];
    createdBy = json['CreatedBy'];
    companyID = json['CompanyID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['InquiryNo'] = this.inquiryNo;
    data['VisitDate'] = this.visitDate;
    data['VisitTime'] = this.visitTime;
    data['VisitorName'] = this.visitorName;
    data['VisitorContact'] = this.visitorContact;
    data['VisitorEmail'] = this.visitorEmail;
    data['PurposeOfVisit'] = this.purposeOfVisit;
    data['Department'] = this.department;
    data['MeetingTo'] = this.meetingTo;
    data['CustomerID'] = this.customerID;
    data['CompanyName'] = this.companyName;
    data['CompanyContact'] = this.companyContact;
    data['Address'] = this.address;
    data['City'] = this.city;
    data['CityName'] = this.cityName;
    data['Pincode'] = this.pincode;
    data['State'] = this.state;
    data['StateName'] = this.stateName;
    data['Country'] = this.country;
    data['CountryName'] = this.countryName;
    data['VisitorImage'] = this.visitorImage;
    data['VisitorDocument'] = this.visitorDocument;
    data['EmployeeName'] = this.employeeName;
    data['Designation'] = this.designation;
    data['CreatedBy'] = this.createdBy;
    data['CompanyID'] = this.companyID;
    return data;
  }
}
