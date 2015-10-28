%this function is designed to take the file path and output the subjectIDm
%the phasor magniuted and the phasor angle in hours. 
%need to name it like phasortablemaker. I'll do that now. done. 
function [subject_ID,phasor_angle_hours,phasor_magnitude] = phasorTableMaker(filePath)
%function [phasorAngleCellArray,phasorMagnitudeCellArray] = phasorTableMaker(filePath)

cdfData = daysimeter12.readcdf(filePath);
[absTime,relTime,epoch,light,activity,masks,subject_ID,deviceSN] = daysimeter12.convertcdf(cdfData);
phazor = phasor.prep(absTime,epoch,light,activity,masks);
phasor_angle_hours = phazor.angle.hours;
phasor_magnitude = phazor.magnitude;


end

