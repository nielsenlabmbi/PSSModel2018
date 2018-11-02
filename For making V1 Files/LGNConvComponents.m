clear all
load('LGNRF.mat')
load('3DGrtStim.mat')

oriCell = {'0' '22' '45' '67' '90' '112' '135' '157' '180' '202' '225' '247' '270' '292' '315' '337'};
for ori1 = 1:16
disp(ori1)
eval(['A = Gr' oriCell{ori1} ';']);
LGN2 = circshift(LGN,[100 100]);
for a = 1:50
for b = 1:200
for c = 1:200
LGN3 = circshift(LGN2,[b c]-1);
conv = A(:,:,a).*LGN3;
LGNOut(b,c,a) = (sum(conv(:)));
end
end
end
LGNOut = LGNOut/(max(LGNOut(:))*2);
eval(['convGr' oriCell{ori1} ' =LGNOut;']);
end
save('conv3DGrtStim','convGr0','convGr22','convGr45','convGr67','convGr90','convGr112','convGr135','convGr157','convGr180','convGr202','convGr225','convGr247','convGr270','convGr292','convGr315','convGr337')