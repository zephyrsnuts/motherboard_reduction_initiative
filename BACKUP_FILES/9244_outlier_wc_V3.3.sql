drop table if exists test_9244_ani_wo;
create table test_9244_ani_wo as (
with outlier_cte as 
		(
				select distinct
					tra.wo_wid ,
					sum (case when lower ( tra.approval_criteria_met ) like '%motherboard reduction initiative%'
							and lower ( tra.kcs_attached ) in ('y')
							and tra.mb_flg > 0
							and tra.mdr_count > 0
							and lower ( ol.mb_outlier ) = 'y'
						then 1 else 0
					end ) as mdr_count_kcs_attached_mb_outlier ,
					sum (case when lower ( tra.approval_criteria_met ) like '%motherboard reduction initiative%'
							and lower ( tra.kcs_attached ) in ('y') 
							and tra.mmpd_flg >= 1
							and tra.mdr_count > 0
							and lower ( ol.mmpd_outlier ) = 'y'
						then 1 else 0
					end ) as mdr_count_kcs_attached_mmpd_outlier ,
					sum (case when lower ( tra.approval_criteria_met ) like '%motherboard reduction initiative%'
							and lower ( tra.kcs_solved ) in ('y')
							and tra.mb_flg > 0
							and tra.mdr_count > 0
							and lower ( ol.mb_outlier ) = 'y'
						then 1 else 0
					end ) as mdr_count_kcs_solved_mb_outlier ,
					sum (case when lower ( tra.approval_criteria_met ) like '%motherboard reduction initiative%'
							and lower ( tra.kcs_solved ) in ('y')
							and tra.mmpd_flg >= 0
							and tra.mdr_count > 0
							and lower ( ol.mmpd_outlier ) = 'y'
						then 1 else 0
					end ) as mdr_count_kcs_solved_mmpd_outlier ,
					sum (case when lower ( tra.approval_criteria_met ) like '%motherboard reduction initiative%'
							and lower ( tra.guided_flow ) in ('y')
							and tra.mb_flg > 0
							and tra.mdr_count > 0
							and lower ( ol.mb_outlier ) = 'y'
						then 1 else 0
					end ) as mdr_count_guided_flow_mb_outlier ,
					sum (case when lower ( tra.approval_criteria_met ) like '%motherboard reduction initiative%'
							and lower ( tra.guided_flow ) in ('y')
							and tra.mmpd_flg >= 0
							and tra.mdr_count > 0
							and lower ( ol.mmpd_outlier ) = 'y'
						then 1 else 0
					end ) as mdr_count_guided_flow_mmpd_outlier 
				from tbl_ani_9244_outliers as ol
					inner join tbl_ani_6208_wc_trans as tra
						on ol.assoc_bdge_nbr = tra.outlier_key
				group by 1
		)
	SELECT DISTINCT
			--keys
			tra.case_wid ,
			tra.asst_unified_iso_ctry_cd ,
			tra.asst_prod_hier_key ,
			ad.assoc_bdge_nbr as outlier_key ,
			tra.wo_wid as wo_wid ,
			tra.wo_crt_utc_dts as wo_crt_utc_dts ,
			tra.wo_apprvd_bdge_hist_id as wo_apprvd_bdge_hist_id ,
			tra.wo_crt_by_bdge_hist_id as wo_crt_by_bdge_hist_id ,
			tra.sfdc_wo_id as sfdc_wo_id ,
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
			cus.subregion_name as customer_subregion ,
			cus.area_name as cust_area ,
			cus.ctry_nm as cust_country ,
			--calendar
			scc.fiscal_week ,	
			scc.week_lag ,
			scc.fiscal_quarter ,
			scc.quarter_lag ,
			scc.fiscal_year ,
			scc.year_lag ,
			-- --case
			-- null as case_status ,
			-- null as case_channel ,
			-- null as origin_name ,
			-- null::timestamp as case_crt_dts ,
			-- null as case_nbr ,
			-- null as kcs_attached_flg ,
			-- null as kcs_solved_flg ,
			-- null as guided_flow_flg ,
			--wo
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
			-- --sums - case
			-- sum ( null::int ) as case_created_count , --COWR = wo count / case created count owner
			-- sum ( null::int ) as case_complete_count_owner ,
			-- sum ( null::int ) as kcs_attached_count ,
			-- sum ( null::int ) as kcs_solved_count ,
			-- sum ( null::int ) as guided_flow_count ,
			-- sum ( null::int ) as dial_home_flg ,
			--sums - WO
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
			sum ( tra.ppd_denom_flg ) as ppd_denom_flg ,
			--sums - Outlier
			sum ( ol.mdr_count_kcs_attached_mb_outlier ) as mdr_count_kcs_attached_mb_outlier  ,
			sum ( ol.mdr_count_kcs_attached_mmpd_outlier ) as mdr_count_kcs_attached_mmpd_outlier  ,
			sum ( ol.mdr_count_kcs_solved_mb_outlier ) as mdr_count_kcs_solved_mb_outlier  ,
			sum ( ol.mdr_count_kcs_solved_mmpd_outlier ) as mdr_count_kcs_solved_mmpd_outlier  ,
			sum ( ol.mdr_count_guided_flow_mb_outlier ) as mdr_count_guided_flow_mb_outlier  ,
			sum ( ol.mdr_count_guided_flow_mmpd_outlier ) as mdr_count_guided_flow_mmpd_outlier 
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
		left join outlier_cte as ol
			on tra.wo_wid = ol.wo_wid 
	where 1=1
		and upper(uph.prod_grp_desc) in ('POWEREDGE SERVERS')
		and scc.week_lag between -3 and 0
	group by 1,2,3,4,5,6,7,8,9,10
		,11,12,13,14,15,16,17,18,19
		,20,21,22,23,24,25,26,27,28,29
		,30,31,32,33,34,35,36,37,38,39
		,40,41,42,43,44,45,46,47,48,49
		,50,51,52,53,54--,55,56,57,58,59
		-- ,60,61,62
)
distributed randomly
;
drop table if exists test_9244_ani_case;
create table test_9244_ani_case as ( 
	select distinct
		--keys
		cas.case_wid ,
		cas.asst_unified_iso_ctry_cd ,
		cas.asst_prod_hier_key ,
		ad.assoc_bdge_nbr as outlier_key ,
		-- null as wo_wid ,
		-- null::timestamp as wo_crt_utc_dts ,
		-- null::int as wo_apprvd_bdge_hist_id ,
		-- null::int as wo_crt_by_bdge_hist_id ,
		-- null as sfdc_wo_id ,
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
		-- --approver
		-- null as appr_assoc_full_nm ,
		-- null as appr_manager_first ,
		-- null as appr_manager_second ,
		-- null as appr_bus_rptg_dept_nm ,
		-- null::int as appr_robotic_user ,
		-- null as appr_bus_rptg_rgn_nm ,
		-- null as appr_bus_rptg_subrgn_nm ,
		-- null as appr_manager_l5 ,
		--cust
		cus.region_name as customer_region ,
		cus.subregion_name as customer_subregion ,
		cus.area_name as cust_area ,
		cus.ctry_nm as cust_country ,
		--calendar
		scc.fiscal_week ,	
		scc.week_lag ,
		scc.fiscal_quarter ,
		scc.quarter_lag ,
		scc.fiscal_year ,
		scc.year_lag ,
		--case
		cas.case_stat as case_status ,
		cas.rptg_case_chnl as case_channel ,
		cas.origin_nm as origin_name ,
		cas.case_crt_dts ,
		cas.case_nbr ,
		case when cas.kcs_attached_count >= 1 then 'Y' else null end as kcs_attached_flg ,
		case when cas.kcs_solved_count >= 1 then 'Y' else null end as kcs_solved_flg ,
		case when cas.guided_flow_count >= 1 then 'Y' else null end as guided_flow_flg ,
		-- --wo
		-- null as approval_criteria_met ,
		-- null as approval_reason ,
		-- null as approval_status ,
		-- null as wo_nbr ,
		-- null as dps_type ,
		-- null as call_type ,
		-- null as wo_type ,
		-- null as svc_type ,	
		-- null as svc_opt ,
		-- null as svc_opt_hrs ,
		-- null as wo_status ,
		-- null as create_process ,
		--sums - case
		sum ( cas.case_created_count ) as case_created_count , --COWR = wo count / case created count owner
		sum ( cas.case_complete_count_owner ) as case_complete_count_owner ,
		sum ( cas.kcs_attached_count ) as kcs_attached_count ,
		sum ( cas.kcs_solved_count ) as kcs_solved_count ,
		sum ( cas.guided_flow_count ) as guided_flow_count ,
		sum ( cas.dial_home_flg ) as dial_home_flg 
		-- --sums - WO
		-- sum ( null::int ) as wo_count ,
		-- sum ( null::int ) as rpa_wo_count ,
		-- sum ( null::int ) as bulk_flg ,
		-- sum ( null::int ) as rd_num ,
		-- sum ( null::int ) as rd_den ,
		-- sum ( null::int ) as rd_case_rd_qualify_denom ,
		-- sum ( null::int ) as mdr_count ,
		-- sum ( null::int ) as mmpd_count ,
		-- sum ( null::int ) as mmpd_flg ,
		-- sum ( null::int ) as mb_prt_count_num ,
		-- sum ( null::int ) as mb_prt_flg_den ,
		-- sum ( null::int ) as mpd_num ,
		-- sum ( null::int ) as mpd_denom ,
		-- sum ( null::int ) as ppd_num_p_qty ,
		-- sum ( null::int ) as ppd_denom_flg ,
		-- --sums - Outlier
		-- sum ( null::int ) as mdr_count_kcs_attached_mb_outlier  ,
		-- sum ( null::int ) as mdr_count_kcs_attached_mmpd_outlier  ,
		-- sum ( null::int ) as mdr_count_kcs_solved_mb_outlier  ,
		-- sum ( null::int ) as mdr_count_kcs_solved_mmpd_outlier  ,
		-- sum ( null::int ) as mdr_count_guided_flow_mb_outlier  ,
		-- sum ( null::int ) as mdr_count_guided_flow_mmpd_outlier 
	from tmp_tbl_ani_6208_wc_case as cas
		inner join tbl_ani_6208_wc_cal as scc
			on scc.calendar_date = cas.case_crt_dts::date
		inner join tbl_ani_6208_wc_prod as uph
			on uph.prod_key = cas.asst_prod_hier_key
		left join tbl_ani_6208_wc_pers as ad
			on ad.src_prsn_hist_gen_id = cas.owner_bdge_hist_id_at_crt
		left join tbl_ani_6208_wc_cust as cus
			on cus.iso_alpha2_cd = cas.asst_unified_iso_ctry_cd
		left join test_9244_ani_wo as tra
			on tra.case_wid = cas.case_wid
	where 1=1
		and upper(uph.prod_grp_desc) in ('POWEREDGE SERVERS')
		and (
			scc.week_lag between -3 and 0
			or 
			tra.case_wid = cas.case_wid
			)
	group by 1,2,3,4,5,6,7,8,9,10
		,11,12,13,14,15,16,17,18,19
		,20,21,22,23,24,25,26,27,28,29
		,30,31,32,33,34,35,36,37--,38,39
		-- ,40,41,42,43,44,45,46,47,48,49
		-- ,50,51,52,53,54,55,56,57,58,59
		-- ,60,61,62
)
distributed randomly
