function  finalThreshold = calcThreshold(dataArray,filterOne,sigDigs)
%Calc Threshold 
    %calculates the lights off threshold of a night 
nElements = numel(dataArray); 
dataIdx = NaN(nElements,1); 

for iElements = 1:nElements
    if dataArray(iElements) > filterOne
        dataIdx(iElements) = 1; 
    else
        dataIdx(iElements) = 0; 
    end
    
end
  dataIdx = logical(dataIdx); 
  dataArray(dataIdx) = [];
  logDataArray = log(dataArray); 
  roundedLogDataArray = round(logDataArray,sigDigs,'significant'); 
  thresholdMode = mode(roundedLogDataArray); 
  finalThreshold = exp(thresholdMode); 