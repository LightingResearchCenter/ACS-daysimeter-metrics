
function [q1FilePaths,q2FilePaths,q3FilePaths,q4FilePaths,q1DiaryPaths,q2DiaryPaths,q3DiaryPaths,q4DiaryPaths] = quarterFilePaths(masterPath)
Q1FP = fullfile(masterPath,filesep,'Q1'); 
Q2FP = fullfile(masterPath,filesep,'Q2'); 
Q3FP = fullfile(masterPath,filesep,'Q3'); 
Q4FP = fullfile(masterPath,filesep,'Q4'); 

[~,q1FilePaths] = getDiaryPath(Q1FP);
[~,q2FilePaths] = getDiaryPath(Q2FP);
[~,q3FilePaths] = getDiaryPath(Q3FP);
[~,q4FilePaths] = getDiaryPath(Q4FP);

[q1DiaryPaths,~] = getDiaryPath(Q1FP);
[q2DiaryPaths,~] = getDiaryPath(Q2FP);
[q3DiaryPaths,~] = getDiaryPath(Q3FP);
[q4DiaryPaths,~] = getDiaryPath(Q4FP);
end





