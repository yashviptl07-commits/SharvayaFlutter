class PurchaseBillACResponse {
  List<PurchaseBillACResponseDetails> details;
  int totalCount;

  PurchaseBillACResponse({this.details, this.totalCount});

  PurchaseBillACResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new PurchaseBillACResponseDetails.fromJson(v));
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

class PurchaseBillACResponseDetails {
  int customerID;
  String customerName;

  PurchaseBillACResponseDetails({this.customerID, this.customerName});

  PurchaseBillACResponseDetails.fromJson(Map<String, dynamic> json) {
    customerID = json['CustomerID'];
    customerName = json['CustomerName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CustomerID'] = this.customerID;
    data['CustomerName'] = this.customerName;
    return data;
  }
}
