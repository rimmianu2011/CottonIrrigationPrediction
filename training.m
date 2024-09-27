%{
FINAL PROJECT

Eshaan Jayant Deshpande, ed6939@rit.edu
Anushka Yadav, ay4034@rit.edu
Vedika Vishwanath Painjane, vp2312@rit.edu

File Name: training.m
%}

% This program trains a convolutional neural network on a dataset, evaluates 
% its performance on a test set, creates a confusion matrix, and saves the 
% trained network.
function training()

% Load the image datastore
load('imds.mat', 'imds');

% Split the data into training and testing sets (70/30 split)
[trainImds, testImds] = splitEachLabel(imds, 0.7, 'randomized');

% Define the neural network with the following layers
layers = [    
    % Input layer for images of size 149 x 149 with 3 color channels
    imageInputLayer([149 149 3])
    
    % Convolution layer with 16 filters, kernel size of 3 x 3 and padding
    convolution2dLayer(3,16,'Padding','same')
    % Batch normalization layer to normalize the output of previous layer
    batchNormalizationLayer
    % ReLU activation function to introduce non-linearity
    reluLayer
    
    % Max pooling layer with a pool size of 2 x 2 and stride of 2
    maxPooling2dLayer(2,'Stride',2)
    
    % Convolution layer with 32 filters, kernel size of 3 x 3 and padding
    convolution2dLayer(3,32,'Padding','same')
    % Batch normalization layer to normalize the output of previous layer
    batchNormalizationLayer
     % ReLU activation function to introduce non-linearity
    reluLayer
    
    % Max pooling layer with a pool size of 2 x 2 and stride of 2
    maxPooling2dLayer(2,'Stride',2)
    
    % Convolution layer with 64 filters, kernel size of 3 x 3 and padding
    convolution2dLayer(3,64,'Padding','same')
    % Batch normalization layer to normalize the output of previous layer
    batchNormalizationLayer
    % ReLU activation function to introduce non-linearity
    reluLayer
    
    % Fully connected layer with 4 output neurons
    fullyConnectedLayer(4)
    % Softmax layer to convert output to probabilities
    softmaxLayer
    % Classification layer to compute the cross-entropy loss function
    classificationLayer
   ];



% Define the training options
% here the epoch value is set to 10 and the Batch size is 32.
options = trainingOptions('sgdm', ...
    'MiniBatchSize', 32, ...
    'MaxEpochs', 10, ...
    'InitialLearnRate', 0.001, ...
    'Shuffle', 'every-epoch', ...
    'Verbose', true, ...
    'Plots', 'training-progress');


% The training images and their labels are stored in an ImageDatastore 
% object called 'trainImds'.
% The 'trainNetwork' function is used to train the CNN with the training 
% data and the network architecture specified by 'layers'.
net = trainNetwork(trainImds, layers, options);

% Evaluate the performance of the neural network on the test set
% Use the pre-trained neural network 'net' to classify the images in the
% test set 'testImds'
predLabels = classify(net, testImds);
% Compute the classification accuracy of the network on the test set.
accuracy = mean(predLabels == testImds.Labels);
% Display the classification accuracy
disp(['Accuracy: ' num2str(accuracy)]);

% Create the confusion matrix using the true labels and the predicted
% labels and the predicted labels
confMat = confusionmat(testImds.Labels, predLabels);

% Define classes that correspond to the different labels in the confusion
% matrix
classes = ["class1", "class2", "class3", "class4"];

% Create a confusion matrix plot using the 'confusionchart' function from
% the MATLAB Deep Learning Toolbox
figure;
cm = confusionchart(confMat, classes, 'Normalization', 'row-normalized');
cm.Title = 'Confusion Matrix for 4 Classes';
colormap(jet);

% Save the trained network to a file called 'trained_network.mat'
save('trained_network.mat', 'net');

end