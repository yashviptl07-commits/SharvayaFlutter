/*pkID:25
ModuleName:SalesInvoice
LoginUserID:admin
CompanyId:7216*/


class ModuleAttachmentsItemWiseDeleteRequest {
  String pkID;
  String ModuleName;
  String LoginUserID;



  String CompanyId;


  ModuleAttachmentsItemWiseDeleteRequest({
      this.pkID, this.ModuleName, this.LoginUserID, this.CompanyId});

  ModuleAttachmentsItemWiseDeleteRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID']; //json['TalukaCode'];
    ModuleName = json['ModuleName'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pkID'] = this.pkID;
    data['ModuleName'] = this.ModuleName;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;

    return data;
  }
}
