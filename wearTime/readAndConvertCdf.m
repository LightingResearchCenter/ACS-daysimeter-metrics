function [absTime,relTime,epoch,light,activity,masks,subjectID,cdfData] = readAndConvertCdf(filePath)
%filePath = 'C:\DaysimeterData\A10207\marked_download\A10207_SEP15_194.cdf';
cdfData = daysimeter12.readcdf(filePath);
[absTime,relTime,epoch,light,activity,masks,subjectID,~] = daysimeter12.convertcdf(cdfData);
end


