%{
FINAL PROJECT

Eshaan Jayant Deshpande, ed6939@rit.edu
Anushka Yadav, ay4034@rit.edu
Vedika Vishwanath Painjane, vp2312@rit.edu

File Name: segment.m
%}

function segment()

% The threshold value for the red channel is set to 114. This value was
% decided by us after a lot of trial n error.
% The threshold values for the other two channels is set to 0.
red_threshold = 114;
green_threshold = 0;
blue_threshold = 0;

% Define structuring element for morphological operations.
SE = strel('disk', 2);

% name of the folder where the segmented images will be stored for further
% use.
folder_name = 'processed_images'; 
if exist(folder_name, 'dir')
    % this line deletes the entire folder if it already exists and then creates 
    % a new folder.   
    rmdir(folder_name, 's'); 
end

% creates a new folder called processed_images
mkdir(folder_name);

processed_img_folder = [folder_name, '/'];

file_list = dir('cotton images/*.TIF');

% this for-loop accesses all the images from the folder named cotton images
% and performs morphological operations on it to get the segmented image
% which is then stored in the folder created above named
% 'processed_images'.
for counter = 1 : length( file_list )
    fn = file_list(counter).name;
    search_word = 'mosaic';
    word_index = strfind(fn, search_word);
%     substring = extractBetween(fn, word_index + length(search_word), strlength(fn) - 4);
    substring = fn(word_index + length(search_word):(end - 4));
    substring = strrep(substring, '_', '');
%     disp(substring);
    fprintf('Processing Image:  %s \n', fn);
    directory = 'cotton images/';
    img = imread(append(directory,fn));
    rgbImage = img(:,:,1:3);

    % extracts all the three color channels
    red = rgbImage(:,:,1);
    green = rgbImage(:,:,2);
    blue = rgbImage(:,:,3);

    % create binary mask 
    yellow_mask = (red < red_threshold) & (green > green_threshold) & (blue > blue_threshold);

    % apply mask to original image
    yellow_img = rgbImage .* uint8(repmat(yellow_mask, [1 1 3]));
    % converts the image to grayscale     
    gray_image = rgb2gray(yellow_img);
    % converts the grayscale image to binary
    binary_img = imbinarize(gray_image);
    % gets the complement of the image
    binary_img = imcomplement(binary_img);

    % Perform morphological operations
    bwarea = ~bwareaopen(~binary_img, 100);
    eroded = imerode(bwarea, SE);
    opened = imopen(eroded, SE);
    eroded = imerode(opened, SE);
    dilate = imdilate(eroded, SE);

    % performs masking
    rgbImage(repmat(dilate, [1 1 3])) = 0;
    % adds the extension to the name of the image 
    save_name = append(processed_img_folder, substring, ".TIF");
    % stores the image in the folder named 'processed_images'
    imwrite(rgbImage, save_name);
end
% displays 'Done' once all the images have been processed
disp("Done");


end