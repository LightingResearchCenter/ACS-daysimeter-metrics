%this function takes a parent directory and creates an array of file paths 
function filePath = getFilePath(varargin)

%pick the directory to operate on
selectDir = varargin{1,1};


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
marked_dir_array = fullfile(pathArray,'marked_download');

nDir = numel(marked_dir_array);

folderContentsCell = cell(nDir,1);
filePath = cell(nDir,1);

for iDir = 1:nDir
    
   thisDir = marked_dir_array{iDir};
   folderContentsCell{iDir} = dir([thisDir,filesep,'*.cdf']);
   if ~isempty(folderContentsCell{iDir})
       fileName = folderContentsCell{iDir,1}.name;
       filePath{iDir} = fullfile(marked_dir_array{iDir},filesep,fileName);
   end
   
    
end
% Find empty cells
idxEmpty = cellfun(@isempty,filePath);
% Remove empty cells
filePath(idxEmpty) = [];

end




