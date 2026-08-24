class MaterialInwardCustomerListResponce {
  List<MaterialInwardCustomerListResponceDetails> details;
  int totalCount;

  MaterialInwardCustomerListResponce({this.details, this.totalCount});

  MaterialInwardCustomerListResponce.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new MaterialInwardCustomerListResponceDetails.fromJson(v));
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

class MaterialInwardCustomerListResponceDetails {
  String label;
  int value;
  int cityCode;
  String cityName;
  int stateCode;
  String stateName;
  String countryCode;
  String countryName;
  String emailAddress;
  String contactNo1;
  String erpClosing;

  MaterialInwardCustomerListResponceDetails(
      {this.label,
      this.value,
      this.cityCode,
      this.cityName,
      this.stateCode,
      this.stateName,
      this.countryCode,
      this.countryName,
      this.emailAddress,
      this.contactNo1,
      this.erpClosing});

  MaterialInwardCustomerListResponceDetails.fromJson(
      Map<String, dynamic> json) {
    label = json['label'];
    value = json['value'];
    cityCode = json['CityCode'];
    cityName = json['CityName'];
    stateCode = json['StateCode'];
    stateName = json['StateName'];
    countryCode = json['CountryCode'];
    countryName = json['CountryName'];
    emailAddress = json['EmailAddress'];
    contactNo1 = json['ContactNo1'];
    erpClosing = json['ErpClosing'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['value'] = this.value;
    data['CityCode'] = this.cityCode;
    data['CityName'] = this.cityName;
    data['StateCode'] = this.stateCode;
    data['StateName'] = this.stateName;
    data['CountryCode'] = this.countryCode;
    data['CountryName'] = this.countryName;
    data['EmailAddress'] = this.emailAddress;
    data['ContactNo1'] = this.contactNo1;
    data['ErpClosing'] = this.erpClosing;
    return data;
  }
}
