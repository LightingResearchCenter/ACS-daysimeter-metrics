%this function is designed to take the file path and output the subjectIDm
%the phasor magniuted and the phasor angle in hours. 
function [phasorAngleTable,phasorMagnitudeTable] = cdfProcessor(filePath)

cdfData = daysimeter12.readcdf(filePath);
[absTime,epoch,light,activity,masks,subjectID] = convertcdf(cdfData);
phasor = prep(absTime,epoch,light,activity,masks);
phasorAngle = phasor.angle.hours;
phasorMagnitude = phasor.magnitude; 
phasorAngleTable = [subjectID,phasorAngle];
phasorMagnitudeTable = [subjectID,phasorMagnitude];


