-- ws_svc_gsa_bi.vw_ani_7262_telco_gdpr source

CREATE OR REPLACE VIEW ws_svc_gsa_bi.vw_ani_7262_telco_gdpr
AS WITH cte_all AS (
         SELECT DISTINCT pers.src_prsn_hist_gen_id,
            pers.assoc_ntwk_login_nm,
            pers.assoc_full_nm,
            replace(pers.assoc_email_addr::text, '_'::text, '.'::text) AS "Agent_Email_Id",
            row_number() OVER (PARTITION BY pers.assoc_bdge_nbr ORDER BY pers.src_eff_end_dt DESC) AS "Ordered",
            pers.assoc_bdge_nbr,
            mgr.assoc_bdge_nbr AS "BUS_FRST_MGR_BDGE_NBR",
                CASE
                    WHEN (pers.ctry_nm::text = ANY (ARRAY['Austria'::character varying::text, 'Belgium'::character varying::text, 'Bulgaria'::character varying::text, 'Croatia'::character varying::text, 'Republic of Cyprus'::character varying::text, 'Czech Republic'::character varying::text, 'Czechia'::character varying::text, 'Denmark'::character varying::text, 'Estonia'::character varying::text, 'Finland'::character varying::text, 'France'::character varying::text, 'Germany'::character varying::text, 'Greece'::character varying::text, 'Hungary'::character varying::text, 'Ireland'::character varying::text, 'Italy'::character varying::text, 'Latvia'::character varying::text, 'Lithuania'::character varying::text, 'Luxembourg'::character varying::text, 'Malta'::character varying::text, 'Netherlands'::character varying::text, 'Poland'::character varying::text, 'Portugal'::character varying::text, 'Romania'::character varying::text, 'Slovakia'::character varying::text, 'Slovenia'::character varying::text, 'Spain'::character varying::text, 'Sweden'::character varying::text, 'United Kingdom'::character varying::text, 'Austria'::character varying::text, 'BELGIUM'::character varying::text, 'BULGARIA'::character varying::text, 'CROATIA'::character varying::text, 'Republic of Cyprus'::character varying::text, 'CZECH REPUBLIC'::character varying::text, 'DENMARK'::character varying::text, 'ESTONIA'::character varying::text, 'FINLAND'::character varying::text, 'FRANCE'::character varying::text, 'GERMANY'::character varying::text, 'GREECE'::character varying::text, 'HUNGARY'::character varying::text, 'IRELAND'::character varying::text, 'ITALY'::character varying::text, 'LATVIA'::character varying::text, 'Lithuania'::character varying::text, 'Luxembourg'::character varying::text, 'MALTA'::character varying::text, 'NETHERLANDS'::character varying::text, 'POLAND'::character varying::text, 'PORTUGAL'::character varying::text, 'ROMANIA'::character varying::text, 'SLOVAKIA'::character varying::text, 'SLOVENIA'::character varying::text, 'SPAIN'::character varying::text, 'Sweden'::character varying::text, 'UNITED KINGDOM'::character varying::text])) AND pers.bus_frst_mgr_last_nm IS NOT NULL THEN 1
                    ELSE 0
                END AS "GDPR Protected"
           FROM assoc_dim pers
             LEFT JOIN assoc_dim mgr ON pers.bus_frst_mgr_bdge_nbr::text = mgr.assoc_bdge_nbr::text AND mgr.bus_rptg_catg_nm::text = 'Tech Support'::text AND (mgr.bus_rptg_grp_nm::text = ANY (ARRAY['Commercial Enterprise Services'::character varying::text, 'Infrastructure Solutions Group'::character varying::text])) AND mgr.bus_rptg_dept_nm::text <> 'TS-DOSD'::text
          WHERE (pers.assoc_bdge_nbr::text = '111111'::text OR (pers.bus_rptg_catg_nm::text = 'Tech Support'::text AND (pers.bus_rptg_grp_nm::text = ANY (ARRAY['Commercial Enterprise Services'::character varying::text, 'Infrastructure Solutions Group'::character varying::text])) AND pers.bus_rptg_dept_nm::text <> 'TS-DOSD'::text)) AND pers.assoc_ntwk_login_nm IS NOT NULL
        )
 SELECT pers.assoc_bdge_nbr,
    COALESCE(pers.assoc_ntwk_login_nm, pers.assoc_full_nm) AS "ASSOC_NTWK_LOGIN_NM",
    pers.assoc_full_nm AS "Agent Name",
    pers."Agent_Email_Id",
    pers."GDPR Protected",
    0 AS "Masked",
    pers."BUS_FRST_MGR_BDGE_NBR",
    'UM'::text || pers.assoc_bdge_nbr::text AS joinkey
   FROM cte_all pers
  WHERE pers."Ordered" = 1
  GROUP BY pers.assoc_bdge_nbr, COALESCE(pers.assoc_ntwk_login_nm, pers.assoc_full_nm), pers.assoc_full_nm, pers."Agent_Email_Id", pers."GDPR Protected", 0::integer, pers."BUS_FRST_MGR_BDGE_NBR", 'UM'::text || pers.assoc_bdge_nbr::text
UNION ALL
 SELECT pers.assoc_bdge_nbr,
    fn_maskvalue((pers.assoc_bdge_nbr::text || pers.assoc_ntwk_login_nm::text)::character varying) AS "ASSOC_NTWK_LOGIN_NM",
    fn_maskvalue((pers.assoc_bdge_nbr::text || pers.assoc_full_nm::text)::character varying) AS "Agent Name",
    pers."Agent_Email_Id",
    pers."GDPR Protected",
    1 AS "Masked",
    pers."BUS_FRST_MGR_BDGE_NBR",
    'MA'::text || pers.assoc_bdge_nbr::text AS joinkey
   FROM cte_all pers
  WHERE pers."Ordered" = 1 AND pers."GDPR Protected" = 1
  GROUP BY pers.assoc_bdge_nbr, fn_maskvalue((pers.assoc_bdge_nbr::text || pers.assoc_ntwk_login_nm::text)::character varying), fn_maskvalue((pers.assoc_bdge_nbr::text || pers.assoc_full_nm::text)::character varying), pers."Agent_Email_Id", pers."GDPR Protected", 1::integer, pers."BUS_FRST_MGR_BDGE_NBR", 'MA'::text || pers.assoc_bdge_nbr::text;