import 'dart:math';

import 'package:soleoserp/models/common/purchase_bill_table.dart';
import 'package:soleoserp/models/common/sales_bill_table.dart';
import 'package:soleoserp/utils/calculation/model/product_calculation_model.dart';
import 'package:soleoserp/utils/calculation/product_calulation.dart';

class PurchaseBillOrderHeaderDiscountCalculation {
  static List<String> testmethod(double i, double j) {
    double sum = i + j;
    double multiplication = i * j;
    List<String> table = [sum.toString(), multiplication.toString()];

    return table;
  }

  static List<PurchaseBillTable> txtHeadDiscount_TextChanged(
      List<PurchaseBillTable> qtTable,
      double txtHeadDiscount,
      String CompanyStateID,
      String CustomerStateID) {
    List<PurchaseBillTable> outqtTable = [];

    double TotalAmt = 0;
    double HeaderDiscAmt = txtHeadDiscount != null ? txtHeadDiscount : 0;
    double HeaderDiscItemWise = 0;
    if (qtTable != null) {
      qtTable.forEach((PurchaseBillTable car) {
        TotalAmt += car.NetAmt != null ? car.NetAmt : 0;
      });

      qtTable.forEach((PurchaseBillTable car) {
        HeaderDiscItemWise = 0;
        double a = car.NetAmt;
        int uq = 1;
        double q = car.Qty;
        double unitqty = 1;
        double ur = car.Rate;
        double dp = car.DiscountPer;
        double dpa = car.DiscountAmt;
        double tr = car.AddTaxPer;
        double at = 0;
        int taxtype = car.TaxType;
        HeaderDiscItemWise = (TotalAmt > 0)
            ? roundDouble(((HeaderDiscAmt * a) / TotalAmt), 2)
            : 0;
        double TaxAmt = 0;
        double CGSTPer = 0, CGSTAmt = 0;
        double SGSTPer = 0,
            SGSTAmt = 0,
            IGSTPer = 0,
            IGSTAmt = 0,
            NetRate = 0,
            BasicAmt = 0,
            NetAmt = 0,
            ItmDiscPer1 = 0,
            ItmDiscAmt1 = 0,
            AddTaxAmt = 0,
            HeadDiscAmt1 = 0;

        ProductCalculationModel productoutparam =
            productCalculation.funCalculateProduct(
          UnitQuantity: 1,
          TaxType: taxtype,
          Qty: q,
          Rate: ur,
          ItmDiscPer: dp,
          ItmDiscAmt: dpa,
          TaxPer: tr,
          AddTaxPer: at,
          HdDiscAmt: HeaderDiscItemWise,
          CustomerStateId: CustomerStateID,
          CompanyStateId: CompanyStateID,
          TaxAmt: TaxAmt,
          CGSTPer: CGSTPer,
          CGSTAmt: CGSTAmt,
          SGSTPer: SGSTPer,
          SGSTAmt: SGSTAmt,
          IGSTPer: IGSTPer,
          IGSTAmt: IGSTAmt,
          NetRate: NetRate,
          BasicAmt: BasicAmt,
          NetAmt: NetAmt,
          ItmDiscPer1: ItmDiscPer1,
          ItmDiscAmt1: ItmDiscAmt1,
          AddTaxAmt: AddTaxAmt,
        );

        outqtTable.add(PurchaseBillTable(
            car.pkID, //pkID,
            car.InvoiceNo, //InvoiceNo,
            car.OrderNo, //OrderNo,
            car.ProductID,
            car.ProductName,
            car.ProductSpecification, //ProductSpecification,
            car.LocationID, //LocationID,
            car.TaxType, //TaxType,
            car.Qty,
            car.Rate,
            car.DiscountPer,
            car.DiscountAmt,
            car.NetRate,
            productoutparam.BasicAmt,
            productoutparam.CGSTPer,
            productoutparam.SGSTPer,
            productoutparam.IGSTPer,
            productoutparam.CGSTAmt,
            productoutparam.SGSTAmt,
            productoutparam.IGSTAmt,
            car.AddTaxPer, //AddTaxPer,
            productoutparam.TaxAmt,
            productoutparam.NetAmt,
            productoutparam.ItemHdDiscAmt, //HeaderDiscAmt,
            car.Unit, //Unit,
            car.StateCode,
            car.LoginUserID,
            car.CompanyId,
            id: car.id));
      });

      return outqtTable;
    } else {
      return null;
    }
  }

  static List<double> funCalculateTotal(
      double hdnOthChrgGST1,
      double hdnOthChrgGST2,
      double hdnOthChrgGST3,
      double hdnOthChrgGST4,
      double hdnOthChrgGST5,
      double hdnOthChrgBasic1,
      double hdnOthChrgBasic2,
      double hdnOthChrgBasic3,
      double hdnOthChrgBasic4,
      double hdnOthChrgBasic5,
      double hdnTotCGSTAmt,
      double hdnTotSGSTAmt,
      double hdnTotIGSTAmt,
      double txtTotBasicAmt,
      double NetAmount,
      double txtHeadDiscount,
      double Tot_otherChargeWithTax,
      Tot_otherChargeExcludeTax) {
    double hdnTotItemGST = hdnTotCGSTAmt + hdnTotSGSTAmt + hdnTotIGSTAmt;
    double txtTotGST = hdnTotItemGST +
        hdnOthChrgGST1 +
        hdnOthChrgGST2 +
        hdnOthChrgGST3 +
        hdnOthChrgGST4 +
        hdnOthChrgGST5;

    double NetAmt = 0;
    NetAmt = NetAmount +
        Tot_otherChargeWithTax +
        Tot_otherChargeExcludeTax +
        hdnOthChrgGST1 +
        hdnOthChrgGST2 +
        hdnOthChrgGST3 +
        hdnOthChrgGST4 +
        hdnOthChrgGST5 -
        txtHeadDiscount;

    double txtTotNetAmt = roundDouble(NetAmt, 0);
    double txtRoff = roundDouble(NetAmt, 0) - roundDouble(NetAmt, 2);

    List<double> addtional = [
      0,
      hdnTotItemGST,
      txtTotGST,
      0,
      txtTotNetAmt,
      txtRoff
    ];
    return addtional;
  }

  static List<PurchaseBillTable> txtHeadDiscount_WithZero(
      List<PurchaseBillTable> qtTable,
      double txtHeadDiscount,
      String CompanyStateID,
      String CustomerStateID) {
    List<PurchaseBillTable> outqtTable = [];

    double TotalAmt = 0;
    double HeaderDiscAmt = 0.00;
    double HeaderDiscItemWise = 0;
    if (qtTable != null) {
      qtTable.forEach((PurchaseBillTable car) {
        TotalAmt += car.NetAmt != null ? car.NetAmt : 0;
      });

      qtTable.forEach((PurchaseBillTable car) {
        HeaderDiscItemWise = 0;
        double a = car.NetAmt;
        int uq = 1;
        double q = car.Qty;
        double unitqty = 1;
        double ur = car.Rate;
        double dp = car.DiscountPer;
        double dpa = car.DiscountAmt;

        double tr = car.AddTaxPer;
        double at = 0;
        int taxtype = car.TaxType;
        HeaderDiscItemWise = (TotalAmt > 0)
            ? roundDouble(((HeaderDiscAmt * a) / TotalAmt), 2)
            : 0;
        double TaxAmt = 0;
        double CGSTPer = 0, CGSTAmt = 0;
        double SGSTPer = 0,
            SGSTAmt = 0,
            IGSTPer = 0,
            IGSTAmt = 0,
            NetRate = 0,
            BasicAmt = 0,
            NetAmt = 0,
            ItmDiscPer1 = 0,
            ItmDiscAmt1 = 0,
            AddTaxAmt = 0,
            HeadDiscAmt1 = 0;

        ProductCalculationModel productoutparam =
            productCalculation.funCalculateProduct(
          UnitQuantity: 1,
          TaxType: taxtype,
          Qty: q,
          Rate: ur,
          ItmDiscPer: dp,
          ItmDiscAmt: dpa,
          TaxPer: tr,
          AddTaxPer: at,
          HdDiscAmt: HeaderDiscItemWise,
          CustomerStateId: CustomerStateID,
          CompanyStateId: CompanyStateID,
          TaxAmt: TaxAmt,
          CGSTPer: CGSTPer,
          CGSTAmt: CGSTAmt,
          SGSTPer: SGSTPer,
          SGSTAmt: SGSTAmt,
          IGSTPer: IGSTPer,
          IGSTAmt: IGSTAmt,
          NetRate: NetRate,
          BasicAmt: BasicAmt,
          NetAmt: NetAmt,
          ItmDiscPer1: ItmDiscPer1,
          ItmDiscAmt1: ItmDiscAmt1,
          AddTaxAmt: AddTaxAmt,
        );

        outqtTable.add(PurchaseBillTable(
            car.pkID, //pkID,
            car.InvoiceNo, //InvoiceNo,
            car.OrderNo, //OrderNo,
            car.ProductID,
            car.ProductName,
            car.ProductSpecification, //ProductSpecification,
            car.LocationID, //LocationID,
            car.TaxType, //TaxType,
            car.Qty,
            car.Rate,
            car.DiscountPer,
            car.DiscountAmt,
            car.NetRate,
            productoutparam.BasicAmt,
            productoutparam.CGSTPer,
            productoutparam.SGSTPer,
            productoutparam.IGSTPer,
            productoutparam.CGSTAmt,
            productoutparam.SGSTAmt,
            productoutparam.IGSTAmt,
            car.AddTaxPer, //AddTaxPer,
            productoutparam.TaxAmt,
            productoutparam.NetAmt,
            productoutparam.ItemHdDiscAmt, //HeaderDiscAmt,
            car.Unit, //Unit,
            car.StateCode,
            car.LoginUserID,
            car.CompanyId,
            id: car.id));
      });

      return outqtTable;
    } else {
      return null;
    }
  }

  static List<double> funCalculateTotal_WithZero(
      double hdnOthChrgGST1,
      double hdnOthChrgGST2,
      double hdnOthChrgGST3,
      double hdnOthChrgGST4,
      double hdnOthChrgGST5,
      double hdnOthChrgBasic1,
      double hdnOthChrgBasic2,
      double hdnOthChrgBasic3,
      double hdnOthChrgBasic4,
      double hdnOthChrgBasic5,
      double hdnTotCGSTAmt,
      double hdnTotSGSTAmt,
      double hdnTotIGSTAmt,
      double txtTotBasicAmt,
      double NetAmount,
      double txtHeadDiscount,
      double Tot_otherChargeWithTax,
      Tot_otherChargeExcludeTax) {
    double hdnTotItemGST = hdnTotCGSTAmt + hdnTotSGSTAmt + hdnTotIGSTAmt;
    double txtTotGST = hdnTotItemGST +
        hdnOthChrgGST1 +
        hdnOthChrgGST2 +
        hdnOthChrgGST3 +
        hdnOthChrgGST4 +
        hdnOthChrgGST5;

    double NetAmt = 0;
    NetAmt = NetAmount +
        Tot_otherChargeWithTax +
        Tot_otherChargeExcludeTax +
        hdnOthChrgGST1 +
        hdnOthChrgGST2 +
        hdnOthChrgGST3 +
        hdnOthChrgGST4 +
        hdnOthChrgGST5 -
        txtHeadDiscount;

    double txtTotNetAmt = roundDouble(NetAmt, 0);
    double txtRoff = roundDouble(NetAmt, 0) - roundDouble(NetAmt, 2);

    List<double> addtional = [
      0,
      hdnTotItemGST,
      txtTotGST,
      0,
      txtTotNetAmt,
      txtRoff
    ];
    return addtional;
  }

  static double roundDouble(double value, int places) {
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }
}
