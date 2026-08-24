/*pkID:
InvoiceNo:Inv-DEC22-002
LoginUserID:admin
CompanyId:4132*/

class SoNoToProductListRequest {

  String OrderNo;
  String CompanyId;

  SoNoToProductListRequest(
      {this.OrderNo, this.CompanyId});

  SoNoToProductListRequest.fromJson(Map<String, dynamic> json) {
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
