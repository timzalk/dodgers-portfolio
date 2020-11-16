#%%
import pandas as pd
import seaborn as sns
import numpy as np
import matplotlib.pyplot as plt
import logging as log

log.basicConfig(level=log.INFO)

#%%
# path = "/Users/timzalk/Library/Mobile Documents/com~apple~CloudDocs/GitHub/syracuse-ds/2020-1/ist718/Project/IST718_Group_Initial_EDA/small_df_interested.csv"
path = "/Users/timzalk/Library/Mobile Documents/com~apple~CloudDocs/GitHub/syracuse-ds/2020-1/ist718/Project/IST718_Group_Initial_EDA/Scorecard.csv"
raw = pd.read_csv(path)
log.info("Imported from " + path)


# %%
df = raw
#df = raw.head(n=5000)
df.RELAFFIL.fillna('Null', inplace=True)
del raw

#%%
selected_cols = ['UGDS', 'AVGFACSAL', 'CONTROL', 'STABBR', 'RELAFFIL', 'md_earn_wne_p10', 'UNITID', 'INSTNM', 'CITY', 'ZIP', 'sch_deg', 'main', 'NUMBRANCH', 'PREDDEG', 'HIGHDEG', 'region', 'LOCALE', 'locale2', 'LATITUDE', 'LONGITUDE', 'CCSIZSET', 'HBCU', 'PBI', 'ANNHI', 'TRIBAL', 'AANAPII', 'HSI', 'NANTI', 'MENONLY', 'WOMENONLY', 'ADM_RATE', 'SAT_AVG', 'DISTANCEONLY', 'COSTT4_A', 'COSTT4_P', 'TUITIONFEE_IN', 'TUITIONFEE_OUT', 'TUITIONFEE_PROG', 'TUITFTE', 'INEXPFTE', 'PFTFAC', 'C150_4', 'C150_L4', 'D150_4', 'D150_L4', 'PCTFLOAN', 'UG25abv', 'CDR3', 'DEATH_YR8_RT', 'RPY_7YR_RT', 'PAR_ED_PCT_1STGEN', 'DEP_INC_AVG', 'IND_INC_AVG', 'DEBT_MDN', 'loan_ever', 'married', 'median_hh_inc', 'Year']

#%%
df = df[selected_cols]
df_lastyear = df[df.Year == 2013]



#%% Histogram of Undergraduate Degree-Seeking Students
sns.set(style='whitegrid', palette="deep", font_scale=1.1, rc={"figure.figsize": [12, 8]})

fig, ax = plt.subplots()
ax.set(yscale="log", xlim=(0,50000))

sns.distplot(df_lastyear['UGDS'], norm_hist=False, kde=False, bins=80, hist_kws={"alpha": 1}).set(xlabel='Undergrad Degree-Seeking Students in 2013', ylabel='Count');


#%% Histogram of Average Faculty Salary
sns.set(style='whitegrid', palette="deep", font_scale=1.1, rc={"figure.figsize": [8, 5]})
sns.distplot(df_lastyear['AVGFACSAL'], norm_hist=False, kde=False, bins=20, hist_kws={"alpha": 1}).set(xlabel='Average Faculty Salary in 2013', ylabel='Count');

#%% Barchart of university type
sns.countplot(df_lastyear['CONTROL']);

#%% Barchart of states
sns.set(rc={"figure.figsize": [18, 8]})
sns.countplot(df_lastyear['STABBR'], order=sorted(df_lastyear['STABBR'].unique().tolist()));


#%% Barchart of religion affiliations
sns.set(rc={"figure.figsize": [16, 8]})
sns.countplot(df_lastyear['RELAFFIL']);

#%% years
sns.countplot(df['Year'])

#%%
#sns.scatterplot(x=df['1stFlrSF'], y=df['SalePrice']);

#%%
# df['mn_earn_wne_inc1_p6'].hist()
# df['mn_earn_wne_inc2_p6'].hist()
# df['mn_earn_wne_inc3_p6'].hist()
sns.set(style='whitegrid', palette="deep", font_scale=1.1, rc={"figure.figsize": [16, 10]})
df_2011 = df[df.Year == 2011][df.md_earn_wne_p10 != 'PrivacySuppressed']
fig, ax = plt.subplots()
ax.set(xlim=(0,150000))
sns.distplot(df_2011['md_earn_wne_p10'], norm_hist=False, kde=False, bins=50, hist_kws={"alpha": 1})


#%% corr
narrow_df = df_2011[selected_cols].drop(['sch_deg', 'UNITID', 'LOCALE', 'locale2', 'Year', 'INSTNM', 'CITY', 'ZIP', 'LONGITUDE', 'LATITUDE', 'D150_4', 'D150_L4', 'COSTT4_P'], axis=1)[df.ne('PrivacySuppressed').all(1)].infer_objects()

narrow_df = narrow_df.dropna(subset=['md_earn_wne_p10', 'DEATH_YR8_RT', 'PAR_ED_PCT_1STGEN'])


fig, ax = plt.subplots(figsize=(11, 9))
sns.set(style="white")
corr = narrow_df.corr()
mask = np.triu(np.ones_like(corr, dtype=np.bool))
cmap = sns.diverging_palette(220, 10, as_cmap=True)
sns.heatmap(corr, mask=mask, cmap=cmap, vmax=1, vmin=-1, center=0, square=True, linewidths=.5, cbar_kws={"shrink": .5})


2#%%
narrow_df.dtypes

#%%
# sns.set(style="white")
# corr = df.corr()
# mask = np.triu(np.ones_like(corr, dtype=np.bool))
# f, ax = plt.subplots(figsize=(11, 9))
# cmap = sns.diverging_palette(220, 10, as_cmap=True)
# sns.heatmap(corr, mask=mask, cmap=cmap, vmax=.3, center=0, square=True, linewidths=.5, cbar_kws={"shrink": .5})


# %%



#%% save
narrow_df.to_csv('narrow-data.csv', index=False)


# %%
df = raw.head(n=1000)


# %%
