
import numpy as np

import math
from  supporting_func import model_evaluate
model_name = ''
def dummy(I):
	row,col = I.shape[0:1]
	# patch size
	p_row = 128
	p_col = 128
	#%% number of overlaping patches
	# in row direction
	# in row direction
	num_patches_row =int(math.floor((row * 2 * 1/p_row)) - 1)
	#in column direction
	num_patches_col = int(math.floor((col * 2 * 1/p_col)) - 1)

	#extract patches
	stride  = [ p_row/2 , p_col/2]



	out = np.zeros((num_patches_row, num_patches_col, 3));


	for R in range(num_patches_row):
		for W in range(num_patches_col):
			# if patch is boundary patch
			if R==1 and W==1:
				patch =I[1:R ,1:W,: ]
			else:
				patch =I[(R-1)*stride[0]/2 +1  : (R+1)*stride[0]/2,(W-1)*stride[1]/2 + 1: (W+1)*stride[1]/2,:]

			# call cnn
			result= cnnEvaluate (patch);
			out[R,W,1] = result[0]
			out[R,W,2] = result[1]
			out[R,W,3] = result[2]

def cnnEvaluate(image_in):
	model = model_load(model_name = model_name,model_weight_name=None, model_weight_separate= False )

	# evaluate the model
	model_evaluate(model=model, y_test=None, preproceced_image=False)
