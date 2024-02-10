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
url1 = 'postgresql+psycopg2://anirudh_naik:'+pwd+'@ddlgpmprd11.us.dell.com:6420/gp_ns_ddl_prod'
connexion(url1)
print("connected...")
case_query = text("select * from test_9244_ani_case")
wo_query = text("select * from test_9244_ani_wo")
cal_query = text("select * from tbl_ani_6208_wc_cal as cal where cal.week_lag >= -4")
df = pd.read_sql(case_query, engine)
print("pulled case table")
df_wo = pd.read_sql(wo_query, engine)
print("pulled wo table")
df_cal = pd.read_sql(cal_query, engine)
print("pulled calendar table")

print("merging...")
ccreated_date = df.groupby(["calendar_date"])["case_created_count"].sum().reset_index()
# ccreated_brand = df.groupby(["global_brand"])["case_created_count"].sum().reset_index()
# ccreated_wk_brand = df.groupby(["fiscal_week", "global_brand"])["case_created_count"].sum().reset_index()
wcowr = df.groupby(["fiscal_week"])["case_created_count"].sum().reset_index()
ccreated_wid = df.groupby(["case_wid"])["case_created_count"].sum().reset_index()

mergedf = pd.merge(df_cal, ccreated_date, how='cross', on='calendar_date')
merge2 = pd.merge(mergedf, df_wo, how='left', on='calendar_date')

# mergedf = pd.merge(ccreated_wid, df_wo, how="left", on='case_wid', left_index=False, right_index=False)
# mergedf = pd.merge(df_wo, wcowr, on='fiscal_week', left_index=False, right_index=False)
# merge2 = pd.merge(mergedf, ccreated_brand, on='global_brand', left_index=False, right_index=False)
filepath = '\\'.join([fpath, 'test_merge.csv'])
print("merge complete")
merge2.to_csv(filepath, index=False)
print("exported to csv")

print("generating report")
report = dp.Report(dp.DataTable(merge2))
report.save(path="sample_report.html")
print("all stop.")