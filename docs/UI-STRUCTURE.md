# UI / UX structure (from the 2,062 recovered windows and 8,748 DataWindows)

## Windows
- Types: **1,643 response (modal) windows**, 407 main/sheet windows, 10 popup, 1 child, 1 MDI frame (`w_main`, menu `m_entry`, MDI client `mdi_1`, status/micro-help). Transaction and list windows are MDI **sheets** opened with `opensheet(w, parentwindow, 0, layered!)` from the menu; dialogs, argument windows (838 `w_arg_*`) and pickers are response windows opened with `open` / `openwithparm` and return values through `message.doubleparm / stringparm / powerobjectparm`.
- Typical size: median 2,423 x 1,626 PowerBuilder units (PBU), largest 4,056 x 1,834; windows centre themselves on the screen (`pixelstounits(env.screenwidth)` pattern, `ue_mdi_move`). **PBU -> pixel conversion must be calibrated against the original** (it depends on the Windows font metrics); coordinates (`x`, `y`, `width`, `height`, `taborder`, fonts, colours) of every control are in `recovered/objects/**.json`.
- Controls (10,597 in windows): static text 2,234, radio buttons 1,669, command buttons 1,603, group boxes 1,088, standard DataWindow control `u_dwstandard` 842 (+767 plain datawindows), check boxes 774, edit masks 605, list boxes 243, drop-down list boxes 132, single-line edits 97, progress bars 80, OLE controls 55 (TWAIN scanner, chart/crystal viewers), user objects 196.
- Look: font **Arial -10** (5,582 controls), Arial -9 (2,283), Arial -8, -12; window background colours `80263581` (1,119 windows) and `67108864` (system button-face, 923): colour values are PowerBuilder long colours (BGR, high bits flag system colours).
- Keyboard model: tab order (`taborder`), Enter-key navigation (`ue_enterkey` / `ue_dwnkey` user events on every DataWindow control, wired to Enter / Down keys), accelerator keys in menu captions (`&`), `Ctrl+X` exit, default/cancel buttons, function keys per window (`key` event).
- Common sheet skeleton (`w_multi_entry`, `w_single_entry`): list/detail tabs, toolbar (menu `m_multi_entry` / `m_single_entry`: New, Save, Delete, Print, First/Prev/Next/Last, Retrieve, Close), master DataWindow + detail grid + footer totals DataWindow, find/filter bars.

## DataWindows (8,748)
- Processing styles: 6,673 tabular/freeform (0), 1,795 grid (1), 147 crosstab (4), 70 graph (3), 59 composite (5), 2 label (2), 1 OLE (6), 1 rich text (7).
- Objects: 144,504 text, 105,218 column, 97,059 computed fields, 49,328 lines, 1,399 bitmaps, 280 nested reports, 270 group boxes, shapes. Layout, fonts, colours, bands (header / detail / summary / footer / group headers), column formats, edit styles (drop-down data windows, check boxes, radio buttons, edit masks), validation rules, computed expressions and retrieval arguments are in `recovered/datawindows/**.srd` (source) and `recovered/datawindows_json/**`. SQL: either `PBSELECT(...)` (painted select) or free SQL; update properties (key columns, updatable table) are present.

## What cannot be derived without the original running
Pixel-exact appearance (font rendering, 3-D borders, PBU calibration, system colours under the user's theme, the real toolbar bitmaps) - see `docs/STATUS.md`, item 1.
