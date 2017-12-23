# -*- coding: utf-8 -*-
"""
Created on Tue Aug 15 14:15:37 2017

@author: Shema

"""
from keras.datasets import mnist
import numpy as np

	
from keras.utils import np_utils
from mymodel import my_model_def

from keras.optimizers import SGD

from keras import callbacks
# %%
batch_size = 16
input_size = (1,28,28)
nb_classes = 10
num_epoch = 10

# Load pre-shuffled MNIST data into train and test sets
(X_train, y_train), (X_test, y_test) = mnist.load_data()
print (X_train.shape)

# (60000, 28, 28)
from matplotlib import pyplot as plt
plt.imshow(X_train[0])
#%%
X_train = X_train.reshape(X_train.shape[0], 1, 28, 28)
X_test = X_test.reshape(X_test.shape[0], 1, 28, 28)

#%%
print (X_train.shape)
#%%
X_train = X_train.astype('float32')
X_test = X_test.astype('float32')
X_train /= 255
X_test /= 255

#%% take half of the data for testing
a = int (X_train.shape[0])//2
b = int (X_test.shape[0])//2

X_train= X_train[0:a ,0,:,:]
X_train = np.expand_dims(X_train,axis=1)
y_train = y_train[0:a]

y_test = y_test[0:b]
X_test = X_test [0:b, 0, :, :]
X_test = np.expand_dims(X_test,axis=1)

# Convert 1-dimensional class arrays to 10-dimensional class matrices
Y_train = np_utils.to_categorical(y_train, 10)
Y_test = np_utils.to_categorical(y_test, 10)

model = my_model_def(input_size,nb_classes=nb_classes)

#%% lerning rate scheduler
sgd = SGD(lr=0.01,momentum=0.9,decay=0.0001,nesterov=True)

model.compile(loss='categorical_crossentropy',metrics=['accuracy'],optimizer=sgd)

#%% view model configuration

print(model.summary())
# print(model.get_config())

# print(model.layers[1].output_shape)
# print(model.layers[1].get_weights())



#%% Training callbacks

filename = 'model_train_new.csv'

csv_log = callbacks.CSVLogger(filename, separator=',', append=False)

early_stopping = callbacks.EarlyStopping(monitor='val_loss', min_delta=0, patience=0, verbose=0, mode='min')

filepath = "Best-weights-my_model-{epoch:03d}-{loss:.4f}-{acc:.4f}.hdf5"

checkpoint = callbacks.ModelCheckpoint(filepath, monitor='val_loss', verbose=1, save_best_only=True, mode='min')

callbacks_list = [csv_log, early_stopping, checkpoint]

hist = model.fit(X_train, Y_train, batch_size=16, nb_epoch=num_epoch, verbose=1, validation_data=(X_test, Y_test),
                 callbacks=callbacks_list)




















