%provides list of cdfs with corresponding diaries. 
function [diaryPath,filePath] = getDiaryPath(masterPath)

%pick the directory to operate on
%masterPath = 'C:\DaysimeterData';

%output directory list and the folder path
[dirList,folderPath] = getFolderListing(masterPath);

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
folderContentsDiary = cell(nDir,1);
folderContentsData = cell(nDir,1); 
diaryPath = cell(nDir,1);
filePath = cell(nDir,1);

%goes through each folder and finds a cdf and records the path to the cell
%array. if the cell is empty it does not write to the cell leaving an empty
%cell 
for iDir = 1:nDir
   
   thisDir = marked_dir_array{iDir};
   folderContentsData{iDir,1} = dir([thisDir,filesep,'*.cdf']);
   if ~isempty(folderContentsData{iDir,1})
       fileName = folderContentsData{iDir,1}.name;
       filePath{iDir,1} = fullfile(marked_dir_array{iDir},filesep,fileName);
   end
   
   thisDir = best_diary_array{iDir};
   
   folderContentsDiary{iDir,1} = dir([thisDir,filesep,'*.xlsx']);
   if ~isempty(folderContentsDiary{iDir,1})
       fileName = folderContentsDiary{iDir,1}.name;
       diaryPath{iDir,1} = fullfile(best_diary_array{iDir},filesep,fileName);
   end
    
end

% Find empty cells
idxEmptyData = cellfun(@isempty,filePath);
idxEmptyDiary = cellfun(@isempty,diaryPath); 
%creates empty cells vecto 
idxEmptyVec = idxEmptyData(:,1) | idxEmptyDiary(:,1);
% Remove empty cells
filePath(idxEmptyVec,:) = [];
diaryPath(idxEmptyVec,:) = []; 


end




