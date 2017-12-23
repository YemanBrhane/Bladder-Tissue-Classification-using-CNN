function localImages  = createSmallDB(folder)
	
    p = randperm(K,N);
    % localImages go here
    localImages.data = zeros(H, W, CH, N, 'single'); % array dimensions restriction
    % this will contain the mean of the training set
    localImages.data_mean = zeros(H, W, CH, 'single');
    % a label per image
    localImages.labels = zeros(1, N);
    % vector indicating to which set an image belong, i.e.,
    % training, validation, etc.
    localImages.set = zeros(1, N);
    localImages. numImgsTrain = 0;

    numImgsTrain = 0;
    % loading positive samples
    for i=1:N
        index  = p(i);
        im = single (im_patches(index).patch);
        
        % add to struct
        localImages.data(:,:,:, i) = im;
        localImages.labels(i) = lable;

        % in this case we select the set (train/val) randomly
        %if(randi(10, 1) < 8)
        if(~ismember(patient_num,validation_patient))
            localImages.set(i) = 1; %training
            localImages.data_mean = localImages.data_mean + im;
            numImgsTrain = numImgsTrain + 1;
        else
            localImages.set(i) = 2;% validation
        end
    end
    localImages. numImgsTrain = numImgsTrain;

end