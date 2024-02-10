				select distinct
					scc.fisc_week_val , 
					scc.fisc_qtr_val ,
					-- cf.case_wid ,
					-- cf.case_nbr ,
					-- cf.case_crt_dts ,
					-- cf.sfdc_case_nbr ,
					-- cf.case_stat ,
					-- cf.rptg_case_chnl ,
					-- cf.asst_id ,
					-- cf.src_cust_prod_id ,
					-- cf.sfdc_case_id ,
					-- cf.asst_prod_hier_key ,
					-- cf.case_rec_type ,
					-- cf.int_case_rec_type_cd ,
					-- row_number() over (partition by cf.asst_id order by cf.case_crt_dts asc) as case_ranks ,
					sum ( case when lower(cf.rptg_case_chnl) in ('connect home','connecthome','dialhome','dialhome','dialhome_dispatch')
						then 1
						else 0
					end ) as dial_home_flg ,
					sum ( case when cf.case_wid is not null then 1 else 0 end ) as case_count
				from usdm_case_fact as cf
						INNER JOIN svc_corp_cldr as scc 
							on scc.cldr_date = cf.case_crt_dts :: date
						left JOIN usdm_prod_hier as uph
							on uph.prod_key = cf.asst_prod_hier_key 
						-- inner join usdm_wo_fact as wf
						-- 	on wf.case_wid = cf.case_wid 
						left join assoc_dim as per
							on per.src_prsn_hist_gen_id = cf.owner_bdge_hist_id_at_crt 
				where 1=1
		--				and wf.wo_nbr is not null
						and scc.fisc_yr_rltv between -2 and 0
						and scc.fisc_qtr_rltv <= 0
						and scc.fisc_week_rltv <= 0
						and lower(cf.usdm_case_type) in ('technical support' , 'incident')
						and lower(cf.CASE_REC_TYPE) not in ('care_case_read_only', 'care', 'accountbasedcase')
						and (lower(uph.svc_prod_group) in ('infrastructure solutions group')
							or lower(per.bus_rptg_grp_nm) in ('infrastructure solutions group','high end storage', 'commercial shared services', 'commercial enterprise services'))
						and cf.quick_case_flg <> 1
						and lower (cf.int_case_rec_type_cd) in ('external case')
						-- and lower(cf.rptg_case_chnl) not in ('dosd')
		--				and cf.case_wid = '5207EBB293DEBE4091E1BEA6433DE25C'
		--				and cf.asst_id = 'CK297600741'
				group by 1,2--,3,4,5,6,7,8,9,10,11,12
		--		having sum ( distinct case when cf.case_wid is not null then 1 else 0 end ) > 1
				order by 1