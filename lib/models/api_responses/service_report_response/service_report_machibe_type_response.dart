class MachineMasterListRequestResponse {
  List<Details> details;
  int totalCount;

  MachineMasterListRequestResponse({this.details, this.totalCount});

  MachineMasterListRequestResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = <Details>[];
      json['details'].forEach((v) {
        details.add(new Details.fromJson(v));
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

class Details {
  int rowNum;
  int pkID;
  String machineType;
  String modelNo;
  String machineCapacity;
  String machineNameLong;
  String createdBy;
  String createdDate;
  String updatedBy;
  String updatedDate;

  Details(
      {this.rowNum,
      this.pkID,
      this.machineType,
      this.modelNo,
      this.machineCapacity,
      this.machineNameLong,
      this.createdBy,
      this.createdDate,
      this.updatedBy,
      this.updatedDate});

  Details.fromJson(Map<String, dynamic> json) {
    rowNum = json['RowNum'];
    pkID = json['pkID'];
    machineType = json['MachineType'];
    modelNo = json['ModelNo'];
    machineCapacity = json['MachineCapacity'];
    machineNameLong = json['MachineNameLong'];
    createdBy = json['CreatedBy'];
    createdDate = json['CreatedDate'];
    updatedBy = json['UpdatedBy'];
    updatedDate = json['UpdatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RowNum'] = this.rowNum;
    data['pkID'] = this.pkID;
    data['MachineType'] = this.machineType;
    data['ModelNo'] = this.modelNo;
    data['MachineCapacity'] = this.machineCapacity;
    data['MachineNameLong'] = this.machineNameLong;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    data['UpdatedBy'] = this.updatedBy;
    data['UpdatedDate'] = this.updatedDate;
    return data;
  }
}
