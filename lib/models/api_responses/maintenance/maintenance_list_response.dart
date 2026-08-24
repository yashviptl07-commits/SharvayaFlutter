class MaintenanceListResponse {
  List<MaintenanceDetails> details;
  int totalCount;

  MaintenanceListResponse({this.details, this.totalCount});

  MaintenanceListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new MaintenanceDetails.fromJson(v));
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

class MaintenanceDetails {
  int rowNum;
  int pkID;
  String inquiryNo;
  String startDate;
  String endDate;
  String contractType;
  String serialKey;
  int employeeID;
  String ownerShip;
  int customerID;
  String customerName;
  String contactPerson;
  String contactNumber;
  String emailAddress;
  String contractFooter;
  String contractTNC;
  String cityName;
  String stateName;
  double totalAmount;
  String employeeName;
  String designation;
  String createdBy;
  int companyID;
  String lastFollowupDate;
  String lastNextFollowupDate;
  int renewDays;
  String iMEINo;
  String remarks;
  int warranty;
  String warrantyName;

  MaintenanceDetails(
      {this.rowNum,
        this.pkID,
        this.inquiryNo,
        this.startDate,
        this.endDate,
        this.contractType,
        this.serialKey,
        this.employeeID,
        this.ownerShip,
        this.customerID,
        this.customerName,
        this.contactPerson,
        this.contactNumber,
        this.emailAddress,
        this.contractFooter,
        this.contractTNC,
        this.cityName,
        this.stateName,
        this.totalAmount,
        this.employeeName,
        this.designation,
        this.createdBy,
        this.companyID,
        this.lastFollowupDate,
        this.lastNextFollowupDate,
        this.renewDays,
        this.iMEINo,
        this.remarks,
        this.warranty,
        this.warrantyName});

  MaintenanceDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'];
    pkID = json['pkID'];
    inquiryNo = json['InquiryNo'];
    startDate = json['StartDate'];
    endDate = json['EndDate'];
    contractType = json['ContractType'];
    serialKey = json['SerialKey'];
    employeeID = json['EmployeeID'];
    ownerShip = json['OwnerShip'];
    customerID = json['CustomerID'];
    customerName = json['CustomerName'];
    contactPerson = json['ContactPerson'];
    contactNumber = json['ContactNumber'];
    emailAddress = json['EmailAddress'];
    contractFooter = json['ContractFooter'];
    contractTNC = json['ContractTNC'];
    cityName = json['CityName'];
    stateName = json['StateName'];
    totalAmount = json['TotalAmount'];
    employeeName = json['EmployeeName'];
    designation = json['Designation'];
    createdBy = json['CreatedBy'];
    companyID = json['CompanyID'];
    lastFollowupDate = json['LastFollowupDate'];
    lastNextFollowupDate = json['LastNextFollowupDate'];
    renewDays = json['RenewDays'];
    iMEINo = json['IMEINo'];
    remarks = json['Remarks'];
    warranty = json['Warranty'];
    warrantyName = json['WarrantyName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['InquiryNo'] = this.inquiryNo;
    data['StartDate'] = this.startDate;
    data['EndDate'] = this.endDate;
    data['ContractType'] = this.contractType;
    data['SerialKey'] = this.serialKey;
    data['EmployeeID'] = this.employeeID;
    data['OwnerShip'] = this.ownerShip;
    data['CustomerID'] = this.customerID;
    data['CustomerName'] = this.customerName;
    data['ContactPerson'] = this.contactPerson;
    data['ContactNumber'] = this.contactNumber;
    data['EmailAddress'] = this.emailAddress;
    data['ContractFooter'] = this.contractFooter;
    data['ContractTNC'] = this.contractTNC;
    data['CityName'] = this.cityName;
    data['StateName'] = this.stateName;
    data['TotalAmount'] = this.totalAmount;
    data['EmployeeName'] = this.employeeName;
    data['Designation'] = this.designation;
    data['CreatedBy'] = this.createdBy;
    data['CompanyID'] = this.companyID;
    data['LastFollowupDate'] = this.lastFollowupDate;
    data['LastNextFollowupDate'] = this.lastNextFollowupDate;
    data['RenewDays'] = this.renewDays;
    data['IMEINo'] = this.iMEINo;
    data['Remarks'] = this.remarks;
    data['Warranty'] = this.warranty;
    data['WarrantyName'] = this.warrantyName;
    return data;
  }
}