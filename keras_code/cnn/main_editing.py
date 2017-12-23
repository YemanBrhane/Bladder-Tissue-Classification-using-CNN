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

from supporting_func import get_mnist_data, visualize_loss_accuracy,\
							compute_confusion_matrix, plot_save_confusion_matrix

bladder_data = True

if bladder_data==False:
	#%% mnist data
	print('loading mnist..')
	training_images, validation_images , training_labels, validation_labels = get_mnist_data(reduce=True)
	input_size = (1,28,28)
	nb_classes = 10
	class_names = ['0', '1', '2', '3','4', '5' ,'6','7','8','9']
	nb_epoch = 2

	batch_size = [70]
	drop_out = [0.6]
	fmap_size = [(200,400,2048)]

else:
	#%% Bladder patches
	input_size = (3,128,128)
	nb_classes = 3
	class_names = ['normal', 'cancer', 'muscle']
	print('loading bladder data...')
	training_data = np.load('../data/agumented/training_data_shuffled.npz')
	training_images = training_data['images']
	training_labels = training_data['labels']

	validation_data = np.load('../data/agumented/validation_data.npz')
	validation_images =validation_data['images']
	validation_labels =validation_data['labels']

	# Convert 1-dimensional class arrays to 10-dimensional class matrices
	training_labels = np_utils.to_categorical(training_labels, nb_classes)
	validation_labels = np_utils.to_categorical(validation_labels, nb_classes)
	


	#%% model parameters
	nb_epoch = 30
	batch_size = [70, 50]
	drop_out = [0.6, 0.5]
	fmap_size = [(200,400,2048),(250,500,3072), (300,500,4096)]



#%% lerning rate scheduler
print(len(batch_size))

print(len(fmap_size))
print(len(drop_out))
sgd = SGD(lr=0.01,momentum=0.9,decay=0.001,nesterov=True)
for bs in range(len(batch_size)):
	for i in range(len(drop_out)):
		for j in range(len(fmap_size)):
			# print('creating model and compiling..')
			model = my_model_def (input_dim = input_size, nb_classes=nb_classes,
					drop_out = drop_out[i], fmap_size =fmap_size[j])

			model.compile(loss='categorical_crossentropy',metrics=['accuracy'],optimizer=sgd)

			# callbacks

			print('training starting..')
			param= "drop_out_"+ str(drop_out[i])+ "_fmap_"+str(fmap_size[j][0])
			log_filename = param+'_model_train_new.csv'

			csv_log = callbacks.CSVLogger(log_filename, separator=',', append=False)

			early_stopping = callbacks.EarlyStopping(monitor='val_loss', min_delta=0, patience=5, verbose=0, mode='min')

			checkpoint_filepath = param+"_best-weight-model-{epoch:03d}-{loss:.4f}-{acc:.4f}.hdf5"

			checkpoint = callbacks.ModelCheckpoint(checkpoint_filepath, monitor='val_loss', verbose=1, save_best_only=True, mode='min')

			callbacks_list = [csv_log, early_stopping, checkpoint]

			hist = model.fit(training_images, training_labels, batch_size=batch_size[bs], epochs=nb_epoch, verbose=1,
							 validation_data=(validation_images, validation_labels), shuffle=True,callbacks=callbacks_list)
			
			
			# plot historty and save
			loss_figure_name = param+"_loss.png"
			acc_figure_name = param+"_acc.png"
			visualize_loss_accuracy(hist,save=False,loss_figure_name=loss_figure_name,
										acc_figure_name=acc_figure_name )
										
			Y_pred = model.predict(validation_images)
			y_pred = np.argmax(Y_pred, axis=1)
			y_test = np.argmax(validation_labels, axis=1)
			confusion_mat = compute_confusion_matrix(y_test, y_pred)
			
			# Plot confusion matrix
			name = param+"_cm.png"
			title='Confusion matrix'
			plot_save_confusion_matrix(confusion_mat, classes=class_names, name=name, title = title)
















