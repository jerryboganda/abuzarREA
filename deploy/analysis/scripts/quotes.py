import os

pairs = [
 ('salewin/w_sale.pbs', 900), ('salewin/w_sale.pbs', 915),
 ('salewin/w_sale.pbs', 3709), ('salewin/w_sale.pbs', 3711), ('salewin/w_sale.pbs', 3717), ('salewin/w_sale.pbs', 3723),
 ('salewin/w_sale.pbs', 3809), ('salewin/w_sale.pbs', 3813), ('salewin/w_sale.pbs', 3824), ('salewin/w_sale.pbs', 3836),
 ('salewin/w_sale.pbs', 11748), ('salewin/w_sale.pbs', 15561), ('salewin/w_sale.pbs', 15565),
 ('purchasecomponents/w_purchase.pbs', 88), ('purchasecomponents/w_purchase.pbs', 4188), ('purchasecomponents/w_purchase.pbs', 4300),
 ('purchasecomponents/w_purchase.pbs', 4315), ('purchasecomponents/w_purchase.pbs', 4319), ('purchasecomponents/w_purchase.pbs', 4326),
 ('purchasecomponents/w_purchase.pbs', 4332), ('purchasecomponents/w_purchase.pbs', 464), ('purchasecomponents/w_purchase.pbs', 481),
 ('purchasecomponents/w_purchase.pbs', 501), ('purchasecomponents/w_purchase.pbs', 502), ('purchasecomponents/w_purchase.pbs', 4708),
 ('salereturncomponents/w_salereturnbuffer.pbs', 2026), ('salereturncomponents/w_salereturnbuffer.pbs', 2034),
 ('salereturncomponents/w_salereturnbuffer.pbs', 2054), ('salereturncomponents/w_salereturnbuffer.pbs', 2057),
 ('salereturncomponents/w_salereturnbuffer.pbs', 2072), ('salereturncomponents/w_salereturnbuffer.pbs', 2077),
 ('salereturncomponents/w_salereturnbuffer.pbs', 2108), ('salereturncomponents/w_salereturnbuffer.pbs', 2116),
 ('transfer/w_transfer.pbs', 2632), ('transfer/w_transfer.pbs', 2674), ('transfer/w_transfer.pbs', 2682),
 ('transfer/w_transfer.pbs', 2683), ('transfer/w_transfer.pbs', 2716), ('transfer/w_transfer.pbs', 2724),
 ('transfer/w_transfer.pbs', 2743), ('transfer/w_transfer.pbs', 2746), ('transfer/w_transfer.pbs', 2762),
 ('poscomponents/w_postsale.pbs', 1789), ('poscomponents/w_postsale.pbs', 1791), ('poscomponents/w_postsale.pbs', 1833),
 ('poscomponents/w_postsale.pbs', 1900), ('poscomponents/w_postsale.pbs', 1904),
 ('pocomponents/w_purchaseorder.pbs', 3668), ('pocomponents/w_purchaseorder.pbs', 3677),
 ('pocomponents/w_purchaseorder.pbs', 3686), ('pocomponents/w_purchaseorder.pbs', 3695),
 ('components/w_multi_entry.pbs', 378), ('components/w_multi_entry.pbs', 382), ('components/w_multi_entry.pbs', 398),
 ('components/w_multi_entry.pbs', 665),
 ('functions/f_stringpreferences.pbs', 8), ('functions/f_getgroupcode.pbs', 5), ('functions/f_getgroupcode.pbs', 10),
 ('functions/f_refreshitemlist.pbs', 10), ('functions/f_refreshitemlist.pbs', 14), ('functions/f_refreshitemlist.pbs', 29),
 ('preferences/w_preferences.pbs', 512), ('preferences/w_preferences.pbs', 626), ('preferences/w_preferences.pbs', 630),
 ('preferences/w_preferences.pbs', 1048), ('preferences/w_preferences.pbs', 1401),
 ('abuzarapp/w_main.pbs', 79), ('abuzarapp/w_main.pbs', 104), ('abuzarapp/w_main.pbs', 191), ('abuzarapp/w_main.pbs', 197),
 ('abuzarapp/w_startup.pbs', 52), ('abuzarapp/w_startup.pbs', 53), ('abuzarapp/w_startup.pbs', 71),
 ('abuzarapp/w_login1.pbs', 201), ('abuzarapp/w_login1.pbs', 106),
 ('abuzarapp/w_dbbackup1.pbs', 83), ('abuzarapp/w_dbbackup1.pbs', 99),
 ('abuzarapp/w_autorecovery.pbs', 107), ('abuzarapp/w_autorecovery.pbs', 147),
 ('templates/u_stockledger.pbs', 141), ('templates/u_stockledger.pbs', 159),
 ('functions/f_generateitemlog.pbs', 27),
 ('issuecomponents/w_view_issueheader.pbs', 226), ('saleorder/w_view_saleorderheader.pbs', 236),
 ('components/u_ds_standard.pbs', 39), ('components/u_ds_standard.pbs', 54),
 ('accounts/w_voucher.pbs', 1857), ('salereturncomponents/w_salereturnbuffer.pbs', 1960),
]

for f, ln in pairs:
    p = os.path.join('recovered/scripts', f)
    lines = open(p, encoding='utf-8', errors='replace').read().splitlines()
    print('%s:%d\t%s' % (f, ln, lines[ln-1].strip()[:220]))
