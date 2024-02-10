--base table for wo which includes mdr and customer rdr, excluding the legacy rdr and 28 day rdr because that data is unnecessary.
--simple query to use only the required data, where rest of it will be summarized.
drop table if exists tmp_tbl_ani_6208_wc_ast ;
drop table if exists tbl_ani_6208_wc_asu_total ;
drop table if exists tmp_tbl_ani_6208_wc_telco ;
drop table if exists tmp_tbl_ani_6208_wc_case ;
drop table if exists tmp_tbl_ani_6208_wc_parts ;
drop table if exists tmp_tbl_ani_6208_wc_rdr ;
drop table if exists tmp_tbl_ani_6208_wc_wo ;
drop table if exists tbl_ani_6208_wc_comb ;
drop table if exists tbl_ani_6208_wc_pers ; 
drop table if exists tbl_ani_6208_wc_cust ;
--drop table if exists tbl_ani_6208_wc_asst ;
drop table if exists tbl_ani_6208_wc_cal ;
drop table if exists tbl_ani_6208_wc_prod ;
drop table if exists tbl_ani_6208_wc_trans ;
drop table if exists tbl_ani_6208_wc_pbi ;
drop table if exists tbl_ani_6208_wc_smry ;
create table tmp_tbl_ani_6208_wc_ast as (
--this asset table only gets data for the assets which have cases associated, there is no need for me to get assets without case
--because we are looking at WO and RDR. we don't need to know a total volume of assets for customers and how many WO were booked on which of those.
--we only need to look at what were the cases that were booked on each asset and the WO will be a part of those cases, cases are related to tech support.
-- and to improve the WO RDR numbers, we have to look at cases only. data for ASU is not required. count for the number of assets which have no cases in tech support will only be
--needed if anyone wants to look at dispatch rate for assets, here we only need dispatch rate for cases.
--how will i even join it to the cases or WO?
			select distinct
					uafa.src_cust_prod_id ,
					uafa.asst_id ,
					sum(distinct (case when uafa.DEL_FLG = 'Y' then 0
							when uafa.ASST_PRNT_SRL_NBR is NULL
								and uafa.DUAL_SERL_FLG = 'N' then 1
							when uafa.ASST_PRNT_SRL_NBR is NULL
								and uafa.DUAL_SERL_FLG = 'Y'
								and uafa.DUAL_SERL_PRIM_ASST_FLG = 'Y' then 1
							else 0 end)) asu_flg ,	
					sum(distinct (case when uafa.ASST_ID is not null then 1 else 0 end)) as asset_count
			from usdm_asst_fact as uafa
				left join usdm_case_fact as ucf
					on ucf.src_cust_prod_id = uafa.src_cust_prod_id 
				inner join svc_corp_cldr as scc 
					on scc.cldr_date = ucf.case_crt_dts ::date
			where 1=1
				and scc.fisc_yr_rltv >= -2
			group by 1,2
)
distributed by ( src_cust_prod_id , asst_id )
;
create table tbl_ani_6208_wc_asu_total as (
			select distinct
					-- add year quarter and week columns so that it can be joined to the year the cases were created or quarter, can even add date for the case creation
					--so when joined to the date we will have a better picture. but to summarize year quarter and week should be enough.
					-- if joined to date we will know how many ASU were tehre for that date, then product too, add only the filters i want to see, not unnecessary ones.
					-- cant join cases table cos that will filter it to only the cases table, will have to use the asset
					scc.fisc_week_val as week_key, 
					scc.fisc_qtr_val as quarter_key,
					scc.fisc_yr_val as year_key,
					uph.global_grouping as prod_group_key,
					uph.global_product as prod_prod_key ,
					uph.global_lob as prod_lob_key ,
					uph.global_brand as prod_brand_key,
					sum((case when uafa.DEL_FLG = 'Y' then 0
							when uafa.ASST_PRNT_SRL_NBR is NULL
								and uafa.DUAL_SERL_FLG = 'N' then 1
							when uafa.ASST_PRNT_SRL_NBR is NULL
								and uafa.DUAL_SERL_FLG = 'Y'
								and uafa.DUAL_SERL_PRIM_ASST_FLG = 'Y' then 1
							else 0 end)) as asu_denom ,	
					sum(distinct (case when uafa.ASST_ID is not null then 1 else 0 end)) as asset_denom
			from usdm_asst_fact as uafa
				inner join usdm_prod_hier as uph
					on uafa.asst_prod_hier_key = uph.prod_key 
				inner join ( select * from svc_corp_cldr as ca where ca.fisc_yr_rltv > -5 ) as scc
					on uafa.asst_crt_utc_dts::date = scc.cldr_date --between min(scc.cldr_date) and max(scc.cldr_date) 
			where 1=1
				and lower(uph.prod_bu_type) in ('enterprise solution group pbu', 'infrastructure solutions pbu')
			group by 1,2,3,4,5,6,7
)
;
create table tmp_tbl_ani_6208_wc_telco as (
				select distinct
							ucf.asst_id 
							,ucf.cntrct_strt_dtsz 
							,ucf.cntrct_end_dtsz 
							,row_number() over(partition by ucf.asst_id order by ucf.cntrct_strt_dtsz desc) as row_rank
							,max(case
								when (ucf.svc_lvl_cd in ('TC1','TC2','TC3','TC4','TC5','TC6','TC7','TC8','TC9','TCA','TCB','TCC','TCD','TCE','TCF','TCG','TCH','TCI','TCJ','TCN','TCO','TCP','TCQ','TCR','TCS','TCT','TCU','TCV','TCW','TCX','TCY','TCZ')
									or (ucf.svc_lvl_cd like ('TC_') and (lower(ucf.svc_lvl_desc) like ('%respond%') or lower(ucf.svc_lvl_desc) like ('%restore%'))))
								then 1 else 0
							end) as telco_flg
							,max(case 
								when ucf.svc_lvl_cd in ('TC4','TC7','TCN','TCQ') then 'Telco CoreUnit'
								when ucf.svc_lvl_cd in ('TC5','TC8','TCO','TCS') then 'Telco NearEdge'
								when ucf.svc_lvl_cd in ('TCP','TCT','TCU','TCV','TC6') then 'Telco FarEdge'
								when ucf.svc_lvl_cd in ('TCR') then 'Telco Response Only'
								when (ucf.svc_lvl_cd like ('TC_') and (lower(ucf.svc_lvl_desc) like ('%respond%') or lower(ucf.svc_lvl_desc) like ('%restore%'))) then ucf.svc_lvl_desc 
							else null
							end) as telco_service
				from ws_svc_gsa_bi.usdm_cntrct_fact ucf 
				--			where ucf.asst_id = 'JWNVCV2'
				group by 1,2,3--,4,5
				having max(case
								when (ucf.svc_lvl_cd in ('TC1','TC2','TC3','TC4','TC5','TC6','TC7','TC8','TC9','TCA','TCB','TCC','TCD','TCE','TCF','TCG','TCH','TCI','TCJ','TCN','TCO','TCP','TCQ','TCR','TCS','TCT','TCU','TCV','TCW','TCX','TCY','TCZ')
									or (ucf.svc_lvl_cd like ('TC_') and (lower(ucf.svc_lvl_desc) like ('%respond%') or lower(ucf.svc_lvl_desc) like ('%restore%'))))
								then 1 else 0
							end) = 1
)
distributed by ( asst_id )
;
drop table if exists tmp_tbl_ani_6208_wc_tcase;
create table tmp_tbl_ani_6208_wc_tcase as  (
				select distinct
					cf.case_wid ,
					cf.case_nbr ,
					cf.case_crt_dts ,
					cf.sfdc_case_nbr ,
					cf.case_stat ,
					cf.rptg_case_chnl ,
					cf.asst_id ,
					cf.src_cust_prod_id ,
					cf.sfdc_case_id ,
					cf.asst_prod_hier_key ,
					cf.asst_unified_iso_ctry_cd ,
					cf.case_rec_type ,
					cf.int_case_rec_type_cd ,
					cf.origin_nm ,
					cf.crt_by_bdge_hist_id ,
					cf.owner_bdge_hist_id_at_crt ,
					row_number() over (partition by cf.asst_id order by cf.case_crt_dts asc) as case_ranks ,
					sum ( case when lower(cf.rptg_case_chnl) in ('connect home','connecthome','dialhome','dialhome','dialhome_dispatch')
						then 1
						else 0
					end ) as dial_home_flg ,
					sum ( case when cf.case_wid is not null then 1 else 0 end ) as case_created_count
				from usdm_case_fact as cf
						INNER JOIN svc_corp_cldr as scc 
							on scc.cldr_date = cf.case_crt_dts :: date
						left JOIN usdm_prod_hier as uph
							on uph.prod_key = cf.asst_prod_hier_key 
--						inner join usdm_wo_fact as wf
--							on wf.case_wid = cf.case_wid 
						left join assoc_dim as per
							on per.src_prsn_hist_gen_id = cf.owner_bdge_hist_id_at_crt 
				where 1=1
		--				and wf.wo_nbr is not null
						and scc.fisc_yr_rltv between -2 and 0
						and scc.fisc_qtr_rltv <= 0
						and scc.fisc_week_rltv <= 0
						and lower(cf.usdm_case_type) in ('technical support' , 'incident')
						and lower(cf.CASE_REC_TYPE) not in ('care_case_read_only', 'care', 'accountbasedcase')--, 'internal_case','internal_case_readonly')
						and (
							lower(uph.prod_bu_type) in ('enterprise solution group pbu', 'infrastructure solutions pbu')
						or lower(per.bus_rptg_grp_nm) in ('scheduling and account services','commercial enterprise services', 'infrastructure solutions group', 
															'high end storage', 'commercial shared services', 'large business', 'large enterprise', 'technical account management')
							)
						and cf.quick_case_flg <> 1
						and lower (cf.int_case_rec_type_cd) in ('external case')
--						and lower(cf.rptg_case_chnl) not in ('dosd')
		--				and cf.case_wid = '5207EBB293DEBE4091E1BEA6433DE25C'
		--				and cf.asst_id = 'CK297600741'
				group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16
		--		having sum ( distinct case when cf.case_wid is not null then 1 else 0 end ) > 1
)
distributed by ( case_wid, sfdc_case_id )
;
drop table if exists tmp_tbl_ani_6208_wc_kcs;
create table tmp_tbl_ani_6208_wc_kcs as (
			select distinct
				atc.case_id ,
				case when lower ( atc.case_src_nm ) in ('knowledge articles')
							and lower ( atc.coveo_rslt_link_nm ) like '%/kbdoc%'
					then 'LKB - KBDOC'
					else atc.case_src_nm
				end as case_source , -- this causes duplication hence had to rank it
				count ( distinct case when atc.case_id is not null then 1 else null end ) as kcs_attached_count ,
				count ( distinct case when lower ( atc.prob_solved_flg ) = 'y' then atc.case_id else null end ) as kcs_solved_count ,
				row_number() over ( partition by atc.case_id order by atc.src_crt_dts desc ) as atc_ranks
			from sfdc_coveo_case_attcht_dtl as atc
				inner join svc_corp_cldr as scc
					on scc.cldr_date = atc.src_crt_dts :: date
				inner join ( select ct.sfdc_case_id, ct.rptg_case_chnl , ct.asst_prod_hier_key, ct.CASE_REC_TYPE, ct.int_case_rec_type_cd from tmp_tbl_ani_6208_wc_tcase as ct ) as ucf
					on ucf.sfdc_case_id = atc.case_id 
				left join usdm_prod_hier as uph
					on uph.prod_key = ucf.asst_prod_hier_key 
			where 1=1
				and scc.fisc_yr_rltv between -2 and 0
				and (lower(uph.prod_bu_type) in ('enterprise solution group pbu', 'infrastructure solutions pbu'))
				and lower(ucf.CASE_REC_TYPE) not in ('care_case_read_only', 'care', 'accountbasedcase', 'internal case')
				and lower (ucf.int_case_rec_type_cd) in ('external case')
--				and lower(ucf.rptg_case_chnl) not in ('dosd')
			group by 1, 2,atc.src_crt_dts
)
distributed by ( case_id )
;
drop table if exists tmp_tbl_ani_6208_wc_gf;
create table tmp_tbl_ani_6208_wc_gf as (
			select distinct
				gf.case_id ,
				count ( distinct case when gf.guided_flow_txt is not null then 1 else null end ) as guided_flow_count
			from sfdc_flow_log_dtl as gf
				inner join svc_corp_cldr as scc
						on scc.cldr_date = gf.src_crt_dts :: date
				inner join ( select ct.sfdc_case_id, ct.rptg_case_chnl , ct.asst_prod_hier_key, ct.CASE_REC_TYPE, ct.int_case_rec_type_cd from tmp_tbl_ani_6208_wc_tcase as ct ) as ucf
					on ucf.sfdc_case_id = gf.case_id 
				left join usdm_prod_hier as uph
					on uph.prod_key = ucf.asst_prod_hier_key 
			where 1=1
				and scc.fisc_yr_rltv between -2 and 0
				and (lower(uph.prod_bu_type) in ('enterprise solution group pbu', 'infrastructure solutions pbu'))
				and lower(ucf.CASE_REC_TYPE) not in ('care_case_read_only', 'care', 'accountbasedcase', 'internal case')
				and lower (ucf.int_case_rec_type_cd) in ('external case')
--				and lower(ucf.rptg_case_chnl) not in ('dosd')
			group by 1
)
distributed by ( case_id ) 
;
drop table if exists tmp_tbl_ani_6208_wc_ccmplt;
create table tmp_tbl_ani_6208_wc_ccmplt as (
		select distinct 
				ucf.case_wid ,
				sum ( case when ucf.case_wid is not null then 1 else 0 end ) as case_complete_count_owner
		from usdm_case_fact ucf 
			inner join svc_corp_cldr as scc 
				on scc.cldr_date = ucf.case_cmplt_dts ::date
			inner join usdm_prod_hier as uph
				on uph.prod_key = ucf.asst_prod_hier_key 
			inner join assoc_dim as ad
				on ad.src_prsn_hist_gen_id = ucf.owner_bdge_hist_id_at_crt 
		where 1=1
				and scc.fisc_yr_rltv between -2 and 0
				and (
					lower (uph.prod_bu_type) in ('enterprise solution group pbu', 'infrastructure solutions pbu')
				or lower(ad.bus_rptg_grp_nm) in ('scheduling and account services','commercial enterprise services', 'infrastructure solutions group', 
				 		'high end storage', 'commercial shared services', 'large business', 'large enterprise', 'technical account management')
				)
				and lower (ucf.usdm_case_type) in ('technical support' , 'incident')
				and lower (ucf.CASE_REC_TYPE) not in ('care_case_read_only', 'care', 'accountbasedcase')--, 'internal_case','internal_case_readonly')
				and lower (ucf.int_case_rec_type_cd) in ('external case')
				and ucf.quick_case_flg = 0
		group by 1
)
distributed randomly
;
create table tmp_tbl_ani_6208_wc_case as ( 
		select distinct 
					cc.case_wid ,
					cc.case_nbr ,
					cc.case_crt_dts ,
					cc.sfdc_case_id ,
					cc.sfdc_case_nbr ,
					cc.case_stat ,
					cc.rptg_case_chnl ,
					cc.asst_id ,
					cc.case_ranks ,
					cc.origin_nm ,
					cc.asst_prod_hier_key ,
					cc.asst_unified_iso_ctry_cd ,
					cc.crt_by_bdge_hist_id ,
					cc.owner_bdge_hist_id_at_crt ,
					--use flags to identify, the telco and asset and asu in every case. use the counts to get the actual volumes of assets and telco
					case when tel.telco_flg = 1 then 'Y' else 'N' end as telco_flg ,
					sum ( cc.dial_home_flg ) as dial_home_flg ,
					sum ( cc.case_created_count ) as case_created_count ,
					sum ( cmp.case_complete_count_owner ) as case_complete_count_owner ,
--					sum ( case when cc.case_ranks is null then ast.asset_count 
--								when cc.case_ranks  = 1 then ast.asset_count
--								else null
--						end ) as asset_count ,
--					sum ( case when cc.case_ranks is null then ast.asu_flg --this line is not needed because i am not looking at assets with no cases, 
--								when cc.case_ranks = 1 then ast.asu_flg 
--								else null
--						end ) as asu_count ,
					sum ( case when cc.case_ranks is null then tel.telco_flg
								when cc.case_ranks = 1 then tel.telco_flg
								else null
						end ) as telco_count ,
					sum ( ka.kcs_attached_count ) as kcs_attached_count ,
					sum ( ka.kcs_solved_count ) as kcs_solved_count ,
					sum ( gf.guided_flow_count ) as guided_flow_count
		from tmp_tbl_ani_6208_wc_tcase as cc
			left join tmp_tbl_ani_6208_wc_ast as ast
					on ast.src_cust_prod_id = cc.src_cust_prod_id
			left join tmp_tbl_ani_6208_wc_telco as tel
				on tel.asst_id = cc.asst_id
				and cc.case_crt_dts between tel.cntrct_strt_dtsz and tel.cntrct_end_dtsz
				and tel.row_rank = 1
			left join tmp_tbl_ani_6208_wc_kcs as ka
				on ka.case_id = cc.sfdc_case_id
				and ka.atc_ranks = 1
			left join tmp_tbl_ani_6208_wc_gf as gf 
				on gf.case_id = cc.sfdc_case_id
			left join tmp_tbl_ani_6208_wc_ccmplt as cmp
				on cmp.case_wid = cc.case_wid
		where 1=1
			and cc.case_wid is not null
--			and lower(cc.CASE_REC_TYPE) not in ('care_case_read_only', 'care', 'accountbasedcase', 'internal case')
--			and lower (cc.int_case_rec_type_cd) in ('external case')
--			and lower(cc.rptg_case_chnl) not in ('dosd')
		group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
) 
distributed by (case_wid)
;
drop table if exists tmp_tbl_ani_6208_wc_ast ;
drop table if exists tmp_tbl_ani_6208_wc_telco ;
drop table if exists tmp_tbl_ani_6208_wc_tcase;
drop table if exists tmp_tbl_ani_6208_wc_kcs;
drop table if exists tmp_tbl_ani_6208_wc_gf;
create table tmp_tbl_ani_6208_wc_parts as (
	select distinct
			part.wo_wid ,
--			part.parts_rank_by_cost_per_wo , --this will prevent summarization, unless this is summarized too, something like the string agg
			sum ( case 
						when part.maj_part_flg = 1 and part.maj_itm_qty_ppd_num >= 5 then 1
						else 0
					end		
			) as mmpd_flg_5 ,
			sum ( case 	
						when part.maj_part_flg = 1 and part.maj_itm_qty_ppd_num = 1 then 1 --this is wrong this wont summarize according to the WO, this has to be done later in the WO table.
						else 0
					end		
			) as mpd_parts_single ,
			sum ( case 	
						when part.maj_part_flg = 1 and part.maj_itm_qty_ppd_num >= 2 then part.itm_qty --this is wrong this wont summarize according to the WO, this has to be done later in the WO table.
						else 0
					end		
			) as mmpd_count ,
			max ( case 	
						when part.maj_part_flg = 1 and part.maj_itm_qty_ppd_num >= 2 then 1 --this is wrong this wont summarize according to the WO, this has to be done later in the WO table.
						else 0
					end		
			) as mmpd_flg ,
			SUM ( part.maj_part_flg ) as maj_prt_count_num , -- based on part number, not the quantity, if there are 10 memory of 1 part num then it will flag as 1 if there are 10 memory of 10 part numbers then it will flag as 10
			max ( case when part.maj_part_flg >= 1 then 1 else 0 end ) as maj_prt_flg_den , -- (mpd denom) only flags the wo which has major parts could be multi or single
			SUM ( case
					when (upper ( gc.comdty_nm ) in ('MOTHERBOARD') or upper ( part.itm_comdty_desc ) in ('MOTHERBOARD')) and part.itm_qty > 0
					then part.itm_qty
					else 0
				end ) as mb_prt_count_num ,	
			max ( case			
					when (upper ( gc.comdty_nm ) in ('MOTHERBOARD') or upper ( part.itm_comdty_desc ) in ('MOTHERBOARD')) and part.itm_qty > 0
					then 1
					else 0
				end ) as mb_prt_flg_den ,
			sum ( case when part.maj_part_flg >= 1 then part.itm_qty else 0 end ) as mpd_num_qty , --(major parts quantity) also functions as major parts quantity total, not just part based
			MAX ( case when part.maj_part_flg >= 1 then 1 else 0 end ) as mpd_denom_flg ,
			MAX ( case when part.itm_qty >=1 then 1 else 0 end ) as ppd_denom_flg ,
--			string_agg (distinct part.itm_nbr||'-'||coalesce (gc.comdty_nm, part.itm_comdty_desc, 'NO_DESC') || '(' || part.itm_qty || ')'  ,'|' ) as comdty_name ,
--			string_agg(distinct part.itm_nbr , '|' order by part.itm_nbr asc) as item_nb ,
			sum ( part.itm_qty ) as ppd_num_p_qty ,
			sum ( case when part.maj_part_flg >= 1 then part.itm_qty else 0 end ) as maj_part_num_counts --gives total part count regardless of part number.
	from (
			select distinct
					orf.wo_wid ,
					orf.itm_nbr ,
					orf.itm_comdty_id ,
					orf.maj_part_flg ,
					orf.itm_comdty_desc ,
					orf.part_ord_crt_dts::date as part_ord_crt_dt ,
					orf.itm_qty as itm_qty ,
					orf.part_ord_inv_dts ,
--					case	
--						when (orf.maj_part_flg = 1
--							or lower (orf.itm_comdty_desc) not in ('attach kit', 'documentation'))
--						then row_number() over(partition by orf.wo_wid order by	orf.itm_cost_amt desc)
--						else 0
--					end as parts_rank_by_cost_per_wo ,
--					rank() over(partition by orf.wo_wid, orf.itm_nbr, orf.itm_comdty_id , orf.itm_qty, orf.itm_comdty_desc, orf.maj_part_flg, orf.part_ord_crt_dt order by orf.part_ord_ln_nbr asc) as ranks ,
					sum (case when orf.maj_part_flg >=1 then orf.itm_qty else 0 end) over (partition by orf.wo_wid) as maj_itm_qty_ppd_num
			from usdm_wo_itm_ord_fact as orf
			where 1=1
--				and orf.wo_wid = '00A01C829404A61842C43289DED70259'
--following filters are used in case of part duplication
--				and orf.part_ord_inv_dts is not null
			group by 1,2,3,4,5,6,7,8--,orf.itm_cost_amt, orf.part_ord_ln_nbr,orf.part_ord_crt_dt
	) as part
		left join sp_gbl_comdty as gc
			on gc.comdty_id = part.itm_comdty_id 
		inner JOIN ws_svc_gsa_bi.svc_corp_cldr as cal 
			on cal.cldr_date = part.part_ord_crt_dt
		left join ( select wfu.wo_wid, wfu.asst_prod_hier_key, 
						coalesce (case when wfu.wo_crt_by_bdge_nbr in ('111111', '0', '1') then wfu.wo_owner_bdge_hist_id else wfu.wo_crt_by_bdge_hist_id end, wfu.wo_owner_bdge_hist_id ) as wo_crt_by_bdge_hist_id 
					from usdm_wo_fact as wfu ) as uwf
			on uwf.wo_wid = part.wo_wid
		left join ws_svc_gsa_bi.usdm_prod_hier uph 
			on uph.prod_key = uwf.asst_prod_hier_key
		left join assoc_dim as ad 
			on ad.src_prsn_hist_gen_id = uwf.wo_crt_by_bdge_hist_id
	WHERE 1=1
			and cal.fisc_yr_rltv between -2 and 0
			and cal.fisc_qtr_rltv <= 0
			and cal.fisc_week_rltv <= 0
			and (
				lower (uph.prod_bu_type) in ('enterprise solution group pbu', 'infrastructure solutions pbu')
			or lower(ad.bus_rptg_grp_nm) in ('scheduling and account services','commercial enterprise services', 'infrastructure solutions group', 
					'high end storage', 'commercial shared services', 'large business', 'large enterprise', 'technical account management')
			)
--			and part.wo_wid = 'F136EC2EA53831D3E39944CBC8B3E110'--'C62380968F724538FD4259D5D8284971'
				--following filters are used in case of part duplication
			-- and ranks = 1
			-- and part.itm_qty >= 1
	group by part.wo_wid--,part.maj_part_flg,part.itm_qty,part.maj_itm_qty_ppd_num
--	having SUM ( case
--					when upper ( part.itm_comdty_desc ) in ('MOTHERBOARD') and part.maj_part_flg >= 1
--					then 1 
--					else 0
--				end ) > 1
)
distributed by (wo_wid)
;
--create table tmp_tbl_ani_6208_wc_mdr as (
--
--select distinct
--
--from usdm_wo_mdr_fact as md
--	inner join usdm_wo_fact as wf
--		on wf.wo_wid = md.wo_wid 
--	inner join svc_corp_cldr as scc
--		on scc.cldr_date = md.wo_crt_utc_dts ::date
--	inner join usdm_prod_hier as uph
--		on uph.prod_key = wf.asst_prod_hier_key 
--where 1=1
--	and 
--
--
--)
create table tmp_tbl_ani_6208_wc_rdr as (
select distinct
	mf.wo_wid ,
	mf.wo_crt_utc_dts ,
	cr.repeat_wo_nbr ,
	cr.repeat_tm_gap_secnd ,
	cr.secnd_repeat_wo_nbr ,
	cr.secnd_repeat_tm_gap_secnd ,
	cr.gcc_rd_parnt_wo_nbr ,
	cr.gcc_crt_wo_seq_nbr ,
	sum ( mf.tech_drct_flg ) as tech_drct_flg ,
	sum ( mf.bulk_flg ) as bulk_flg ,
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
	sum ( mf.mdr_qualify_flg ) as mdr_qualify_count , --whether WO qualifies for MDR
	sum ( mf.mdr_dspch_flg ) as mdr_count ,  -- whether WO is an MDR WO
	sum ( mf.mdr_lbr_flg ) as mrd_lbr_flg -- whether WO is an MDR labour WO
FROM usdm_wo_mdr_fact as mf
	inner join ( select wfu.wo_wid, wfu.asst_prod_hier_key, wfu.wo_crt_utc_dts, 
						coalesce (case when wfu.wo_crt_by_bdge_nbr in ('111111', '0', '1') then wfu.wo_owner_bdge_hist_id else wfu.wo_crt_by_bdge_hist_id end, wfu.wo_owner_bdge_hist_id ) as wo_crt_by_bdge_hist_id 
					from usdm_wo_fact as wfu ) as wf
		on wf.wo_wid = mf.wo_wid 
	INNER JOIN svc_corp_cldr as scc 
		on scc.cldr_date = wf.wo_crt_utc_dts :: date
	INNER JOIN usdm_prod_hier as uph
		on uph.prod_key = wf.asst_prod_hier_key
	left join usdm_wo_cust_rdr_fact as cr
		on cr.wo_wid = mf.wo_wid 
	left join ws_svc_gsa_bi.assoc_dim as ad 
		on ad.src_prsn_hist_gen_id = wf.wo_crt_by_bdge_hist_id
WHERE 1=1
	and scc.fisc_yr_rltv between -2 and 0
	and scc.fisc_qtr_rltv <= 0
	and scc.fisc_week_rltv <= 0
	and (
		lower (uph.prod_bu_type) in ('enterprise solution group pbu', 'infrastructure solutions pbu')
	or lower(ad.bus_rptg_grp_nm) in ('scheduling and account services','commercial enterprise services', 'infrastructure solutions group', 
			'high end storage', 'commercial shared services', 'large business', 'large enterprise', 'technical account management')
	)
	and mf.mdr_dspch_flg >= 1
group by 1,2,3,4,5,6,7,8
order by 1 desc
)
distributed by (wo_wid)
;
create table tmp_tbl_ani_6208_wc_wo as (
select distinct
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
uwf.crt_prcs ,
case when upper(uwf.crt_prcs) in ('RPA') then 1 else 0 end as rpa_wo ,
swd.appv_criteria_met_desc ,
swd.appv_rsn_desc ,
swd.appv_stat_val ,
coalesce (case when uwf.wo_crt_by_bdge_nbr in ('111111', '0', '1') then uwf.wo_owner_bdge_hist_id else uwf.wo_crt_by_bdge_hist_id end, uwf.wo_owner_bdge_hist_id ) as wo_crt_by_bdge_hist_id ,
case when uwf.wo_crt_by_bdge_nbr = uwf.wo_apprvd_bdge_nbr then 
	case when uwf.wo_apprvd_bdge_nbr in ('111111', '0', '1') then uwf.wo_owner_bdge_hist_id 
		else uwf.wo_apprvd_bdge_hist_id end
	when uwf.wo_apprvd_bdge_nbr <> uwf.wo_crt_by_bdge_nbr and uwf.wo_apprvd_bdge_nbr in ('111111', '0', '1') and uwf.wo_crt_by_bdge_nbr is null then uwf.wo_owner_bdge_hist_id 
	else uwf.wo_apprvd_bdge_hist_id end as wo_apprvd_bdge_hist_id ,
uwf.asst_id ,
row_number() over ( partition by uwf.case_wid order by uwf.wo_crt_utc_dts asc ) as wo_ranks ,
sum ( case when uwf.wo_wid is not null then 1 else 0 end ) as wo_count
from usdm_wo_fact as uwf 
	INNER JOIN svc_corp_cldr as scc 
		on scc.cldr_date = uwf.wo_crt_utc_dts :: date
	INNER JOIN usdm_prod_hier as uph
		on uph.prod_key = uwf.asst_prod_hier_key 
	left join ws_svc_gsa_bi.assoc_dim ad 
		on ad.src_prsn_hist_gen_id = uwf.wo_crt_by_bdge_hist_id
	left join sfdc_wo_dtl as swd
		on swd.sfdc_wo_id = uwf.sfdc_wo_id 
		and swd.wo_bu_id = uwf.wo_bu_id 
	left join tmp_tbl_ani_6208_wc_case as cc 
		on cc.case_wid = uwf.case_wid 
where 1=1
	and scc.fisc_yr_rltv between -2 and 0
	and scc.fisc_qtr_rltv <= 0
	and scc.fisc_week_rltv <= 0
	and (
		lower (uph.prod_bu_type) in ('enterprise solution group pbu', 'infrastructure solutions pbu')
	or lower(ad.bus_rptg_grp_nm) in ('scheduling and account services','commercial enterprise services', 'infrastructure solutions group', 
			'high end storage', 'commercial shared services', 'large business', 'large enterprise', 'technical account management')
	)
	and cc.case_wid is not null
		--or (per.bus_rptg_catg_id in (5, 69, 70, 2))
--				and lower(per.bus_rptg_grp_nm) in ('infrastructure solutions group','high end storage', 'commercial shared services')))
--	and lower(cc.rptg_case_chnl) not in ('dosd')
group by 1,2,3,4,5,6,7,8,9,10,
		11,12,13,14,15,16,17,18,19,20,21,22
		,uwf.wo_crt_by_bdge_nbr,uwf.wo_apprvd_bdge_nbr,uwf.wo_owner_bdge_hist_id,uwf.wo_apprvd_bdge_hist_id,uwf.asst_id  
)
distributed by ( wo_wid )
;
drop table if exists tbl_ani_6208_wc_comb;
create table tbl_ani_6208_wc_comb as (
with parts_cte as (
	select distinct
					pd.wo_wid ,
					sum ( case when pd.maj_part_num_counts >= 5 and pd.maj_prt_flg_den = 1 then pd.ppd_num_p_qty else 0 end ) as mmpd_5_count ,--over ( partition by wo.wo_wid order by wo.wo_crt_utc_dts) as mmpd_5_count ,
					sum ( pd.mpd_num_qty ) as mpd_num_qty ,
					sum ( pd.mpd_denom_flg ) as mpd_denom_flg ,
					sum ( pd.ppd_denom_flg ) as ppd_denom_flg ,
					sum ( pd.ppd_num_p_qty ) as ppd_num_p_qty ,
					sum ( pd.maj_part_num_counts ) as maj_part_num_counts ,
					sum ( pd.maj_prt_flg_den ) as maj_prt_flg_den ,
					sum ( pd.mb_prt_count_num ) as mb_prt_count_num ,
					sum ( pd.mb_prt_flg_den ) as mb_prt_flg_den ,
					sum ( pd.mmpd_count ) as mmpd_count ,
					sum ( pd.mmpd_flg ) as mmpd_flg 
	from tmp_tbl_ani_6208_wc_parts as pd 
		left join tmp_tbl_ani_6208_wc_wo as wo
			on wo.wo_wid = pd.wo_wid
	group by 1
)
select distinct
	--keys
	wo.asst_unified_iso_ctry_cd ,
	wo.asst_prod_hier_key ,
	wo.wo_crt_utc_dts ,
	wo.wo_apprvd_bdge_hist_id ,
	wo.wo_crt_by_bdge_hist_id ,
	wo.case_wid ,
	wo.wo_wid ,
	wo.sfdc_wo_id ,
	--other
	wo.wo_nbr ,
	wo.dps_type ,
	wo.call_type ,
	wo.wo_type ,
	wo.svc_type ,
	wo.svc_opt ,
	wo.svc_opt_hrs ,
	wo.curr_stat ,
	wo.appv_stat_val , 
	wo.appv_rsn_desc ,
	wo.appv_criteria_met_desc ,
	wo.crt_prcs ,
	wo.wo_ranks ,
	sum (wo.rpa_wo) as rpa_wo_count ,
	sum (wo.wo_count) as wo_count ,
	sum (case when md.mdr_count >= 1 then md.tech_drct_flg else null end ) as tech_drct_flg ,
	sum (case when md.mdr_count >= 1 then md.bulk_flg else null end ) as bulk_flg ,
	sum (case when md.mdr_count >= 1 then md.rd_null_asset_flg else null end ) as rd_null_asset_flg ,
	sum (case when md.mdr_count >= 1 then md.rd_dummy_asset_flg else null end ) as rd_dummy_asset_flg ,
	-- sum (case when md.mdr_count >= 1 then md.rd_pre_qualify_flg else null end ) as rd_pre_qualify_flg ,
	-- sum (case when md.mdr_count >= 1 then md.rd_gcc_crt_wo_flg else null end ) as rd_gcc_crt_wo_flg ,
	-- sum (case when md.mdr_count >= 1 then md.rd_gcc_reissue_flg else null end ) as rd_gcc_reissue_flg ,
	-- sum (case when md.mdr_count >= 1 then md.rd_gcc_ship_cost_flg else null end ) as rd_gcc_ship_cost_flg ,
	-- sum (case when md.mdr_count >= 1 then md.rd_ship_cost_flg else null end ) as rd_ship_cost_flg ,
	-- sum (case when md.mdr_count >= 1 then md.rd_lbr_cost_flg else null end ) as rd_lbr_cost_flg ,
	sum (case when md.mdr_count >= 1 then md.rd_onsite_diags_dps_flg else null end ) as rd_onsite_diags_dps_flg ,
	sum (case when md.mdr_count >= 1 then md.rd_onsite_diags_lbr_flg else null end ) as rd_onsite_diags_lbr_flg ,
	sum (case when ( md.mdr_count >= 1 and md.rd_pre_qualify_flg >= 1 ) then md.repeat_num else null end ) as repeat_num ,
	sum (case when ( md.mdr_count >= 1 and md.rd_pre_qualify_flg >= 1 ) then md.qualify_denom else null end ) as qualify_denom ,
	sum (case when ( md.mdr_count >= 1 and md.rd_pre_qualify_flg >= 1 ) then md.rd_case_rd_qualify_denom else null end ) as rd_case_rd_qualify_denom ,
	sum (md.mdr_qualify_count) as mdr_qualify_count ,
	sum (md.mdr_count) as mdr_count ,
	sum (md.mrd_lbr_flg) as mrd_lbr_flg ,
	sum (prt.mmpd_5_count) as mmpd_5_count ,
	sum (prt.mmpd_count) as mmpd_count ,
	sum (prt.mmpd_flg) as mmpd_flg ,
	sum (prt.mb_prt_count_num) as mb_prt_count_num ,
	sum (prt.mb_prt_flg_den) as mb_prt_flg_den ,
--	sum (prt.maj_part_num_counts) as maj_part_num_counts ,
--	sum (prt.maj_prt_flg_den) as maj_prt_flg_den ,
	sum (prt.mpd_num_qty) as mpd_num_qty ,
	sum (prt.mpd_denom_flg) as mpd_denom_flg ,
	sum (prt.ppd_num_p_qty) as ppd_num_p_qty ,
	sum (prt.ppd_denom_flg) as ppd_denom_flg 
from tmp_tbl_ani_6208_wc_wo as wo
	left join tmp_tbl_ani_6208_wc_rdr as md
		on md.wo_wid = wo.wo_wid
	left join parts_cte as prt
		on prt.wo_wid = wo.wo_wid
	inner join svc_corp_cldr as scc
		on scc.cldr_date = wo.wo_crt_utc_dts::date
where 1=1
	and scc.fisc_yr_rltv between -2 and 0
group by 1,2,3,4,5,6,7,8,9
,10,11,12,13,14,15,16,17,18,19
,20,21
)
distributed by (wo_wid)
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
						else pers.bus_secnd_mgr_last_nm || ', ' || pers.bus_secnd_mgr_frst_nm
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
				select distinct
					per.assoc_bdge_nbr ,
					per.updated_order ,
					per.ROBOTIC_USER
				from
					(
					select
						distinct ad.assoc_bdge_nbr ,
						case
							when (ad.bus_rptg_dept_nm in ('Robotics')
							or upper(ad.assoc_frst_nm) in ('RUI')) or 
							upper(ad.assoc_ntwk_login_nm) like 'RUI%' then 1
							else 0
						end robotic_user1 ,
						case
							when lower(sud.BOT_FLG) = 'y'
							or lower(sud.FIN_SUB_QUEUE_NM) in ('robotics')
							or lower(sud.VNDR_DESC) in ('robotic user id')
							or lower(ad.bus_rptg_team_cd) in ('robotic process auto')
							or lower(ad.bus_rptg_team_nm) in ('robotic process automation queue') then 1 
							else 0
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
					per.ROBOTIC_USER = 1
					and per.updated_order = 1 /*end of robotic user*/
		)
		select distinct
					pera.src_prsn_hist_gen_id ,
					pera.assoc_full_nm ,
					pera.assoc_ptnr_nm ,
					pera.assoc_ptnr_osp_flg ,
					pera.assoc_loc_nm ,
					pera.bus_rptg_catg_nm ,
					pera.bus_rptg_dept_nm ,
					pera.bus_rptg_func_nm ,
					pera.bus_rptg_grp_nm ,
					pera.bus_rptg_queue_nm ,
					pera.assoc_bdge_nbr ,
					pera.bus_rptg_rgn_nm ,
					pera.bus_rptg_subrgn_nm ,
					pera.bus_rptg_subgrp_nm ,
					pera.bus_rptg_team_nm ,
					pera.manager_first ,
					pera.manager_second ,
					pera.manager_l3 ,
					pera.manager_l4 ,
					pera.manager_l5 ,
					pera.robotic_user
		from (
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
					coalesce(rob.ROBOTIC_USER, 0) as robotic_user 
					from ws_svc_gsa_bi.assoc_dim ad2
					left join gdpr_man_data gmd
						on gmd.person_hist_id = ad2.src_prsn_hist_gen_id
					left join robotics rob
						on rob.assoc_bdge_nbr = ad2.assoc_bdge_nbr
					inner join tmp_tbl_ani_6208_wc_wo as wo  
						on ad2.src_prsn_hist_gen_id = wo.wo_crt_by_bdge_hist_id
					where
						1 = 1
			--			and ad2.bus_rptg_catg_id in (5, 69, 70, 2)
			--			and lower(ad2.bus_rptg_grp_nm) in ('unkn','scheduling and account services','commercial enterprise services', 'infrastructure solutions group',
			--				'high end storage', 'commercial shared services', 'large business', 'large enterprise', 'technical account management')
					group by 1,2,3,4,5,6,7,8,9,10,
					11,12,13,14,15,16,17,18,19,20,21
					union all
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
					coalesce(rob.ROBOTIC_USER, 0) as robotic_user 
					from ws_svc_gsa_bi.assoc_dim ad2
					left join gdpr_man_data gmd
						on gmd.person_hist_id = ad2.src_prsn_hist_gen_id
					left join robotics rob
						on rob.assoc_bdge_nbr = ad2.assoc_bdge_nbr
					inner join tmp_tbl_ani_6208_wc_wo as wo  
						on ad2.src_prsn_hist_gen_id = wo.wo_apprvd_bdge_hist_id
					where
						1 = 1
			--			and ad2.bus_rptg_catg_id in (5, 69, 70, 2)
			--			and lower(ad2.bus_rptg_grp_nm) in ('unkn','scheduling and account services','commercial enterprise services', 'infrastructure solutions group',
			--				'high end storage', 'commercial shared services', 'large business', 'large enterprise', 'technical account management')
					group by 1,2,3,4,5,6,7,8,9,10,
					11,12,13,14,15,16,17,18,19,20,21
		) as pera
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
			uph.svc_prod_group ,
			uph.prod_bu_type ,
			uph.prod_grp_desc ,
			uph.svc_prod_lob_group ,
			uph.rptg_prod_type ,
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
	/* in order to have counts visible from the case side then we have to limit it to only 1st WO or when WO is null so that the case counts and attributes associated to cases are right.
	 * otherwise it is best to use a boolean like y or n to indicate if the attribute exists on the WO from teh case perspective like dial home for counts it has to be for 1st wo and null wo
	 * but to know if wo is dial home then make it a boolean y or n, check kcs_attached and kcs_attached_count for the difference.
	 * */
	cal.fiscal_week ,
	cal.week_lag ,
	cal.fiscal_quarter ,
	cal.quarter_lag ,
	cal.fiscal_year ,
	cal.year_lag ,
	--person
	per.assoc_full_nm ,
	per.manager_first ,
	per.manager_second ,
	per.bus_rptg_dept_nm ,
	per.robotic_user ,
	per.bus_rptg_rgn_nm ,
	per.bus_rptg_subrgn_nm ,
	per.bus_rptg_grp_nm ,
	per.manager_l5 ,
	per.assoc_bdge_nbr as outlier_key,
	--customer
	cus.region_name ,
	cus.subregion_name ,
	cus.area_name ,
	cus.ctry_nm ,
	--prod
	uph.global_grouping ,
	uph.global_product,
	uph.global_lob,
	uph.global_brand,
	uph.global_generation,
	uph.prod_grp_desc as product_group , 
	wf.asst_prod_hier_key ,
	--WO STUFF
	wf.cust_lcl_chnl_cd ,
	wf.asst_unified_iso_ctry_cd ,
	wf.wo_crt_by_bdge_hist_id ,
	wf.wo_apprvd_bdge_hist_id ,
	wf.asst_id ,
	wf.wo_crt_utc_dts ,
	wf.wo_wid ,
	wf.dps_type ,
	wf.wo_type ,
	wf.svc_type ,	
	wf.svc_opt ,
	wf.svc_opt_hrs ,
	wf.wo_nbr ,
	wf.curr_stat as wo_status,
	cf.case_wid ,
	cf.case_nbr ,
	cf.case_stat as case_status,
	cf.sfdc_case_nbr ,
	cf.rptg_case_chnl as case_channel,
	cf.origin_nm as origin_name ,
	case when cf.kcs_attached_count >= 1 then 'Y' else 'N' end as kcs_attached ,
	case when cf.kcs_solved_count >= 1 then 'Y' else 'N' end as kcs_solved ,
	case when cf.guided_flow_count >= 1 then 'Y' else 'N' end as guided_flow ,
	wf.appv_criteria_met_desc as approval_criteria_met,
	wf.appv_rsn_desc as approval_reason ,
	wf.appv_stat_val as approval_status , 
	wf.crt_prcs ,
	cr.repeat_wo_nbr ,
	cr.repeat_tm_gap_secnd ,
	cr.secnd_repeat_wo_nbr ,
	cr.secnd_repeat_tm_gap_secnd ,
	cr.gcc_rd_parnt_wo_nbr ,
	cr.gcc_crt_wo_seq_nbr ,
	--tmp_tbl_ani_6208_wc_parts 
	sum ( wf.rpa_wo ) as rpa_wo_count ,
	max ( cf.telco_flg ) as telco_flg ,
	sum ( case when cr.mdr_count >= 1 then prt.mpd_num_qty else null end ) as mpd_num ,
	sum ( case when cr.mdr_count >= 1 then prt.maj_prt_flg_den else null end ) as maj_part_count ,
	sum ( case when cr.mdr_count >= 1 then prt.mpd_denom_flg else null end ) as mpd_denom ,
	sum ( case when cr.mdr_count >= 1 then prt.ppd_denom_flg else null end ) as ppd_denom ,
	sum ( case when cr.mdr_count >= 1 then prt.ppd_num_p_qty else null end ) as ppd_num ,
	sum ( case when cr.mdr_count >= 1 then prt.mb_prt_flg_den else null end ) as mb_flg ,
	sum ( case when cr.mdr_count >= 1 then prt.mb_prt_count_num else null end ) as mb_count ,
	sum ( case when cr.mdr_count >= 1 then prt.mmpd_flg_5 else null end ) over ( partition by wf.wo_wid order by wf.wo_crt_utc_dts) as mmpd_5_flg ,
	sum ( case when cr.mdr_count >= 1 then prt.mmpd_flg else null end ) over ( partition by wf.wo_wid order by wf.wo_crt_utc_dts) as mmpd_flg ,
--	sum ( case when prt.mpd_num > 1 and prt.mpd_denom = 1 then prt.part_quantity else 0 end ) over ( partition by wf.wo_wid order by wf.wo_crt_utc_dts) as mmpd_count ,
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
	sum ( case when cr.mdr_count >= 1 then cr.repeat_num else null end ) as repeat_num ,
	sum ( case when cr.mdr_count >= 1 then cr.qualify_denom else null end ) as qualify_denom ,
	sum ( cr.mdr_count ) as mdr_count ,
	sum ( wf.wo_count ) as wo_count ,
	sum ( case when wf.wo_ranks is null then cf.case_created_count
				when wf.wo_ranks = 1 then cf.case_created_count
				else null 
			end ) as case_created_count ,
	sum ( case when wf.wo_ranks is null then cf.kcs_attached_count
				when wf.wo_ranks = 1 then cf.kcs_attached_count
				else null 
			end ) as kcs_attached_count ,
	sum ( case when wf.wo_ranks is null then cf.kcs_solved_count
				when wf.wo_ranks = 1 then cf.kcs_solved_count
				else null 
			end ) as kcs_solved_count ,
	sum ( case when wf.wo_ranks is null then cf.guided_flow_count
				when wf.wo_ranks = 1 then cf.guided_flow_count
				else null 
			end ) as guided_flow_count ,
	sum ( cf.dial_home_flg ) as dial_home_flg 
--	sum ( case when ( cf.case_ranks is null or cf.case_ranks = 1 ) then cf.asset_count else null end ) as assets_wcases_count 
FROM tmp_tbl_ani_6208_wc_wo as wf
	INNER join tbl_ani_6208_wc_cal as cal
		on cal.calendar_date = wf.wo_crt_utc_dts::date
	INNER JOIN tbl_ani_6208_wc_prod as uph
		on uph.prod_key = wf.asst_prod_hier_key
	left JOIN tmp_tbl_ani_6208_wc_case as cf
		on cf.case_wid = wf.case_wid
	left join tmp_tbl_ani_6208_wc_rdr as cr
		on cr.wo_wid = wf.wo_wid
	left join tbl_ani_6208_wc_pers as per
		on per.src_prsn_hist_gen_id = wf.wo_crt_by_bdge_hist_id
	left join tmp_tbl_ani_6208_wc_parts as prt 
		on prt.wo_wid = wf.wo_wid
	left join tbl_ani_6208_wc_cust as cus
		on cus.iso_alpha2_cd = wf.asst_unified_iso_ctry_cd
--	left join tmp_tbl_ani_6208_wc_ast as ast
--		on wf.asst_id  = ast.asst_id
--	left join tmp_tbl_ani_6208_wc_telco as tel
--		on tel.asst_id = cf.asst_id 
--		and cf.case_crt_dts between tel.cntrct_strt_dtsz and tel.cntrct_end_dtsz 
--		and tel.row_rank = 1
WHERE 1=1
--	and cal.year_lag between -2 and 0
--	and mmpd_flg_5 = 1
--	and lower (per.manager_l5) = 'brown, dexter s.'
--	and cal.fisc_week_rltv = -1 -- and 0
--	and (lower(uph.prod_bu_type) in ('enterprise solution group pbu', 'infrastructure solutions pbu')
--		or lower(per.bus_rptg_grp_nm) in ('scheduling and account services','commercial enterprise services', 'infrastructure solutions group', 
--				'high end storage', 'commercial shared services', 'large business', 'large enterprise', 'technical account management'))
--	and cr.mdr_count = 1
--	and lower(cf.rptg_case_chnl) not in ('dosd')
--	and wf.asst_id = 'CK297600741'
group by 1,2,3,4,5,6,7,8,9
,10,11,12,13,14,15,16,17,18,19
,20,21,22,23,24,25,26,27,28,29
,30,31,32,33,34,35,36,37,38,39
,40,41,42,43,44,45,46,47,48,49
,50,51,52,53,54,55,56,57,58,59
,60
,prt.ppd_num_p_qty,wf.wo_crt_utc_dts,prt.mpd_num_qty,prt.mpd_denom_flg,cr.mdr_count,prt.mmpd_flg_5,prt.mmpd_flg
order by 26 asc
)
distributed by ( wo_wid ,  case_nbr )
;
create table tbl_ani_6208_wc_pbi as (
	select distinct
			--join keys
			wo.asst_prod_hier_key ,--prod - from prod table
			wo.asst_unified_iso_ctry_cd ,--cust - from cust table
			wo.wo_crt_utc_dts::date as calendar_key ,--calendar - from calendar table
			wo.wo_crt_by_bdge_hist_id as wo_owner ,--pers - from pers table
			wo.wo_apprvd_bdge_hist_id as wo_approver ,--pers approver - from pers table
			--ent
			--others - case
			cd.rptg_case_chnl as case_channel,
			cd.case_stat as case_status,
			--others - wo
			wo.dps_type ,
			wo.call_type ,
			wo.curr_stat ,
			wo.wo_type ,
			wo.svc_type ,
			wo.crt_prcs ,
			sum ( wo.rpa_wo ) as rpa_wo_count ,
			max ( cd.telco_flg ) as telco_flag ,
			sum ( rd.mdr_count ) as mdr_count ,
			sum ( rd.mdr_qualify_count ) as mdr_qualify_count ,
			sum ( rd.rd_pre_qualify_flg ) as rd_pre_qualify_flg ,
			sum ( rd.qualify_denom ) as rd_qualify_denom ,
			sum ( rd.repeat_num ) as rd_num ,
			sum ( rd.rd_case_rd_qualify_denom ) as rd_case_rd_qualify_denom ,
			sum ( pd.mmpd_flg_5 ) as mmpd_flg_5 ,
			sum ( pd.mpd_parts_single ) as mpd_parts_single ,
			sum ( pd.mmpd_count ) as mmpd_count ,
			sum ( pd.mmpd_flg ) as mmpd_flg ,
			sum ( pd.maj_prt_flg_den ) as maj_prt_flg_den ,
			sum ( pd.mb_prt_flg_den ) as mb_prt_flg_den ,
			sum ( pd.mb_prt_count_num ) as mb_prt_count_num ,
			sum ( pd.mpd_num_qty ) as mpd_num_qty ,
			sum ( pd.mpd_denom_flg ) as mpd_denom_flg ,
			sum ( pd.ppd_num_p_qty ) as ppd_num_p_qty ,
			sum ( pd.ppd_denom_flg ) as ppd_denom_flg ,
			sum ( cd.dial_home_flg ) as dial_home_flg ,
			sum ( case when wo.wo_ranks is null then cd.case_created_count
						when wo.wo_ranks = 1 then cd.case_created_count
						else null 
					end ) as case_created_count ,
--			sum ( cd.asset_count ) as asset_count , --asu count will be in a seperate table.
			sum ( cd.telco_count ) as telco_count 
	from tmp_tbl_ani_6208_wc_case  as cd 
		left join tmp_tbl_ani_6208_wc_wo as wo
			on cd.case_wid = wo.case_wid 
		left join tmp_tbl_ani_6208_wc_rdr as rd
			on rd.wo_wid = wo.wo_wid 
		left join tmp_tbl_ani_6208_wc_parts as pd 
			on pd.wo_wid = rd.wo_wid
		inner JOIN tbl_ani_6208_wc_prod as uph
			on uph.prod_key = cd.asst_prod_hier_key
	where 1=1
--		and rd.mdr_count = 1
		and lower(uph.prod_bu_type) in ('enterprise solution group pbu', 'infrastructure solutions pbu')
--		and lower(cd.rptg_case_chnl) not in ('dosd')
	group by 
			--join keys
			wo.asst_prod_hier_key ,
			wo.asst_unified_iso_ctry_cd ,
			wo.wo_crt_utc_dts ,
			wo.wo_crt_by_bdge_hist_id ,
			wo.wo_apprvd_bdge_hist_id ,
			--calendar
			--prod
			--pers
			--cust
			--ent
			--others - case
			cd.rptg_case_chnl ,
			cd.case_stat ,
			--others - wo
			wo.dps_type ,
			wo.call_type ,
			wo.curr_stat ,
			wo.wo_type ,
			wo.svc_type ,
			wo.crt_prcs 
)
distributed randomly
;
--drop table if exists tmp_tbl_ani_6208_wc_case ;
--drop table if exists tmp_tbl_ani_6208_wc_parts ;
--drop table if exists tmp_tbl_ani_6208_wc_rdr ;
--drop table if exists tmp_tbl_ani_6208_wc_wo ;
drop table if exists tbl_ani_6208_wc_smry ;
create table tbl_ani_6208_wc_smry as (
		select distinct
			--calendar
			scc.fisc_week_val as fiscal_weeks ,
			scc.fisc_qtr_val as fiscal_quarters ,
			scc.fisc_yr_val as fiscal_years ,
			scc.fisc_week_rltv as week_relative ,
			scc.fisc_qtr_rltv as quarter_relative , 
			scc.cldr_date as calendar_date ,
			--product
			uph.global_grouping as global_product_grouping ,
			uph.global_product as global_product_product ,
			uph.global_lob as global_product_lob,
			uph.global_brand as global_product_brand ,	
			--person
			per.assoc_ptnr_nm as partner_name ,
			per.bus_rptg_dept_nm as wo_owner_reporting_department,
			per.bus_rptg_grp_nm as wo_owner_reporting_group ,
			per.bus_rptg_rgn_nm as wo_owner_reporting_region,
			per.manager_first as wo_owner_manager_first ,
			per.manager_second as wo_owner_manager_second ,
			per.assoc_full_nm as wo_owner_name ,
			per.robotic_user ,
			per.manager_l5 as manager_5 ,
			tra.crt_prcs ,
			sum ( case when lower (per.assoc_ptnr_osp_flg) = 'y' then 1 else 0 end ) as assoc_ptnr_osp_flg ,
			--work 
			sum ( tra.rpa_wo_count ) as rpa_wo_count ,
			sum ( tra.mpd_num ) as mpd_num ,
			sum ( tra.mpd_denom ) as mpd_denom ,
			sum ( tra.ppd_denom ) as ppd_denom ,
			sum ( tra.ppd_num ) as ppd_num ,
			sum ( tra.mb_flg ) as mobo_flg ,
			sum ( tra.mmpd_5_flg ) as mmpd_5_flg ,
			sum ( tra.mmpd_flg ) as mmpd_flg ,
			sum ( tra.rd_tech_drct_flg ) as rd_tech_drct_flg ,
			sum ( tra.rd_case_rd_qualify_denom ) as rd_case_rd_qualify_denom ,
			sum ( tra.repeat_num ) as repeat_num ,
			sum ( tra.qualify_denom ) as qualify_denom ,
			sum ( tra.mdr_count ) as mdr_count ,
			sum ( tra.wo_count ) as wo_count ,
			sum ( tra.case_created_count ) as case_created_count ,
			sum ( tra.dial_home_flg ) as dial_home_flg
		from tbl_ani_6208_wc_trans as tra
			inner join svc_corp_cldr as scc
				on scc.cldr_date = tra.wo_crt_utc_dts::date
			left JOIN tbl_ani_6208_wc_prod as uph
				on uph.prod_key = tra.asst_prod_hier_key
			left join tbl_ani_6208_wc_cust as cust
				on cust.iso_alpha2_cd = tra.asst_unified_iso_ctry_cd
			left join tbl_ani_6208_wc_pers as per
				on per.src_prsn_hist_gen_id = tra.wo_crt_by_bdge_hist_id
		where 1=1
			and scc.fisc_qtr_rltv between -5 and 0
--			and scc.fisc_week_rltv between -30 and 0
--			and tra.mdr_count = 1
			and (lower(uph.prod_bu_type) in ('enterprise solution group pbu', 'infrastructure solutions pbu')
				or lower(per.bus_rptg_grp_nm) in ('scheduling and account services','commercial enterprise services', 'infrastructure solutions group', 
				'high end storage', 'commercial shared services', 'large business', 'large enterprise', 'technical account management'))
		--	and tra.case_nbr is not null
		--	and dial_home_flg = 1
		--	and wo_nbr = '433331806'
		group by 1,2,3,4,5,6,7,8,9,10
		,11,12,13,14,15,16,17,18,19,20
		--,21,22,23--,24,25--,26,27,28,29,30
)
distributed randomly 
;