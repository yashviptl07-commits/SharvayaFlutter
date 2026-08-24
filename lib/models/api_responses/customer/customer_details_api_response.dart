class CustomerDetailsResponse {
  List<CustomerDetails> details;
  int totalCount;

  CustomerDetailsResponse({this.details, this.totalCount});

  CustomerDetailsResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new CustomerDetails.fromJson(v));
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

class CustomerDetails {
  int rowNum;
  int customerID;
  String customerName;
  String customerType;
  bool blockCustomer;
  String address;
  String area;
  String pinCode;
  int cityCode;
  String cityName;
  int stateCode;
  String stateName;
  int gSTStateCode;
  String address1;
  String area1;
  String pinCode1;
  int cityCode1;
  String cityName1;
  int stateCode1;
  String stateName1;
  int gSTStateCode1;
  String gSTNO;
  String pANNO;
  String cINNO;
  String contactNo1;
  String contactNo2;
  String emailAddress;
  String websiteAddress;
  String birthDate;
  String anniversaryDate;
  String orgTypeCode;
  String orgType;
  int parentID;
  int erpClosing;
  String parentName;
  int customerSourceID;
  String customerSourceName;
  int specialityID;
  String specialityName;
  String treatmentType;
  String generateInquiry;
  String countryCode;
  String countryName;
  String countryCode1;
  String countryName1;
  double opening;
  double debit;
  double credit;
  double closing;
  int priceListID;
  String createdBy;
  String createdDate;
  String latitude;
  String longitude;

  CustomerDetails(
      {this.rowNum,
        this.customerID,
        this.customerName,
        this.customerType,
        this.blockCustomer,
        this.address,
        this.area,
        this.pinCode,
        this.cityCode,
        this.cityName,
        this.stateCode,
        this.stateName,
        this.gSTStateCode,
        this.address1,
        this.area1,
        this.pinCode1,
        this.cityCode1,
        this.cityName1,
        this.stateCode1,
        this.stateName1,
        this.gSTStateCode1,
        this.gSTNO,
        this.pANNO,
        this.cINNO,
        this.contactNo1,
        this.contactNo2,
        this.emailAddress,
        this.websiteAddress,
        this.birthDate,
        this.anniversaryDate,
        this.orgTypeCode,
        this.orgType,
        this.parentID,
        this.erpClosing,
        this.parentName,
        this.customerSourceID,
        this.customerSourceName,
        this.specialityID,
        this.specialityName,
        this.treatmentType,
        this.generateInquiry,
        this.countryCode,
        this.countryName,
        this.countryCode1,
        this.countryName1,
        this.opening,
        this.debit,
        this.credit,
        this.closing,
        this.priceListID,
        this.createdBy,
        this.createdDate,
        this.latitude,
        this.longitude});

  CustomerDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'] == null ? 0 : json['RowNum'];
    customerID = json['CustomerID'] == null ? 0 : json['CustomerID'];
    customerName = json['CustomerName'] == null ? "" : json['CustomerName'];
    customerType = json['CustomerType'] == null ? "" : json['CustomerType'];
    blockCustomer =
    json['BlockCustomer'] == null ? false : json['BlockCustomer'];
    address = json['Address'] == null ? "" : json['Address'];
    area = json['Area'] == null ? "" : json['Area'];
    pinCode = json['PinCode'] == null ? "" : json['PinCode'];
    cityCode = json['CityCode'] == null ? 0 : json['CityCode'];
    cityName = json['CityName'] == null ? "" : json['CityName'];
    stateCode = json['StateCode'] == null ? 0 : json['StateCode'];
    stateName = json['StateName'] == null ? "" : json['StateName'];
    gSTStateCode = json['GSTStateCode'] == null ? 0 : json['GSTStateCode'];
    address1 = json['Address1'] == null ? "" : json['Address1'];
    area1 = json['Area1'] == null ? "" : json['Area1'];
    pinCode1 = json['PinCode1'] == null ? "" : json['PinCode1'];
    cityCode1 = json['CityCode1'] == null ? 0 : json['CityCode1'];
    cityName1 = json['CityName1'] == null ? "" : json['CityName1'];
    stateCode1 = json['StateCode1'] == null ? 0 : json['StateCode1'];
    stateName1 = json['StateName1'] == null ? "" : json['StateName1'];
    gSTStateCode1 = json['GSTStateCode1'] == null ? 0 : json['GSTStateCode1'];
    gSTNO = json['GSTNO'] == null ? "" : json['GSTNO'];
    pANNO = json['PANNO'] == null ? "" : json['PANNO'];
    cINNO = json['CINNO'] == null ? "" : json['CINNO'];
    contactNo1 = json['ContactNo1'] == null ? "" : json['ContactNo1'];
    contactNo2 = json['ContactNo2'] == null ? "" : json['ContactNo2'];
    emailAddress = json['EmailAddress'] == null ? "" : json['EmailAddress'];
    websiteAddress =
    json['WebsiteAddress'] == null ? "" : json['WebsiteAddress'];
    birthDate = json['BirthDate'] == null ? "" : json['BirthDate'];
    anniversaryDate =
    json['AnniversaryDate'] == null ? "" : json['AnniversaryDate'];
    orgTypeCode = json['OrgTypeCode'] == null ? "" : json['OrgTypeCode'];
    orgType = json['OrgType'] == null ? "" : json['OrgType'];
    parentID = json['ParentID'] == null ? 0 : json['ParentID'];
    erpClosing = json['ErpClosing'] == null ? 0 : json['ErpClosing'];
    parentName = json['ParentName'] == null ? "" : json['ParentName'];
    customerSourceID =
    json['CustomerSourceID'] == null ? 0 : json['CustomerSourceID'];
    customerSourceName =
    json['CustomerSourceName'] == null ? "" : json['CustomerSourceName'];
    specialityID = json['SpecialityID'] == null ? 0 : json['SpecialityID'];
    specialityName =
    json['SpecialityName'] == null ? "" : json['SpecialityName'];
    treatmentType = json['TreatmentType'] == null ? "" : json['TreatmentType'];
    generateInquiry =
    json['GenerateInquiry'] == null ? "" : json['GenerateInquiry'];
    countryCode = json['CountryCode'] == null ? "" : json['CountryCode'];
    countryName = json['CountryName'] == null ? "" : json['CountryName'];
    countryCode1 = json['CountryCode1'] == null ? "" : json['CountryCode1'];
    countryName1 = json['CountryName1'] == null ? "" : json['CountryName1'];
    opening = json['Opening'] == null ? 0.00 : json['Opening'];
    debit = json['Debit'] == null ? 0.00 : json['Debit'];
    credit = json['Credit'] == null ? 0.00 : json['Credit'];
    closing = json['Closing'] == null ? 0.00 : json['Closing'];
    priceListID = json['PriceListID'] == null ? 0 : json['PriceListID'];
    createdBy = json['CreatedBy'] == null ? "" : json['CreatedBy'];
    createdDate = json['CreatedDate'] == null ? "" : json['CreatedDate'];
    latitude = json['Latitude'] == null ? "" : json['Latitude'];
    longitude = json['Longitude'] == null ? "" : json['Longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['CustomerID'] = this.customerID;
    data['CustomerName'] = this.customerName;
    data['CustomerType'] = this.customerType;
    data['BlockCustomer'] = this.blockCustomer;
    data['Address'] = this.address;
    data['Area'] = this.area;
    data['PinCode'] = this.pinCode;
    data['CityCode'] = this.cityCode;
    data['CityName'] = this.cityName;
    data['StateCode'] = this.stateCode;
    data['StateName'] = this.stateName;
    data['GSTStateCode'] = this.gSTStateCode;
    data['Address1'] = this.address1;
    data['Area1'] = this.area1;
    data['PinCode1'] = this.pinCode1;
    data['CityCode1'] = this.cityCode1;
    data['CityName1'] = this.cityName1;
    data['StateCode1'] = this.stateCode1;
    data['StateName1'] = this.stateName1;
    data['GSTStateCode1'] = this.gSTStateCode1;
    data['GSTNO'] = this.gSTNO;
    data['PANNO'] = this.pANNO;
    data['CINNO'] = this.cINNO;
    data['ContactNo1'] = this.contactNo1;
    data['ContactNo2'] = this.contactNo2;
    data['EmailAddress'] = this.emailAddress;
    data['WebsiteAddress'] = this.websiteAddress;
    data['BirthDate'] = this.birthDate;
    data['AnniversaryDate'] = this.anniversaryDate;
    data['OrgTypeCode'] = this.orgTypeCode;
    data['OrgType'] = this.orgType;
    data['ParentID'] = this.parentID;
    data['ErpClosing'] = this.erpClosing;
    data['ParentName'] = this.parentName;
    data['CustomerSourceID'] = this.customerSourceID;
    data['CustomerSourceName'] = this.customerSourceName;
    data['SpecialityID'] = this.specialityID;
    data['SpecialityName'] = this.specialityName;
    data['TreatmentType'] = this.treatmentType;
    data['GenerateInquiry'] = this.generateInquiry;
    data['CountryCode'] = this.countryCode;
    data['CountryName'] = this.countryName;
    data['CountryCode1'] = this.countryCode1;
    data['CountryName1'] = this.countryName1;
    data['Opening'] = this.opening;
    data['Debit'] = this.debit;
    data['Credit'] = this.credit;
    data['Closing'] = this.closing;
    data['PriceListID'] = this.priceListID;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    data['Latitude'] = this.latitude;
    data['Longitude'] = this.longitude;
    return data;
  }
}
