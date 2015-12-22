%%This function gets the folder directory as a list with the parent
%directories removed %%

function [dirLis,folderPath] = getFolderListing(varargin)

vararginNumel = numel(varargin);

folderPath = varargin;

if vararginNumel >  0
    topDirPath  = varargin{1,1};
 
    else 
        topDir = uigetdir ('','Select the directory you want to analyze'); 
        topDirPath = topDir;
        folderPath = topDirPath;
end 

%get directory list 
dirLis = dir(topDirPath);

% Find parent directories
parentDirIdx = strcmp({dirLis.name}','.') | strcmp({dirLis.name}','..');
% Remove parent directories
dirLis(parentDirIdx) = [];
end




