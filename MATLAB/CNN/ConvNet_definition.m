function [net, info] = ConvNet_definition(imdb,param, expDir)

    home = pwd; 
    cd ../; cd ../;
    convSetup = fullfile(pwd, 'matconvnet_24\matlab', 'vl_setupnn.m');
	run(convSetup) ;
    cd(home);

	% some common options
	opts.train.batchSize = 50;%100
	opts.train.numEpochs = 70 ; %20
	opts.train.continue = true ;
	opts.train.gpus = 1 ;
	opts.train.learningRate = [param.lr*ones(1, 30),  1e-3*ones(1, 100)];
	opts.train.weightDecay = 3e-4;
	opts.train.momentum = 0.;
	opts.train.expDir = expDir;
	opts.train.numSubBatches = 10;
	% getBatch options
	bopts.useGpu = numel(opts.train.gpus) >  0 ;


	% network definition!
	% MATLAB handle, passed by reference
	
	%% feature map (FM) parameters passed to function
	FM1 = param.InFeatureMapSize; % 96
	FM2 = param.intermidiateFeatureMapSize; % 500
	FM3 = param.fullyconnectedFeatureMapSize ; % 4096
    
    %% Filter sise(FS) parameters passed to function
	f  = param.InputFilterSize;
    p2  = (f-1)/2;
    %% Filter sise(FS) parameters passed to function
	d = param.dropOut;
	%% Network definition
	net = dagnn.DagNN() ;
	
	net.addLayer('conv1', dagnn.Conv('size', [f f 3 FM1], 'hasBias', true, 'stride', [4, 4], 'pad', [20 20 20 20]), {'input'}, {'conv1'},  {'conv1f'  'conv1b'});
	net.addLayer('relu1', dagnn.ReLU(), {'conv1'}, {'relu1'}, {});
	net.addLayer('lrn1', dagnn.LRN('param', [5 1 2.0000e-05 0.7500]), {'relu1'}, {'lrn1'}, {});
	net.addLayer('pool1', dagnn.Pooling('method', 'max', 'poolSize', [3, 3], 'stride', [2 2], 'pad', [0 0 0 0]), {'lrn1'}, {'pool1'}, {});

	net.addLayer('conv2', dagnn.Conv('size', [f-2 f-2 FM1/2 256], 'hasBias', true, 'stride', [1, 1], 'pad', [p2 p2 p2 p2]), {'pool1'}, {'conv2'},  {'conv2f'  'conv2b'});
	net.addLayer('relu2', dagnn.ReLU(), {'conv2'}, {'relu2'}, {});
	net.addLayer('lrn2', dagnn.LRN('param', [5 1 2.0000e-05 0.7500]), {'relu2'}, {'lrn2'}, {});
	net.addLayer('pool2', dagnn.Pooling('method', 'max', 'poolSize', [3, 3], 'stride', [2 2], 'pad', [0 0 0 0]), {'lrn2'}, {'pool2'}, {});
	
	net.addLayer('conv5', dagnn.Conv('size', [f-4 f-4 256 FM2], 'hasBias', true, 'stride', [2, 2], 'pad', [1 1 1 1]), {'pool2'}, {'conv5'},  {'conv5f'  'conv5b'});
	net.addLayer('relu5', dagnn.ReLU(), {'conv5'}, {'relu5'}, {});
	net.addLayer('pool5', dagnn.Pooling('method', 'max', 'poolSize', [3 3], 'stride', [2 2], 'pad', [0 0 0 0]), {'relu5'}, {'pool5'}, {});
	
	
	net.addLayer('fc6', dagnn.Conv('size', [1 1 FM2 FM3], 'hasBias', true, 'stride', [1, 1], 'pad', [0 0 0 0]), {'pool5'}, {'fc6'},  {'conv6f'  'conv6b'});
	net.addLayer('relu6', dagnn.ReLU(), {'fc6'}, {'relu6'}, {});
	net.addLayer('drop6', dagnn.DropOut('rate',d),{'relu6'},{'drop6'},{})


	
	net.addLayer('classifier', dagnn.Conv('size', [1 1 FM3 3], 'hasBias', true, 'stride', [1, 1], 'pad', [0 0 0 0]), {'drop6'}, {'classifier'},  {'conv8f'  'conv8b'});
	net.addLayer('prob', dagnn.SoftMax(), {'classifier'}, {'prob'}, {});
	net.addLayer('objective', dagnn.Loss('loss', 'log'), {'prob', 'label'}, {'objective'}, {});
	net.addLayer('error', dagnn.Loss('loss', 'classerror'), {'prob','label'}, 'error') ;


	% initialization of the weights

	initNet_He(net)

	% do the training!
	info = cnn_train_dag_sgd(net, imdb, @(i,b) getBatch(bopts,i,b), opts.train, 'val', find(imdb.images.set == 2)) ;
end


