class OfficeRefTypeFromCustomerIDResponse {
  List<OfficeRefTypeFromCustomerIDResponseDetails> details;
  int totalCount;

  OfficeRefTypeFromCustomerIDResponse({this.details, this.totalCount});

  OfficeRefTypeFromCustomerIDResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new OfficeRefTypeFromCustomerIDResponseDetails.fromJson(v));
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

class OfficeRefTypeFromCustomerIDResponseDetails {
  int customerID;
  String orderNo;

  OfficeRefTypeFromCustomerIDResponseDetails({this.customerID, this.orderNo});

  OfficeRefTypeFromCustomerIDResponseDetails.fromJson(
      Map<String, dynamic> json) {
    customerID = json['CustomerID'];
    orderNo = json['OrderNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CustomerID'] = this.customerID;
    data['OrderNo'] = this.orderNo;
    return data;
  }
}
