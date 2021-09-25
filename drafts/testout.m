%%
N=10e4;
d=floor([16*normrnd(0,1,[1 N])/3+16]);%, 16*normrnd(0,1,[1 N])/3+3*16]);
d(d>64) = [];
d(d<0) = [];
[a,b]=hist(d,unique(d));
a(25) = 7e3;
x = 1:size(a,2);
figure
hold on

% xx = meaninterp(x);
% aa = meaninterp(a);
% xxx = meaninterp(xx);
% aaa = meaninterp(aa);
% 
% xs = 1:.01:size(a,2);
% as = spline(x,a,xs);
% aaas = spline(xxx,aaa,xs);

% plot(x,a)
% plot(xs,as)
% plot(xs,aaas)


%%
% o=isoutlier(a, 'movmedian', 5, 'ThresholdFactor', 2);
% hold on
% yyaxis right
% plot(o)
% any(o)

%%
a1 = diff(a);
a1 = [([0 a1] + [a1 0])/2; a1 0];
a1 = a1(1:end-1);
x1 = meaninterp(x);


a2 = diff(a1);
a2 = [([0 a2] + [a2 0])/2; a2 0];
a2 = a2(1:end-1);
x2 = meaninterp(x1);

% a1 = [a1 ; (a1(1:end-1) + a1(2:end))/2, 0];
% a1 = a1(1:end-1);

plot(x,a);
plot(x1,a1)
plot(x2,a2)

%%
% R = abs(((1+a1.^2).^(3/2))./a2);
% yyaxis right
% plot(x2,R)
