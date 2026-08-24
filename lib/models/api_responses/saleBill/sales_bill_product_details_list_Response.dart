class SalesBillProductDetailsListResponse {
  List<SalesBillProductDetailsListResponseDetails> details;
  int totalCount;

  SalesBillProductDetailsListResponse({this.details, this.totalCount});

  SalesBillProductDetailsListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new SalesBillProductDetailsListResponseDetails.fromJson(v));
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

class SalesBillProductDetailsListResponseDetails {
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
  double taxRate;
  double taxAmount;
  double addTaxPer;
  double addTaxAmt;
  double netAmt;
  String createdBy;
  String createdDate;
  String updatedBy;
  String updatedDate;
  String forOrderNo;
  double unitQty;
  String productSpecification;
  int locationID;
  String docRefNo;
  double grossWT;
  double netWT;
  String boxNo;
  int lorryNo;
  int lineSealNo;
  int eSealNo;
  int containerNo;
  int noOfBags;
  int batch;

  SalesBillProductDetailsListResponseDetails(
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
      this.taxRate,
      this.taxAmount,
      this.addTaxPer,
      this.addTaxAmt,
      this.netAmt,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate,
      this.forOrderNo,
      this.unitQty,
      this.productSpecification,
      this.locationID,
      this.docRefNo,
      this.grossWT,
      this.netWT,
      this.boxNo,
      this.lorryNo,
      this.lineSealNo,
      this.eSealNo,
      this.containerNo,
      this.noOfBags,
      this.batch});

  SalesBillProductDetailsListResponseDetails.fromJson(
      Map<String, dynamic> json) {
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
    taxRate = json['TaxRate'];
    taxAmount = json['TaxAmount'];
    addTaxPer = json['AddTaxPer'];
    addTaxAmt = json['AddTaxAmt'];
    netAmt = json['NetAmt'];
    createdBy = json['CreatedBy'];
    createdDate = json['CreatedDate'];
    updatedBy = json['UpdatedBy'];
    updatedDate = json['UpdatedDate'];
    forOrderNo = json['ForOrderNo'];
    unitQty = json['UnitQty'];
    productSpecification = json['ProductSpecification'];
    locationID = json['LocationID'];
    docRefNo = json['DocRefNo'];
    grossWT = json['GrossWT'];
    netWT = json['NetWT'];
    boxNo = json['BoxNo'];
    lorryNo = json['LorryNo'];
    lineSealNo = json['LineSealNo'];
    eSealNo = json['ESealNo'];
    containerNo = json['ContainerNo'];
    noOfBags = json['NoOfBags'];
    batch = json['Batch'];
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
    data['TaxRate'] = this.taxRate;
    data['TaxAmount'] = this.taxAmount;
    data['AddTaxPer'] = this.addTaxPer;
    data['AddTaxAmt'] = this.addTaxAmt;
    data['NetAmt'] = this.netAmt;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    data['UpdatedBy'] = this.updatedBy;
    data['UpdatedDate'] = this.updatedDate;
    data['ForOrderNo'] = this.forOrderNo;
    data['UnitQty'] = this.unitQty;
    data['ProductSpecification'] = this.productSpecification;
    data['LocationID'] = this.locationID;
    data['DocRefNo'] = this.docRefNo;
    data['GrossWT'] = this.grossWT;
    data['NetWT'] = this.netWT;
    data['BoxNo'] = this.boxNo;
    data['LorryNo'] = this.lorryNo;
    data['LineSealNo'] = this.lineSealNo;
    data['ESealNo'] = this.eSealNo;
    data['ContainerNo'] = this.containerNo;
    data['NoOfBags'] = this.noOfBags;
    data['Batch'] = this.batch;
    return data;
  }
}
