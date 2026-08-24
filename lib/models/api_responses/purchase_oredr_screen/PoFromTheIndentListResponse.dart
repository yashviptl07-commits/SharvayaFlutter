class PoFromTheIndentListResponse {
  List<PoFromTheIndentListResponseDetails> details;
  int totalCount;

  PoFromTheIndentListResponse({this.details, this.totalCount});

  PoFromTheIndentListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new PoFromTheIndentListResponseDetails.fromJson(v));
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

class PoFromTheIndentListResponseDetails {
  double quantity;
  double qty;
  String indentNo;
  int productID;
  String unit;
  double inQty;
  String expectedDate;
  String remarks;
  double usedQty;
  String orderNo;
  double unitRate;
  double discountPercent;
  double discountPer;
  double discountAmount;
  double discountAmt;
  double netRate;
  double unitQty;
  double amount;
  double cGSTAmt;
  double sGSTAmt;
  double iGSTAmt;
  double cGSTPer;
  double sGSTPer;
  double iGSTPer;
  double taxRate;
  double taxAmount;
  double taxAmt;
  double netAmount;
  double netAmt;
  double headerDiscAmt;
  double headerDiscAmount;
  String productName;
  String approvalStatus;
  String productSpecification;
  String deliveryTime;
  int taxType;
  int locationId;
  String locationName;
  bool isChecked;

  PoFromTheIndentListResponseDetails(
      {this.quantity,
        this.qty,
        this.indentNo,
        this.productID,
        this.unit,
        this.inQty,
        this.expectedDate,
        this.remarks,
        this.usedQty,
        this.orderNo,
        this.unitRate,
        this.discountPercent,
        this.discountPer,
        this.discountAmount,
        this.discountAmt,
        this.netRate,
        this.unitQty,
        this.amount,
        this.cGSTAmt,
        this.sGSTAmt,
        this.iGSTAmt,
        this.cGSTPer,
        this.sGSTPer,
        this.iGSTPer,
        this.taxRate,
        this.taxAmount,
        this.taxAmt,
        this.netAmount,
        this.netAmt,
        this.headerDiscAmt,
        this.headerDiscAmount,
        this.productName,
        this.approvalStatus,
        this.productSpecification,
        this.deliveryTime,
        this.taxType,
        this.locationId,
        this.locationName,
        this.isChecked,
      });

  PoFromTheIndentListResponseDetails.fromJson(Map<String, dynamic> json) {
    quantity = json['Quantity'];
    qty = json['Qty'];
    indentNo = json['IndentNo'];
    productID = json['ProductID'];
    unit = json['Unit'];
    inQty = json['InQty'];
    expectedDate = json['ExpectedDate'];
    remarks = json['Remarks'];
    usedQty = json['UsedQty'];
    orderNo = json['OrderNo'];
    unitRate = json['UnitRate'];
    discountPercent = json['DiscountPercent'];
    discountPer = json['DiscountPer'];
    discountAmount = json['DiscountAmount'];
    discountAmt = json['DiscountAmt'];
    netRate = json['NetRate'];
    unitQty = json['UnitQty'];
    amount = json['Amount'];
    cGSTAmt = json['CGSTAmt'];
    sGSTAmt = json['SGSTAmt'];
    iGSTAmt = json['IGSTAmt'];
    cGSTPer = json['CGSTPer'];
    sGSTPer = json['SGSTPer'];
    iGSTPer = json['IGSTPer'];
    taxRate = json['TaxRate'];
    taxAmount = json['TaxAmount'];
    taxAmt = json['TaxAmt'];
    netAmount = json['NetAmount'];
    netAmt = json['NetAmt'];
    headerDiscAmt = json['HeaderDiscAmt'];
    headerDiscAmount = json['HeaderDiscAmount'];
    productName = json['ProductName'];
    approvalStatus = json['ApprovalStatus'];
    productSpecification = json['ProductSpecification'];
    deliveryTime = json['DeliveryTime'];
    taxType = json['TaxType'];
    locationId = json['LocationId'];
    locationName = json['LocationName'];
    isChecked = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Quantity'] = this.quantity;
    data['Qty'] = this.qty;
    data['IndentNo'] = this.indentNo;
    data['ProductID'] = this.productID;
    data['Unit'] = this.unit;
    data['InQty'] = this.inQty;
    data['ExpectedDate'] = this.expectedDate;
    data['Remarks'] = this.remarks;
    data['UsedQty'] = this.usedQty;
    data['OrderNo'] = this.orderNo;
    data['UnitRate'] = this.unitRate;
    data['DiscountPercent'] = this.discountPercent;
    data['DiscountPer'] = this.discountPer;
    data['DiscountAmount'] = this.discountAmount;
    data['DiscountAmt'] = this.discountAmt;
    data['NetRate'] = this.netRate;
    data['UnitQty'] = this.unitQty;
    data['Amount'] = this.amount;
    data['CGSTAmt'] = this.cGSTAmt;
    data['SGSTAmt'] = this.sGSTAmt;
    data['IGSTAmt'] = this.iGSTAmt;
    data['CGSTPer'] = this.cGSTPer;
    data['SGSTPer'] = this.sGSTPer;
    data['IGSTPer'] = this.iGSTPer;
    data['TaxRate'] = this.taxRate;
    data['TaxAmount'] = this.taxAmount;
    data['TaxAmt'] = this.taxAmt;
    data['NetAmount'] = this.netAmount;
    data['NetAmt'] = this.netAmt;
    data['HeaderDiscAmt'] = this.headerDiscAmt;
    data['HeaderDiscAmount'] = this.headerDiscAmount;
    data['ProductName'] = this.productName;
    data['ApprovalStatus'] = this.approvalStatus;
    data['ProductSpecification'] = this.productSpecification;
    data['DeliveryTime'] = this.deliveryTime;
    data['TaxType'] = this.taxType;
    data['LocationId'] = this.locationId;
    data['LocationName'] = this.locationName;
    return data;
  }
}