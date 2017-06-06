function ei = thorGetExperimentInfo (dataFolder)

xmlFile = makeName('Experiment.xml',dataFolder);
xDoc = xmlread(xmlFile);
tt = xDoc.getElementsByTagName('LSM');
ttt = tt.item(0);

temp = char(ttt.getAttribute('averageMode')); avgMode = str2num(temp);
temp = char(ttt.getAttribute('averageNum')); avgNum = str2num(temp);

temp = char(ttt.getAttribute('frameRate'));ei.frameRate = str2num(temp);
if avgMode
    ei.frameRate = ei.frameRate/avgNum;
end


temp = char(ttt.getAttribute('pixelX')); ei.pixelX = str2num(temp);
temp = char(ttt.getAttribute('pixelY')); ei.pixelY = str2num(temp);
temp = char(ttt.getAttribute('widthUM')); ei.widthUM = str2num(temp);
temp = char(ttt.getAttribute('heightUM')); ei.heightUM = str2num(temp);

tt = xDoc.getElementsByTagName('Timelapse');
ttt = tt.item(0);
temp = char(ttt.getAttribute('timepoints')); ei.timePoints = str2num(temp);ei.totalFrames = str2num(temp);
    