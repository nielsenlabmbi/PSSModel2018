for i = 1:length(Files)
load(['C:\Users\nielsenlab\Documents\MATLAB\ephysAnalysis\out\process\' Files{i} '_16x16RCProcess.mat']);

for unit = 1:length(RC16Process{1}.LatencyTc(:))
RC16Process{1}.MaxRespTC(unit) = max(RC16Process{1}.DataTunCurs(:,1,unit,RC16Process{1}.LatencyTc(unit)));
end

[Val Cell] = min(abs(RC16Process{1}.MaxRespTC - mResp(i)));
Data{i} = RC16Process{1}.RESPMAP(:,:,Cell,RC16Process{1}.LatencyTc(Cell));

for ori = 1:16
TCunit(ori) = Data{i}(ori,ori);
end

mx = find(TCunit == max(TCunit));

Data{i} = Data{i}([mx:end 1:mx-1],[mx:end 1:mx-1]);

end
