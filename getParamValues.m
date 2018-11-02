function [MtNL,C50,N,W,WI,I,ContrastSat,ExcW,InhW] = getParamValues(IDs)

MtNL=[];
C50=[];
N=[];
W=[];
I=[];
WI=[];


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

for i = 1:length(IDs)

JobID = IDs(i)-1;

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

I(i) = InhLower + double(InhId)*InhUpper/(Steps-1);
W(i) = WidthLower + double(WidthId)*(WidthUpper-WidthLower)/(Steps-1);
WI(i) = WidthILower + double(WidthIId)*(WidthIUpper-WidthILower)/(Steps-1);
MtNL(i) = MtNLLower + double(MtNLId)*MtNLUpper/(Steps-1);
C50(i) = C50Lower + double(C50Id)*(C50Upper-C50Lower)/(Steps-1);
N(i) = NLower + double(NId)*(NUpper-NLower)/(Steps-1);
CRI(i) = NC50toCrossOriInh(NId,C50Id);

ContrasRespFunc = (([0:0.01:1].^N(i))./([0:0.01:1].^N(i)+C50(i).^N(i)))/(1/(1+C50(i).^N(i)));

MTE = circ_vmpdf([0:1:15]*(2*pi/16),14*pi/16,2^W(i));
MTE = MTE./max(MTE);

MTI = circshift(circ_vmpdf([0:1:15]*(2*pi/16),14*pi/16,2^WI(i)),8);
MTI = MTI./max(MTI);

MTW = MTE - MTI*I(i);

ContrastSat(i) = ContrasRespFunc(51);
PosMTW = MTW;
PosMTW(PosMTW<0) = 0;
NegMTW = MTW;
NegMTW(NegMTW>0) = 0;

ExcW(i) = sum(PosMTW > 0.2*max(PosMTW));
InhW(i) = sum(-NegMTW > 0.2*max(PosMTW));

end