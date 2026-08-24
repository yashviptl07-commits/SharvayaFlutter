class CommonCompanyDetailsResponse {
  List<CommonCompanyDetailsResponseDetails> details;
  int totalCount;

  CommonCompanyDetailsResponse({this.details, this.totalCount});

  CommonCompanyDetailsResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new CommonCompanyDetailsResponseDetails.fromJson(v));
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

class CommonCompanyDetailsResponseDetails {
  int companyID;
  String companyName;
  String serialKey;
  int parentCompanyID;
  String address;
  String area;
  String pincode;
  int cityCode;
  String state;
  String gSTNo;
  String pANNo;
  String cINNo;
  String host;
  bool enableSSL;
  String userName;
  String password;
  int portNumber;
  int stateCode;
  dynamic sMSUri;
  dynamic sMSAuthKey;
  dynamic sMSSenderID;
  int bankID;
  String eSignaturePath;
  String wSPAuthKey;
  String contactNo;

  CommonCompanyDetailsResponseDetails(
      {this.companyID,
        this.companyName,
        this.serialKey,
        this.parentCompanyID,
        this.address,
        this.area,
        this.pincode,
        this.cityCode,
        this.state,
        this.gSTNo,
        this.pANNo,
        this.cINNo,
        this.host,
        this.enableSSL,
        this.userName,
        this.password,
        this.portNumber,
        this.stateCode,
        this.sMSUri,
        this.sMSAuthKey,
        this.sMSSenderID,
        this.bankID,
        this.eSignaturePath,
        this.wSPAuthKey,
        this.contactNo});

  CommonCompanyDetailsResponseDetails.fromJson(Map<String, dynamic> json) {
    companyID = json['CompanyID'];
    companyName = json['CompanyName'];
    serialKey = json['SerialKey'];
    parentCompanyID = json['ParentCompanyID'];
    address = json['Address'];
    area = json['Area'];
    pincode = json['Pincode'];
    cityCode = json['CityCode'];
    state = json['State'];
    gSTNo = json['GSTNo'];
    pANNo = json['PANNo'];
    cINNo = json['CINNo'];
    host = json['Host'];
    enableSSL = json['EnableSSL'];
    userName = json['UserName'];
    password = json['Password'];
    portNumber = json['PortNumber'];
    stateCode = json['StateCode'];
    sMSUri = json['SMS_Uri'];
    sMSAuthKey = json['SMS_AuthKey'];
    sMSSenderID = json['SMS_SenderID'];
    bankID = json['BankID'];
    eSignaturePath = json['eSignaturePath'];
    wSPAuthKey = json['WSP_AuthKey'];
    contactNo = json['ContactNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CompanyID'] = this.companyID;
    data['CompanyName'] = this.companyName;
    data['SerialKey'] = this.serialKey;
    data['ParentCompanyID'] = this.parentCompanyID;
    data['Address'] = this.address;
    data['Area'] = this.area;
    data['Pincode'] = this.pincode;
    data['CityCode'] = this.cityCode;
    data['State'] = this.state;
    data['GSTNo'] = this.gSTNo;
    data['PANNo'] = this.pANNo;
    data['CINNo'] = this.cINNo;
    data['Host'] = this.host;
    data['EnableSSL'] = this.enableSSL;
    data['UserName'] = this.userName;
    data['Password'] = this.password;
    data['PortNumber'] = this.portNumber;
    data['StateCode'] = this.stateCode;
    data['SMS_Uri'] = this.sMSUri;
    data['SMS_AuthKey'] = this.sMSAuthKey;
    data['SMS_SenderID'] = this.sMSSenderID;
    data['BankID'] = this.bankID;
    data['eSignaturePath'] = this.eSignaturePath;
    data['WSP_AuthKey'] = this.wSPAuthKey;
    data['ContactNo'] = this.contactNo;
    return data;
  }
}