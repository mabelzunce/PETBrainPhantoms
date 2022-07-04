%% EXAMPLE HOW TO LOAD THE PHANTOM
% First download the data from https://doi.org/10.5281/zenodo.1190598 into the
% ../data directory.
close all
clear
%% LAOD THE PHANTOM
load('../data/phantom_atlas_density_cls.mat')
%% GET EACH INDIVIDUAL IMAGE
fdgPhantom = phantom_atlas_density_cls.phantom;
fdgPhantomSmoothed = phantom_atlas_density_cls.phantom_smoothed;
fdgPhantomGuidedFilter = phantom_atlas_density_cls.phantom_guided_filter;
mriPhantom = phantom_atlas_density_cls.mr;
muMapPhantom = phantom_atlas_density_cls.ct;
ctPhantom = phantom_atlas_density_cls.umap;
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

