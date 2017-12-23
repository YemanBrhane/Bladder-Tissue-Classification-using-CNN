# Saving and loading model and weights
from keras.models import model_from_json
from keras.models import load_model, Model

#import os
import numpy as np
import matplotlib.pyplot as plt


from keras import backend as K

from sklearn.metrics import classification_report, confusion_matrix
import itertools

from keras.datasets import mnist
from keras.utils import np_utils

def model_save(model, model_name='model.json', model_weight_name = "model_weight.h5" ,
	model_weight_separate=False):
	pass
	# if model_weight_separate:
		# serialize model to JSON
		# model_json = model.to_json()
		# with open(model_name, "w") as json_file:
			# json_file.write(model_json)
		# serialize weights to HDF5
		# model.save_weights(model_weight_name)
	# print("Saved model to disk")

	# else:
		# model.save('model.hdf5')
	
def model_load(model_name,model_weight_name=None, model_weight_separate= False ):
	pass
	# if model_weight_separate:
		# assert (model_weight_name==None),"model_weight_name= None "
		# load json and create model
		# json_file = open(model_name, 'r')
		# loaded_model_json = json_file.read()
		# json_file.close()
		# loaded_model = model_from_json(loaded_model_json)
		# load weights into new model
		# loaded_model.load_weights(model_weight_name)
		# print("Loaded model from disk")
		# return loaded_model
	# else:
		# loaded_model = load_model(model_name)
		# return loaded_model
		
		
def visualize_loss_accuracy(hist,save=False,loss_figure_name="loss.png",acc_figure_name="accuracy.png" ):
	train_loss = hist.history['loss']
	val_loss = hist.history['val_loss']
	train_acc = hist.history['acc']
	val_acc = hist.history['val_acc']
	xc = len(train_loss)
	xc = np.linspace(0, xc, num=xc,endpoint=False)
    
	fig1 = plt.figure(1, figsize=(7, 5))
	plt.plot(xc, train_loss)
	plt.plot(xc, val_loss)
	plt.xlabel('num of Epochs')
	plt.ylabel('loss')
	plt.title('train_loss vs val_loss')
	plt.grid(True)
	plt.legend(['train', 'val'])
	# print plt.style.available # use bmh, classic,ggplot for big pictures
	plt.style.use(['classic'])
	fig1.savefig(loss_figure_name)

	fig2 = plt.figure(2, figsize=(7, 5))
	plt.plot(xc, train_acc)
	plt.plot(xc, val_acc)
	plt.xlabel('num of Epochs')
	plt.ylabel('accuracy')
	plt.title('train_acc vs val_acc')
	plt.grid(True)
	plt.legend(['train', 'val'], loc=4)
	# print plt.style.available # use bmh, classic,ggplot for big pictures
	plt.style.use(['classic'])
	fig2.savefig(acc_figure_name)
	

	
def model_evaluate(model, X_test, y_test=None, preproceced_image=False):
	pass
	# score=[]
	# if y_test!=None and preproceced_image:
		# Returns the loss value & metrics values for the model in test mode.
		# score = model.evaluate(X_test, y_test, show_accuracy=True, verbose=0)

		# test_image = X_test[0:1]
		# print(test_image.shape)
		
		# Generates output predictions for the input samples.
		# predicted_result = model.predict(X_test)
		# print(model.predict_classes(test_image))
		# print(y_test[0:1])
		# return score, predicted_result
		
	# elif y_test==None and preproceced_image:
		
		# Generates output predictions for the input samples.
		# predicted_result = model.predict(X_test)
		# print(model.predict_classes(test_image))
		# print(y_test[0:1])
		# return  score, predicted_result
	
	# elif y_test==None and preproceced_image==False:
		# convert to single prescion
		# test_images = X_test.astype('float32')
		# Normalize
		# test_images /=255
		
		# Generates output predictions for the input samples.
		# predicted_result = model.predict(test_images)
		# print(model.predict_classes(test_image))
		# print(y_test[0:1])
		# return  score, predicted_result
		
	# elif y_test!=None and preproceced_image==False:
		# convert to single prescion
		# test_images = X_test.astype('float32')
		# Normalize
		# test_images /=255
		
		# score = model.evaluate(X_test, y_test, show_accuracy=True, verbose=0)
		# test_image = X_test[0:1]
		# print(test_image.shape)

		# Generates output predictions for the input samples.
		# Generates output predictions for the input samples.
		# predicted_result = model.predict(test_images)
		# print(model.predict_classes(test_image))
		# print(y_test[0:1])
		# return  score, predicted_result		

def get_layer_featuremaps(model, layer_idx, X_batch):
	pass
    # get_activations = K.function([model.layers[0].input, K.learning_phase()], [model.layers[layer_idx].output, ])
    # activations = get_activations([X_batch, 0])
    # return activations		
	

def visualize_intermidiate_layer_f_map(model, test_image, layer_idx=0):
	pass
	# activations = get_layer_featuremaps(model, layer_idx, test_image)
	# print(np.shape(activations))
	# feature_maps = activations[0][0]
	# print(np.shape(feature_maps))
    #
	# # if K.image_dim_ordering() == 'th':
	# # feature_maps = np.rollaxis((np.rollaxis(feature_maps, 2, 0)), 2, 0)
	# # print(feature_maps.shape)
    #
	# # fig = plt.figure(figsize=(16, 16))
	# # plt.imshow(feature_maps[:, :, filter_num], cmap='gray')
	# # plt.savefig("featuremaps-layer-{}".format(layer_num) + "-filternum-{}".format(filter_num) + '.jpg')
    #
	# num_of_featuremaps = feature_maps.shape[2]
	# fig = plt.figure(figsize=(16, 16))
	# plt.title("featuremaps-layer-{}".format(layer_num))
	# subplot_num = int(np.ceil(np.sqrt(num_of_featuremaps)))
	# for i in range(int(num_of_featuremaps)):
	# ax = fig.add_subplot(subplot_num, subplot_num, i + 1)
	# # ax.imshow(output_image[0,:,:,i],interpolation='nearest' ) #to see the first filter
	# ax.imshow(feature_maps[:, :, i], cmap='gray')
	# plt.xticks([])
	# plt.yticks([])
	# plt.tight_layout()
	# plt.show()
	# fig.savefig("featuremaps-layer-{}".format(layer_num) + '.jpg')


def compute_confusion_matrix(y_test, y_pred):
	cnf_matrix = (confusion_matrix(y_test, y_pred))
	return cnf_matrix


# Plotting the confusion matrix
def plot_save_confusion_matrix(cm, classes, name='confusion matrix.png',
                          normalize_=False,
                          title='Confusion matrix',cmap=plt.cm.Blues):

	fig = plt.figure()
	plt.imshow(cm, interpolation='nearest', cmap=cmap)
	plt.title(title)
	plt.colorbar()
	tick_marks = np.arange(len(classes))
	plt.xticks(tick_marks, classes, rotation=45)
	plt.yticks(tick_marks, classes)

	if normalize_:
		cm = cm.astype('float') / cm.sum(axis=1)[:, np.newaxis]
		print("Normalized confusion matrix")
	else:
		print('Confusion matrix, without normalization')

	print(cm)

	thresh = cm.max() / 2.
	for i, j in itertools.product(range(cm.shape[0]), range(cm.shape[1])):
		plt.text(j, i, cm[i, j],
				 horizontalalignment="center",
				 color="white" if cm[i, j] > thresh else "black")

	plt.tight_layout()
	plt.ylabel('True label')
	plt.xlabel('Predicted label')
	fig.savefig(name)

def get_mnist_data(reduce=False):

	#Load pre-shuffled MNIST data into train and test sets
	(X_train, y_train), (X_test, y_test) = mnist.load_data()
	#print (X_train.shape)


	# plt.imshow(X_train[0])

	X_train = X_train.reshape(X_train.shape[0], 1, 28, 28)
	X_test = X_test.reshape(X_test.shape[0], 1, 28, 28)


	# print (X_train.shape)

	X_train = X_train.astype('float32')
	X_test = X_test.astype('float32')
	X_train /= 255
	X_test /= 255


	if reduce:
		a = int (X_train.shape[0])//20
		b = int (X_test.shape[0])//20
		
		X_train= X_train[0:a ,0,:,:]
		X_train = np.expand_dims(X_train,axis=1)
		y_train = y_train[0:a]

		y_test = y_test[0:b]
		X_test = X_test [0:b, 0, :, :]
		X_test = np.expand_dims(X_test,axis=1)

	# Convert 1-dimensional class arrays to 10-dimensional class matrices
	Y_train = np_utils.to_categorical(y_train, 10)
	Y_test = np_utils.to_categorical(y_test, 10)

	return X_train, X_test , Y_train, Y_test
		
