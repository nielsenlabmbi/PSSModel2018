function MtModel = modelFunctionOneInstance(JobID)

%Parameter settings

Steps = 10;

MtNLLower = 0;
MtNLUpper = 0.7;

C50Lower = 0.01;
C50Upper = 1;

NLower = 1;
NUpper = 5;

WidthLower = -3;
WidthUpper = 6;

WidthILower = -3;
WidthIUpper = 6;

InhLower = 0;
InhUpper = 2;
    
%Get parameter values

ID = uint32(JobID);

InhId = idivide(ID,Steps^5);
ID = mod(ID,100000);

WidthId = idivide(ID,Steps^4);
ID = mod(ID,10000);

WidthIId = idivide(ID,Steps^3);
ID = mod(ID,1000);

MtNLId = idivide(ID,Steps^2);
ID = mod(ID,100);

NId = idivide(ID,Steps^1);
ID = mod(ID,10);

C50Id = ID;

Inh = InhLower + double(InhId)*InhUpper/(Steps-1);
Width = WidthLower + double(WidthId)*(WidthUpper-WidthLower)/(Steps-1);
WidthI = WidthILower + double(WidthIId)*(WidthIUpper-WidthILower)/(Steps-1);
MtNL = MtNLLower + double(MtNLId)*MtNLUpper/(Steps-1);

% Get V1 Responses from premade LGN responses

% Done separately, load file
FileID = C50Id+NId*(Steps);

% eval(['load(''V1RespFiles/V1Resp_' num2str(FileID) '.mat'')'])
load(['V1RespFiles/V1Resp_' num2str(FileID) '.mat']);

%Compute V1 population responses

for N = 1:16
    popV1Resp(:,:,N) = circshift(V1Resp,[N-1 N-1]);
end

% Set MT Weights

MTE = circ_vmpdf([0:1:15]*(2*pi/16),14*pi/16,2^Width);
MTE = MTE./max(MTE);

MTI = circshift(circ_vmpdf([0:1:15]*(2*pi/16),14*pi/16,2^WidthI),8);
MTI = MTI./max(MTI);

MTW = MTE - MTI*Inh;

% Get MT Resp

MtModel = zeros(16,16);
 
for i = 1:16
    MtModel = MtModel + popV1Resp(:,:,i).*MTW(i);
end

if max(MtModel(:))>0
MtModel=MtModel./(max(MtModel(:)));
else
MtModel = zeros(16,16);    
end

MtModel = MtModel - MtNL;
MtModel(MtModel<0)=0;

for ori = 1:16
TCunit(ori) = MtModel(ori,ori);
end

mx = find(TCunit == max(TCunit));

MtModel = MtModel([mx:end 1:mx-1],[mx:end 1:mx-1]);
