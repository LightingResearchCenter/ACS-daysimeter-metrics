function [dateLabels,hourLabels,condData] = condenseData(absTime,dataArray,varargin)
%CONDENSEDATA Summary of this function goes here
%   Detailed explanation goes here

condensingInterval = 60*60*1000; % Interval in milli-seconds

if nargin == 3 % Optional argument provided
    averageType = varargin{1}; % Use provided average type
else
    averageType = 'mean';
end

averageFunc = str2func(averageType);

startCdfEpoch = min(absTime.localCdfEpoch);
endCdfEpoch = max(absTime.localCdfEpoch);

ms2days = 1000*60*60*24;
startCdfEpoch = floor(startCdfEpoch/ms2days)*ms2days;
endCdfEpoch = ceil(endCdfEpoch/ms2days)*ms2days;

condensedTimeArray_cdfEpoch = startCdfEpoch:condensingInterval:endCdfEpoch;
nCond = numel(condensedTimeArray_cdfEpoch)-1;
condData = nan(nCond,1);

for iInterval = 1:nCond
    thisStart = condensedTimeArray_cdfEpoch(iInterval);
    thisEnd = condensedTimeArray_cdfEpoch(iInterval+1);
    
    thisIdx = (absTime.localCdfEpoch >= thisStart) & (absTime.localCdfEpoch < thisEnd);
    condData(iInterval) = averageFunc(dataArray(thisIdx));
end

localTimeVec = (cdflib.epochBreakdown(condensedTimeArray_cdfEpoch))';
localDateVec = localTimeVec(:,1:6);

dateLabels = datestr(localDateVec(1:end-1,:),'yyyy-mm-dd');
startHourLabels = datestr(localDateVec(1:end-1,:),'HH:MM');
endHourLabels = datestr(localDateVec(2:end,:),'HH:MM');
spacer = repmat(' - ',[size(startHourLabels,1),1]);
hourLabels = [startHourLabels,spacer,endHourLabels];
 
dateLabels = cellstr(dateLabels);
hourLabels = cellstr(hourLabels);

end

