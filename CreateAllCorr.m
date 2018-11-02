AllCorr=[];
AllError=[];
AllAllignment=[];
for i = 0:199
if rem(i,100) == 0
    disp(i)
end
load(['CorrFiles/Corr_ID' num2str(i)]')
BigCorr(isnan(BigCorr))=0;
AllCorr = [AllCorr;BigCorr];
AllAllignment = [AllAllignment;BigAllignment];
AllError = [AllError;BigError];
end
save('AllCorr','AllCorr','AllAllignment','AllError')