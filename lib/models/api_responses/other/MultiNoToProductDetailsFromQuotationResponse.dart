class MultiNoToProductDetailsFromQuotationResponse {
  List<MultiNoToProductDetailsFromQuotationResponseDetails> details;
  int totalCount;

  MultiNoToProductDetailsFromQuotationResponse({this.details, this.totalCount});

  MultiNoToProductDetailsFromQuotationResponse.fromJson(
      Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(
            new MultiNoToProductDetailsFromQuotationResponseDetails.fromJson(v));
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

class MultiNoToProductDetailsFromQuotationResponseDetails {
  int pkID;
  String quotationNo;
  int productID;
  double quantity;
  String unit;
  double unitRate;
  double discountPercent;
  double discountAmt;
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
  int bundleId;
  String createdBy;
  String createdDate;
  String updatedBy;
  String updatedDate;
  double headerDiscAmt;
  String productSpecification;
  double unitQty;
  bool subsidyApplicable;
  String docRefNo;
  int finishProductID;
  String flag;
  double hARate;
  double hAPer;
  double hAAmt;
  double marginPer;
  double marginAmt;
  double aftMarginAmt;
  int gradeID;
  int sizeID;
  int finishID;
  int thicknessID;
  int designID;
  int oldRevpkID;
  double additionalDiscAmt;
  double basicPrice;
  double unitHeight;
  double unitWidth;
  String othRef1;
  String othRef2;
  String othRef3;
  double profitAmount;
  String productName;

  MultiNoToProductDetailsFromQuotationResponseDetails(
      {this.pkID,
        this.quotationNo,
        this.productID,
        this.quantity,
        this.unit,
        this.unitRate,
        this.discountPercent,
        this.discountAmt,
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
        this.bundleId,
        this.createdBy,
        this.createdDate,
        this.updatedBy,
        this.updatedDate,
        this.headerDiscAmt,
        this.productSpecification,
        this.unitQty,
        this.subsidyApplicable,
        this.docRefNo,
        this.finishProductID,
        this.flag,
        this.hARate,
        this.hAPer,
        this.hAAmt,
        this.marginPer,
        this.marginAmt,
        this.aftMarginAmt,
        this.gradeID,
        this.sizeID,
        this.finishID,
        this.thicknessID,
        this.designID,
        this.oldRevpkID,
        this.additionalDiscAmt,
        this.basicPrice,
        this.unitHeight,
        this.unitWidth,
        this.othRef1,
        this.othRef2,
        this.othRef3,
        this.profitAmount,
        this.productName});

  MultiNoToProductDetailsFromQuotationResponseDetails.fromJson(
      Map<String, dynamic> json) {
    pkID = json['pkID'];
    quotationNo = json['QuotationNo'];
    productID = json['ProductID'];
    quantity = json['Quantity'];
    unit = json['Unit'];
    unitRate = json['UnitRate'];
    discountPercent = json['DiscountPercent'];
    discountAmt = json['DiscountAmt'];
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
    bundleId = json['BundleId'];
    createdBy = json['CreatedBy'];
    createdDate = json['CreatedDate'];
    updatedBy = json['UpdatedBy'];
    updatedDate = json['UpdatedDate'];
    headerDiscAmt = json['HeaderDiscAmt'];
    productSpecification = json['ProductSpecification'];
    unitQty = json['UnitQty'];
    subsidyApplicable = json['SubsidyApplicable'];
    docRefNo = json['DocRefNo'];
    finishProductID = json['FinishProductID'];
    flag = json['Flag'];
    hARate = json['HARate'];
    hAPer = json['HAPer'];
    hAAmt = json['HAAmt'];
    marginPer = json['MarginPer'];
    marginAmt = json['MarginAmt'];
    aftMarginAmt = json['AftMarginAmt'];
    gradeID = json['GradeID'];
    sizeID = json['SizeID'];
    finishID = json['FinishID'];
    thicknessID = json['ThicknessID'];
    designID = json['DesignID'];
    oldRevpkID = json['OldRevpkID'];
    additionalDiscAmt = json['AdditionalDiscAmt'];
    basicPrice = json['BasicPrice'];
    unitHeight = json['UnitHeight'];
    unitWidth = json['UnitWidth'];
    othRef1 = json['OthRef1'];
    othRef2 = json['OthRef2'];
    othRef3 = json['OthRef3'];
    profitAmount = json['ProfitAmount'];
    productName = json['ProductName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['QuotationNo'] = this.quotationNo;
    data['ProductID'] = this.productID;
    data['Quantity'] = this.quantity;
    data['Unit'] = this.unit;
    data['UnitRate'] = this.unitRate;
    data['DiscountPercent'] = this.discountPercent;
    data['DiscountAmt'] = this.discountAmt;
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
    data['BundleId'] = this.bundleId;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    data['UpdatedBy'] = this.updatedBy;
    data['UpdatedDate'] = this.updatedDate;
    data['HeaderDiscAmt'] = this.headerDiscAmt;
    data['ProductSpecification'] = this.productSpecification;
    data['UnitQty'] = this.unitQty;
    data['SubsidyApplicable'] = this.subsidyApplicable;
    data['DocRefNo'] = this.docRefNo;
    data['FinishProductID'] = this.finishProductID;
    data['Flag'] = this.flag;
    data['HARate'] = this.hARate;
    data['HAPer'] = this.hAPer;
    data['HAAmt'] = this.hAAmt;
    data['MarginPer'] = this.marginPer;
    data['MarginAmt'] = this.marginAmt;
    data['AftMarginAmt'] = this.aftMarginAmt;
    data['GradeID'] = this.gradeID;
    data['SizeID'] = this.sizeID;
    data['FinishID'] = this.finishID;
    data['ThicknessID'] = this.thicknessID;
    data['DesignID'] = this.designID;
    data['OldRevpkID'] = this.oldRevpkID;
    data['AdditionalDiscAmt'] = this.additionalDiscAmt;
    data['BasicPrice'] = this.basicPrice;
    data['UnitHeight'] = this.unitHeight;
    data['UnitWidth'] = this.unitWidth;
    data['OthRef1'] = this.othRef1;
    data['OthRef2'] = this.othRef2;
    data['OthRef3'] = this.othRef3;
    data['ProfitAmount'] = this.profitAmount;
    data['ProductName'] = this.productName;
    return data;
  }
}
