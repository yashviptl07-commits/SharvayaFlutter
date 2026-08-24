class MultiNoToProductDetailsFromSalesOrderResponse {
  List<MultiNoToProductDetailsFromSalesOrderResponseDetails> details;
  int totalCount;

  MultiNoToProductDetailsFromSalesOrderResponse(
      {this.details, this.totalCount});

  MultiNoToProductDetailsFromSalesOrderResponse.fromJson(
      Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(
            new MultiNoToProductDetailsFromSalesOrderResponseDetails.fromJson(
                v));
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

class MultiNoToProductDetailsFromSalesOrderResponseDetails {
  String productName;
  int pkID;
  String orderNo;
  int productID;
  double quantity;
  String unit;
  double unitRate;
  double discountPercent;
  double netRate;
  double amount;
  double sGSTPer;
  double sGSTAmt;
  double cGSTPer;
  double cGSTAmt;
  double iGSTPer;
  double iGSTAmt;
  int taxType;
  double taxRate;
  double taxAmount;
  double netAmount;
  String createdBy;
  String createdDate;
  String updatedBy;
  String updatedDate;
  double discountAmt;
  double headerDiscAmt;
  String productSpecification;
  String deliveryDate;
  double unitQty;
  String docRefNo;
  String fromSrNo;
  String toSrNo;

  MultiNoToProductDetailsFromSalesOrderResponseDetails(
      {this.productName,
      this.pkID,
      this.orderNo,
      this.productID,
      this.quantity,
      this.unit,
      this.unitRate,
      this.discountPercent,
      this.netRate,
      this.amount,
      this.sGSTPer,
      this.sGSTAmt,
      this.cGSTPer,
      this.cGSTAmt,
      this.iGSTPer,
      this.iGSTAmt,
      this.taxType,
      this.taxRate,
      this.taxAmount,
      this.netAmount,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.discountAmt,
      this.headerDiscAmt,
      this.productSpecification,
      this.deliveryDate,
      this.unitQty,
      this.docRefNo,
      this.fromSrNo,
      this.toSrNo});

  MultiNoToProductDetailsFromSalesOrderResponseDetails.fromJson(
      Map<String, dynamic> json) {
    productName = json['ProductName'];
    pkID = json['pkID'];
    orderNo = json['OrderNo'];
    productID = json['ProductID'];
    quantity = json['Quantity'];
    unit = json['Unit'];
    unitRate = json['UnitRate'];
    discountPercent = json['DiscountPercent'];
    netRate = json['NetRate'];
    amount = json['Amount'];
    sGSTPer = json['SGSTPer'];
    sGSTAmt = json['SGSTAmt'];
    cGSTPer = json['CGSTPer'];
    cGSTAmt = json['CGSTAmt'];
    iGSTPer = json['IGSTPer'];
    iGSTAmt = json['IGSTAmt'];
    taxType = json['TaxType'];
    taxRate = json['TaxRate'];
    taxAmount = json['TaxAmount'];
    netAmount = json['NetAmount'];
    createdBy = json['CreatedBy'];
    createdDate = json['CreatedDate'];
    updatedBy = json['UpdatedBy'];
    updatedDate = json['UpdatedDate'];
    discountAmt = json['DiscountAmt'];
    headerDiscAmt = json['HeaderDiscAmt'];
    productSpecification = json['ProductSpecification'];
    deliveryDate = json['DeliveryDate'];
    unitQty = json['UnitQty'];
    docRefNo = json['DocRefNo'];
    fromSrNo = json['FromSrNo'];
    toSrNo = json['ToSrNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ProductName'] = this.productName;
    data['pkID'] = this.pkID;
    data['OrderNo'] = this.orderNo;
    data['ProductID'] = this.productID;
    data['Quantity'] = this.quantity;
    data['Unit'] = this.unit;
    data['UnitRate'] = this.unitRate;
    data['DiscountPercent'] = this.discountPercent;
    data['NetRate'] = this.netRate;
    data['Amount'] = this.amount;
    data['SGSTPer'] = this.sGSTPer;
    data['SGSTAmt'] = this.sGSTAmt;
    data['CGSTPer'] = this.cGSTPer;
    data['CGSTAmt'] = this.cGSTAmt;
    data['IGSTPer'] = this.iGSTPer;
    data['IGSTAmt'] = this.iGSTAmt;
    data['TaxType'] = this.taxType;
    data['TaxRate'] = this.taxRate;
    data['TaxAmount'] = this.taxAmount;
    data['NetAmount'] = this.netAmount;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    data['UpdatedBy'] = this.updatedBy;
    data['UpdatedDate'] = this.updatedDate;
    data['DiscountAmt'] = this.discountAmt;
    data['HeaderDiscAmt'] = this.headerDiscAmt;
    data['ProductSpecification'] = this.productSpecification;
    data['DeliveryDate'] = this.deliveryDate;
    data['UnitQty'] = this.unitQty;
    data['DocRefNo'] = this.docRefNo;
    data['FromSrNo'] = this.fromSrNo;
    data['ToSrNo'] = this.toSrNo;
    return data;
  }
}
