import 'dart:math';

import 'package:soleoserp/models/common/Short_Invoice_Table.dart';
import 'package:soleoserp/models/common/sales_order_table.dart';
import 'package:soleoserp/utils/calculation/model/product_calculation_model.dart';
import 'package:soleoserp/utils/calculation/product_calulation.dart';

class ShortInvoiceHeaderDiscountCalculation {
  static List<String> testmethod(double i, double j) {
    double sum = i + j;
    double multiplication = i * j;
    List<String> table = [sum.toString(), multiplication.toString()];

    return table;
  }

  static List<ShortInvoiceTable> txtHeadDiscount_TextChanged(
      List<ShortInvoiceTable> qtTable,
      double txtHeadDiscount,
      String CompanyStateID,
      String CustomerStateID) {
    List<ShortInvoiceTable> outqtTable = [];

    double TotalAmt = 0;
    double HeaderDiscAmt = txtHeadDiscount != null ? txtHeadDiscount : 0;
    double HeaderDiscItemWise = 0;
    if (qtTable != null) {
      qtTable.forEach((ShortInvoiceTable car) {
        TotalAmt += car.NetAmt != null ? car.NetAmt : 0;
      });

      qtTable.forEach((ShortInvoiceTable car) {
        HeaderDiscItemWise = 0;
        double a = car.NetAmt;
        double q = car.Qty;
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

        outqtTable.add(ShortInvoiceTable(
            car.pkID, //int pkID,
            car.InvoiceNo, //String InvoiceNo,
            car.DocRefNo, //String DocRefNo,
            car.ProductID, //int ProductID,
            car.ProductName, //String ProductName,
            car.ProductSpecification, //String ProductSpecification,
            car.LocationID, //int LocationID,
            car.TaxType, //int TaxType,
            car.PendingQty, //double PendingQty,
            car.UnitQty, //double UnitQty,
            car.Qty, //double Qty,
            car.Unit, //String Unit,
            car.Rate, //double Rate,
            car.DiscountPer, //double DiscountPer,
            car.DiscountAmt, //double DiscountAmt,
            car.NetRate, //double NetRate,
            productoutparam.BasicAmt, //double Amount,
            productoutparam.CGSTPer, //double CGSTPer,
            productoutparam.SGSTPer, //double SGSTPer,
            productoutparam.IGSTPer, //double IGSTPer,
            productoutparam.CGSTAmt, //double CGSTAmt,
            productoutparam.SGSTAmt, //double SGSTAmt,
            productoutparam.IGSTAmt, //double IGSTAmt,
            car.AddTaxPer, //double AddTaxPer,
            productoutparam.TaxAmt, //double AddTaxAmt,
            productoutparam.NetAmt, //double NetAmt,
            productoutparam.ItemHdDiscAmt, //double HeaderDiscAmt,
            car.ForOrderNo, //String ForOrderNo,
            car.NetWt, //String NetWt,
            car.BocNo, //String BocNo,
            car.GrossWt, //String GrossWt,
            car.StateCode, //String StateCode,
            car.LoginUserID, //String LoginUserID,
            car.CompanyId, //String CompanyId
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

  static List<ShortInvoiceTable> txtHeadDiscount_WithZero(
      List<ShortInvoiceTable> qtTable,
      double txtHeadDiscount,
      String CompanyStateID,
      String CustomerStateID) {
    List<ShortInvoiceTable> outqtTable = [];

    double TotalAmt = 0;
    double HeaderDiscAmt = 0.00;
    double HeaderDiscItemWise = 0;
    if (qtTable != null) {
      qtTable.forEach((ShortInvoiceTable car) {
        TotalAmt += car.NetAmt != null ? car.NetAmt : 0;
      });

      qtTable.forEach((ShortInvoiceTable car) {
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

        print("Amount1TEST" +
            " AmountP : " +
            productoutparam.BasicAmt.toString() +
            "  NetAmountP  : " +
            productoutparam.NetAmt.toString());
        outqtTable.add(ShortInvoiceTable(
            car.pkID, //int pkID,
            car.InvoiceNo, //String InvoiceNo,
            car.DocRefNo, //String DocRefNo,
            car.ProductID, //int ProductID,
            car.ProductName, //String ProductName,
            car.ProductSpecification, //String ProductSpecification,
            car.LocationID, //int LocationID,
            car.TaxType, //int TaxType,
            car.PendingQty, //double PendingQty,
            car.UnitQty, //double UnitQty,
            car.Qty, //double Qty,
            car.Unit, //String Unit,
            car.Rate, //double Rate,
            car.DiscountPer, //double DiscountPer,
            car.DiscountAmt, //double DiscountAmt,
            car.NetRate, //double NetRate,
            productoutparam.BasicAmt, //double Amount,
            productoutparam.CGSTPer, //double CGSTPer,
            productoutparam.SGSTPer, //double SGSTPer,
            productoutparam.IGSTPer, //double IGSTPer,
            productoutparam.CGSTAmt, //double CGSTAmt,
            productoutparam.SGSTAmt, //double SGSTAmt,
            productoutparam.IGSTAmt, //double IGSTAmt,
            car.AddTaxPer, //double AddTaxPer,
            productoutparam.TaxAmt, //double AddTaxAmt,
            productoutparam.NetAmt, //double NetAmt,
            productoutparam.ItemHdDiscAmt, //double HeaderDiscAmt,
            car.ForOrderNo, //String ForOrderNo,
            car.NetWt, //String NetWt,
            car.BocNo, //String BocNo,
            car.GrossWt, //String GrossWt,
            car.StateCode, //String StateCode,
            car.LoginUserID, //String LoginUserID,
            car.CompanyId, //String CompanyId
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
