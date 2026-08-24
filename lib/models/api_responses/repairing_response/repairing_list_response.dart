class RepairingListResponse {
  List<RepairingListResponseDetails> details;
  int totalCount;

  RepairingListResponse({this.details, this.totalCount});

  RepairingListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new RepairingListResponseDetails.fromJson(v));
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

class RepairingListResponseDetails {
  int rowNum;
  int pkID;
  String repairingNo;
  String repairingDate;
  int customerID;
  String customerName;
  String primaryMobileNo;
  String alternateMobileNo;
  int productID;
  String productName;
  String iMEINo;
  String deliveryDate;
  String accessPattern;
  String accessPin;
  String problemNotes;
  String repairingNotes;
  String contractFooter;
  String repairingStage;
  int assignTo;
  String assigntoEmployeeName;
  int employeeID;
  double amount;
  String createdBy;
  String createdEmployeeName;
  String createdDate;
  String updatedBy;
  String updatedDate;

  RepairingListResponseDetails(
      {this.rowNum,
        this.pkID,
        this.repairingNo,
        this.repairingDate,
        this.customerID,
        this.customerName,
        this.primaryMobileNo,
        this.alternateMobileNo,
        this.productID,
        this.productName,
        this.iMEINo,
        this.deliveryDate,
        this.accessPattern,
        this.accessPin,
        this.problemNotes,
        this.repairingNotes,
        this.contractFooter,
        this.repairingStage,
        this.assignTo,
        this.assigntoEmployeeName,
        this.employeeID,
        this.amount,
        this.createdBy,
        this.createdEmployeeName,
        this.createdDate,
        this.updatedBy,
        this.updatedDate});

  RepairingListResponseDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'] == null ? 0 : json['RowNum'];
    pkID = json['pkID'] == null ? 0 : json['pkID'];
    repairingNo = json['RepairingNo'] == null ? "" : json['RepairingNo'];
    repairingDate = json['RepairingDate'] == null ? "" : json['RepairingDate'];
    customerID = json['CustomerID'] == null ? 0 : json['CustomerID'];
    customerName = json['CustomerName'] == null ? "" : json['CustomerName'];
    primaryMobileNo = json['PrimaryMobileNo'] == null ? "" : json['PrimaryMobileNo'];
    alternateMobileNo = json['AlternateMobileNo'] == null ? "" : json['AlternateMobileNo'];
    productID = json['ProductID'] == null ? 0 : json['ProductID'];
    productName = json['ProductName'] == null ? "" : json['ProductName'];
    iMEINo = json['IMEINo'] == null ? "" : json['IMEINo'];
    deliveryDate = json['DeliveryDate'] == null ? "" : json['DeliveryDate'];
    accessPattern = json['AccessPattern'] == null ? "" : json['AccessPattern'];
    accessPin = json['AccessPin'] == null ? "" : json['AccessPin'];
    problemNotes = json['ProblemNotes'] == null ? "" : json['ProblemNotes'];
    repairingNotes = json['RepairingNotes'] == null ? "" : json['RepairingNotes'];
    contractFooter = json['ContractFooter'] == null ? "" : json['ContractFooter'];
    repairingStage = json['RepairingStage'] == null ? "" : json['RepairingStage'];
    assignTo = json['AssignTo'] == null ? 0 : json['AssignTo'];
    assigntoEmployeeName = json['AssigntoEmployeeName'] == null ? "" : json['AssigntoEmployeeName'];
    employeeID = json['EmployeeID'] == null ? 0 : json['EmployeeID'];
    amount = json['Amount'] == null ? 0.00 : json['Amount'];
    createdBy = json['CreatedBy'] == null ? 0 : json['CreatedBy'];
    createdEmployeeName = json['CreatedEmployeeName'] == null ? "" : json['CreatedEmployeeName'];
    createdDate = json['CreatedDate'] == null ? "" : json['CreatedDate'];
    updatedBy = json['UpdatedBy'] == null ? "" : json['UpdatedBy'];
    updatedDate = json['UpdatedDate'] == null ? "" : json['UpdatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['RepairingNo'] = this.repairingNo;
    data['RepairingDate'] = this.repairingDate;
    data['CustomerID'] = this.customerID;
    data['CustomerName'] = this.customerName;
    data['PrimaryMobileNo'] = this.primaryMobileNo;
    data['AlternateMobileNo'] = this.alternateMobileNo;
    data['ProductID'] = this.productID;
    data['ProductName'] = this.productName;
    data['IMEINo'] = this.iMEINo;
    data['DeliveryDate'] = this.deliveryDate;
    data['AccessPattern'] = this.accessPattern;
    data['AccessPin'] = this.accessPin;
    data['ProblemNotes'] = this.problemNotes;
    data['RepairingNotes'] = this.repairingNotes;
    data['ContractFooter'] = this.contractFooter;
    data['RepairingStage'] = this.repairingStage;
    data['AssignTo'] = this.assignTo;
    data['AssigntoEmployeeName'] = this.assigntoEmployeeName;
    data['EmployeeID'] = this.employeeID;
    data['Amount'] = this.amount;
    data['CreatedBy'] = this.createdBy;
    data['CreatedEmployeeName'] = this.createdEmployeeName;
    data['CreatedDate'] = this.createdDate;
    data['UpdatedBy'] = this.updatedBy;
    data['UpdatedDate'] = this.updatedDate;
    return data;
  }
}