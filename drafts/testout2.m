%%
N=10e4;
d=floor([16*normrnd(0,1,[1 N])/3+16]);%, 16*normrnd(0,1,[1 N])/3+3*16]);
d(d>64) = [];
d(d<0) = [];
[a,b]=hist(d,unique(d));
a(25) = 7e3;
% a(26) = 5e3;
x = 1:size(a,2);
figure
hold on

x1 = x(1:end-1)+.5;
a1 = diff(a);
a2 = diff([0 a1 0]);
a3 = diff(a2);
a4 = diff([0 a3 0]);

plot(x,a)
yyaxis right
plot(x1,maxnormalize(abs(a1)));
plot(x,maxnormalize(abs(a2)));

function y = maxnormalize(x)
    y = x./max(x);
end