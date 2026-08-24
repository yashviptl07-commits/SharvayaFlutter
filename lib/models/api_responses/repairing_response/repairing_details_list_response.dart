class RepairingDetailsListResponse {
  List<RepairingDetailsListResponseDetails> details;
  int totalCount;

  RepairingDetailsListResponse({this.details, this.totalCount});

  RepairingDetailsListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new RepairingDetailsListResponseDetails.fromJson(v));
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

class RepairingDetailsListResponseDetails {
  int pkID;
  int parentID;
  String repairingNo;
  int checkListID;
  String checkDesc;
  bool checkFlag;

  RepairingDetailsListResponseDetails(
      {this.pkID,
        this.parentID,
        this.repairingNo,
        this.checkListID,
        this.checkDesc,
        this.checkFlag});

  RepairingDetailsListResponseDetails.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    parentID = json['ParentID'];
    repairingNo = json['RepairingNo'];
    checkListID = json['CheckListID'];
    checkDesc = json['CheckDesc'];
    checkFlag = json['CheckFlag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['ParentID'] = this.parentID;
    data['RepairingNo'] = this.repairingNo;
    data['CheckListID'] = this.checkListID;
    data['CheckDesc'] = this.checkDesc;
    data['CheckFlag'] = this.checkFlag;
    return data;
  }
}