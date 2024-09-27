%{
FINAL PROJECT

Eshaan Jayant Deshpande, ed6939@rit.edu
Anushka Yadav, ay4034@rit.edu
Vedika Vishwanath Painjane, vp2312@rit.edu

File Name: predict.m
%}


% This file predicts results for images in folder images_for_prediction
% Please upload the testing images to this folder and run this code
% This code uses the trained network model saved in trained_network.mat

function predict()
% Load the trained network
load('trained_network.mat', 'net')

% The threshold value for the red channel is set to 114. This value was
% decided by us after a lot of trial n error.
% The threshold values for the other two channels is set to 0.
red_threshold = 114;
green_threshold = 0;
blue_threshold = 0;

% Define structuring element
SE = strel('disk', 2);

% name of the folder where the images will be stored for prediction
file_list = dir('images_for_prediction/*.TIF');

for counter = 1 : length( file_list )
    fn = file_list(counter).name;
    fprintf('Processing Image:  %s \n', fn);
    directory = 'images_for_prediction/';
    img = imread(append(directory,fn));
    rgbImage = img(:,:,1:3);

    % extracts all the three color channels
    red = rgbImage(:,:,1);
    green = rgbImage(:,:,2);
    blue = rgbImage(:,:,3);

    % create binary mask 
    red_mask = (red < red_threshold) & (green > green_threshold) & (blue > blue_threshold);

    % apply mask to original image
    red_img = rgbImage .* uint8(repmat(red_mask, [1 1 3]));
    gray_image = rgb2gray(red_img);
    binary_img = imbinarize(gray_image);
    binary_img = imcomplement(binary_img);

    % Perform morphological operations
    bwarea = ~bwareaopen(~binary_img, 100);
    eroded = imerode(bwarea, SE);
    opened = imopen(eroded, SE);
    eroded = imerode(opened, SE);
    dilate = imdilate(eroded, SE);

    rgbImage(repmat(dilate, [1 1 3])) = 0;

    % Resize the image according to NN layers
    inputSize = net.Layers(1).InputSize;
    resized_img = imresize(rgbImage, [inputSize(1), inputSize(2)]);

    % Predict the label of the image using the loaded network
    label = classify(net, resized_img);

    predicted_class = '';

    % Get irrigation value associated with the class
    switch char(label)
        case '1'
            predicted_class = 'Rainfed';
        case '2'
            predicted_class = 'Fully irrigated';
        case '3'
            predicted_class = 'Percent deficit';
        case '4'
            predicted_class = 'Time delay';
    end
    
    % Display the predicted label
    figure,
    imshow(rgbImage);
    str_cat = strcat({'The treatment used should be: '}, {predicted_class});
    title(str_cat);

end
end