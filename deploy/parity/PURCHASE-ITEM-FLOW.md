# Purchase item flow - verified runtime evidence

**Date:** 2026-11-03  
**Screen:** Purchase | Purchases (`w_purchase`, title `Pack Purchase`)  
**Data:** migrated live PostgreSQL `trader`

## Verified user flow

1. Open **Purchase | Purchases**.
2. The header and detail grids open with the live `d_normalpurchaseheader` / `d_normalpurchasedetail` objects; godown is `GODOWN1`.
3. Click the first detail item-name cell; the 27,818-row item list opens.
4. Find/select **FACE MASK** (`icode=9801`).
5. Press Enter to commit the item.
6. Set **Qty (packqty)** to `5` and press Enter.

## Measured values

| Field | Value |
|---|---|
| `icode` | `9801` |
| `itemname` | `FACE MASK ` |
| `packqty` | `5` |
| `purprice` | `2` |
| `stock` | `18,041` |
| Footer `stock` | `18,041` |
| Footer `total` | **`10`** |

No modal and no page error. No save/post/print was performed.

## Evidence

- `deploy/parity/purchase-accept.log` - measured values.
- `deploy/parity/real/36-purchase-item.png` - item selected (qty 1, total 2).
- `deploy/parity/real/37-purchase-qty5.png` - qty 5, footer total 10.

## Remaining Purchase work

- Supplier selection and saving/posting validation.
- Batch/expiry picker for batch-tracked items.
- Exact pixel comparison of the full Purchase screen against the live app.
