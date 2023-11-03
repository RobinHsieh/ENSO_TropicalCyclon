clear;
fn=fopen('/data/yshuang/index/NPGO.txt');
npgoi=textscan(fn,'%d%d%f','Delimiter','\t');
fclose(fn);
npgo=permute(cell2mat(npgoi(1,3)),[2 1]);

figure;
[p ,rednoise,c5, c95 ,f]=spec_anal(npgo, 0.05, 0.95,0,0);
plot(f, p, f, rednoise, f, c5, f, c95);
ax=gca;
ax.XLim = [0 2.0]
