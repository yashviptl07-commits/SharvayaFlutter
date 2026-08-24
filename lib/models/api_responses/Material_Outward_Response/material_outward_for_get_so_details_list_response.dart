class MaterialOutwardPendingSalesOrderDetailsListResponse {
  List<MaterialOutwardPendingSalesOrderDetailsListResponseDetails> details;
  int totalCount;

  MaterialOutwardPendingSalesOrderDetailsListResponse(
      {this.details, this.totalCount});

  MaterialOutwardPendingSalesOrderDetailsListResponse.fromJson(
      Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(
            new MaterialOutwardPendingSalesOrderDetailsListResponseDetails
                .fromJson(v));
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

class MaterialOutwardPendingSalesOrderDetailsListResponseDetails {
  int pkid;
  double sampleQuantity;
  double quantity;
  String displayProductName;
  String orderNo;

  MaterialOutwardPendingSalesOrderDetailsListResponseDetails(
      {this.pkid,
      this.sampleQuantity,
      this.quantity,
      this.displayProductName,
      this.orderNo});

  MaterialOutwardPendingSalesOrderDetailsListResponseDetails.fromJson(
      Map<String, dynamic> json) {
    pkid = json['pkid'];
    sampleQuantity = json['SampleQuantity'];
    quantity = json['Quantity'];
    displayProductName = json['DisplayProductName'];
    orderNo = json['OrderNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkid'] = this.pkid;
    data['SampleQuantity'] = this.sampleQuantity;
    data['Quantity'] = this.quantity;
    data['DisplayProductName'] = this.displayProductName;
    data['OrderNo'] = this.orderNo;
    return data;
  }
}
