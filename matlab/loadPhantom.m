%% EXAMPLE HOW TO LOAD THE PHANTOM
% First download the data from https://doi.org/10.5281/zenodo.1190598 into the
% ../data directory.
close all
clear
%% LAOD THE PHANTOM
load('../data/phantom_atlas_density_cls.mat')
%% OPTIONAL: ADD CLS IMAGE
% Previous version of the phantom did not have the cls image in the.mat
% Download the cls image from bigbrain and uncomment this code to create an
% updated .mat file.
% cls = niftiread('../data/full_cls_400um_2009b_sym.nii.gz');
% cls = permute(cls, [2 1 3]);
% cls = cls(:,:,end:-1:1);
% cls = cls(end:-1:1,:,:);
% phantom_atlas_density_cls.cls = cls;
% save('../data/phantom_atlas_density_cls.mat', "phantom_atlas_density_cls");
%% GET EACH INDIVIDUAL IMAGE
fdgPhantom = phantom_atlas_density_cls.phantom;
fdgPhantomSmoothed = phantom_atlas_density_cls.phantom_smoothed;
fdgPhantomGuidedFilter = phantom_atlas_density_cls.phantom_guided_filter;
mriPhantom = phantom_atlas_density_cls.mr;
ctPhantom = phantom_atlas_density_cls.ct;
muMapPhantom = phantom_atlas_density_cls.umap;
voxelSize_mm = 0.4;

%% SHOW IMAGES
slice = 280;
figure;
subplot(2,2,1);
imshow(fdgPhantom(:,:,slice),[]);
title('FDG PET')
subplot(2,2,3);
imshow(mriPhantom(:,:,slice),[]);
title('MRI')
subplot(2,2,2);
imshow(muMapPhantom(:,:,slice),[]);
title('uMap')
subplot(2,2,4);
imshow(ctPhantom(:,:,slice),[]);
title('CT')

