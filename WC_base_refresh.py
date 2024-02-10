import os
import sys
import shutil
from sqlalchemy import create_engine, text
sys.path.append(os.path.abspath("C:\\Users\\Anirudh_Naik\\OneDrive - Dell Technologies"))
from pwdfile import getpass
pwd = getpass("ddlpw.txt")

#set path
os.chdir(os.path.dirname(os.path.abspath(__file__)))
fp = os.getcwd()

# set connection
def connexion():
    url = 'postgresql+psycopg2://anirudh_naik'+pwd+'@ddlgpmprod11.us.dell.com:6420/gp_ns_ddl_prod'
    engine = create_engine(url)

connexion()

# get file to execute
def pathmaker():
