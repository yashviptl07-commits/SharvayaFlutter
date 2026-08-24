class FixedLedgerListResponse {
  List<FixedLedgerListResponseDetails> details;
  int totalCount;

  FixedLedgerListResponse({this.details, this.totalCount});

  FixedLedgerListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new FixedLedgerListResponseDetails.fromJson(v));
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

class FixedLedgerListResponseDetails {
  int customerID;
  String customerName;

  FixedLedgerListResponseDetails({this.customerID, this.customerName});

  FixedLedgerListResponseDetails.fromJson(Map<String, dynamic> json) {
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


