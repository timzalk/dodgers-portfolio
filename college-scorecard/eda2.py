#%%
import pandas as pd
import numpy as np
import seaborn as sns
from matplotlib import rcParams

wd = "Initial_EDA/"

college_scorecard_raw = pd.read_csv(wd + "Scorecard.csv")

#%%
college_scorecard_raw.head(5)
#%%
college_scorecard_raw.tail()
#%%
print(len(college_scorecard_raw))
#%%
# Make a small data set for EDA by taking a random sample of 500 rows
small_df = college_scorecard_raw.sample(500)

small_df.head(5)
#%%
# Further narrow the small_df for EDA by only selecting interested columns
small_df_interested = small_df[['Id','UNITID','OPEID','INSTNM','CITY','STABBR','ZIP','CONTROL','HBCU','PBI','ANNHI','TRIBAL','AANAPII','HSI','NANTI','MENONLY','WOMENONLY','RELAFFIL','ADM_RATE','UGDS','UGDS_WHITE','UGDS_BLACK','UGDS_HISP','UGDS_ASIAN','UGDS_AIAN','UGDS_NHPI','UGDS_2MOR','UGDS_NRA','UGDS_UNKN','UGDS_WHITENH','UGDS_BLACKNH','UGDS_API','NPT4_PUB','NPT4_PRIV','NPT4_PROG','NPT4_OTHER','AVGFACSAL','count_nwne_p6','count_wne_p6','mn_earn_wne_p6','md_earn_wne_p6','pct10_earn_wne_p6','pct25_earn_wne_p6','pct75_earn_wne_p6','pct90_earn_wne_p6','count_wne_indep0_p6','count_wne_indep1_p6','count_wne_male0_p6','count_wne_male1_p6','gt_25k_p6']]

small_df_interested.head(20)
#%%
# Save DF to .csv file to look at data content
small_df_interested.to_csv(wd + 'small_df_interested.csv')

# Get rid of all the rows with NaN's
#small_df_interested_clean = small_df_interested.dropna()

#small_df_interested_clean.head(20)
#%%
print(type(small_df_interested["mn_earn_wne_p6"]))
#%%
# Try converting to string and then removing/replacing PrivacySuppressed with a code number
small_df_interested_clean = small_df_interested
small_df_interested_clean["mn_earn_wne_p6"] = small_df_interested_clean["mn_earn_wne_p6"].replace(np.nan,'-1')
small_df_interested_clean["mn_earn_wne_p6"] = small_df_interested_clean["mn_earn_wne_p6"].replace('PrivacySuppressed','-1')
small_df_interested_clean["mn_earn_wne_p6"] = small_df_interested_clean["mn_earn_wne_p6"].astype(int)

#%%
print(small_df_interested_clean["mn_earn_wne_p6"])

#%%
# Quick Scatter Plot 
#rcParams['figure.figsize'] = 11.7,8.27
ax = sns.scatterplot(x="INSTNM", y="mn_earn_wne_p6", data=small_df_interested_clean)
ax.set_xticklabels(
    ax.get_xticklabels(), 
    rotation=45, 
    horizontalalignment='right',
    fontweight='light',
    fontsize='x-large'
)

fig = ax.get_figure()
fig.savefig("college_scorecard.png")






# %%
