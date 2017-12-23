# Saving and loading model and weights
from keras.models import model_from_json
from keras.models import load_model


#%% Save model

def model_save():
	# serialize model to JSON
	model_json = model.to_json()
	with open("model.json", "w") as json_file:
		json_file.write(model_json)
	# serialize weights to HDF5
	model.save_weights("model.h5")
	print("Saved model to disk")

	def model_load(name_model, name_weight = None):
	# load json and create model
	json_file = open('model.json', 'r')
	loaded_model_json = json_file.read()
	json_file.close()
	loaded_model = model_from_json(loaded_model_json)
	# load weights into new model
	loaded_model.load_weights("model.h5")
	print("Loaded model from disk")

	model.save('model.hdf5')
	loaded_model = load_model('model.hdf5')