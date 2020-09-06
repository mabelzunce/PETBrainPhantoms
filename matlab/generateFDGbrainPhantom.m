%% THIS VERSION CREATES A PHANTOM TAKING INTO ACCOUNT ONLY CELLULAR CONCENTRATIONS
close all
clear all
% PATHS
dataPath = '../data/';
addpath('./nifti/')
outputPath = '../output/';
hammers_mithAtlasPath = [dataPath '/Hammers_mith-n30r95/'];
if ~isfolder(outputPath)
    mkdir(outputPath);
end
%% OPTIMIZATION PARAMETERS
params.saveInterval = 5;
params.nIter = 20;
params.slice_phantom_res = 280;
params.beta = 1e5;%1e1;%1e1;
params.maxAreaForReg = 4e4;
%% LOAD PET DISTRIBUTION TEMPLATE/SCAN
% In the data folder there are a few different options, but any image can
% be used. In this case we use FDG PET from a sinlge patient:
petTemplateInfo = myniftiinfo([dataPath '/fdg2_flirt-2009b.nii.gz']);
petReferenceImage = myniftiread(petTemplateInfo);
%% LOAD BIGBRAIN IMAGES
% The images can be found in: ftp://bigbrain.loris.ca/
% We have also included them in the data path. The images are already
% normalized into MNI space.
histologyInfo = myniftiinfo([dataPath '/full16_400um_2009b_sym.nii.gz']);
histologyImage = myniftiread(histologyInfo);
% Change the scaling of the histology image to [0,1].
histologyImage = single(histologyImage);
histologyImage(:) = max(histologyImage(:))-histologyImage;
histologyImage = histologyImage./max(max(max(histologyImage))); 

classifiedTissueInfo = niftiinfo([dataPath '/full_cls_400um_2009b_sym.nii.gz']);
classifiedTissue = niftiread(classifiedTissueInfo);

% The original MRI dataset was registered to the histology image with AyN
% tools:
mrInfo = niftiinfo([dataPath '/mri_registered_with_skull_2009b_sym.nii.gz']);
mrImage = niftiread(mrInfo);
%% LOAD OTHER REQUIRED DATA SETS
% Read pseudo CT, generated with:
% http://niftyweb.cs.ucl.ac.uk/program.php?p=PCT
% Ninon Burgos et al, Attenuation Correction Synthesis for Hybrid PET-MR Scanners: Application to Brain Studies. IEEE Trans Med Imaging. 2014 Dec;33(12):2332-41. DOI 10.1109/TMI.2014.2340135
ctInfo = niftiinfo([dataPath '/pct_mni_icbm152_t1_tal_nlin_sym_09b_hires_corr.nii.gz']);
ctImage = niftiread(ctInfo);
% Then a mu map was created from the CT:
mumapInfo = niftiinfo([dataPath '/muMap_2009b.nii.gz']);
mumapImage = niftiread(mumapInfo);

%% OUTPUT VOXEL SIZE
petVoxelSize_mm = histologyInfo.PixelDimensions;

%% READ HAMMERSMITH ATLASES PROBABILITY MAPS AND STORE THEM IN SPARSE MATRICES
% Need to have in a folder all the region probabilities, which can be
% obtained in:
% http://brain-development.org/brain-atlases/adult-brain-atlases/adult-brain-maximum-probability-map-hammers-mith-atlas-n30r83-in-mni-space/
atlasPath = [dataPath '/Hammers_mith-n30r95/'];
[atlasProbMaps, indicesAtlasRegions] = CreateProbabilityMapsFromHammersmithAtlas(atlasPath);

%% ESTIMATION OF THE PHANTOM UPTAKE DISTRIBUTION
phantom = CreateBrainPhantomWithBigBrain(histologyImageImage, clsImage, atlasProbMaps,  voxelSize_mm);

%% WRITE THE RESULTS
% Matlab .mat file with all the components of the phantom:
save([outputPath '/phantom.mat'], 'phantom', '-v7.3');
% Nifti and Raw for the pet phanom::
phantom_nifti = phantom.pet(end:-1:1,:,end:-1:1);
phantom_nifti = permute(phantom_nifti, [2 1 3]);
phantom_info = histologyImage_info;
phantom_info.Datatype = 'single';
phantom_info.Description = 'Phantom based on tissue labels and cell-body densities';
niftiwrite(single(phantom_nifti), [outputPath 'phantom_atlas_density_cls'], phantom_info, 'Compressed', true);
% Raw
fid = fopen([outputPath 'pet_phantom.raw'],'wb'); fwrite(fid, phantom_nifti,'single'); fclose(fid);