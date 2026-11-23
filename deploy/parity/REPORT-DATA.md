# Report data with real arguments - verified

**Date:** 2026-11-03  
**Report:** Reports | Sales Reports | User Wise | Net Cash (`d_userwise_netcash`)  
**Data:** migrated live PostgreSQL `trader`

## Flow

1. Open **Reports | Sales Reports | User Wise | Net Cash**.
2. The argument window `w_arg_user_sdate_ldate` opens with today's dates and a user field.
3. Set user code **4** (ZUBAIR ARIF) and the date range **01/01/2024 00:00:00** to **31/12/2024 23:59:59**.
4. Click **Ok** in the real argument window.
5. Click **Ok** in the report format selector (`w_selectformat_1_2`).

## Result

The report viewer (`w_reviewreport`) retrieves and renders **3 real rows**:

| Type | Group | Row | Description | Amount | User |
|---:|---|---:|---|---:|---|
| 1 | Sales Summary | 1 | Total Sales | 58,569,818.00 | ZUBAIR ARIF |
| 1 | Sales Summary | 4 | Cash Returns | (4,945,353.00) | ZUBAIR ARIF |
| 2 | Credit Customer Sales | 1 | ****CASH SALES CUSTOMER | 58,569,818.00 | ZUBAIR ARIF |

Header: `From Date 01/01/24 00:00:00`, `To Date 31/12/24 23:59:59`, `User: ZUBAIR ARIF`.  
Footer: `Net Cash: 53624465.00`.

## Defects fixed to make this work

- Clicking a real button did not drain the posted-event queue while a modal was open, so an argument dialog's `post event ue_close(1)` never ran. UI click handlers now flush posted events.
- `EditMask.GetData` handed date values to report struct members as raw text. It now converts date/time-looking values to `PBDateTime`, so the report receives typed dates.
- The report path now advances through the argument dialog and the format selector without cancelling either one.

## Evidence

- `deploy/parity/report-normal2.log` - full measured run.
- `deploy/parity/real/30-report-netcash-normal.png` - report page with 3 rows.
- `deploy/parity/real/29-report-netcash-rows.png` - report page with 3 rows (direct argument test).

This proves report retrieval and rendering with real migrated data, not just layout.

## Column truncation fixed — 2026-11-03

The report is designed in Arial Narrow, which is not installed on this build
machine. Chromium substituted Arial, so the 176 px description column and the
71 px amount column overflowed:

- `scrollWidth` 188 px vs `clientWidth` 176 px for `****CASH SALES CUSTOMER`
- `scrollWidth` 82 px vs `clientWidth` 71 px for `58569818.00`

A metric-compatible **Liberation Sans Narrow** face is now bundled at
`web/public/fonts/` and registered as both `Arial Narrow` and
`Liberation Sans Narrow` in `src/ui/styles.ts`.

Measured after the fix:

| Cell | Client width | Scroll width | Result |
|---|---:|---:|---|
| `****CASH SALES CUSTOMER` | 176 | 176 | **no overflow** |
| `58569818.00` | 71 | 71 | **no overflow** |
| `53624465.00` (Net Cash) | 118 | 118 | **no overflow** |

The current screenshot is `real/31-report-netcash-current.png`; both the full
customer name and both decimal places are visible.

