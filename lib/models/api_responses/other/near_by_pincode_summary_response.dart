class SOCustomerNearByPinCodeSummaryResponse {
  List<SOCustomerNearByPinCodeSummaryResponseDetails> details;
  int totalCount;

  SOCustomerNearByPinCodeSummaryResponse({this.details, this.totalCount});

  SOCustomerNearByPinCodeSummaryResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details
            .add(new SOCustomerNearByPinCodeSummaryResponseDetails.fromJson(v));
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

class SOCustomerNearByPinCodeSummaryResponseDetails {
  int customerID;
  String customerName;
  String contactNo1;
  String emailAddress;
  String customerType;
  String address;
  String pinCode;
  int productID;
  String productName;

  SOCustomerNearByPinCodeSummaryResponseDetails(
      {this.customerID,
      this.customerName,
      this.contactNo1,
      this.emailAddress,
      this.customerType,
      this.address,
      this.pinCode,
      this.productID,
      this.productName});

  SOCustomerNearByPinCodeSummaryResponseDetails.fromJson(
      Map<String, dynamic> json) {
    customerID = json['CustomerID'];
    customerName = json['CustomerName'];
    contactNo1 = json['ContactNo1'];
    emailAddress = json['EmailAddress'];
    customerType = json['CustomerType'];
    address = json['Address'];
    pinCode = json['PinCode'];
    productID = json['ProductID'];
    productName = json['ProductName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CustomerID'] = this.customerID;
    data['CustomerName'] = this.customerName;
    data['ContactNo1'] = this.contactNo1;
    data['EmailAddress'] = this.emailAddress;
    data['CustomerType'] = this.customerType;
    data['Address'] = this.address;
    data['PinCode'] = this.pinCode;
    data['ProductID'] = this.productID;
    data['ProductName'] = this.productName;
    return data;
  }
}
