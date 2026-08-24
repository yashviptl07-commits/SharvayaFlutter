class PurchaseBillDeleteDeleteRequest {
  int pkID;
  int CompanyId;

  PurchaseBillDeleteDeleteRequest({this.pkID, this.CompanyId});

  PurchaseBillDeleteDeleteRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
