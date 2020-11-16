#%%
import pandas as pd
import seaborn as sns

#%%
path = "Scorecard.csv"
raw = pd.read_csv(path, error_bad_lines=False)
print("Imported from " + path)

raw.columns.values

len(raw.iloc[:,0])

#%%
# some columns for less-than-four years, some for four-years. some columns for private, some for public. must combine. some data only exists for Title IV institutions
featurelist = ['Year','UNITID','OPEID','OPEID6','INSTNM','STABBR','REGION','LOCALE','LOCALE2','LATITUDE','LONGITUDE','SCH_DEG', 'PREDDEG','NUMBRANCH','MAIN','HCM2','AccredAgency','ZIP'
               ,'CCUGPROF','CCBASIC','CCSIZSET','HBCU','PBI','MENONLY','WOMENONLY','RELAFFIL','ADM_RATE','SATVR25'
               ,'SATVR75','SATMT25','SATMT75','SATWR25','SATWR75','SATVRMID','SATMTMID','SATWRMID','ACTCM25','ACTCM75'
               ,'ACTEN25','ACTEN75','ACTMT25','ACTMT75','ACTWR25','ACTWR75','ACTCMMID','ACTENMID','ACTMTMID','ACTWRMID'
               ,'SAT_AVG','SAT_AVG_ALL','UGDS','UG','DISTANCEONLY','PPTUG_EF','PPTUG_EF2','CURROPER'
               ,'NPT4_PUB','NPT4_PRIV','NPT4_PROG','NPT4_OTHER','COSTT4_A','COSTT4_P','TUITIONFEE_IN','TUITIONFEE_OUT'
               ,'TUITIONFEE_PROG','TUITFTE','INEXPFTE','AVGFACSAL','PFTFAC','PCTPELL','C150_4','C150_L4','C150_4_POOLED','C150_L4_POOLED'
               ,'C200_4','C200_L4','RET_FT4','RET_FTL4','RET_PT4','RET_PTL4','UG25abv','CDR2','CDR3'
               ,'DEATH_YR2_RT','ENRL_ORIG_YR2_RT','WDRAW_ORIG_YR2_RT','COMP_ORIG_YR2_RT'
               ,'COMP_ORIG_YR3_RT','WDRAW_ORIG_YR3_RT','ENRL_ORIG_YR3_RT','PCTFLOAN','ENRL_ORIG_YR4_RT','DEATH_YR3_RT','ENRL_ORIG_YR2_RT','COMP_ORIG_YR4_RT','DEATH_YR4_RT','WDRAW_ORIG_YR4_RT'
               ,'COMP_ORIG_YR6_RT','DEATH_YR6_RT','ENRL_ORIG_YR6_RT','WDRAW_ORIG_YR6_RT'
               ,'RPY_1YR_RT','RPY_3YR_RT','RPY_5YR_RT','RPY_7YR_RT','PAR_ED_PCT_1STGEN','DEP_STAT_PCT_IND','PAR_ED_PCT_MS','PAR_ED_PCT_HS','PAR_ED_PCT_PS'
               ,'DEP_INC_AVG','IND_INC_AVG','DEBT_MDN','GRAD_DEBT_MDN','WDRAW_DEBT_MDN','LO_INC_DEBT_MDN','MD_INC_DEBT_MDN','HI_INC_DEBT_MDN','DEP_DEBT_MDN'
               ,'IND_DEBT_MDN','MALE_DEBT_MDN','FEMALE_DEBT_MDN','FIRSTGEN_DEBT_MDN','NOTFIRSTGEN_DEBT_MDN'
               ,'CUML_DEBT_P10','CUML_DEBT_P25','CUML_DEBT_P75','CUML_DEBT_P90','LOAN_EVER','PELL_EVER','AGE_ENTRY','AGEGE24'
               ,'FEMALE','MARRIED','DEPENDENT','VETERAN','FIRST_GEN'
               ,'FAMINC','MD_FAMINC','POVERTY_RATE','UNEMP_RATE'
               ,'MD_EARN_WNE_P10','MN_EARN_WNE_P10','MD_EARN_WNE_P6','MN_EARN_WNE_P6','MN_EARN_WNE_P8','MD_EARN_WNE_P8'
               ,'DEBT_MDN_SUPP','RPY_3YR_RT_SUPP'
               ,'ICLEVEL','UGDS_MEN','UGDS_WOMEN'
               ,'OPENADMP','SCHTYPE','OPEFLAG','PRGMOFR']

#subsetdf = raw[featurelist]


'''
KeyError: "['POVERTY_RATE', 'MD_EARN_WNE_P6', 'OPENADMP', 'FEMALE', 'UGDS_MEN', 'UGDS_WOMEN', 'OPEFLAG', 'SATVRMIDSATMTMID', 'PELL_EVER', 'MD_EARN_WNE_P10', 'VETERAN', 'MAIN', 'FIRST_GEN', 'AGE_ENTRY', 'UG25ABV', 'ICLEVEL', 'LOAN_EVER', 'OPEID6', 'ACCREDAGENCY', 'SCHTYPE', 'MARRIED', 'MN_EARN_WNE_P8', 'MD_FAMINC', 'REGION', 'LOCALE2', 'MD_EARN_WNE_P8', 'FAMINC', 'MN_EARN_WNE_P10', 'MN_EARN_WNE_P6', 'PRGMOFR', 'DEPENDENT', 'SCH_DEG', 'UNEMP_RATE', 'AGEGE24'] not in index"

'''

problem = ['POVERTY_RATE', 'MD_EARN_WNE_P6', 'OPENADMP', 'FEMALE', 'UGDS_MEN', 'UGDS_WOMEN', 'OPEFLAG', 'MD_EARN_WNE_P10', 'PELL_EVER', 'VETERAN', 'MAIN', 'FIRST_GEN', 'AGE_ENTRY', 'ICLEVEL', 'LOAN_EVER', 'OPEID6', 'SCHTYPE', 'MARRIED', 'MN_EARN_WNE_P8', 'MD_FAMINC', 'REGION', 'LOCALE2', 'MD_EARN_WNE_P8', 'FAMINC', 'MN_EARN_WNE_P10', 'MN_EARN_WNE_P6', 'DEPENDENT', 'PRGMOFR', 'SCH_DEG', 'UNEMP_RATE', 'AGEGE24']

stillshit = ['iclevel', 'ugds_men', 'schtype', 'opeflag', 'openadmp', 'ugds_women', 'prgmofr']
#%%
loweredfeaturelist = []
for each in featurelist:
    if each in problem:
        if each.lower() in stillshit:
            pass
        else:
            loweredfeaturelist.append(each.lower())
    else:
        loweredfeaturelist.append(each)

subsetdf = raw[loweredfeaturelist]

post2008 = subsetdf[(subsetdf['Year'] > 2008)]

nulls = []

for each in post2008.columns.values:
    nulls.append((each,(len(post2008.iloc[:,0]) - post2008[each].count())))

print(nulls)
#%%
print("COMPLETED")
#%%
corr = raw.corr()
ax = sns.heatmap(
    corr, 
    vmin=-1, vmax=1, center=0,
    cmap=sns.diverging_palette(20, 220, n=200),
    square=True
)
ax.set_xticklabels(
    ax.get_xticklabels(),
    rotation=45,
    horizontalalignment='right'
);



# %%


# %%
