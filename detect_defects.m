%% Generate ideal sensor values
N=10e4;
d=floor([16*normrnd(0,1,[1 N])/3+16]);%, 16*normrnd(0,1,[1 N])/3+3*16]);
d(d>64) = [];
d(d<0) = [];
[a_orig,b] = hist(d,unique(d));
x = 1:size(a_orig,2);
a = a_orig;

%% Add defects
N_osh = 3;
osh = randi(size(a,2),1,N_osh);
N_ush = 3;
ush = randi(size(a,2),1,N_ush);

% osh = 18:25;
% ush = [];

effective_defects = containers.Map('KeyType','double','ValueType','char');
for i = 1:size(osh,2)
    strength = 1.5+.25*2*(rand-.5);
    a(osh(i)) = a(osh(i))*strength;
    effective_defects(osh(i)) = ['Overshoot'];%  ' num2str(round(100*(strength-1))) '%'];
end
for i = 1:size(ush,2)
    strength = .5+.25*2*(rand-.5);
    a(ush(i)) = a(ush(i))*strength;
    effective_defects(ush(i)) = ['Undershoot'];% ' num2str(round(100*(1-strength))) '%'];
end

%% Detect defects

defects = containers.Map('KeyType','double','ValueType','char');

% Order of the mean prediction
order = 2;
% Error tolerance
p = .1;
figs = [];

while 1

    ae = [zeros(1,order) a zeros(1,order)];
    xe = [x(1)-(1:order) x x(end)+(1:order)];

    % as = [];
    % as2 = [];
    am = [];

    for i = 1:size(x,2)
    %     as(i) = spline([xe(i-(1:order)+order) xe(i+(1:order)+order)], [ae(i-(1:order)+order) ae(i+(1:order)+order)], x(i));
    %     as2(i) = spline([xe(i) xe(i+2*order)], [ae(i) ae(i+2*order)], x(i));
        am(i) = mean([ae(i-(1:order)+order) ae(i+(1:order)+order)]);
    end

    figs = [figs figure];
    subplot(2,1,1)
    hold on
    plot(x,a)
    % plot(x,as);
    % plot(x,as2);
    plot(x,am);

    tam = max(am)*p;
%     tam = am*p;
    plot(x,am-tam,'r--');
    plot(x,am+tam,'r--');

%     das = abs(a-as);
%     das2 = abs(a-as2);
    dam = a-am;
    adam = abs(dam);
    
    rdam = dam/max(am);
%     rdam = dam./am;
    ardam = abs(rdam);

    subplot(2,1,2)
    hold on
    % plot(x,das);
    % plot(x,das2);
    plot(x,rdam);
    yline(p,'r--');
    yline(-p,'r--');
    
    gtp = rdam>p;
    ltp = rdam<-p;
    xgtp = x(gtp);
    xltp = x(ltp);
    plot(xgtp,rdam(gtp),'rx','MarkerSize',10)
    plot(xltp,rdam(ltp),'rx','MarkerSize',10)

    [m,i] = max(ardam);

    if not(m>p) % the max we found is not outside tolerance
        break; % all the points are between the boundaries, no more defects
    end
    
    xline(i,'r')
    subplot(2,1,1)
    xline(i,'r')

%     pause
    if not(isKey(defects,i))
        if sign(rdam(i)) > 0
            defects(i) = ['Overshoot'];%  ' num2str(round(100*adam(i)/am(i))) '%'];
        else
            defects(i) = ['Undershoot'];% ' num2str(round(100*adam(i)/am(i))) '%'];
        end
    end
    a(i) = am(i);

end

subplot(2,1,1);
plot(x,a_orig);

for i = size(figs,2):-1:1
    figure(figs(i));
end

disp 'Effective defects:'
disp([effective_defects.keys', effective_defects.values'])

disp 'Anomalies detected on sensors:'
disp([defects.keys', defects.values'])
