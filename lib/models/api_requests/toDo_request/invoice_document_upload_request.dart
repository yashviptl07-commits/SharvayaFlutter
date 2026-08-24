/*
pkID:0
ModuleName:SalesInvoice
DocName:mayank_191130116045.pdf
KeyValue:10017
LoginUserID:admin
CompanyId:7216*/

import 'dart:io';

class InvoiceDocumentUploadRequest {
  String pkID;
  String ModuleName;
  String DocName;
  String KeyValue;
  String LoginUserID;
  String CompanyId;
  File file;

  InvoiceDocumentUploadRequest(
      {this.pkID,
      this.ModuleName,
      this.DocName,
      this.KeyValue,
      this.LoginUserID,
      this.CompanyId,
      this.file});

  InvoiceDocumentUploadRequest.fromJson(Map<String, dynamic> json) {
    pkID = json['pkID'];
    ModuleName = json['ModuleName'];
    DocName = json['DocName'];
    KeyValue = json['KeyValue'];
    LoginUserID = json['LoginUserID'];
    CompanyId = json['CompanyId'];
    file = json[''];
  }

  Map<String, dynamic> toJson() {
    final Map<String, String> data = new Map<String, String>();
    data['pkID'] = this.pkID;
    data['ModuleName'] = this.ModuleName;
    data['DocName'] = this.DocName;
    data['KeyValue'] = this.KeyValue;
    data['LoginUserID'] = this.LoginUserID;
    data['CompanyId'] = this.CompanyId;
    return data;
  }
}
