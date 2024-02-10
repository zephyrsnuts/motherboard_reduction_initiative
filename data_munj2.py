import pandas as pd
# import numpy as np
import datapane as dp
import os
import sys
from sqlalchemy import create_engine, text

sys.path.append(os.path.abspath("C:\\Users\\Anirudh_Naik\\OneDrive - Dell Technologies"))
from pwdfile import getpass

pwd = getpass("ddlpw.txt")

os.chdir(os.path.dirname(os.path.abspath(__file__)))
fpath = os.getcwd()


def connexion(url):
    global engine
    engine = create_engine(url)


print("start queries")
url1 = 'postgresql+psycopg2://anirudh_naik:' + pwd + '@ddlgpmprd11.us.dell.com:6420/gp_ns_ddl_prod'
connexion(url1)
print("connected...")
# engine.execute()
case_query = text("""
                        select distinct
                            cas.case_wid ,
                            cas.case_stat as case_status ,
                            cas.rptg_case_chnl as case_channel ,
                            cas.origin_nm as origin_name ,
                            cas.case_crt_dts ,
                            cas.case_nbr ,
                            --calendar
                            scc.fiscal_week as case_fiscal_week ,	
                            scc.week_lag as case_week_lag ,
                            scc.fiscal_quarter as case_fiscal_quarter ,
                            scc.quarter_lag as case_quarter_lag ,
                            scc.fiscal_year as case_fiscal_year ,
                            scc.year_lag as case_year_lag ,
                            case when cas.kcs_attached_count >= 1 then 'Y' else null end as kcs_attached_flg ,
                            case when cas.kcs_solved_count >= 1 then 'Y' else null end as kcs_solved_flg ,
                            case when cas.guided_flow_count >= 1 then 'Y' else null end as guided_flow_flg ,
                            sum ( cas.case_created_count ) as case_created_count , --COWR = wo count / case created count owner
                            sum ( cas.case_complete_count_owner ) as case_complete_count_owner ,
                            sum ( cas.kcs_attached_count ) as kcs_attached_count ,
                            sum ( cas.kcs_solved_count ) as kcs_solved_count ,
                            sum ( cas.guided_flow_count ) as guided_flow_count ,
                            sum ( cas.dial_home_flg ) as dial_home_flg 
                        from tmp_tbl_ani_6208_wc_case as cas
                            inner join tbl_ani_6208_wc_cal as scc
                                on scc.calendar_date = cas.case_crt_dts::date
                            inner join tbl_ani_6208_wc_prod as uph
                                on uph.prod_key = cas.asst_prod_hier_key
                            left join tbl_ani_6208_wc_pers as ad
                                on ad.src_prsn_hist_gen_id = cas.owner_bdge_hist_id_at_crt
                            left join tbl_ani_6208_wc_comb as wo
                                on wo.case_wid = cas.case_wid
                                and wo.wo_crt_utc_dts > current_timestamp - interval '3 weeks'
                        where 1=1
                            and upper(uph.prod_grp_desc) in ('POWEREDGE SERVERS')
                            and (
                                scc.week_lag between -3 and 0
                                or 
                                wo.case_wid = cas.case_wid
                            )
                        group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
                """)
wo_query = text("""
                    SELECT DISTINCT
                            --keys
                            tra.wo_wid ,
                            tra.case_wid ,
                            ad.assoc_bdge_nbr as outlier_key ,
                            tra.wo_crt_utc_dts::date as wo_crt_utc_dts ,
                            tra.asst_unified_iso_ctry_cd ,
                            tra.asst_prod_hier_key ,
                            tra.wo_apprvd_bdge_hist_id ,
                            tra.wo_crt_by_bdge_hist_id ,
                            tra.sfdc_wo_id ,
                            --others
                            tra.appv_criteria_met_desc::varchar(150) as approval_criteria_met ,
                            tra.appv_rsn_desc as approval_reason ,
                            tra.appv_stat_val as approval_status ,
                            tra.wo_nbr ,
                            tra.dps_type ,
                            tra.call_type ,
                            tra.wo_type ,
                            tra.svc_type ,	
                            tra.svc_opt ,
                            tra.svc_opt_hrs ,
                            tra.curr_stat as wo_status ,
                            tra.crt_prcs as create_process ,
                            --dimensions
                            --prod
                            uph.global_grouping ,
                            uph.global_product,
                            uph.global_lob,
                            uph.global_brand,
                            uph.global_generation,
                            uph.prod_grp_desc as product_group , 
                            uph.product_family as product_family , 
                            --per
                            ad.assoc_full_nm as crt_assoc_full_nm ,
                            ad.manager_first as crt_manager_first ,
                            ad.manager_second as crt_manager_second ,
                            ad.bus_rptg_dept_nm as crt_bus_rptg_dept_nm ,
                            ad.robotic_user as crt_robotic_user ,
                            ad.bus_rptg_rgn_nm as crt_bus_rptg_rgn_nm ,
                            ad.bus_rptg_subrgn_nm as crt_bus_rptg_subrgn_nm ,
                            ad.manager_l5 as crt_manager_l5 ,
                            --approver
                            ad2.assoc_full_nm as appr_assoc_full_nm ,
                            ad2.manager_first as appr_manager_first ,
                            ad2.manager_second as appr_manager_second ,
                            ad2.bus_rptg_dept_nm as appr_bus_rptg_dept_nm ,
                            ad2.robotic_user as appr_robotic_user ,
                            ad2.bus_rptg_rgn_nm as appr_bus_rptg_rgn_nm ,
                            ad2.bus_rptg_subrgn_nm as appr_bus_rptg_subrgn_nm ,
                            ad2.manager_l5 as appr_manager_l5 ,
                            --cust
                            cus.region_name as customer_region ,
                            cus.subregion_name as customer_subregion_name ,
                            cus.area_name as area_name ,
                            cus.ctry_nm as ctry_nm ,
                            --calendar
                            scc.fiscal_week ,	
                            scc.week_lag ,
                            scc.fiscal_quarter ,
                            scc.quarter_lag ,
                            scc.fiscal_year ,
                            scc.year_lag ,
                            sum ( tra.wo_count ) as wo_count ,
                            sum ( tra.rpa_wo_count ) as rpa_wo_count ,
                            sum ( tra.bulk_flg ) as bulk_flg ,
                            sum ( tra.repeat_num ) as rd_num ,
                            sum ( tra.qualify_denom ) as rd_den ,
                            sum ( tra.rd_case_rd_qualify_denom ) as rd_case_rd_qualify_denom ,
                            sum ( tra.mdr_count ) as mdr_count ,
                            sum ( tra.mmpd_count ) as mmpd_count ,
                            sum ( tra.mmpd_flg ) as mmpd_flg ,
                            sum ( tra.mb_prt_count_num ) as mb_prt_count_num ,
                            sum ( tra.mb_prt_flg_den ) as mb_prt_flg_den ,
                            sum ( tra.mpd_num_qty ) as mpd_num ,
                            sum ( tra.mpd_denom_flg ) as mpd_denom ,
                            sum ( tra.ppd_num_p_qty ) as ppd_num_p_qty ,
                            sum ( tra.ppd_denom_flg ) as ppd_denom_flg 
                    FROM tbl_ani_6208_wc_comb AS tra
                        inner join tbl_ani_6208_wc_cal as scc
                            on scc.calendar_date = tra.wo_crt_utc_dts::date
                        inner join tbl_ani_6208_wc_prod as uph
                            on uph.prod_key = tra.asst_prod_hier_key
                        left join tbl_ani_6208_wc_pers as ad
                            on ad.src_prsn_hist_gen_id = tra.wo_crt_by_bdge_hist_id
                        left join tbl_ani_6208_wc_pers as ad2
                            on ad2.src_prsn_hist_gen_id = tra.wo_apprvd_bdge_hist_id
                        left join tbl_ani_6208_wc_cust as cus
                            on cus.iso_alpha2_cd = tra.asst_unified_iso_ctry_cd
                    where 1=1
                        and upper(uph.prod_grp_desc) in ('POWEREDGE SERVERS')
                        and scc.week_lag between -3 and 0
                    group by 1,2,3,4,5,6,7,8,9,10
                        ,11,12,13,14,15,16,17,18,19
                        ,20,21,22,23,24,25,26,27,28,29
                        ,30,31,32,33,34,35,36,37,38,39
                        ,40,41,42,43,44,45,46,47,48,49
                        ,50,51,52,53,54
                """)
ol_query = text(""" 
                    select distinct
                        tra.wo_wid ,
                        ol.mb_outlier ,
                        ol.mmpd_outlier ,
                        sum (case when lower ( tra.approval_criteria_met ) like '%motherboard reduction initiative%'
                                and cc.kcs_attached_count > 0
                                and tra.mb_prt_flg_den > 0
                                and tra.mdr_count > 0
                                and lower ( ol.mb_outlier ) = 'y'
                            then 1 else 0
                        end ) as mdr_count_kcs_attached_mb_outlier ,
                        sum (case when lower ( tra.approval_criteria_met ) like '%motherboard reduction initiative%'
                                and cc.kcs_attached_count > 0
                                and tra.mmpd_flg >= 1
                                and tra.mdr_count > 0
                                and lower ( ol.mmpd_outlier ) = 'y'
                            then 1 else 0
                        end ) as mdr_count_kcs_attached_mmpd_outlier ,
                        sum (case when lower ( tra.approval_criteria_met ) like '%motherboard reduction initiative%'
                                and cc.kcs_solved_count > 0
                                and tra.mb_prt_flg_den > 0
                                and tra.mdr_count > 0
                                and lower ( ol.mb_outlier ) = 'y'
                            then 1 else 0
                        end ) as mdr_count_kcs_solved_mb_outlier ,
                        sum (case when lower ( tra.approval_criteria_met ) like '%motherboard reduction initiative%'
                                and cc.kcs_solved_count > 0
                                and tra.mmpd_flg >= 0
                                and tra.mdr_count > 0
                                and lower ( ol.mmpd_outlier ) = 'y'
                            then 1 else 0
                        end ) as mdr_count_kcs_solved_mmpd_outlier ,
                        sum (case when lower ( tra.approval_criteria_met ) like '%motherboard reduction initiative%'
                                and cc.guided_flow_count > 0
                                and tra.mb_prt_flg_den > 0
                                and tra.mdr_count > 0
                                and lower ( ol.mb_outlier ) = 'y'
                            then 1 else 0
                        end ) as mdr_count_guided_flow_mb_outlier ,
                        sum (case when lower ( tra.approval_criteria_met ) like '%motherboard reduction initiative%'
                                and cc.guided_flow_count > 0
                                and tra.mmpd_flg >= 0
                                and tra.mdr_count > 0
                                and lower ( ol.mmpd_outlier ) = 'y'
                            then 1 else 0
                        end ) as mdr_count_guided_flow_mmpd_outlier 
                        -- sum (case when lower ( tra.approval_criteria_met ) like '%motherboard reduction initiative%' then 1 else 0 end) as mb_initiative_reviewed_counts
                    from tbl_ani_9244_outliers as ol
                        inner join tbl_ani_6208_wc_comb as tra
                            on ol.assoc_bdge_nbr = tra.outlier_key
                        left join tmp_tbl_ani_6208_wc_case as cc
                            on cc.case_wid = tra.case_wid
                    group by 1,2,3
                """)
cal_query = text("select * from tbl_ani_6208_wc_cal as cal where cal.week_lag >= -4")
df = pd.read_sql(case_query, engine, index_col='case_wid')
print("pulled case table")
df_wo = pd.read_sql(wo_query, engine, index_col='case_wid')
print("pulled wo table")
df_ol = pd.read_sql(ol_query, engine)
print("pulled outlier table")
df_cal = pd.read_sql(cal_query, engine)
print("pulled calendar table")

print("merging...")
def f(my_df):
    # returns a dataframe
    return my_df.sum(axis=1)

df_case = df[["kcs_attached_flg","kcs_solved_flg","guided_flow_flg","case_fiscal_week","case_week_lag","case_crt_dts","case_nbr"]]

filepath = '\\'.join([fpath, 'test_merge.csv'])
print("merge complete")
merge2.to_csv(filepath, index=False)
print("exported to csv")

print("generating report")
report = dp.Report(dp.DataTable(merge2))
report.save(path="sample_report.html")
print("all stop.")
