% Creates a cell array with the probability maps for each label in the
% Hammersmith atlases.
% Input: path where the hamersmith atlas is found.
% Outputs: 
%   atlasProbMaps: cell array with the probability maps for each
%   label/region stored in a sparse matrix.
%   indicesAtlasRegions: indices for each region.
function [atlasProbMaps, indicesAtlasRegions] = CreateProbabilityMapsFromHammersmithAtlas(atlasPath)

lisAtlasRegions = dir([atlasPath 'probmap*']);
lengthFirstPart = length('probmap-full-r');
numSamples = 30;
for i = 1 : numel(lisAtlasRegions)
    if ~isdir([atlasPath lisAtlasRegions(i).name])
        atlas_info = myniftiinfo([atlasPath lisAtlasRegions(i).name]);
        atlas_roi = double(myniftiread(atlas_info));
        atlas_roi = atlas_roi./numSamples;%sum(atlas_roi(:));%numSamples;
        atlas_roi = permute(atlas_roi, [2 1 3]);
        atlas_roi = atlas_roi(end:-1:1,:,end:-1:1);
        atlasProbMaps{i} = sparse(atlas_roi(:));
        % Also I want to get the index in the hammersmith atlas of each region,
        % I get it from the filename:
        indexEndNumber = strfind(lisAtlasRegions(i).name(lengthFirstPart+1:end), '-');
        indicesAtlasRegions(i) = str2num(lisAtlasRegions(i).name(lengthFirstPart+1:lengthFirstPart+indexEndNumber-1));
    end
end