import numpy as np
import pandas as pd
import tensorflow as tf
from tensorflow.keras.models import Model
from tensorflow.keras.layers import Conv2D, BatchNormalization
from keras.models import load_model

model = tf.keras.models.load_model(f'/home/jialun/unetplus_model.keras')
model.summary()
base_path = '/home/jialun/keydoc/ww3_python/pyfiles/'

data_input_test = pd.read_csv(f'{base_path}input_test.csv', header=None)
data_input_dia_test = pd.read_csv(f'{base_path}input_dia_test.csv', header=None)
data_input_test = data_input_test.to_numpy().reshape(data_input_test.shape[0], 40, 24)
data_input_test = data_input_test.transpose(0, 2, 1)[:,:,:40]
data_input_dia_test = data_input_dia_test.to_numpy().reshape(data_input_dia_test.shape[0], 40, 24)
data_input_dia_test = data_input_dia_test.transpose(0, 2, 1)[:,:,:40]
data_input_testsk = np.stack([data_input_test,data_input_dia_test], axis=-1)

spec_norm1 = 0.10981746675383443
snl_norm1 = 0.08250960527868294
predictions = model.predict(data_input_testsk/spec_norm1)
predictions = predictions * snl_norm1
array_squeezed = predictions.squeeze()
array_flattened = array_squeezed.reshape(24,40)

pd.DataFrame(array_flattened).to_csv('/home/jialun/keydoc/ww3_python/pyfiles/pred.csv', index=False, header=None)

