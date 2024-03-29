--create the outlier table
--uncomment only if changes otherwise leave as is.
drop table if exists tbl_ani_9244_outliers;
CREATE TABLE tbl_ani_9244_outliers AS (
	with outlier_cte as (
			select distinct
					ad.assoc_bdge_nbr 
					,case when lower(ad.assoc_ntwk_login_nm)  in (
																	'gopinath_jayaram',
																	'rajjesh_gaikwad',
																	'prathima_b_r',
																	'jaffer_akbar',
																	'jyotirmoy_mallik',
																	'akshay_d1',
																	'vijaykumar_rajendran',
																	'shreyank_shanbhag',
																	'mohan_rao_k',
																	'varun_bhalla1',
																	'mohammed_edris',
																	'satish_p1',
																	'chandini_a',
																	'anil_kumar_sk',
																	'd_p',
																	'raghavendra_hs',
																	'chetan_kumar_h_s',
																	'm_b_g',
																	'abdul_tousif',
																	'kumar_kumar',
																	'satendra_pal',
																	'mizuki_ishibashi',
																	'racy_takayama',
																	'masashi_nonaka',
																	'baharuddin_binomar',
																	'haruka_azuma',
																	'x_l',
																	'yongle_li',
																	'wenhui_liu1',
																	'junbin_lin',
																	'zhipeng_yu',
																	'max_l',
																	'anwei_xia',
																	'wenqiang_guo',
																	'zhiye_ge',
																	'daniella_xie',
																	'jiazi_l',
																	'donglin_chang',
																	'hien_tran_the',
																	'duong_le',
																	'bui_minh_quyen',
																	'qartika_eslyna_othma',
																	'khairi_yaacob',
																	'ann_eltanal',
																	'andri_pratama',
																	'duong_le',
																	'tinh_lexuan',
																	'zakaria_hamidon',
																	'careewan_phetthong',
																	'phumiphath_rongsawat',
																	'ahmad_zariss_mansor',
																	'sangtheetha_chandras',
																	'sithaartha_baarathy',
																	'somruetat_saeueng',
																	'mustapha_el_moudia',
																	'ali_abouelhassan',
																	'oleg_merzlikin',
																	'stuart_scully',
																	'jamal_aitali',
																	'richard_vermaas',
																	'hamza_amezian',
																	'apurv_p',
																	'mohamed_borja',
																	'hamza_el_mamouni',
																	'paul_mccormack',
																	'mohamed_karaoui',
																	'jawad_rehaoui',
																	'raunak_sharma',
																	'asthaa_pokhriyal',
																	'faisalkhan_pathan',
																	'grigore_dabija',
																	'k_jadhav',
																	'salaheddine_bousserr',
																	'robert_mcculloch',
																	'kavya_dudam',
																	'lahcen_khmassi',
																	'youssef_ouizzane',
																	'harshal_rathod',
																	'rachid_ait_hemmou',
																	'mohammaduwais_mulla',
																	'johan_versteegh',
																	'thobias_nilsson',
																	'john_harrold',
																	'jc_morassi',
																	'tomas_strycek',
																	'youssef_souhail',
																	'aqib_sayed',
																	'samir_benmeziane',
																	'attila_katona',
																	'youness_benbrahim',
																	'jerzy_gajewicz',
																	'amine_ait_hemmou',
																	'fatih_uzun',
																	'guillermo_de_escuder',
																	'andre_carvalho',
																	'vikram_t_m',
																	'sylvain_arbonnier',
																	'riad_chfali',
																	'andrea_fiore',
																	'eetu_siltanen',
																	'ariel_carvajal',
																	'imarys_riquelme',
																	'luis_tejedor',
																	'ruben_famania',
																	'adalberto_santa_cruz',
																	'kevin_arauz',
																	'c_a_rodriguez',
																	'juan_rodriguez_l',
																	'francine_rosa',
																	'j_chaves',
																	'ivan_jaureguizar',
																	'y_mendoza',
																	'eduardo_herrera1',
																	'julissa_garrido',
																	'jahir_vasquez',
																	'alecksander_oliveira',
																	'vinicius_vagner.salomao',
																	'norvell_brown',
																	'giancarlo_alvarez',
																	'zaida_molina',
																	'adam_rios2',
																	'ledell_wilson',
																	'arjit_mishra',
																	'manoj_sharma15',
																	'raviteja_vellanki',
																	'stephen_karber',
																	'hyun_c_shin',
																	'siddalinga_shivayoga',
																	'maurice_nirmal_s',
																	'kunal_saha',
																	'rajprabhu_s',
																	'aditya_joshi3',
																	'natividad_munoz',
																	'christopher_m_may',
																	'santhosh_g2',
																	'arya_roy',
																	'brian_arredondo',
																	'aniket_meshram',
																	'alexander_albright',
																	'deepak_kp_kumar',
																	'alan_chan1',
																	'sourjeet_parichha',
																	'william_c_chapman',
																	'nikhil_naik1',
																	'clayton_reininger',
																	'chris_davola',
																	'xavier_jimenez',
																	'shakeel_ahmed_k_r'
																	'sreejesh_k',
																	'venkatesh_ps',
																	'iyyanar_janardhanan',
																	'mohan_m_r',
																	'arun_nelson_dalmeida',
																	'sutanu_chakraborty',
																	'akash_shankarmurthy',
																	'santhosh_b_a',
																	'rakshith_ballal',
																	'nilesh_n_naik',
																	'abhijith_nath',
																	'libin_mathew',
																	'marcel_francis',
																	'shaik_mashkoor',
																	'sohan_philip_saldanh',
																	'usha_g1',
																	'syed_umer',
																	'gurunath_r',
																	'parvez_ahmed',
																	'nelson_gregory_ferna',
																	'sadhasivam_r',
																	'vinod_babu',
																	'dhanu_vijay',
																	'dipak_kumar_prasad',
																	'purushothaman_m',
																	'shilpa_a',
																	'priyanka_saha2',
																	'madhuri_bommidi',
																	'nazia_s',
																	'h_raj',
																	'anjaneya_alapati',
																	'roshan_fernandes',
																	'jai_shekhar',
																	'bhanu_thakur',
																	'sridhar_naik',
																	'mohar_chakraborty',
																	'prairna_malla',
																	'hitanshi_jadav'
																	'sreejesh_k',
																	'venkatesh_ps',
																	'iyyanar_janardhanan',
																	'mohan_m_r',
																	'arun_nelson_dalmeida',
																	'sutanu_chakraborty',
																	'akash_shankarmurthy',
																	'santhosh_b_a',
																	'rakshith_ballal',
																	'nilesh_n_naik',
																	'abhijith_nath',
																	'libin_mathew',
																	'marcel_francis',
																	'shaik_mashkoor',
																	'sohan_philip_saldanh',
																	'usha_g1',
																	'syed_umer',
																	'gurunath_r',
																	'parvez_ahmed',
																	'nelson_gregory_ferna',
																	'sadhasivam_r',
																	'vinod_babu',
																	'dhanu_vijay',
																	'dipak_kumar_prasad',
																	'purushothaman_m',
																	'shilpa_a',
																	'priyanka_saha2',
																	'madhuri_bommidi',
																	'nazia_s',
																	'h_raj',
																	'anjaneya_alapati',
																	'roshan_fernandes',
																	'jai_shekhar',
																	'bhanu_thakur',
																	'sridhar_naik',
																	'mohar_chakraborty',
																	'prairna_malla',
																	'hitanshi_jadav'
																	'germano_assuncao',
																	'jefferson_dorneles',
																	'fabricio.eloi',
																	'guilherme_jasniewicz',
																	'caio_roberto_santos',
																	'ana_paula.dossi',
																	'manuela.dalcorso',
																	'pedro.dutra',
																	'alejandro.sesti',
																	'carlos.cordoba1',
																	'erick.garcia2',
																	'n_mendoza',
																	'michelle_phillips1',
																	'rosilin.urriola',
																	'gregory_compere'
																						) then 'y' else 'n' end as mb_outlier
					,case when lower (ad.assoc_ntwk_login_nm)  in (
													'ashutosh_chumbhale',
													'megha_gajbhiye',
													'shahid_momin',
													'shubham_garde',
													'robert_oconnor2',
													'joshua_reed',
													'paul_scrivner',
													'steven_apple',
													'steven_cheney',
													'siddalinga_shivayoga',
													'justin_bradley',
													'bryan_massey',
													'david_m_kennel',
													'rodrick_willrich',
													'francine_rosa',
													'henry_silva',
													'anderson_nogueira',
													'alecksander_oliveira',
													'adalberto_santa_cruz',
													'y_mendoza',
													'michelle_phillips1',
													'jamith_galvis',
													'germano_assuncao',
													'julissa_garrido',
													'kevin.arauz',
													'm_siervo',
													'v_z_lam',
													'guilherme_jasniewicz',
													'juan_rodriguez_l',
													'wagner.alves',
													'stanley_s',
													'n_mendoza',
													'j_chaves',
													'mateus_jost',
													'gustavo_vargas',
													'lucas_melo3',
													'c_a_rodriguez',
													'jefferson_dorneles',
													'ruben_famania',
													'eduardo_herrera1',
													'anderson_cardoso1',
													'marcelo_atencio',
													'murilo.aguilar',
													'ivan_jaureguizar',
													'mariel_rodriguez',
													'imarys.riquelme',
													'marcelo_marcellino',
													'jahir_vasquez',
													'norvell_brown',
													'ariel_carvajal',
													'lucas.martins_campos',
													'renan_borges',
													'cristiano_fonseca',
													'mariam_maged',
													'vinay_r1',
													'radhika_radhika',
													'youness_benbrahim',
													'danny_segura',
													'gary_burke',
													'johan_versteegh',
													'david_sherlock',
													'suhas_muluguru',
													'ahmed.wael2',
													'ranjit_s_x',
													'rakesh_kumar_r',
													'yassine_el_habachi',
													'megane_nzenza',
													'tarik_idrissi_tlemca',
													'charles_dickens',
													'moncef_faraj',
													'yassine_aitbraime',
													'walid_ahmed',
													'lakshmi_chidambaram',
													'ahmed.alaaeldin',
													'nouran_moharam',
													'walter_rajashekaran',
													'm_hussein',
													'abdelrahman_awad',
													'm_b_s',
													'bertrand_puig',
													'mohamed_abdelhamid_a',
													'ayoub_el_marji',
													'salma_hashem',
													'chin_haw_khoh',
													'darren_george_woodwo',
													'diviyashini_raja',
													'faiz_athirah_hazri',
													'gary_jiang',
													'jing_cao1',
													'nor_affadzillah',
													'ragulan_balakrishnan',
													'ridhwan_merican',
													'shaojun_cai',
													'songyun_chen',
													'tee_chun_tan',
													'yuan_li1',
													'zakhwan_roslee',
													'zulhelmi_zaini',
													'black_jiang',
													'chunyu_zou',
													'joseph_jian1',
													'maokun_fang',
													'qd_h',
													'soil_zhang',
													'chui_lin_leong',
													'jun_sakuma',
													'keisuke_shima',
													'kyuyoul_park',
													'masahiro_hidaka',
													'misako_hosoki',
													'tohru_sasaki',
													'yosuke_katsuta',
													'yukiko_kihara',
													'yusuke_fukuyoshi'
																			) then 'y' else 'n' end as mmpd_outlier
			FROM assoc_dim as ad
			where 1=1
		)
		select distinct
		assoc_bdge_nbr ,
		mb_outlier,
		mmpd_outlier		
		from outlier_cte as ou
		where ou.mb_outlier is not null
		or ou.mmpd_outlier is not null
)
distributed by (assoc_bdge_nbr)
;
drop table if exists tbl_ani_9244_mb_redux;
create table tbl_ani_9244_mb_redux as (--working case counts.
		with case_cte as 
		(
			select distinct
				cas.case_wid ,
				cas.case_stat as case_status ,
				cas.rptg_case_chnl as case_channel ,
				cas.origin_nm as origin_name ,
				cas.case_crt_dts ,
				cas.asst_prod_hier_key ,
				sum ( cas.case_count ) as case_count ,
				sum ( cas.kcs_attached_count ) as kcs_attached_count ,
				sum ( cas.kcs_solved_count ) as kcs_solved_count ,
				sum ( cas.guided_flow_count ) as guided_flow_count ,
				sum ( cas.dial_home_flg ) as dial_home_flg 
			from tmp_tbl_ani_6208_wc_case as cas
			group by 1,2,3,4,5,6
		),
		wo_cte as 
				(
					select distinct
					tra.wo_wid ,
					tra.case_wid ,
					tra.outlier_key ,
					tra.approval_criteria_met::varchar(150) as approval_criteria_met ,
					tra.approval_reason ,
					tra.approval_status ,
					tra.wo_crt_utc_dts::date ,
					tra.wo_nbr ,
					tra.dps_type ,
					tra.wo_type ,
					tra.svc_type ,	
					tra.svc_opt ,
					tra.svc_opt_hrs ,
					tra.wo_status ,
					tra.crt_prcs as create_process ,
					tra.global_grouping ,
					tra.global_product,
					tra.global_lob,
					tra.global_brand,
					tra.global_generation,
					tra.product_group , 
					tra.assoc_full_nm ,
					tra.manager_first ,
					tra.manager_second ,
					tra.bus_rptg_dept_nm ,
					tra.robotic_user ,
					tra.bus_rptg_rgn_nm ,
					tra.bus_rptg_subrgn_nm ,
					tra.manager_l5 ,
					tra.region_name as customer_region ,
					tra.subregion_name as customer_subregion_name ,
					tra.area_name as area_name ,
					tra.ctry_nm as ctry_nm ,
					tra.kcs_attached ,
					tra.kcs_solved ,
					tra.guided_flow ,
					sum ( tra.wo_count ) as wo_count ,
					sum ( tra.repeat_num ) as rd_num ,
					sum ( tra.qualify_denom ) as rd_den ,
					sum ( tra.mpd_num ) as mpd_num ,
					sum ( tra.mpd_denom ) as mpd_denom ,
					sum ( tra.mmpd_flg ) as mmpd_flg ,
					sum ( tra.mmpd_flg2 ) as mmpd_flg_nowo ,
					sum ( tra.mmpd_flg3 ) as mmpd_flg_nomdr ,
					sum ( tra.mmpd_count ) as mmpd_count ,
					sum ( tra.mmpd_count2 ) as mmpd_count_nowo ,
					sum ( tra.mmpd_count3 ) as mmpd_count_nomdr ,
					sum ( tra.mb_count ) as mb_count ,
					sum ( tra.mb_count2 ) as mb_count_nowo ,
					sum ( tra.mb_count3 ) as mb_count_nomdr ,
					sum ( tra.mb_flg ) as mb_flg ,
					sum ( tra.mb_flg2 ) as mb_flg_nowo ,
					sum ( tra.mb_flg3 ) as mb_flg_nomdr ,
					sum ( tra.mdr_count ) as mdr_count
					from tbl_ani_6208_wc_trans as tra
						-- left join tbl_ani_9244_outliers as ol
						-- 	on tra.outlier_key = ol.assoc_bdge_nbr 
					group by 1,2,3,4,5,6,7,8,9,10
							,11,12,13,14,15,16,17,18,19
							,20,21,22,23,24,25,26,27,28,29
							,30,31,32,33,34,35,36--,37,38--,39
		),
		outlier_cte as 
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
		cal.fiscal_week ,
		cal.fiscal_quarter ,
		cal.week_lag ,
		cal.quarter_lag ,
		cal.calendar_date ,
		cas.case_status as case_status ,
		cas.case_channel as case_channel ,
		cas.origin_name as origin_name ,
		tra.approval_criteria_met as approval_criteria_met ,
		tra.approval_reason ,
		tra.approval_status ,
		tra.wo_crt_utc_dts::date ,
		tra.wo_nbr ,
		tra.dps_type ,
		tra.wo_type ,
		tra.svc_type ,	
		tra.svc_opt ,
		tra.svc_opt_hrs ,
		tra.wo_status ,
		tra.create_process as create_process ,
		tra.global_grouping ,
		tra.global_product,
		tra.global_lob,
		tra.global_brand,
		tra.global_generation,
		tra.product_group , 
		tra.assoc_full_nm ,
		tra.manager_first ,
		tra.manager_second ,
		tra.bus_rptg_dept_nm ,
		tra.robotic_user ,
		tra.bus_rptg_rgn_nm ,
		tra.bus_rptg_subrgn_nm ,
		tra.manager_l5 ,
		tra.customer_region as customer_region ,
		tra.customer_subregion_name as customer_subregion_name ,
		tra.area_name as area_name ,
		tra.ctry_nm as ctry_nm ,
		sum ( ol.mdr_count_kcs_attached_mb_outlier ) as mdr_count_kcs_attached_mb_outlier  ,
		sum ( ol.mdr_count_kcs_attached_mmpd_outlier ) as mdr_count_kcs_attached_mmpd_outlier  ,
		sum ( ol.mdr_count_kcs_solved_mb_outlier ) as mdr_count_kcs_solved_mb_outlier  ,
		sum ( ol.mdr_count_kcs_solved_mmpd_outlier ) as mdr_count_kcs_solved_mmpd_outlier  ,
		sum ( ol.mdr_count_guided_flow_mb_outlier ) as mdr_count_guided_flow_mb_outlier  ,
		sum ( ol.mdr_count_guided_flow_mmpd_outlier ) as mdr_count_guided_flow_mmpd_outlier  ,
		sum ( cas.case_count ) as case_count ,
		sum ( cas.kcs_attached_count ) as kcs_attached_count ,
		sum ( cas.kcs_solved_count ) as kcs_solved_count ,
		sum ( cas.guided_flow_count ) as guided_flow_count ,
		sum ( cas.dial_home_flg ) as dial_home_flg ,
		sum ( tra.wo_count ) as wo_count ,
		sum ( tra.rd_num ) as rd_num ,
		sum ( tra.rd_den ) as rd_den ,
		sum ( tra.mpd_num ) as mpd_num ,
		sum ( tra.mpd_denom ) as mpd_denom ,
		sum ( tra.mmpd_flg ) as mmpd_flg ,
		sum ( tra.mmpd_flg_nowo ) as mmpd_flg_nowo ,
		sum ( tra.mmpd_flg_nomdr ) as mmpd_flg_nomdr ,
		sum ( tra.mmpd_count ) as mmpd_count ,
		sum ( tra.mmpd_count_nowo ) as mmpd_count_nowo ,
		sum ( tra.mmpd_count_nomdr ) as mmpd_count_nomdr ,
		sum ( tra.mb_count ) as mb_count ,
		sum ( tra.mb_count_nowo ) as mb_count_nowo ,
		sum ( tra.mb_count_nomdr ) as mb_count_nomdr ,
		sum ( tra.mb_flg ) as mb_flg ,
		sum ( tra.mb_flg_nowo ) as mb_flg_nowo ,
		sum ( tra.mb_flg_nomdr ) as mb_flg_nomdr ,
		sum ( tra.mdr_count ) as mdr_count
		from case_cte as cas
			left join wo_cte as tra
				on cas.case_wid = tra.case_wid
			inner join tbl_ani_6208_wc_cal as cal
				on cal.calendar_date = cas.case_crt_dts::date --cas.case_crt_dts::date --wo.wo_crt_utc_dts::date
			inner join tbl_ani_6208_wc_prod as pd
				on pd.prod_key = cas.asst_prod_hier_key
			left join outlier_cte as ol
				on tra.wo_wid = ol.wo_wid 
			-- left join tmp_tbl_ani_6208_wc_wo as wo
			-- 	on wo.case_wid = cas.case_wid
			-- left join tmp_tbl_ani_6208_wc_rdr as rd
			-- 	on rd.wo_wid = wo.wo_wid
			-- left join tmp_tbl_ani_6208_wc_parts as par
			-- 	on par.wo_wid = wo.wo_wid
			-- left join tbl_ani_6208_wc_pers as ow
			-- 	on ow.src_prsn_hist_gen_id = wo.wo_crt_by_bdge_hist_id
			-- left join tbl_ani_6208_wc_cust as cus
			-- 	on cus.iso_alpha2_cd = wo.asst_unified_iso_ctry_cd
			-- left join tbl_ani_6208_wc_pers as ap
			-- 	on ap.src_prsn_hist_gen_id = wo.wo_apprvd_bdge_hist_id
		where 1=1
		and cal.quarter_lag >= -5
		--and cal.week_lag >= -4
		-- and upper(pd.prod_grp_desc) in ('POWEREDGE SERVERS')
		-- and upper(tra.crt_prcs) not in ('RPA')
		-- and tra.wo_nbr = '431311098'
		group by 1,2,3,4,5,6,7,8,9,
		10,11,12,13,14,15,16,17,18,19,
		20,21,22,23,24,25,26,27,28,29,
		30,31,32,33,34,35,36,37,38--,39,
		--40,41,42,43,44--,45,46--,47,48,49
		order by 1
)
distributed randomly
;