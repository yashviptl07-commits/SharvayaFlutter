class SalesOrderAddressDropDownResponse {
  List<SalesOrderAddressDropDownResponseDetails> details;
  int totalCount;

  SalesOrderAddressDropDownResponse({this.details, this.totalCount});

  SalesOrderAddressDropDownResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new SalesOrderAddressDropDownResponseDetails.fromJson(v));
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

class SalesOrderAddressDropDownResponseDetails {
  String iD;
  String name;
  String gSTNo;
  String contactNo;
  String address;
  String area;
  String cityName;
  int cityCode;
  String stateName;
  int stateCode;
  String countryName;
  String countryCode;
  String pinCode;

  SalesOrderAddressDropDownResponseDetails(
      {this.iD,
        this.name,
        this.gSTNo,
        this.contactNo,
        this.address,
        this.area,
        this.cityName,
        this.cityCode,
        this.stateName,
        this.stateCode,
        this.countryName,
        this.countryCode,
        this.pinCode});

  SalesOrderAddressDropDownResponseDetails.fromJson(Map<String, dynamic> json) {
    iD = json['ID']==null?"0": json['ID'];
    name = json['Name']==null?"": json['Name'];
    gSTNo = json['GSTNo']==null?"": json['GSTNo'];
    contactNo = json['ContactNo']==null?"": json['ContactNo'];
    address = json['Address']==null?"": json['Address'];
    area = json['Area']==null?"": json['Area'];
    cityName = json['CityName']==null?"": json['CityName'];
    cityCode = json['CityCode']==null?0: json['CityCode'];
    stateName = json['StateName']==null?"": json['StateName'];
    stateCode = json['StateCode']==null?0: json['StateCode'];
    countryName = json['CountryName']==null?"": json['CountryName'];
    countryCode = json['CountryCode']==null?"": json['CountryCode'];
    pinCode = json['PinCode']==null?"": json['PinCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['GSTNo'] = this.gSTNo;
    data['ContactNo'] = this.contactNo;
    data['Address'] = this.address;
    data['Area'] = this.area;
    data['CityName'] = this.cityName;
    data['CityCode'] = this.cityCode;
    data['StateName'] = this.stateName;
    data['StateCode'] = this.stateCode;
    data['CountryName'] = this.countryName;
    data['CountryCode'] = this.countryCode;
    data['PinCode'] = this.pinCode;
    return data;
  }
}