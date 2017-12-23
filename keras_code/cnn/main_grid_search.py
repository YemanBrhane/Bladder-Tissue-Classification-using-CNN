# -*- coding: utf-8 -*-
"""
Created on Tue Aug 15 14:15:37 2017

@author: Shema

"""
import os

os.environ["CUDA_DEVICE_ORDER"] = "PCI_BUS_ID"  # see issue #152
os.environ["CUDA_VISIBLE_DEVICES"] = ""

# from keras.datasets import mnist
import numpy as np
from matplotlib import pyplot as plt

from keras.utils import np_utils
from mymodel import my_model_def

from keras.optimizers import SGD

from keras import callbacks
from supporting_func import *


from sklearn.model_selection import GridSearchCV
from keras.wrappers.scikit_learn import KerasClassifier

# %%
batch_size = 32
input_size = (3, 128, 128)
nb_classes = 3
nb_epoch = 10

# %% load data

print('loading data...')
training_data = np.load('../data/agumented/training_data.npz')
training_images = training_data['images']
training_labels = training_data['labels']

validation_data = np.load('../data/agumented/validation_data.npz')
validation_images = validation_data['images']
validation_labels = validation_data['labels']

# Convert 1-dimensional class arrays to 10-dimensional class matrices
training_labels = np_utils.to_categorical(training_labels, nb_classes)
validation_labels = np_utils.to_categorical(validation_labels, nb_classes)

#%%
# fix random seed for reproducibility
seed = 7
np.random.seed(seed)

# create model
model = KerasClassifier(build_fn=my_model_def(), epochs=100, batch_size=10, verbose=0)
# define the grid search parameters
neurons = [1, 5, 10, 15, 20, 25, 30]
param_grid = dict(neurons=neurons)
grid = GridSearchCV(estimator=model, param_grid=param_grid, n_jobs=-1)
grid = GridSearchCV(estimator=my_model_def(),param_grid=param_grid,n_jobs=-1)
grid_result = grid.fit()
# summarize results
print("Best: %f using %s" % (grid_result.best_score_, grid_result.best_params_))
means = grid_result.cv_results_['mean_test_score']
stds = grid_result.cv_results_['std_test_score']
params = grid_result.cv_results_['params']
for mean, stdev, param in zip(means, stds, params):
    print("%f (%f) with: %r" % (mean, stdev, param))










