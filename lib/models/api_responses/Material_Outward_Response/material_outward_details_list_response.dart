class MaterialOutwardDetailsListResponse {
  List<MaterialOutwardDetailsListResponseDetails> details;
  int totalCount;

  MaterialOutwardDetailsListResponse({this.details, this.totalCount});

  MaterialOutwardDetailsListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new MaterialOutwardDetailsListResponseDetails.fromJson(v));
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

class MaterialOutwardDetailsListResponseDetails {
  int pkID;
  String outwardNo;
  int productID;
  String productName;
  double quantity;
  String productSpecification;
  double quantityWeight;
  String serialNo;
  String boxNo;
  String unit;
  double unitRate;
  int discountPercent;
  double netRate;
  double amount;
  double taxRate;
  double taxAmount;
  double netAmount;
  String createdBy;
  String createdDate;
  String updatedBy;
  String updatedDate;
  String orderNo;
  int locationID;
  double iGSTPer;
  double discountAmt;
  double sGSTAmt;
  double cGSTAmt;
  double iGSTAmt;
  double sampleQuantity;
  String dateCode;
  int taxType;
  double sGSTPer;
  double cGSTPer;

  MaterialOutwardDetailsListResponseDetails(
      {this.pkID,
      this.outwardNo,
      this.productID,
      this.productName,
      this.quantity,
      this.productSpecification,
      this.quantityWeight,
      this.serialNo,
      this.boxNo,
      this.unit,
      this.unitRate,
      this.discountPercent,
      this.netRate,
      this.amount,
      this.taxRate,
      this.taxAmount,
      this.netAmount,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.orderNo,
      this.locationID,
      this.iGSTPer,
      this.discountAmt,
      this.sGSTAmt,
      this.cGSTAmt,
      this.iGSTAmt,
      this.sampleQuantity,
      this.dateCode,
      this.taxType,
      this.sGSTPer,
      this.cGSTPer});

  MaterialOutwardDetailsListResponseDetails.fromJson(
      Map<String, dynamic> json) {
    pkID = json['pkID'] == null ? 0 : json['RowNum'];
    outwardNo = json['OutwardNo'] == null ? "" : json['OutwardNo'];
    productID = json['ProductID'] == null ? 0 : json['ProductID'];
    productName = json['ProductName'] == null ? "" : json['ProductName'];
    quantity = json['Quantity'] == null ? 0.00 : json['Quantity'];
    productSpecification = json['ProductSpecification'] == null
        ? ""
        : json['ProductSpecification'];
    quantityWeight =
        json['QuantityWeight'] == null ? 0.00 : json['QuantityWeight'];
    serialNo = json['SerialNo'] == null ? "" : json['SerialNo'];
    boxNo = json['BoxNo'] == null ? "" : json['BoxNo'];
    unit = json['Unit'] == null ? "" : json['Unit'];
    unitRate = json['UnitRate'] == null ? 0.00 : json['UnitRate'];
    discountPercent =
        json['DiscountPercent'] == null ? 0 : json['DiscountPercent'];
    netRate = json['NetRate'] == null ? 0.00 : json['NetRate'];
    amount = json['Amount'] == null ? 0.00 : json['Amount'];
    taxRate = json['TaxRate'] == null ? 0.00 : json['TaxRate'];
    taxAmount = json['TaxAmount'] == null ? 0.00 : json['TaxAmount'];
    netAmount = json['NetAmount'] == null ? 0.00 : json['NetAmount'];
    createdBy = json['CreatedBy'] == null ? "" : json['CreatedBy'];
    createdDate = json['CreatedDate'] == null ? "" : json['CreatedDate'];
    updatedBy = json['UpdatedBy'] == null ? "" : json['UpdatedBy'];
    updatedDate = json['UpdatedDate'] == null ? "" : json['UpdatedDate'];
    orderNo = json['OrderNo'] == null ? "" : json['OrderNo'];
    locationID = json['LocationID'] == null ? 0 : json['LocationID'];
    iGSTPer = json['IGSTPer'] == null ? 0.00 : json['IGSTPer'];
    discountAmt = json['DiscountAmt'] == null ? 0.00 : json['DiscountAmt'];
    sGSTAmt = json['SGSTAmt'] == null ? 0.00 : json['SGSTAmt'];
    cGSTAmt = json['CGSTAmt'] == null ? 0.00 : json['CGSTAmt'];
    iGSTAmt = json['IGSTAmt'] == null ? 0.00 : json['IGSTAmt'];
    sampleQuantity =
        json['SampleQuantity'] == null ? 0.00 : json['SampleQuantity'];
    dateCode = json['DateCode'] == null ? "" : json['DateCode'];
    taxType = json['TaxType'] == null ? 0 : json['TaxType'];
    sGSTPer = json['SGSTPer'] == null ? 0.00 : json['SGSTPer'];
    cGSTPer = json['CGSTPer'] == null ? 0.00 : json['CGSTPer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['OutwardNo'] = this.outwardNo;
    data['ProductID'] = this.productID;
    data['ProductName'] = this.productName;
    data['Quantity'] = this.quantity;
    data['ProductSpecification'] = this.productSpecification;
    data['QuantityWeight'] = this.quantityWeight;
    data['SerialNo'] = this.serialNo;
    data['BoxNo'] = this.boxNo;
    data['Unit'] = this.unit;
    data['UnitRate'] = this.unitRate;
    data['DiscountPercent'] = this.discountPercent;
    data['NetRate'] = this.netRate;
    data['Amount'] = this.amount;
    data['TaxRate'] = this.taxRate;
    data['TaxAmount'] = this.taxAmount;
    data['NetAmount'] = this.netAmount;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    data['UpdatedBy'] = this.updatedBy;
    data['UpdatedDate'] = this.updatedDate;
    data['OrderNo'] = this.orderNo;
    data['LocationID'] = this.locationID;
    data['IGSTPer'] = this.iGSTPer;
    data['DiscountAmt'] = this.discountAmt;
    data['SGSTAmt'] = this.sGSTAmt;
    data['CGSTAmt'] = this.cGSTAmt;
    data['IGSTAmt'] = this.iGSTAmt;
    data['SampleQuantity'] = this.sampleQuantity;
    data['DateCode'] = this.dateCode;
    data['TaxType'] = this.taxType;
    data['SGSTPer'] = this.sGSTPer;
    data['CGSTPer'] = this.cGSTPer;
    return data;
  }
}
