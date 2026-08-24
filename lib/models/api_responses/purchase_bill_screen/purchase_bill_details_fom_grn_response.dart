class MultiNoToProductDetailsFromGRNResponse {
  List<MultiNoToProductDetailsFromGRNResponseDetails> details;
  int totalCount;

  MultiNoToProductDetailsFromGRNResponse({this.details, this.totalCount});

  MultiNoToProductDetailsFromGRNResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details
            .add(new MultiNoToProductDetailsFromGRNResponseDetails.fromJson(v));
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

class MultiNoToProductDetailsFromGRNResponseDetails {
  int pkID;
  String inwardNo;
  int taxType;
  int productID;
  String productName;
  String productSpecification;
  String dateCode;
  double quantity;
  String unit;
  double unitRate;
  double discountPercent;
  double discountAmt;
  double netRate;
  double amount;
  double taxRate;
  double taxAmount;
  double netAmount;
  double sGSTPer;
  double sGSTAmt;
  double headerDiscAmt;
  double cGSTPer;
  double cGSTAmt;
  double iGSTPer;
  double iGSTAmt;
  String orderNo;
  int locationID;
  double sampleQuantity;

  MultiNoToProductDetailsFromGRNResponseDetails({
    this.pkID,
    this.inwardNo,
    this.taxType,
    this.productID,
    this.productName,
    this.productSpecification,
    this.dateCode,
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
    this.locationID,
    this.sampleQuantity,
    this.headerDiscAmt,
  });

  MultiNoToProductDetailsFromGRNResponseDetails.fromJson(
      Map<String, dynamic> json) {
    pkID = json['pkID'];
    inwardNo = json['InwardNo'];
    taxType = json['TaxType'];
    productID = json['ProductID'];
    productName = json['ProductName'];
    productSpecification = json['ProductSpecification'];
    dateCode = json['DateCode'];
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
    headerDiscAmt = json['HeaderDiscAmt'];
    sGSTPer = json['SGSTPer'];
    sGSTAmt = json['SGSTAmt'];
    cGSTPer = json['CGSTPer'];
    cGSTAmt = json['CGSTAmt'];
    iGSTPer = json['IGSTPer'];
    iGSTAmt = json['IGSTAmt'];
    orderNo = json['OrderNo'];
    locationID = json['LocationID'];
    sampleQuantity = json['SampleQuantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['InwardNo'] = this.inwardNo;
    data['TaxType'] = this.taxType;
    data['ProductID'] = this.productID;
    data['ProductName'] = this.productName;
    data['ProductSpecification'] = this.productSpecification;
    data['DateCode'] = this.dateCode;
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
    data['LocationID'] = this.locationID;
    data['SampleQuantity'] = this.sampleQuantity;
    data['HeaderDiscAmt'] = this.headerDiscAmt;
    return data;
  }
}
