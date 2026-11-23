# Menu walk baseline

Generated **2026-11-04T00:00:02.857Z** against `http://127.0.0.1:5177`.

Run duration **1352 s**; menu root class `m_entry`; **1477** menu nodes, **265** visible nodes, **1277** leaf nodes (16 separators, 1261 menu leaf items).

Every visible+enabled leaf was clicked through `window.__menu(path)` in menu order. The window was captured at 1920x1080, any message box was recorded and dismissed with No/Cancel/Close, then the sheet was closed through `rt.closeWindow` without saving, printing, posting or fiscalising anything.

## Summary

| Outcome | Count | Share of actionable |
|---|---:|---:|
| **Actionable leaves** (visible + enabled) | **210** | 100% |
| Opened OK (new window, no modal) | 193 | 91.9% |
| Opened with modal message(s) | 7 | 3.3% |
| No window | 1 | 0.5% |
| Failed / exception | 2 | 1.0% |
| Skipped by safety policy | 7 | 3.3% |
| Not run (time budget) | 0 | 0.0% |
| **Screens with a window/DOM view still open after close** | **3** | 1.4% |
| Click handlers still pending after close (warning) | 56 | 26.7% |

| Menu tree | Count |
|---|---:|
| Leaf nodes (all, including separators) | 1277 |
| Separators | 16 |
| Menu leaf items | 1261 |
| Visible menu nodes | 265 |
| Hidden / disabled leaves | 1051 |
| Visible but disabled leaves | 1 |
| Hidden leaves | 1050 |

> The walk recovered the browser **8** time(s) after a screen stopped responding; the affected item is marked failed and the walk continued with the next one.

## Failures / exceptions

| # | Caption path | Window class | Reason | Modal / error | Screenshot |
|---:|---|---|---|---|---|
| 1106 | Maintenance \| Godown Preferences \| Group Wise Godown Setting | `w_arg_group` | click threw: PBRuntimeError: Null object reference (reading l_code1) at Runtime.getMember (http://127.0.0.1:5… |  | [png](menu-walk/1106_Maintenance_Godown_Preferences_Group_Wise_Godown_Setting__w_arg_group.png) |
| 1182 | Manage \| Group Wise Header Setting | `w_arg_group` | click threw: PBRuntimeError: Null object reference (reading l_code1) at Runtime.getMember (http://127.0.0.1:5… |  | [png](menu-walk/1182_Manage_Group_Wise_Header_Setting__w_arg_group.png) |

## No window

| # | Caption path | Click result | Message / last status |
|---:|---|---|---|
| 1213 | Manage \| Cashier Management \| Cashier Activity Window | true (__menu) | Unable to fetch cashier job data from database \|\| [close] Unable to fetch cashier job data from database |

## Windows left open after close

`rt.closeWindow` returned but these screens still had a window or a DOM view afterwards. The next item was still measured from a fresh before/after snapshot, but the leak is a rebuild finding in itself.

| # | Caption path | Window class | Remaining / views |
|---:|---|---|---|
| 1206 | Manage \| Session Monitor Ctrl+Alt+M | `w_salesmanpassword` | w_salesmanpassword |
| 1212 | Manage \| Cashier Management \| Cashier Job | `w_salesmanpassword` | w_salesmanpassword |
| 1213 | Manage \| Cashier Management \| Cashier Activity Window | `w_salesmanpassword` | w_salesmanpassword |

## Click handler still pending after close

`window.__menu` returned from the click but its event handler was still waiting after `rt.closeWindow` had closed the screen. The page stayed responsive; the item is counted by what it opened (and flagged here).

| # | Caption path | Outcome | Window class |
|---:|---|---|---|
| 110 | Reports \| Daily Reports \| Sale \| Sale detail | opened_ok | `w_reviewreport`, `w_selectformat_dailysaledetail` |
| 111 | Reports \| Daily Reports \| Sale \| Sale summary | opened_ok | `w_reviewreport`, `w_selectformat_dailysalessummary` |
| 114 | Reports \| Daily Reports \| Sale \| Sale Summary Inv. Cust Wise | opened_ok | `w_reviewreport`, `w_arg_sinvcode_linvcode_onecust_netamt` |
| 115 | Reports \| Daily Reports \| Sale \| Sale Detail Inv. Wise | opened_ok | `w_reviewreport`, `w_arg_sinvcode_linvcode_saletype_spres_h` |
| 119 | Reports \| Daily Reports \| Sale \| Sale Detail (Format 2) | opened_ok | `w_reviewreport`, `w_arg_sale_sdate_ldate` |
| 121 | Reports \| Daily Reports \| Sale \| Refused Sales Detail | opened_ok | `w_reviewreport`, `w_arg_sdate_ldate` |
| 122 | Reports \| Daily Reports \| Sale \| Sale Detail Inv. Wise(with diff.col.) | opened_ok | `w_reviewreport`, `w_selectformat_dailysaledetail_pricediff` |
| 130 | Reports \| Daily Reports \| Sales Return \| Sales Return detail | opened_ok | `w_reviewreport`, `w_selectformat_1_2` |
| 131 | Reports \| Daily Reports \| Sales Return \| Sales Return summary | opened_ok | `w_reviewreport`, `w_arg_sale_return_sdate_ldate` |
| 137 | Reports \| Daily Reports \| Purchase \| Purchase detail | opened_ok | `w_reviewreport`, `w_arg_sdate_ldate` |
| 138 | Reports \| Daily Reports \| Purchase \| Purchase summary | opened_ok | `w_reviewreport`, `w_arg_sdate_ldate` |
| 142 | Reports \| Daily Reports \| Purchase Return \| Purchase Return summary | opened_ok | `w_reviewreport`, `w_arg_sdate_ldate` |
| 160 | Reports \| Daily Reports \| Adjustment \| Adjustment Summary/Detail | opened_ok | `w_reviewreport`, `w_selection_manf_cat_class_packing2` |
| 180 | Reports \| Daily Reports \| Purchase Order \| Purchase Order Summary | opened_ok | `w_reviewreport`, `w_arg_sdate_ldate` |
| 187 | Reports \| Stock Reports \| Stock In hand \| Manufacturer wise | opened_ok | `w_reviewreport`, `w_selectformat_stockinhand_manf` |
| 190 | Reports \| Stock Reports \| Stock In hand \| Class Wise | opened_ok | `w_reviewreport`, `w_selectformat_stock_classwise_godown` |
| 204 | Reports \| Stock Reports \| Stock In hand \| Supplier Manufacturer Association | opened_ok | `w_reviewreport`, `w_arg_supp_stock` |
| 205 | Reports \| Stock Reports \| Stock In hand \| Stock Quantity Format | opened_ok | `w_reviewreport`, `w_selection_manf_cat_class_packing` |
| 211 | Reports \| Stock Reports \| Expiry Report | opened_ok | `w_reviewreport`, `w_selectformat_expiryreport` |
| 219 | Reports \| Stock Reports \| Stock Register(For Narcotics) | opened_ok | `w_reviewreport`, `w_selectformat_1_3` |
| 228 | Reports \| Stock Reports \| Item Activity | opened_ok | `w_reviewreport`, `w_selectformat_itemactivity` |
| 230 | Reports \| Stock Reports \| Stock Register(Narcotics Format2) | opened_ok | `w_reviewreport`, `w_selectformat_1_5` |
| 234 | Reports \| Stock Reports \| Reorder/Optimum Level Report | opened_ok | `w_reviewreport`, `w_selectformat_1_3` |
| 236 | Reports \| Stock Reports \| Stock IN/OUT(Date Wise) | opened_ok | `w_reviewreport`, `w_selectformat_cat_1_or_n` |
| 250 | Reports \| Sales Reports \| Customer Sales \| Days Summary | opened_ok | `w_reviewreport`, `w_arg_customers_sdate_ldate_v5` |
| 253 | Reports \| Sales Reports \| Customer Sales \| Invoice Wise Profit Margin Detail | opened_ok | `w_reviewreport`, `w_select_invprofitmargin` |
| 254 | Reports \| Sales Reports \| Customer Sales \| Items Summary | opened_ok | `w_reviewreport`, `w_arg_cust_sdate_ldate` |
| 296 | Reports \| Sales Reports \| Customer Sales \| Monthly Net Sales | opened_ok | `w_reviewreport`, `w_arg_sdate_ldate` |
| 322 | Reports \| Sales Reports \| Category Wise \| Gross Profit | opened_ok | `w_reviewreport`, `w_selectformat_catwise_grossprofit` |
| 339 | Reports \| Sales Reports \| Manufacturer Wise \| Sales | opened_ok | `w_reviewreport`, `w_arg_manufacturers_returnoptions` |
| 343 | Reports \| Sales Reports \| Manufacturer Wise \| Sales Detail And Summary | opened_ok | `w_reviewreport`, `w_selectformat_customer_manf_sales` |
| 370 | Reports \| Sales Reports \| User Wise \| Sales | opened_ok | `w_reviewreport`, `w_selectformat_1_4` |
| 371 | Reports \| Sales Reports \| User Wise \| Category Summary | opened_ok | `w_reviewreport`, `w_arg_user_sdate_ldate` |
| 375 | Reports \| Sales Reports \| User Wise \| Net Cash | opened_ok | `w_reviewreport`, `w_arg_user_sdate_ldate` |
| 376 | Reports \| Sales Reports \| User Wise \| Sales Commission | opened_ok | `w_reviewreport`, `w_arg_users_sdate_ldate` |
| 431 | Reports \| Sales Reports \| Slow/Fast moving Items | opened_ok | `w_reviewreport`, `w_selection_manf_cat_class_packing` |
| 435 | Reports \| Sales Reports \| Net Sale Summary | opened_ok | `w_reviewreport`, `w_arg_sdate_ldate`, `w_selectformat_slowfastmoving` |
| 439 | Reports \| Sales Reports \| Item Wise \| Item Sale and Return Activity | opened_ok | `w_reviewreport`, `w_arg_items_sdate_ldate` |
| 442 | Reports \| Sales Reports \| Item Wise \| Item Wise Net Sales | opened_ok | `w_reviewreport`, `w_selectformat_item_netsales` |
| 460 | Reports \| Sales Reports \| Sale/Return Summary Inv. Type Wise | opened_ok | `w_reviewreport`, `w_selectformat_saleinvtypewisereport` |
| 471 | Reports \| Sales Reports \| Dead Item List | opened_ok | `w_reviewreport`, `w_selection_manf_cat_class_packing` |
| 477 | Reports \| Purchase Reports \| Periodic Purchases | opened_with_modal | `w_reviewreport`, `w_arg_sdate_ldate` |
| 479 | Reports \| Purchase Reports \| Purchase Order | opened_ok | `w_reviewreport`, `w_selectformat_datewise_invwise` |
| 481 | Reports \| Purchase Reports \| Supplier Wise \| Purchase Detail | opened_ok | `w_reviewreport`, `w_arg_supplier_all` |
| 487 | Reports \| Purchase Reports \| Manufacturer Wise \| Detail | opened_ok | `w_reviewreport`, `w_selectformat_1_2` |
| 490 | Reports \| Purchase Reports \| Category Wise Purchase | opened_ok | `w_reviewreport`, `w_selectformat_cat_purchase` |
| 504 | Reports \| Purchase Reports \| Net Purchase Summary | opened_ok | `w_reviewreport`, `w_selectformat_netpursummary` |
| 522 | Reports \| Accounts Reports \| Ledger Reports \| Accounts Ledger | opened_ok | `w_reviewreport` |
| 691 | Reports \| Item Reports \| History \| Sale Price Difference | opened_ok | `w_reviewreport`, `w_arg_category_sdate_ldate` |
| 692 | Reports \| Item Reports \| History \| Item Basic Data Changes | opened_ok | `w_reviewreport` |
| 693 | Reports \| Item Reports \| History \| Item Sale Price Changes | opened_ok | `w_reviewreport` |
| 722 | Reports \| Purchase Return Reports \| Supplier Purchase Returns \| Detail | opened_ok | `w_reviewreport`, `w_selectformat_1_2` |
| 1099 | Maintenance \| Change Item Discount | opened_ok | `w_select_changediscmethod` |
| 1100 | Maintenance \| Modify Sale Invoices | opened_ok | `w_selectformat_period_invrange` |
| 1206 | Manage \| Session Monitor Ctrl+Alt+M | opened_ok | `w_connectionmonitor`, `w_salesmanpassword` |
| 1231 | Manage \| Job Schedule | opened_ok | `w_job_schedule` |

## Opened with a modal message

These screens showed at least one message box while opening (close-query prompts are not counted).

| # | Caption path | Window class | Message |
|---:|---|---|---|
| 162 | Reports \| Daily Reports \| Quotation \| Detail | `w_reviewreport`, `w_arg_sdate_ldate` | Null object reference (writing s_name1) (in f_retrieve_report6.f_retrieve_report6.f_retrieve_report6) |
| 208 | Reports \| Stock Reports \| Stock In hand \| Stock in Hand - Audit Purpose | `w_reviewreport` | Null object reference (reading i_status) (in f_retrieve_report6.f_retrieve_report6.f_retrieve_report6) |
| 212 | Reports \| Stock Reports \| Reorder Level Report | `w_reviewreport`, `w_selection_manf_cat_class_packing`, `w_arg_manfs_cats_classes_packs_days` | Not a DataWindowChild |
| 213 | Reports \| Stock Reports \| Stock Register | `w_reviewreport`, `w_arg_items_sdate_ldate_stockregister` | Null object reference (writing s_name7) (in f_retrieve_report.f_retrieve_report.f_retrieve_report) |
| 354 | Reports \| Sales Reports \| Manufacturer Wise \| CNIC/NTN Registered Customers Sales | `w_reviewreport` | Null object reference (reading i_status) (in f_retrieve_report6.f_retrieve_report6.f_retrieve_report6) |
| 477 | Reports \| Purchase Reports \| Periodic Purchases | `w_reviewreport`, `w_arg_sdate_ldate` | Null object reference (reading i_status) (in f_retrieve_report7.f_retrieve_report7.f_retrieve_report7) |
| 598 | Reports \| Listing \| Supplier List | `w_reviewreport` | Null object reference (reading i_status) (in f_retrieve_report1.f_retrieve_report1.f_retrieve_report1) |

## Top page / console / SQL / application messages

| # | Type | Message | Count | First seen at |
|---:|---|---|---:|---|
| 1 | console | PBRuntimeError: Null object reference (reading i_status) at Runtime.getMember (http://N.N:N/src/runtime/interp.js:N:N) at Runtime.eval (http://N.N:N/src/runtime/interp.js:N:N) at async Runtime.evalBi… | 5 | (startup / between items) |
| 2 | modal | Null object reference (reading i_status) (in f_retrieve_report6.f_retrieve_report6.f_retrieve_report6) | 2 | Reports \| Stock Reports \| Stock In hand \| Stock in Hand - Audit Purpose |
| 3 | modal | Not a DataWindowChild | 1 | Reports \| Stock Reports \| Reorder Level Report |
| 4 | modal | Null object reference (reading i_status) (in f_retrieve_report1.f_retrieve_report1.f_retrieve_report1) | 1 | Reports \| Listing \| Supplier List |
| 5 | modal | Null object reference (reading i_status) (in f_retrieve_report7.f_retrieve_report7.f_retrieve_report7) | 1 | Reports \| Purchase Reports \| Periodic Purchases |
| 6 | modal | Null object reference (writing s_name1) (in f_retrieve_report6.f_retrieve_report6.f_retrieve_report6) | 1 | Reports \| Daily Reports \| Quotation \| Detail |
| 7 | modal | Null object reference (writing s_name7) (in f_retrieve_report.f_retrieve_report.f_retrieve_report) | 1 | Reports \| Stock Reports \| Stock Register |
| 8 | console | PBRuntimeError: Null object reference (writing s_name1) at Runtime.assign (http://N.N:N/src/runtime/interp.js:N:N) at async Runtime.exec (http://N.N:N/src/runtime/interp.js:N:N) at async Runtime.exec… | 1 | Reports \| Daily Reports \| Adjustment \| Item Wise Adjustment Summary |
| 9 | console | PBRuntimeError: Null object reference (writing s_name7) at Runtime.assign (http://N.N:N/src/runtime/interp.js:N:N) at async Runtime.exec (http://N.N:N/src/runtime/interp.js:N:N) at async Runtime.exec… | 1 | Reports \| Stock Reports \| Reorder Level Report |
| 10 | modal | Unable to fetch cashier job data from database | 1 | Manage \| Cashier Management \| Cashier Activity Window |

## Item evidence

All actionable leaves, in walk order. Screenshot links are relative to `deploy/parity/`.

| # | Caption path | Outcome | Window class(es) | Messages (open/close) | ms | Screenshot |
|---:|---|---|---|---|---:|---|
| 1 | File \| Change User | skipped | - |  |  | - |
| 3 | File \| Exit Ctrl+X | skipped | - |  |  | - |
| 7 | Purchase \| Purchases | opened_ok | `w_purchase` | [close] Do You want to save changes | 1462 | [1](menu-walk/007_Purchase_Purchases__w_purchase.png) |
| 8 | Purchase \| Purchase Return | opened_ok | `w_purchasereturn` | [close] Do You want to save changes | 1798 | [1](menu-walk/008_Purchase_Purchase_Return__w_purchasereturn.png) |
| 9 | Purchase \| Opening Purchase | opened_ok | `w_purchase` | [close] Do You want to save changes | 1260 | [1](menu-walk/009_Purchase_Opening_Purchase__w_purchase.png) |
| 11 | Purchase \| Purchases (Loose) | opened_ok | `w_purchase` | [close] Do You want to save changes | 2044 | [1](menu-walk/011_Purchase_Purchases_%28Loose%29__w_purchase.png) |
| 17 | Purchase \| Purchase Orders | opened_ok | `w_purchaseorder` | [close] Do You want to save changes | 1421 | [1](menu-walk/017_Purchase_Purchase_Orders__w_purchaseorder.png) |
| 35 | Sales \| CashSale | opened_ok | `w_sale` | [close] Do You want to save changes | 2349 | [1](menu-walk/035_Sales_CashSale__w_sale.png) |
| 36 | Sales \| Credit Sale | opened_ok | `w_sale` | [close] Do You want to save changes | 3368 | [1](menu-walk/036_Sales_Credit_Sale__w_sale.png) |
| 38 | Sales \| Sale Return \| Cash Sale Return | opened_ok | `w_salereturn` | [close] Do You want to save changes | 1065 | [1](menu-walk/038_Sales_Sale_Return_Cash_Sale_Return__w_salereturn.png) |
| 39 | Sales \| Sale Return \| Credit Sale Return | opened_ok | `w_salereturn` | [close] Do You want to save changes | 1212 | [1](menu-walk/039_Sales_Sale_Return_Credit_Sale_Return__w_salereturn.png) |
| 40 | Sales \| Open Sale Return \| Cash Sale Return | opened_ok | `w_salereturn` | [close] Do You want to save changes | 1202 | [1](menu-walk/040_Sales_Open_Sale_Return_Cash_Sale_Return__w_salereturn.png) |
| 41 | Sales \| Open Sale Return \| Credit Sale Return | opened_ok | `w_salereturn` | [close] Do You want to save changes | 1195 | [1](menu-walk/041_Sales_Open_Sale_Return_Credit_Sale_Return__w_salereturn.png) |
| 44 | Sales \| Quotation | opened_ok | `w_quotation` | [close] Do You want to save changes | 1356 | [1](menu-walk/044_Sales_Quotation__w_quotation.png) |
| 79 | Sales \| Refused Sales | opened_ok | `w_refusedsales` | [close] Do You want to save changes | 1047 | [1](menu-walk/079_Sales_Refused_Sales__w_refusedsales.png) |
| 110 | Reports \| Daily Reports \| Sale \| Sale detail | opened_ok * | `w_reviewreport`, `w_selectformat_dailysaledetail` |  | 6184 | [1](menu-walk/110_Reports_Daily_Reports_Sale_Sale_detail__w_reviewreport.png) [2](menu-walk/110_Reports_Daily_Reports_Sale_Sale_detail__w_selectformat_dailysaledetail.png) |
| 111 | Reports \| Daily Reports \| Sale \| Sale summary | opened_ok * | `w_reviewreport`, `w_selectformat_dailysalessummary` |  | 6165 | [1](menu-walk/111_Reports_Daily_Reports_Sale_Sale_summary__w_reviewreport.png) [2](menu-walk/111_Reports_Daily_Reports_Sale_Sale_summary__w_selectformat_dailysalessummary.png) |
| 112 | Reports \| Daily Reports \| Sale \| Sale Summary Inv. Wise | opened_ok | `w_reviewreport`, `w_arg_sinvcode_linvcode` |  | 6287 | [1](menu-walk/112_Reports_Daily_Reports_Sale_Sale_Summary_Inv._Wise__w_reviewreport.png) [2](menu-walk/112_Reports_Daily_Reports_Sale_Sale_Summary_Inv._Wise__w_arg_sinvcode_linvcode.png) |
| 114 | Reports \| Daily Reports \| Sale \| Sale Summary Inv. Cust Wise | opened_ok * | `w_reviewreport`, `w_arg_sinvcode_linvcode_onecust_netamt` |  | 6706 | [1](menu-walk/114_Reports_Daily_Reports_Sale_Sale_Summary_Inv._Cust_Wise__w_reviewreport.png) [2](menu-walk/114_Reports_Daily_Reports_Sale_Sale_Summary_Inv._Cust_Wise__w_arg_sinvcode_linvcode_onecust_netamt.png) |
| 115 | Reports \| Daily Reports \| Sale \| Sale Detail Inv. Wise | opened_ok * | `w_reviewreport`, `w_arg_sinvcode_linvcode_saletype_spres_h` |  | 6402 | [1](menu-walk/115_Reports_Daily_Reports_Sale_Sale_Detail_Inv._Wise__w_reviewreport.png) [2](menu-walk/115_Reports_Daily_Reports_Sale_Sale_Detail_Inv._Wise__w_arg_sinvcode_linvcode_saletype_spres_h.png) |
| 119 | Reports \| Daily Reports \| Sale \| Sale Detail (Format 2) | opened_ok * | `w_reviewreport`, `w_arg_sale_sdate_ldate` |  | 6259 | [1](menu-walk/119_Reports_Daily_Reports_Sale_Sale_Detail_%28Format_2%29__w_reviewreport.png) [2](menu-walk/119_Reports_Daily_Reports_Sale_Sale_Detail_%28Format_2%29__w_arg_sale_sdate_ldate.png) |
| 121 | Reports \| Daily Reports \| Sale \| Refused Sales Detail | opened_ok * | `w_reviewreport`, `w_arg_sdate_ldate` |  | 6604 | [1](menu-walk/121_Reports_Daily_Reports_Sale_Refused_Sales_Detail__w_reviewreport.png) [2](menu-walk/121_Reports_Daily_Reports_Sale_Refused_Sales_Detail__w_arg_sdate_ldate.png) |
| 122 | Reports \| Daily Reports \| Sale \| Sale Detail Inv. Wise(with diff.col.) | opened_ok * | `w_reviewreport`, `w_selectformat_dailysaledetail_pricediff` |  | 6499 | [1](menu-walk/122_Reports_Daily_Reports_Sale_Sale_Detail_Inv._Wise%28with_diff.col.%29__w_reviewreport.png) [2](menu-walk/122_Reports_Daily_Reports_Sale_Sale_Detail_Inv._Wise%28with_diff.col.%29__w_selectformat_dailysaledetail_pricediff.png) |
| 123 | Reports \| Daily Reports \| Sale \| Sale Summary - Invoice Wise | opened_ok | `w_reviewreport`, `w_arg_sinvcode_linvcode_gstperc_date` |  | 6546 | [1](menu-walk/123_Reports_Daily_Reports_Sale_Sale_Summary_-_Invoice_Wise__w_reviewreport.png) [2](menu-walk/123_Reports_Daily_Reports_Sale_Sale_Summary_-_Invoice_Wise__w_arg_sinvcode_linvcode_gstperc_date.png) |
| 128 | Reports \| Daily Reports \| Sale \| Sale Summary Machine and Invoice Range Wise | opened_ok | `w_reviewreport` |  | 1047 | [1](menu-walk/128_Reports_Daily_Reports_Sale_Sale_Summary_Machine_and_Invoice_Range_Wise__w_reviewreport.png) |
| 129 | Reports \| Daily Reports \| Sale \| Selected Sales and Summaries Report | opened_ok | `w_reviewreport` |  | 1126 | [1](menu-walk/129_Reports_Daily_Reports_Sale_Selected_Sales_and_Summaries_Report__w_reviewreport.png) |
| 130 | Reports \| Daily Reports \| Sales Return \| Sales Return detail | opened_ok * | `w_reviewreport`, `w_selectformat_1_2` |  | 6455 | [1](menu-walk/130_Reports_Daily_Reports_Sales_Return_Sales_Return_detail__w_reviewreport.png) [2](menu-walk/130_Reports_Daily_Reports_Sales_Return_Sales_Return_detail__w_selectformat_1_2.png) |
| 131 | Reports \| Daily Reports \| Sales Return \| Sales Return summary | opened_ok * | `w_reviewreport`, `w_arg_sale_return_sdate_ldate` |  | 6210 | [1](menu-walk/131_Reports_Daily_Reports_Sales_Return_Sales_Return_summary__w_reviewreport.png) [2](menu-walk/131_Reports_Daily_Reports_Sales_Return_Sales_Return_summary__w_arg_sale_return_sdate_ldate.png) |
| 132 | Reports \| Daily Reports \| Sales Return \| Sales Return Summary Inv.wise | opened_ok | `w_reviewreport`, `w_arg_sinvcode_linvcode_srtype` |  | 6153 | [1](menu-walk/132_Reports_Daily_Reports_Sales_Return_Sales_Return_Summary_Inv.wise__w_reviewreport.png) [2](menu-walk/132_Reports_Daily_Reports_Sales_Return_Sales_Return_Summary_Inv.wise__w_arg_sinvcode_linvcode_srtype.png) |
| 133 | Reports \| Daily Reports \| Sales Return \| Sales Return Detail Inv.wise | opened_ok | `w_reviewreport`, `w_arg_sinvcode_linvcode` |  | 6265 | [1](menu-walk/133_Reports_Daily_Reports_Sales_Return_Sales_Return_Detail_Inv.wise__w_reviewreport.png) [2](menu-walk/133_Reports_Daily_Reports_Sales_Return_Sales_Return_Detail_Inv.wise__w_arg_sinvcode_linvcode.png) |
| 137 | Reports \| Daily Reports \| Purchase \| Purchase detail | opened_ok * | `w_reviewreport`, `w_arg_sdate_ldate` |  | 6283 | [1](menu-walk/137_Reports_Daily_Reports_Purchase_Purchase_detail__w_reviewreport.png) [2](menu-walk/137_Reports_Daily_Reports_Purchase_Purchase_detail__w_arg_sdate_ldate.png) |
| 138 | Reports \| Daily Reports \| Purchase \| Purchase summary | opened_ok * | `w_reviewreport`, `w_arg_sdate_ldate` |  | 6110 | [1](menu-walk/138_Reports_Daily_Reports_Purchase_Purchase_summary__w_reviewreport.png) [2](menu-walk/138_Reports_Daily_Reports_Purchase_Purchase_summary__w_arg_sdate_ldate.png) |
| 139 | Reports \| Daily Reports \| Purchase \| Purchase Summary2 | opened_ok | `w_reviewreport`, `w_arg_sdate_ldate` |  | 6200 | [1](menu-walk/139_Reports_Daily_Reports_Purchase_Purchase_Summary2__w_reviewreport.png) [2](menu-walk/139_Reports_Daily_Reports_Purchase_Purchase_Summary2__w_arg_sdate_ldate.png) |
| 141 | Reports \| Daily Reports \| Purchase Return \| Purchase Return detail | opened_ok | `w_reviewreport`, `w_arg_sdate_ldate` |  | 6204 | [1](menu-walk/141_Reports_Daily_Reports_Purchase_Return_Purchase_Return_detail__w_reviewreport.png) [2](menu-walk/141_Reports_Daily_Reports_Purchase_Return_Purchase_Return_detail__w_arg_sdate_ldate.png) |
| 142 | Reports \| Daily Reports \| Purchase Return \| Purchase Return summary | opened_ok * | `w_reviewreport`, `w_arg_sdate_ldate` |  | 6243 | [1](menu-walk/142_Reports_Daily_Reports_Purchase_Return_Purchase_Return_summary__w_reviewreport.png) [2](menu-walk/142_Reports_Daily_Reports_Purchase_Return_Purchase_Return_summary__w_arg_sdate_ldate.png) |
| 155 | Reports \| Daily Reports \| Adjustment \| Adjustment Summary | opened_ok | `w_reviewreport`, `w_arg_sdate_ldate_adj` |  | 6500 | [1](menu-walk/155_Reports_Daily_Reports_Adjustment_Adjustment_Summary__w_reviewreport.png) [2](menu-walk/155_Reports_Daily_Reports_Adjustment_Adjustment_Summary__w_arg_sdate_ldate_adj.png) |
| 156 | Reports \| Daily Reports \| Adjustment \| Adjustment Detail | opened_ok | `w_reviewreport`, `w_arg_sdate_ldate_adj` |  | 6305 | [1](menu-walk/156_Reports_Daily_Reports_Adjustment_Adjustment_Detail__w_reviewreport.png) [2](menu-walk/156_Reports_Daily_Reports_Adjustment_Adjustment_Detail__w_arg_sdate_ldate_adj.png) |
| 158 | Reports \| Daily Reports \| Adjustment \| Adjustment Summary Inv. Wise | opened_ok | `w_reviewreport`, `w_arg_sinvcode_linvcode_adjtype` |  | 6502 | [1](menu-walk/158_Reports_Daily_Reports_Adjustment_Adjustment_Summary_Inv._Wise__w_reviewreport.png) [2](menu-walk/158_Reports_Daily_Reports_Adjustment_Adjustment_Summary_Inv._Wise__w_arg_sinvcode_linvcode_adjtype.png) |
| 159 | Reports \| Daily Reports \| Adjustment \| Adjustment Detail Inv. wise | opened_ok | `w_reviewreport`, `w_arg_sinvcode_linvcode_adjtype` |  | 6393 | [1](menu-walk/159_Reports_Daily_Reports_Adjustment_Adjustment_Detail_Inv._wise__w_reviewreport.png) [2](menu-walk/159_Reports_Daily_Reports_Adjustment_Adjustment_Detail_Inv._wise__w_arg_sinvcode_linvcode_adjtype.png) |
| 160 | Reports \| Daily Reports \| Adjustment \| Adjustment Summary/Detail | opened_ok * | `w_reviewreport`, `w_selection_manf_cat_class_packing2` |  | 6972 | [1](menu-walk/160_Reports_Daily_Reports_Adjustment_Adjustment_Summary_Detail__w_reviewreport.png) [2](menu-walk/160_Reports_Daily_Reports_Adjustment_Adjustment_Summary_Detail__w_selection_manf_cat_class_packing2.png) |
| 161 | Reports \| Daily Reports \| Adjustment \| Item Wise Adjustment Summary | opened_ok | `w_selectformat_summary_detail_adj`, `w_reviewreport`, `w_arg_sinv_linv_manf_cat_class_pack` |  | 6925 | [1](menu-walk/161_Reports_Daily_Reports_Adjustment_Item_Wise_Adjustment_Summary__w_selectformat_summary_detail_adj.png) [2](menu-walk/161_Reports_Daily_Reports_Adjustment_Item_Wise_Adjustment_Summary__w_reviewreport.png) [3](menu-walk/161_Reports_Daily_Reports_Adjustment_Item_Wise_Adjustment_Summary__w_arg_sinv_linv_manf_cat_class_pack.png) |
| 162 | Reports \| Daily Reports \| Quotation \| Detail | opened_with_modal | `w_reviewreport`, `w_arg_sdate_ldate` | Null object reference (writing s_name1) (in f_retrieve_report6.f_retrieve_report6.f_retrieve_report6) \|\| [clo… | 6802 | [1](menu-walk/162_Reports_Daily_Reports_Quotation_Detail__modal.png) [2](menu-walk/162_Reports_Daily_Reports_Quotation_Detail__w_reviewreport.png) [3](menu-walk/162_Reports_Daily_Reports_Quotation_Detail__w_arg_sdate_ldate.png) |
| 163 | Reports \| Daily Reports \| Quotation \| Summary | opened_ok | `w_reviewreport`, `w_arg_sdate_ldate` |  | 6287 | [1](menu-walk/163_Reports_Daily_Reports_Quotation_Summary__w_reviewreport.png) [2](menu-walk/163_Reports_Daily_Reports_Quotation_Summary__w_arg_sdate_ldate.png) |
| 179 | Reports \| Daily Reports \| Header Wise Transaction Summary | opened_ok | `w_reviewreport` |  | 1266 | [1](menu-walk/179_Reports_Daily_Reports_Header_Wise_Transaction_Summary__w_reviewreport.png) |
| 180 | Reports \| Daily Reports \| Purchase Order \| Purchase Order Summary | opened_ok * | `w_reviewreport`, `w_arg_sdate_ldate` |  | 6450 | [1](menu-walk/180_Reports_Daily_Reports_Purchase_Order_Purchase_Order_Summary__w_reviewreport.png) [2](menu-walk/180_Reports_Daily_Reports_Purchase_Order_Purchase_Order_Summary__w_arg_sdate_ldate.png) |
| 187 | Reports \| Stock Reports \| Stock In hand \| Manufacturer wise | opened_ok * | `w_reviewreport`, `w_selectformat_stockinhand_manf` |  | 7064 | [1](menu-walk/187_Reports_Stock_Reports_Stock_In_hand_Manufacturer_wise__w_reviewreport.png) [2](menu-walk/187_Reports_Stock_Reports_Stock_In_hand_Manufacturer_wise__w_selectformat_stockinhand_manf.png) |
| 188 | Reports \| Stock Reports \| Stock In hand \| Category wise | opened_ok | `w_reviewreport`, `w_selectformat_stockinhand_categorywise` |  | 6787 | [1](menu-walk/188_Reports_Stock_Reports_Stock_In_hand_Category_wise__w_reviewreport.png) [2](menu-walk/188_Reports_Stock_Reports_Stock_In_hand_Category_wise__w_selectformat_stockinhand_categorywise.png) |
| 189 | Reports \| Stock Reports \| Stock In hand \| Others | opened_ok | `w_stock_filter` |  | 7356 | [1](menu-walk/189_Reports_Stock_Reports_Stock_In_hand_Others__w_stock_filter.png) |
| 190 | Reports \| Stock Reports \| Stock In hand \| Class Wise | opened_ok * | `w_reviewreport`, `w_selectformat_stock_classwise_godown` |  | 6831 | [1](menu-walk/190_Reports_Stock_Reports_Stock_In_hand_Class_Wise__w_reviewreport.png) [2](menu-walk/190_Reports_Stock_Reports_Stock_In_hand_Class_Wise__w_selectformat_stock_classwise_godown.png) |
| 193 | Reports \| Stock Reports \| Stock In hand \| Back Date | opened_ok | `w_reviewreport`, `w_selectstockreport_inbackdate` |  | 6815 | [1](menu-walk/193_Reports_Stock_Reports_Stock_In_hand_Back_Date__w_reviewreport.png) [2](menu-walk/193_Reports_Stock_Reports_Stock_In_hand_Back_Date__w_selectstockreport_inbackdate.png) |
| 198 | Reports \| Stock Reports \| Stock In hand \| Manufacturer Wise (Format2) | opened_ok | `w_reviewreport`, `w_arg_manufacturers_v3` |  | 7088 | [1](menu-walk/198_Reports_Stock_Reports_Stock_In_hand_Manufacturer_Wise_%28Format2%29__w_reviewreport.png) [2](menu-walk/198_Reports_Stock_Reports_Stock_In_hand_Manufacturer_Wise_%28Format2%29__w_arg_manufacturers_v3.png) |
| 204 | Reports \| Stock Reports \| Stock In hand \| Supplier Manufacturer Association | opened_ok * | `w_reviewreport`, `w_arg_supp_stock` |  | 7277 | [1](menu-walk/204_Reports_Stock_Reports_Stock_In_hand_Supplier_Manufacturer_Association__w_reviewreport.png) [2](menu-walk/204_Reports_Stock_Reports_Stock_In_hand_Supplier_Manufacturer_Association__w_arg_supp_stock.png) |
| 205 | Reports \| Stock Reports \| Stock In hand \| Stock Quantity Format | opened_ok * | `w_reviewreport`, `w_selection_manf_cat_class_packing` |  | 6294 | [1](menu-walk/205_Reports_Stock_Reports_Stock_In_hand_Stock_Quantity_Format__w_reviewreport.png) [2](menu-walk/205_Reports_Stock_Reports_Stock_In_hand_Stock_Quantity_Format__w_selection_manf_cat_class_packing.png) |
| 208 | Reports \| Stock Reports \| Stock In hand \| Stock in Hand - Audit Purpose | opened_with_modal | `w_reviewreport` | Null object reference (reading i_status) (in f_retrieve_report6.f_retrieve_report6.f_retrieve_report6) \|\| [cl… | 895 | [1](menu-walk/208_Reports_Stock_Reports_Stock_In_hand_Stock_in_Hand_-_Audit_Purpose__modal.png) [2](menu-walk/208_Reports_Stock_Reports_Stock_In_hand_Stock_in_Hand_-_Audit_Purpose__w_reviewreport.png) |
| 210 | Reports \| Stock Reports \| Stock In hand \| Batch, Priority Wise - Audit Purposes | opened_ok | `w_reviewreport` |  | 755 | [1](menu-walk/210_Reports_Stock_Reports_Stock_In_hand_Batch,_Priority_Wise_-_Audit_Purposes__w_reviewreport.png) |
| 211 | Reports \| Stock Reports \| Expiry Report | opened_ok * | `w_reviewreport`, `w_selectformat_expiryreport` |  | 6121 | [1](menu-walk/211_Reports_Stock_Reports_Expiry_Report__w_reviewreport.png) [2](menu-walk/211_Reports_Stock_Reports_Expiry_Report__w_selectformat_expiryreport.png) |
| 212 | Reports \| Stock Reports \| Reorder Level Report | opened_with_modal | `w_reviewreport`, `w_selection_manf_cat_class_packing`, `w_arg_manfs_cats_classes_packs_days` | Not a DataWindowChild \|\| [close] Not a DataWindowChild | 6336 | [1](menu-walk/212_Reports_Stock_Reports_Reorder_Level_Report__modal.png) [2](menu-walk/212_Reports_Stock_Reports_Reorder_Level_Report__w_reviewreport.png) [3](menu-walk/212_Reports_Stock_Reports_Reorder_Level_Report__w_selection_manf_cat_class_packing.png) [4](menu-walk/212_Reports_Stock_Reports_Reorder_Level_Report__w_arg_manfs_cats_classes_packs_days.png) |
| 213 | Reports \| Stock Reports \| Stock Register | opened_with_modal | `w_reviewreport`, `w_arg_items_sdate_ldate_stockregister` | Null object reference (writing s_name7) (in f_retrieve_report.f_retrieve_report.f_retrieve_report) \|\| [close]… | 6514 | [1](menu-walk/213_Reports_Stock_Reports_Stock_Register__modal.png) [2](menu-walk/213_Reports_Stock_Reports_Stock_Register__w_reviewreport.png) [3](menu-walk/213_Reports_Stock_Reports_Stock_Register__w_arg_items_sdate_ldate_stockregister.png) |
| 217 | Reports \| Stock Reports \| Item Stock Register Summary | opened_ok | `w_reviewreport`, `w_arg_item_sdate_ldate` |  | 6457 | [1](menu-walk/217_Reports_Stock_Reports_Item_Stock_Register_Summary__w_reviewreport.png) [2](menu-walk/217_Reports_Stock_Reports_Item_Stock_Register_Summary__w_arg_item_sdate_ldate.png) |
| 219 | Reports \| Stock Reports \| Stock Register(For Narcotics) | opened_ok * | `w_reviewreport`, `w_selectformat_1_3` |  | 6550 | [1](menu-walk/219_Reports_Stock_Reports_Stock_Register%28For_Narcotics%29__w_reviewreport.png) [2](menu-walk/219_Reports_Stock_Reports_Stock_Register%28For_Narcotics%29__w_selectformat_1_3.png) |
| 224 | Reports \| Stock Reports \| Stock and Sales | opened_ok | `w_stockandsale_orientation` |  | 6787 | [1](menu-walk/224_Reports_Stock_Reports_Stock_and_Sales__w_stockandsale_orientation.png) |
| 226 | Reports \| Stock Reports \| Optimum Level Report | opened_ok | `w_reviewreport`, `w_arg_manf_cat_class_packing` |  | 6746 | [1](menu-walk/226_Reports_Stock_Reports_Optimum_Level_Report__w_reviewreport.png) [2](menu-walk/226_Reports_Stock_Reports_Optimum_Level_Report__w_arg_manf_cat_class_packing.png) |
| 228 | Reports \| Stock Reports \| Item Activity | opened_ok * | `w_reviewreport`, `w_selectformat_itemactivity` |  | 6636 | [1](menu-walk/228_Reports_Stock_Reports_Item_Activity__w_reviewreport.png) [2](menu-walk/228_Reports_Stock_Reports_Item_Activity__w_selectformat_itemactivity.png) |
| 230 | Reports \| Stock Reports \| Stock Register(Narcotics Format2) | opened_ok * | `w_reviewreport`, `w_selectformat_1_5` |  | 6729 | [1](menu-walk/230_Reports_Stock_Reports_Stock_Register%28Narcotics_Format2%29__w_reviewreport.png) [2](menu-walk/230_Reports_Stock_Reports_Stock_Register%28Narcotics_Format2%29__w_selectformat_1_5.png) |
| 231 | Reports \| Stock Reports \| Expiry Report(Class Wise) | opened_ok | `w_reviewreport`, `w_arg_class_day` |  | 6645 | [1](menu-walk/231_Reports_Stock_Reports_Expiry_Report%28Class_Wise%29__w_reviewreport.png) [2](menu-walk/231_Reports_Stock_Reports_Expiry_Report%28Class_Wise%29__w_arg_class_day.png) |
| 232 | Reports \| Stock Reports \| Minimum Level Report | opened_ok | `w_reviewreport`, `w_selection_manf_cat_class_packing` |  | 6514 | [1](menu-walk/232_Reports_Stock_Reports_Minimum_Level_Report__w_reviewreport.png) [2](menu-walk/232_Reports_Stock_Reports_Minimum_Level_Report__w_selection_manf_cat_class_packing.png) |
| 234 | Reports \| Stock Reports \| Reorder/Optimum Level Report | opened_ok * | `w_reviewreport`, `w_selectformat_1_3` |  | 6364 | [1](menu-walk/234_Reports_Stock_Reports_Reorder_Optimum_Level_Report__w_reviewreport.png) [2](menu-walk/234_Reports_Stock_Reports_Reorder_Optimum_Level_Report__w_selectformat_1_3.png) |
| 235 | Reports \| Stock Reports \| Daily Stock IN/OUT | opened_ok | `w_reviewreport`, `w_selection_manf_cat_class_packing` |  | 6187 | [1](menu-walk/235_Reports_Stock_Reports_Daily_Stock_IN_OUT__w_reviewreport.png) [2](menu-walk/235_Reports_Stock_Reports_Daily_Stock_IN_OUT__w_selection_manf_cat_class_packing.png) |
| 236 | Reports \| Stock Reports \| Stock IN/OUT(Date Wise) | opened_ok * | `w_reviewreport`, `w_selectformat_cat_1_or_n` |  | 6435 | [1](menu-walk/236_Reports_Stock_Reports_Stock_IN_OUT%28Date_Wise%29__w_reviewreport.png) [2](menu-walk/236_Reports_Stock_Reports_Stock_IN_OUT%28Date_Wise%29__w_selectformat_cat_1_or_n.png) |
| 245 | Reports \| Stock Reports \| Stock Management Report | opened_ok | `w_reviewreport` |  | 1046 | [1](menu-walk/245_Reports_Stock_Reports_Stock_Management_Report__w_reviewreport.png) |
| 246 | Reports \| Stock Reports \| Norcotics Stock Register-Generic Type Wise | opened_ok | `w_reviewreport` |  | 1240 | [1](menu-walk/246_Reports_Stock_Reports_Norcotics_Stock_Register-Generic_Type_Wise__w_reviewreport.png) |
| 247 | Reports \| Sales Reports \| Customer Sales \| Detail | opened_ok | `w_reviewreport` |  | 1103 | [1](menu-walk/247_Reports_Sales_Reports_Customer_Sales_Detail__w_reviewreport.png) |
| 249 | Reports \| Sales Reports \| Customer Sales \| Summary | opened_ok | `w_reviewreport` |  | 1119 | [1](menu-walk/249_Reports_Sales_Reports_Customer_Sales_Summary__w_reviewreport.png) |
| 250 | Reports \| Sales Reports \| Customer Sales \| Days Summary | opened_ok * | `w_reviewreport`, `w_arg_customers_sdate_ldate_v5` |  | 6767 | [1](menu-walk/250_Reports_Sales_Reports_Customer_Sales_Days_Summary__w_reviewreport.png) [2](menu-walk/250_Reports_Sales_Reports_Customer_Sales_Days_Summary__w_arg_customers_sdate_ldate_v5.png) |
| 253 | Reports \| Sales Reports \| Customer Sales \| Invoice Wise Profit Margin Detail | opened_ok * | `w_reviewreport`, `w_select_invprofitmargin` |  | 6742 | [1](menu-walk/253_Reports_Sales_Reports_Customer_Sales_Invoice_Wise_Profit_Margin_Detail__w_reviewreport.png) [2](menu-walk/253_Reports_Sales_Reports_Customer_Sales_Invoice_Wise_Profit_Margin_Detail__w_select_invprofitmargin.png) |
| 254 | Reports \| Sales Reports \| Customer Sales \| Items Summary | opened_ok * | `w_reviewreport`, `w_arg_cust_sdate_ldate` |  | 6809 | [1](menu-walk/254_Reports_Sales_Reports_Customer_Sales_Items_Summary__w_reviewreport.png) [2](menu-walk/254_Reports_Sales_Reports_Customer_Sales_Items_Summary__w_arg_cust_sdate_ldate.png) |
| 260 | Reports \| Sales Reports \| Customer Sales \| Invoice Summary | opened_ok | `w_reviewreport`, `w_arg_sinvcode_linvcode` |  | 6799 | [1](menu-walk/260_Reports_Sales_Reports_Customer_Sales_Invoice_Summary__w_reviewreport.png) [2](menu-walk/260_Reports_Sales_Reports_Customer_Sales_Invoice_Summary__w_arg_sinvcode_linvcode.png) |
| 261 | Reports \| Sales Reports \| Customer Sales \| Hourly Graph | opened_ok | `w_reviewreport`, `w_arg_sdate_ldate` |  | 6217 | [1](menu-walk/261_Reports_Sales_Reports_Customer_Sales_Hourly_Graph__w_reviewreport.png) [2](menu-walk/261_Reports_Sales_Reports_Customer_Sales_Hourly_Graph__w_arg_sdate_ldate.png) |
| 273 | Reports \| Sales Reports \| Customer Sales \| Customer Category Wise Net Sales | opened_ok | `w_reviewreport`, `w_arg_manf_custcat_sdate_ldate` |  | 6084 | [1](menu-walk/273_Reports_Sales_Reports_Customer_Sales_Customer_Category_Wise_Net_Sales__w_reviewreport.png) [2](menu-walk/273_Reports_Sales_Reports_Customer_Sales_Customer_Category_Wise_Net_Sales__w_arg_manf_custcat_sdate_ldate.png) |
| 292 | Reports \| Sales Reports \| Customer Sales \| Customer Wise Category Net Sales | opened_ok | `w_reviewreport` |  | 757 | [1](menu-walk/292_Reports_Sales_Reports_Customer_Sales_Customer_Wise_Category_Net_Sales__w_reviewreport.png) |
| 296 | Reports \| Sales Reports \| Customer Sales \| Monthly Net Sales | opened_ok * | `w_reviewreport`, `w_arg_sdate_ldate` |  | 5866 | [1](menu-walk/296_Reports_Sales_Reports_Customer_Sales_Monthly_Net_Sales__w_reviewreport.png) [2](menu-walk/296_Reports_Sales_Reports_Customer_Sales_Monthly_Net_Sales__w_arg_sdate_ldate.png) |
| 312 | Reports \| Sales Reports \| Customer Sales \| Claimable for Allowed Customers | opened_ok | `w_reviewreport` |  | 931 | [1](menu-walk/312_Reports_Sales_Reports_Customer_Sales_Claimable_for_Allowed_Customers__w_reviewreport.png) |
| 313 | Reports \| Sales Reports \| Customer Sales \| Customer NTN Wise Sales Tax Report | opened_ok | `w_reviewreport` |  | 1004 | [1](menu-walk/313_Reports_Sales_Reports_Customer_Sales_Customer_NTN_Wise_Sales_Tax_Report__w_reviewreport.png) |
| 314 | Reports \| Sales Reports \| Customer Sales \| Customer Wise Advance Tax | opened_ok | `w_reviewreport` |  | 974 | [1](menu-walk/314_Reports_Sales_Reports_Customer_Sales_Customer_Wise_Advance_Tax__w_reviewreport.png) |
| 316 | Reports \| Sales Reports \| Category Wise \| Sale And Return (One Category) | opened_ok | `w_reviewreport`, `w_arg_cat_sdate_ldate` |  | 6355 | [1](menu-walk/316_Reports_Sales_Reports_Category_Wise_Sale_And_Return_%28One_Category%29__w_reviewreport.png) [2](menu-walk/316_Reports_Sales_Reports_Category_Wise_Sale_And_Return_%28One_Category%29__w_arg_cat_sdate_ldate.png) |
| 317 | Reports \| Sales Reports \| Category Wise \| Sales | opened_ok | `w_reviewreport`, `w_arg_sdate_ldate` |  | 6627 | [1](menu-walk/317_Reports_Sales_Reports_Category_Wise_Sales__w_reviewreport.png) [2](menu-walk/317_Reports_Sales_Reports_Category_Wise_Sales__w_arg_sdate_ldate.png) |
| 319 | Reports \| Sales Reports \| Category Wise \| Deviated Items | opened_ok | `w_reviewreport`, `w_arg_category_sdate_ldate` |  | 6785 | [1](menu-walk/319_Reports_Sales_Reports_Category_Wise_Deviated_Items__w_reviewreport.png) [2](menu-walk/319_Reports_Sales_Reports_Category_Wise_Deviated_Items__w_arg_category_sdate_ldate.png) |
| 320 | Reports \| Sales Reports \| Category Wise \| Monthly Sale | opened_ok | `w_reviewreport`, `w_arg_cust_or_allcust` |  | 6780 | [1](menu-walk/320_Reports_Sales_Reports_Category_Wise_Monthly_Sale__w_reviewreport.png) [2](menu-walk/320_Reports_Sales_Reports_Category_Wise_Monthly_Sale__w_arg_cust_or_allcust.png) |
| 321 | Reports \| Sales Reports \| Category Wise \| Net Sale | opened_ok | `w_reviewreport`, `w_arg_sale_users_withlist_sdate_ldate` |  | 6519 | [1](menu-walk/321_Reports_Sales_Reports_Category_Wise_Net_Sale__w_reviewreport.png) [2](menu-walk/321_Reports_Sales_Reports_Category_Wise_Net_Sale__w_arg_sale_users_withlist_sdate_ldate.png) |
| 322 | Reports \| Sales Reports \| Category Wise \| Gross Profit | opened_ok * | `w_reviewreport`, `w_selectformat_catwise_grossprofit` |  | 6702 | [1](menu-walk/322_Reports_Sales_Reports_Category_Wise_Gross_Profit__w_reviewreport.png) [2](menu-walk/322_Reports_Sales_Reports_Category_Wise_Gross_Profit__w_selectformat_catwise_grossprofit.png) |
| 327 | Reports \| Sales Reports \| Category Wise \| Item Wise Sale Discounts Detail | opened_ok | `w_reviewreport`, `w_arg_category_sdate_ldate` |  | 6179 | [1](menu-walk/327_Reports_Sales_Reports_Category_Wise_Item_Wise_Sale_Discounts_Detail__w_reviewreport.png) [2](menu-walk/327_Reports_Sales_Reports_Category_Wise_Item_Wise_Sale_Discounts_Detail__w_arg_category_sdate_ldate.png) |
| 334 | Reports \| Sales Reports \| Category Wise \| Item Category Wise Monthly Sales | opened_ok | `w_reviewreport`, `w_arg_category_sdate_ldate` |  | 6331 | [1](menu-walk/334_Reports_Sales_Reports_Category_Wise_Item_Category_Wise_Monthly_Sales__w_reviewreport.png) [2](menu-walk/334_Reports_Sales_Reports_Category_Wise_Item_Category_Wise_Monthly_Sales__w_arg_category_sdate_ldate.png) |
| 338 | Reports \| Sales Reports \| Category Wise \| Category Wise Day Net Sale | opened_ok | `w_reviewreport` |  | 1243 | [1](menu-walk/338_Reports_Sales_Reports_Category_Wise_Category_Wise_Day_Net_Sale__w_reviewreport.png) |
| 339 | Reports \| Sales Reports \| Manufacturer Wise \| Sales | opened_ok * | `w_reviewreport`, `w_arg_manufacturers_returnoptions` |  | 6743 | [1](menu-walk/339_Reports_Sales_Reports_Manufacturer_Wise_Sales__w_reviewreport.png) [2](menu-walk/339_Reports_Sales_Reports_Manufacturer_Wise_Sales__w_arg_manufacturers_returnoptions.png) |
| 343 | Reports \| Sales Reports \| Manufacturer Wise \| Sales Detail And Summary | opened_ok * | `w_reviewreport`, `w_selectformat_customer_manf_sales` |  | 6827 | [1](menu-walk/343_Reports_Sales_Reports_Manufacturer_Wise_Sales_Detail_And_Summary__w_reviewreport.png) [2](menu-walk/343_Reports_Sales_Reports_Manufacturer_Wise_Sales_Detail_And_Summary__w_selectformat_customer_manf_sales.png) |
| 344 | Reports \| Sales Reports \| Manufacturer Wise \| Net Sales | opened_ok | `w_reviewreport`, `w_arg_sale_users_withlist_sdate_ldate` |  | 6546 | [1](menu-walk/344_Reports_Sales_Reports_Manufacturer_Wise_Net_Sales__w_reviewreport.png) [2](menu-walk/344_Reports_Sales_Reports_Manufacturer_Wise_Net_Sales__w_arg_sale_users_withlist_sdate_ldate.png) |
| 346 | Reports \| Sales Reports \| Manufacturer Wise \| Item Sales/Discount | opened_ok | `w_reviewreport`, `w_selection_manf_cat_class_packing` |  | 6668 | [1](menu-walk/346_Reports_Sales_Reports_Manufacturer_Wise_Item_Sales_Discount__w_reviewreport.png) [2](menu-walk/346_Reports_Sales_Reports_Manufacturer_Wise_Item_Sales_Discount__w_selection_manf_cat_class_packing.png) |
| 350 | Reports \| Sales Reports \| Manufacturer Wise \| Manufacturer Wise Sales And Return Summary | opened_ok | `w_reviewreport`, `w_arg_grouping_area_period` |  | 6986 | [1](menu-walk/350_Reports_Sales_Reports_Manufacturer_Wise_Manufacturer_Wise_Sales_And_Return_Summary__w_reviewreport.png) [2](menu-walk/350_Reports_Sales_Reports_Manufacturer_Wise_Manufacturer_Wise_Sales_And_Return_Summary__w_arg_grouping_area_period.png) |
| 354 | Reports \| Sales Reports \| Manufacturer Wise \| CNIC/NTN Registered Customers Sales | opened_with_modal | `w_reviewreport` | Null object reference (reading i_status) (in f_retrieve_report6.f_retrieve_report6.f_retrieve_report6) \|\| [cl… | 1466 | [1](menu-walk/354_Reports_Sales_Reports_Manufacturer_Wise_CNIC_NTN_Registered_Customers_Sales__modal.png) [2](menu-walk/354_Reports_Sales_Reports_Manufacturer_Wise_CNIC_NTN_Registered_Customers_Sales__w_reviewreport.png) |
| 369 | Reports \| Sales Reports \| User Wise \| Invoice Graph | opened_ok | `w_reviewreport`, `w_arg_sdate_ldate_perc` |  | 6577 | [1](menu-walk/369_Reports_Sales_Reports_User_Wise_Invoice_Graph__w_reviewreport.png) [2](menu-walk/369_Reports_Sales_Reports_User_Wise_Invoice_Graph__w_arg_sdate_ldate_perc.png) |
| 370 | Reports \| Sales Reports \| User Wise \| Sales | opened_ok * | `w_reviewreport`, `w_selectformat_1_4` |  | 6694 | [1](menu-walk/370_Reports_Sales_Reports_User_Wise_Sales__w_reviewreport.png) [2](menu-walk/370_Reports_Sales_Reports_User_Wise_Sales__w_selectformat_1_4.png) |
| 371 | Reports \| Sales Reports \| User Wise \| Category Summary | opened_ok * | `w_reviewreport`, `w_arg_user_sdate_ldate` |  | 6795 | [1](menu-walk/371_Reports_Sales_Reports_User_Wise_Category_Summary__w_reviewreport.png) [2](menu-walk/371_Reports_Sales_Reports_User_Wise_Category_Summary__w_arg_user_sdate_ldate.png) |
| 372 | Reports \| Sales Reports \| User Wise \| Discount Report | opened_ok | `w_reviewreport`, `w_arg_users_sdate_ldate` |  | 6260 | [1](menu-walk/372_Reports_Sales_Reports_User_Wise_Discount_Report__w_reviewreport.png) [2](menu-walk/372_Reports_Sales_Reports_User_Wise_Discount_Report__w_arg_users_sdate_ldate.png) |
| 375 | Reports \| Sales Reports \| User Wise \| Net Cash | opened_ok * | `w_reviewreport`, `w_arg_user_sdate_ldate` |  | 6115 | [1](menu-walk/375_Reports_Sales_Reports_User_Wise_Net_Cash__w_reviewreport.png) [2](menu-walk/375_Reports_Sales_Reports_User_Wise_Net_Cash__w_arg_user_sdate_ldate.png) |
| 376 | Reports \| Sales Reports \| User Wise \| Sales Commission | opened_ok * | `w_reviewreport`, `w_arg_users_sdate_ldate` |  | 5890 | [1](menu-walk/376_Reports_Sales_Reports_User_Wise_Sales_Commission__w_reviewreport.png) [2](menu-walk/376_Reports_Sales_Reports_User_Wise_Sales_Commission__w_arg_users_sdate_ldate.png) |
| 377 | Reports \| Sales Reports \| User Wise \| User Wise Sales Summary | opened_ok | `w_reviewreport`, `w_arg_sdate_ldate` |  | 6323 | [1](menu-walk/377_Reports_Sales_Reports_User_Wise_User_Wise_Sales_Summary__w_reviewreport.png) [2](menu-walk/377_Reports_Sales_Reports_User_Wise_User_Wise_Sales_Summary__w_arg_sdate_ldate.png) |
| 430 | Reports \| Sales Reports \| Hourly Sales Graph | opened_ok | `w_reviewreport`, `w_arg_sdate_ldate` |  | 6391 | [1](menu-walk/430_Reports_Sales_Reports_Hourly_Sales_Graph__w_reviewreport.png) [2](menu-walk/430_Reports_Sales_Reports_Hourly_Sales_Graph__w_arg_sdate_ldate.png) |
| 431 | Reports \| Sales Reports \| Slow/Fast moving Items | opened_ok * | `w_reviewreport`, `w_selection_manf_cat_class_packing` |  | 6356 | [1](menu-walk/431_Reports_Sales_Reports_Slow_Fast_moving_Items__w_reviewreport.png) [2](menu-walk/431_Reports_Sales_Reports_Slow_Fast_moving_Items__w_selection_manf_cat_class_packing.png) |
| 435 | Reports \| Sales Reports \| Net Sale Summary | opened_ok * | `w_reviewreport`, `w_arg_sdate_ldate`, `w_selectformat_slowfastmoving` |  | 6516 | [1](menu-walk/435_Reports_Sales_Reports_Net_Sale_Summary__w_reviewreport.png) [2](menu-walk/435_Reports_Sales_Reports_Net_Sale_Summary__w_arg_sdate_ldate.png) [3](menu-walk/435_Reports_Sales_Reports_Net_Sale_Summary__w_selectformat_slowfastmoving.png) |
| 439 | Reports \| Sales Reports \| Item Wise \| Item Sale and Return Activity | opened_ok * | `w_reviewreport`, `w_arg_items_sdate_ldate` |  | 6373 | [1](menu-walk/439_Reports_Sales_Reports_Item_Wise_Item_Sale_and_Return_Activity__w_reviewreport.png) [2](menu-walk/439_Reports_Sales_Reports_Item_Wise_Item_Sale_and_Return_Activity__w_arg_items_sdate_ldate.png) |
| 442 | Reports \| Sales Reports \| Item Wise \| Item Wise Net Sales | opened_ok * | `w_reviewreport`, `w_selectformat_item_netsales` |  | 6396 | [1](menu-walk/442_Reports_Sales_Reports_Item_Wise_Item_Wise_Net_Sales__w_reviewreport.png) [2](menu-walk/442_Reports_Sales_Reports_Item_Wise_Item_Wise_Net_Sales__w_selectformat_item_netsales.png) |
| 460 | Reports \| Sales Reports \| Sale/Return Summary Inv. Type Wise | opened_ok * | `w_reviewreport`, `w_selectformat_saleinvtypewisereport` |  | 6357 | [1](menu-walk/460_Reports_Sales_Reports_Sale_Return_Summary_Inv._Type_Wise__w_reviewreport.png) [2](menu-walk/460_Reports_Sales_Reports_Sale_Return_Summary_Inv._Type_Wise__w_selectformat_saleinvtypewisereport.png) |
| 467 | Reports \| Sales Reports \| Daily Sales Summary with Profit(Day wise grouping) | opened_ok | `w_reviewreport` |  | 930 | [1](menu-walk/467_Reports_Sales_Reports_Daily_Sales_Summary_with_Profit%28Day_wise_grouping%29__w_reviewreport.png) |
| 469 | Reports \| Sales Reports \| Monthly Net Sales Summary | opened_ok | `w_reviewreport`, `w_arg_monthly_netsales_sdate_ldate` |  | 6568 | [1](menu-walk/469_Reports_Sales_Reports_Monthly_Net_Sales_Summary__w_reviewreport.png) [2](menu-walk/469_Reports_Sales_Reports_Monthly_Net_Sales_Summary__w_arg_monthly_netsales_sdate_ldate.png) |
| 471 | Reports \| Sales Reports \| Dead Item List | opened_ok * | `w_reviewreport`, `w_selection_manf_cat_class_packing` |  | 6119 | [1](menu-walk/471_Reports_Sales_Reports_Dead_Item_List__w_reviewreport.png) [2](menu-walk/471_Reports_Sales_Reports_Dead_Item_List__w_selection_manf_cat_class_packing.png) |
| 476 | Reports \| Sales Reports \| Sales Tax Report | opened_ok | `w_reviewreport` |  | 943 | [1](menu-walk/476_Reports_Sales_Reports_Sales_Tax_Report__w_reviewreport.png) |
| 477 | Reports \| Purchase Reports \| Periodic Purchases | opened_with_modal * | `w_reviewreport`, `w_arg_sdate_ldate` | Null object reference (reading i_status) (in f_retrieve_report7.f_retrieve_report7.f_retrieve_report7) \|\| [cl… | 6757 | [1](menu-walk/477_Reports_Purchase_Reports_Periodic_Purchases__modal.png) [2](menu-walk/477_Reports_Purchase_Reports_Periodic_Purchases__w_reviewreport.png) [3](menu-walk/477_Reports_Purchase_Reports_Periodic_Purchases__w_arg_sdate_ldate.png) |
| 479 | Reports \| Purchase Reports \| Purchase Order | opened_ok * | `w_reviewreport`, `w_selectformat_datewise_invwise` |  | 6572 | [1](menu-walk/479_Reports_Purchase_Reports_Purchase_Order__w_reviewreport.png) [2](menu-walk/479_Reports_Purchase_Reports_Purchase_Order__w_selectformat_datewise_invwise.png) |
| 480 | Reports \| Purchase Reports \| Supplier Wise \| Detail | opened_ok | `w_reviewreport`, `w_arg_supp_sdate_ldate` |  | 6417 | [1](menu-walk/480_Reports_Purchase_Reports_Supplier_Wise_Detail__w_reviewreport.png) [2](menu-walk/480_Reports_Purchase_Reports_Supplier_Wise_Detail__w_arg_supp_sdate_ldate.png) |
| 481 | Reports \| Purchase Reports \| Supplier Wise \| Purchase Detail | opened_ok * | `w_reviewreport`, `w_arg_supplier_all` |  | 6755 | [1](menu-walk/481_Reports_Purchase_Reports_Supplier_Wise_Purchase_Detail__w_reviewreport.png) [2](menu-walk/481_Reports_Purchase_Reports_Supplier_Wise_Purchase_Detail__w_arg_supplier_all.png) |
| 486 | Reports \| Purchase Reports \| Supplier Wise \| Advance Income Tax | opened_ok | `w_reviewreport` |  | 1023 | [1](menu-walk/486_Reports_Purchase_Reports_Supplier_Wise_Advance_Income_Tax__w_reviewreport.png) |
| 487 | Reports \| Purchase Reports \| Manufacturer Wise \| Detail | opened_ok * | `w_reviewreport`, `w_selectformat_1_2` |  | 6336 | [1](menu-walk/487_Reports_Purchase_Reports_Manufacturer_Wise_Detail__w_reviewreport.png) [2](menu-walk/487_Reports_Purchase_Reports_Manufacturer_Wise_Detail__w_selectformat_1_2.png) |
| 488 | Reports \| Purchase Reports \| Manufacturer Wise \| Monthly Stock Movement | opened_ok | `w_reviewreport` |  | 1211 | [1](menu-walk/488_Reports_Purchase_Reports_Manufacturer_Wise_Monthly_Stock_Movement__w_reviewreport.png) |
| 489 | Reports \| Purchase Reports \| Monthly Purchase Graph | opened_ok | `w_reviewreport`, `w_arg_sdate_ldate` |  | 6603 | [1](menu-walk/489_Reports_Purchase_Reports_Monthly_Purchase_Graph__w_reviewreport.png) [2](menu-walk/489_Reports_Purchase_Reports_Monthly_Purchase_Graph__w_arg_sdate_ldate.png) |
| 490 | Reports \| Purchase Reports \| Category Wise Purchase | opened_ok * | `w_reviewreport`, `w_selectformat_cat_purchase` |  | 6787 | [1](menu-walk/490_Reports_Purchase_Reports_Category_Wise_Purchase__w_reviewreport.png) [2](menu-walk/490_Reports_Purchase_Reports_Category_Wise_Purchase__w_selectformat_cat_purchase.png) |
| 494 | Reports \| Purchase Reports \| Days Summary | opened_ok | `w_reviewreport`, `w_arg_sdate_ldate` |  | 6553 | [1](menu-walk/494_Reports_Purchase_Reports_Days_Summary__w_reviewreport.png) [2](menu-walk/494_Reports_Purchase_Reports_Days_Summary__w_arg_sdate_ldate.png) |
| 503 | Reports \| Purchase Reports \| Purchase Order Supplier Wise | opened_ok | `w_reviewreport`, `w_arg_purorder_sdate_ldate_onesupp` |  | 7226 | [1](menu-walk/503_Reports_Purchase_Reports_Purchase_Order_Supplier_Wise__w_reviewreport.png) [2](menu-walk/503_Reports_Purchase_Reports_Purchase_Order_Supplier_Wise__w_arg_purorder_sdate_ldate_onesupp.png) |
| 504 | Reports \| Purchase Reports \| Net Purchase Summary | opened_ok * | `w_reviewreport`, `w_selectformat_netpursummary` |  | 6223 | [1](menu-walk/504_Reports_Purchase_Reports_Net_Purchase_Summary__w_reviewreport.png) [2](menu-walk/504_Reports_Purchase_Reports_Net_Purchase_Summary__w_selectformat_netpursummary.png) |
| 509 | Reports \| Purchase Reports \| Supplier Category Wise \| Input Sales Tax Report | opened_ok | `w_reviewreport` |  | 868 | [1](menu-walk/509_Reports_Purchase_Reports_Supplier_Category_Wise_Input_Sales_Tax_Report__w_reviewreport.png) |
| 512 | Reports \| Purchase Reports \| Withholding Tax Deduction | opened_ok | `w_reviewreport` |  | 920 | [1](menu-walk/512_Reports_Purchase_Reports_Withholding_Tax_Deduction__w_reviewreport.png) |
| 513 | Reports \| Purchase Reports \| Supplier/Manufacturer Wise G/P | opened_ok | `w_reviewreport` |  | 1003 | [1](menu-walk/513_Reports_Purchase_Reports_Supplier_Manufacturer_Wise_G_P__w_reviewreport.png) |
| 522 | Reports \| Accounts Reports \| Ledger Reports \| Accounts Ledger | opened_ok * | `w_reviewreport` |  | 6024 | [1](menu-walk/522_Reports_Accounts_Reports_Ledger_Reports_Accounts_Ledger__w_reviewreport.png) |
| 598 | Reports \| Listing \| Supplier List | opened_with_modal | `w_reviewreport` | Null object reference (reading i_status) (in f_retrieve_report1.f_retrieve_report1.f_retrieve_report1) \|\| [cl… | 1116 | [1](menu-walk/598_Reports_Listing_Supplier_List__modal.png) [2](menu-walk/598_Reports_Listing_Supplier_List__w_reviewreport.png) |
| 600 | Reports \| Listing \| Items List | opened_ok | `w_filter_for_itemlist_rep` |  | 6700 | [1](menu-walk/600_Reports_Listing_Items_List__w_filter_for_itemlist_rep.png) |
| 603 | Reports \| Listing \| Manufacturer List | opened_ok | `w_reviewreport`, `w_selectformat_1_3` |  | 6585 | [1](menu-walk/603_Reports_Listing_Manufacturer_List__w_reviewreport.png) [2](menu-walk/603_Reports_Listing_Manufacturer_List__w_selectformat_1_3.png) |
| 612 | Reports \| Listing \| Group Rights List | opened_ok | `w_reviewreport`, `w_arg_groups` |  | 6793 | [1](menu-walk/612_Reports_Listing_Group_Rights_List__w_reviewreport.png) [2](menu-walk/612_Reports_Listing_Group_Rights_List__w_arg_groups.png) |
| 613 | Reports \| Listing \| Item List Class Wise | opened_ok | `w_reviewreport`, `w_selection_manf_cat_class_packing` |  | 7097 | [1](menu-walk/613_Reports_Listing_Item_List_Class_Wise__w_reviewreport.png) [2](menu-walk/613_Reports_Listing_Item_List_Class_Wise__w_selection_manf_cat_class_packing.png) |
| 614 | Reports \| Listing \| GroupWise User List | opened_ok | `w_reviewreport`, `w_arg_groups` |  | 6573 | [1](menu-walk/614_Reports_Listing_GroupWise_User_List__w_reviewreport.png) [2](menu-walk/614_Reports_Listing_GroupWise_User_List__w_arg_groups.png) |
| 619 | Reports \| Listing \| Sale Person Scope \| Manufacturer/Sub Area Wise Sales Person Conflict | opened_ok | `w_reviewreport` |  | 1085 | [1](menu-walk/619_Reports_Listing_Sale_Person_Scope_Manufacturer_Sub_Area_Wise_Sales_Person_Conflict__w_reviewreport.png) |
| 624 | Reports \| RePrinting \| Sale | opened_ok | `w_reviewreport` |  | 6146 | [1](menu-walk/624_Reports_RePrinting_Sale__w_reviewreport.png) |
| 625 | Reports \| RePrinting \| Purchase | opened_ok | `w_reviewreport`, `w_arg_sinvcode_linvcode` |  | 6981 | [1](menu-walk/625_Reports_RePrinting_Purchase__w_reviewreport.png) [2](menu-walk/625_Reports_RePrinting_Purchase__w_arg_sinvcode_linvcode.png) |
| 626 | Reports \| RePrinting \| Sale (with summary reports) | opened_ok | `w_reviewreport`, `w_arg_sinvcode_linvcode_saleswithsummary` |  | 7150 | [1](menu-walk/626_Reports_RePrinting_Sale_%28with_summary_reports%29__w_reviewreport.png) [2](menu-walk/626_Reports_RePrinting_Sale_%28with_summary_reports%29__w_arg_sinvcode_linvcode_saleswithsummary.png) |
| 627 | Reports \| RePrinting \| Sale Format(2) | opened_ok | `w_reviewreport`, `w_arg_invcode_printdate_printexpiry` |  | 6979 | [1](menu-walk/627_Reports_RePrinting_Sale_Format%282%29__w_reviewreport.png) [2](menu-walk/627_Reports_RePrinting_Sale_Format%282%29__w_arg_invcode_printdate_printexpiry.png) |
| 630 | Reports \| RePrinting \| Sale Format(3) | opened_ok | `w_reviewreport`, `w_arg_code_caption` |  | 6784 | [1](menu-walk/630_Reports_RePrinting_Sale_Format%283%29__w_reviewreport.png) [2](menu-walk/630_Reports_RePrinting_Sale_Format%283%29__w_arg_code_caption.png) |
| 634 | Reports \| RePrinting \| Sale Format(4) | opened_ok | `w_reviewreport`, `w_arg_sdate_ldate_cust` |  | 6732 | [1](menu-walk/634_Reports_RePrinting_Sale_Format%284%29__w_reviewreport.png) [2](menu-walk/634_Reports_RePrinting_Sale_Format%284%29__w_arg_sdate_ldate_cust.png) |
| 635 | Reports \| RePrinting \| Sale (with header wise summaries) | opened_ok | `w_reviewreport`, `w_arg_sinv_linv_salesum_headerwise` |  | 6634 | [1](menu-walk/635_Reports_RePrinting_Sale_%28with_header_wise_summaries%29__w_reviewreport.png) [2](menu-walk/635_Reports_RePrinting_Sale_%28with_header_wise_summaries%29__w_arg_sinv_linv_salesum_headerwise.png) |
| 647 | Reports \| RePrinting \| Selected Sales and Summaries | opened_ok | `w_reviewreport` |  | 1460 | [1](menu-walk/647_Reports_RePrinting_Selected_Sales_and_Summaries__w_reviewreport.png) |
| 691 | Reports \| Item Reports \| History \| Sale Price Difference | opened_ok * | `w_reviewreport`, `w_arg_category_sdate_ldate` |  | 7067 | [1](menu-walk/691_Reports_Item_Reports_History_Sale_Price_Difference__w_reviewreport.png) [2](menu-walk/691_Reports_Item_Reports_History_Sale_Price_Difference__w_arg_category_sdate_ldate.png) |
| 692 | Reports \| Item Reports \| History \| Item Basic Data Changes | opened_ok * | `w_reviewreport` |  | 6254 | [1](menu-walk/692_Reports_Item_Reports_History_Item_Basic_Data_Changes__w_reviewreport.png) |
| 693 | Reports \| Item Reports \| History \| Item Sale Price Changes | opened_ok * | `w_reviewreport` |  | 6222 | [1](menu-walk/693_Reports_Item_Reports_History_Item_Sale_Price_Changes__w_reviewreport.png) |
| 695 | Reports \| Item Reports \| History \| New Item(s) Created/Defined | opened_ok | `w_reviewreport`, `w_arg_sdate_ldate` |  | 6511 | [1](menu-walk/695_Reports_Item_Reports_History_New_Item%28s%29_Created_Defined__w_reviewreport.png) [2](menu-walk/695_Reports_Item_Reports_History_New_Item%28s%29_Created_Defined__w_arg_sdate_ldate.png) |
| 697 | Reports \| Item Reports \| History \| Item Name Changes | opened_ok | `w_reviewreport` |  | 1383 | [1](menu-walk/697_Reports_Item_Reports_History_Item_Name_Changes__w_reviewreport.png) |
| 698 | Reports \| Item Reports \| Stock Adjustments \| Stock Adjustments Detail | opened_ok | `w_reviewreport`, `w_arg_item_sdate_ldate_pricetype` |  | 6216 | [1](menu-walk/698_Reports_Item_Reports_Stock_Adjustments_Stock_Adjustments_Detail__w_reviewreport.png) [2](menu-walk/698_Reports_Item_Reports_Stock_Adjustments_Stock_Adjustments_Detail__w_arg_item_sdate_ldate_pricetype.png) |
| 700 | Reports \| Item Reports \| Deleted Sale Items Log | opened_ok | `w_reviewreport`, `w_arg_sdate_ldate` |  | 6089 | [1](menu-walk/700_Reports_Item_Reports_Deleted_Sale_Items_Log__w_reviewreport.png) [2](menu-walk/700_Reports_Item_Reports_Deleted_Sale_Items_Log__w_arg_sdate_ldate.png) |
| 722 | Reports \| Purchase Return Reports \| Supplier Purchase Returns \| Detail | opened_ok * | `w_reviewreport`, `w_selectformat_1_2` |  | 6145 | [1](menu-walk/722_Reports_Purchase_Return_Reports_Supplier_Purchase_Returns_Detail__w_reviewreport.png) [2](menu-walk/722_Reports_Purchase_Return_Reports_Supplier_Purchase_Returns_Detail__w_selectformat_1_2.png) |
| 723 | Reports \| Purchase Return Reports \| Supplier Purchase Returns \| Summary | opened_ok | `w_reviewreport`, `w_arg_supp_sdate_ldate` |  | 6104 | [1](menu-walk/723_Reports_Purchase_Return_Reports_Supplier_Purchase_Returns_Summary__w_reviewreport.png) [2](menu-walk/723_Reports_Purchase_Return_Reports_Supplier_Purchase_Returns_Summary__w_arg_supp_sdate_ldate.png) |
| 874 | Basic Data \| Customer .......... \| Customer | opened_ok | `w_customer_form` | [close] Do You want to save changes | 2763 | [1](menu-walk/874_Basic_Data_Customer_.........._Customer__w_customer_form.png) |
| 875 | Basic Data \| Customer .......... \| Customer Category | opened_ok | `w_custcategory_form` | [close] Do You want to save changes | 1393 | [1](menu-walk/875_Basic_Data_Customer_.........._Customer_Category__w_custcategory_form.png) |
| 894 | Basic Data \| Customer .......... \| Sale Promotion | opened_ok | `w_salepromotion_form` | [close] Do You want to save changes | 1357 | [1](menu-walk/894_Basic_Data_Customer_.........._Sale_Promotion__w_salepromotion_form.png) |
| 895 | Basic Data \| Customer .......... \| Customer Sector | opened_ok | `w_custsector_form` | [close] Do You want to save changes | 1352 | [1](menu-walk/895_Basic_Data_Customer_.........._Customer_Sector__w_custsector_form.png) |
| 896 | Basic Data \| Supplier .......... \| Supplier | opened_ok | `w_supplier_manf` | [close] Do You want to save changes | 2074 | [1](menu-walk/896_Basic_Data_Supplier_.........._Supplier__w_supplier_manf.png) |
| 897 | Basic Data \| Supplier .......... \| Supplier Category | opened_ok | `w_suppliercategory_form` | [close] Do You want to save changes | 1324 | [1](menu-walk/897_Basic_Data_Supplier_.........._Supplier_Category__w_suppliercategory_form.png) |
| 900 | Basic Data \| Item .......... \| Item | opened_ok | `w_item_form` | [close] Do You want to save changes | 2307 | [1](menu-walk/900_Basic_Data_Item_.........._Item__w_item_form.png) |
| 901 | Basic Data \| Item .......... \| Manufacturer | opened_ok | `w_manufacturer_form` | [close] Do You want to save changes | 1361 | [1](menu-walk/901_Basic_Data_Item_.........._Manufacturer__w_manufacturer_form.png) |
| 902 | Basic Data \| Item .......... \| Item Class | opened_ok | `w_class_form` | [close] Do You want to save changes | 1347 | [1](menu-walk/902_Basic_Data_Item_.........._Item_Class__w_class_form.png) |
| 903 | Basic Data \| Item .......... \| Item Category | opened_ok | `w_itemcategory_form` | [close] Do You want to save changes | 1412 | [1](menu-walk/903_Basic_Data_Item_.........._Item_Category__w_itemcategory_form.png) |
| 915 | Basic Data \| Item .......... \| Generic Item | opened_ok | `w_genericitem_form` | [close] Do You want to save changes | 1378 | [1](menu-walk/915_Basic_Data_Item_.........._Generic_Item__w_genericitem_form.png) |
| 918 | Basic Data \| Item .......... \| Item Basic Data | opened_ok | `w_item_basicdata_form` | [close] Do You want to save changes | 1401 | [1](menu-walk/918_Basic_Data_Item_.........._Item_Basic_Data__w_item_basicdata_form.png) |
| 922 | Basic Data \| Item .......... \| Price Policy | opened_ok | `w_itempricepolicy_form` | [close] Do You want to save changes | 1476 | [1](menu-walk/922_Basic_Data_Item_.........._Price_Policy__w_itempricepolicy_form.png) |
| 924 | Basic Data \| Item .......... \| Item Alert | opened_ok | `w_itemalert_form` | [close] Do You want to save changes | 1373 | [1](menu-walk/924_Basic_Data_Item_.........._Item_Alert__w_itemalert_form.png) |
| 929 | Basic Data \| Item .......... \| Sales Tax Schedule | opened_ok | `w_salestaxschedule_form` | [close] Do You want to save changes | 1416 | [1](menu-walk/929_Basic_Data_Item_.........._Sales_Tax_Schedule__w_salestaxschedule_form.png) |
| 930 | Basic Data \| Item .......... \| PCT Codes | opened_ok | `w_pctcodes_form` | [close] Do You want to save changes | 1357 | [1](menu-walk/930_Basic_Data_Item_.........._PCT_Codes__w_pctcodes_form.png) |
| 931 | Basic Data \| Item .......... \| Generic Item Type | opened_ok | `w_genericitemtype_form` | [close] Do You want to save changes | 1388 | [1](menu-walk/931_Basic_Data_Item_.........._Generic_Item_Type__w_genericitemtype_form.png) |
| 932 | Basic Data \| Item .......... \| Item Thickness | opened_ok | `w_itemthickness_form` | [close] Do You want to save changes | 1448 | [1](menu-walk/932_Basic_Data_Item_.........._Item_Thickness__w_itemthickness_form.png) |
| 933 | Basic Data \| Item .......... \| Lock Reason | opened_ok | `w_lockreason` | [close] Do You want to save changes | 1369 | [1](menu-walk/933_Basic_Data_Item_.........._Lock_Reason__w_lockreason.png) |
| 934 | Basic Data \| Item .......... \| Category Segment | opened_ok | `w_categorysegment_form` | [close] Do You want to save changes | 1402 | [1](menu-walk/934_Basic_Data_Item_.........._Category_Segment__w_categorysegment_form.png) |
| 935 | Basic Data \| Item .......... \| Manufacturer Type | opened_ok | `w_manufacturertype_form` | [close] Do You want to save changes | 1330 | [1](menu-walk/935_Basic_Data_Item_.........._Manufacturer_Type__w_manufacturertype_form.png) |
| 944 | Basic Data \| Sale Template | opened_ok | `w_saletemplate` | [close] Do You want to save changes | 1266 | [1](menu-walk/944_Basic_Data_Sale_Template__w_saletemplate.png) |
| 1070 | Basic Data \| Tax Category | opened_ok | `w_taxcategory_form` | [close] Do You want to save changes | 1047 | [1](menu-walk/1070_Basic_Data_Tax_Category__w_taxcategory_form.png) |
| 1073 | Maintenance \| Change Password | opened_ok | `w_changepassword` |  | 5833 | [1](menu-walk/1073_Maintenance_Change_Password__w_changepassword.png) |
| 1074 | Maintenance \| Preferences | opened_ok | `w_preferences` |  | 6246 | [1](menu-walk/1074_Maintenance_Preferences__w_preferences.png) |
| 1081 | Maintenance \| Change Items Price | opened_ok | `w_filter_changeitem_price` |  | 5829 | [1](menu-walk/1081_Maintenance_Change_Items_Price__w_filter_changeitem_price.png) |
| 1082 | Maintenance \| Database Utilities \| Backup Database | skipped | - |  |  | - |
| 1083 | Maintenance \| Database Utilities \| Check Database Integrity | skipped | - |  |  | - |
| 1084 | Maintenance \| Adjustment \| Increase | opened_ok | `w_adjincrease` | [close] Do You want to save changes | 1095 | [1](menu-walk/1084_Maintenance_Adjustment_Increase__w_adjincrease.png) |
| 1085 | Maintenance \| Adjustment \| Decrease | opened_ok | `w_adjwindow` | [close] Do You want to save changes | 1076 | [1](menu-walk/1085_Maintenance_Adjustment_Decrease__w_adjwindow.png) |
| 1086 | Maintenance \| Adjustment \| Stock Adjustment | opened_ok | `w_adjbuffer` | [close] Do You want to save changes | 1034 | [1](menu-walk/1086_Maintenance_Adjustment_Stock_Adjustment__w_adjbuffer.png) |
| 1093 | Maintenance \| Priority Setting | opened_ok | `w_itempriority_form` |  | 999 | [1](menu-walk/1093_Maintenance_Priority_Setting__w_itempriority_form.png) |
| 1099 | Maintenance \| Change Item Discount | opened_ok * | `w_select_changediscmethod` |  | 5837 | [1](menu-walk/1099_Maintenance_Change_Item_Discount__w_select_changediscmethod.png) |
| 1100 | Maintenance \| Modify Sale Invoices | opened_ok * | `w_selectformat_period_invrange` |  | 5832 | [1](menu-walk/1100_Maintenance_Modify_Sale_Invoices__w_selectformat_period_invrange.png) |
| 1101 | Maintenance \| Modify Last Transaction Date | opened_ok | `w_set_lasttransdate` |  | 5856 | [1](menu-walk/1101_Maintenance_Modify_Last_Transaction_Date__w_set_lasttransdate.png) |
| 1106 | Maintenance \| Godown Preferences \| Group Wise Godown Setting | failed | `w_arg_group` |  | 5842 | [1](menu-walk/1106_Maintenance_Godown_Preferences_Group_Wise_Godown_Setting__w_arg_group.png) |
| 1112 | Maintenance \| Interface Setting | opened_ok | `w_interfacesetting` |  | 6058 | [1](menu-walk/1112_Maintenance_Interface_Setting__w_interfacesetting.png) |
| 1145 | Maintenance \| Update Item Basic Data | opened_ok | `w_select_manf_cat_class_pack_saleorder` |  | 5851 | [1](menu-walk/1145_Maintenance_Update_Item_Basic_Data__w_select_manf_cat_class_pack_saleorder.png) |
| 1150 | Maintenance \| Update Item Suppliers | opened_ok | `w_itemsuppliers_form` | [close] Do You want to save changes | 1037 | [1](menu-walk/1150_Maintenance_Update_Item_Suppliers__w_itemsuppliers_form.png) |
| 1153 | Maintenance \| Change Item Reorder Qty | opened_ok | `w_select_manf_cat_class_packing_combined` |  | 5857 | [1](menu-walk/1153_Maintenance_Change_Item_Reorder_Qty__w_select_manf_cat_class_packing_combined.png) |
| 1162 | Maintenance \| Import Historical Data \| Import Previous Sales | skipped | - |  |  | - |
| 1165 | Maintenance \| Inplace Initialization | skipped | - |  |  | - |
| 1173 | Maintenance \| Lock Item Batches | skipped | - |  |  | - |
| 1178 | Manage \| Groups | opened_ok | `w_groups` |  | 856 | [1](menu-walk/1178_Manage_Groups__w_groups.png) |
| 1179 | Manage \| Users | opened_ok | `w_users` | [close] Do You want to save changes | 1042 | [1](menu-walk/1179_Manage_Users__w_users.png) |
| 1182 | Manage \| Group Wise Header Setting | failed | `w_arg_group` |  | 5851 | [1](menu-walk/1182_Manage_Group_Wise_Header_Setting__w_arg_group.png) |
| 1199 | Manage \| Group Allowed Price Setting | opened_ok | `w_groupwiseallowedprices` | [close] Do You want to save changes | 1034 | [1](menu-walk/1199_Manage_Group_Allowed_Price_Setting__w_groupwiseallowedprices.png) |
| 1201 | Manage \| Group Wise Cash Account Setting | opened_ok | `w_groupwiseallowedcashaccount` | [close] Do You want to save changes | 1044 | [1](menu-walk/1201_Manage_Group_Wise_Cash_Account_Setting__w_groupwiseallowedcashaccount.png) |
| 1206 | Manage \| Session Monitor Ctrl+Alt+M | opened_ok * | `w_connectionmonitor`, `w_salesmanpassword` |  | 5933 | [1](menu-walk/1206_Manage_Session_Monitor_Ctrl+Alt+M__w_connectionmonitor.png) [2](menu-walk/1206_Manage_Session_Monitor_Ctrl+Alt+M__w_salesmanpassword.png) |
| 1212 | Manage \| Cashier Management \| Cashier Job | opened_ok | `w_cashierjob` |  | 830 | [1](menu-walk/1212_Manage_Cashier_Management_Cashier_Job__w_cashierjob.png) |
| 1213 | Manage \| Cashier Management \| Cashier Activity Window | no_window | - | Unable to fetch cashier job data from database \|\| [close] Unable to fetch cashier job data from database | 1254 | [1](menu-walk/1213_Manage_Cashier_Management_Cashier_Activity_Window__modal.png) |
| 1231 | Manage \| Job Schedule | opened_ok * | `w_job_schedule` |  | 6261 | [1](menu-walk/1231_Manage_Job_Schedule__w_job_schedule.png) |
| 1232 | Manage \| Group Wise Supplier Category | opened_ok | `w_groupsuppcategory` |  | 1038 | [1](menu-walk/1232_Manage_Group_Wise_Supplier_Category__w_groupsuppcategory.png) |
| 1277 | Help \| About | opened_ok | `w_about` |  | 5908 | [1](menu-walk/1277_Help_About__w_about.png) |

`*` = the menu click handler was still pending when the screen was closed (see the section above).

## Skipped by safety policy

| # | Caption path | Reason |
|---:|---|---|
| 1 | File \| Change User | safety policy: would log the ADMIN session off |
| 3 | File \| Exit Ctrl+X | safety policy: would halt the application |
| 1082 | Maintenance \| Database Utilities \| Backup Database | safety policy: runs a database backup (writes files) |
| 1083 | Maintenance \| Database Utilities \| Check Database Integrity | safety policy: long database-wide integrity utility |
| 1162 | Maintenance \| Import Historical Data \| Import Previous Sales | safety policy: imports data |
| 1165 | Maintenance \| Inplace Initialization | safety policy: writes initialization data |
| 1173 | Maintenance \| Lock Item Batches | safety policy: locks item batches (writes data) |

## Hidden / disabled leaves

These are in the live menu tree but not reachable for ADMIN (hidden by rights or disabled). Exact paths and per-item state are in `menu-walk.json`.

| Top level | Total | Hidden | Visible but disabled |
|---|---:|---:|---:|
| Reports | 607 | 607 | 0 |
| Basic Data | 184 | 184 | 0 |
| Maintenance | 85 | 85 | 0 |
| Manage | 47 | 47 | 0 |
| Sales | 40 | 40 | 0 |
| Purchase | 23 | 23 | 0 |
| Transactions | 23 | 23 | 0 |
| E-Prescription | 16 | 16 | 0 |
| Activities | 13 | 13 | 0 |
| Patient Management | 11 | 11 | 0 |
| Window | 2 | 1 | 1 |

## How to repeat

```powershell
cd C:\Projects\Abuzar\deploy\parity\pw
node menu-walk.mjs
# quick subset:
node menu-walk.mjs --only "Basic Data" --max-ms 600000
```

The JSON next to this report has every leaf (including hidden/disabled), the exact click result, window classes, titles, modal texts and screenshots per item.

---

## Retry after session-leak fix

Generated **2026-11-04T00:06:02.612Z** on one fresh page against `http://127.0.0.1:5177` after `httpdb.ts` was changed to send `set_config` through `/api/query` instead of `/api/exec` and the server was restarted.

Retried **10** baseline items: 2 failed, 1 no-window, 7 opened-with-modal. The original baseline table above is unchanged; only these items were re-measured.

| Retry classification | Count |
|---|---:|
| Fixed by the session-leak fix | 7 |
| Real screen failure | 1 |
| Parameterized-popup artifact (needs caller parm) | 2 |

### Remaining real failures

| # | Caption path | Window class | First error line |
|---:|---|---|---|
| 1213 | Manage \| Cashier Management \| Cashier Activity Window | — | Unable to fetch cashier job data from database |

### Parameterized-popup artifacts

These popups expect `message.powerobjectparm` from a caller screen and are not standalone menu screens.

| # | Caption path | Window class | Why it is not a standalone screen |
|---:|---|---|---|
| 1106 | Maintenance \| Godown Preferences \| Group Wise Godown Setting | `w_arg_group` | opens w_arg_group, whose OK sets message.powerobjectparm for the caller screen; a standalone walk cannot supply that parm |
| 1182 | Manage \| Group Wise Header Setting | `w_arg_group` | opens w_arg_group, whose OK sets message.powerobjectparm for the caller screen; a standalone walk cannot supply that parm |

### Fixed by the session fix

| # | Caption path | Baseline outcome | Retry outcome | Window class |
|---:|---|---|---|---|
| 162 | Reports \| Daily Reports \| Quotation \| Detail | opened_with_modal | opened_ok | `w_reviewreport`, `w_arg_sdate_ldate` |
| 208 | Reports \| Stock Reports \| Stock In hand \| Stock in Hand - Audit Purpose | opened_with_modal | opened_ok | `w_reviewreport` |
| 212 | Reports \| Stock Reports \| Reorder Level Report | opened_with_modal | opened_ok | `w_reviewreport`, `w_selection_manf_cat_class_packing` |
| 213 | Reports \| Stock Reports \| Stock Register | opened_with_modal | opened_ok | `w_reviewreport`, `w_arg_items_sdate_ldate_stockregister` |
| 354 | Reports \| Sales Reports \| Manufacturer Wise \| CNIC/NTN Registered Customers Sales | opened_with_modal | opened_ok | `w_reviewreport` |
| 477 | Reports \| Purchase Reports \| Periodic Purchases | opened_with_modal | opened_ok | `w_reviewreport`, `w_arg_sdate_ldate` |
| 598 | Reports \| Listing \| Supplier List | opened_with_modal | opened_ok | `w_reviewreport` |

### Totals after retry

| Outcome | Original baseline | After focused retry |
|---|---:|---:|
| Opened OK | 193 | 200 |
| Opened with modal | 7 | 0 |
| No window | 1 | 0 |
| Failed / exception | 2 | 1 |
| Skipped by safety policy | 7 | 7 |
| Parameterized-popup artifact | 0 | 2 |
| Not run | 0 | 0 |
| **Total actionable** | **210** | **210** |

### Retry evidence

| # | Caption path | Baseline | Retry outcome | Classification | Window class(es) | First error line | Screenshot |
|---:|---|---|---|---|---|---|---|
| 162 | Reports \| Daily Reports \| Quotation \| Detail | opened_with_modal | opened_ok | fixed_by_session_fix | `w_reviewreport`, `w_arg_sdate_ldate` |  | [png](menu-walk/retry_162_Reports_Daily_Reports_Quotation_Detail__w_reviewreport.png) |
| 208 | Reports \| Stock Reports \| Stock In hand \| Stock in Hand - Audit Purpose | opened_with_modal | opened_ok | fixed_by_session_fix | `w_reviewreport` |  | [png](menu-walk/retry_208_Reports_Stock_Reports_Stock_In_hand_Stock_in_Hand_-_Audit_Purpose__w_reviewreport.png) |
| 212 | Reports \| Stock Reports \| Reorder Level Report | opened_with_modal | opened_ok | fixed_by_session_fix | `w_reviewreport`, `w_selection_manf_cat_class_packing` |  | [png](menu-walk/retry_212_Reports_Stock_Reports_Reorder_Level_Report__w_reviewreport.png) |
| 213 | Reports \| Stock Reports \| Stock Register | opened_with_modal | opened_ok | fixed_by_session_fix | `w_reviewreport`, `w_arg_items_sdate_ldate_stockregister` |  | [png](menu-walk/retry_213_Reports_Stock_Reports_Stock_Register__w_reviewreport.png) |
| 354 | Reports \| Sales Reports \| Manufacturer Wise \| CNIC/NTN Registered Customers Sales | opened_with_modal | opened_ok | fixed_by_session_fix | `w_reviewreport` |  | [png](menu-walk/retry_354_Reports_Sales_Reports_Manufacturer_Wise_CNIC_NTN_Registered_Customers_Sales__w_reviewreport.png) |
| 477 | Reports \| Purchase Reports \| Periodic Purchases | opened_with_modal | opened_ok | fixed_by_session_fix | `w_reviewreport`, `w_arg_sdate_ldate` |  | [png](menu-walk/retry_477_Reports_Purchase_Reports_Periodic_Purchases__w_reviewreport.png) |
| 598 | Reports \| Listing \| Supplier List | opened_with_modal | opened_ok | fixed_by_session_fix | `w_reviewreport` |  | [png](menu-walk/retry_598_Reports_Listing_Supplier_List__w_reviewreport.png) |
| 1106 | Maintenance \| Godown Preferences \| Group Wise Godown Setting | failed | opened_ok | parameterized_popup_artifact | `w_arg_group` |  | [png](menu-walk/retry_1106_Maintenance_Godown_Preferences_Group_Wise_Godown_Setting__w_arg_group.png) |
| 1182 | Manage \| Group Wise Header Setting | failed | opened_ok | parameterized_popup_artifact | `w_arg_group` |  | [png](menu-walk/retry_1182_Manage_Group_Wise_Header_Setting__w_arg_group.png) |
| 1213 | Manage \| Cashier Management \| Cashier Activity Window | no_window | no_window | real_screen_failure | — | Unable to fetch cashier job data from database | [png](menu-walk/retry_1213_Manage_Cashier_Management_Cashier_Activity_Window__modal.png) |

Retry screenshots are prefixed `retry_` and are next to the baseline screenshots in `menu-walk/`. The original per-item screenshots are untouched.
