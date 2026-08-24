/*
pkID:13
LoginUserID:admin
CompanyId:7291
*/
class MaterialInwardDeleteRequest {
  String pkID;
  String LoginUserID;
  String CompanyId;

  MaterialInwardDeleteRequest({
    this.pkID,
    this.LoginUserID,
    this.CompanyId,
  });

  MaterialInwardDeleteRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
