%% Generate ideal sensor values
N=10e4;
d=floor([16*normrnd(0,1,[1 N])/3+16]);%, 16*normrnd(0,1,[1 N])/3+3*16]);
d(d>64) = [];
d(d<0) = [];
[a_orig,b] = hist(d,unique(d));
x = 1:size(a_orig,2);
a = a_orig;

figure
plot(x,a,'Color',[0.4660 0.6740 0.1880]);
hold on

for i from 1 to n
        y[i] := y[i-1] + ? * (x[i] - y[i-1])