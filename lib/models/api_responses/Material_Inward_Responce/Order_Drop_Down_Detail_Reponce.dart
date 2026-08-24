class OrderDropDownDetailResponce {
  List<OrderDropDownDetailResponceDetails> details;
  int totalCount;

  OrderDropDownDetailResponce({this.details, this.totalCount});

  OrderDropDownDetailResponce.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new OrderDropDownDetailResponceDetails.fromJson(v));
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

class OrderDropDownDetailResponceDetails {
  int productID;
  int taxType;
  String productName;
  String ordProductID;
  String productNameLong;
  double orderQty;
  double inwardQty;
  double unitRate;
  String unit;
  double discountPercent;
  bool serialNoFlag;
  double discountAmt;
  double netRate;
  double amount;
  double cGSTPer;
  double sGSTPer;
  double iGSTPer;
  double taxRate;
  double cGSTAmt;
  double sGSTAmt;
  double iGSTAmt;
  double taxAmount;
  double netAmount;
  String orderNo;
  String orderDate;
  int pkID;
  String unitSize;
  int customerID;
  String indentNo;
  double sampleQuantity;
  double quantity;
  String displayProductName;
  bool isChecked;

  OrderDropDownDetailResponceDetails(
      {this.productID,
      this.taxType,
      this.productName,
      this.ordProductID,
      this.productNameLong,
      this.orderQty,
      this.inwardQty,
      this.unitRate,
      this.unit,
      this.discountPercent,
      this.serialNoFlag,
      this.discountAmt,
      this.netRate,
      this.amount,
      this.cGSTPer,
      this.sGSTPer,
      this.iGSTPer,
      this.taxRate,
      this.cGSTAmt,
      this.sGSTAmt,
      this.iGSTAmt,
      this.taxAmount,
      this.netAmount,
      this.orderNo,
      this.orderDate,
      this.pkID,
      this.unitSize,
      this.customerID,
      this.indentNo,
      this.sampleQuantity,
      this.quantity,
      this.displayProductName,
      this.isChecked
      });

  OrderDropDownDetailResponceDetails.fromJson(Map<String, dynamic> json) {
    productID = json['ProductID'];
    taxType = json['TaxType'];
    productName = json['ProductName'];
    ordProductID = json['OrdProductID'];
    productNameLong = json['ProductNameLong'];
    orderQty = json['OrderQty'];
    inwardQty = json['InwardQty'];
    unitRate = json['UnitRate'];
    unit = json['Unit'];
    discountPercent = json['DiscountPercent'];
    serialNoFlag = json['SerialNoFlag'];
    discountAmt = json['DiscountAmt'];
    netRate = json['NetRate'];
    amount = json['Amount'];
    cGSTPer = json['CGSTPer'];
    sGSTPer = json['SGSTPer'];
    iGSTPer = json['IGSTPer'];
    taxRate = json['TaxRate'];
    cGSTAmt = json['CGSTAmt'];
    sGSTAmt = json['SGSTAmt'];
    iGSTAmt = json['IGSTAmt'];
    taxAmount = json['TaxAmount'];
    netAmount = json['NetAmount'];
    orderNo = json['OrderNo'];
    orderDate = json['OrderDate'];
    pkID = json['pkID'];
    unitSize = json['UnitSize'];
    customerID = json['CustomerID'];
    indentNo = json['IndentNo'];
    sampleQuantity = json['SampleQuantity'];
    quantity = json['Quantity'];
    displayProductName = json['DisplayProductName'];
    isChecked = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ProductID'] = this.productID;
    data['TaxType'] = this.taxType;
    data['ProductName'] = this.productName;
    data['OrdProductID'] = this.ordProductID;
    data['ProductNameLong'] = this.productNameLong;
    data['OrderQty'] = this.orderQty;
    data['InwardQty'] = this.inwardQty;
    data['UnitRate'] = this.unitRate;
    data['Unit'] = this.unit;
    data['DiscountPercent'] = this.discountPercent;
    data['SerialNoFlag'] = this.serialNoFlag;
    data['DiscountAmt'] = this.discountAmt;
    data['NetRate'] = this.netRate;
    data['Amount'] = this.amount;
    data['CGSTPer'] = this.cGSTPer;
    data['SGSTPer'] = this.sGSTPer;
    data['IGSTPer'] = this.iGSTPer;
    data['TaxRate'] = this.taxRate;
    data['CGSTAmt'] = this.cGSTAmt;
    data['SGSTAmt'] = this.sGSTAmt;
    data['IGSTAmt'] = this.iGSTAmt;
    data['TaxAmount'] = this.taxAmount;
    data['NetAmount'] = this.netAmount;
    data['OrderNo'] = this.orderNo;
    data['OrderDate'] = this.orderDate;
    data['pkID'] = this.pkID;
    data['UnitSize'] = this.unitSize;
    data['CustomerID'] = this.customerID;
    data['IndentNo'] = this.indentNo;
    data['SampleQuantity'] = this.sampleQuantity;
    data['Quantity'] = this.quantity;
    data['DisplayProductName'] = this.displayProductName;
    return data;
  }
}
