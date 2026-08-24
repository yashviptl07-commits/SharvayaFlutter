class CustomerLabelvalueRsponse {
  List<SearchDetails> details;
  int totalCount;

  CustomerLabelvalueRsponse({this.details, this.totalCount});

  CustomerLabelvalueRsponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new SearchDetails.fromJson(v));
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

class SearchDetails {
  String label;
  int value;
  String customerType;
  int stateCode;
  String stateName;
  // bool erpClosing;
  double erpClosing;
  String countryCode;
  String countryName;
  String customerSourceName;
  String emailAddress;
  String ContactNo1;
  String ContactNo2;
  String inquiryNo;
  String CityName;
  String Longitude;
  String Latitude;
  int CityCode;

  SearchDetails({
    this.label,
    this.value,
    this.customerType,
    this.stateCode,
    this.stateName,
    this.erpClosing,
    this.countryCode,
    this.countryName,
    this.customerSourceName,
    this.emailAddress,
    this.ContactNo1,
    this.ContactNo2,
    this.inquiryNo,
    this.CityName,
    this.CityCode,
    this.Latitude,
    this.Longitude,
  });

  SearchDetails.fromJson(Map<String, dynamic> json) {
    label = json['label'] == null ? "" : json['label'];
    value = json['value'] == null ? 0 : json['value'];
    customerType = json['CustomerType'] == null ? "" : json['CustomerType'];
    stateCode = json['StateCode'] == null ? 0 : json['StateCode'];
    stateName = json['StateName'] == null ? "" : json['StateName'];
    erpClosing = json['ErpClosing'];
    countryCode = json['CountryCode'] == null ? "" : json['CountryCode'];
    countryName = json['CountryName'] == null ? "" : json['CountryName'];
    customerSourceName =
        json['CustomerSourceName'] == null ? "" : json['CustomerSourceName'];
    emailAddress = json['EmailAddress'] == null ? "" : json['EmailAddress'];
    ContactNo1 = json['ContactNo1'] == null ? "" : json['ContactNo1'];
    ContactNo2 = json['ContactNo2'] == null ? "" : json['ContactNo2'];
    inquiryNo = json['inquiryNo'] == null ? "" : json['inquiryNo'];
    CityName = json['CityName'] == null ? "" : json['CityName'];
    Longitude = json['Longitude'] == null ? "" : json['Longitude'];
    Latitude = json['Latitude'] == null ? "" : json['Latitude'];
    CityCode = json['CityCode'] == null ? 0 : json['CityCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['value'] = this.value;
    data['CustomerType'] = this.customerType;
    data['StateCode'] = this.stateCode;
    data['StateName'] = this.stateName;
    data['ErpClosing'] = this.erpClosing;
    data['CountryCode'] = this.countryCode;
    data['CountryName'] = this.countryName;
    data['CustomerSourceName'] = this.customerSourceName;
    data['EmailAddress'] = this.emailAddress;
    data['ContactNo1'] = this.ContactNo1;
    data['ContactNo2'] = this.ContactNo2;
    data['inquiryNo'] = this.inquiryNo;
    data['CityName'] = this.CityName;
    data['Latitude'] = this.Latitude;
    data['Longitude'] = this.Longitude;

    return data;
  }
}
