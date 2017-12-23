
#from create_database_edited_aug import create_database
#
#data_folders  = ['F:/Project_Files/code_python/python_patches_folder/patches_0/train',
#                 'F:/Project_Files/code_python/python_patches_folder/patches_45/train',
#                 'F:/Project_Files/code_python/python_patches_folder/patches_lr/train']
#
#
#create_database(muscle_per=0.11695742282,cancer_per=0.0494670420885,
#                normal_per=0.0164029401942, total=150000,
#                data_path_=data_folders)

from sklearn.utils import shuffle
import numpy as np

print('loading')
training_data = np.load('../data/agumented/training_data.npz')
training_images = training_data['images']
training_labels = training_data['labels']

print('shfuffling')
training_images, training_labels = shuffle(training_images, training_labels,random_state=10)
training_images, training_labels = shuffle(training_images, training_labels,random_state=50)
np.savez('training_data_shuffled.npz', images= training_images,labels=training_labels)