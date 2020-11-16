#%%
import pandas as pd
import seaborn as sns
import numpy as np
import matplotlib.pyplot as plt
import logging as log

from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestRegressor

log.basicConfig(level=log.INFO)

#%%
path = "narrow-data.csv"
df = pd.read_csv(path)
log.info("Imported from " + path)

#%% remove universities with less than 400 undergrad degree-seaking students
df.dropna(subset=['UGDS'], inplace=True)
df = df[df.UGDS >= 400]

#%%
df = df[df.Year == 2011]

# %%
df.dropna(subset=['md_earn_wne_p10'], inplace=True)
df = df[df.md_earn_wne_p10 != 'PrivacySuppressed']

#%%
# featureIndexer = VectorIndexer(inputCol="features", outputCol="indexedFeatures", maxCategories=4).fit(df)

# featureIndexer = VectorIndexer(inputCol)

# %%
train, test = train_test_split(df, train_size=.8, shuffle=True)
train_x = train.drop('md_earn_wne_p10', axis=1)
train_y = train['md_earn_wne_p10']
test_x = test.drop('md_earn_wne_p10', axis=1)
test_y = test['md_earn_wne_p10']

# %%
rf = RandomForestRegressor()
rf.fit(X=train_x, y=train_y)

#%%
regr.feature_importances_


# %%
