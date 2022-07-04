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
%% WRITE THEM IN NIFTI
% Get info from the bigbrain histology images:
bigbrainFile = 'full16_400um_2009b_sym.nii.gz';
info = niftiinfo(bigbrainFile);
histology = niftiread(bigbrainFile);

info.Description = 'Ultra-high resolution FDG PET Phantom - PET Uptake';
info.Datatype = 'single';
fdgPhantomForNifti = permute(fdgPhantom,[2 1 3]);
fdgPhantomForNifti = fdgPhantomForNifti(:,end:-1:1,end:-1:1);
niftiwrite(fdgPhantomForNifti, '../data/fdg_pet_phantom_uptake', info, 'Compressed', 1)

info.Description = 'Ultra-high resolution FDG PET Phantom - uMAP';
muMapPhantomForNifti = permute(muMapPhantom,[2 1 3]);
muMapPhantomForNifti = muMapPhantomForNifti(:,end:-1:1,end:-1:1);
niftiwrite(muMapPhantomForNifti, '../data/fdg_pet_phantom_umap', info, 'Compressed', 1)

info.Description = 'Ultra-high resolution FDG PET Phantom - CT';
ctPhantomForNifti = permute(ctPhantom,[2 1 3]);
ctPhantomForNifti = ctPhantomForNifti(:,end:-1:1,end:-1:1);
niftiwrite(ctPhantomForNifti, '../data/fdg_pet_phantom_ct', info, 'Compressed', 1)

info.Description = 'Ultra-high resolution FDG PET Phantom - MRI';
mriPhantomForNifti = permute(mriPhantom,[2 1 3]);
mriPhantomForNifti = mriPhantomForNifti(:,end:-1:1,end:-1:1);
niftiwrite(mriPhantomForNifti, '../data/fdg_pet_phantom_mri', info, 'Compressed', 1)
