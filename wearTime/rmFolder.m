function dirLis = rmFolder(dirLis,varargin)
%returns the number of elements of varargin. using numel becaue I couldnt
%get nargikn to work 
vararginNumel = numel(varargin);

if vararginNumel >  0
    delDir = varargin{1,1};
      
    else 
        %topDir = uigetdir('','Select the directory you want to analyze'); 
        topDir = input('Enter the name of the director you wish to remove in apostrophes'); 
        delDir = topDir;
end 

% Find selected directory 
rmDirIdx = strcmp({dirLis.name}',delDir);
% Remove selected directory
dirLis(rmDirIdx) = [];