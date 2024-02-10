/*
testing if WO is duplicating.
*/
select distinct
scc.fisc_week_val,
wc.wo_wid ,
sum(wc.mdr_count),
sum(mmpd_count),
sum(mmpd_flg),
sum(mb_prt_count_num)
from temp_test_ani_wc as wc
	inner join svc_corp_cldr as scc
		on scc.cldr_date = wc.wo_crt_utc_dts::date
where 1=1
and scc.fisc_week_rltv between -5 and 0
group by 1,2
having sum(mdr_count) > 1