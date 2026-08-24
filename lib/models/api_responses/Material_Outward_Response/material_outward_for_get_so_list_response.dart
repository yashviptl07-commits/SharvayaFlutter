class MaterialOutwardPendingSalesOrderListResponse {
  List<MaterialOutwardPendingSalesOrderListResponseDetails> details;
  int totalCount;

  MaterialOutwardPendingSalesOrderListResponse({this.details, this.totalCount});

  MaterialOutwardPendingSalesOrderListResponse.fromJson(
      Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(
            new MaterialOutwardPendingSalesOrderListResponseDetails.fromJson(
                v));
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

class MaterialOutwardPendingSalesOrderListResponseDetails {
  String orderNo;

  MaterialOutwardPendingSalesOrderListResponseDetails({this.orderNo});

  MaterialOutwardPendingSalesOrderListResponseDetails.fromJson(
      Map<String, dynamic> json) {
    orderNo = json['OrderNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OrderNo'] = this.orderNo;
    return data;
  }
}
