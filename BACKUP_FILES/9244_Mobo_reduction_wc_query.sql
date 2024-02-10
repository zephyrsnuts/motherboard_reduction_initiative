--base table for wo which includes mdr and customer rdr, excluding the legacy rdr and 28 day rdr because that data is unnecessary.
--simple query to use only the required data, where rest of it will be summarized.
drop table if exists tmp_tbl_ani_6208_wc_case ;
drop table if exists tmp_tbl_ani_6208_wc_parts ;
drop table if exists tmp_tbl_ani_6208_wc_rdr ;
drop table if exists tmp_tbl_ani_6208_wc_wo ;
drop table if exists tbl_ani_6208_wc_pers ; 
drop table if exists tbl_ani_6208_wc_cust ;
--drop table if exists tbl_ani_6208_wc_asst ;
drop table if exists tbl_ani_6208_wc_prod ;
drop table if exists tbl_ani_6208_wc_trans ;
create table tmp_tbl_ani_6208_wc_case as ( 
		select distinct
			cf.case_wid ,
			cf.case_nbr ,
			cf.case_stat ,
			cf.rptg_case_chnl ,
			case when lower(cf.rptg_case_chnl) in ('connect home','connecthome','dialhome','dialhome','dialhome_dispatch')
				then 1
				else 0
			end as dial_home_flg ,
			sum ( distinct case when cf.case_wid is not null then 1 else 0 end ) as case_count
		from usdm_case_fact as cf
				INNER JOIN svc_corp_cldr as scc 
					on scc.cldr_date = cf.case_crt_dts :: date
				INNER JOIN usdm_prod_hier as uph
					on uph.prod_key = cf.asst_prod_hier_key 
				inner join usdm_wo_fact as wf
					on wf.case_wid = cf.case_wid 
				left join assoc_dim as per
					on per.src_prsn_hist_gen_id = cf.owner_bdge_hist_id_at_crt 
		where 1=1
				and wf.wo_nbr is not null
				and scc.fisc_yr_rltv between -1 and 0
				and scc.fisc_qtr_rltv < 0
				and scc.fisc_week_rltv < 0
				and lower(cf.usdm_case_type) in ('technical support' , 'incident')
				and (lower(uph.svc_prod_group) in ('enterprise solution group', 'infrastructure solutions group'))
--						or (per.bus_rptg_catg_id in (5, 69)
--					and lower(per.bus_rptg_grp_nm) in ('infrastructure solutions group','high end storage', 'commercial shared services')))
				and cf.quick_case_flg <> 1
				and lower (cf.int_case_rec_type_cd) in ('external case')
--				and cf.case_wid = '5207EBB293DEBE4091E1BEA6433DE25C'
--				and cf.asst_id = 'CK297600741'
		group by 1,2,3,4,5
--		having sum ( distinct case when cf.case_wid is not null then 1 else 0 end ) > 1
) 
distributed by (case_wid)
;
create table tmp_tbl_ani_6208_wc_parts as (
	select distinct
			part.wo_wid ,
--			part.parts_rank_by_cost_per_wo , --this will prevent summarization, unless this is summarized too, something like the string agg
			sum ( case 
						when part.maj_part_flg = 1 and part.itm_qty >= 5 then 1
						else 0
					end		
			) as mmpd_flg_5 ,
			sum ( case 	
						when part.maj_part_flg = 1 and part.itm_qty = 1 then 1
						else 0
					end		
			) as mpd_parts_single ,
			SUM ( part.maj_part_flg ) as maj_part_flg , -- based on part number, not the quantity, if there are 10 memory of 1 part num then it will flag as 1 if there are 10 memory of 10 part numbers then it will flag as 10
			max ( case when part.maj_part_flg = 1 then 1 else 0 end ) as maj_part_highlight , -- (mpd denom) only flags the wo which has major parts could be multi or single
			SUM ( case
					when upper ( gc.comdty_nm ) in ('MOTHERBOARD') and part.itm_qty > 0
					then 1 
					else 0
				end ) as motherboard_parts_count ,	
			sum ( case when part.maj_part_flg = 1 then part.itm_qty else 0 end ) as mpd_num ,
			MAX ( case when part.maj_part_flg = 1 then 1 else 0 end ) as mpd_denom ,
			MAX ( case when part.itm_qty >=1 then 1 else 0 end ) as ppd_denom ,
--			string_agg (distinct part.itm_nbr||'-'||coalesce (gc.comdty_nm, part.itm_comdty_desc, 'NO_DESC') || '(' || part.itm_qty || ')'  ,'|' ) as comdty_name ,
--			string_agg(distinct part.itm_nbr , '|' order by part.itm_nbr asc) as item_nb ,
			sum ( part.itm_qty ) as part_quantity 
	from (
			select
					orf.wo_wid ,
					orf.itm_nbr ,
					orf.itm_comdty_id ,
					orf.maj_part_flg ,
					orf.itm_comdty_desc ,
					orf.part_ord_crt_dts::date as part_ord_crt_dt ,
					orf.itm_qty as itm_qty ,
					orf.part_ord_inv_dts ,
					case	
						when (orf.maj_part_flg = 1
							or lower (orf.itm_comdty_desc) not in ('attach kit', 'documentation'))
						then row_number() over(partition by orf.wo_wid order by	orf.itm_cost_amt desc)
						else 0
					end as parts_rank_by_cost_per_wo ,
					rank() over(partition by orf.wo_wid, orf.itm_nbr, orf.itm_comdty_id , orf.itm_qty, orf.itm_comdty_desc, orf.maj_part_flg, orf.part_ord_crt_dt order by orf.part_ord_ln_nbr asc) as ranks
			from usdm_wo_itm_ord_fact as orf
			where 1=1
--				and orf.wo_wid = '00A01C829404A61842C43289DED70259'
				and orf.part_ord_inv_dts is not null
--			group by 1,2,3,4,5,6,7,8,9,orf.itm_cost_amt
	) as part
		left join sp_gbl_comdty as gc
			on gc.comdty_id = part.itm_comdty_id 
		inner JOIN ws_svc_gsa_bi.svc_corp_cldr as cal 
			on cal.cldr_date = part.part_ord_crt_dt
		left join ( select wfu.wo_wid, wfu.asst_prod_hier_key from usdm_wo_fact as wfu ) as uwf
			on uwf.wo_wid = part.wo_wid
		left join ws_svc_gsa_bi.usdm_prod_hier uph 
			on uph.prod_key = uwf.asst_prod_hier_key
	WHERE 1=1
			and cal.fisc_qtr_rltv between -5 and 0
			and (lower(uph.svc_prod_group) in ('enterprise solution group', 'infrastructure solutions group'))
--			and part.wo_wid = '3CD018FDD7411B28B9851BD1555C0897'
			and ranks = 1
			and part.itm_qty >= 1
	group by 1
--	having SUM ( case
--					when upper ( gc.comdty_nm ) in ('MOTHERBOARD') and part.maj_part_flg >= 1
--					then 1 
--					else 0
--				end ) > 1
)
distributed by (wo_wid)
;
create table tmp_tbl_ani_6208_wc_rdr as (
select distinct
	cr.wo_wid ,
	cr.wo_crt_utc_dts ,
	cr.repeat_wo_nbr ,
	cr.repeat_tm_gap_secnd ,
	cr.secnd_repeat_wo_nbr ,
	cr.secnd_repeat_tm_gap_secnd ,
	cr.gcc_rd_parnt_wo_nbr ,
	cr.gcc_crt_wo_seq_nbr ,
	sum ( mf.tech_drct_flg ) as tech_drct_flg ,
	sum ( cr.null_asst_flg ) as rd_null_asset_flg ,
	sum ( cr.dummy_asst_flg ) as rd_dummy_asset_flg ,
	sum ( cr.case_rd_rptg_flg ) as rd_case_rd_qualify_denom ,
	sum ( cr.rd_pre_qualify_flg) as rd_pre_qualify_flg ,
	sum ( cr.gcc_crt_wo_flg ) as rd_gcc_crt_wo_flg ,
	sum ( cr.gcc_reissued_flg ) as rd_gcc_reissue_flg ,
	sum ( cr.gcc_ship_cost_flg ) as rd_gcc_ship_cost_flg ,
	sum ( cr.gcc_lbr_cost_flg ) as rd_gcc_lbr_cost_flg ,
	sum ( cr.ship_cost_flg ) as rd_ship_cost_flg , 
	sum ( cr.lbr_cost_flg ) as rd_lbr_cost_flg ,
	sum ( cr.onsite_diagnosis_dps_flg ) as rd_onsite_diags_dps_flg ,
	sum ( cr.onsite_diagnosis_lbr_flg ) as rd_onsite_diags_lbr_flg ,
	sum ( cr.repeat_7_defect_flg ) as repeat_num ,
	sum ( cr.rd_qualify_flg ) as qualify_denom ,
	sum ( mf.mdr_qualify_flg ) as mdr_qualify_count ,
	sum ( mf.mdr_dspch_flg ) as mdr_count 
FROM usdm_wo_mdr_fact as mf
	inner join usdm_wo_fact as wf
		on wf.wo_wid = mf.wo_wid 
	INNER JOIN svc_corp_cldr as scc 
		on scc.cldr_date = wf.wo_crt_utc_dts :: date
	INNER JOIN usdm_prod_hier as uph
		on uph.prod_key = wf.asst_prod_hier_key
	left join usdm_wo_cust_rdr_fact as cr
		on cr.wo_wid = wf.wo_wid
	left join ws_svc_gsa_bi.assoc_dim as per 
		on per.src_prsn_hist_gen_id = wf.wo_crt_by_bdge_hist_id
WHERE 1=1
	and scc.fisc_qtr_rltv between -5 and 0
--	and scc.fisc_week_rltv = -1 -- and 0
	and (lower(uph.svc_prod_group) in ('enterprise solution group', 'infrastructure solutions group'))
--			or (per.bus_rptg_catg_id in (5, 69)
--				and per.bus_rptg_grp_nm in ('Infrastructure Solutions Group','High End Storage', 'Commercial Shared Services')))
	and cr.rd_pre_qualify_flg = 1
group by 1,2,3,4,5,6,7,8
order by 1 desc
)
distributed by (wo_wid)
;
create table tmp_tbl_ani_6208_wc_wo as (
select
uwf.wo_nbr ,
uwf.case_wid ,
uwf.wo_wid ,
uwf.dps_type ,
uwf.call_type ,
uwf.curr_stat ,
uwf.wo_type ,
uwf.svc_type ,
uwf.svc_opt ,
uwf.svc_opt_hrs ,
uwf.sfdc_wo_id ,
uwf.wo_crt_utc_dts ,
uwf.asst_prod_hier_key ,
uwf.cust_lcl_chnl_cd ,
uwf.asst_unified_iso_ctry_cd ,
uwf.wo_crt_by_bdge_hist_id ,
uwf.wo_apprvd_bdge_hist_id ,
uwf.asst_id ,
row_number() over ( partition by uwf.case_wid order by uwf.wo_crt_utc_dts asc ) as wo_ranks ,
sum ( case when uwf.wo_wid is not null then 1 else 0 end ) as wo_count
from usdm_wo_fact as uwf 
	INNER JOIN svc_corp_cldr as scc 
		on scc.cldr_date = uwf.wo_crt_utc_dts :: date
	INNER JOIN usdm_prod_hier as uph
		on uph.prod_key = uwf.asst_prod_hier_key 
	left join ws_svc_gsa_bi.assoc_dim per 
		on per.src_prsn_hist_gen_id = uwf.wo_crt_by_bdge_hist_id
where 1=1
	and scc.fisc_qtr_rltv between -5 and 0
	and (lower(uph.svc_prod_group) in ('enterprise solution group', 'infrastructure solutions group'))
--			or (per.bus_rptg_catg_id in (5, 69)
--				and per.bus_rptg_grp_nm in ('Infrastructure Solutions Group','High End Storage', 'Commercial Shared Services')))
group by 1,2,3,4,5,6,7,8,9,10,
		11,12,13,14,15,16,17,18
)
distributed by ( wo_wid )
;
create table tbl_ani_6208_wc_pers as (
		with gdpr_man_data as (
				select distinct
					pers.src_prsn_hist_gen_id as person_hist_id ,
					pers.assoc_bdge_nbr ,
					case
						when pers.bus_frst_mgr_bdge_nbr in ('111111', '76684', '-1', '0') then pers.frst_mgr_last_nm || ', ' || pers.frst_mgr_frst_nm
						when PERS.frst_mgr_bdge_nbr is null then 'TBD - NO NAME AVAILABLE'
						else pers.bus_frst_mgr_last_nm || ', ' || pers.bus_frst_mgr_frst_nm
					end manager_first ,
					case
						when pers.bus_secnd_mgr_bdge_nbr in ('111111', '76684', '-1', '0') then pers.secnd_mgr_last_nm || ', ' || pers.secnd_mgr_frst_nm
						when PERS.secnd_mgr_bdge_nbr is null then 'TBD - NO NAME AVAILABLE'
						else pers.bus_secnd_mgr_last_nm || ', ' || pers.secnd_mgr_frst_nm
					end manager_second ,
					case
						when pers.CTRY_NM in ('Austria', 'Belgium', 'Bulgaria', 'Croatia', 'Republic of Cyprus', 'Czech Republic', 'Denmark', 'Estonia', 'Finland', 'France', 'Germany', 'Greece', 'Hungary', 'Ireland', 'Italy', 'Latvia', 'Lithuania', 'Luxembourg', 'Malta', 'Netherlands', 'Poland', 'Portugal', 'Romania', 'Slovakia', 'Slovenia', 'Spain', 'Sweden', 'United Kingdom') then 1
						else 0
					end GDPR_Protection_flag ,
					coalesce (aehh.epicenter_lvl_3_assoc_nm,
					aehh.hr_lvl_3_assoc_nm ) manager_3 ,
					coalesce (aehh.epicenter_lvl_4_assoc_nm ,
					aehh.hr_lvl_4_assoc_nm ) manager_4 ,
					coalesce (aehh.epicenter_lvl_5_assoc_nm ,
					aehh.hr_lvl_5_assoc_nm ) manager_5 ,
					coalesce (aehh.epicenter_lvl_6_assoc_nm ,
					aehh.hr_lvl_6_assoc_nm ) manager_6 ,
					row_number() over(partition by pers.assoc_bdge_nbr
				order by
					pers.gp_ins_upd_dts desc) as order_list
				from
					ws_svc_gsa_bi.assoc_dim pers
				left join (select a1.*, row_number() over(partition by a1.src_prsn_hist_gnrtn_id order by a1.gpetl_update_dt desc) as row_rank from ws_svc_gsa_bi.assoc_epicenter_hr_hier a1) aehh on
					aehh.src_prsn_hist_gnrtn_id = pers.src_prsn_hist_gen_id
					and aehh.row_rank = 1
		),
		robotics as (/*checking for robotic user*/
				select
					per.src_prsn_hist_gen_id ,
					per.updated_order ,
					per.ROBOTIC_USER
				from
					(
					select
						distinct ad.src_prsn_hist_gen_id ,
						case
							when ad.bus_rptg_dept_nm in ('Robotics')
							and ad.assoc_frst_nm in ('RUI') then 1
							else 0
						end robotic_user1 ,
						case
							when lower(sud.BOT_FLG) = 'y'
							or lower(sud.FIN_SUB_QUEUE_NM) in ('robotics')
							or lower(sud.VNDR_DESC) in ('robotic user id')
							or lower(ad.bus_rptg_team_cd) in ('robotic process auto')
							or lower(ad.bus_rptg_team_nm) in ('robotic process automation queue') then 'Y'
							else 'N'
						end ROBOTIC_USER ,
						row_number() over(partition by ad.assoc_bdge_nbr
					order by
						ad.src_updt_dts desc) as updated_order
					from
						ws_svc_gsa_bi.assoc_dim ad
					left join ws_svc_gsa_bi.sfdc_user_dtl sud on
						sud.assoc_bdge_nbr = ad.assoc_bdge_nbr
					where
						1 = 1
						--and (ad.bus_secnd_mgr_bdge_nbr = '346554' or ad.secnd_mgr_bdge_nbr ='346554')
						--and ad.bus_rptg_dept_nm in ('Robotics')
						--and ad.assoc_ntwk_login_nm not like '%RUI_GABFO%'
						--and updated_order = 1
						--fetch first 500 rows only
				) per
				where
					lower(per.ROBOTIC_USER) = 'y'
					and per.updated_order = 1 /*end of robotic user*/
		)
		select distinct
		ad2.src_prsn_hist_gen_id ,
		ad2.assoc_full_nm ,
		ad2.assoc_ptnr_nm ,
		ad2.assoc_ptnr_osp_flg ,
		ad2.assoc_loc_nm ,
		ad2.bus_rptg_catg_nm ,
		ad2.bus_rptg_dept_nm ,
		ad2.bus_rptg_func_nm ,
		ad2.bus_rptg_grp_nm ,
		ad2.bus_rptg_queue_nm ,
		ad2.assoc_bdge_nbr ,
		case
			when (ad2.bus_rptg_rgn_nm in ('AMERICAS') and ad2.bus_rptg_subrgn_nm in ('Latin America')) then 'LA'
			when ad2.bus_rptg_rgn_nm in ('AMERICAS') then 'NA'
			else ad2.bus_rptg_rgn_nm
		end as bus_rptg_rgn_nm ,
		ad2.bus_rptg_subrgn_nm ,
		ad2.bus_rptg_subgrp_nm ,
		ad2.bus_rptg_team_nm ,
		gmd.manager_first ,
		gmd.manager_second ,
		gmd.manager_3 as manager_l3 ,
		gmd.manager_4 as manager_l4 ,
		gmd.manager_5 as manager_l5 ,
		coalesce(rob.ROBOTIC_USER, '') as robotic_user 
		from ws_svc_gsa_bi.assoc_dim ad2
		left join gdpr_man_data gmd
			on gmd.person_hist_id = ad2.src_prsn_hist_gen_id
		left join robotics rob
			on rob.src_prsn_hist_gen_id = ad2.src_prsn_hist_gen_id
		where
			1 = 1
			and ad2.bus_rptg_catg_id in (5, 69)
			and lower(ad2.bus_rptg_grp_nm) in ('unkn','scheduling and account services','commercial enterprise services', 'infrastructure solutions group',
				'high end storage', 'commercial shared services', 'large business', 'large enterprise', 'technical account management')
		group by 1,2,3,4,5,6,7,8,9,10,
		11,12,13,14,15,16,17,18,19,20,21
)
distributed by ( src_prsn_hist_gen_id )
;
create table tbl_ani_6208_wc_cust as (
		select distinct
				ughs.iso_alpha2_cd
				,ughs.ctry_nm as ctry_nm
				,CASE WHEN ughs.dell_sub_terr = 'Latin America' THEN 'LA'
				    WHEN ughs.dell_terr_cd = 'Latin America' THEN 'LA'
				    WHEN ughs.dell_terr_cd = 'EMEAF' THEN 'EMEA'
				    WHEN ughs.dell_terr_cd = 'AMER' THEN 'NA'
				    WHEN ughs.dell_terr_cd = 'APJAP' THEN 'APJ'
				    WHEN ughs.iso_alpha2_cd = '-3' THEN 'UNK'
				    WHEN ughs.iso_alpha2_cd = '-2' THEN 'UNK'
				    WHEN ughs.iso_alpha2_cd = '-1' THEN 'UNK'
				    ELSE ughs.dell_terr_cd
				END as region_name
				,ughs.dell_sub_terr as subregion_name
				,ughs.dell_area as area_name
		from ws_svc_gsa_bi.usdm_geo_hier_srt ughs
)
distributed by ( iso_alpha2_cd ) 
;
--create table tbl_ani_6208_wc_asst as ()
create table tbl_ani_6208_wc_cal as (
		select
		scc.cldr_date::date AS calendar_date
		,scc.cldr_day_val AS calendar_day
		,scc.fisc_day_rltv AS day_lag
		,scc.weekday_flag AS weekday_flag
		,scc.fisc_week_rltv AS week_lag
		,scc.fisc_mth_rltv AS month_lag
		,scc.fisc_qtr_rltv AS quarter_lag
		,scc.fisc_yr_rltv AS year_lag
		,scc.fisc_week_val AS fiscal_week
		,scc.fisc_mth_val AS fiscal_month
		,scc.fisc_qtr_val AS fiscal_quarter
		,scc.fisc_yr_val AS fiscal_year
	--	,current_date at time zone 'UTC' as current_refresh_time
		from ws_svc_gsa_bi.svc_corp_cldr scc
		where 1=1
		and scc.fisc_yr_rltv between -3 and 0
		and scc.fisc_qtr_rltv <= 0
		and scc.fisc_week_rltv <= 0
)
distributed by (calendar_date)
;
create table tbl_ani_6208_wc_prod as (
		select distinct
			uph.prod_key ,
			uph.global_grouping as global_grouping ,
			uph.global_product as global_product,
			uph.global_lob as global_lob,
			uph.global_brand as global_brand ,
			uph.global_generation as global_generation,
			case
				when uph.src_sys_id = 'LEMC' then uph.fmly
				when uph.src_sys_id = 'LDELL' then uph.prod_lob_rptg_grp
				else 'OTHER'
			end as product_family ,
			case
				when uph.src_sys_id = 'LEMC' then uph.prod_desc
				when uph.src_sys_id = 'LDELL' then uph.prod_ln_nm
				else 'OTHER'
			end as product_line_name
		from ws_svc_gsa_bi.usdm_prod_hier uph
)
distributed by ( prod_key )
;
create table tbl_ani_6208_wc_trans as ( 
select distinct
	wf.asst_prod_hier_key ,
	wf.cust_lcl_chnl_cd ,
	wf.asst_unified_iso_ctry_cd ,
	wf.wo_crt_by_bdge_hist_id ,
	wf.wo_apprvd_bdge_hist_id ,
	wf.asst_id ,
	cr.wo_crt_utc_dts ,
	wf.wo_wid ,
	wf.case_wid ,
	wf.wo_nbr ,
	cf.case_nbr ,
	cf.rptg_case_chnl ,
	cr.repeat_wo_nbr ,
	cr.repeat_tm_gap_secnd ,
	cr.secnd_repeat_wo_nbr ,
	cr.secnd_repeat_tm_gap_secnd ,
	cr.gcc_rd_parnt_wo_nbr ,
	cr.gcc_crt_wo_seq_nbr ,
	--tmp_tbl_ani_6208_wc_parts 
	sum ( prt.mpd_num ) as mpd_num ,
	sum ( prt.mpd_denom ) as mpd_denom ,
	sum ( prt.ppd_denom ) as ppd_denom ,
	sum ( prt.part_quantity ) as ppd_num ,
	sum ( prt.motherboard_parts_count ) as mobo_count ,
	sum ( prt.mmpd_flg_5 ) as mmpd_5_count ,
	sum ( prt.mpd_parts_single ) as mpd_single_count ,
	sum ( cr.tech_drct_flg ) as rd_tech_drct_flg ,
	sum ( cr.rd_null_asset_flg ) as rd_null_asset_flg ,
	sum ( cr.rd_dummy_asset_flg ) as rd_dummy_asset_flg ,
	sum ( cr.rd_case_rd_qualify_denom ) as rd_case_rd_qualify_denom ,
	sum ( cr.rd_pre_qualify_flg) as rd_pre_qualify_flg ,
	sum ( cr.rd_gcc_crt_wo_flg ) as rd_gcc_crt_wo_flg ,
	sum ( cr.rd_gcc_reissue_flg ) as rd_gcc_reissue_flg ,
	sum ( cr.rd_gcc_ship_cost_flg ) as rd_gcc_ship_cost_flg ,
	sum ( cr.rd_gcc_lbr_cost_flg ) as rd_gcc_lbr_cost_flg ,
	sum ( cr.rd_ship_cost_flg ) as rd_ship_cost_flg , 
	sum ( cr.rd_lbr_cost_flg ) as rd_lbr_cost_flg ,
	sum ( cr.rd_onsite_diags_dps_flg ) as rd_onsite_diags_dps_flg ,
	sum ( cr.rd_onsite_diags_lbr_flg ) as rd_onsite_diags_lbr_flg ,
	sum ( cr.repeat_num ) as repeat_num ,
	sum ( cr.qualify_denom ) as qualify_denom ,
	sum ( cr.mdr_count ) as mdr_count ,
	sum ( distinct wf.wo_count ) as wo_count ,
	sum ( case when ( wf.wo_ranks is null or wf.wo_ranks = 1 ) then cf.case_count else null end ) as case_count ,
	sum ( case when cf.dial_home_flg >= 1 then 1 else 0 end ) as dial_home_flg
FROM tmp_tbl_ani_6208_wc_wo as wf
	INNER JOIN svc_corp_cldr as scc 
		on scc.cldr_date = wf.wo_crt_utc_dts :: date
	INNER JOIN usdm_prod_hier as uph
		on uph.prod_key = wf.asst_prod_hier_key
	LEFT JOIN tmp_tbl_ani_6208_wc_case as cf
		on cf.case_wid = wf.case_wid
	left join tmp_tbl_ani_6208_wc_rdr as cr
		on cr.wo_wid = wf.wo_wid
	left join ws_svc_gsa_bi.assoc_dim per 
		on per.src_prsn_hist_gen_id = wf.wo_crt_by_bdge_hist_id
	left join tmp_tbl_ani_6208_wc_parts as prt 
		on prt.wo_wid = wf.wo_wid
WHERE 1=1
	and scc.fisc_qtr_rltv between -5 and 0
--	and scc.fisc_week_rltv = -1 -- and 0
	and (lower(uph.svc_prod_group) in ('enterprise solution group', 'infrastructure solutions group'))
--			or (per.bus_rptg_catg_id in (5, 69)
--				and lower (per.bus_rptg_grp_nm) in ('unkn','infrastructure solutions group','high end storage', 'commercial shared services')))
	and cr.rd_pre_qualify_flg = 1
--	and wf.asst_id = 'CK297600741'
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18
order by 1 asc
)
;
drop table if exists tmp_tbl_ani_6208_wc_case ;
drop table if exists tmp_tbl_ani_6208_wc_parts ;
drop table if exists tmp_tbl_ani_6208_wc_rdr ;
drop table if exists tmp_tbl_ani_6208_wc_wo ;
create table tbl_ani_6208_wc_smry as (

		select distinct
			--calendar
			scc.fisc_week_val as weeks,
			scc.fisc_qtr_val as quarters,
			scc.fisc_yr_val as years,
			--product
			uph.global_grouping ,
			uph.global_product,
			uph.global_lob,
			uph.global_brand,
			uph.global_generation,
			--person
		--	per.assoc_full_nm ,
			per.assoc_ptnr_nm ,
		--	per.assoc_loc_nm ,
			per.bus_rptg_dept_nm ,
		--	per.bus_rptg_func_nm ,
			per.bus_rptg_grp_nm ,
		--	per.bus_rptg_queue_nm ,
		--	per.assoc_bdge_nbr ,
			per.bus_rptg_rgn_nm ,
		--	per.bus_rptg_subrgn_nm ,
		--	per.bus_rptg_subgrp_nm ,
		--	per.bus_rptg_team_nm ,
			per.manager_first ,
			per.manager_second ,
		--	per.manager_l3 as manager_3 ,
		--	per.manager_l4 as manager_4 ,
			per.manager_l5 as manager_5 ,
		--	per.robotic_user as robotics , 
			sum ( case when lower (per.assoc_ptnr_osp_flg) = 'y' then 1 else 0 end ) as assoc_ptnr_osp_flg ,
			--work 
			sum ( tra.mpd_num ) as mpd_num ,
			sum ( tra.mpd_denom ) as mpd_denom ,
			sum ( tra.ppd_denom ) as ppd_denom ,
			sum ( tra.ppd_num ) as ppd_num ,
			sum ( tra.mobo_count ) as mobo_count ,
			sum ( tra.mmpd_5_count ) as mmpd_5_count ,
			sum ( tra.mpd_single_count ) as mpd_single_count ,
			sum ( tra.rd_tech_drct_flg ) as rd_tech_drct_flg ,
			sum ( tra.rd_null_asset_flg ) as rd_null_asset_flg ,
			sum ( tra.rd_dummy_asset_flg ) as rd_dummy_asset_flg ,
			sum ( tra.rd_case_rd_qualify_denom ) as rd_case_rd_qualify_denom ,
			sum ( tra.rd_pre_qualify_flg ) as rd_pre_qualify_flg ,
			sum ( tra.rd_gcc_crt_wo_flg ) as rd_gcc_crt_wo_flg ,
			sum ( tra.rd_gcc_reissue_flg ) as rd_gcc_reissue_flg ,
			sum ( tra.rd_gcc_ship_cost_flg ) as rd_gcc_ship_cost_flg ,
			sum ( tra.rd_gcc_lbr_cost_flg ) as rd_gcc_lbr_cost_flg ,
			sum ( tra.rd_ship_cost_flg ) as rd_ship_cost_flg , 
			sum ( tra.rd_lbr_cost_flg ) as rd_lbr_cost_flg ,
			sum ( tra.rd_onsite_diags_dps_flg ) as rd_onsite_diags_dps_flg ,
			sum ( tra.rd_onsite_diags_lbr_flg ) as rd_onsite_diags_lbr_flg ,
			sum ( tra.repeat_num ) as repeat_num ,
			sum ( tra.qualify_denom ) as qualify_denom ,
			sum ( tra.mdr_count ) as mdr_count ,
			sum ( distinct tra.wo_count ) as wo_count ,
			sum ( tra.case_count ) as case_count ,
			sum ( tra.dial_home_flg ) as dial_home_flg
		from tbl_ani_6208_wc_trans as tra
			inner join svc_corp_cldr as scc
				on scc.cldr_date = tra.wo_crt_utc_dts::date
			INNER JOIN tbl_ani_6208_wc_prod as uph
				on uph.prod_key = tra.asst_prod_hier_key
			left join tbl_ani_6208_wc_cust as cust
				on cust.iso_alpha2_cd = tra.asst_unified_iso_ctry_cd
			left join tbl_ani_6208_wc_pers as per
				on per.src_prsn_hist_gen_id = tra.wo_crt_by_bdge_hist_id
		where 1=1
			and scc.fisc_qtr_rltv between -5 and 0
			and scc.fisc_week_rltv = -1
--			and lower (per.manager_l5) = 'brown, dexter s.'
		--	and tra.case_nbr is not null
		--	and dial_home_flg = 1
		--	and wo_nbr = '433331806'
		group by 1,2,3,4,5,6,7,8,9,10
		,11,12,13,14,15--,16,17--,18,19,20
		--,21,22,23--,24,25--,26,27,28,29,30
		
)
distributed randomly 
;
--for norbert, require outlier names included metrics are mdr, mpd, ppd, rdr
--create table tbl_ani_9244_wc_mobo as (
--
--					select
--					*,
--					--mdr
--					sum ( rd.mdr_qualify_count ) as mdr_denom ,
--					
--					--mpd
--					--ppd
--					--rdr
--					from tmp_tbl_ani_6208_wc_wo as wc
--						left join tmp_tbl_ani_6208_wc_rdr as rd
--							on rd.wo_wid = wc.wo_wid
--						left join tmp_tbl_ani_6208_wc_case as cs
--							on cs.case_wid = wc.case_wid
--						left join tmp_tbl_ani_6208_wc_parts as pt
--							on pt.wo_wid = wc.wo_wid
--						left join tbl_ani_6208_wc_cust as cu
--							on cu.iso_alpha2_cd = wc.asst_unified_iso_ctry_cd
--						inner join tbl_ani_6208_wc_cal as cal
--							on cal.cldr_date = wc.wo_crt_utc_dts:: date
--						inner join tbl_ani_6208_wc_prod as pr
--							on pr.prod_key = wc.asst_prod_hier_key
--
--
--
--)

drop table if exists tmp_tbl_ani_6208_wc_case ;
drop table if exists tmp_tbl_ani_6208_wc_parts ;
drop table if exists tmp_tbl_ani_6208_wc_rdr ;
drop table if exists tmp_tbl_ani_6208_wc_wo ;
drop table if exists tbl_ani_6208_wc_pers ; 
drop table if exists tbl_ani_6208_wc_cust ;
--drop table if exists tbl_ani_6208_wc_asst ;
drop table if exists tbl_ani_6208_wc_prod ;
drop table if exists tbl_ani_6208_wc_trans ;

--query for Adrian to find the duration between created and submitted.
--testing queries
--select 
--count(tra.mdr_count2)
--from tbl_ani_6208_wc_trans as tra
--	inner join svc_corp_cldr as cal 
--		on cal.cldr_date = tra.wo_crt_utc_dts::date
--where cal.fisc_week_rltv = -1
--;
--select 
--sum(tra.mdr_count2)
--from tbl_ani_6208_wc_smry as tra
--where tra.weeks = '2024-W03'