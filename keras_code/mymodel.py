

from keras.layers import Input, Dense, Conv2D, MaxPool2D,merge,\
    Dropout,Flatten, Activation

from keras.models import Model
from customlayers import splittensor

def my_model_def (input_dim = (3,128,128), nb_classes=3):
    # MOdel Definition
    inputs = Input(shape=input_dim)

    conv1 = Conv2D(96, (7, 7), padding='same', activation='relu', strides=(1, 1), kernel_initializer='he_normal')(
        inputs)
    pool1 = MaxPool2D(pool_size=(2, 2), strides=(2, 2))(conv1)

    conv2 = merge([Conv2D(128, (5, 5), activation="relu", padding='same', kernel_initializer='he_normal',
                          name='conv2_' + str(i + 1))(
        splittensor(ratio_split=2, id_split=i)(conv1)) for i in range(2)], mode='sum', concat_axis=1, name='conv2')

    conv2 = Conv2D(128, (5, 5), activation="relu", padding='same', kernel_initializer='he_normal')(conv2)
    pool2 = MaxPool2D(pool_size=(2, 2), strides=(2, 2))(conv2)

    conv3 = Conv2D(256, (3, 3), strides=(2, 2), padding='same', activation='relu', kernel_initializer='he_uniform')(
        conv2)
    conv3 = Dropout(rate=0.5, seed=10)(conv3)
    conv3 = MaxPool2D(pool_size=(2, 2), strides=(2, 2))(conv3)

    dense1 = Flatten(name="flatten")(conv1)
    dense1 = Dense(4096, activation='relu', kernel_initializer='he_normal')(dense1)
    dense1 = Dropout(0.5)(dense1)

    dense2 = Dense(4096, activation='relu', kernel_initializer='he_normal')(dense1)
    dense2 = Dropout(rate=0.5)(dense2)

    dense3 = Dense(nb_classes, name='dense3_new', kernel_initializer='he_normal')(dense2)

    prediction = Activation("softmax")(dense3)

    model = Model(inputs=inputs, outputs=prediction)

    return model