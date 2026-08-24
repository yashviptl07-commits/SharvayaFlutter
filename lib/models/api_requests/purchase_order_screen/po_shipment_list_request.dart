/*
pkID:0
InvoiceNo:RC-SHI-2526-0003
LoginUserID:admin
CompanyId:7313*/
class PurchaseOrderShipmentListRequest {
  String OrderNo;
  String LoginUserID;
  String CompanyId;

  PurchaseOrderShipmentListRequest({
    this.OrderNo,
    this.LoginUserID,
    this.CompanyId,
  });

  PurchaseOrderShipmentListRequest.fromJson(Map<String, dynamic> json) {
    OrderNo = json['OrderNo'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OrderNo'] = this.OrderNo;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
