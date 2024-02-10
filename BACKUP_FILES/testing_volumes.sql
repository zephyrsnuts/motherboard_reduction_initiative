--find out how to filter the volumes
select distinct
tra.fiscal_quarter , 
tra.fiscal_week ,
sum ( tra.case_count ) as case_counts  ,
sum ( tra.mdr_count ) as mdr_counts  ,
sum ( tra.wo_count ) as wo_counts  ,
sum ( tra.repeat_num ) as rd_counts  ,
sum ( tra.qualify_denom ) as rd_denom_counts  ,
sum ( tra.mmpd_flg ) as mmpd_counts  ,
sum ( tra.mb_flg ) as mb_counts 
from tbl_ani_6208_wc_trans as tra
where 1=1
and week_lag > -10
group by 1,2
order by 2