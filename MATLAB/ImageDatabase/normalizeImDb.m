function normalizeImDb()
	% load database to be normalized
	load('imdb.mat');
	data = imdb.images.data;

	im_mean = imdb.images.data_mean;
	N  = 255; 

	% subtract the mean: zeros mean
	data = bsxfun(@minus, data, im_mean);
	% Normalize: [-1 1]
	data = bsxfun(@rdivide, data, N);
	imdb.images.data = data;
	save('imdb_norm_zero_center.mat','imdb','-v7.3');
end
