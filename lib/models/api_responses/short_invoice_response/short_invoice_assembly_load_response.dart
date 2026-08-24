class ShortInvoiceAssemblyLoadResponse {
  List<ShortInvoiceAssemblyLoadResponseDetails> details;
  int totalCount;

  ShortInvoiceAssemblyLoadResponse({this.details, this.totalCount});

  ShortInvoiceAssemblyLoadResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new ShortInvoiceAssemblyLoadResponseDetails.fromJson(v));
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

class ShortInvoiceAssemblyLoadResponseDetails {
  int rowNum;
  int pkID;
  int finishProductID;
  String finishProductName;
  String finishProductNameLong;
  String productNameLong;
  int productID;
  String productName;
  double quantity;
  String unit;
  String productAlias;
  double unitPrice;
  double taxRate;
  double addTaxPer;
  String productSpecification;
  int productGroupID;
  String productGroupName;
  String productImage;
  int brandID;
  String brandName;
  int taxType;
  bool activeFlag;
  String activeFlagDesc;
  double closingSTK;

  ShortInvoiceAssemblyLoadResponseDetails(
      {this.rowNum,
      this.pkID,
      this.finishProductID,
      this.finishProductName,
      this.finishProductNameLong,
      this.productNameLong,
      this.productID,
      this.productName,
      this.quantity,
      this.unit,
      this.productAlias,
      this.unitPrice,
      this.taxRate,
      this.addTaxPer,
      this.productSpecification,
      this.productGroupID,
      this.productGroupName,
      this.productImage,
      this.brandID,
      this.brandName,
      this.taxType,
      this.activeFlag,
      this.activeFlagDesc,
      this.closingSTK});

  ShortInvoiceAssemblyLoadResponseDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'];
    pkID = json['pkID'];
    finishProductID = json['FinishProductID'];
    finishProductName = json['FinishProductName'];
    finishProductNameLong = json['FinishProductNameLong'];
    productNameLong = json['ProductNameLong'];
    productID = json['ProductID'];
    productName = json['ProductName'];
    quantity = json['Quantity'];
    unit = json['Unit'];
    productAlias = json['ProductAlias'];
    unitPrice = json['UnitPrice'];
    taxRate = json['TaxRate'];
    addTaxPer = json['AddTaxPer'];
    productSpecification = json['ProductSpecification'];
    productGroupID = json['ProductGroupID'];
    productGroupName = json['ProductGroupName'];
    productImage = json['ProductImage'];
    brandID = json['BrandID'];
    brandName = json['BrandName'];
    taxType = json['TaxType'];
    activeFlag = json['ActiveFlag'];
    activeFlagDesc = json['ActiveFlagDesc'];
    closingSTK = json['ClosingSTK'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['FinishProductID'] = this.finishProductID;
    data['FinishProductName'] = this.finishProductName;
    data['FinishProductNameLong'] = this.finishProductNameLong;
    data['ProductNameLong'] = this.productNameLong;
    data['ProductID'] = this.productID;
    data['ProductName'] = this.productName;
    data['Quantity'] = this.quantity;
    data['Unit'] = this.unit;
    data['ProductAlias'] = this.productAlias;
    data['UnitPrice'] = this.unitPrice;
    data['TaxRate'] = this.taxRate;
    data['AddTaxPer'] = this.addTaxPer;
    data['ProductSpecification'] = this.productSpecification;
    data['ProductGroupID'] = this.productGroupID;
    data['ProductGroupName'] = this.productGroupName;
    data['ProductImage'] = this.productImage;
    data['BrandID'] = this.brandID;
    data['BrandName'] = this.brandName;
    data['TaxType'] = this.taxType;
    data['ActiveFlag'] = this.activeFlag;
    data['ActiveFlagDesc'] = this.activeFlagDesc;
    data['ClosingSTK'] = this.closingSTK;
    return data;
  }
}
