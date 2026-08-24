class MudraServiceListResponse {
  List<Details> details;
  int totalCount;

  MudraServiceListResponse({this.details, this.totalCount});

  MudraServiceListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = <Details>[];
      json['details'].forEach((v) {
        details.add(new Details.fromJson(v));
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

class Details {
  int rowNum;
  int pkID;
  String inquiryNo;
  String startDate;
  String endDate;
  String contractType;
  int customerID;
  String customerName;
  String contactPerson;
  String contactNumber;
  String emailAddress;
  String contractFooter;
  String contractTNC;
  String cityName;
  String stateName;
  int serviceDuration;
  String productGroupName;
  String contractNotes;
  String employeeName;
  String designation;
  String createdBy;
  int companyID;

  Details(
      {this.rowNum,
        this.pkID,
        this.inquiryNo,
        this.startDate,
        this.endDate,
        this.contractType,
        this.customerID,
        this.customerName,
        this.contactPerson,
        this.contactNumber,
        this.emailAddress,
        this.contractFooter,
        this.contractTNC,
        this.cityName,
        this.stateName,
        this.serviceDuration,
        this.productGroupName,
        this.contractNotes,
        this.employeeName,
        this.designation,
        this.createdBy,
        this.companyID});

  Details.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'];
    pkID = json['pkID'];
    inquiryNo = json['InquiryNo'];
    startDate = json['StartDate'];
    endDate = json['EndDate'];
    contractType = json['ContractType'];
    customerID = json['CustomerID'];
    customerName = json['CustomerName'];
    contactPerson = json['ContactPerson'];
    contactNumber = json['ContactNumber'];
    emailAddress = json['EmailAddress'];
    contractFooter = json['ContractFooter'];
    contractTNC = json['ContractTNC'];
    cityName = json['CityName'];
    stateName = json['StateName'];
    serviceDuration = json['ServiceDuration'];
    productGroupName = json['ProductGroupName'];
    contractNotes = json['ContractNotes'];
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
    data['StartDate'] = this.startDate;
    data['EndDate'] = this.endDate;
    data['ContractType'] = this.contractType;
    data['CustomerID'] = this.customerID;
    data['CustomerName'] = this.customerName;
    data['ContactPerson'] = this.contactPerson;
    data['ContactNumber'] = this.contactNumber;
    data['EmailAddress'] = this.emailAddress;
    data['ContractFooter'] = this.contractFooter;
    data['ContractTNC'] = this.contractTNC;
    data['CityName'] = this.cityName;
    data['StateName'] = this.stateName;
    data['ServiceDuration'] = this.serviceDuration;
    data['ProductGroupName'] = this.productGroupName;
    data['ContractNotes'] = this.contractNotes;
    data['EmployeeName'] = this.employeeName;
    data['Designation'] = this.designation;
    data['CreatedBy'] = this.createdBy;
    data['CompanyID'] = this.companyID;
    return data;
  }
}