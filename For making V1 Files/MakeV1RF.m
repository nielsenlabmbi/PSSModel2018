% To make V1RF. Resolution: 0.1 deg/pixel and 0.02 sec per frame
% Temp freq 1Hz
% Spatial freq = .1 cyc/deg
% The +25 in V12 is not necessary

for x = 1:200
for y = 1:200
for t = 1:50
V1(x,y,t) = sin((((x-13.5)+(t-1))/50)*2*pi)*normpdf(sqrt((x-101)^2 + (y-101)^2),0,25);
V12(x,y,t) = cos((((x-13.5+25)+(t-1))/50)*2*pi)*normpdf(sqrt((x-101)^2 + (y-101)^2),0,25);
end
end
end
V1=V1./max(V1(:));
V12=V12./max(V12(:));
save('V1RF','V1','V12');