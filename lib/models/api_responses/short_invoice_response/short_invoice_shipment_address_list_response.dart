class ShortInvoiceShipmentListResponse {
  List<ShortInvoiceShipmentListResponseDetails> details;
  int totalCount;

  ShortInvoiceShipmentListResponse({this.details, this.totalCount});

  ShortInvoiceShipmentListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new ShortInvoiceShipmentListResponseDetails.fromJson(v));
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

class ShortInvoiceShipmentListResponseDetails {
  int rowNum;
  int pkID;
  String invoiceNo;
  String sCompanyName;
  String sGSTNo;
  String sContactNo;
  String sContactPersonName;
  String sAddress;
  String sArea;
  String sCountryCode;
  String email;
  String countryName;
  int sCityCode;
  String cityName;
  String gSTStateCode1;
  int sStateCode;
  String stateName;
  String sPincode;
  String updatedBy;
  String updatedDate;
  int customerID;
  String customerName;
  String createdBy;
  String createdDate;
  String createdEmployeeName;
  int companyID;

  ShortInvoiceShipmentListResponseDetails(
      {this.rowNum,
      this.pkID,
      this.invoiceNo,
      this.sCompanyName,
      this.sGSTNo,
      this.sContactNo,
      this.sContactPersonName,
      this.sAddress,
      this.sArea,
      this.sCountryCode,
      this.email,
      this.countryName,
      this.sCityCode,
      this.cityName,
      this.gSTStateCode1,
      this.sStateCode,
      this.stateName,
      this.sPincode,
      this.updatedBy,
      this.updatedDate,
      this.customerID,
      this.customerName,
      this.createdBy,
      this.createdDate,
      this.createdEmployeeName,
      this.companyID});

  ShortInvoiceShipmentListResponseDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'];
    pkID = json['pkID'];
    invoiceNo = json['InvoiceNo'];
    sCompanyName = json['SCompanyName'];
    sGSTNo = json['SGSTNo'];
    sContactNo = json['SContactNo'];
    sContactPersonName = json['SContactPersonName'];
    sAddress = json['SAddress'];
    sArea = json['SArea'];
    sCountryCode = json['SCountryCode'];
    email = json['Email'];
    countryName = json['CountryName'];
    sCityCode = json['SCityCode'];
    cityName = json['CityName'];
    gSTStateCode1 = json['GSTStateCode1'];
    sStateCode = json['SStateCode'];
    stateName = json['StateName'];
    sPincode = json['SPincode'];
    updatedBy = json['UpdatedBy'];
    updatedDate = json['UpdatedDate'];
    customerID = json['CustomerID'];
    customerName = json['CustomerName'];
    createdBy = json['CreatedBy'];
    createdDate = json['CreatedDate'];
    createdEmployeeName = json['CreatedEmployeeName'];
    companyID = json['CompanyID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['InvoiceNo'] = this.invoiceNo;
    data['SCompanyName'] = this.sCompanyName;
    data['SGSTNo'] = this.sGSTNo;
    data['SContactNo'] = this.sContactNo;
    data['SContactPersonName'] = this.sContactPersonName;
    data['SAddress'] = this.sAddress;
    data['SArea'] = this.sArea;
    data['SCountryCode'] = this.sCountryCode;
    data['Email'] = this.email;
    data['CountryName'] = this.countryName;
    data['SCityCode'] = this.sCityCode;
    data['CityName'] = this.cityName;
    data['GSTStateCode1'] = this.gSTStateCode1;
    data['SStateCode'] = this.sStateCode;
    data['StateName'] = this.stateName;
    data['SPincode'] = this.sPincode;
    data['UpdatedBy'] = this.updatedBy;
    data['UpdatedDate'] = this.updatedDate;
    data['CustomerID'] = this.customerID;
    data['CustomerName'] = this.customerName;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    data['CreatedEmployeeName'] = this.createdEmployeeName;
    data['CompanyID'] = this.companyID;
    return data;
  }
}
