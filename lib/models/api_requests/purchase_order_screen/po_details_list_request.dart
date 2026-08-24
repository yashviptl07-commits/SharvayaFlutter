class PurchaseOrderDetailsListRequest {
  String OrderNo;
  String CompanyId;

  PurchaseOrderDetailsListRequest({
    this.OrderNo,
    this.CompanyId,
  });

  PurchaseOrderDetailsListRequest.fromJson(Map<String, dynamic> json) {
    OrderNo = json['OrderNo'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OrderNo'] = this.OrderNo;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
