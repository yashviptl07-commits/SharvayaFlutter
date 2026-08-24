class PurchaseBillDetailsListResponse {
  List<Details> details;
  int totalCount;

  PurchaseBillDetailsListResponse({this.details, this.totalCount});

  PurchaseBillDetailsListResponse.fromJson(Map<String, dynamic> json) {
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
  String productName;
  int pkID;
  String invoiceNo;
  int productID;
  int taxType;
  double rate;
  String unit;
  double qty;
  double discountPer;
  double discountAmt;
  double netRate;
  double headerDiscAmt;
  double amount;
  double sGSTPer;
  double sGSTAmt;
  double cGSTPer;
  double cGSTAmt;
  double iGSTPer;
  double iGSTAmt;
  double addTaxPer;
  double addTaxAmt;
  double netAmt;
  String orderNo;
  String createdBy;
  String createdDate;
  String updatedBy;
  String updatedDate;
  int locationID;
  String productSpecification;

  Details(
      {this.productName,
      this.pkID,
      this.invoiceNo,
      this.productID,
      this.taxType,
      this.rate,
      this.unit,
      this.qty,
      this.discountPer,
      this.discountAmt,
      this.netRate,
      this.headerDiscAmt,
      this.amount,
      this.sGSTPer,
      this.sGSTAmt,
      this.cGSTPer,
      this.cGSTAmt,
      this.iGSTPer,
      this.iGSTAmt,
      this.addTaxPer,
      this.addTaxAmt,
      this.netAmt,
      this.orderNo,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.locationID,
      this.productSpecification});

  Details.fromJson(Map<String, dynamic> json) {
    productName = json['ProductName'];
    pkID = json['pkID'];
    invoiceNo = json['InvoiceNo'];
    productID = json['ProductID'];
    taxType = json['TaxType'];
    rate = json['Rate'];
    unit = json['Unit'];
    qty = json['Qty'];
    discountPer = json['DiscountPer'];
    discountAmt = json['DiscountAmt'];
    netRate = json['NetRate'];
    headerDiscAmt = json['HeaderDiscAmt'];
    amount = json['Amount'];
    sGSTPer = json['SGSTPer'];
    sGSTAmt = json['SGSTAmt'];
    cGSTPer = json['CGSTPer'];
    cGSTAmt = json['CGSTAmt'];
    iGSTPer = json['IGSTPer'];
    iGSTAmt = json['IGSTAmt'];
    addTaxPer = json['AddTaxPer'];
    addTaxAmt = json['AddTaxAmt'];
    netAmt = json['NetAmt'];
    orderNo = json['OrderNo'];
    createdBy = json['CreatedBy'];
    createdDate = json['CreatedDate'];
    updatedBy = json['UpdatedBy'];
    updatedDate = json['UpdatedDate'];
    locationID = json['LocationID'];
    productSpecification = json['ProductSpecification'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ProductName'] = this.productName;
    data['pkID'] = this.pkID;
    data['InvoiceNo'] = this.invoiceNo;
    data['ProductID'] = this.productID;
    data['TaxType'] = this.taxType;
    data['Rate'] = this.rate;
    data['Unit'] = this.unit;
    data['Qty'] = this.qty;
    data['DiscountPer'] = this.discountPer;
    data['DiscountAmt'] = this.discountAmt;
    data['NetRate'] = this.netRate;
    data['HeaderDiscAmt'] = this.headerDiscAmt;
    data['Amount'] = this.amount;
    data['SGSTPer'] = this.sGSTPer;
    data['SGSTAmt'] = this.sGSTAmt;
    data['CGSTPer'] = this.cGSTPer;
    data['CGSTAmt'] = this.cGSTAmt;
    data['IGSTPer'] = this.iGSTPer;
    data['IGSTAmt'] = this.iGSTAmt;
    data['AddTaxPer'] = this.addTaxPer;
    data['AddTaxAmt'] = this.addTaxAmt;
    data['NetAmt'] = this.netAmt;
    data['OrderNo'] = this.orderNo;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    data['UpdatedBy'] = this.updatedBy;
    data['UpdatedDate'] = this.updatedDate;
    data['LocationID'] = this.locationID;
    data['ProductSpecification'] = this.productSpecification;
    return data;
  }
}
