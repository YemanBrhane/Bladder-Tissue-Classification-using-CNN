# -*- coding: utf-8 -*-
"""
Created on Tue Aug 15 14:15:37 2017

@author: Shema

"""
import os
os.environ["CUDA_DEVICE_ORDER"] = "PCI_BUS_ID"   # see issue #152
os.environ["CUDA_VISIBLE_DEVICES"] = ""

#from keras.datasets import mnist
import numpy as np
from matplotlib import pyplot as plt
	
from keras.utils import np_utils
from mymodel import my_model_def

from keras.optimizers import SGD

from keras import callbacks

from supporting_func import get_mnist_data
# %%
batch_size = 32
input_size = (3,128,128)
nb_classes = 3
nb_epoch = 10
#%% mnist data

training_images, validation_images , training_labels, validation_labels = get_mnist_data(reduce=True)


#%% Bladder patches

print('loading data...')
training_data = np.load('../data/agumented/training_data_shuffled.npz')
training_images = training_data['images']
training_labels = training_data['labels']
 
validation_data = np.load('../data/agumented/validation_data.npz')
validation_images =validation_data['images']
validation_labels =validation_data['labels']

# Convert 1-dimensional class arrays to 10-dimensional class matrices
training_labels = np_utils.to_categorical(training_labels, nb_classes)
validation_labels = np_utils.to_categorical(validation_labels, nb_classes)




#%% lerning rate scheduler
sgd = SGD(lr=0.01,momentum=0.9,decay=0.0001,nesterov=True)

print('creating model and compiling..')
model = my_model_def(input_size,nb_classes=nb_classes)

model.compile(loss='categorical_crossentropy',metrics=['accuracy'],optimizer=sgd)


#%% Training callbacks

print('training starting..')

filename = 'model_train_new.csv'

csv_log = callbacks.CSVLogger(filename, separator=',', append=False)

early_stopping = callbacks.EarlyStopping(monitor='val_loss', min_delta=0, patience=5, verbose=0, mode='min')

filepath = "Best-weights-my_model-{epoch:03d}-{loss:.4f}-{acc:.4f}.hdf5"

checkpoint = callbacks.ModelCheckpoint(filepath, monitor='val_loss', verbose=1, save_best_only=True, mode='min')

callbacks_list = [csv_log, early_stopping, checkpoint]

hist = model.fit(training_images, training_labels, batch_size=batch_size, epochs=nb_epoch, verbose=1,
                 validation_data=(validation_images, validation_labels), shuffle=True,callbacks=callbacks_list)
















