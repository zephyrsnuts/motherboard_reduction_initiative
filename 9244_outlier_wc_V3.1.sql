/*
		this is the query being used.

*/
-- -- create the outlier table
-- -- uncomment only if changes otherwise leave as is.
-- drop table if exists tbl_ani_9244_outliers;
-- CREATE TABLE tbl_ani_9244_outliers AS (
-- 	with outlier_cte as (
-- 			select distinct
-- 					ad.assoc_bdge_nbr 
-- 					,case when lower(ad.assoc_ntwk_login_nm)  in (
-- 																	'adam_rios2'
-- ,'ledell_wilson'
-- ,'arjit_mishra'
-- ,'manoj_sharma15'
-- ,'raviteja_vellanki'
-- ,'stephen_karber'
-- ,'hyun_c_shin'
-- ,'siddalinga_shivayoga'
-- ,'maurice_nirmal_s'
-- ,'kunal_saha'
-- ,'rajprabhu_s'
-- ,'aditya_joshi3'
-- ,'natividad_munoz'
-- ,'christopher_m_may'
-- ,'santhosh_g2'
-- ,'arya_roy'
-- ,'brian_arredondo'
-- ,'aniket_meshram'
-- ,'alexander_albright'
-- ,'deepak_kp_kumar'
-- ,'alan_chan1'
-- ,'sourjeet_parichha'
-- ,'william_c_chapman'
-- ,'nikhil_naik1'
-- ,'clayton_reininger'
-- ,'chris_davola'
-- ,'xavier_jimenez'
-- ,'shakeel_ahmed_k_r'
-- ,'adalberto_santa_cruz'
-- ,'alecksander_oliveira'
-- ,'alejandro_sesti'
-- ,'ana_paula_dossi'
-- ,'anderson_cardoso1'
-- ,'anderson_nogueira'
-- ,'andre_dresch'
-- ,'andre_nunes'
-- ,'ariel_carvajal'
-- ,'bellodi_bellodi'
-- ,'c_a_rodriguez'
-- ,'caio_roberto_santos'
-- ,'carlos_cordoba'
-- ,'carmelo_bustos'
-- ,'cassiano_bet'
-- ,'claiton_avila'
-- ,'cristiano_fonseca'
-- ,'d_keller'
-- ,'e_garcia'
-- ,'eduardo_herrera1'
-- ,'eduardo_lopes'
-- ,'fabricio_eloi'
-- ,'felipe_gomes2'
-- ,'francine_rosa'
-- ,'francis_carvalho'
-- ,'germano_assuncao'
-- ,'giancarlo_alvarez'
-- ,'gladstony_freitas'
-- ,'gregory_compere'
-- ,'guilherme_jasniewicz'
-- ,'gustavo_vargas'
-- ,'henry_silva'
-- ,'hermes_menegaz'
-- ,'icaro_d_farias'
-- ,'imarys_riquelme'
-- ,'ivan_jaureguizar'
-- ,'j_chaves'
-- ,'jamith_galvis'
-- ,'jeferson_m_souza'
-- ,'jefferson_dorneles'
-- ,'joao_f_rosa'
-- ,'joao_sturm_junior'
-- ,'juan_rodriguez_l'
-- ,'julissa_garrido'
-- ,'kevin_arauz'
-- ,'leonardo_moraes'
-- ,'lucas_martins_campos'
-- ,'lucas_melo3'
-- ,'m_siervo'
-- ,'manuela_dalcorso'
-- ,'marcelo_atencio'
-- ,'marcelo_marcellino'
-- ,'mariel_rodriguez'
-- ,'mateus_jost'
-- ,'michelle_phillips1'
-- ,'murilo_aguilar'
-- ,'n_mendoza'
-- ,'norvell_brown'
-- ,'pedro_dutra'
-- ,'renan_borges'
-- ,'rosilin_urriola'
-- ,'ruben_famania'
-- ,'stanley_s'
-- ,'v_z_lam'
-- ,'victor_carneiro'
-- ,'vinicius_vagner_salo'
-- ,'wagner_alves'
-- ,'y_mendoza'
-- ,'mustapha_el_moudia'
-- ,'ali_abouelhassan'
-- ,'oleg_merzlikin'
-- ,'jamal_aitali'
-- ,'richard_vermaas'
-- ,'hamza_amezian'
-- ,'apurv_p'
-- ,'mohamed_borja'
-- ,'hamza_el_mamouni'
-- ,'paul_mccormack'
-- ,'mohamed_karaoui'
-- ,'jawad_rehaoui'
-- ,'raunak_sharma'
-- ,'asthaa_pokhriyal'
-- ,'faisalkhan_pathan'
-- ,'grigore_dabija'
-- ,'k_jadhav'
-- ,'salaheddine_bousserr'
-- ,'robert_mcculloch'
-- ,'kavya_dudam'
-- ,'lahcen_khmassi'
-- ,'youssef_ouizzane'
-- ,'harshal_rathod'
-- ,'rachid_ait_hemmou'
-- ,'mohammaduwais_mulla'
-- ,'thobias_nilsson'
-- ,'john_harrold'
-- ,'jc_morassi'
-- ,'tomas_strycek'
-- ,'youssef_souhail'
-- ,'aqib_sayed'
-- ,'samir_benmeziane'
-- ,'attila_katona'
-- ,'youness_benbrahim'
-- ,'jerzy_gajewicz'
-- ,'amine_ait_hemmou'
-- ,'fatih_uzun'
-- ,'guillermo_de_escuder'
-- ,'andre_carvalho'
-- ,'vikram_t_m'
-- ,'sylvain_arbonnier'
-- ,'riad_chfali'
-- ,'andrea_fiore'
-- ,'eetu_siltanen'
-- ,'gopinath_jayaram'
-- ,'rajjesh_gaikwad'
-- ,'prathima_b_r'
-- ,'jaffer_akbar'
-- ,'jyotirmoy_mallik'
-- ,'akshay_d1'
-- ,'vijaykumar_rajendran'
-- ,'shreyank_shanbhag'
-- ,'mohan_rao_k'
-- ,'varun_bhalla1'
-- ,'mohammed_edris'
-- ,'satish_p1'
-- ,'chandini_a'
-- ,'anil_kumar_sk'
-- ,'d_p'
-- ,'raghavendra_hs'
-- ,'chetan_kumar_h_s'
-- ,'m_b_g'
-- ,'abdul_tousif'
-- ,'kumar_kumar'
-- ,'satendra_pal'
-- ,'mizuki_ishibashi'
-- ,'racy_takayama'
-- ,'masashi_nonaka'
-- ,'baharuddin_binomar'
-- ,'haruka_azuma'
-- ,'x_l'
-- ,'yongle_li'
-- ,'wenhui_liu1'
-- ,'junbin_lin'
-- ,'zhipeng_yu'
-- ,'max_l'
-- ,'anwei_xia'
-- ,'wenqiang_guo'
-- ,'zhiye_ge'
-- ,'daniella_xie'
-- ,'jiazi_l'
-- ,'donglin_chang'
-- ,'hien_tran_the'
-- ,'duong_le'
-- ,'bui_minh_quyen'
-- ,'qartika_eslyna_othma'
-- ,'khairi_yaacob'
-- ,'ann_eltanal'
-- ,'andri_pratama'
-- ,'tinh_lexuan'
-- ,'zakaria_hamidon'
-- ,'careewan_phetthong'
-- ,'phumiphath_rongsawat'
-- ,'ahmad_zariss_mansor'
-- ,'sangtheetha_chandras'
-- ,'sithaartha_baarathy'
-- ,'somruetat_saeueng'
-- ,'sreejesh_k'
-- ,'venkatesh_ps'
-- ,'iyyanar_janardhanan'
-- ,'mohan_m_r'
-- ,'arun_nelson_dalmeida'
-- ,'sutanu_chakraborty'
-- ,'akash_shankarmurthy'
-- ,'santhosh_b_a'
-- ,'rakshith_ballal'
-- ,'nilesh_n_naik'
-- ,'abhijith_nath'
-- ,'libin_mathew'
-- ,'marcel_francis'
-- ,'shaik_mashkoor'
-- ,'sohan_philip_saldanh'
-- ,'usha_g1'
-- ,'syed_umer'
-- ,'gurunath_r'
-- ,'parvez_ahmed'
-- ,'nelson_gregory_ferna'
-- ,'sadhasivam_r'
-- ,'vinod_babu'
-- ,'dhanu_vijay'
-- ,'dipak_kumar_prasad'
-- ,'purushothaman_m'
-- ,'shilpa_a'
-- ,'priyanka_saha2'
-- ,'madhuri_bommidi'
-- ,'nazia_s'
-- ,'h_raj'
-- ,'anjaneya_alapati'
-- ,'roshan_fernandes'
-- ,'jai_shekhar'
-- ,'bhanu_thakur'
-- ,'sridhar_naik'
-- ,'mohar_chakraborty'
-- ,'prairna_malla'
-- ,'hitanshi_jadav'
-- 					) then 'y' else null end as mb_outlier
-- 					,case when lower (ad.assoc_ntwk_login_nm)  in (
-- 'chin_haw_khoh'
-- ,'darren_george_woodwo'
-- ,'diviyashini_raja'
-- ,'faiz_athirah_hazri'
-- ,'gary_jiang'
-- ,'jing_cao1'
-- ,'nor_affadzillah'
-- ,'ragulan_balakrishnan'
-- ,'ridhwan_merican'
-- ,'shaojun_cai'
-- ,'songyun_chen'
-- ,'tee_chun_tan'
-- ,'yuan_li1'
-- ,'zakhwan_roslee'
-- ,'zulhelmi_zaini'
-- ,'black_jiang'
-- ,'chunyu_zou'
-- ,'joseph_jian1'
-- ,'maokun_fang'
-- ,'qd_h'
-- ,'soil_zhang'
-- ,'chui_lin_leong'
-- ,'jun_sakuma'
-- ,'keisuke_shima'
-- ,'kyuyoul_park'
-- ,'masahiro_hidaka'
-- ,'misako_hosoki'
-- ,'tohru_sasaki'
-- ,'yosuke_katsuta'
-- ,'yukiko_kihara'
-- ,'yusuke_fukuyoshi'
-- 																			) then 'y' else null end as mmpd_outlier
-- 			FROM assoc_dim as ad
-- 			where 1=1
-- 		)
-- 		select distinct
-- 		assoc_bdge_nbr ,
-- 		mb_outlier,
-- 		mmpd_outlier		
-- 		from outlier_cte as ou
-- 		where ou.mb_outlier is not null
-- 		or ou.mmpd_outlier is not null
-- )
-- distributed by (assoc_bdge_nbr)
-- ;
drop table if exists tbl_ani_9244_mb_redux;
create table tbl_ani_9244_mb_redux as (
with case_cte as 
	(
	select distinct
		/*
			do not add WO table to this, it will begin duplicating since it will have to be a left join.
			and cas.case_nbr = '164454143'
		*/
		cas.case_wid ,
		cas.case_stat as case_status ,
		cas.rptg_case_chnl as case_channel ,
		cas.origin_nm as origin_name ,
		cas.case_crt_dts ,
		cas.case_nbr ,
		cas.acct_nm ,
		--customer
		cus.region_name as c_cust_region ,
		cus.ctry_nm as c_country ,
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
			on scc.cldr_date = cas.case_crt_dts::date
		inner join tbl_ani_6208_wc_prod as uph
			on uph.prod_key = cas.asst_prod_hier_key
		left join tbl_ani_6208_wc_pers as ad
			on ad.src_prsn_hist_gen_id = cas.owner_bdge_hist_id_at_crt
		left join tbl_ani_6208_wc_cust as cus
			on cus.iso_alpha2_cd = cas.asst_unified_iso_ctry_cd
	where 1=1
		and upper(uph.prod_grp_desc) in ('POWEREDGE SERVERS')
		and (
			scc.week_lag between -5 and 0
			-- or 
			-- wo.case_wid = cas.case_wid
		)
	group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18
	),
wo_cte as 
	(
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
			tra.wo_ranks ,
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
			case when (
						tra.mdr_count >= 1 
						and ad.assoc_full_nm <> ad2.assoc_full_nm
					)
				then 1 
				else 0 
			end as mdr_not_auto_approved ,
			case when (
						tra.mdr_count >= 1 
						and ad2.assoc_full_nm is null
				)
			then 1
			else 0 
			end as mdr_no_review , 
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
			on scc.cldr_date = tra.wo_crt_utc_dts::date
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
		and scc.week_lag between -5 and 0
	group by 1,2,3,4,5,6,7,8,9,10
		,11,12,13,14,15,16,17,18,19
		,20,21,22,23,24,25,26,27,28,29
		,30,31,32,33,34,35,36,37,38,39
		,40,41,42,43,44,45,46,47,48,49
		,50,51,52,53,54,55,56,57
	),
outlier_cte as 
		(
				select distinct
					tra.wo_wid ,
					ol.mb_outlier ,
					ol.mmpd_outlier ,
					case 
						when lower ( tra.approval_criteria_met ) like '%dispatch reduction initiative%' then 1
						else null
					end as criteria_met_dri ,
					case 
						when lower ( tra.approval_criteria_met ) like '%motherboard reduction initiative%' then 1
						else null
					end as criteria_met_mri ,
					case
						when tra.approval_criteria_met is null then 1
						else 0
					end as no_review_criteria ,
					-- case when 
					-- 	lower(ol.mb_outlier) in ('y')
					-- 	or lower(ol.mmpd_outlier) in ('y')
					-- 	then 'y'
					-- 	else null
					-- end as outlier_flg ,
					-- sum (case when lower ( tra.approval_criteria_met ) like '%motherboard reduction initiative%'
					-- 		and lower ( cc.kcs_attached_flg ) in ('y')
					-- 		and tra.mb_prt_flg_den > 0
					-- 		and tra.mdr_count > 0
					-- 		and lower ( ol.mb_outlier ) = 'y'
					-- 	then 1 else 0
					-- end ) as mdr_count_kcs_attached_mb_outlier ,
					-- sum (case when lower ( tra.approval_criteria_met ) like '%motherboard reduction initiative%'
					-- 		and lower ( cc.kcs_attached_flg ) in ('y') 
					-- 		and tra.mmpd_flg >= 1
					-- 		and tra.mdr_count > 0
					-- 		and lower ( ol.mmpd_outlier ) = 'y'
					-- 	then 1 else 0
					-- end ) as mdr_count_kcs_attached_mmpd_outlier ,
					-- sum (case when lower ( tra.approval_criteria_met ) like '%motherboard reduction initiative%'
					-- 		and lower ( cc.kcs_solved_flg ) in ('y')
					-- 		and tra.mb_prt_flg_den > 0
					-- 		and tra.mdr_count > 0
					-- 		and lower ( ol.mb_outlier ) = 'y'
					-- 	then 1 else 0
					-- end ) as mdr_count_kcs_solved_mb_outlier ,
					-- sum (case when lower ( tra.approval_criteria_met ) like '%motherboard reduction initiative%'
					-- 		and lower ( cc.kcs_solved_flg ) in ('y')
					-- 		and tra.mmpd_flg >= 0
					-- 		and tra.mdr_count > 0
					-- 		and lower ( ol.mmpd_outlier ) = 'y'
					-- 	then 1 else 0
					-- end ) as mdr_count_kcs_solved_mmpd_outlier ,
					-- sum (case when lower ( tra.approval_criteria_met ) like '%motherboard reduction initiative%'
					-- 		and lower ( cc.guided_flow_flg ) in ('y')
					-- 		and tra.mb_prt_flg_den > 0
					-- 		and tra.mdr_count > 0
					-- 		and lower ( ol.mb_outlier ) = 'y'
					-- 	then 1 else 0
					-- end ) as mdr_count_guided_flow_mb_outlier ,
					-- sum (case when lower ( tra.approval_criteria_met ) like '%motherboard reduction initiative%'
					-- 		and lower ( cc.guided_flow_flg ) in ('y')
					-- 		and tra.mmpd_flg >= 0
					-- 		and tra.mdr_count > 0
					-- 		and lower ( ol.mmpd_outlier ) = 'y'
					-- 	then 1 else 0
					-- end ) as mdr_count_guided_flow_mmpd_outlier 
					-- sum (case when lower ( tra.approval_criteria_met ) like '%motherboard reduction initiative%' then 1 else 0 end) as mb_initiative_reviewed_counts
				from tbl_ani_9244_outliers as ol
					inner join wo_cte as tra
						on ol.assoc_bdge_nbr = tra.outlier_key
					left join case_cte as cc
						on cc.case_wid = tra.case_wid
				group by 1,2,3,4
		)
-- c_count_cte as (
-- 		select distinct
-- 				-- cc.case_crt_dts::date as case_created_date ,
-- 				scc.fiscal_week ,
-- 				cc.asst_prod_hier_key ,
-- 				cc.asst_unified_iso_ctry_cd ,
-- 				cc.owner_bdge_hist_id_at_crt ,
-- 				sum (case when cc.case_wid is not null then 1 else 0 end) as c_case_count
-- 		from tmp_tbl_ani_6208_wc_case as cc
-- 			inner join tbl_ani_6208_wc_prod as uph
-- 				on uph.prod_key = cc.asst_prod_hier_key
-- 			inner join tbl_ani_6208_wc_cal as scc
-- 				on scc.cldr_date = cc.case_crt_dts::date
-- 		where 1=1
-- 				-- and scc.fisc_yr_rltv between -2 and 0
-- 				-- and scc.fisc_qtr_rltv <= 0
-- 				-- and scc.fisc_week_rltv <= 0
-- 				-- and lower(cc.usdm_case_type) in ('technical support' , 'incident')
-- 				-- and lower(cc.CASE_REC_TYPE) not in ('care_case_read_only', 'care', 'accountbasedcase')--, 'internal_case','internal_case_readonly')
-- 				-- and (
-- 					-- lower(uph.prod_bu_type) in ('enterprise solution group pbu', 'infrastructure solutions pbu')
-- 				-- or lower(per.bus_rptg_grp_nm) in ('scheduling and account services','commercial enterprise services', 'infrastructure solutions group', 
-- 													-- 'high end storage', 'commercial shared services', 'large business', 'large enterprise', 'technical account management')
-- 					-- )
-- 				-- and cc.quick_case_flg <> 1
-- 				-- and lower (cc.int_case_rec_type_cd) in ('external case')
-- 				-- and lower(cc.rptg_case_chnl) not in ('dosd', 'bulk')		
-- 		group by 1,2,3,4
-- )
select distinct
		--cal - case
		cas.case_fiscal_week ,
		cas.case_week_lag ,
		cas.case_fiscal_quarter ,
		cas.case_quarter_lag ,
		cas.case_fiscal_year ,
		cas.case_year_lag ,
		--cal - wo
		wo.fiscal_week ,	
		wo.week_lag ,
		wo.fiscal_quarter ,
		wo.quarter_lag ,
		wo.fiscal_year ,
		wo.year_lag ,
		wo.wo_crt_utc_dts::date ,
		--cust - wo
		wo.customer_region as customer_region ,
		wo.customer_subregion_name as customer_subregion ,
		wo.area_name as area_name ,
		wo.ctry_nm as country ,
		--cust - case
		cas.c_cust_region ,
		cas.c_country ,
		--prod - wo
		wo.global_grouping ,
		wo.global_product,
		wo.global_lob,
		wo.global_brand,
		wo.global_generation,
		wo.product_group , 
		wo.product_family , 
		--person - created - wo
		wo.crt_assoc_full_nm ,
		wo.crt_manager_first ,
		wo.crt_manager_second ,
		wo.crt_bus_rptg_dept_nm ,
		wo.crt_robotic_user ,
		wo.crt_bus_rptg_rgn_nm ,
		wo.crt_bus_rptg_subrgn_nm ,
		wo.crt_manager_l5 ,
		--approver
		wo.appr_assoc_full_nm ,
		wo.appr_manager_first ,
		wo.appr_manager_second ,
		wo.appr_bus_rptg_dept_nm ,
		wo.appr_robotic_user ,
		wo.appr_bus_rptg_rgn_nm ,
		wo.appr_bus_rptg_subrgn_nm ,
		wo.appr_manager_l5 ,
		wo.mdr_not_auto_approved ,
		wo.mdr_no_review ,
		--wo
		wo.approval_criteria_met ,
		wo.approval_reason ,
		wo.approval_status ,
		wo.wo_nbr ,
		wo.dps_type ,
		wo.call_type ,
		wo.wo_type ,
		wo.svc_type ,
		wo.svc_opt ,
		wo.svc_opt_hrs ,
		wo.wo_status ,
		wo.create_process ,
		--case
		cas.case_status,
		cas.case_channel,
		cas.origin_name ,
		cas.case_nbr ,
		cas.acct_nm ,
		--flags
		cas.kcs_attached_flg ,
		cas.kcs_solved_flg ,
		cas.guided_flow_flg ,
		ol.mb_outlier ,
		ol.mmpd_outlier ,
		ol.outlier_flg ,
		sum ( case
			when mdr_not_auto_approved = 0 then 1
			when mdr_no_review = 1 then 1
			else 0
		end ) as mdr_not_reviewed_agent ,
		--sums
		-- sum ( ol.mdr_count_kcs_attached_mb_outlier ) as mdr_count_kcs_attached_mb_outlier  ,
		-- sum ( ol.mdr_count_kcs_attached_mmpd_outlier ) as mdr_count_kcs_attached_mmpd_outlier  ,
		-- sum ( ol.mdr_count_kcs_solved_mb_outlier ) as mdr_count_kcs_solved_mb_outlier  ,
		-- sum ( ol.mdr_count_kcs_solved_mmpd_outlier ) as mdr_count_kcs_solved_mmpd_outlier  ,
		-- sum ( ol.mdr_count_guided_flow_mb_outlier ) as mdr_count_guided_flow_mb_outlier  ,
		-- sum ( ol.mdr_count_guided_flow_mmpd_outlier ) as mdr_count_guided_flow_mmpd_outlier  ,
		sum ( ol.no_review_criteria ) as no_review_criteria_count ,
		sum ( case when wo.wo_ranks > 1 then 0 else cas.case_created_count end ) as case_created_count  ,
		sum ( case when wo.wo_ranks > 1 then 0 else cas.case_complete_count_owner end ) as case_complete_count_owner  ,
		sum ( cas.kcs_attached_count ) as kcs_attached_count  ,
		sum ( cas.kcs_solved_count ) as kcs_solved_count  ,
		sum ( cas.guided_flow_count ) as guided_flow_count  ,
		sum ( cas.dial_home_flg ) as dial_home_flg  ,
		sum ( wo.wo_count ) as wo_count  ,
		sum ( wo.rpa_wo_count ) as rpa_wo_count  ,
		sum ( wo.bulk_flg ) as bulk_flg  ,
		sum ( wo.rd_num ) as rd_num  ,
		sum ( wo.rd_den ) as rd_den  ,
		sum ( wo.rd_case_rd_qualify_denom ) as rd_case_rd_qualify_denom  ,
		sum ( wo.mdr_count ) as mdr_count  ,
		sum ( wo.mmpd_count ) as mmpd_count  ,
		sum ( wo.mmpd_flg ) as mmpd_flg  ,
		sum ( wo.mb_prt_count_num ) as mb_prt_count_num  ,
		sum ( wo.mb_prt_flg_den ) as mb_prt_flg_den  ,
		sum ( wo.mpd_num ) as mpd_num  ,
		sum ( wo.mpd_denom ) as mpd_denom  ,
		sum ( wo.ppd_num_p_qty ) as ppd_num_p_qty  ,
		sum ( wo.ppd_denom_flg ) as ppd_denom_flg  ,
		sum ( case when  )
		-- sum ( case when wo.wo_ranks > 1 then 0 else cco.c_case_count end ) as c_case_count
from case_cte as cas
	left join wo_cte as wo
		on wo.case_wid = cas.case_wid
	left join outlier_cte as ol
		on wo.wo_wid = ol.wo_wid 
	-- left join c_count_cte as cco
	-- 	on cco.fiscal_week = wo.fiscal_week
	-- 		and cco.asst_prod_hier_key = wo.asst_prod_hier_key
	-- 		and cco.asst_unified_iso_ctry_cd = wo.asst_unified_iso_ctry_cd
	-- 		and cco.owner_bdge_hist_id_at_crt = wo.wo_crt_by_bdge_hist_id
where 1=1
	and cas.case_week_lag >= -5
group by 1,2,3,4,5,6,7,8,9,10
	,11,12,13,14,15,16,17,18,19
	,20,21,22,23,24,25,26,27,28,29
	,30,31,32,33,34,35,36,37,38,39
	,40,41,42,43,44,45,46,47,48,49
	,50,51,52,53,54,55,56,57,58,59
	,60,61,62,63,64,65,66,67
)
distributed randomly
;
-- /*

-- 		summary table


-- */
-- -- drop table if exists tbl_ani_9244_mb_smry;
-- -- create table tbl_ani_9244_mb_smry as (
-- drop table if exists tbl_ani_9244_mb_smry;
-- create table tbl_ani_9244_mb_smry as (
-- with case_cte as 
-- 	(
-- 	select distinct
-- 		cas.case_wid ,
-- 		cas.case_stat as case_status ,
-- 		cas.rptg_case_chnl as case_channel ,
-- 		cas.origin_nm as origin_name ,
-- 		cas.case_crt_dts ,
-- 		cas.case_nbr ,
-- 		--calendar
-- 		scc.fiscal_week as case_fiscal_week ,	
-- 		scc.week_lag as case_week_lag ,
-- 		scc.fiscal_quarter as case_fiscal_quarter ,
-- 		scc.quarter_lag as case_quarter_lag ,
-- 		scc.fiscal_year as case_fiscal_year ,
-- 		scc.year_lag as case_year_lag ,
-- 		case when cas.kcs_attached_count >= 1 then 'Y' else null end as kcs_attached_flg ,
-- 		case when cas.kcs_solved_count >= 1 then 'Y' else null end as kcs_solved_flg ,
-- 		case when cas.guided_flow_count >= 1 then 'Y' else null end as guided_flow_flg ,
-- 		sum ( cas.case_created_count ) as case_created_count , --COWR = wo count / case created count owner
-- 		sum ( cas.case_complete_count_owner ) as case_complete_count_owner ,
-- 		sum ( cas.kcs_attached_count ) as kcs_attached_count ,
-- 		sum ( cas.kcs_solved_count ) as kcs_solved_count ,
-- 		sum ( cas.guided_flow_count ) as guided_flow_count ,
-- 		sum ( cas.dial_home_flg ) as dial_home_flg 
-- 	from tmp_tbl_ani_6208_wc_case as cas
-- 		inner join tbl_ani_6208_wc_cal as scc
-- 			on scc.cldr_date = cas.case_crt_dts::date
-- 		inner join tbl_ani_6208_wc_prod as uph
-- 			on uph.prod_key = cas.asst_prod_hier_key
-- 		left join tbl_ani_6208_wc_pers as ad
-- 			on ad.src_prsn_hist_gen_id = cas.owner_bdge_hist_id_at_crt
-- 	where 1=1
-- 		and upper(uph.prod_grp_desc) in ('POWEREDGE SERVERS')
-- 		and scc.week_lag between -3 and 0
-- 	group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
-- 	),
-- wo_cte as 
-- 	(
-- 	SELECT DISTINCT
-- 			--keys
-- 			tra.wo_wid ,
-- 			tra.case_wid ,
-- 			ad.assoc_bdge_nbr as outlier_key ,
-- 			tra.wo_crt_utc_dts::date as wo_crt_utc_dts ,
-- 			tra.asst_unified_iso_ctry_cd ,
-- 			tra.asst_prod_hier_key ,
-- 			tra.wo_apprvd_bdge_hist_id ,
-- 			tra.wo_crt_by_bdge_hist_id ,
-- 			tra.sfdc_wo_id ,
-- 			--others
-- 			tra.appv_criteria_met_desc::varchar(150) as approval_criteria_met ,
-- 			tra.appv_rsn_desc as approval_reason ,
-- 			tra.appv_stat_val as approval_status ,
-- 			tra.wo_nbr ,
-- 			tra.dps_type ,
-- 			tra.call_type ,
-- 			tra.wo_type ,
-- 			tra.svc_type ,	
-- 			tra.svc_opt ,
-- 			tra.svc_opt_hrs ,
-- 			tra.curr_stat as wo_status ,
-- 			tra.crt_prcs as create_process ,
-- 			--dimensions
-- 			--prod
-- 			uph.global_grouping ,
-- 			uph.global_product,
-- 			uph.global_lob,
-- 			uph.global_brand,
-- 			uph.global_generation,
-- 			uph.prod_grp_desc as product_group , 
-- 			uph.product_family as product_family , 
-- 			--per
-- 			ad.assoc_full_nm as crt_assoc_full_nm ,
-- 			ad.manager_first as crt_manager_first ,
-- 			ad.manager_second as crt_manager_second ,
-- 			ad.bus_rptg_dept_nm as crt_bus_rptg_dept_nm ,
-- 			ad.robotic_user as crt_robotic_user ,
-- 			ad.bus_rptg_rgn_nm as crt_bus_rptg_rgn_nm ,
-- 			ad.bus_rptg_subrgn_nm as crt_bus_rptg_subrgn_nm ,
-- 			ad.manager_l5 as crt_manager_l5 ,
-- 			--approver
-- 			ad2.assoc_full_nm as appr_assoc_full_nm ,
-- 			ad2.manager_first as appr_manager_first ,
-- 			ad2.manager_second as appr_manager_second ,
-- 			ad2.bus_rptg_dept_nm as appr_bus_rptg_dept_nm ,
-- 			ad2.robotic_user as appr_robotic_user ,
-- 			ad2.bus_rptg_rgn_nm as appr_bus_rptg_rgn_nm ,
-- 			ad2.bus_rptg_subrgn_nm as appr_bus_rptg_subrgn_nm ,
-- 			ad2.manager_l5 as appr_manager_l5 ,
-- 			--cust
-- 			cus.region_name as customer_region ,
-- 			cus.subregion_name as customer_subregion_name ,
-- 			cus.area_name as area_name ,
-- 			cus.ctry_nm as ctry_nm ,
-- 			--calendar
-- 			scc.fiscal_week ,	
-- 			scc.week_lag ,
-- 			scc.fiscal_quarter ,
-- 			scc.quarter_lag ,
-- 			scc.fiscal_year ,
-- 			scc.year_lag ,
-- 			sum ( tra.wo_count ) as wo_count ,
-- 			sum ( tra.rpa_wo_count ) as rpa_wo_count ,
-- 			sum ( tra.bulk_flg ) as bulk_flg ,
-- 			sum ( tra.repeat_num ) as rd_num ,
-- 			sum ( tra.qualify_denom ) as rd_den ,
-- 			sum ( tra.rd_case_rd_qualify_denom ) as rd_case_rd_qualify_denom ,
-- 			sum ( tra.mdr_count ) as mdr_count ,
-- 			sum ( tra.mmpd_count ) as mmpd_count ,
-- 			sum ( tra.mmpd_flg ) as mmpd_flg ,
-- 			sum ( tra.mb_prt_count_num ) as mb_prt_count_num ,
-- 			sum ( tra.mb_prt_flg_den ) as mb_prt_flg_den ,
-- 			sum ( tra.mpd_num_qty ) as mpd_num ,
-- 			sum ( tra.mpd_denom_flg ) as mpd_denom ,
-- 			sum ( tra.ppd_num_p_qty ) as ppd_num_p_qty ,
-- 			sum ( tra.ppd_denom_flg ) as ppd_denom_flg 
-- 	FROM tbl_ani_6208_wc_comb AS tra
-- 		inner join tbl_ani_6208_wc_cal as scc
-- 			on scc.cldr_date = tra.wo_crt_utc_dts::date
-- 		inner join tbl_ani_6208_wc_prod as uph
-- 			on uph.prod_key = tra.asst_prod_hier_key
-- 		left join tbl_ani_6208_wc_pers as ad
-- 			on ad.src_prsn_hist_gen_id = tra.wo_crt_by_bdge_hist_id
-- 		left join tbl_ani_6208_wc_pers as ad2
-- 			on ad2.src_prsn_hist_gen_id = tra.wo_apprvd_bdge_hist_id
-- 		left join tbl_ani_6208_wc_cust as cus
-- 			on cus.iso_alpha2_cd = tra.asst_unified_iso_ctry_cd
-- 	where 1=1
-- 		and upper(uph.prod_grp_desc) in ('POWEREDGE SERVERS')
-- 		and scc.week_lag between -3 and 0
-- 	group by 1,2,3,4,5,6,7,8,9,10
-- 		,11,12,13,14,15,16,17,18,19
-- 		,20,21,22,23,24,25,26,27,28,29
-- 		,30,31,32,33,34,35,36,37,38,39
-- 		,40,41,42,43,44,45,46,47,48,49
-- 		,50,51,52,53,54
-- 	),
-- outlier_cte as 
-- 		(
-- 				select distinct
-- 					tra.wo_wid ,
-- 					ol.mb_outlier ,
-- 					ol.mmpd_outlier ,
-- 					sum (case when lower ( tra.approval_criteria_met ) like '%motherboard reduction initiative%'
-- 							and lower ( cc.kcs_attached_flg ) in ('y')
-- 							and tra.mb_prt_flg_den > 0
-- 							and tra.mdr_count > 0
-- 							and lower ( ol.mb_outlier ) = 'y'
-- 						then 1 else 0
-- 					end ) as mdr_count_kcs_attached_mb_outlier ,
-- 					sum (case when lower ( tra.approval_criteria_met ) like '%motherboard reduction initiative%'
-- 							and lower ( cc.kcs_attached_flg ) in ('y') 
-- 							and tra.mmpd_flg >= 1
-- 							and tra.mdr_count > 0
-- 							and lower ( ol.mmpd_outlier ) = 'y'
-- 						then 1 else 0
-- 					end ) as mdr_count_kcs_attached_mmpd_outlier ,
-- 					sum (case when lower ( tra.approval_criteria_met ) like '%motherboard reduction initiative%'
-- 							and lower ( cc.kcs_solved_flg ) in ('y')
-- 							and tra.mb_prt_flg_den > 0
-- 							and tra.mdr_count > 0
-- 							and lower ( ol.mb_outlier ) = 'y'
-- 						then 1 else 0
-- 					end ) as mdr_count_kcs_solved_mb_outlier ,
-- 					sum (case when lower ( tra.approval_criteria_met ) like '%motherboard reduction initiative%'
-- 							and lower ( cc.kcs_solved_flg ) in ('y')
-- 							and tra.mmpd_flg >= 0
-- 							and tra.mdr_count > 0
-- 							and lower ( ol.mmpd_outlier ) = 'y'
-- 						then 1 else 0
-- 					end ) as mdr_count_kcs_solved_mmpd_outlier ,
-- 					sum (case when lower ( tra.approval_criteria_met ) like '%motherboard reduction initiative%'
-- 							and lower ( cc.guided_flow_flg ) in ('y')
-- 							and tra.mb_prt_flg_den > 0
-- 							and tra.mdr_count > 0
-- 							and lower ( ol.mb_outlier ) = 'y'
-- 						then 1 else 0
-- 					end ) as mdr_count_guided_flow_mb_outlier ,
-- 					sum (case when lower ( tra.approval_criteria_met ) like '%motherboard reduction initiative%'
-- 							and lower ( cc.guided_flow_flg ) in ('y')
-- 							and tra.mmpd_flg >= 0
-- 							and tra.mdr_count > 0
-- 							and lower ( ol.mmpd_outlier ) = 'y'
-- 						then 1 else 0
-- 					end ) as mdr_count_guided_flow_mmpd_outlier 
-- 					-- sum (case when lower ( tra.approval_criteria_met ) like '%motherboard reduction initiative%' then 1 else 0 end) as mb_initiative_reviewed_counts
-- 				from tbl_ani_9244_outliers as ol
-- 					inner join wo_cte as tra
-- 						on ol.assoc_bdge_nbr = tra.outlier_key
-- 					left join case_cte as cc
-- 						on cc.case_wid = tra.case_wid
-- 				group by 1,2,3
-- 		)
-- select distinct
-- 		--cal - case
-- 		cas.case_fiscal_week ,
-- 		cas.case_week_lag ,
-- 		cas.case_fiscal_quarter ,
-- 		cas.case_quarter_lag ,
-- 		cas.case_fiscal_year ,
-- 		cas.case_year_lag ,
-- 		--cal - wo
-- 		-- wo.fiscal_week ,	
-- 		-- wo.week_lag ,
-- 		-- wo.fiscal_quarter ,
-- 		-- wo.quarter_lag ,
-- 		-- wo.fiscal_year ,
-- 		-- wo.year_lag ,
-- 		-- wo.wo_crt_utc_dts ,
-- 		--cust - wo
-- 		wo.customer_region as customer_region ,
-- 		wo.customer_subregion_name as customer_subregion ,
-- 		wo.area_name as area_name ,
-- 		wo.ctry_nm as country ,
-- 		--prod - wo
-- 		wo.global_grouping ,
-- 		wo.global_product,
-- 		wo.global_lob,
-- 		wo.global_brand,
-- 		wo.global_generation,
-- 		wo.product_group , 
-- 		wo.product_family , 
-- 		--person - created - wo
-- 		wo.crt_assoc_full_nm ,
-- 		wo.crt_manager_first ,
-- 		wo.crt_manager_second ,
-- 		wo.crt_bus_rptg_dept_nm ,
-- 		wo.crt_robotic_user ,
-- 		wo.crt_bus_rptg_rgn_nm ,
-- 		wo.crt_bus_rptg_subrgn_nm ,
-- 		wo.crt_manager_l5 ,
-- 		--approver
-- 		wo.appr_assoc_full_nm ,
-- 		wo.appr_manager_first ,
-- 		wo.appr_manager_second ,
-- 		wo.appr_bus_rptg_dept_nm ,
-- 		wo.appr_robotic_user ,
-- 		wo.appr_bus_rptg_rgn_nm ,
-- 		wo.appr_bus_rptg_subrgn_nm ,
-- 		wo.appr_manager_l5 ,
-- 		--wo
-- 		wo.approval_criteria_met ,
-- 		wo.approval_reason ,
-- 		wo.approval_status ,
-- 		wo.wo_nbr ,
-- 		wo.dps_type ,
-- 		wo.call_type ,
-- 		wo.wo_type ,
-- 		wo.svc_type ,
-- 		wo.svc_opt ,
-- 		wo.svc_opt_hrs ,
-- 		wo.wo_status ,
-- 		wo.create_process ,
-- 		--case
-- 		cas.case_status,
-- 		cas.case_channel,
-- 		cas.origin_name ,
-- 		cas.case_nbr ,
-- 		--flags
-- 		cas.kcs_attached_flg ,
-- 		cas.kcs_solved_flg ,
-- 		cas.guided_flow_flg ,
-- 		ol.mb_outlier ,
-- 		ol.mmpd_outlier ,
-- 		--sums
-- 		sum ( ol.mdr_count_kcs_attached_mb_outlier ) as mdr_count_kcs_attached_mb_outlier  ,
-- 		sum ( ol.mdr_count_kcs_attached_mmpd_outlier ) as mdr_count_kcs_attached_mmpd_outlier  ,
-- 		sum ( ol.mdr_count_kcs_solved_mb_outlier ) as mdr_count_kcs_solved_mb_outlier  ,
-- 		sum ( ol.mdr_count_kcs_solved_mmpd_outlier ) as mdr_count_kcs_solved_mmpd_outlier  ,
-- 		sum ( ol.mdr_count_guided_flow_mb_outlier ) as mdr_count_guided_flow_mb_outlier  ,
-- 		sum ( ol.mdr_count_guided_flow_mmpd_outlier ) as mdr_count_guided_flow_mmpd_outlier  ,
-- 		sum ( cas.case_created_count ) as case_created_count  ,
-- 		sum ( cas.case_complete_count_owner ) as case_complete_count_owner  ,
-- 		sum ( cas.kcs_attached_count ) as kcs_attached_count  ,
-- 		sum ( cas.kcs_solved_count ) as kcs_solved_count  ,
-- 		sum ( cas.guided_flow_count ) as guided_flow_count  ,
-- 		sum ( cas.dial_home_flg ) as dial_home_flg  ,
-- 		sum ( wo.wo_count ) as wo_count  ,
-- 		sum ( wo.rpa_wo_count ) as rpa_wo_count  ,
-- 		sum ( wo.bulk_flg ) as bulk_flg  ,
-- 		sum ( wo.rd_num ) as rd_num  ,
-- 		sum ( wo.rd_den ) as rd_den  ,
-- 		sum ( wo.rd_case_rd_qualify_denom ) as rd_case_rd_qualify_denom  ,
-- 		sum ( wo.mdr_count ) as mdr_count  ,
-- 		sum ( wo.mmpd_count ) as mmpd_count  ,
-- 		sum ( wo.mmpd_flg ) as mmpd_flg  ,
-- 		sum ( wo.mb_prt_count_num ) as mb_prt_count_num  ,
-- 		sum ( wo.mb_prt_flg_den ) as mb_prt_flg_den  ,
-- 		sum ( wo.mpd_num ) as mpd_num  ,
-- 		sum ( wo.mpd_denom ) as mpd_denom  ,
-- 		sum ( wo.ppd_num_p_qty ) as ppd_num_p_qty  ,
-- 		sum ( wo.ppd_denom_flg ) as ppd_denom_flg  
-- from case_cte as cas
-- 	left join wo_cte as wo
-- 		on wo.case_wid = cas.case_wid
-- 	left join outlier_cte as ol
-- 		on wo.wo_wid = ol.wo_wid 
-- where 1=1
-- 	and cas.case_week_lag between -3 and 0
-- group by 1,2,3,4,5,6,7,8,9,10
-- 	,11,12,13,14,15,16,17,18,19
-- 	,20,21,22,23,24,25,26,27,28,29
-- 	,30,31,32,33,34,35,36,37,38,39
-- 	,40,41,42,43,44,45,46,47,48,49
-- 	,50,51,52,53,54,55,56,57,58,59,60,61
-- )
-- distributed randomly