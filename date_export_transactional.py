import os
import shutil
import time

import pandas as pd
import psutil
from sqlalchemy import create_engine, text
import xlwings as xw
import sys
sys.path.append(os.path.abspath("C:\\Users\\Anirudh_Naik\\OneDrive - Dell Technologies"))
from pwdfile import getpass
pwd = getpass("ddlpw.txt")

# set default directory
os.chdir(os.path.dirname(os.path.abspath(__file__)))
path = os.getcwd()


# set path
def file_loc():
    storepath = path
    copypath = r"C:\Users\anirudh_naik\OneDrive - Dell Technologies\Refreshes"
    datafile = "9244_norbert_data.csv"
    # datasmry = "9244_smry_mb_red.csv"
    xlfile = "9244_MB_reduction_weeks_shared_file.xlsx"
    xlfile2 = "9244_MB_reduction_weeks_shared_file_2.xlsx"
    global localfile
    global sharefile
    global localsummary
    localfile = '\\'.join([storepath, datafile])
    # localsummary = '\\'.join([storepath, datasmry])
    sharefile = '\\'.join([copypath, datafile])
    global xlshare
    xlshare = '\\'.join([copypath, xlfile])
    global xlshare2
    xlshare2 = '\\'.join([copypath, xlfile2])


file_loc()

url = 'postgresql+psycopg2://anirudh_naik:'+pwd+'@ddlgpmprd11.us.dell.com:6420/gp_ns_ddl_prod'
engine = create_engine(url)

# update backend tables
qf = "9244_outlier_wc_V3.5_cleaned.sql"
qfp = '\\'.join([path, qf])
with open(qfp, 'r') as q:
    sql = q.read()
    lcount = len(sql.split(';'))

querys = []
for sequence in range(lcount):
    querys = sql.split(';')

for i in range(lcount):
    print(f"executing {querys[i]}")
    # engine.execute(querys[i])
    with engine.connect().execution_options(autocommit=True) as conn:
        conn.execute(text(querys[i]))


print("getting data from source...")
fetchsql = text("select * from tbl_ani_9244_mb_redux")
# fetchsqlsmry = text("select * from tbl_ani_9244_mb_smry")

df = pd.read_sql(fetchsql, engine)
# df2 = pd.read_sql(fetchsqlsmry, engine)

print("downloaded to local file...")
df.to_csv(localfile, index=False)
# df2.to_csv(localsummary, index=False)

print(f"copied to shared location {sharefile}")
shutil.copyfile(localfile, sharefile)
print("export complete")

# refresh excel file
# open xl in the background
app_xl = xw.App(visible=True)
#refresh the workbook
wb = xw.Book(xlshare)
wb.api.RefreshAll()
print("refreshing in excel...")
time.sleep(20)
# save file
wb.save('xltemp.xlsx')
wb.close()
time.sleep(3)
# kill excel
del wb
app_xl.kill()
del app_xl
print("finished excel bit, killed it. Returning to normal.")
try:
    shutil.copyfile('xltemp.xlsx', xlshare)
    print(f"able to copy {xlshare}")
except:
    print("file copy denied on the first file, hence copying to alternate.")
    try:
        shutil.copyfile('xltemp.xlsx', xlshare2)
        print("trying alternate copy...")
    except:
        print("failed alternate.")
finally:
    print("neither file was saved... have to copy temp file manually.")
    shutil.copyfile('xltemp.xlsx', 'xltemp2.xlsx')
print("saving...")
os.remove('xltemp.xlsx')
print("removed temp file")


