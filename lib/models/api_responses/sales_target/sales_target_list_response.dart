class SalesTargetListResponse {
  List<SalesTargetListResponseDetails> details;
  int totalCount;

  SalesTargetListResponse({this.details, this.totalCount});

  SalesTargetListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new SalesTargetListResponseDetails.fromJson(v));
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

class SalesTargetListResponseDetails {
  int pkID;
  String employeeName;
  String fromDate;
  String toDate;
  String targetType;
  String targetType1;
  int employeeId;
  double targetAmount;
  double qtyAmount;
  double achievedAmount;
  double percentage;
  int customerId;
  String customerName;
  int productId;
  String productName;

  SalesTargetListResponseDetails({
    this.pkID,
    this.employeeName,
    this.fromDate,
    this.toDate,
    this.targetType,
    this.targetType1,
    this.employeeId,
    this.targetAmount,
    this.qtyAmount,
    this.achievedAmount,
    this.percentage,
    this.customerId,
    this.customerName,
    this.productId,
    this.productName,
  });

  SalesTargetListResponseDetails.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'] == null ? 0 : json['pkID'];
    employeeName = json['EmployeeName'] == null ? "" : json['EmployeeName'];
    fromDate = json['FromDate'] == null ? "" : json['FromDate'];
    toDate = json['ToDate'] == null ? "" : json['ToDate'];
    targetType = json['TargetType'] == null ? "" : json['TargetType'];
    targetType1 = json['TargetType1'] == null ? "" : json['TargetType1'];
    employeeId = json['EmployeeId'] == null ? 0 : json['EmployeeId'];
    targetAmount = json['TargetAmount'] == null ? 0.00 : json['TargetAmount'];
    qtyAmount = json['QtyAmount'] == null ? 0.00 : json['QtyAmount'];
    achievedAmount =
        json['AchievedAmount'] == null ? 0.00 : json['AchievedAmount'];
    percentage = json['Percentage'] == null ? 0.00 : json['Percentage'];
    customerId = json['CustomerId'] == null ? 0 : json['CustomerId'];
    customerName = json['CustomerName'] == null ? "" : json['CustomerName'];
    productId = json['ProductId'] == null ? 0 : json['ProductId'];
    productName = json['ProductName'] == null ? "" : json['ProductName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['EmployeeName'] = this.employeeName;
    data['FromDate'] = this.fromDate;
    data['ToDate'] = this.toDate;
    data['TargetType'] = this.targetType;
    data['TargetType1'] = this.targetType1;
    data['EmployeeId'] = this.employeeId;
    data['TargetAmount'] = this.targetAmount;
    data['QtyAmount'] = this.qtyAmount;
    data['AchievedAmount'] = this.achievedAmount;
    data['Percentage'] = this.percentage;
    data['CustomerId'] = this.customerId;
    data['CustomerName'] = this.customerName;
    data['ProductId'] = this.productId;
    data['ProductName'] = this.productName;
    return data;
  }
}
