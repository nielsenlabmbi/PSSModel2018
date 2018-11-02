function CRI = NC50toCrossOriInh(NId,C50Id)
Steps=10;
FileID = C50Id+NId*(Steps);
load(['V1RespFiles/V1Resp_' num2str(FileID) '.mat']);
CRI = V1Resp(9,5);