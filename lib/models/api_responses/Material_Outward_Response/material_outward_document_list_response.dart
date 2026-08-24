class MaterialOutwardDocumentListResponse {
  List<MaterialOutwardDocumentListResponseDetails> details;
  int totalCount;

  MaterialOutwardDocumentListResponse({this.details, this.totalCount});

  MaterialOutwardDocumentListResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new MaterialOutwardDocumentListResponseDetails.fromJson(v));
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

class MaterialOutwardDocumentListResponseDetails {
  int pkID;
  String moduleName;
  String keyValue;
  String docName;
  String docType;
  String docData;
  String createdBy;
  String createdDate;

  MaterialOutwardDocumentListResponseDetails(
      {this.pkID,
      this.moduleName,
      this.keyValue,
      this.docName,
      this.docType,
      this.docData,
      this.createdBy,
      this.createdDate});

  MaterialOutwardDocumentListResponseDetails.fromJson(
      Map<String, dynamic> json) {
    pkID = json['pkID'] == null ? 0 : json['pkID'];
    moduleName = json['ModuleName'] == null ? "" : json['ModuleName'];
    keyValue = json['KeyValue'] == null ? "" : json['KeyValue'];
    docName = json['DocName'] == null ? "" : json['DocName'];
    docType = json['DocType'] == null ? "" : json['DocType'];
    docData = json['DocData'] == null ? "" : json['DocData'];
    createdBy = json['CreatedBy'] == null ? "" : json['CreatedBy'];
    createdDate = json['CreatedDate'] == null ? "" : json['CreatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['ModuleName'] = this.moduleName;
    data['KeyValue'] = this.keyValue;
    data['DocName'] = this.docName;
    data['DocType'] = this.docType;
    data['DocData'] = this.docData;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    return data;
  }
}
