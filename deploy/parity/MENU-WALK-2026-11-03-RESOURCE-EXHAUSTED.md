# Menu walk baseline

Generated **2026-11-03T14:44:25.507Z** against `http://127.0.0.1:5174`.

Run duration **1709 s**; menu root class `m_entry`; **1477** menu nodes, **265** visible nodes, **1277** leaf nodes (16 separators, 1261 menu leaf items).

Every visible+enabled leaf was clicked through `window.__menu(path)` in menu order. The window was captured at 1920x1080, any message box was recorded and dismissed with No/Cancel/Close, then the sheet was closed through `rt.closeWindow` without saving, printing, posting or fiscalising anything.

## Summary

| Outcome | Count | Share of actionable |
|---|---:|---:|
| **Actionable leaves** (visible + enabled) | **210** | 100% |
| Opened OK (new window, no modal) | 136 | 64.8% |
| Opened with modal message(s) | 8 | 3.8% |
| No window | 18 | 8.6% |
| Failed / exception | 41 | 19.5% |
| Skipped by safety policy | 7 | 3.3% |
| Not run (time budget) | 0 | 0.0% |
| **Screens with a window/DOM view still open after close** | **0** | 0.0% |
| Click handlers still pending after close (warning) | 65 | 31.0% |

| Menu tree | Count |
|---|---:|
| Leaf nodes (all, including separators) | 1277 |
| Separators | 16 |
| Menu leaf items | 1261 |
| Visible menu nodes | 265 |
| Hidden / disabled leaves | 1051 |
| Visible but disabled leaves | 1 |
| Hidden leaves | 1050 |

> The walk recovered the browser **1** time(s) after a screen stopped responding; the affected item is marked failed and the walk continued with the next one.

## Failures / exceptions

| # | Caption path | Window class | Reason | Modal / error | Screenshot |
|---:|---|---|---|---|---|
| 626 | Reports \| RePrinting \| Sale (with summary reports) | `w_reviewreport` | screen stopped responding (timeout) |  | [png](menu-walk/626_Reports_RePrinting_Sale_%28with_summary_reports%29__w_reviewreport.png) |
| 723 | Reports \| Purchase Return Reports \| Supplier Purchase Returns \| Summary | `w_reviewreport` | click threw: TypeError: Failed to fetch at DwCatalog.text [as read] (http://127.0.0.1:5174/src/main.ts:23:21)… | http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/api… | [png](menu-walk/723_Reports_Purchase_Return_Reports_Supplier_Purchase_Returns_Summary__w_reviewreport.png) |
| 875 | Basic Data \| Customer .......... \| Customer Category | — | click threw: TypeError: Failed to fetch at text (http://127.0.0.1:5174/src/main.ts:27:19) at JsonClassLoader.… | http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/data/classes/w_custcategory_form.json net::ERR_INSUFFICIENT_RESOURCES … | [png](menu-walk/875_Basic_Data_Customer_.........._Customer_Category__state.png) |
| 894 | Basic Data \| Customer .......... \| Sale Promotion | — | click threw: TypeError: Failed to fetch at text (http://127.0.0.1:5174/src/main.ts:27:19) at JsonClassLoader.… | http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/dat… | [png](menu-walk/894_Basic_Data_Customer_.........._Sale_Promotion__state.png) |
| 895 | Basic Data \| Customer .......... \| Customer Sector | — | click threw: TypeError: Failed to fetch at text (http://127.0.0.1:5174/src/main.ts:27:19) at JsonClassLoader.… | http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/api… | [png](menu-walk/895_Basic_Data_Customer_.........._Customer_Sector__state.png) |
| 896 | Basic Data \| Supplier .......... \| Supplier | — | click threw: TypeError: Failed to fetch at text (http://127.0.0.1:5174/src/main.ts:27:19) at JsonClassLoader.… | http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/api… | [png](menu-walk/896_Basic_Data_Supplier_.........._Supplier__state.png) |
| 897 | Basic Data \| Supplier .......... \| Supplier Category | — | click threw: TypeError: Failed to fetch at text (http://127.0.0.1:5174/src/main.ts:27:19) at JsonClassLoader.… | http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/data/classes/w_suppliercategory_form.json net::ERR_INSUFFICIENT_RESOUR… | [png](menu-walk/897_Basic_Data_Supplier_.........._Supplier_Category__state.png) |
| 900 | Basic Data \| Item .......... \| Item | — | click threw: TypeError: Failed to fetch at text (http://127.0.0.1:5174/src/main.ts:27:19) at JsonClassLoader.… | http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/api… | [png](menu-walk/900_Basic_Data_Item_.........._Item__state.png) |
| 901 | Basic Data \| Item .......... \| Manufacturer | — | click threw: TypeError: Failed to fetch at text (http://127.0.0.1:5174/src/main.ts:27:19) at JsonClassLoader.… | http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/data/classes/w_manufacturer_form.json net::ERR_INSUFFICIENT_RESOURCES … | [png](menu-walk/901_Basic_Data_Item_.........._Manufacturer__state.png) |
| 902 | Basic Data \| Item .......... \| Item Class | — | click threw: TypeError: Failed to fetch at text (http://127.0.0.1:5174/src/main.ts:27:19) at JsonClassLoader.… | http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/api… | [png](menu-walk/902_Basic_Data_Item_.........._Item_Class__state.png) |
| 903 | Basic Data \| Item .......... \| Item Category | — | click threw: TypeError: Failed to fetch at text (http://127.0.0.1:5174/src/main.ts:27:19) at JsonClassLoader.… | http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/api… | [png](menu-walk/903_Basic_Data_Item_.........._Item_Category__state.png) |
| 922 | Basic Data \| Item .......... \| Price Policy | — | click threw: TypeError: Failed to fetch at text (http://127.0.0.1:5174/src/main.ts:27:19) at JsonClassLoader.… | http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/data/classes/w_itempricepolicy_form.json net::ERR_INSUFFICIENT_RESOURC… | [png](menu-walk/922_Basic_Data_Item_.........._Price_Policy__state.png) |
| 924 | Basic Data \| Item .......... \| Item Alert | — | click threw: TypeError: Failed to fetch at text (http://127.0.0.1:5174/src/main.ts:27:19) at JsonClassLoader.… | http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/api… | [png](menu-walk/924_Basic_Data_Item_.........._Item_Alert__state.png) |
| 930 | Basic Data \| Item .......... \| PCT Codes | — | click threw: TypeError: Failed to fetch at text (http://127.0.0.1:5174/src/main.ts:27:19) at JsonClassLoader.… | http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/api… | [png](menu-walk/930_Basic_Data_Item_.........._PCT_Codes__state.png) |
| 931 | Basic Data \| Item .......... \| Generic Item Type | — | click threw: TypeError: Failed to fetch at text (http://127.0.0.1:5174/src/main.ts:27:19) at JsonClassLoader.… | http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/api… | [png](menu-walk/931_Basic_Data_Item_.........._Generic_Item_Type__state.png) |
| 933 | Basic Data \| Item .......... \| Lock Reason | — | click threw: TypeError: Failed to fetch at text (http://127.0.0.1:5174/src/main.ts:27:19) at JsonClassLoader.… | Failed to fetch \|\| [close] Failed to fetch | [png](menu-walk/933_Basic_Data_Item_.........._Lock_Reason__modal.png) |
| 934 | Basic Data \| Item .......... \| Category Segment | — | click threw: TypeError: Failed to fetch at text (http://127.0.0.1:5174/src/main.ts:27:19) at JsonClassLoader.… | http://127.0.0.1:5174/data/classes/w_categorysegment_form.json net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURC… | [png](menu-walk/934_Basic_Data_Item_.........._Category_Segment__state.png) |
| 935 | Basic Data \| Item .......... \| Manufacturer Type | — | click threw: TypeError: Failed to fetch at text (http://127.0.0.1:5174/src/main.ts:27:19) at JsonClassLoader.… | http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/data/classes/w_manufacturertype_form.json net::ERR_INSUFFICIENT_RESOUR… | [png](menu-walk/935_Basic_Data_Item_.........._Manufacturer_Type__state.png) |
| 944 | Basic Data \| Sale Template | — | click threw: TypeError: Failed to fetch at text (http://127.0.0.1:5174/src/main.ts:27:19) at JsonClassLoader.… | http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/api… | [png](menu-walk/944_Basic_Data_Sale_Template__state.png) |
| 1070 | Basic Data \| Tax Category | — | click threw: TypeError: Failed to fetch at text (http://127.0.0.1:5174/src/main.ts:27:19) at JsonClassLoader.… | http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/api… | [png](menu-walk/1070_Basic_Data_Tax_Category__state.png) |
| 1074 | Maintenance \| Preferences | — | click threw: TypeError: Failed to fetch at text (http://127.0.0.1:5174/src/main.ts:27:19) at JsonClassLoader.… | Failed to fetch \|\| [close] Failed to fetch | [png](menu-walk/1074_Maintenance_Preferences__modal.png) |
| 1081 | Maintenance \| Change Items Price | — | click threw: TypeError: Failed to fetch at text (http://127.0.0.1:5174/src/main.ts:27:19) at JsonClassLoader.… | http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/api… | [png](menu-walk/1081_Maintenance_Change_Items_Price__state.png) |
| 1084 | Maintenance \| Adjustment \| Increase | — | click threw: TypeError: Failed to fetch at text (http://127.0.0.1:5174/src/main.ts:27:19) at JsonClassLoader.… | http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/api… | [png](menu-walk/1084_Maintenance_Adjustment_Increase__state.png) |
| 1085 | Maintenance \| Adjustment \| Decrease | — | click threw: TypeError: Failed to fetch at text (http://127.0.0.1:5174/src/main.ts:27:19) at JsonClassLoader.… | http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/api… | [png](menu-walk/1085_Maintenance_Adjustment_Decrease__state.png) |
| 1086 | Maintenance \| Adjustment \| Stock Adjustment | — | click threw: TypeError: Failed to fetch at text (http://127.0.0.1:5174/src/main.ts:27:19) at JsonClassLoader.… | http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/data/classes/w_adjbuffer.json net::ERR_INSUFFICIENT_RESOURCES \|\| http:… | [png](menu-walk/1086_Maintenance_Adjustment_Stock_Adjustment__state.png) |
| 1093 | Maintenance \| Priority Setting | — | click threw: TypeError: Failed to fetch at text (http://127.0.0.1:5174/src/main.ts:27:19) at JsonClassLoader.… | http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/api… | [png](menu-walk/1093_Maintenance_Priority_Setting__state.png) |
| 1099 | Maintenance \| Change Item Discount | — | click threw: TypeError: Failed to fetch at text (http://127.0.0.1:5174/src/main.ts:27:19) at JsonClassLoader.… | http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/api… | [png](menu-walk/1099_Maintenance_Change_Item_Discount__state.png) |
| 1100 | Maintenance \| Modify Sale Invoices | — | click threw: TypeError: Failed to fetch at text (http://127.0.0.1:5174/src/main.ts:27:19) at JsonClassLoader.… | http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/api… | [png](menu-walk/1100_Maintenance_Modify_Sale_Invoices__state.png) |
| 1106 | Maintenance \| Godown Preferences \| Group Wise Godown Setting | — | click threw: TypeError: Failed to fetch at text (http://127.0.0.1:5174/src/main.ts:27:19) at JsonClassLoader.… | http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/api… | [png](menu-walk/1106_Maintenance_Godown_Preferences_Group_Wise_Godown_Setting__state.png) |
| 1145 | Maintenance \| Update Item Basic Data | — | click threw: TypeError: Failed to fetch at text (http://127.0.0.1:5174/src/main.ts:27:19) at JsonClassLoader.… | http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/api… | [png](menu-walk/1145_Maintenance_Update_Item_Basic_Data__state.png) |
| 1150 | Maintenance \| Update Item Suppliers | — | click threw: TypeError: Failed to fetch at text (http://127.0.0.1:5174/src/main.ts:27:19) at JsonClassLoader.… | http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/api… | [png](menu-walk/1150_Maintenance_Update_Item_Suppliers__state.png) |
| 1178 | Manage \| Groups | — | click threw: TypeError: Failed to fetch at text (http://127.0.0.1:5174/src/main.ts:27:19) at JsonClassLoader.… | http://127.0.0.1:5174/data/classes/w_groups.json net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://1… | [png](menu-walk/1178_Manage_Groups__state.png) |
| 1179 | Manage \| Users | — | click threw: TypeError: Failed to fetch at text (http://127.0.0.1:5174/src/main.ts:27:19) at JsonClassLoader.… | http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/dat… | [png](menu-walk/1179_Manage_Users__state.png) |
| 1182 | Manage \| Group Wise Header Setting | — | click threw: TypeError: Failed to fetch at text (http://127.0.0.1:5174/src/main.ts:27:19) at JsonClassLoader.… | http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/api… | [png](menu-walk/1182_Manage_Group_Wise_Header_Setting__state.png) |
| 1199 | Manage \| Group Allowed Price Setting | — | click threw: TypeError: Failed to fetch at text (http://127.0.0.1:5174/src/main.ts:27:19) at JsonClassLoader.… | http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/data/classes/w_groupwiseallowedprices.json net::ERR_INSUFFICIENT_RESOU… | [png](menu-walk/1199_Manage_Group_Allowed_Price_Setting__state.png) |
| 1201 | Manage \| Group Wise Cash Account Setting | — | click threw: TypeError: Failed to fetch at text (http://127.0.0.1:5174/src/main.ts:27:19) at JsonClassLoader.… | http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/dat… | [png](menu-walk/1201_Manage_Group_Wise_Cash_Account_Setting__state.png) |
| 1206 | Manage \| Session Monitor Ctrl+Alt+M | — | click threw: TypeError: Failed to fetch at text (http://127.0.0.1:5174/src/main.ts:27:19) at JsonClassLoader.… | http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/dat… | [png](menu-walk/1206_Manage_Session_Monitor_Ctrl+Alt+M__state.png) |
| 1212 | Manage \| Cashier Management \| Cashier Job | — | click threw: TypeError: Failed to fetch at text (http://127.0.0.1:5174/src/main.ts:27:19) at JsonClassLoader.… | http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/api… | [png](menu-walk/1212_Manage_Cashier_Management_Cashier_Job__state.png) |
| 1231 | Manage \| Job Schedule | — | click threw: TypeError: Failed to fetch at text (http://127.0.0.1:5174/src/main.ts:27:19) at JsonClassLoader.… | http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/api… | [png](menu-walk/1231_Manage_Job_Schedule__state.png) |
| 1232 | Manage \| Group Wise Supplier Category | — | click threw: TypeError: Failed to fetch at text (http://127.0.0.1:5174/src/main.ts:27:19) at JsonClassLoader.… | http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/api… | [png](menu-walk/1232_Manage_Group_Wise_Supplier_Category__state.png) |
| 1277 | Help \| About | — | click threw: TypeError: Failed to fetch at text (http://127.0.0.1:5174/src/main.ts:27:19) at JsonClassLoader.… | http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/api/query net::ERR_INSUFFICIENT_RESOURCES \|\| http://127.0.0.1:5174/api… | [png](menu-walk/1277_Help_About__state.png) |

## No window

| # | Caption path | Click result | Message / last status |
|---:|---|---|---|
| 7 | Purchase \| Purchases | true (__menu) | WASEELA ABUZAR V2 01.01.2022 : ADMIN : 03/11/26 19:15:57 ✕ File Purchase Sales Reports Basic Data Maintenance Manage Window Help ? |
| 9 | Purchase \| Opening Purchase | true (__menu) | WASEELA ABUZAR V2 01.01.2022 : ADMIN : 03/11/26 19:15:57 ✕ File Purchase Sales Reports Basic Data Maintenance Manage Window Help ? |
| 11 | Purchase \| Purchases (Loose) | true (__menu) | WASEELA ABUZAR V2 01.01.2022 : ADMIN : 03/11/26 19:15:57 ✕ File Purchase Sales Reports Basic Data Maintenance Manage Window Help ? |
| 38 | Sales \| Sale Return \| Cash Sale Return | true (__menu) | WASEELA ABUZAR V2 01.01.2022 : ADMIN : 03/11/26 19:15:57 ✕ File Purchase Sales Reports Basic Data Maintenance Manage Window Help ? |
| 39 | Sales \| Sale Return \| Credit Sale Return | true (__menu) | WASEELA ABUZAR V2 01.01.2022 : ADMIN : 03/11/26 19:15:57 ✕ File Purchase Sales Reports Basic Data Maintenance Manage Window Help ? |
| 40 | Sales \| Open Sale Return \| Cash Sale Return | true (__menu) | WASEELA ABUZAR V2 01.01.2022 : ADMIN : 03/11/26 19:15:57 ✕ File Purchase Sales Reports Basic Data Maintenance Manage Window Help ? |
| 41 | Sales \| Open Sale Return \| Credit Sale Return | true (__menu) | WASEELA ABUZAR V2 01.01.2022 : ADMIN : 03/11/26 19:15:57 ✕ File Purchase Sales Reports Basic Data Maintenance Manage Window Help ! |
| 44 | Sales \| Quotation | true (__menu) | WASEELA ABUZAR V2 01.01.2022 : ADMIN : 03/11/26 19:15:57 ✕ File Purchase Sales Reports Basic Data Maintenance Manage Window Help ? |
| 874 | Basic Data \| Customer .......... \| Customer | false | WASEELA ABUZAR V2 01.01.2022 : ADMIN : 03/11/26 19:37:27 ✕ File Purchase Sales Reports Basic Data Maintenance Manage Window Help RE Ready |
| 915 | Basic Data \| Item .......... \| Generic Item | false | WASEELA ABUZAR V2 01.01.2022 : ADMIN : 03/11/26 19:37:27 ✕ File Purchase Sales Reports Basic Data Maintenance Manage Window Help RE Ready |
| 918 | Basic Data \| Item .......... \| Item Basic Data | false | Failed to fetch \|\| [close] Failed to fetch |
| 929 | Basic Data \| Item .......... \| Sales Tax Schedule | false | WASEELA ABUZAR V2 01.01.2022 : ADMIN : 03/11/26 19:37:27 ✕ File Purchase Sales Reports Basic Data Maintenance Manage Window Help RE Ready |
| 932 | Basic Data \| Item .......... \| Item Thickness | false | WASEELA ABUZAR V2 01.01.2022 : ADMIN : 03/11/26 19:37:27 ✕ File Purchase Sales Reports Basic Data Maintenance Manage Window Help RE Ready Application error Failed to fet… |
| 1073 | Maintenance \| Change Password | false | WASEELA ABUZAR V2 01.01.2022 : ADMIN : 03/11/26 19:37:27 ✕ File Purchase Sales Reports Basic Data Maintenance Manage Window Help RE Ready |
| 1101 | Maintenance \| Modify Last Transaction Date | false | WASEELA ABUZAR V2 01.01.2022 : ADMIN : 03/11/26 19:37:27 ✕ File Purchase Sales Reports Basic Data Maintenance Manage Window Help RE Ready |
| 1112 | Maintenance \| Interface Setting | false | WASEELA ABUZAR V2 01.01.2022 : ADMIN : 03/11/26 19:37:27 ✕ File Purchase Sales Reports Basic Data Maintenance Manage Window Help RE Ready |
| 1153 | Maintenance \| Change Item Reorder Qty | false | WASEELA ABUZAR V2 01.01.2022 : ADMIN : 03/11/26 19:37:27 ✕ File Purchase Sales Reports Basic Data Maintenance Manage Window Help RE Ready |
| 1213 | Manage \| Cashier Management \| Cashier Activity Window | false | WASEELA ABUZAR V2 01.01.2022 : ADMIN : 03/11/26 19:37:27 ✕ File Purchase Sales Reports Basic Data Maintenance Manage Window Help RE Ready |

## Windows left open after close

Every clicked screen was fully closed through `rt.closeWindow` before the next item.

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
| 204 | Reports \| Stock Reports \| Stock In hand \| Supplier Manufacturer Association | opened_ok | `w_reviewreport` |
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
| 435 | Reports \| Sales Reports \| Net Sale Summary | opened_ok | `w_selectformat_slowfastmoving`, `w_reviewreport`, `w_arg_sdate_ldate` |
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
| 522 | Reports \| Accounts Reports \| Ledger Reports \| Accounts Ledger | opened_ok | `w_reviewreport`, `w_arg_accounts_sdate_ldate` |
| 691 | Reports \| Item Reports \| History \| Sale Price Difference | opened_ok | `w_reviewreport` |
| 692 | Reports \| Item Reports \| History \| Item Basic Data Changes | opened_ok | `w_reviewreport` |
| 693 | Reports \| Item Reports \| History \| Item Sale Price Changes | opened_ok | `w_reviewreport` |
| 695 | Reports \| Item Reports \| History \| New Item(s) Created/Defined | opened_with_modal | `w_reviewreport` |
| 698 | Reports \| Item Reports \| Stock Adjustments \| Stock Adjustments Detail | opened_ok | `w_reviewreport` |
| 700 | Reports \| Item Reports \| Deleted Sale Items Log | opened_ok | `w_reviewreport` |
| 722 | Reports \| Purchase Return Reports \| Supplier Purchase Returns \| Detail | opened_ok | `w_reviewreport` |
| 874 | Basic Data \| Customer .......... \| Customer | no_window | — |
| 915 | Basic Data \| Item .......... \| Generic Item | no_window | — |
| 918 | Basic Data \| Item .......... \| Item Basic Data | no_window | — |
| 929 | Basic Data \| Item .......... \| Sales Tax Schedule | no_window | — |
| 932 | Basic Data \| Item .......... \| Item Thickness | no_window | — |
| 1073 | Maintenance \| Change Password | no_window | — |
| 1101 | Maintenance \| Modify Last Transaction Date | no_window | — |
| 1112 | Maintenance \| Interface Setting | no_window | — |
| 1153 | Maintenance \| Change Item Reorder Qty | no_window | — |
| 1213 | Manage \| Cashier Management \| Cashier Activity Window | no_window | — |

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
| 695 | Reports \| Item Reports \| History \| New Item(s) Created/Defined | `w_reviewreport` | Failed to fetch |

## Top page / console / SQL / application messages

| # | Type | Message | Count | First seen at |
|---:|---|---|---:|---|
| 1 | http | N http://N.N:N/api/query {"error":{"code":"NOSESSION","message":"unknown session"}} | 10 | Purchase \| Purchase Return |
| 2 | console | PBRuntimeError: Null object reference (reading i_status) at Runtime.getMember (http://N.N:N/src/runtime/interp.ts:N:N) at Runtime.eval (http://N.N:N/src/runtime/interp.ts:N:N) at async Runtime.evalBi… | 5 | (startup / between items) |
| 3 | console | TypeError: Failed to fetch at text (http://N.N:N/src/main.ts:N:N) at JsonClassLoader.read (http://N.N:N/src/main.ts:N:N) at JsonClassLoader.load (http://N.N:N/src/runtime/loader.ts:N:N) at Runtime.ge… | 5 | Reports \| Item Reports \| History \| Item Sale Price Changes |
| 4 | modal | Failed to fetch | 4 | Reports \| Item Reports \| History \| New Item(s) Created/Defined |
| 5 | modal | Null object reference (reading i_status) (in f_retrieve_report6.f_retrieve_report6.f_retrieve_report6) | 2 | Reports \| Stock Reports \| Stock In hand \| Stock in Hand - Audit Purpose |
| 6 | pageerror | Failed to fetch | 1 | Reports \| Purchase Return Reports \| Supplier Purchase Returns \| Summary |
| 7 | modal | Not a DataWindowChild | 1 | Reports \| Stock Reports \| Reorder Level Report |
| 8 | modal | Null object reference (reading i_status) (in f_retrieve_report1.f_retrieve_report1.f_retrieve_report1) | 1 | Reports \| Listing \| Supplier List |
| 9 | modal | Null object reference (reading i_status) (in f_retrieve_report7.f_retrieve_report7.f_retrieve_report7) | 1 | Reports \| Purchase Reports \| Periodic Purchases |
| 10 | modal | Null object reference (writing s_name1) (in f_retrieve_report6.f_retrieve_report6.f_retrieve_report6) | 1 | Reports \| Daily Reports \| Quotation \| Detail |
| 11 | modal | Null object reference (writing s_name7) (in f_retrieve_report.f_retrieve_report.f_retrieve_report) | 1 | Reports \| Stock Reports \| Stock Register |
| 12 | console | PBRuntimeError: Null object reference (writing s_name1) at Runtime.assign (http://N.N:N/src/runtime/interp.ts:N:N) at async Runtime.exec (http://N.N:N/src/runtime/interp.ts:N:N) at async Runtime.exec… | 1 | Reports \| Daily Reports \| Adjustment \| Item Wise Adjustment Summary |
| 13 | console | PBRuntimeError: Null object reference (writing s_name7) at Runtime.assign (http://N.N:N/src/runtime/interp.ts:N:N) at async Runtime.exec (http://N.N:N/src/runtime/interp.ts:N:N) at async Runtime.exec… | 1 | Reports \| Stock Reports \| Reorder Level Report |

## Item evidence

All actionable leaves, in walk order. Screenshot links are relative to `deploy/parity/`.

| # | Caption path | Outcome | Window class(es) | Messages (open/close) | ms | Screenshot |
|---:|---|---|---|---|---:|---|
| 1 | File \| Change User | skipped | - |  |  | - |
| 3 | File \| Exit Ctrl+X | skipped | - |  |  | - |
| 7 | Purchase \| Purchases | no_window | - |  | 1618 | [1](menu-walk/007_Purchase_Purchases__state.png) |
| 8 | Purchase \| Purchase Return | opened_ok | `w_purchasereturn` |  | 1383 | [1](menu-walk/008_Purchase_Purchase_Return__w_purchasereturn.png) |
| 9 | Purchase \| Opening Purchase | no_window | - |  | 1021 | [1](menu-walk/009_Purchase_Opening_Purchase__state.png) |
| 11 | Purchase \| Purchases (Loose) | no_window | - |  | 2270 | [1](menu-walk/011_Purchase_Purchases_%28Loose%29__state.png) |
| 17 | Purchase \| Purchase Orders | opened_ok | `w_purchaseorder` |  | 853 | [1](menu-walk/017_Purchase_Purchase_Orders__w_purchaseorder.png) |
| 35 | Sales \| CashSale | opened_ok | `w_sale` | [close] Do You want to save changes | 2801 | [1](menu-walk/035_Sales_CashSale__w_sale.png) |
| 36 | Sales \| Credit Sale | opened_ok | `w_sale` |  | 4519 | [1](menu-walk/036_Sales_Credit_Sale__w_sale.png) |
| 38 | Sales \| Sale Return \| Cash Sale Return | no_window | - |  | 1117 | [1](menu-walk/038_Sales_Sale_Return_Cash_Sale_Return__state.png) |
| 39 | Sales \| Sale Return \| Credit Sale Return | no_window | - |  | 973 | [1](menu-walk/039_Sales_Sale_Return_Credit_Sale_Return__state.png) |
| 40 | Sales \| Open Sale Return \| Cash Sale Return | no_window | - |  | 968 | [1](menu-walk/040_Sales_Open_Sale_Return_Cash_Sale_Return__state.png) |
| 41 | Sales \| Open Sale Return \| Credit Sale Return | no_window | - |  | 950 | [1](menu-walk/041_Sales_Open_Sale_Return_Credit_Sale_Return__state.png) |
| 44 | Sales \| Quotation | no_window | - |  | 1420 | [1](menu-walk/044_Sales_Quotation__state.png) |
| 79 | Sales \| Refused Sales | opened_ok | `w_refusedsales` | [close] Do You want to save changes | 1101 | [1](menu-walk/079_Sales_Refused_Sales__w_refusedsales.png) |
| 110 | Reports \| Daily Reports \| Sale \| Sale detail | opened_ok * | `w_reviewreport`, `w_selectformat_dailysaledetail` |  | 6202 | [1](menu-walk/110_Reports_Daily_Reports_Sale_Sale_detail__w_reviewreport.png) [2](menu-walk/110_Reports_Daily_Reports_Sale_Sale_detail__w_selectformat_dailysaledetail.png) |
| 111 | Reports \| Daily Reports \| Sale \| Sale summary | opened_ok * | `w_reviewreport`, `w_selectformat_dailysalessummary` |  | 6171 | [1](menu-walk/111_Reports_Daily_Reports_Sale_Sale_summary__w_reviewreport.png) [2](menu-walk/111_Reports_Daily_Reports_Sale_Sale_summary__w_selectformat_dailysalessummary.png) |
| 112 | Reports \| Daily Reports \| Sale \| Sale Summary Inv. Wise | opened_ok | `w_reviewreport`, `w_arg_sinvcode_linvcode` |  | 6191 | [1](menu-walk/112_Reports_Daily_Reports_Sale_Sale_Summary_Inv._Wise__w_reviewreport.png) [2](menu-walk/112_Reports_Daily_Reports_Sale_Sale_Summary_Inv._Wise__w_arg_sinvcode_linvcode.png) |
| 114 | Reports \| Daily Reports \| Sale \| Sale Summary Inv. Cust Wise | opened_ok * | `w_reviewreport`, `w_arg_sinvcode_linvcode_onecust_netamt` |  | 6431 | [1](menu-walk/114_Reports_Daily_Reports_Sale_Sale_Summary_Inv._Cust_Wise__w_reviewreport.png) [2](menu-walk/114_Reports_Daily_Reports_Sale_Sale_Summary_Inv._Cust_Wise__w_arg_sinvcode_linvcode_onecust_netamt.png) |
| 115 | Reports \| Daily Reports \| Sale \| Sale Detail Inv. Wise | opened_ok * | `w_reviewreport`, `w_arg_sinvcode_linvcode_saletype_spres_h` |  | 6363 | [1](menu-walk/115_Reports_Daily_Reports_Sale_Sale_Detail_Inv._Wise__w_reviewreport.png) [2](menu-walk/115_Reports_Daily_Reports_Sale_Sale_Detail_Inv._Wise__w_arg_sinvcode_linvcode_saletype_spres_h.png) |
| 119 | Reports \| Daily Reports \| Sale \| Sale Detail (Format 2) | opened_ok * | `w_reviewreport`, `w_arg_sale_sdate_ldate` |  | 6221 | [1](menu-walk/119_Reports_Daily_Reports_Sale_Sale_Detail_%28Format_2%29__w_reviewreport.png) [2](menu-walk/119_Reports_Daily_Reports_Sale_Sale_Detail_%28Format_2%29__w_arg_sale_sdate_ldate.png) |
| 121 | Reports \| Daily Reports \| Sale \| Refused Sales Detail | opened_ok * | `w_reviewreport`, `w_arg_sdate_ldate` |  | 6453 | [1](menu-walk/121_Reports_Daily_Reports_Sale_Refused_Sales_Detail__w_reviewreport.png) [2](menu-walk/121_Reports_Daily_Reports_Sale_Refused_Sales_Detail__w_arg_sdate_ldate.png) |
| 122 | Reports \| Daily Reports \| Sale \| Sale Detail Inv. Wise(with diff.col.) | opened_ok * | `w_reviewreport`, `w_selectformat_dailysaledetail_pricediff` |  | 6418 | [1](menu-walk/122_Reports_Daily_Reports_Sale_Sale_Detail_Inv._Wise%28with_diff.col.%29__w_reviewreport.png) [2](menu-walk/122_Reports_Daily_Reports_Sale_Sale_Detail_Inv._Wise%28with_diff.col.%29__w_selectformat_dailysaledetail_pricediff.png) |
| 123 | Reports \| Daily Reports \| Sale \| Sale Summary - Invoice Wise | opened_ok | `w_reviewreport`, `w_arg_sinvcode_linvcode_gstperc_date` |  | 6652 | [1](menu-walk/123_Reports_Daily_Reports_Sale_Sale_Summary_-_Invoice_Wise__w_reviewreport.png) [2](menu-walk/123_Reports_Daily_Reports_Sale_Sale_Summary_-_Invoice_Wise__w_arg_sinvcode_linvcode_gstperc_date.png) |
| 128 | Reports \| Daily Reports \| Sale \| Sale Summary Machine and Invoice Range Wise | opened_ok | `w_reviewreport` |  | 1030 | [1](menu-walk/128_Reports_Daily_Reports_Sale_Sale_Summary_Machine_and_Invoice_Range_Wise__w_reviewreport.png) |
| 129 | Reports \| Daily Reports \| Sale \| Selected Sales and Summaries Report | opened_ok | `w_reviewreport` |  | 1011 | [1](menu-walk/129_Reports_Daily_Reports_Sale_Selected_Sales_and_Summaries_Report__w_reviewreport.png) |
| 130 | Reports \| Daily Reports \| Sales Return \| Sales Return detail | opened_ok * | `w_reviewreport`, `w_selectformat_1_2` |  | 6374 | [1](menu-walk/130_Reports_Daily_Reports_Sales_Return_Sales_Return_detail__w_reviewreport.png) [2](menu-walk/130_Reports_Daily_Reports_Sales_Return_Sales_Return_detail__w_selectformat_1_2.png) |
| 131 | Reports \| Daily Reports \| Sales Return \| Sales Return summary | opened_ok * | `w_reviewreport`, `w_arg_sale_return_sdate_ldate` |  | 6333 | [1](menu-walk/131_Reports_Daily_Reports_Sales_Return_Sales_Return_summary__w_reviewreport.png) [2](menu-walk/131_Reports_Daily_Reports_Sales_Return_Sales_Return_summary__w_arg_sale_return_sdate_ldate.png) |
| 132 | Reports \| Daily Reports \| Sales Return \| Sales Return Summary Inv.wise | opened_ok | `w_reviewreport`, `w_arg_sinvcode_linvcode_srtype` |  | 6610 | [1](menu-walk/132_Reports_Daily_Reports_Sales_Return_Sales_Return_Summary_Inv.wise__w_reviewreport.png) [2](menu-walk/132_Reports_Daily_Reports_Sales_Return_Sales_Return_Summary_Inv.wise__w_arg_sinvcode_linvcode_srtype.png) |
| 133 | Reports \| Daily Reports \| Sales Return \| Sales Return Detail Inv.wise | opened_ok | `w_reviewreport`, `w_arg_sinvcode_linvcode` |  | 6499 | [1](menu-walk/133_Reports_Daily_Reports_Sales_Return_Sales_Return_Detail_Inv.wise__w_reviewreport.png) [2](menu-walk/133_Reports_Daily_Reports_Sales_Return_Sales_Return_Detail_Inv.wise__w_arg_sinvcode_linvcode.png) |
| 137 | Reports \| Daily Reports \| Purchase \| Purchase detail | opened_ok * | `w_reviewreport`, `w_arg_sdate_ldate` |  | 6862 | [1](menu-walk/137_Reports_Daily_Reports_Purchase_Purchase_detail__w_reviewreport.png) [2](menu-walk/137_Reports_Daily_Reports_Purchase_Purchase_detail__w_arg_sdate_ldate.png) |
| 138 | Reports \| Daily Reports \| Purchase \| Purchase summary | opened_ok * | `w_reviewreport`, `w_arg_sdate_ldate` |  | 6578 | [1](menu-walk/138_Reports_Daily_Reports_Purchase_Purchase_summary__w_reviewreport.png) [2](menu-walk/138_Reports_Daily_Reports_Purchase_Purchase_summary__w_arg_sdate_ldate.png) |
| 139 | Reports \| Daily Reports \| Purchase \| Purchase Summary2 | opened_ok | `w_reviewreport`, `w_arg_sdate_ldate` |  | 6583 | [1](menu-walk/139_Reports_Daily_Reports_Purchase_Purchase_Summary2__w_reviewreport.png) [2](menu-walk/139_Reports_Daily_Reports_Purchase_Purchase_Summary2__w_arg_sdate_ldate.png) |
| 141 | Reports \| Daily Reports \| Purchase Return \| Purchase Return detail | opened_ok | `w_reviewreport`, `w_arg_sdate_ldate` |  | 6474 | [1](menu-walk/141_Reports_Daily_Reports_Purchase_Return_Purchase_Return_detail__w_reviewreport.png) [2](menu-walk/141_Reports_Daily_Reports_Purchase_Return_Purchase_Return_detail__w_arg_sdate_ldate.png) |
| 142 | Reports \| Daily Reports \| Purchase Return \| Purchase Return summary | opened_ok * | `w_reviewreport`, `w_arg_sdate_ldate` |  | 6616 | [1](menu-walk/142_Reports_Daily_Reports_Purchase_Return_Purchase_Return_summary__w_reviewreport.png) [2](menu-walk/142_Reports_Daily_Reports_Purchase_Return_Purchase_Return_summary__w_arg_sdate_ldate.png) |
| 155 | Reports \| Daily Reports \| Adjustment \| Adjustment Summary | opened_ok | `w_reviewreport`, `w_arg_sdate_ldate_adj` |  | 7210 | [1](menu-walk/155_Reports_Daily_Reports_Adjustment_Adjustment_Summary__w_reviewreport.png) [2](menu-walk/155_Reports_Daily_Reports_Adjustment_Adjustment_Summary__w_arg_sdate_ldate_adj.png) |
| 156 | Reports \| Daily Reports \| Adjustment \| Adjustment Detail | opened_ok | `w_reviewreport`, `w_arg_sdate_ldate_adj` |  | 6733 | [1](menu-walk/156_Reports_Daily_Reports_Adjustment_Adjustment_Detail__w_reviewreport.png) [2](menu-walk/156_Reports_Daily_Reports_Adjustment_Adjustment_Detail__w_arg_sdate_ldate_adj.png) |
| 158 | Reports \| Daily Reports \| Adjustment \| Adjustment Summary Inv. Wise | opened_ok | `w_reviewreport`, `w_arg_sinvcode_linvcode_adjtype` |  | 6993 | [1](menu-walk/158_Reports_Daily_Reports_Adjustment_Adjustment_Summary_Inv._Wise__w_reviewreport.png) [2](menu-walk/158_Reports_Daily_Reports_Adjustment_Adjustment_Summary_Inv._Wise__w_arg_sinvcode_linvcode_adjtype.png) |
| 159 | Reports \| Daily Reports \| Adjustment \| Adjustment Detail Inv. wise | opened_ok | `w_reviewreport`, `w_arg_sinvcode_linvcode_adjtype` |  | 6851 | [1](menu-walk/159_Reports_Daily_Reports_Adjustment_Adjustment_Detail_Inv._wise__w_reviewreport.png) [2](menu-walk/159_Reports_Daily_Reports_Adjustment_Adjustment_Detail_Inv._wise__w_arg_sinvcode_linvcode_adjtype.png) |
| 160 | Reports \| Daily Reports \| Adjustment \| Adjustment Summary/Detail | opened_ok * | `w_reviewreport`, `w_selection_manf_cat_class_packing2` |  | 7340 | [1](menu-walk/160_Reports_Daily_Reports_Adjustment_Adjustment_Summary_Detail__w_reviewreport.png) [2](menu-walk/160_Reports_Daily_Reports_Adjustment_Adjustment_Summary_Detail__w_selection_manf_cat_class_packing2.png) |
| 161 | Reports \| Daily Reports \| Adjustment \| Item Wise Adjustment Summary | opened_ok | `w_reviewreport`, `w_selectformat_summary_detail_adj`, `w_arg_sinv_linv_manf_cat_class_pack` |  | 7892 | [1](menu-walk/161_Reports_Daily_Reports_Adjustment_Item_Wise_Adjustment_Summary__w_reviewreport.png) [2](menu-walk/161_Reports_Daily_Reports_Adjustment_Item_Wise_Adjustment_Summary__w_selectformat_summary_detail_adj.png) [3](menu-walk/161_Reports_Daily_Reports_Adjustment_Item_Wise_Adjustment_Summary__w_arg_sinv_linv_manf_cat_class_pack.png) |
| 162 | Reports \| Daily Reports \| Quotation \| Detail | opened_with_modal | `w_reviewreport`, `w_arg_sdate_ldate` | Null object reference (writing s_name1) (in f_retrieve_report6.f_retrieve_report6.f_retrieve_report6) \|\| [clo… | 7133 | [1](menu-walk/162_Reports_Daily_Reports_Quotation_Detail__modal.png) [2](menu-walk/162_Reports_Daily_Reports_Quotation_Detail__w_reviewreport.png) [3](menu-walk/162_Reports_Daily_Reports_Quotation_Detail__w_arg_sdate_ldate.png) |
| 163 | Reports \| Daily Reports \| Quotation \| Summary | opened_ok | `w_reviewreport`, `w_arg_sdate_ldate` |  | 7228 | [1](menu-walk/163_Reports_Daily_Reports_Quotation_Summary__w_reviewreport.png) [2](menu-walk/163_Reports_Daily_Reports_Quotation_Summary__w_arg_sdate_ldate.png) |
| 179 | Reports \| Daily Reports \| Header Wise Transaction Summary | opened_ok | `w_reviewreport` |  | 1484 | [1](menu-walk/179_Reports_Daily_Reports_Header_Wise_Transaction_Summary__w_reviewreport.png) |
| 180 | Reports \| Daily Reports \| Purchase Order \| Purchase Order Summary | opened_ok * | `w_reviewreport`, `w_arg_sdate_ldate` |  | 6762 | [1](menu-walk/180_Reports_Daily_Reports_Purchase_Order_Purchase_Order_Summary__w_reviewreport.png) [2](menu-walk/180_Reports_Daily_Reports_Purchase_Order_Purchase_Order_Summary__w_arg_sdate_ldate.png) |
| 187 | Reports \| Stock Reports \| Stock In hand \| Manufacturer wise | opened_ok * | `w_reviewreport`, `w_selectformat_stockinhand_manf` |  | 7288 | [1](menu-walk/187_Reports_Stock_Reports_Stock_In_hand_Manufacturer_wise__w_reviewreport.png) [2](menu-walk/187_Reports_Stock_Reports_Stock_In_hand_Manufacturer_wise__w_selectformat_stockinhand_manf.png) |
| 188 | Reports \| Stock Reports \| Stock In hand \| Category wise | opened_ok | `w_reviewreport`, `w_selectformat_stockinhand_categorywise` |  | 7211 | [1](menu-walk/188_Reports_Stock_Reports_Stock_In_hand_Category_wise__w_reviewreport.png) [2](menu-walk/188_Reports_Stock_Reports_Stock_In_hand_Category_wise__w_selectformat_stockinhand_categorywise.png) |
| 189 | Reports \| Stock Reports \| Stock In hand \| Others | opened_ok | `w_stock_filter` |  | 8111 | [1](menu-walk/189_Reports_Stock_Reports_Stock_In_hand_Others__w_stock_filter.png) |
| 190 | Reports \| Stock Reports \| Stock In hand \| Class Wise | opened_ok * | `w_reviewreport`, `w_selectformat_stock_classwise_godown` |  | 7140 | [1](menu-walk/190_Reports_Stock_Reports_Stock_In_hand_Class_Wise__w_reviewreport.png) [2](menu-walk/190_Reports_Stock_Reports_Stock_In_hand_Class_Wise__w_selectformat_stock_classwise_godown.png) |
| 193 | Reports \| Stock Reports \| Stock In hand \| Back Date | opened_ok | `w_reviewreport`, `w_selectstockreport_inbackdate` |  | 7196 | [1](menu-walk/193_Reports_Stock_Reports_Stock_In_hand_Back_Date__w_reviewreport.png) [2](menu-walk/193_Reports_Stock_Reports_Stock_In_hand_Back_Date__w_selectstockreport_inbackdate.png) |
| 198 | Reports \| Stock Reports \| Stock In hand \| Manufacturer Wise (Format2) | opened_ok | `w_reviewreport`, `w_arg_manufacturers_v3` |  | 7184 | [1](menu-walk/198_Reports_Stock_Reports_Stock_In_hand_Manufacturer_Wise_%28Format2%29__w_reviewreport.png) [2](menu-walk/198_Reports_Stock_Reports_Stock_In_hand_Manufacturer_Wise_%28Format2%29__w_arg_manufacturers_v3.png) |
| 204 | Reports \| Stock Reports \| Stock In hand \| Supplier Manufacturer Association | opened_ok * | `w_reviewreport` |  | 6495 | [1](menu-walk/204_Reports_Stock_Reports_Stock_In_hand_Supplier_Manufacturer_Association__w_reviewreport.png) |
| 205 | Reports \| Stock Reports \| Stock In hand \| Stock Quantity Format | opened_ok * | `w_reviewreport`, `w_selection_manf_cat_class_packing` |  | 7380 | [1](menu-walk/205_Reports_Stock_Reports_Stock_In_hand_Stock_Quantity_Format__w_reviewreport.png) [2](menu-walk/205_Reports_Stock_Reports_Stock_In_hand_Stock_Quantity_Format__w_selection_manf_cat_class_packing.png) |
| 208 | Reports \| Stock Reports \| Stock In hand \| Stock in Hand - Audit Purpose | opened_with_modal | `w_reviewreport` | Null object reference (reading i_status) (in f_retrieve_report6.f_retrieve_report6.f_retrieve_report6) \|\| [cl… | 2174 | [1](menu-walk/208_Reports_Stock_Reports_Stock_In_hand_Stock_in_Hand_-_Audit_Purpose__modal.png) [2](menu-walk/208_Reports_Stock_Reports_Stock_In_hand_Stock_in_Hand_-_Audit_Purpose__w_reviewreport.png) |
| 210 | Reports \| Stock Reports \| Stock In hand \| Batch, Priority Wise - Audit Purposes | opened_ok | `w_reviewreport` |  | 1824 | [1](menu-walk/210_Reports_Stock_Reports_Stock_In_hand_Batch,_Priority_Wise_-_Audit_Purposes__w_reviewreport.png) |
| 211 | Reports \| Stock Reports \| Expiry Report | opened_ok * | `w_reviewreport`, `w_selectformat_expiryreport` |  | 7539 | [1](menu-walk/211_Reports_Stock_Reports_Expiry_Report__w_reviewreport.png) [2](menu-walk/211_Reports_Stock_Reports_Expiry_Report__w_selectformat_expiryreport.png) |
| 212 | Reports \| Stock Reports \| Reorder Level Report | opened_with_modal | `w_reviewreport`, `w_selection_manf_cat_class_packing`, `w_arg_manfs_cats_classes_packs_days` | Not a DataWindowChild \|\| [close] Not a DataWindowChild | 8180 | [1](menu-walk/212_Reports_Stock_Reports_Reorder_Level_Report__modal.png) [2](menu-walk/212_Reports_Stock_Reports_Reorder_Level_Report__w_reviewreport.png) [3](menu-walk/212_Reports_Stock_Reports_Reorder_Level_Report__w_selection_manf_cat_class_packing.png) [4](menu-walk/212_Reports_Stock_Reports_Reorder_Level_Report__w_arg_manfs_cats_classes_packs_days.png) |
| 213 | Reports \| Stock Reports \| Stock Register | opened_with_modal | `w_reviewreport`, `w_arg_items_sdate_ldate_stockregister` | Null object reference (writing s_name7) (in f_retrieve_report.f_retrieve_report.f_retrieve_report) \|\| [close]… | 8249 | [1](menu-walk/213_Reports_Stock_Reports_Stock_Register__modal.png) [2](menu-walk/213_Reports_Stock_Reports_Stock_Register__w_reviewreport.png) [3](menu-walk/213_Reports_Stock_Reports_Stock_Register__w_arg_items_sdate_ldate_stockregister.png) |
| 217 | Reports \| Stock Reports \| Item Stock Register Summary | opened_ok | `w_reviewreport`, `w_arg_item_sdate_ldate` |  | 7482 | [1](menu-walk/217_Reports_Stock_Reports_Item_Stock_Register_Summary__w_reviewreport.png) [2](menu-walk/217_Reports_Stock_Reports_Item_Stock_Register_Summary__w_arg_item_sdate_ldate.png) |
| 219 | Reports \| Stock Reports \| Stock Register(For Narcotics) | opened_ok * | `w_reviewreport`, `w_selectformat_1_3` |  | 7209 | [1](menu-walk/219_Reports_Stock_Reports_Stock_Register%28For_Narcotics%29__w_reviewreport.png) [2](menu-walk/219_Reports_Stock_Reports_Stock_Register%28For_Narcotics%29__w_selectformat_1_3.png) |
| 224 | Reports \| Stock Reports \| Stock and Sales | opened_ok | `w_stockandsale_orientation` |  | 9282 | [1](menu-walk/224_Reports_Stock_Reports_Stock_and_Sales__w_stockandsale_orientation.png) |
| 226 | Reports \| Stock Reports \| Optimum Level Report | opened_ok | `w_reviewreport` |  | 6612 | [1](menu-walk/226_Reports_Stock_Reports_Optimum_Level_Report__w_reviewreport.png) |
| 228 | Reports \| Stock Reports \| Item Activity | opened_ok * | `w_reviewreport`, `w_selectformat_itemactivity` |  | 7583 | [1](menu-walk/228_Reports_Stock_Reports_Item_Activity__w_reviewreport.png) [2](menu-walk/228_Reports_Stock_Reports_Item_Activity__w_selectformat_itemactivity.png) |
| 230 | Reports \| Stock Reports \| Stock Register(Narcotics Format2) | opened_ok * | `w_reviewreport`, `w_selectformat_1_5` |  | 7594 | [1](menu-walk/230_Reports_Stock_Reports_Stock_Register%28Narcotics_Format2%29__w_reviewreport.png) [2](menu-walk/230_Reports_Stock_Reports_Stock_Register%28Narcotics_Format2%29__w_selectformat_1_5.png) |
| 231 | Reports \| Stock Reports \| Expiry Report(Class Wise) | opened_ok | `w_reviewreport`, `w_arg_class_day` |  | 7533 | [1](menu-walk/231_Reports_Stock_Reports_Expiry_Report%28Class_Wise%29__w_reviewreport.png) [2](menu-walk/231_Reports_Stock_Reports_Expiry_Report%28Class_Wise%29__w_arg_class_day.png) |
| 232 | Reports \| Stock Reports \| Minimum Level Report | opened_ok | `w_reviewreport`, `w_selection_manf_cat_class_packing` |  | 7307 | [1](menu-walk/232_Reports_Stock_Reports_Minimum_Level_Report__w_reviewreport.png) [2](menu-walk/232_Reports_Stock_Reports_Minimum_Level_Report__w_selection_manf_cat_class_packing.png) |
| 234 | Reports \| Stock Reports \| Reorder/Optimum Level Report | opened_ok * | `w_reviewreport`, `w_selectformat_1_3` |  | 7183 | [1](menu-walk/234_Reports_Stock_Reports_Reorder_Optimum_Level_Report__w_reviewreport.png) [2](menu-walk/234_Reports_Stock_Reports_Reorder_Optimum_Level_Report__w_selectformat_1_3.png) |
| 235 | Reports \| Stock Reports \| Daily Stock IN/OUT | opened_ok | `w_reviewreport`, `w_selection_manf_cat_class_packing` |  | 7453 | [1](menu-walk/235_Reports_Stock_Reports_Daily_Stock_IN_OUT__w_reviewreport.png) [2](menu-walk/235_Reports_Stock_Reports_Daily_Stock_IN_OUT__w_selection_manf_cat_class_packing.png) |
| 236 | Reports \| Stock Reports \| Stock IN/OUT(Date Wise) | opened_ok * | `w_reviewreport`, `w_selectformat_cat_1_or_n` |  | 7664 | [1](menu-walk/236_Reports_Stock_Reports_Stock_IN_OUT%28Date_Wise%29__w_reviewreport.png) [2](menu-walk/236_Reports_Stock_Reports_Stock_IN_OUT%28Date_Wise%29__w_selectformat_cat_1_or_n.png) |
| 245 | Reports \| Stock Reports \| Stock Management Report | opened_ok | `w_reviewreport` |  | 2065 | [1](menu-walk/245_Reports_Stock_Reports_Stock_Management_Report__w_reviewreport.png) |
| 246 | Reports \| Stock Reports \| Norcotics Stock Register-Generic Type Wise | opened_ok | `w_reviewreport` |  | 1858 | [1](menu-walk/246_Reports_Stock_Reports_Norcotics_Stock_Register-Generic_Type_Wise__w_reviewreport.png) |
| 247 | Reports \| Sales Reports \| Customer Sales \| Detail | opened_ok | `w_reviewreport` |  | 1862 | [1](menu-walk/247_Reports_Sales_Reports_Customer_Sales_Detail__w_reviewreport.png) |
| 249 | Reports \| Sales Reports \| Customer Sales \| Summary | opened_ok | `w_reviewreport` |  | 2245 | [1](menu-walk/249_Reports_Sales_Reports_Customer_Sales_Summary__w_reviewreport.png) |
| 250 | Reports \| Sales Reports \| Customer Sales \| Days Summary | opened_ok * | `w_reviewreport`, `w_arg_customers_sdate_ldate_v5` |  | 8540 | [1](menu-walk/250_Reports_Sales_Reports_Customer_Sales_Days_Summary__w_reviewreport.png) [2](menu-walk/250_Reports_Sales_Reports_Customer_Sales_Days_Summary__w_arg_customers_sdate_ldate_v5.png) |
| 253 | Reports \| Sales Reports \| Customer Sales \| Invoice Wise Profit Margin Detail | opened_ok * | `w_reviewreport`, `w_select_invprofitmargin` |  | 8243 | [1](menu-walk/253_Reports_Sales_Reports_Customer_Sales_Invoice_Wise_Profit_Margin_Detail__w_reviewreport.png) [2](menu-walk/253_Reports_Sales_Reports_Customer_Sales_Invoice_Wise_Profit_Margin_Detail__w_select_invprofitmargin.png) |
| 254 | Reports \| Sales Reports \| Customer Sales \| Items Summary | opened_ok * | `w_reviewreport`, `w_arg_cust_sdate_ldate` |  | 8564 | [1](menu-walk/254_Reports_Sales_Reports_Customer_Sales_Items_Summary__w_reviewreport.png) [2](menu-walk/254_Reports_Sales_Reports_Customer_Sales_Items_Summary__w_arg_cust_sdate_ldate.png) |
| 260 | Reports \| Sales Reports \| Customer Sales \| Invoice Summary | opened_ok | `w_reviewreport`, `w_arg_sinvcode_linvcode` |  | 7696 | [1](menu-walk/260_Reports_Sales_Reports_Customer_Sales_Invoice_Summary__w_reviewreport.png) [2](menu-walk/260_Reports_Sales_Reports_Customer_Sales_Invoice_Summary__w_arg_sinvcode_linvcode.png) |
| 261 | Reports \| Sales Reports \| Customer Sales \| Hourly Graph | opened_ok | `w_reviewreport`, `w_arg_sdate_ldate` |  | 7895 | [1](menu-walk/261_Reports_Sales_Reports_Customer_Sales_Hourly_Graph__w_reviewreport.png) [2](menu-walk/261_Reports_Sales_Reports_Customer_Sales_Hourly_Graph__w_arg_sdate_ldate.png) |
| 273 | Reports \| Sales Reports \| Customer Sales \| Customer Category Wise Net Sales | opened_ok | `w_reviewreport`, `w_arg_manf_custcat_sdate_ldate` |  | 8252 | [1](menu-walk/273_Reports_Sales_Reports_Customer_Sales_Customer_Category_Wise_Net_Sales__w_reviewreport.png) [2](menu-walk/273_Reports_Sales_Reports_Customer_Sales_Customer_Category_Wise_Net_Sales__w_arg_manf_custcat_sdate_ldate.png) |
| 292 | Reports \| Sales Reports \| Customer Sales \| Customer Wise Category Net Sales | opened_ok | `w_reviewreport` |  | 2030 | [1](menu-walk/292_Reports_Sales_Reports_Customer_Sales_Customer_Wise_Category_Net_Sales__w_reviewreport.png) |
| 296 | Reports \| Sales Reports \| Customer Sales \| Monthly Net Sales | opened_ok * | `w_reviewreport`, `w_arg_sdate_ldate` |  | 8137 | [1](menu-walk/296_Reports_Sales_Reports_Customer_Sales_Monthly_Net_Sales__w_reviewreport.png) [2](menu-walk/296_Reports_Sales_Reports_Customer_Sales_Monthly_Net_Sales__w_arg_sdate_ldate.png) |
| 312 | Reports \| Sales Reports \| Customer Sales \| Claimable for Allowed Customers | opened_ok | `w_reviewreport` |  | 2579 | [1](menu-walk/312_Reports_Sales_Reports_Customer_Sales_Claimable_for_Allowed_Customers__w_reviewreport.png) |
| 313 | Reports \| Sales Reports \| Customer Sales \| Customer NTN Wise Sales Tax Report | opened_ok | `w_reviewreport` |  | 2303 | [1](menu-walk/313_Reports_Sales_Reports_Customer_Sales_Customer_NTN_Wise_Sales_Tax_Report__w_reviewreport.png) |
| 314 | Reports \| Sales Reports \| Customer Sales \| Customer Wise Advance Tax | opened_ok | `w_reviewreport` |  | 2144 | [1](menu-walk/314_Reports_Sales_Reports_Customer_Sales_Customer_Wise_Advance_Tax__w_reviewreport.png) |
| 316 | Reports \| Sales Reports \| Category Wise \| Sale And Return (One Category) | opened_ok | `w_reviewreport`, `w_arg_cat_sdate_ldate` |  | 9106 | [1](menu-walk/316_Reports_Sales_Reports_Category_Wise_Sale_And_Return_%28One_Category%29__w_reviewreport.png) [2](menu-walk/316_Reports_Sales_Reports_Category_Wise_Sale_And_Return_%28One_Category%29__w_arg_cat_sdate_ldate.png) |
| 317 | Reports \| Sales Reports \| Category Wise \| Sales | opened_ok | `w_reviewreport`, `w_arg_sdate_ldate` |  | 8181 | [1](menu-walk/317_Reports_Sales_Reports_Category_Wise_Sales__w_reviewreport.png) [2](menu-walk/317_Reports_Sales_Reports_Category_Wise_Sales__w_arg_sdate_ldate.png) |
| 319 | Reports \| Sales Reports \| Category Wise \| Deviated Items | opened_ok | `w_reviewreport`, `w_arg_category_sdate_ldate` |  | 7879 | [1](menu-walk/319_Reports_Sales_Reports_Category_Wise_Deviated_Items__w_reviewreport.png) [2](menu-walk/319_Reports_Sales_Reports_Category_Wise_Deviated_Items__w_arg_category_sdate_ldate.png) |
| 320 | Reports \| Sales Reports \| Category Wise \| Monthly Sale | opened_ok | `w_reviewreport`, `w_arg_cust_or_allcust` |  | 8684 | [1](menu-walk/320_Reports_Sales_Reports_Category_Wise_Monthly_Sale__w_reviewreport.png) [2](menu-walk/320_Reports_Sales_Reports_Category_Wise_Monthly_Sale__w_arg_cust_or_allcust.png) |
| 321 | Reports \| Sales Reports \| Category Wise \| Net Sale | opened_ok | `w_reviewreport`, `w_arg_sale_users_withlist_sdate_ldate` |  | 9008 | [1](menu-walk/321_Reports_Sales_Reports_Category_Wise_Net_Sale__w_reviewreport.png) [2](menu-walk/321_Reports_Sales_Reports_Category_Wise_Net_Sale__w_arg_sale_users_withlist_sdate_ldate.png) |
| 322 | Reports \| Sales Reports \| Category Wise \| Gross Profit | opened_ok * | `w_reviewreport`, `w_selectformat_catwise_grossprofit` |  | 8637 | [1](menu-walk/322_Reports_Sales_Reports_Category_Wise_Gross_Profit__w_reviewreport.png) [2](menu-walk/322_Reports_Sales_Reports_Category_Wise_Gross_Profit__w_selectformat_catwise_grossprofit.png) |
| 327 | Reports \| Sales Reports \| Category Wise \| Item Wise Sale Discounts Detail | opened_ok | `w_reviewreport`, `w_arg_category_sdate_ldate` |  | 8099 | [1](menu-walk/327_Reports_Sales_Reports_Category_Wise_Item_Wise_Sale_Discounts_Detail__w_reviewreport.png) [2](menu-walk/327_Reports_Sales_Reports_Category_Wise_Item_Wise_Sale_Discounts_Detail__w_arg_category_sdate_ldate.png) |
| 334 | Reports \| Sales Reports \| Category Wise \| Item Category Wise Monthly Sales | opened_ok | `w_reviewreport`, `w_arg_category_sdate_ldate` |  | 7976 | [1](menu-walk/334_Reports_Sales_Reports_Category_Wise_Item_Category_Wise_Monthly_Sales__w_reviewreport.png) [2](menu-walk/334_Reports_Sales_Reports_Category_Wise_Item_Category_Wise_Monthly_Sales__w_arg_category_sdate_ldate.png) |
| 338 | Reports \| Sales Reports \| Category Wise \| Category Wise Day Net Sale | opened_ok | `w_reviewreport` |  | 2826 | [1](menu-walk/338_Reports_Sales_Reports_Category_Wise_Category_Wise_Day_Net_Sale__w_reviewreport.png) |
| 339 | Reports \| Sales Reports \| Manufacturer Wise \| Sales | opened_ok * | `w_reviewreport`, `w_arg_manufacturers_returnoptions` |  | 9283 | [1](menu-walk/339_Reports_Sales_Reports_Manufacturer_Wise_Sales__w_reviewreport.png) [2](menu-walk/339_Reports_Sales_Reports_Manufacturer_Wise_Sales__w_arg_manufacturers_returnoptions.png) |
| 343 | Reports \| Sales Reports \| Manufacturer Wise \| Sales Detail And Summary | opened_ok * | `w_reviewreport`, `w_selectformat_customer_manf_sales` |  | 10009 | [1](menu-walk/343_Reports_Sales_Reports_Manufacturer_Wise_Sales_Detail_And_Summary__w_reviewreport.png) [2](menu-walk/343_Reports_Sales_Reports_Manufacturer_Wise_Sales_Detail_And_Summary__w_selectformat_customer_manf_sales.png) |
| 344 | Reports \| Sales Reports \| Manufacturer Wise \| Net Sales | opened_ok | `w_reviewreport`, `w_arg_sale_users_withlist_sdate_ldate` |  | 8689 | [1](menu-walk/344_Reports_Sales_Reports_Manufacturer_Wise_Net_Sales__w_reviewreport.png) [2](menu-walk/344_Reports_Sales_Reports_Manufacturer_Wise_Net_Sales__w_arg_sale_users_withlist_sdate_ldate.png) |
| 346 | Reports \| Sales Reports \| Manufacturer Wise \| Item Sales/Discount | opened_ok | `w_reviewreport`, `w_selection_manf_cat_class_packing` |  | 8323 | [1](menu-walk/346_Reports_Sales_Reports_Manufacturer_Wise_Item_Sales_Discount__w_reviewreport.png) [2](menu-walk/346_Reports_Sales_Reports_Manufacturer_Wise_Item_Sales_Discount__w_selection_manf_cat_class_packing.png) |
| 350 | Reports \| Sales Reports \| Manufacturer Wise \| Manufacturer Wise Sales And Return Summary | opened_ok | `w_reviewreport`, `w_arg_grouping_area_period` |  | 8515 | [1](menu-walk/350_Reports_Sales_Reports_Manufacturer_Wise_Manufacturer_Wise_Sales_And_Return_Summary__w_reviewreport.png) [2](menu-walk/350_Reports_Sales_Reports_Manufacturer_Wise_Manufacturer_Wise_Sales_And_Return_Summary__w_arg_grouping_area_period.png) |
| 354 | Reports \| Sales Reports \| Manufacturer Wise \| CNIC/NTN Registered Customers Sales | opened_with_modal | `w_reviewreport` | Null object reference (reading i_status) (in f_retrieve_report6.f_retrieve_report6.f_retrieve_report6) \|\| [cl… | 3328 | [1](menu-walk/354_Reports_Sales_Reports_Manufacturer_Wise_CNIC_NTN_Registered_Customers_Sales__modal.png) [2](menu-walk/354_Reports_Sales_Reports_Manufacturer_Wise_CNIC_NTN_Registered_Customers_Sales__w_reviewreport.png) |
| 369 | Reports \| Sales Reports \| User Wise \| Invoice Graph | opened_ok | `w_reviewreport`, `w_arg_sdate_ldate_perc` |  | 9495 | [1](menu-walk/369_Reports_Sales_Reports_User_Wise_Invoice_Graph__w_reviewreport.png) [2](menu-walk/369_Reports_Sales_Reports_User_Wise_Invoice_Graph__w_arg_sdate_ldate_perc.png) |
| 370 | Reports \| Sales Reports \| User Wise \| Sales | opened_ok * | `w_reviewreport`, `w_selectformat_1_4` |  | 8792 | [1](menu-walk/370_Reports_Sales_Reports_User_Wise_Sales__w_reviewreport.png) [2](menu-walk/370_Reports_Sales_Reports_User_Wise_Sales__w_selectformat_1_4.png) |
| 371 | Reports \| Sales Reports \| User Wise \| Category Summary | opened_ok * | `w_reviewreport`, `w_arg_user_sdate_ldate` |  | 9470 | [1](menu-walk/371_Reports_Sales_Reports_User_Wise_Category_Summary__w_reviewreport.png) [2](menu-walk/371_Reports_Sales_Reports_User_Wise_Category_Summary__w_arg_user_sdate_ldate.png) |
| 372 | Reports \| Sales Reports \| User Wise \| Discount Report | opened_ok | `w_reviewreport`, `w_arg_users_sdate_ldate` |  | 9193 | [1](menu-walk/372_Reports_Sales_Reports_User_Wise_Discount_Report__w_reviewreport.png) [2](menu-walk/372_Reports_Sales_Reports_User_Wise_Discount_Report__w_arg_users_sdate_ldate.png) |
| 375 | Reports \| Sales Reports \| User Wise \| Net Cash | opened_ok * | `w_reviewreport`, `w_arg_user_sdate_ldate` |  | 8638 | [1](menu-walk/375_Reports_Sales_Reports_User_Wise_Net_Cash__w_reviewreport.png) [2](menu-walk/375_Reports_Sales_Reports_User_Wise_Net_Cash__w_arg_user_sdate_ldate.png) |
| 376 | Reports \| Sales Reports \| User Wise \| Sales Commission | opened_ok * | `w_reviewreport`, `w_arg_users_sdate_ldate` |  | 8790 | [1](menu-walk/376_Reports_Sales_Reports_User_Wise_Sales_Commission__w_reviewreport.png) [2](menu-walk/376_Reports_Sales_Reports_User_Wise_Sales_Commission__w_arg_users_sdate_ldate.png) |
| 377 | Reports \| Sales Reports \| User Wise \| User Wise Sales Summary | opened_ok | `w_reviewreport`, `w_arg_sdate_ldate` |  | 8633 | [1](menu-walk/377_Reports_Sales_Reports_User_Wise_User_Wise_Sales_Summary__w_reviewreport.png) [2](menu-walk/377_Reports_Sales_Reports_User_Wise_User_Wise_Sales_Summary__w_arg_sdate_ldate.png) |
| 430 | Reports \| Sales Reports \| Hourly Sales Graph | opened_ok | `w_reviewreport`, `w_arg_sdate_ldate` |  | 9045 | [1](menu-walk/430_Reports_Sales_Reports_Hourly_Sales_Graph__w_reviewreport.png) [2](menu-walk/430_Reports_Sales_Reports_Hourly_Sales_Graph__w_arg_sdate_ldate.png) |
| 431 | Reports \| Sales Reports \| Slow/Fast moving Items | opened_ok * | `w_reviewreport`, `w_selection_manf_cat_class_packing` |  | 8900 | [1](menu-walk/431_Reports_Sales_Reports_Slow_Fast_moving_Items__w_reviewreport.png) [2](menu-walk/431_Reports_Sales_Reports_Slow_Fast_moving_Items__w_selection_manf_cat_class_packing.png) |
| 435 | Reports \| Sales Reports \| Net Sale Summary | opened_ok * | `w_selectformat_slowfastmoving`, `w_reviewreport`, `w_arg_sdate_ldate` |  | 10045 | [1](menu-walk/435_Reports_Sales_Reports_Net_Sale_Summary__w_selectformat_slowfastmoving.png) [2](menu-walk/435_Reports_Sales_Reports_Net_Sale_Summary__w_reviewreport.png) [3](menu-walk/435_Reports_Sales_Reports_Net_Sale_Summary__w_arg_sdate_ldate.png) |
| 439 | Reports \| Sales Reports \| Item Wise \| Item Sale and Return Activity | opened_ok * | `w_reviewreport`, `w_arg_items_sdate_ldate` |  | 9789 | [1](menu-walk/439_Reports_Sales_Reports_Item_Wise_Item_Sale_and_Return_Activity__w_reviewreport.png) [2](menu-walk/439_Reports_Sales_Reports_Item_Wise_Item_Sale_and_Return_Activity__w_arg_items_sdate_ldate.png) |
| 442 | Reports \| Sales Reports \| Item Wise \| Item Wise Net Sales | opened_ok * | `w_reviewreport`, `w_selectformat_item_netsales` |  | 9208 | [1](menu-walk/442_Reports_Sales_Reports_Item_Wise_Item_Wise_Net_Sales__w_reviewreport.png) [2](menu-walk/442_Reports_Sales_Reports_Item_Wise_Item_Wise_Net_Sales__w_selectformat_item_netsales.png) |
| 460 | Reports \| Sales Reports \| Sale/Return Summary Inv. Type Wise | opened_ok * | `w_reviewreport`, `w_selectformat_saleinvtypewisereport` |  | 10461 | [1](menu-walk/460_Reports_Sales_Reports_Sale_Return_Summary_Inv._Type_Wise__w_reviewreport.png) [2](menu-walk/460_Reports_Sales_Reports_Sale_Return_Summary_Inv._Type_Wise__w_selectformat_saleinvtypewisereport.png) |
| 467 | Reports \| Sales Reports \| Daily Sales Summary with Profit(Day wise grouping) | opened_ok | `w_reviewreport` |  | 3296 | [1](menu-walk/467_Reports_Sales_Reports_Daily_Sales_Summary_with_Profit%28Day_wise_grouping%29__w_reviewreport.png) |
| 469 | Reports \| Sales Reports \| Monthly Net Sales Summary | opened_ok | `w_reviewreport`, `w_arg_monthly_netsales_sdate_ldate` |  | 9826 | [1](menu-walk/469_Reports_Sales_Reports_Monthly_Net_Sales_Summary__w_reviewreport.png) [2](menu-walk/469_Reports_Sales_Reports_Monthly_Net_Sales_Summary__w_arg_monthly_netsales_sdate_ldate.png) |
| 471 | Reports \| Sales Reports \| Dead Item List | opened_ok * | `w_reviewreport`, `w_selection_manf_cat_class_packing` |  | 8784 | [1](menu-walk/471_Reports_Sales_Reports_Dead_Item_List__w_reviewreport.png) [2](menu-walk/471_Reports_Sales_Reports_Dead_Item_List__w_selection_manf_cat_class_packing.png) |
| 476 | Reports \| Sales Reports \| Sales Tax Report | opened_ok | `w_reviewreport` |  | 2958 | [1](menu-walk/476_Reports_Sales_Reports_Sales_Tax_Report__w_reviewreport.png) |
| 477 | Reports \| Purchase Reports \| Periodic Purchases | opened_with_modal * | `w_reviewreport`, `w_arg_sdate_ldate` | Null object reference (reading i_status) (in f_retrieve_report7.f_retrieve_report7.f_retrieve_report7) \|\| [cl… | 9800 | [1](menu-walk/477_Reports_Purchase_Reports_Periodic_Purchases__modal.png) [2](menu-walk/477_Reports_Purchase_Reports_Periodic_Purchases__w_reviewreport.png) [3](menu-walk/477_Reports_Purchase_Reports_Periodic_Purchases__w_arg_sdate_ldate.png) |
| 479 | Reports \| Purchase Reports \| Purchase Order | opened_ok * | `w_reviewreport`, `w_selectformat_datewise_invwise` |  | 9890 | [1](menu-walk/479_Reports_Purchase_Reports_Purchase_Order__w_reviewreport.png) [2](menu-walk/479_Reports_Purchase_Reports_Purchase_Order__w_selectformat_datewise_invwise.png) |
| 480 | Reports \| Purchase Reports \| Supplier Wise \| Detail | opened_ok | `w_reviewreport`, `w_arg_supp_sdate_ldate` |  | 8856 | [1](menu-walk/480_Reports_Purchase_Reports_Supplier_Wise_Detail__w_reviewreport.png) [2](menu-walk/480_Reports_Purchase_Reports_Supplier_Wise_Detail__w_arg_supp_sdate_ldate.png) |
| 481 | Reports \| Purchase Reports \| Supplier Wise \| Purchase Detail | opened_ok * | `w_reviewreport`, `w_arg_supplier_all` |  | 9611 | [1](menu-walk/481_Reports_Purchase_Reports_Supplier_Wise_Purchase_Detail__w_reviewreport.png) [2](menu-walk/481_Reports_Purchase_Reports_Supplier_Wise_Purchase_Detail__w_arg_supplier_all.png) |
| 486 | Reports \| Purchase Reports \| Supplier Wise \| Advance Income Tax | opened_ok | `w_reviewreport` |  | 3040 | [1](menu-walk/486_Reports_Purchase_Reports_Supplier_Wise_Advance_Income_Tax__w_reviewreport.png) |
| 487 | Reports \| Purchase Reports \| Manufacturer Wise \| Detail | opened_ok * | `w_reviewreport`, `w_selectformat_1_2` |  | 9356 | [1](menu-walk/487_Reports_Purchase_Reports_Manufacturer_Wise_Detail__w_reviewreport.png) [2](menu-walk/487_Reports_Purchase_Reports_Manufacturer_Wise_Detail__w_selectformat_1_2.png) |
| 488 | Reports \| Purchase Reports \| Manufacturer Wise \| Monthly Stock Movement | opened_ok | `w_reviewreport` |  | 3171 | [1](menu-walk/488_Reports_Purchase_Reports_Manufacturer_Wise_Monthly_Stock_Movement__w_reviewreport.png) |
| 489 | Reports \| Purchase Reports \| Monthly Purchase Graph | opened_ok | `w_reviewreport`, `w_arg_sdate_ldate` |  | 9521 | [1](menu-walk/489_Reports_Purchase_Reports_Monthly_Purchase_Graph__w_reviewreport.png) [2](menu-walk/489_Reports_Purchase_Reports_Monthly_Purchase_Graph__w_arg_sdate_ldate.png) |
| 490 | Reports \| Purchase Reports \| Category Wise Purchase | opened_ok * | `w_reviewreport`, `w_selectformat_cat_purchase` |  | 9316 | [1](menu-walk/490_Reports_Purchase_Reports_Category_Wise_Purchase__w_reviewreport.png) [2](menu-walk/490_Reports_Purchase_Reports_Category_Wise_Purchase__w_selectformat_cat_purchase.png) |
| 494 | Reports \| Purchase Reports \| Days Summary | opened_ok | `w_reviewreport`, `w_arg_sdate_ldate` |  | 9237 | [1](menu-walk/494_Reports_Purchase_Reports_Days_Summary__w_reviewreport.png) [2](menu-walk/494_Reports_Purchase_Reports_Days_Summary__w_arg_sdate_ldate.png) |
| 503 | Reports \| Purchase Reports \| Purchase Order Supplier Wise | opened_ok | `w_reviewreport`, `w_arg_purorder_sdate_ldate_onesupp` |  | 10109 | [1](menu-walk/503_Reports_Purchase_Reports_Purchase_Order_Supplier_Wise__w_reviewreport.png) [2](menu-walk/503_Reports_Purchase_Reports_Purchase_Order_Supplier_Wise__w_arg_purorder_sdate_ldate_onesupp.png) |
| 504 | Reports \| Purchase Reports \| Net Purchase Summary | opened_ok * | `w_reviewreport`, `w_selectformat_netpursummary` |  | 9750 | [1](menu-walk/504_Reports_Purchase_Reports_Net_Purchase_Summary__w_reviewreport.png) [2](menu-walk/504_Reports_Purchase_Reports_Net_Purchase_Summary__w_selectformat_netpursummary.png) |
| 509 | Reports \| Purchase Reports \| Supplier Category Wise \| Input Sales Tax Report | opened_ok | `w_reviewreport` |  | 3198 | [1](menu-walk/509_Reports_Purchase_Reports_Supplier_Category_Wise_Input_Sales_Tax_Report__w_reviewreport.png) |
| 512 | Reports \| Purchase Reports \| Withholding Tax Deduction | opened_ok | `w_reviewreport` |  | 3230 | [1](menu-walk/512_Reports_Purchase_Reports_Withholding_Tax_Deduction__w_reviewreport.png) |
| 513 | Reports \| Purchase Reports \| Supplier/Manufacturer Wise G/P | opened_ok | `w_reviewreport` |  | 4010 | [1](menu-walk/513_Reports_Purchase_Reports_Supplier_Manufacturer_Wise_G_P__w_reviewreport.png) |
| 522 | Reports \| Accounts Reports \| Ledger Reports \| Accounts Ledger | opened_ok * | `w_reviewreport`, `w_arg_accounts_sdate_ldate` |  | 9826 | [1](menu-walk/522_Reports_Accounts_Reports_Ledger_Reports_Accounts_Ledger__w_reviewreport.png) [2](menu-walk/522_Reports_Accounts_Reports_Ledger_Reports_Accounts_Ledger__w_arg_accounts_sdate_ldate.png) |
| 598 | Reports \| Listing \| Supplier List | opened_with_modal | `w_reviewreport` | Null object reference (reading i_status) (in f_retrieve_report1.f_retrieve_report1.f_retrieve_report1) \|\| [cl… | 4708 | [1](menu-walk/598_Reports_Listing_Supplier_List__modal.png) [2](menu-walk/598_Reports_Listing_Supplier_List__w_reviewreport.png) |
| 600 | Reports \| Listing \| Items List | opened_ok | `w_filter_for_itemlist_rep` |  | 11262 | [1](menu-walk/600_Reports_Listing_Items_List__w_filter_for_itemlist_rep.png) |
| 603 | Reports \| Listing \| Manufacturer List | opened_ok | `w_reviewreport`, `w_selectformat_1_3` |  | 10020 | [1](menu-walk/603_Reports_Listing_Manufacturer_List__w_reviewreport.png) [2](menu-walk/603_Reports_Listing_Manufacturer_List__w_selectformat_1_3.png) |
| 612 | Reports \| Listing \| Group Rights List | opened_ok | `w_reviewreport`, `w_arg_groups` |  | 9600 | [1](menu-walk/612_Reports_Listing_Group_Rights_List__w_reviewreport.png) [2](menu-walk/612_Reports_Listing_Group_Rights_List__w_arg_groups.png) |
| 613 | Reports \| Listing \| Item List Class Wise | opened_ok | `w_reviewreport`, `w_selection_manf_cat_class_packing` |  | 11096 | [1](menu-walk/613_Reports_Listing_Item_List_Class_Wise__w_reviewreport.png) [2](menu-walk/613_Reports_Listing_Item_List_Class_Wise__w_selection_manf_cat_class_packing.png) |
| 614 | Reports \| Listing \| GroupWise User List | opened_ok | `w_reviewreport`, `w_arg_groups` |  | 9978 | [1](menu-walk/614_Reports_Listing_GroupWise_User_List__w_reviewreport.png) [2](menu-walk/614_Reports_Listing_GroupWise_User_List__w_arg_groups.png) |
| 619 | Reports \| Listing \| Sale Person Scope \| Manufacturer/Sub Area Wise Sales Person Conflict | opened_ok | `w_reviewreport` |  | 4398 | [1](menu-walk/619_Reports_Listing_Sale_Person_Scope_Manufacturer_Sub_Area_Wise_Sales_Person_Conflict__w_reviewreport.png) |
| 624 | Reports \| RePrinting \| Sale | opened_ok | `w_reviewreport` |  | 11738 | [1](menu-walk/624_Reports_RePrinting_Sale__w_reviewreport.png) |
| 625 | Reports \| RePrinting \| Purchase | opened_ok | `w_reviewreport`, `w_arg_sinvcode_linvcode` |  | 27983 | [1](menu-walk/625_Reports_RePrinting_Purchase__w_reviewreport.png) [2](menu-walk/625_Reports_RePrinting_Purchase__w_arg_sinvcode_linvcode.png) |
| 626 | Reports \| RePrinting \| Sale (with summary reports) | failed | `w_reviewreport` |  | 19469 | [1](menu-walk/626_Reports_RePrinting_Sale_%28with_summary_reports%29__w_reviewreport.png) |
| 627 | Reports \| RePrinting \| Sale Format(2) | opened_ok | `w_reviewreport`, `w_arg_invcode_printdate_printexpiry` |  | 6400 | [1](menu-walk/627_Reports_RePrinting_Sale_Format%282%29__w_reviewreport.png) [2](menu-walk/627_Reports_RePrinting_Sale_Format%282%29__w_arg_invcode_printdate_printexpiry.png) |
| 630 | Reports \| RePrinting \| Sale Format(3) | opened_ok | `w_reviewreport`, `w_arg_code_caption` |  | 6142 | [1](menu-walk/630_Reports_RePrinting_Sale_Format%283%29__w_reviewreport.png) [2](menu-walk/630_Reports_RePrinting_Sale_Format%283%29__w_arg_code_caption.png) |
| 634 | Reports \| RePrinting \| Sale Format(4) | opened_ok | `w_reviewreport`, `w_arg_sdate_ldate_cust` |  | 6392 | [1](menu-walk/634_Reports_RePrinting_Sale_Format%284%29__w_reviewreport.png) [2](menu-walk/634_Reports_RePrinting_Sale_Format%284%29__w_arg_sdate_ldate_cust.png) |
| 635 | Reports \| RePrinting \| Sale (with header wise summaries) | opened_ok | `w_reviewreport`, `w_arg_sinv_linv_salesum_headerwise` |  | 6131 | [1](menu-walk/635_Reports_RePrinting_Sale_%28with_header_wise_summaries%29__w_reviewreport.png) [2](menu-walk/635_Reports_RePrinting_Sale_%28with_header_wise_summaries%29__w_arg_sinv_linv_salesum_headerwise.png) |
| 647 | Reports \| RePrinting \| Selected Sales and Summaries | opened_ok | `w_reviewreport` |  | 806 | [1](menu-walk/647_Reports_RePrinting_Selected_Sales_and_Summaries__w_reviewreport.png) |
| 691 | Reports \| Item Reports \| History \| Sale Price Difference | opened_ok * | `w_reviewreport` |  | 5954 | [1](menu-walk/691_Reports_Item_Reports_History_Sale_Price_Difference__w_reviewreport.png) |
| 692 | Reports \| Item Reports \| History \| Item Basic Data Changes | opened_ok * | `w_reviewreport` |  | 5952 | [1](menu-walk/692_Reports_Item_Reports_History_Item_Basic_Data_Changes__w_reviewreport.png) |
| 693 | Reports \| Item Reports \| History \| Item Sale Price Changes | opened_ok * | `w_reviewreport` |  | 5933 | [1](menu-walk/693_Reports_Item_Reports_History_Item_Sale_Price_Changes__w_reviewreport.png) |
| 695 | Reports \| Item Reports \| History \| New Item(s) Created/Defined | opened_with_modal * | `w_reviewreport` | Failed to fetch \|\| [close] Failed to fetch | 6258 | [1](menu-walk/695_Reports_Item_Reports_History_New_Item%28s%29_Created_Defined__modal.png) [2](menu-walk/695_Reports_Item_Reports_History_New_Item%28s%29_Created_Defined__w_reviewreport.png) |
| 697 | Reports \| Item Reports \| History \| Item Name Changes | opened_ok | `w_reviewreport` |  | 985 | [1](menu-walk/697_Reports_Item_Reports_History_Item_Name_Changes__w_reviewreport.png) |
| 698 | Reports \| Item Reports \| Stock Adjustments \| Stock Adjustments Detail | opened_ok * | `w_reviewreport` |  | 5927 | [1](menu-walk/698_Reports_Item_Reports_Stock_Adjustments_Stock_Adjustments_Detail__w_reviewreport.png) |
| 700 | Reports \| Item Reports \| Deleted Sale Items Log | opened_ok * | `w_reviewreport` | [close] Failed to fetch | 5973 | [1](menu-walk/700_Reports_Item_Reports_Deleted_Sale_Items_Log__w_reviewreport.png) |
| 722 | Reports \| Purchase Return Reports \| Supplier Purchase Returns \| Detail | opened_ok * | `w_reviewreport` |  | 5894 | [1](menu-walk/722_Reports_Purchase_Return_Reports_Supplier_Purchase_Returns_Detail__w_reviewreport.png) |
| 723 | Reports \| Purchase Return Reports \| Supplier Purchase Returns \| Summary | failed | `w_reviewreport` |  | 907 | [1](menu-walk/723_Reports_Purchase_Return_Reports_Supplier_Purchase_Returns_Summary__w_reviewreport.png) |
| 874 | Basic Data \| Customer .......... \| Customer | no_window * | - |  | 17977 | [1](menu-walk/874_Basic_Data_Customer_.........._Customer__state.png) |
| 875 | Basic Data \| Customer .......... \| Customer Category | failed | - |  | 1624 | [1](menu-walk/875_Basic_Data_Customer_.........._Customer_Category__state.png) |
| 894 | Basic Data \| Customer .......... \| Sale Promotion | failed | - |  | 1627 | [1](menu-walk/894_Basic_Data_Customer_.........._Sale_Promotion__state.png) |
| 895 | Basic Data \| Customer .......... \| Customer Sector | failed | - |  | 1572 | [1](menu-walk/895_Basic_Data_Customer_.........._Customer_Sector__state.png) |
| 896 | Basic Data \| Supplier .......... \| Supplier | failed | - |  | 1712 | [1](menu-walk/896_Basic_Data_Supplier_.........._Supplier__state.png) |
| 897 | Basic Data \| Supplier .......... \| Supplier Category | failed | - |  | 1594 | [1](menu-walk/897_Basic_Data_Supplier_.........._Supplier_Category__state.png) |
| 900 | Basic Data \| Item .......... \| Item | failed | - |  | 1597 | [1](menu-walk/900_Basic_Data_Item_.........._Item__state.png) |
| 901 | Basic Data \| Item .......... \| Manufacturer | failed | - |  | 1612 | [1](menu-walk/901_Basic_Data_Item_.........._Manufacturer__state.png) |
| 902 | Basic Data \| Item .......... \| Item Class | failed | - |  | 1631 | [1](menu-walk/902_Basic_Data_Item_.........._Item_Class__state.png) |
| 903 | Basic Data \| Item .......... \| Item Category | failed | - |  | 1612 | [1](menu-walk/903_Basic_Data_Item_.........._Item_Category__state.png) |
| 915 | Basic Data \| Item .......... \| Generic Item | no_window * | - |  | 17877 | [1](menu-walk/915_Basic_Data_Item_.........._Generic_Item__state.png) |
| 918 | Basic Data \| Item .......... \| Item Basic Data | no_window * | - | Failed to fetch \|\| [close] Failed to fetch | 10867 | [1](menu-walk/918_Basic_Data_Item_.........._Item_Basic_Data__modal.png) |
| 922 | Basic Data \| Item .......... \| Price Policy | failed | - |  | 1647 | [1](menu-walk/922_Basic_Data_Item_.........._Price_Policy__state.png) |
| 924 | Basic Data \| Item .......... \| Item Alert | failed | - |  | 1627 | [1](menu-walk/924_Basic_Data_Item_.........._Item_Alert__state.png) |
| 929 | Basic Data \| Item .......... \| Sales Tax Schedule | no_window * | - |  | 17991 | [1](menu-walk/929_Basic_Data_Item_.........._Sales_Tax_Schedule__state.png) |
| 930 | Basic Data \| Item .......... \| PCT Codes | failed | - |  | 1588 | [1](menu-walk/930_Basic_Data_Item_.........._PCT_Codes__state.png) |
| 931 | Basic Data \| Item .......... \| Generic Item Type | failed | - |  | 1614 | [1](menu-walk/931_Basic_Data_Item_.........._Generic_Item_Type__state.png) |
| 932 | Basic Data \| Item .......... \| Item Thickness | no_window * | - |  | 17949 | [1](menu-walk/932_Basic_Data_Item_.........._Item_Thickness__state.png) |
| 933 | Basic Data \| Item .......... \| Lock Reason | failed | - | Failed to fetch \|\| [close] Failed to fetch | 924 | [1](menu-walk/933_Basic_Data_Item_.........._Lock_Reason__modal.png) |
| 934 | Basic Data \| Item .......... \| Category Segment | failed | - |  | 1608 | [1](menu-walk/934_Basic_Data_Item_.........._Category_Segment__state.png) |
| 935 | Basic Data \| Item .......... \| Manufacturer Type | failed | - |  | 1613 | [1](menu-walk/935_Basic_Data_Item_.........._Manufacturer_Type__state.png) |
| 944 | Basic Data \| Sale Template | failed | - |  | 1690 | [1](menu-walk/944_Basic_Data_Sale_Template__state.png) |
| 1070 | Basic Data \| Tax Category | failed | - |  | 1595 | [1](menu-walk/1070_Basic_Data_Tax_Category__state.png) |
| 1073 | Maintenance \| Change Password | no_window * | - |  | 17973 | [1](menu-walk/1073_Maintenance_Change_Password__state.png) |
| 1074 | Maintenance \| Preferences | failed | - | Failed to fetch \|\| [close] Failed to fetch | 913 | [1](menu-walk/1074_Maintenance_Preferences__modal.png) |
| 1081 | Maintenance \| Change Items Price | failed | - |  | 1661 | [1](menu-walk/1081_Maintenance_Change_Items_Price__state.png) |
| 1082 | Maintenance \| Database Utilities \| Backup Database | skipped | - |  |  | - |
| 1083 | Maintenance \| Database Utilities \| Check Database Integrity | skipped | - |  |  | - |
| 1084 | Maintenance \| Adjustment \| Increase | failed | - |  | 1599 | [1](menu-walk/1084_Maintenance_Adjustment_Increase__state.png) |
| 1085 | Maintenance \| Adjustment \| Decrease | failed | - |  | 1617 | [1](menu-walk/1085_Maintenance_Adjustment_Decrease__state.png) |
| 1086 | Maintenance \| Adjustment \| Stock Adjustment | failed | - |  | 1545 | [1](menu-walk/1086_Maintenance_Adjustment_Stock_Adjustment__state.png) |
| 1093 | Maintenance \| Priority Setting | failed | - |  | 1612 | [1](menu-walk/1093_Maintenance_Priority_Setting__state.png) |
| 1099 | Maintenance \| Change Item Discount | failed | - |  | 1593 | [1](menu-walk/1099_Maintenance_Change_Item_Discount__state.png) |
| 1100 | Maintenance \| Modify Sale Invoices | failed | - |  | 1533 | [1](menu-walk/1100_Maintenance_Modify_Sale_Invoices__state.png) |
| 1101 | Maintenance \| Modify Last Transaction Date | no_window * | - |  | 17973 | [1](menu-walk/1101_Maintenance_Modify_Last_Transaction_Date__state.png) |
| 1106 | Maintenance \| Godown Preferences \| Group Wise Godown Setting | failed | - |  | 1603 | [1](menu-walk/1106_Maintenance_Godown_Preferences_Group_Wise_Godown_Setting__state.png) |
| 1112 | Maintenance \| Interface Setting | no_window * | - |  | 17926 | [1](menu-walk/1112_Maintenance_Interface_Setting__state.png) |
| 1145 | Maintenance \| Update Item Basic Data | failed | - |  | 1628 | [1](menu-walk/1145_Maintenance_Update_Item_Basic_Data__state.png) |
| 1150 | Maintenance \| Update Item Suppliers | failed | - |  | 1652 | [1](menu-walk/1150_Maintenance_Update_Item_Suppliers__state.png) |
| 1153 | Maintenance \| Change Item Reorder Qty | no_window * | - |  | 18090 | [1](menu-walk/1153_Maintenance_Change_Item_Reorder_Qty__state.png) |
| 1162 | Maintenance \| Import Historical Data \| Import Previous Sales | skipped | - |  |  | - |
| 1165 | Maintenance \| Inplace Initialization | skipped | - |  |  | - |
| 1173 | Maintenance \| Lock Item Batches | skipped | - |  |  | - |
| 1178 | Manage \| Groups | failed | - |  | 1605 | [1](menu-walk/1178_Manage_Groups__state.png) |
| 1179 | Manage \| Users | failed | - |  | 1644 | [1](menu-walk/1179_Manage_Users__state.png) |
| 1182 | Manage \| Group Wise Header Setting | failed | - |  | 1567 | [1](menu-walk/1182_Manage_Group_Wise_Header_Setting__state.png) |
| 1199 | Manage \| Group Allowed Price Setting | failed | - |  | 1564 | [1](menu-walk/1199_Manage_Group_Allowed_Price_Setting__state.png) |
| 1201 | Manage \| Group Wise Cash Account Setting | failed | - |  | 1606 | [1](menu-walk/1201_Manage_Group_Wise_Cash_Account_Setting__state.png) |
| 1206 | Manage \| Session Monitor Ctrl+Alt+M | failed | - |  | 1587 | [1](menu-walk/1206_Manage_Session_Monitor_Ctrl+Alt+M__state.png) |
| 1212 | Manage \| Cashier Management \| Cashier Job | failed | - |  | 1651 | [1](menu-walk/1212_Manage_Cashier_Management_Cashier_Job__state.png) |
| 1213 | Manage \| Cashier Management \| Cashier Activity Window | no_window * | - |  | 17861 | [1](menu-walk/1213_Manage_Cashier_Management_Cashier_Activity_Window__state.png) |
| 1231 | Manage \| Job Schedule | failed | - |  | 1551 | [1](menu-walk/1231_Manage_Job_Schedule__state.png) |
| 1232 | Manage \| Group Wise Supplier Category | failed | - |  | 1553 | [1](menu-walk/1232_Manage_Group_Wise_Supplier_Category__state.png) |
| 1277 | Help \| About | failed | - |  | 1625 | [1](menu-walk/1277_Help_About__state.png) |

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
