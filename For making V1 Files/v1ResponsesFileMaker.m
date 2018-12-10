function V1ResponsesFileMaker(ID)
load('V1RF.mat')
load('conv3DGrtStim.mat')
disp(['Job ID: ' num2str(ID)])

ID1 = int32(ID);
Steps = 10;

C50Lower = 0.01;
C50Upper = 1;

NLower = 1;
NUpper = 4;

NId = idivide(ID1,Steps^1);
ID2 = mod(ID1,10);

C50Id = ID2;

N = NLower + double(NId)*NUpper/(Steps-1);
C50 = C50Lower + double(C50Id)*C50Upper/(Steps-1);
    
oriCell = {'0' '22' '45' '67' '90' '112' '135' '157' '180' '202' '225' '247' '270' '292' '315' '337'};
for ori1 = 1:16
disp(ori1)
for ori2 = 1:16
for RelPhase = 1:4

eval(['A = Gr' oriCell{ori1} ';']);
eval(['B = Gr' oriCell{ori2} ';']);
if ori1 ~=ori2
A = circshift(A,[0 0 floor(12.5*RelPhase)]);
end
%Build stimulus

St = (A+B)./2;

%Separate LGN ON OFF channels

LGNNeg = -St;
LGNNeg(LGNNeg<0)=0;


LGNPos = St;
LGNPos(LGNPos<0)=0;

%Implement contrast function on LGN channels

LGNNeg = ((LGNNeg.^N)./(LGNNeg.^N+C50.^N))/(1/(1+C50.^N));
LGNPos = ((LGNPos.^N)./(LGNPos.^N+C50.^N))/(1/(1+C50.^N));

%Merge LGN ON OFF channels

St = LGNPos-LGNNeg;

%Compute simple V1 cell response

R2 = St.*V12;
R = St.*V1;

R2=sum(R2(:));
R=sum(R(:));

%Compute complex V1 cell response

V1Resp(ori1,ori2,RelPhase) = sqrt(R2.^2+R.^2);

end
end
end

V1Resp=(mean(V1Resp,3));
V1Resp=V1Resp./max(V1Resp(:));
FileID = C50Id+NId*(Steps);

eval(['save(''V1RespFiles/V1Resp_' num2str(FileID) '.mat'',''V1Resp'')'])
end