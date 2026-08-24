class ShortInvoiceDetailsListResponse {
  List<ShortInvoiceDetailsListResponseDetails> details;
  int totalCount;

  ShortInvoiceDetailsListResponse({this.details, this.totalCount});

  ShortInvoiceDetailsListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new ShortInvoiceDetailsListResponseDetails.fromJson(v));
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

class ShortInvoiceDetailsListResponseDetails {
  String productName;
  int pkID;
  String invoiceNo;
  String docRefNo;
  int productID;
  int taxType;
  double rate;
  String unit;
  double qty;
  double unitQty;
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
  String forOrderNo;
  String createdBy;
  String createdDate;
  String updatedBy;
  String updatedDate;
  int locationID;
  String productSpecification;
  String batch;
  String noOfBags;
  String boxNo;
  double netWT;
  double grossWT;
  String lineSealNo;
  String eSealNo;
  String containerNo;
  String lorryNo;
  double pendingQty;

  ShortInvoiceDetailsListResponseDetails(
      {this.productName,
      this.pkID,
      this.invoiceNo,
      this.docRefNo,
      this.productID,
      this.taxType,
      this.rate,
      this.unit,
      this.qty,
      this.unitQty,
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
      this.forOrderNo,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.locationID,
      this.productSpecification,
      this.batch,
      this.noOfBags,
      this.boxNo,
      this.netWT,
      this.grossWT,
      this.lineSealNo,
      this.eSealNo,
      this.containerNo,
      this.lorryNo,
      this.pendingQty});

  ShortInvoiceDetailsListResponseDetails.fromJson(Map<String, dynamic> json) {
    productName = json['ProductName'];
    pkID = json['pkID'];
    invoiceNo = json['InvoiceNo'];
    docRefNo = json['DocRefNo'];
    productID = json['ProductID'];
    taxType = json['TaxType'];
    rate = json['Rate'];
    unit = json['Unit'];
    qty = json['Qty'];
    unitQty = json['UnitQty'];
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
    forOrderNo = json['ForOrderNo'];
    createdBy = json['CreatedBy'];
    createdDate = json['CreatedDate'];
    updatedBy = json['UpdatedBy'];
    updatedDate = json['UpdatedDate'];
    locationID = json['LocationID'];
    productSpecification = json['ProductSpecification'];
    batch = json['Batch'];
    noOfBags = json['NoOfBags'];
    boxNo = json['BoxNo'];
    netWT = json['NetWT'];
    grossWT = json['GrossWT'];
    lineSealNo = json['LineSealNo'];
    eSealNo = json['ESealNo'];
    containerNo = json['ContainerNo'];
    lorryNo = json['LorryNo'];
    pendingQty = json['PendingQty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ProductName'] = this.productName;
    data['pkID'] = this.pkID;
    data['InvoiceNo'] = this.invoiceNo;
    data['DocRefNo'] = this.docRefNo;
    data['ProductID'] = this.productID;
    data['TaxType'] = this.taxType;
    data['Rate'] = this.rate;
    data['Unit'] = this.unit;
    data['Qty'] = this.qty;
    data['UnitQty'] = this.unitQty;
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
    data['ForOrderNo'] = this.forOrderNo;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    data['UpdatedBy'] = this.updatedBy;
    data['UpdatedDate'] = this.updatedDate;
    data['LocationID'] = this.locationID;
    data['ProductSpecification'] = this.productSpecification;
    data['Batch'] = this.batch;
    data['NoOfBags'] = this.noOfBags;
    data['BoxNo'] = this.boxNo;
    data['NetWT'] = this.netWT;
    data['GrossWT'] = this.grossWT;
    data['LineSealNo'] = this.lineSealNo;
    data['ESealNo'] = this.eSealNo;
    data['ContainerNo'] = this.containerNo;
    data['LorryNo'] = this.lorryNo;
    data['PendingQty'] = this.pendingQty;
    return data;
  }
}
