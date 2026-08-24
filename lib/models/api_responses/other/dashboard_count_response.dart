class DashBoardCountResponse {
  List<DashBoardCountResponseDetails> details;
  int totalCount;

  DashBoardCountResponse({this.details, this.totalCount});

  DashBoardCountResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new DashBoardCountResponseDetails.fromJson(v));
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

class DashBoardCountResponseDetails {
  int followup;
  String userID;
  int employeeID;
  String employeeName;
  String designation;
  String companyName;
  int contacts;
  int toDO;
  int leave;
  int loginLogout;
  int inquiry;
  int followup1;
  int followup2;
  int quotation;
  int salesOrder;
  int purchaseOrder;
  int salesInvoice;
  int purchaseInvoice;
  int inward;
  int outward;
  int dailyActivity;

  DashBoardCountResponseDetails(
      {this.followup,
        this.userID,
        this.employeeID,
        this.employeeName,
        this.designation,
        this.companyName,
        this.contacts,
        this.toDO,
        this.leave,
        this.loginLogout,
        this.inquiry,
        this.followup1,
        this.followup2,
        this.quotation,
        this.salesOrder,
        this.purchaseOrder,
        this.salesInvoice,
        this.purchaseInvoice,
        this.inward,
        this.outward,
        this.dailyActivity});

  DashBoardCountResponseDetails.fromJson(Map<String, dynamic> json) {
    followup = json['Followup']==null?0:json['Followup'];
    userID = json['UserID']==null?"":json['UserID'];
    employeeID = json['EmployeeID']==null?0:json['EmployeeID'];
    employeeName = json['EmployeeName']==null?"":json['EmployeeName'];
    designation = json['Designation']==null?"":json['Designation'];
    companyName = json['CompanyName']==null?"":json['CompanyName'];
    contacts = json['Contacts']==null?0:json['Contacts'];
    toDO = json['ToDO']==null?0:json['ToDO'];
    leave = json['Leave']==null?0:json['Leave'];
    loginLogout = json['login_logout']==null?0:json['login_logout'];
    inquiry = json['Inquiry']==null?0:json['Inquiry'];
    followup1 = json['Followup1']==null?0:json['Followup1'];
    followup2 = json['Followup2']==null?0:json['Followup2'];
    quotation = json['Quotation']==null?0:json['Quotation'];
    salesOrder = json['SalesOrder']==null?0:json['SalesOrder'];
    purchaseOrder = json['PurchaseOrder']==null?0:json['PurchaseOrder'];
    salesInvoice = json['SalesInvoice']==null?0:json['SalesInvoice'];
    purchaseInvoice = json['PurchaseInvoice']==null?0:json['PurchaseInvoice'];
    inward = json['Inward']==null?0:json['Inward'];
    outward = json['Outward']==null?0:json['Outward'];
    dailyActivity = json['DailyActivity']==null?0:json['DailyActivity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Followup'] = this.followup;
    data['UserID'] = this.userID;
    data['EmployeeID'] = this.employeeID;
    data['EmployeeName'] = this.employeeName;
    data['Designation'] = this.designation;
    data['CompanyName'] = this.companyName;
    data['Contacts'] = this.contacts;
    data['ToDO'] = this.toDO;
    data['Leave'] = this.leave;
    data['login_logout'] = this.loginLogout;
    data['Inquiry'] = this.inquiry;
    data['Followup1'] = this.followup1;
    data['Followup2'] = this.followup2;
    data['Quotation'] = this.quotation;
    data['SalesOrder'] = this.salesOrder;
    data['PurchaseOrder'] = this.purchaseOrder;
    data['SalesInvoice'] = this.salesInvoice;
    data['PurchaseInvoice'] = this.purchaseInvoice;
    data['Inward'] = this.inward;
    data['Outward'] = this.outward;
    data['DailyActivity'] = this.dailyActivity;
    return data;
  }
}