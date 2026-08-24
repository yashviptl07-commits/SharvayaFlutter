class MaterialOutwardUploadResponse {
  List<MaterialOutwardUploadResponseDetails> details;
  int totalCount;

  MaterialOutwardUploadResponse({this.details, this.totalCount});

  MaterialOutwardUploadResponse.fromJson(Map<String, dynamic> json) {
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details.add(new MaterialOutwardUploadResponseDetails.fromJson(v));
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

class MaterialOutwardUploadResponseDetails {
  String column1;

  MaterialOutwardUploadResponseDetails({this.column1});

  MaterialOutwardUploadResponseDetails.fromJson(Map<String, dynamic> json) {
    column1 = json['Column1'] == null ? "" : json['Column1'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Column1'] = this.column1;
    return data;
  }
}
