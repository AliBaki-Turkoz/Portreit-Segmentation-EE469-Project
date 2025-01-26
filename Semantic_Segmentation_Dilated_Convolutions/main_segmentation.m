% IMPORTANT TO CHANGE THIS PART
% CHANGE THIS PART
% you need to change this datafolder to the one on your computer
% this datafolder must contain the subfolder titled
% ground_truth_segmentations which contains binary segmentation ground truths in
% png format of each jpg image, in the segmentation file, the 1's indicate
% foreground and 0's indicate background pixels.
load("semantic.mat")

datafolder_rgb='C:\Users\AliBakiTURKOZ\OneDrive\Masaüstü/rgb_images';
datafolder_mask='C:\Users\AliBakiTURKOZ\OneDrive\Masaüstü/segmented_images';
datafolder_mymask='C:\Users\AliBakiTURKOZ\OneDrive\Masaüstü/masks';
datafolder_err=('C:\Users\AliBakiTURKOZ\OneDrive\Masaüstü/err');
mkdir(datafolder_err);

% to perform automatic segmentation, this step should write a subfolder
% with name groupname which will contain png format segmentations in datafolder
perform_segmentation(datafolder_rgb,datafolder_mymask,net);
% to do evaluation of the performed segmentations
evaluate_segmentation(datafolder_mask,datafolder_mymask,datafolder_err);