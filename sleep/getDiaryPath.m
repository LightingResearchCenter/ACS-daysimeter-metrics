%provides list of cdfs with corresponding diaries. 
function filePaths = getDiaryPath(varargin)

%pick the directory to operate on
%selectDir = varargin{1,1};
%selectDir = uigetdir('C:\','pick');
selectDir = 'C:\DaysimeterData';

%output directory list and the folder path
[dirList,folderPath] = getFolderListing(selectDir);

%removes the folders in question 
dirList = rmFolder(dirList,'weekly_reports'); 
dirList = rmFolder(dirList,'archive');

% Remove files, leaving only folders
dirList(~[dirList.isdir]') = [];
% Create full paths
pathArray = fullfile(folderPath,{dirList.name}');

% Create marked download folder paths
marked_dir_array = fullfile(pathArray,filesep,'marked_download');
best_diary_array = fullfile(pathArray,filesep,'best_diary'); 

%counts the number of folders
nDir = numel(marked_dir_array); 

%preallocates for the file paths 
folderContentsCell = cell(nDir,2);
filePaths = cell(nDir,2);

%goes through each folder and finds a cdf and records the path to the cell
%array. if the cell is empty it does not write to the cell leaving an empty
%cell 
for iDir = 1:nDir
    
   thisDir = marked_dir_array{iDir};
   folderContentsCell{iDir,1} = dir([thisDir,filesep,'*.cdf']);
   if ~isempty(folderContentsCell{iDir,1})
       fileName = folderContentsCell{iDir,1}.name;
       filePaths{iDir,1} = fullfile(marked_dir_array{iDir},filesep,fileName);
   end
   
   thisDir = best_diary_array{iDir};
   folderContentsCell{iDir,2} = dir([thisDir,filesep,'*.xlsx']);
   if ~isempty(folderContentsCell{iDir})
       fileName = folderContentsCell{iDir,2}.name;
       filePaths{iDir,2} = fullfile(best_diary_array{iDir},filesep,fileName);
   end
    
end

% Find empty cells
idxEmpty = cellfun(@isempty,filePaths);
%creates empty cells vecto 
idxEmptyVec = idxEmpty(:,1) | idxEmpty(:,2);
% Remove empty cells
filePaths(idxEmptyVec,:) = [];


end




