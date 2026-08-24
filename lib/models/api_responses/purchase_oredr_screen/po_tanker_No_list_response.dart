class POTankerListResponse {
  List<POTankerListResponseDetails> details;
  int totalCount;

  POTankerListResponse({this.details, this.totalCount});

  POTankerListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new POTankerListResponseDetails.fromJson(v));
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

class POTankerListResponseDetails {
  int rowNum;
  int pkID;
  String registrationNo;
  String chasisNo;
  String mfg;
  String model;
  String color;
  String vehicleType;
  String mfgyear;
  String engineCC;
  String ownerName;
  String ownerAddress;
  String ownerMobile;
  String ownerLandline;
  double insurancePerTrip;
  double governmentTax;
  double depreciationPerDay;
  double explosiveTax;
  String insuranceCompany;
  String insurancePolicyNo;
  String insuranceExpiry;
  double ratePerKM;
  double grossWeight;
  double tareWeight;
  double netWeight;
  String licenseNo;
  String rTOTax;
  String form38Startdt;
  String form38Renewdt;
  String gujPermitStartdt;
  String gujPermitRenewdt;
  String form47Startdt;
  String form47Renewdt;
  String fitmentCertiStartdt;
  String fitmentCertiRenewdt;
  String insuranceStartdt;
  String insuranceRenewdt;
  String formLS2Startdt;
  String formLS2Renewdt;
  String rule19Startdt;
  String rule19Renewdt;
  String rule18Startdt;
  String rule18Renewdt;
  String rule43Startdt;
  String rule43Renewdt;
  String pUCStartdt;
  String pUCRenewdt;
  String fitnessCertiStartdt;
  String fitnessCertiRenewdt;
  String createdBy;
  String createdDate;
  String updatedBy;
  String updatedDate;

  POTankerListResponseDetails(
      {this.rowNum,
      this.pkID,
      this.registrationNo,
      this.chasisNo,
      this.mfg,
      this.model,
      this.color,
      this.vehicleType,
      this.mfgyear,
      this.engineCC,
      this.ownerName,
      this.ownerAddress,
      this.ownerMobile,
      this.ownerLandline,
      this.insurancePerTrip,
      this.governmentTax,
      this.depreciationPerDay,
      this.explosiveTax,
      this.insuranceCompany,
      this.insurancePolicyNo,
      this.insuranceExpiry,
      this.ratePerKM,
      this.grossWeight,
      this.tareWeight,
      this.netWeight,
      this.licenseNo,
      this.rTOTax,
      this.form38Startdt,
      this.form38Renewdt,
      this.gujPermitStartdt,
      this.gujPermitRenewdt,
      this.form47Startdt,
      this.form47Renewdt,
      this.fitmentCertiStartdt,
      this.fitmentCertiRenewdt,
      this.insuranceStartdt,
      this.insuranceRenewdt,
      this.formLS2Startdt,
      this.formLS2Renewdt,
      this.rule19Startdt,
      this.rule19Renewdt,
      this.rule18Startdt,
      this.rule18Renewdt,
      this.rule43Startdt,
      this.rule43Renewdt,
      this.pUCStartdt,
      this.pUCRenewdt,
      this.fitnessCertiStartdt,
      this.fitnessCertiRenewdt,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate});

  POTankerListResponseDetails.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'];
    pkID = json['pkID'];
    registrationNo = json['RegistrationNo'];
    chasisNo = json['ChasisNo'];
    mfg = json['Mfg'];
    model = json['Model'];
    color = json['Color'];
    vehicleType = json['VehicleType'];
    mfgyear = json['Mfgyear'];
    engineCC = json['EngineCC'];
    ownerName = json['OwnerName'];
    ownerAddress = json['OwnerAddress'];
    ownerMobile = json['OwnerMobile'];
    ownerLandline = json['OwnerLandline'];
    insurancePerTrip = json['InsurancePerTrip'];
    governmentTax = json['GovernmentTax'];
    depreciationPerDay = json['DepreciationPerDay'];
    explosiveTax = json['ExplosiveTax'];
    insuranceCompany = json['InsuranceCompany'];
    insurancePolicyNo = json['InsurancePolicyNo'];
    insuranceExpiry = json['InsuranceExpiry'];
    ratePerKM = json['RatePerKM'];
    grossWeight = json['Gross_Weight'];
    tareWeight = json['Tare_Weight'];
    netWeight = json['Net_Weight'];
    licenseNo = json['LicenseNo'];
    rTOTax = json['RTOTax'];
    form38Startdt = json['Form38Startdt'];
    form38Renewdt = json['Form38Renewdt'];
    gujPermitStartdt = json['GujPermitStartdt'];
    gujPermitRenewdt = json['GujPermitRenewdt'];
    form47Startdt = json['Form47Startdt'];
    form47Renewdt = json['Form47Renewdt'];
    fitmentCertiStartdt = json['FitmentCertiStartdt'];
    fitmentCertiRenewdt = json['FitmentCertiRenewdt'];
    insuranceStartdt = json['InsuranceStartdt'];
    insuranceRenewdt = json['InsuranceRenewdt'];
    formLS2Startdt = json['FormLS2Startdt'];
    formLS2Renewdt = json['FormLS2Renewdt'];
    rule19Startdt = json['Rule19Startdt'];
    rule19Renewdt = json['Rule19Renewdt'];
    rule18Startdt = json['Rule18Startdt'];
    rule18Renewdt = json['Rule18Renewdt'];
    rule43Startdt = json['Rule43Startdt'];
    rule43Renewdt = json['Rule43Renewdt'];
    pUCStartdt = json['PUCStartdt'];
    pUCRenewdt = json['PUCRenewdt'];
    fitnessCertiStartdt = json['FitnessCertiStartdt'];
    fitnessCertiRenewdt = json['FitnessCertiRenewdt'];
    createdBy = json['CreatedBy'];
    createdDate = json['CreatedDate'];
    updatedBy = json['UpdatedBy'];
    updatedDate = json['UpdatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['RegistrationNo'] = this.registrationNo;
    data['ChasisNo'] = this.chasisNo;
    data['Mfg'] = this.mfg;
    data['Model'] = this.model;
    data['Color'] = this.color;
    data['VehicleType'] = this.vehicleType;
    data['Mfgyear'] = this.mfgyear;
    data['EngineCC'] = this.engineCC;
    data['OwnerName'] = this.ownerName;
    data['OwnerAddress'] = this.ownerAddress;
    data['OwnerMobile'] = this.ownerMobile;
    data['OwnerLandline'] = this.ownerLandline;
    data['InsurancePerTrip'] = this.insurancePerTrip;
    data['GovernmentTax'] = this.governmentTax;
    data['DepreciationPerDay'] = this.depreciationPerDay;
    data['ExplosiveTax'] = this.explosiveTax;
    data['InsuranceCompany'] = this.insuranceCompany;
    data['InsurancePolicyNo'] = this.insurancePolicyNo;
    data['InsuranceExpiry'] = this.insuranceExpiry;
    data['RatePerKM'] = this.ratePerKM;
    data['Gross_Weight'] = this.grossWeight;
    data['Tare_Weight'] = this.tareWeight;
    data['Net_Weight'] = this.netWeight;
    data['LicenseNo'] = this.licenseNo;
    data['RTOTax'] = this.rTOTax;
    data['Form38Startdt'] = this.form38Startdt;
    data['Form38Renewdt'] = this.form38Renewdt;
    data['GujPermitStartdt'] = this.gujPermitStartdt;
    data['GujPermitRenewdt'] = this.gujPermitRenewdt;
    data['Form47Startdt'] = this.form47Startdt;
    data['Form47Renewdt'] = this.form47Renewdt;
    data['FitmentCertiStartdt'] = this.fitmentCertiStartdt;
    data['FitmentCertiRenewdt'] = this.fitmentCertiRenewdt;
    data['InsuranceStartdt'] = this.insuranceStartdt;
    data['InsuranceRenewdt'] = this.insuranceRenewdt;
    data['FormLS2Startdt'] = this.formLS2Startdt;
    data['FormLS2Renewdt'] = this.formLS2Renewdt;
    data['Rule19Startdt'] = this.rule19Startdt;
    data['Rule19Renewdt'] = this.rule19Renewdt;
    data['Rule18Startdt'] = this.rule18Startdt;
    data['Rule18Renewdt'] = this.rule18Renewdt;
    data['Rule43Startdt'] = this.rule43Startdt;
    data['Rule43Renewdt'] = this.rule43Renewdt;
    data['PUCStartdt'] = this.pUCStartdt;
    data['PUCRenewdt'] = this.pUCRenewdt;
    data['FitnessCertiStartdt'] = this.fitnessCertiStartdt;
    data['FitnessCertiRenewdt'] = this.fitnessCertiRenewdt;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    data['UpdatedBy'] = this.updatedBy;
    data['UpdatedDate'] = this.updatedDate;
    return data;
  }
}
