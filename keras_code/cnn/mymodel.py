

from keras.layers import Input, Dense, Conv2D, MaxPool2D,\
    Dropout,Flatten, Activation
from keras.layers.normalization import BatchNormalization
from keras.layers.merge import Concatenate

from keras.models import Model
from customlayers import splittensor



def my_model_def (input_dim = (3,128,128), nb_classes=3,drop_out = 0.5, fmap_size =[128,500,4096]):
    # MOdel Definition
    inputs = Input(shape=input_dim,name='input')

    conv1 = Conv2D(96, (7, 7), padding='same', activation='relu', strides=(1, 1),
			kernel_initializer='he_normal',name='conv1')(inputs)
    pool1 = MaxPool2D(pool_size=(3, 3), strides=(2, 2),padding='same',name='pool1')(conv1)



    concat2 = Concatenate(axis=1, name='concat1')([Conv2D(48, (5, 5), activation="relu", strides=(2, 2),
			padding='same',kernel_initializer='he_normal',name='conv2_' + str(i + 1))
			(splittensor(ratio_split=2, id_split=i)(pool1)) for i in range(2)])
    pool2_1 = MaxPool2D(pool_size=(3, 3), strides=(2, 2),padding='same',name='pool2_1')(concat2)
    
    conv2 = Conv2D(384, (5, 5), activation="relu", padding='same',strides=(2, 2),
			kernel_initializer='he_normal',name='conv2_3')(pool2_1)
    pool2_2 = MaxPool2D(pool_size=(3, 3), strides=(2, 2),padding='same',name='pool2_2')(conv2)

    concat3 = Concatenate(axis=1, name='concat3')([Conv2D(fmap_size[0], (5, 5), activation="relu", strides=(2, 2),
			padding='same',kernel_initializer='he_normal',name='conv3_' + str(i + 1))
			(splittensor(ratio_split=2, id_split=i)(pool2_2)) for i in range(2)])
    pool3 = MaxPool2D(pool_size=(3, 3), strides=(2, 2),padding='same',name='pool3')(concat3)
    
#    conv3 = Conv2D(250, (3, 3), strides=(2, 2), padding='same', activation='relu',
#                   kernel_initializer='he_normal', name='conv3_1')(pool2_2)
#    pool3 = MaxPool2D(pool_size=(3, 3), strides=(1, 1), padding='same', name='conv3_2')(conv3)

    conv4 = Conv2D(fmap_size[1], (3, 3), strides=(2, 2), padding='same', activation='relu',
                   kernel_initializer='he_normal', name='conv4_1')(pool3)
    pool4 = MaxPool2D(pool_size=(3, 3), strides=(1, 1), padding='same', name='pool4')(conv4)
    drop4 = Dropout(rate=drop_out, seed=10, name='drop4')(pool4)
    

    flatten5 = Flatten(name="flatten")(drop4)
    dense5 = Dense(fmap_size[2], activation='relu', kernel_initializer='he_normal',name='dense5')(flatten5)
    drop5 = Dropout(rate=drop_out-0.3)(dense5)

    dense6 = Dense(fmap_size[2], activation='relu', kernel_initializer='he_normal', name='dense6_1')(drop5)
    dense6 = Dense(nb_classes, kernel_initializer='he_normal', name='dense6_2')(dense6)
    prediction = Activation("softmax",name='softmax_act')(dense6)

    model = Model(inputs=inputs, outputs=prediction)

    return model

if __name__ == '__main__':
    input_dim = (3,128,128)
    nb_classes=3
    model = my_model_def (input_dim = input_dim, nb_classes=nb_classes)
    print(model.summary())