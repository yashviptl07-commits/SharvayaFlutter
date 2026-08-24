class MaterialInwardDetailListResponse {
  List<MaterialInwardDetailListResponseDetails> details;
  int totalCount;

  MaterialInwardDetailListResponse({this.details, this.totalCount});

  MaterialInwardDetailListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new MaterialInwardDetailListResponseDetails.fromJson(v));
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

class MaterialInwardDetailListResponseDetails {
  int pkID;
  String inwardNo;
  int taxType;
  int productID;
  String productName;
  double quantity;
  String unit;
  double unitRate;
  int discountPercent;
  double discountAmt;
  double netRate;
  double amount;
  double taxRate;
  double taxAmount;
  double netAmount;
  double sGSTPer;
  double sGSTAmt;
  double cGSTPer;
  double cGSTAmt;
  double iGSTPer;
  double iGSTAmt;
  String orderNo;
  String indentNo;
  String createdBy;
  String createdDate;
  String updatedBy;
  String updatedDate;
  int locationID;
  double sampleQuantity;
  String dateCode;

  MaterialInwardDetailListResponseDetails(
      {this.pkID,
        this.inwardNo,
        this.taxType,
        this.productID,
        this.productName,
        this.quantity,
        this.unit,
        this.unitRate,
        this.discountPercent,
        this.discountAmt,
        this.netRate,
        this.amount,
        this.taxRate,
        this.taxAmount,
        this.netAmount,
        this.sGSTPer,
        this.sGSTAmt,
        this.cGSTPer,
        this.cGSTAmt,
        this.iGSTPer,
        this.iGSTAmt,
        this.orderNo,
        this.indentNo,
        this.createdBy,
        this.createdDate,
        this.updatedBy,
        this.updatedDate,
        this.locationID,
        this.sampleQuantity,
        this.dateCode});

  MaterialInwardDetailListResponseDetails.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    inwardNo = json['InwardNo'];
    taxType = json['TaxType'];
    productID = json['ProductID'];
    productName = json['ProductName'];
    quantity = json['Quantity'];
    unit = json['Unit'];
    unitRate = json['UnitRate'];
    discountPercent = json['DiscountPercent'];
    discountAmt = json['DiscountAmt'];
    netRate = json['NetRate'];
    amount = json['Amount'];
    taxRate = json['TaxRate'];
    taxAmount = json['TaxAmount'];
    netAmount = json['NetAmount'];
    sGSTPer = json['SGSTPer'];
    sGSTAmt = json['SGSTAmt'];
    cGSTPer = json['CGSTPer'];
    cGSTAmt = json['CGSTAmt'];
    iGSTPer = json['IGSTPer'];
    iGSTAmt = json['IGSTAmt'];
    orderNo = json['OrderNo'];
    indentNo = json['IndentNo'];
    createdBy = json['CreatedBy'];
    createdDate = json['CreatedDate'];
    updatedBy = json['UpdatedBy'];
    updatedDate = json['UpdatedDate'];
    locationID = json['LocationID'];
    sampleQuantity = json['SampleQuantity'];
    dateCode = json['DateCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['InwardNo'] = this.inwardNo;
    data['TaxType'] = this.taxType;
    data['ProductID'] = this.productID;
    data['ProductName'] = this.productName;
    data['Quantity'] = this.quantity;
    data['Unit'] = this.unit;
    data['UnitRate'] = this.unitRate;
    data['DiscountPercent'] = this.discountPercent;
    data['DiscountAmt'] = this.discountAmt;
    data['NetRate'] = this.netRate;
    data['Amount'] = this.amount;
    data['TaxRate'] = this.taxRate;
    data['TaxAmount'] = this.taxAmount;
    data['NetAmount'] = this.netAmount;
    data['SGSTPer'] = this.sGSTPer;
    data['SGSTAmt'] = this.sGSTAmt;
    data['CGSTPer'] = this.cGSTPer;
    data['CGSTAmt'] = this.cGSTAmt;
    data['IGSTPer'] = this.iGSTPer;
    data['IGSTAmt'] = this.iGSTAmt;
    data['OrderNo'] = this.orderNo;
    data['IndentNo'] = this.indentNo;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    data['UpdatedBy'] = this.updatedBy;
    data['UpdatedDate'] = this.updatedDate;
    data['LocationID'] = this.locationID;
    data['SampleQuantity'] = this.sampleQuantity;
    data['DateCode'] = this.dateCode;
    return data;
  }
}