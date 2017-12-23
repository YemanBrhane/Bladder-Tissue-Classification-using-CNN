import os
import numpy as np
import scipy.io as sio
import random

# preprocessing
from sklearn import preprocessing

# choose which dataset you want to create_database
create_training_db= True  # if False create validation database

# data_path = 'F:\Patches'
#data_path = 'D:/amc-project/Code/patchesFolder/python'
if create_training_db:
	num_patch_per_class = 25000	
	print ('creating training database')
	data_path = 'F:/Project_Files/code_python/python_patches_folder/patches_0/training'
	db_name = 'training_data.npz'
else:
	print ('creating validation database')
	data_path = 'F:/Project_Files/Code/Python/python_patches_folder/validation'
	db_name = 'validation_data.npz'
	num_patch_per_class = 10000


numRows = 128
numCols = 128
numChannels = 3


# img_data_list=[]
# total = 35000

def create_database(muscle_per, cancer_per, normal_per, total,data_path_= data_path):
	i = 0
	label = np.ndarray((total, 1), dtype=np.int)
	images_array = np.ndarray((total, numChannels, numRows, numCols), dtype=np.uint8)

	for folder in range(len(data_path_)):
		data_path = data_path_[folder]
		print(data_path)
		data_dir_list = os.listdir(data_path)

		for dataset_dir in data_dir_list:  # this for patient number
			print('patch: ', dataset_dir)
			# patch_type_list = os.listdir(data_path +'/' + dataset_dir )
			patch_type_list = os.listdir(os.path.join(data_path, dataset_dir))
			for patchs_type in patch_type_list:  # cancer, normal and muscle folders
				patchs = os.listdir(os.path.join(data_path, dataset_dir, patchs_type))
				patchs_type_dir = os.path.join(data_path, dataset_dir, patchs_type)
				for patch in patchs:
					print(patch)
					patch_dir = os.path.join(patchs_type_dir, patch)
					mat_contents = sio.loadmat(patch_dir)  # load mat file

					value = mat_contents['data']

				   #print('Shape of your data is ', value.shape)
					N, M = value.shape
					if patchs_type == 'normal':
						percent = normal_per
					elif patchs_type == 'cancer':
						percent = cancer_per
					elif patchs_type == 'muscle':
						percent = muscle_per;
					K = round(M * percent)
					selected_patch_index = random.sample(range(M), K)
					all_patches = value['patch']
					for index in selected_patch_index:
						# image = np.array([all_patches[0,index]], )
						image = all_patches[0, index]
						image = np.rollaxis(image, 2, 0)
						if i >= total:  # since we are using round the index can be > total
							break

						image = image_standardize(image, 'normalize only')
						images_array[i] = image
						if patchs_type == 'normal':
							label[i] = 0
						elif patchs_type == 'cancer':
							label[i] = 1
						elif patchs_type == 'muscle':
							label[i] = 2
						i = i + 1
						# img_data_list.append( all_patches[0,index])
                        

    
	print('loading data done!')
	images_array = images_array[0:i-1, :, :, :]
	label = label[0:i-1,:]
	print('size of the whole dataset and label  is: ', images_array.shape, label.shape)
	# print('saving data..')
	# np.save('trainData.npy', images_array)
	# print('number of patches: ', i)
	# print('Saving to .npy files done.')
    print('shfuffling')
    images_array, training_labels = shuffle(images_array, label,random_state=10)
    images_array, label = shuffle(images_array, label,random_state=50)
	np.savez(db_name, images=images_array, labels=label) #zipped
	print(data_path)
	print(dataset_dir)
	print(patchs_type)
	print(patch)
	#training_data.seek(0) # close file


def do_patch_statistics():
    data_dir_list = os.listdir(data_path)
    # do do the statistics
    num_cancer = 0
    num_normal = 0
    num_muscle = 0
    for dataset_dir in data_dir_list:  # this for patient number
        print('patch: ', dataset_dir)
        # patch_type_list = os.listdir(data_path +'/' + dataset_dir )
        patch_type_list = os.listdir(os.path.join(data_path, dataset_dir))
        for patchs_type in patch_type_list:  # cancer, normal and muscle folders
            patchs = os.listdir(os.path.join(data_path, dataset_dir, patchs_type))
            patchs_type_dir = os.path.join(data_path, dataset_dir, patchs_type)
            for patch in patchs:
                patch_dir = os.path.join(patchs_type_dir, patch)
                mat_file = sio.loadmat(patch_dir)  # load mat file
                value = mat_file['data']
                # print('Shape of your data is ', value.shape)
                N, M = value.shape
                if patchs_type == 'cancer':
                    num_cancer += M
    
                elif patchs_type == 'normal':
                    num_normal += M
                elif patchs_type == 'muscle':
                    num_muscle += M
    
    	# save patch numbers
    name= 'patch_0_stat.npz'
    np.savez(name, num_muscle=num_muscle, num_normal=num_normal,num_cancer=num_cancer ) #zipped
    print('patche statistics saved')
    # compute percentage                
    muscle_percent = num_patch_per_class / num_muscle
    cancer_percent = num_patch_per_class / num_cancer
    normal_percent = num_patch_per_class / num_normal
    total_ = int(round(muscle_percent * num_muscle) + round(normal_percent * num_normal) + \
             round(cancer_percent*num_cancer))
    
    return muscle_percent, cancer_percent, normal_percent, total_


def image_standardize(image, method='normalize only'):
    #  pass
    if method == 'normalize only':
        return image / 255
    else:
        return preprocessing.scale(image)  # mean and std


if __name__ == '__main__':
    print('Computing patches statistics ')
    muscle_per, cancer_per, normal_per, total = do_patch_statistics()

    # print('Create training dataset')
    create_database(muscle_per, cancer_per, normal_per, total)
    # print('loading saved data')
    # data = np.load('trainData.npy')
    # print('shape of loaded data', data.shape)
    # training_data = np.load('training_data.npz')
    # training_images = training_data['images']
    # training_labels = training_data['labels']
