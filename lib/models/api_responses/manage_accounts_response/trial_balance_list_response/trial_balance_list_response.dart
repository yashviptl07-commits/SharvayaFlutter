class TrialBalanceListResponse {
  List<TrialBalanceListResponseDetails> details;
  int totalCount;

  TrialBalanceListResponse({this.details, this.totalCount});

  TrialBalanceListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new TrialBalanceListResponseDetails.fromJson(v));
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

class TrialBalanceListResponseDetails {
  int customerID;
  String customerName;
  double opening;
  double debit;
  double credit;
  double closing;

  TrialBalanceListResponseDetails(
      {this.customerID,
      this.customerName,
      this.opening,
      this.debit,
      this.credit,
      this.closing});

  TrialBalanceListResponseDetails.fromJson(Map<String, dynamic> json) {
    customerID = json['CustomerID'];
    customerName = json['CustomerName'];
    opening = json['Opening'];
    debit = json['Debit'];
    credit = json['Credit'];
    closing = json['Closing'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CustomerID'] = this.customerID;
    data['CustomerName'] = this.customerName;
    data['Opening'] = this.opening;
    data['Debit'] = this.debit;
    data['Credit'] = this.credit;
    data['Closing'] = this.closing;
    return data;
  }
}
