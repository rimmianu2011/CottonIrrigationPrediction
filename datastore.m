%{
FINAL PROJECT

Eshaan Jayant Deshpande, ed6939@rit.edu
Anushka Yadav, ay4034@rit.edu
Vedika Vishwanath Painjane, vp2312@rit.edu

File Name: datastore.m
%}


% This code is used for creating an ImageDatastore object and assigning 
% labels to the images. It prepares the images and labels for use in a 
% machine learning model.
function datastore()

% Loads the CSV file with the labels
labels = readtable('final_labels.csv');

% this line defines the image directory
img_dir = 'processed_images/';

% Creates an imageDatastore for the images
imds = imageDatastore(img_dir);

% set ReadFcn to read and resize images
imds.ReadFcn = @(filename)readAndResizeImage(filename); 

% this function resizes the image to [149, 149]
function img = readAndResizeImage(filename)
%     disp(filename);
    img = imread(filename);
    img = imresize(img, [149, 149]); % resize the image to [149, 149]
end

% this line creates a table for the labels
class_names = labels.class;

% this line assigns the class names of the labels in a dataset to a 
% categorical variable in the same dataset.
imds.Labels = categorical(class_names);

while hasdata(imds)
    [~, info] = read(imds);
    disp(info);
end
save('imds.mat', 'imds');

end