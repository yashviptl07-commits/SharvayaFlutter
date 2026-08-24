class MultiNoToProductDetailsFromInquiryResponse {
  List<MultiNoToProductDetailsFromInquiryResponseDetails> details;
  int totalCount;

  MultiNoToProductDetailsFromInquiryResponse({this.details, this.totalCount});

  MultiNoToProductDetailsFromInquiryResponse.fromJson(
      Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(
            new MultiNoToProductDetailsFromInquiryResponseDetails.fromJson(v));
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

class MultiNoToProductDetailsFromInquiryResponseDetails {
  int pkID;
  String inquiryNo;
  int productID;
  double unitPrice;
  double taxRate;
  double quantity;
  String createdBy;
  String createdDate;
  String unit;
  String thickness;
  double factor;
  double area;
  String remarks;
  String productName;

  MultiNoToProductDetailsFromInquiryResponseDetails(
      {this.pkID,
      this.inquiryNo,
      this.productID,
      this.unitPrice,
      this.taxRate,
      this.quantity,
      this.createdBy,
      this.createdDate,
      this.unit,
      this.thickness,
      this.factor,
      this.area,
      this.remarks,
      this.productName});

  MultiNoToProductDetailsFromInquiryResponseDetails.fromJson(
      Map<String, dynamic> json) {
    pkID = json['pkID'] == null ? 0 : json['pkID'];
    inquiryNo = json['InquiryNo'] == null ? "" : json['InquiryNo'];
    productID = json['ProductID'] == null ? 0 : json['ProductID'];
    unitPrice = json['UnitPrice'] == null ? 0.00 : json['UnitPrice'];
    taxRate = json['TaxRate'] == null ? 0.00 : json['TaxRate'];
    quantity = json['Quantity'] == null ? 0.00 : json['Quantity'];
    createdBy = json['CreatedBy'] == null ? "" : json['CreatedBy'];
    createdDate = json['CreatedDate'] == null ? "" : json['CreatedDate'];
    unit = json['Unit'] == null ? "" : json['Unit'];
    thickness = json['Thickness'] == null ? "" : json['Thickness'];
    factor = json['Factor'] == null ? 0.00 : json['Factor'];
    area = json['Area'] == null ? 0.00 : json['Area'];
    remarks = json['Remarks'] == null ? "" : json['Remarks'];
    productName = json['ProductName'] == null ? "" : json['ProductName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['InquiryNo'] = this.inquiryNo;
    data['ProductID'] = this.productID;
    data['UnitPrice'] = this.unitPrice;
    data['TaxRate'] = this.taxRate;
    data['Quantity'] = this.quantity;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    data['Unit'] = this.unit;
    data['Thickness'] = this.thickness;
    data['Factor'] = this.factor;
    data['Area'] = this.area;
    data['Remarks'] = this.remarks;
    data['ProductName'] = this.productName;
    return data;
  }
}
