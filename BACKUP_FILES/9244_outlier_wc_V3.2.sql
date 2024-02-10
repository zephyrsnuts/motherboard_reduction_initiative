-- create the outlier table
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
select distinct
		--keys
		ain.case_wid ,
		ain.asst_unified_iso_ctry_cd ,
		ain.asst_prod_hier_key ,
		ain.outlier_key ,
		ain.wo_wid ,
		ain.wo_crt_utc_dts ,
		ain.wo_apprvd_bdge_hist_id ,
		ain.wo_crt_by_bdge_hist_id ,
		ain.sfdc_wo_id ,
		--dimensions
		--prod
		ain.global_grouping ,
		ain.global_product,
		ain.global_lob,
		ain.global_brand,
		ain.global_generation,
		ain.product_group , 
		ain.product_family , 
		--per
		ain.crt_assoc_full_nm ,
		ain.crt_manager_first ,
		ain.crt_manager_second ,
		ain.crt_bus_rptg_dept_nm ,
		ain.crt_robotic_user ,
		ain.crt_bus_rptg_rgn_nm ,
		ain.crt_bus_rptg_subrgn_nm ,
		ain.crt_manager_l5 ,
		--approver
		ain.appr_assoc_full_nm ,
		ain.appr_manager_first ,
		ain.appr_manager_second ,
		ain.appr_bus_rptg_dept_nm ,
		ain.appr_robotic_user ,
		ain.appr_bus_rptg_rgn_nm ,
		ain.appr_bus_rptg_subrgn_nm ,
		ain.appr_manager_l5 ,
		--cust
		ain.customer_region ,
		ain.customer_subregion ,
		ain.cust_area ,
		ain.cust_country ,
		--calendar
		ain.fiscal_week ,	
		ain.week_lag ,
		ain.fiscal_quarter ,
		ain.quarter_lag ,
		ain.fiscal_year ,
		ain.year_lag ,
		--case
		ain.case_status ,
		ain.case_channel ,
		ain.origin_name ,
		ain.case_crt_dts ,
		ain.case_nbr ,
		ain.kcs_attached_flg ,
		ain.kcs_solved_flg ,
		ain.guided_flow_flg ,
		--wo
		ain.approval_criteria_met ,
		ain.approval_reason ,
		ain.approval_status ,
		ain.wo_nbr ,
		ain.dps_type ,
		ain.call_type ,
		ain.wo_type ,
		ain.svc_type ,	
		ain.svc_opt ,
		ain.svc_opt_hrs ,
		ain.wo_status ,
		ain.create_process ,
		--sums - case
		sum ( ain.case_created_count ) as case_created_count , --COWR = wo count / case created count owner
		sum ( ain.case_complete_count_owner ) as case_complete_count_owner ,
		sum ( ain.kcs_attached_count ) as kcs_attached_count ,
		sum ( ain.kcs_solved_count ) as kcs_solved_count ,
		sum ( ain.guided_flow_count ) as guided_flow_count ,
		sum ( ain.dial_home_flg ) as dial_home_flg ,
		--sums - WO
		sum ( ain.wo_count ) as wo_count ,
		sum ( ain.rpa_wo_count ) as rpa_wo_count ,
		sum ( ain.bulk_flg ) as bulk_flg ,
		sum ( ain.rd_num ) as rd_num ,
		sum ( ain.rd_den ) as rd_den ,
		sum ( ain.rd_case_rd_qualify_denom ) as rd_case_rd_qualify_denom ,
		sum ( ain.mdr_count ) as mdr_count ,
		sum ( ain.mmpd_count ) as mmpd_count ,
		sum ( ain.mmpd_flg ) as mmpd_flg ,
		sum ( ain.mb_prt_count_num ) as mb_prt_count_num ,
		sum ( ain.mb_prt_flg_den ) as mb_prt_flg_den ,
		sum ( ain.mpd_num ) as mpd_num ,
		sum ( ain.mpd_denom ) as mpd_denom ,
		sum ( ain.ppd_num_p_qty ) as ppd_num_p_qty ,
		sum ( ain.ppd_denom_flg ) as ppd_denom_flg ,
		--sums - Outlier
		sum ( ain.mdr_count_kcs_attached_mb_outlier ) as mdr_count_kcs_attached_mb_outlier  ,
		sum ( ain.mdr_count_kcs_attached_mmpd_outlier ) as mdr_count_kcs_attached_mmpd_outlier  ,
		sum ( ain.mdr_count_kcs_solved_mb_outlier ) as mdr_count_kcs_solved_mb_outlier  ,
		sum ( ain.mdr_count_kcs_solved_mmpd_outlier ) as mdr_count_kcs_solved_mmpd_outlier  ,
		sum ( ain.mdr_count_guided_flow_mb_outlier ) as mdr_count_guided_flow_mb_outlier  ,
		sum ( ain.mdr_count_guided_flow_mmpd_outlier ) as mdr_count_guided_flow_mmpd_outlier 
from (
	select distinct
		--keys
		cas.case_wid ,
		cas.asst_unified_iso_ctry_cd ,
		cas.asst_prod_hier_key ,
		ad.assoc_bdge_nbr as outlier_key ,
		null as wo_wid ,
		null::timestamp as wo_crt_utc_dts ,
		null::int as wo_apprvd_bdge_hist_id ,
		null::int as wo_crt_by_bdge_hist_id ,
		null as sfdc_wo_id ,
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
		null as appr_assoc_full_nm ,
		null as appr_manager_first ,
		null as appr_manager_second ,
		null as appr_bus_rptg_dept_nm ,
		null::int as appr_robotic_user ,
		null as appr_bus_rptg_rgn_nm ,
		null as appr_bus_rptg_subrgn_nm ,
		null as appr_manager_l5 ,
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
		--wo
		null as approval_criteria_met ,
		null as approval_reason ,
		null as approval_status ,
		null as wo_nbr ,
		null as dps_type ,
		null as call_type ,
		null as wo_type ,
		null as svc_type ,	
		null as svc_opt ,
		null as svc_opt_hrs ,
		null as wo_status ,
		null as create_process ,
		--sums - case
		sum ( cas.case_created_count ) as case_created_count , --COWR = wo count / case created count owner
		sum ( cas.case_complete_count_owner ) as case_complete_count_owner ,
		sum ( cas.kcs_attached_count ) as kcs_attached_count ,
		sum ( cas.kcs_solved_count ) as kcs_solved_count ,
		sum ( cas.guided_flow_count ) as guided_flow_count ,
		sum ( cas.dial_home_flg ) as dial_home_flg ,
		--sums - WO
		sum ( null::int ) as wo_count ,
		sum ( null::int ) as rpa_wo_count ,
		sum ( null::int ) as bulk_flg ,
		sum ( null::int ) as rd_num ,
		sum ( null::int ) as rd_den ,
		sum ( null::int ) as rd_case_rd_qualify_denom ,
		sum ( null::int ) as mdr_count ,
		sum ( null::int ) as mmpd_count ,
		sum ( null::int ) as mmpd_flg ,
		sum ( null::int ) as mb_prt_count_num ,
		sum ( null::int ) as mb_prt_flg_den ,
		sum ( null::int ) as mpd_num ,
		sum ( null::int ) as mpd_denom ,
		sum ( null::int ) as ppd_num_p_qty ,
		sum ( null::int ) as ppd_denom_flg ,
		--sums - Outlier
		sum ( null::int ) as mdr_count_kcs_attached_mb_outlier  ,
		sum ( null::int ) as mdr_count_kcs_attached_mmpd_outlier  ,
		sum ( null::int ) as mdr_count_kcs_solved_mb_outlier  ,
		sum ( null::int ) as mdr_count_kcs_solved_mmpd_outlier  ,
		sum ( null::int ) as mdr_count_guided_flow_mb_outlier  ,
		sum ( null::int ) as mdr_count_guided_flow_mmpd_outlier 
	from tmp_tbl_ani_6208_wc_case as cas
		inner join tbl_ani_6208_wc_cal as scc
			on scc.calendar_date = cas.case_crt_dts::date
		inner join tbl_ani_6208_wc_prod as uph
			on uph.prod_key = cas.asst_prod_hier_key
		left join tbl_ani_6208_wc_pers as ad
			on ad.src_prsn_hist_gen_id = cas.owner_bdge_hist_id_at_crt
		left join tbl_ani_6208_wc_cust as cus
			on cus.iso_alpha2_cd = cas.asst_unified_iso_ctry_cd
		left join tbl_ani_6208_wc_comb as wo
			on wo.case_wid = cas.case_wid
			and wo.wo_crt_utc_dts > current_timestamp - interval '3 weeks'
	where 1=1
		and upper(uph.prod_grp_desc) in ('POWEREDGE SERVERS')
		and (
			scc.week_lag between -3 and 0
			-- or
			-- wo.case_wid = cas.case_wid
		)
	group by 1,2,3,4,5,6,7,8,9,10
		,11,12,13,14,15,16,17,18,19
		,20,21,22,23,24,25,26,27,28,29
		,30,31,32,33,34,35,36,37,38,39
		,40,41,42,43,44,45,46,47,48,49
		,50,51,52,53,54,55,56,57,58,59
		,60,61,62
union
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
			--case
			null as case_status ,
			null as case_channel ,
			null as origin_name ,
			null::timestamp as case_crt_dts ,
			null as case_nbr ,
			null as kcs_attached_flg ,
			null as kcs_solved_flg ,
			null as guided_flow_flg ,
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
			--sums - case
			sum ( null::int ) as case_created_count , --COWR = wo count / case created count owner
			sum ( null::int ) as case_complete_count_owner ,
			sum ( null::int ) as kcs_attached_count ,
			sum ( null::int ) as kcs_solved_count ,
			sum ( null::int ) as guided_flow_count ,
			sum ( null::int ) as dial_home_flg ,
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
		and (
			scc.week_lag between -3 and 0
			)
	group by 1,2,3,4,5,6,7,8,9,10
		,11,12,13,14,15,16,17,18,19
		,20,21,22,23,24,25,26,27,28,29
		,30,31,32,33,34,35,36,37,38,39
		,40,41,42,43,44,45,46,47,48,49
		,50,51,52,53,54,55,56,57,58,59
		,60,61,62
	) ain
group by 
		1,2,3,4,5,6,7,8,9,10
		,11,12,13,14,15,16,17,18,19
		,20,21,22,23,24,25,26,27,28,29
		,30,31,32,33,34,35,36,37,38,39
		,40,41,42,43,44,45,46,47,48,49
		,50,51,52,53,54,55,56,57,58,59
		,60,61,62
)
distributed randomly
