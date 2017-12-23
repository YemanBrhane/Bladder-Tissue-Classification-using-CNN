import os
import numpy as np
import scipy.io as sio
import random

# data_path = 'F:\Patches'
data_path = 'F:\Project_Files\Code\patchesFolder\python'

data_dir_list = os.listdir(data_path)
numRows = 128
numCols = 128
numChannels = 3
# img_data_list=[]
# total = 35000

def create_training_database( muscle_per, cancer_per, normal_per, total):
    i=0
    label = np.ndarray((total,1), dtype=np.int)
    imagesSaved = np.ndarray((total, numChannels, numRows, numCols), dtype=np.uint8)
    for dataset_dir in data_dir_list:  # this for patient number
        print('procesing ', dataset_dir)
        # patch_type_list = os.listdir(data_path +'/' + dataset_dir )
        patch_type_list  = os.listdir(os.path.join(data_path,dataset_dir))
        for patchs_type in patch_type_list: # cancer, normal and muscle folders
            patchs  = os.listdir(os.path.join(data_path,dataset_dir,patchs_type))
            patchs_type_dir = os.path.join(data_path , dataset_dir, patchs_type )
            for patch in patchs:
                patch_dir  = os.path.join(patchs_type_dir , patch)
                mat_contents = sio.loadmat(patch_dir) # load mat file

                value = mat_contents['data']

                #print('Shape of your data is ', value.shape)
                N,M = value.shape
                if patchs_type=='normal':
                    percent = normal_per
                elif  patchs_type=='cancer':
                    percent = cancer_per
                elif patchs_type=='muscle':
                    percent =muscle_per ;
                K  = round(M * percent)
                selected_patch_index= random.sample(range(M), K)
                all_patches = value['patch']
                for index in selected_patch_index:
                    # image = np.array([all_patches[0,index]], )
                    image  = all_patches[0,index]
                    image = np.rollaxis(image, 2, 0)
                    if i>=total: # since we are using round the index can be > total
                        break
                    imagesSaved[i] = image
                    if patchs_type == 'normal':
                        label[i] = 0
                    elif patchs_type == 'cancer':
                        label[i] = 1
                    elif patchs_type == 'muscle':
                        label[i] = 2
                    i=  i + 1
                    # img_data_list.append( all_patches[0,index])

    print('loading data done!')
    imagesSaved  = imagesSaved[0:i-1,:,:,:]
    label  = label[0:i-1,:]
    print('size of the whole dataset and label  is: ', imagesSaved.shape, label.shape)
    print('saving data..')
    np.save('trainData.npy', imagesSaved)
    np.save('trainLabel.npy', label)
    print('number of patches: ', i)
    print('Saving to .npy files done.')

def do_patch_statistics():
    # do do the statistics
    num_cancer = 0
    num_normal = 0
    num_muscle = 0
    for dataset_dir in data_dir_list:  # this for patient number
        print('procesing ', dataset_dir)
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
                    num_cancer +=M

                elif patchs_type =='normal':
                    num_normal +=M
                elif patchs_type == 'muscle':
                    num_muscle +=M
    muscle_per = 33000/num_muscle
    cancer_per = 33000 / num_cancer
    normal_per = 33000/ num_normal
    total = (int)(round(muscle_per * num_muscle) + round(normal_per * num_normal)+ \
    round(cancer_per,num_cancer))

    return (muscle_per,cancer_per, normal_per, total )

if __name__ == '__main__':
    print('Computing patches statistics ')
    muscle_per, cancer_per, normal_per, total= do_patch_statistics()

    print('Create training dataset')
    create_training_database( muscle_per, cancer_per, normal_per, total)
    print('loading saved data')
    data = np.load('trainData.npy')
    print('shape of loaded data',data.shape)