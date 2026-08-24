class SOCustomerNearByPinCodeDetailsResponse {
  List<SOCustomerNearByPinCodeDetailsResponseDetails> details;
  int totalCount;

  SOCustomerNearByPinCodeDetailsResponse({this.details, this.totalCount});

  SOCustomerNearByPinCodeDetailsResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details
            .add(new SOCustomerNearByPinCodeDetailsResponseDetails.fromJson(v));
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

class SOCustomerNearByPinCodeDetailsResponseDetails {
  String orderNo;
  String orderDate;
  int customerID;
  String customerName;
  String contactNo1;
  String address;
  String pinCode;
  int productID;
  String productName;
  double unitRate;
  String CustomerType;

  SOCustomerNearByPinCodeDetailsResponseDetails(
      {this.orderNo,
      this.orderDate,
      this.customerID,
      this.customerName,
      this.contactNo1,
      this.address,
      this.pinCode,
      this.productID,
      this.productName,
      this.unitRate,
      this.CustomerType});

  SOCustomerNearByPinCodeDetailsResponseDetails.fromJson(
      Map<String, dynamic> json) {
    orderNo = json['OrderNo'];
    orderDate = json['OrderDate'];
    customerID = json['CustomerID'];
    customerName = json['CustomerName'];
    contactNo1 = json['ContactNo1'];
    address = json['Address'];
    pinCode = json['PinCode'];
    productID = json['ProductID'];
    productName = json['ProductName'];
    unitRate = json['UnitRate'];
    CustomerType = json['CustomerType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['OrderNo'] = this.orderNo;
    data['OrderDate'] = this.orderDate;
    data['CustomerID'] = this.customerID;
    data['CustomerName'] = this.customerName;
    data['ContactNo1'] = this.contactNo1;
    data['Address'] = this.address;
    data['PinCode'] = this.pinCode;
    data['ProductID'] = this.productID;
    data['ProductName'] = this.productName;
    data['UnitRate'] = this.unitRate;
    data['CustomerType'] = this.CustomerType;
    return data;
  }
}
