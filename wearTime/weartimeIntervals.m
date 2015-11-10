function [oneLine,nonCompliantOneLine] = weartimeIntervals(masks,absTime)

%filePath ='C:\Users\runef_000\Documents\GitHub\cdfPractice\A11637\marked_download\A11637_SEP15_191.cdf';

    %[absTime,relTime,epoch,light,activity,masks,subjectID,cdfData] = readAndConvertCdf(filePath);
    
%generate use logical array
use = masks.compliance(masks.observation);

compDiff = diff(use);
% compDiff = -1 = start of noncompliance bouts
startIdx = compDiff == 1;
% compDiff = 1 = end of noncompliance bouts
endIdx = compDiff == -1;

% Handle end effects
if use(1) % is true
    startIdx2 = [true;startIdx];
else % compliance(1) is false
    startIdx2 = [false;startIdx];
end

if use(end) %is true
    endIdx2 = [endIdx;true];
else % compliance(end) is false
    endIdx2 = [endIdx;false];
end

% Use indicies to extract start and end times
cBoutStartArray = absTime.localDateNum(startIdx2);
cBoutEndArray = absTime.localDateNum(endIdx2);

nBouts = numel(cBoutEndArray);
weartimeStartArray = cell(nBouts,1);
weartimeEndArray = cell(nBouts,1); 

for iBouts = 1:nBouts
weartimeStartArray{iBouts,1} = datestr(cBoutStartArray(iBouts));
weartimeEndArray{iBouts,1} = datestr(cBoutEndArray(iBouts)); 
end

weartimeStartArray = (weartimeStartArray)';
weartimeEndArray = (weartimeEndArray)';

nStart = numel(weartimeEndArray); 
oneLine = cell(1,nStart*2); 

%fills the oneLine cell array with the data 
iLarge = 1;
for iSmall = 1:nStart
  
oneLine(iLarge) = weartimeStartArray(iSmall); 
iLarge = iLarge + 1;
oneLine(iLarge) = weartimeEndArray(iSmall); 
iLarge = iLarge + 1; 
end

%*************************************************************************
compDiff = diff(use);
% compDiff = -1 = start of noncompliance bouts
startIdx = compDiff == -1;
% compDiff = 1 = end of noncompliance bouts
endIdx = compDiff == 1;

% Handle end effects
if use(1) % is true
    startIdx2 = [false;startIdx];
else % compliance(1) is false
    startIdx2 = [true;startIdx];
end

if use(end) %is true
    endIdx2 = [endIdx;false];
else % compliance(end) is false
    endIdx2 = [endIdx;true];
end

% Use indicies to extract start and end times
ncBoutStartArray = absTime.localDateNum(startIdx2);
ncBoutEndArray = absTime.localDateNum(endIdx2);

nBouts = numel(ncBoutEndArray);
nonWeartimeStartArray = cell(nBouts,1);
nonWeartimeEndArray = cell(nBouts,1); 

for iBouts = 1:nBouts
nonWeartimeStartArray{iBouts,1} = datestr(ncBoutStartArray(iBouts));
nonWeartimeEndArray{iBouts,1} = datestr(ncBoutEndArray(iBouts)); 
end

nonWeartimeStartArray = (nonWeartimeStartArray)';
nonWeartimeEndArray = (nonWeartimeEndArray)';

nStart = numel(nonWeartimeEndArray); 
nonCompliantOneLine = cell(1,nStart*2); 

iLarge = 1;
for iSmall = 1:nStart
  
nonCompliantOneLine(iLarge) = nonWeartimeStartArray(iSmall); 
iLarge = iLarge + 1;
nonCompliantOneLine(iLarge) = nonWeartimeEndArray(iSmall); 
iLarge = iLarge + 1; 
end

end



