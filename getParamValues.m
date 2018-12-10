function [PSSNL,C50,N,W,WI,I] = getParamValues(IDs)

PSSNL=[];
C50=[];
N=[];
W=[];
I=[];
WI=[];


Steps = 10;

PSSNLLower = 0;
PSSNLUpper = 0.7;

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

for i = 1:length(IDs)

JobID = IDs(i)-1;

ID = uint32(JobID);

InhId = idivide(ID,Steps^5);
ID = mod(ID,100000);

WidthId = idivide(ID,Steps^4);
ID = mod(ID,10000);

WidthIId = idivide(ID,Steps^3);
ID = mod(ID,1000);

PSSNLId = idivide(ID,Steps^2);
ID = mod(ID,100);

NId = idivide(ID,Steps^1);
ID = mod(ID,10);

C50Id = ID;

I(i) = InhLower + double(InhId)*InhUpper/(Steps-1);
W(i) = WidthLower + double(WidthId)*(WidthUpper-WidthLower)/(Steps-1);
WI(i) = WidthILower + double(WidthIId)*(WidthIUpper-WidthILower)/(Steps-1);
PSSNL(i) = PSSNLLower + double(PSSNLId)*PSSNLUpper/(Steps-1);
C50(i) = C50Lower + double(C50Id)*(C50Upper-C50Lower)/(Steps-1);
N(i) = NLower + double(NId)*(NUpper-NLower)/(Steps-1);

end
