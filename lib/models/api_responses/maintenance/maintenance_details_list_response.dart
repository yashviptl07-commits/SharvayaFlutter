class MaintenanceDetailsListResponse {
  List<Details> details;
  int totalCount;

  MaintenanceDetailsListResponse({this.details, this.totalCount});

  MaintenanceDetailsListResponse.fromJson(Map<String, dynamic> json) {
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
  String serialKey;
  int productID;
  String productName;
  double quantity;
  double unitPrice;
  String productNameLong;
  String startDate;
  String endDate;
  String orderNo;

  Details(
      {this.rowNum,
        this.pkID,
        this.inquiryNo,
        this.serialKey,
        this.productID,
        this.productName,
        this.quantity,
        this.unitPrice,
        this.productNameLong,
        this.startDate,
        this.endDate,
        this.orderNo});

  Details.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'];
    pkID = json['pkID'];
    inquiryNo = json['InquiryNo'];
    serialKey = json['SerialKey'];
    productID = json['ProductID'];
    productName = json['ProductName'];
    quantity = json['Quantity'];
    unitPrice = json['UnitPrice'];
    productNameLong = json['ProductNameLong'];
    startDate = json['StartDate'];
    endDate = json['EndDate'];
    orderNo = json['OrderNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['InquiryNo'] = this.inquiryNo;
    data['SerialKey'] = this.serialKey;
    data['ProductID'] = this.productID;
    data['ProductName'] = this.productName;
    data['Quantity'] = this.quantity;
    data['UnitPrice'] = this.unitPrice;
    data['ProductNameLong'] = this.productNameLong;
    data['StartDate'] = this.startDate;
    data['EndDate'] = this.endDate;
    data['OrderNo'] = this.orderNo;
    return data;
  }
}